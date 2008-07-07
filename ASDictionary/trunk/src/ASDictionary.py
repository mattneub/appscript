"""ASDictionary

(C) 2007 HAS
"""

__name__ = 'ASDictionary'
__version__ = '0.10.0'

import objc
from Foundation import NSUserDefaultsDidChangeNotification
from AppKit import *
from PyObjCTools.KeyValueCoding import *
from PyObjCTools import NibClassBuilder, AppHelper

import osax, appscript



import os, os.path

import mactypes

######################################################################
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


######################################################################
	
def namefrompath(path):
	if path.endswith('/'):
		path = path[:-1]
	name = os.path.basename(path)
	if name.lower().endswith('.app'):
		name = name[:-4]
	elif name.lower().endswith('.osax'):
		name = name[:-5]
	return name
		
######################################################################
# Main export function

from aem.ae import GetAppTerminology as getaete
from osaterminology.dom import aeteparser
from osaterminology.renderers import quickdoc, htmldoc, htmldoc2
from osaterminology.makeidentifier import getconverter

#######

kStyleToSuffix = {
		'applescript': '-AS',
		'py-appscript': '-py', 
		'rb-appscript': '-rb', 
		'objc-appscript': '-objc',
}


def _makeDestinationFolder(outFolder, styleSubfolderName, formatSubfolderName, fileName):
	destFolder = os.path.join(outFolder, styleSubfolderName, formatSubfolderName or '')
	if not os.path.exists(destFolder):
		os.makedirs(destFolder)
	return os.path.join(destFolder, fileName)


def _export(items, styles, plainText, singleHTML, frameHTML, options, outFolder, exportToSubfolders, progress):
	styleInfo = [(style, kStyleToSuffix[style]) for style in styles]
	# process each item
	for i, item in enumerate(items):
		name, path = item['name'], item['path']
		progress.nextitem(name, path)
		try:
			aetes = getaete(path)
			if not bool(aetes):
				progress.didfail(u"No terminology found.")
				continue
			for style, suffix in styleInfo:
				styleSubfolderName = exportToSubfolders and style or ''
				if not progress.shouldcontinue():
					for item in items[i:]:
						progress.didfail(u"User cancelled.")
						progress.nextapp(item['name'], item['path'])
					progress.didfail(u"User cancelled.")
					progress.didfinish()
					return
				if plainText:
					outputPath = _makeDestinationFolder(outFolder, styleSubfolderName, 
							exportToSubfolders and 'text', name + suffix + '.txt')
					progress.nextoutput(u'%s' % outputPath)
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
						outputPath = _makeDestinationFolder(outFolder, styleSubfolderName, 
								exportToSubfolders and 'html', name + suffix + '.html')
						progress.nextoutput(u'%s' % outputPath)
						html = htmldoc.renderdictionary(terms, style, options)
						f = open(outputPath, 'w')
						f.write(str(html))
						f.close()
					if frameHTML:
						outputPath = _makeDestinationFolder(outFolder, styleSubfolderName, 
								exportToSubfolders and 'frame-html', name + suffix)
						progress.nextoutput(u'%s' % outputPath)
						htmldoc2.renderdictionary(terms, outputPath, style, options)
		except Exception, err:
			from traceback import print_exc
			from StringIO import StringIO
			out = StringIO()
			print_exc(file=out)
			progress.didfail(u'Unexpected error:/n%s' % out.getvalue())
		else:
			progress.didsucceed()
	return progress.didfinish()


######################################################################
# Install 'export dictionaries' event handler

kPlainText = 'PTex'
kSingleHTML = 'SHTM'
kFrameHTML = 'FHTM'
kASStyle = 'AScr'
kPyStyle = 'PyAp'
kRbStyle = 'RbAp'
kObjCStyle = 'OCAp'

kAECodeToStyle = {
	kASStyle: 'applescript',
	kPyStyle: 'py-appscript',
	kRbStyle: 'rb-appscript',
	kObjCStyle: 'objc-appscript',
}

