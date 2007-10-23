"""ASDictionary

(C) 2007 HAS
"""

__name__ = 'ASDictionary'
__version__ = '0.9.0'


#######
# Initialise support for appscript help system and asdict tool

import appscriptsupport, asdictsupport

# Initialise support for read-only 'name' and 'version' properties

from aemreceive import *

class _AEOMApplication:
	def __init__(self, result):
		self._result = result
	
	def property(self, code):
		self._result['result'] = unicode({'pnam': __name__, 'vers': __version__}[code])


class _AEOMResolver:
	def __init__(self, result):
		self.app = _AEOMApplication(result)


def getd(ref):
	try:
		result = {}
		ref.AEM_resolve(_AEOMResolver(result))
		return result['result']
	except:
		raise EventHandlerError(-1728)
installeventhandler(
		getd,
		'coregetd',
		('----', 'ref', kAE.typeObjectSpecifier)
		)


#######

import objc
from Foundation import NSUserDefaultsDidChangeNotification
from AppKit import *
from PyObjCTools.KeyValueCoding import *
from PyObjCTools import NibClassBuilder, AppHelper

import os, os.path

import osax, appscript

from osaterminology.getterminology import getaete
from osaterminology.dom import aeteparser
from osaterminology.renderers import quickdoc, htmldoc, htmldoc2
from osaterminology.makeidentifier import getconverter

#######

NibClassBuilder.extractClasses("MainMenu")

userDefaults = NSUserDefaults.standardUserDefaults()


#######

# OS X bug workaround note: 
# OSATerminology.so functions should not be called before main event loop
# is started, otherwise it triggers strange behaviour where minimised windows
# refuse to expand when clicked on in Dock. (This is a Cocoa/Carbon issue.)
# Since osax.ScriptingAddition constructor calls osaterminology.getterminology.getaete
# (which in turn calls OSATerminology.OSAGetAppTerminology), it should not be
# called here (ie. at top level of script).
#
# OTOH, appscript uses ascrgdte event to retrieve terminology, so app objects can
# safely be created and used at top level of script.

_sysev = appscript.app('System Events')

#######

_styles = [ # (prefs key, osaterminology name, filename suffix)
		(u'applescriptStyle', 'applescript', '-AS'),
		(u'pythonStyle', 'py-appscript', '-py'), 
		(u'rubyStyle', 'rb-appscript', '-rb'), 
		(u'objcStyle', 'objc-appscript', '-objc'),
]

#######

def _namefrompath(path):
	if path.endswith('/'):
		path = path[:-1]
	name = os.path.basename(path)
	if name.lower().endswith('.app'):
		name = name[:-4]
	elif name.lower().endswith('.osax'):
		name = name[:-5]
	return name

#######

class NoTerminologyError(Exception):
	pass

_osaxcache = None

def _osaxInfo():
	global _osaxcache
	if _osaxcache is None:
		_osaxcache = {}
		for domain in [_sysev.system_domain, _sysev.local_domain, _sysev.user_domain]:
			osaxen = domain.scripting_additions_folder.files[appscript.its.visible == True]
			for name, path in zip(osaxen.name(), osaxen.POSIX_path()):
				if name.lower().endswith('.osax'):
					name = name[:-5]
				elif name.lower().endswith('.app'):
					name = name[:-4]
				if not _osaxcache.has_key(name.lower()):
					_osaxcache[name] = path
	return _osaxcache

def osaxNames():
	names = _osaxInfo().keys()
	names.sort(lambda a,b:cmp(a.lower(), b.lower()))
	return names

def osaxPathForName(name):
	return _osaxInfo()[name]


#######

class ArrayToBooleanTransformer(NSValueTransformer):
	def transformedValue_(self, item):
		return bool(item)

NSValueTransformer.setValueTransformer_forName_(
		ArrayToBooleanTransformer.alloc().init(), u"ArrayToBoolean")


#######


class ASDictionary(NibClassBuilder.AutoBaseClass):
	# Outlets:
	# mainWindow
	# filenameTableView
	# selectedFilesController
	# progressPanel
	# progressBar
	# itemName
	# logTextView
	
	def init(self):
		self = super(ASDictionary, self).init()
		if self is None: return
		self._selectedFiles = [] # {'name': u'...', 'path': u'...'}
		self._canExport = False
		self._htmlOptionsEnabled = False
		self._itemName = u''
		self._progressBar = 0
		self._showLog = False
		# Connect to StandardAdditions (see note at top of script)
		self._stdadditions = osax.ScriptingAddition()
		return self
		
	
	def awakeFromNib(self):
		NSNotificationCenter.defaultCenter().addObserver_selector_name_object_(
				self, 'notifyPreferencesChanged:', NSUserDefaultsDidChangeNotification, userDefaults)
		self._updateLocks()
		self.filenameTableView.registerForDraggedTypes_([NSFilenamesPboardType])
		self.filenameTableView.setDraggingSourceOperationMask_forLocal_(NSDragOperationLink, False)
		self._windowController = NSWindowController.alloc().initWithWindow_(self.mainWindow)
		self._windowController.setWindowFrameAutosaveName_(u'ExportWindow')
		self.selectedFilesController.setSortDescriptors_([
				NSSortDescriptor.alloc().initWithKey_ascending_selector_(u'name', True, 'caseInsensitiveCompare:'),
				NSSortDescriptor.alloc().initWithKey_ascending_selector_(u'path', True, 'caseInsensitiveCompare:')])
	
	
	#######
	# Update enabled/disabled status of 'Export' window's checkboxes and 'Export' button when
	# chosen files list or preferences change
	
	def _updateLocks(self):
		self.setHtmlOptionsEnabled_(userDefaults.boolForKey_(u'singleHTML') or userDefaults.boolForKey_(u'frameHTML'))
		self.setCanExport_(bool(self.selectedFiles())
				and (self.htmlOptionsEnabled() or userDefaults.boolForKey_(u'plainText'))
				and (userDefaults.boolForKey_(u'applescriptStyle') or userDefaults.boolForKey_(u'pythonStyle')
						or userDefaults.boolForKey_(u'rubyStyle') or userDefaults.boolForKey_(u'objcStyle')))
	
	def notifyPreferencesChanged_(self, sender):
		self._updateLocks()
	
	
	#######
	# delete items in files list
	
	def delete_(self, sender):
		self.selectedFilesController.removeObjects_(self.selectedFilesController.selectedObjects())
		self._updateLocks()
	
	def clear_(self, sender):
		self.selectedFilesController.removeObjects_(self.selectedFilesController.content())
		self._updateLocks()
	
	
	#######
	# drag-n-drop support
	
	def application_openFile_(self, application, filename):
		self._addPathToSelectedFiles(filename)
		return True
	
	def tableView_validateDrop_proposedRow_proposedDropOperation_(self, tableView, info, row, operation):
		return NSDragOperationLink
	
	def tableView_acceptDrop_row_dropOperation_(self, tableView, info, row, operation):
		for path in info.draggingPasteboard().propertyListForType_(NSFilenamesPboardType):
			self._addPathToSelectedFiles(path)
		return True
	
	
	#######
	# show/hide export log drawer bindings
	
	def showLog_(self, sender):
		pass
	
	def showLog(self):
		return self._showLog
	
	def setShowLog_(self, value):
		self._showLog = value
	
	
	#######
	# files list controller bindings
	
	def selectedFiles(self):
		return self._selectedFiles

	def setSelectedFiles_(self, selectedFiles):
		self._selectedFiles = selectedFiles[:]

	def countOfSelectedFiles(self):
		return len(self._selectedFiles)
	countOfSelectedFiles = objc.accessor(countOfSelectedFiles)
	
	def objectInSelectedFilesAtIndex_(self, idx):
		return self._selectedFiles[idx]
	objectInSelectedFilesAtIndex_ = objc.accessor(objectInSelectedFilesAtIndex_)
	
	def insertObject_inSelectedFilesAtIndex_(self, obj, idx):
		self._selectedFiles.insert(idx, obj)
	insertObject_inSelectedFilesAtIndex_ = objc.accessor(insertObject_inSelectedFilesAtIndex_)

	def removeObjectFromSelectedFilesAtIndex_(self, idx):
		del self._selectedFiles[idx]
	removeObjectFromSelectedFilesAtIndex_ = objc.accessor(removeObjectFromSelectedFilesAtIndex_)
	
	def replaceObjectInSelectedFilesAtIndex_withObject_(self, idx, obj):
		self._selectedFiles[idx] = obj
	replaceObjectInSelectedFilesAtIndex_withObject_ = objc.accessor(replaceObjectInSelectedFilesAtIndex_withObject_)
	
	
	#######
	# 'Export' window checkbox bindings
	
	def canExport(self):
		return self._canExport
	
	def setCanExport_(self, value):
		self._canExport = value
	
	def htmlOptionsEnabled(self):
		return self._htmlOptionsEnabled
	
	def setHtmlOptionsEnabled_(self, value):
		self._htmlOptionsEnabled = value
	
	
	#######
	# 'Dictionary' menu methods
	
	def _addPathToSelectedFiles(self, path):
		item = {'name': _namefrompath(path), 'path': path}
		if item not in self.selectedFiles():
			self.insertObject_inSelectedFilesAtIndex_(item, self.countOfSelectedFiles())
		self._updateLocks()
	
	def chooseFromFileBrowser_(self, sender):
		try:
			selection = self._stdadditions.choose_file(with_prompt='Select the item(s) to process:', 
					invisibles=False, multiple_selections_allowed=True)
		except osax.CommandError, e:
			if int(e) == -128:
				return
			else:
				raise
		for alias in selection:
			self._addPathToSelectedFiles(alias.path)
	
	def chooseFromApplicationList_(self, sender):
		try:
			selection = self._stdadditions.choose_application(
					with_prompt='Select the application(s) to process:', 
					multiple_selections_allowed=True, as_=osax.k.alias)
		except osax.CommandError, e:
			if int(e) == -128:
				return
			else:
				raise
		for alias in selection:
			self._addPathToSelectedFiles(alias.path)
	
	def chooseRunningApplications_(self, sender):
		names = _sysev.application_processes.name()
		names.sort(lambda a, b: cmp(a.lower(), b.lower()))
		selection = self._stdadditions.choose_from_list(
				names, 
				with_prompt='Choose one or more running applications:', 
				multiple_selections_allowed=True)
		if selection == False:
			return
		for name in selection:
			self._addPathToSelectedFiles(_sysev.application_processes[name].file().path)
		
	
	def chooseInstalledAdditions_(self, sender):
		selection = self._stdadditions.choose_from_list(
				osaxNames(), 
				with_prompt='Choose one or more scripting additions:', 
				multiple_selections_allowed=True)
		if selection == False:
			return
		for name in selection:
			self._addPathToSelectedFiles(osaxPathForName(name))
	
	
	#######
	# 'Export' button method
	
	def _log(self, text):
		store = self.logTextView.textStorage()
		store.appendAttributedString_(NSAttributedString.alloc().initWithString_(text))
		self.logTextView.scrollRangeToVisible_([store.length(), 0])
	
	def _makeDestinationFolder(self, outFolder, styleSubfolderName, formatSubfolderName, fileName):
		destFolder = os.path.join(outFolder, styleSubfolderName, formatSubfolderName or '')
		if not os.path.exists(destFolder):
			os.makedirs(destFolder)
		return os.path.join(destFolder, fileName)

	
	
	def export_(self, sender):
		try:
			outFolder = self._stdadditions.choose_folder('Select the destination folder:').path
		except osax.CommandError, e:
			if int(e) == -128:
				return
			else:
				raise
		# HTML options
		options = []
		if userDefaults.boolForKey_(u'compactClasses'):
			options.append('collapse')
		if userDefaults.boolForKey_(u'showInvisibles'):
			options.append('full')
		plainText, singleHTML, frameHTML = [userDefaults.boolForKey_(name) 
				for name in [u'plainText', u'singleHTML', u'frameHTML']]
		styleInfo = [(style, suffix) for key, style, suffix in _styles if userDefaults.boolForKey_(key)]
		exportToSubfolders = userDefaults.boolForKey_(u'exportToSubfolders')
		# files to process, sorted by name
		selection = self.selectedFiles()[:]
		selection.sort(lambda a,b:cmp(a['name'].lower(), b['name'].lower()))
		# create progress panel
		self.itemName.setStringValue_(selection[0]['name'])
		self.progressBar.setDoubleValue_(0)
		self.progressPanel.center()
		self.progressPanel.makeKeyAndOrderFront_(None)
		self.progressPanel.display()
		failedApps = []
		session = NSApp().beginModalSessionForWindow_(self.progressPanel)
		# process each item
		stop = False
		incrementSize = 1.0 / (len([i for i in [plainText, singleHTML, frameHTML] if i]) * len(styleInfo))
		for i, item in enumerate(selection):
			name, path = item['name'], item['path']
			self._log(u'Exporting %s:\n' % name)
			self.itemName.setStringValue_(name)
			progress = 0
			try:
				aetes = getaete(path)
				if not bool(aetes):
					failedApps.append(name)
					self._log(u'\tNo terminology found.\n')
					continue
				for style, suffix in styleInfo:
					styleSubfolderName = exportToSubfolders and style or ''
					if NSApp().runModalSession_(session) != NSRunContinuesResponse:
						for j in range(i, len(selection)):
							failedApps.append(selection[j]['name'])
						self._log(u"User cancelled.\n")
						stop = True
						break
					self._log(u'\t%s\n' % style)
					if plainText:
						outputPath = self._makeDestinationFolder(outFolder, styleSubfolderName, 
								exportToSubfolders and 'text', name + suffix + '.txt')
						progress += incrementSize
						self.progressBar.setDoubleValue_(float(i + progress) / len(selection))
						self._log(u'\t\t(plain text) %s\n' % outputPath)
						f = file(outputPath, 'w')
						try:
							f.write('\xEF\xBB\xBF') # UTF8 BOM
							quickdoc.app(path, f, getconverter(style))
						except:
							f.close()
							raise
						f.close()
					if singleHTML or frameHTML:
						terms = aeteparser.parseaetes(aetes, path, style)
						if singleHTML:
							outputPath = self._makeDestinationFolder(outFolder, styleSubfolderName, 
									exportToSubfolders and 'html', name + suffix + '.html')
							progress += incrementSize
							self.progressBar.setDoubleValue_(float(i + progress) / len(selection))
							self._log(u'\t\t(HTML single file) %s\n' % outputPath)
							html = htmldoc.renderdictionary(terms, style, options)
							f = open(outputPath, 'w')
							f.write(str(html))
							f.close()
						if frameHTML:
							outputPath = self._makeDestinationFolder(outFolder, styleSubfolderName, 
									exportToSubfolders and 'frame-html', name + suffix)
							progress += incrementSize
							self.progressBar.setDoubleValue_(float(i + progress) / len(selection))
							self._log(u'\t\t(HTML frames) %s\n' % outputPath)
							htmldoc2.renderdictionary(terms, outputPath, style, options)
				if stop:
					break
			except Exception, err:
				failedApps.append(name)
				from traceback import print_exc
				from StringIO import StringIO
				out = StringIO()
				self._log(u"Unexpected error:/n")
				print_exc(file=out)
				self._log(u'%s' % out.getvalue())
		# dispose progress panel
		self.progressPanel.orderOut_(None)
		NSApp().endModalSession_(session)
		self._log(u'Done.\n\n')
		self._stdadditions.beep()
		if failedApps:
			buttons = ['OK']
			if not self._showLog:
				buttons.insert(0, 'View Log')
			action = self._stdadditions.display_dialog("Rendered terminology for %i items.\n\n" % (len(selection) - len(failedApps))
					+ "Couldn't render terminology for: \n    " + '\n    '.join(failedApps), 
					buttons=buttons, default_button='OK', with_icon=osax.k.caution)[osax.k.button_returned]
			if action == 'View Log':
				self.setShowLog_(True)
		else:
			self._stdadditions.display_dialog("Rendered terminology for %i items." % len(selection), 
					buttons=['OK'], default_button=1, with_icon=osax.k.note)
	
	def stopProcessing_(self, sender): # cancel button on progress panel
		NSApp().stopModalWithCode_(-128)
	
	def windowWillClose_(self, sender): # quit on main window close
		NSApp().terminate_(sender)
		
	
#######

AppHelper.runEventLoop()