class AEProgress:

	kClassKey = AEType('pcls')
	kClassValue = AEType('ExpR')
	#kNameKey = AEType('pnam')
	kSuccessKey = AEType('Succ')
	kSourceKey = AEType('Sour')
	kDestKey = AEType('Dest')
	kErrorKey = AEType('ErrS')
	kMissingValue = AEType('msng')

	def __init__(self, itemcount, stylecount, formatcount, controller):
		self._results = []

	def shouldcontinue(self):
		return True
		
	def nextitem(self, name, inpath):
		self._results.append({
				self.kClassKey:self.kClassValue,
				#self.kNameKey:name, 
				self.kSourceKey:mactypes.File(inpath)})
	
	def nextoutput(self, outpath):
		self._results[-1][self.kDestKey] = mactypes.File(outpath)
		
	def didsucceed(self):
		self._results[-1][self.kSuccessKey] = True
		self._results[-1][self.kErrorKey] = self.kMissingValue
		
	def didfail(self, errormessage):
		self._results[-1][self.kSuccessKey] = False
		self._results[-1][self.kDestKey] = self.kMissingValue
		self._results[-1][self.kErrorKey] = errormessage
	
	def didfinish(self):
		return self._results


def exportdictionaries(sources, outfolder, 
		fileformats=[AEEnum(kFrameHTML)], styles=[AEEnum(kASStyle)],
		compactclasses=False, showinvisibles=False, usesubfolders=False):
	items = [{'name': namefrompath(alias.path), 'path': alias.path} for alias in sources]
	outfolder = outfolder.path
	plaintext = AEEnum(kPlainText) in fileformats
	singlehtml = AEEnum(kSingleHTML) in fileformats
	framehtml = AEEnum(kFrameHTML) in fileformats
	styles = [kAECodeToStyle[o.code] for o in styles]
	options = []
	if compactclasses:
		options.append('collapse')
	if showinvisibles:
		options.append('full')
	progressobj = AEProgress(len(items), len(styles), len(fileformats), None)
	return _export(items, styles, plaintext, singlehtml, framehtml, options, outfolder, usesubfolders, progressobj)

installeventhandler(exportdictionaries,
		'ASDiExpD',
		('----', 'sources', ArgListOf(kAE.typeAlias)),
		('ToFo', 'outfolder', kAE.typeAlias),
		('Form', 'fileformats', ArgListOf(ArgEnum(kPlainText, kSingleHTML, kFrameHTML))),
		('Styl', 'styles', ArgListOf(ArgEnum(kASStyle, kPyStyle, kRbStyle, kObjCStyle))),
		('ClaC', 'compactclasses', kAE.typeBoolean),
		('SInv', 'showinvisibles', kAE.typeBoolean),
		('SubF', 'usesubfolders', kAE.typeBoolean))



######################################################################
# Import remaining dependencies


######################################################################

NibClassBuilder.extractClasses("MainMenu")

userDefaults = NSUserDefaults.standardUserDefaults()

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


######################################################################
# Functions for locating installed osaxen by name

_osaxcache = None

def _osaxInfo():
	global _osaxcache
	if _osaxcache is None:
		_osaxcache = {}
		for domain in [_sysev.system_domain, _sysev.local_domain, _sysev.user_domain]:
			osaxen = domain.scripting_additions_folder.files[appscript.its.visible == True]
			if osaxen.name.exists():
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


######################################################################
# Cocoa Bindings stuff (required by part of the enable/disable logic for the Export button)

class ArrayToBooleanTransformer(NSValueTransformer):
	def transformedValue_(self, item):
		return bool(item)

NSValueTransformer.setValueTransformer_forName_(
		ArrayToBooleanTransformer.alloc().init(), u"ArrayToBoolean")


######################################################################
# NSApplication delegate, model logic and window controllers
# Bit unwieldy this; would be good to move log drawer and progress dialog
# controller logic into their own classes at some point, but it works ok for now.

class ASDictionary(NibClassBuilder.AutoBaseClass):
	# Outlets:
	# mainWindow
	# filenameTableView
	# selectedFilesController
	# progressPanel
	# progressBar
	# itemName
	# logDrawer
	# logTextView
	
	def init(self):
		self = super(ASDictionary, self).init()
		if self is None: return
		self._selectedFiles = [] # {'name': u'...', 'path': u'...'}
		self._canExport = False
		self._htmlOptionsEnabled = False
		self._itemName = u''
		self._progressBar = 0
		# Connect to StandardAdditions (see note at top of script)
		self.standardAdditions = osax.ScriptingAddition()
		return self
		
	
	def awakeFromNib(self):
		NSNotificationCenter.defaultCenter().addObserver_selector_name_object_(
				self, 'notifyPreferencesChanged:', NSUserDefaultsDidChangeNotification, userDefaults)
		self._updateLocks()
		self.filenameTableView.registerForDraggedTypes_([NSFilenamesPboardType])
		self.filenameTableView.setDraggingSourceOperationMask_forLocal_(NSDragOperationLink, False)
		self.mainWindow.setFrameAutosaveName_(u'ExportWindow')
		self.logDrawer.setContentSize_(userDefaults.arrayForKey_(u'LogDrawer') or self.logDrawer.contentSize())
		self.selectedFilesController.setSortDescriptors_([
				NSSortDescriptor.alloc().initWithKey_ascending_selector_(u'name', True, 'caseInsensitiveCompare:'),
				NSSortDescriptor.alloc().initWithKey_ascending_selector_(u'path', True, 'caseInsensitiveCompare:')])
	
	
	def applicationWillTerminate_(self, notification):
		userDefaults.setObject_forKey_(list(self.logDrawer.contentSize()), u'LogDrawer')

	
	#######
	# Update enabled/disabled status of 'Export' window's checkboxes and 'Export' button when
	# chosen files list or preferences change
	
	def _updateLocks(self):
		self.setHtmlOptionsEnabled_(userDefaults.boolForKey_(u'singleHTML') or userDefaults.boolForKey_(u'frameHTML'))
		self.setCanExport_(bool(self.selectedFiles()) 
				and (self.htmlOptionsEnabled() or userDefaults.boolForKey_(u'plainText'))
				and bool([1 for name in [u'applescriptStyle', u'pythonStyle', u'rubyStyle', u'objcStyle'] if userDefaults.boolForKey_(name)]))
	
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
	# show/hide export log drawer
	
	def showLog_(self, sender):
		pass
	
	
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
		item = {'name': namefrompath(path), 'path': path}
		if item not in self.selectedFiles():
			self.insertObject_inSelectedFilesAtIndex_(item, self.countOfSelectedFiles())
		self._updateLocks()
	
	##
	
	def chooseFromFileBrowser_(self, sender):
		try:
			selection = self.standardAdditions.choose_file(with_prompt='Select the item(s) to process:', 
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
			selection = self.standardAdditions.choose_application(
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
		selection = self.standardAdditions.choose_from_list(
				names, 
				with_prompt='Choose one or more running applications:', 
				multiple_selections_allowed=True)
		if selection == False:
			return
		for name in selection:
			self._addPathToSelectedFiles(_sysev.application_processes[name].file().path)
		
	
	def chooseInstalledAdditions_(self, sender):
		selection = self.standardAdditions.choose_from_list(
				osaxNames(), 
				with_prompt='Choose one or more scripting additions:', 
				multiple_selections_allowed=True)
		if selection == False:
			return
		for name in selection:
			self._addPathToSelectedFiles(osaxPathForName(name))
	
	
	#######
	# 'Export' button method
	
	def writeToLogWindow(self, text):
		store = self.logTextView.textStorage()
		store.appendAttributedString_(NSAttributedString.alloc().initWithString_(text))
		self.logTextView.scrollRangeToVisible_([store.length(), 0])

	
	
	def export_(self, sender):
		try:
			outFolder = self.standardAdditions.choose_folder('Select the destination folder:').path
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
		styles = [style for key, style in [
				(u'applescriptStyle', 'applescript'),
				(u'pythonStyle', 'py-appscript'),
				(u'rubyStyle', 'rb-appscript'),
				(u'objcStyle', 'objc-appscript')] if userDefaults.boolForKey_(key)]
		exportToSubfolders = userDefaults.boolForKey_(u'exportToSubfolders')
		# files to process, sorted by name
		selection = self.selectedFiles()[:]
		selection.sort(lambda a,b:cmp(a['name'].lower(), b['name'].lower()))
		progressObj = GUIProgress(len(selection), len(styles), len([i for i in [plainText, singleHTML, frameHTML] if i]), self)
		_export(selection, styles, plainText, singleHTML, frameHTML, options, outFolder, exportToSubfolders, progressObj)
	
	
	def stopProcessing_(self, sender): # cancel button on progress panel
		NSApp().stopModalWithCode_(-128)
	
	def windowWillClose_(self, sender): # quit on main window close
		NSApp().terminate_(sender)


######################################################################
# Main _export method takes an instance of this or AEProgress class, depending on
# whether it's invoked by GUI or Apple event handler.

class GUIProgress:

	def __init__(self, itemcount, stylecount, formatcount, appcontroller):
		self._appcontroller = appcontroller
		self._subincrement = 1.0 / (stylecount * formatcount)
		self._maincount = 0
		self._faileditems = []
		# create progress panel
		appcontroller.itemName.setStringValue_('Now processing...')
		appcontroller.progressBar.setMaxValue_(itemcount)
		appcontroller.progressBar.setDoubleValue_(0)
		appcontroller.progressPanel.center()
		appcontroller.progressPanel.makeKeyAndOrderFront_(None)
		appcontroller.progressPanel.display()
		self._session = NSApp().beginModalSessionForWindow_(appcontroller.progressPanel)
	
	def shouldcontinue(self):
		return NSApp().runModalSession_(self._session) == NSRunContinuesResponse
	
	def nextitem(self, name, inpath):
		self._itemname = name
		self._subcount = 0
		self._maincount += 1
		self._appcontroller.writeToLogWindow(u'Exporting %s dictionary...\n' % name)
		self._appcontroller.itemName.setStringValue_(name)
		self._appcontroller.progressBar.setDoubleValue_(self._maincount - 1)
	
	def nextoutput(self, outpath):
		self._subcount += self._subincrement
		self._appcontroller.writeToLogWindow(u'%s\n' % outpath)
		self._appcontroller.progressBar.setDoubleValue_(self._maincount - 1 + self._subcount)
	
	def didsucceed(self):
		self._appcontroller.writeToLogWindow(u'\n')

	def didfail(self, errormessage):
		self._faileditems.append(self._itemname)
		self._appcontroller.writeToLogWindow(u'%s\n\n' % errormessage)

	def didfinish(self):
		# dispose progress panel
		self._appcontroller.progressPanel.orderOut_(None)
		NSApp().endModalSession_(self._session)
		self._appcontroller.writeToLogWindow(u'Done.\n\n\n')
		self._appcontroller.standardAdditions.beep()
		if self._faileditems:
			buttons = ['OK']
			if not userDefaults.boolForKey_(u'showLog'):
				buttons.insert(0, 'View Log')
			action = self._appcontroller.standardAdditions.display_dialog("Rendered terminology for %i items.\n\n" % (self._maincount - len(self._faileditems))
					+ "Couldn't render terminology for: \n    " + '\n    '.join(self._faileditems), 
					buttons=buttons, default_button='OK', with_icon=osax.k.caution)[osax.k.button_returned]
			if action == 'View Log':
				userDefaults.setBool_forKey_(True, u'showLog')
		else:
			self._appcontroller.standardAdditions.display_dialog("Rendered terminology for %i items." % self._maincount, 
					buttons=['OK'], default_button=1, with_icon=osax.k.note)


#######

AppHelper.runEventLoop()

