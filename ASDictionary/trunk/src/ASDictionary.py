"""ASDictionary

(C) 2007-2009 HAS
"""

import os

import objc
from Foundation import NSUserDefaultsDidChangeNotification, NSBundle
from AppKit import *
from PyObjCTools.KeyValueCoding import *
from PyObjCTools import NibClassBuilder, AppHelper

import osax, mactypes, aemreceive
from osaterminology.makeglue.objcappscript import nametoprefix

import appscriptsupport, osaxfinder, dictionaryexporter


NibClassBuilder.extractClasses("MainMenu")


######################################################################
# support for read-only 'name' and 'version' properties # TO DO: use Cocoa Scripting?

class _AEOMApplication:
	def __init__(self, result):
		self._result = result
	
	def property(self, code):
		key = {'pnam': u'CFBundleDisplayName', 'vers': u'CFBundleShortVersionString'}[code]
		self._result['result'] = NSBundle.mainBundle().infoDictionary()[key]

class _AEOMResolver:
	def __init__(self, result):
		self.app = _AEOMApplication(result)

def handle_get(ref):
	try:
		result = {}
		ref.AEM_resolve(_AEOMResolver(result))
		return result['result']
	except:
		raise aemreceive.EventHandlerError(-1728)


######################################################################
# Cocoa Bindings stuff (required by part of the enable/disable logic for the Export button)

class ArrayToBooleanTransformer(NSValueTransformer):
	def transformedValue_(self, item):
		return bool(item)



######################################################################
# NSApplication delegate, model logic and window controllers
# TO DO: refactor this into separate classes

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
	# objcPrefixColumn
	
	def init(self):
		self = super(ASDictionary, self).init()
		if self is None: return
		self._selectedFiles = [] # {'obcPrefix': u'...', 'name': u'...', 'path': u'...'}
		self._canExport = False
		self._htmlOptionsEnabled = False
		self._itemName = u''
		self._progressBar = 0
		NSValueTransformer.setValueTransformer_forName_(
				ArrayToBooleanTransformer.alloc().init(), u"ArrayToBoolean")
		return self
	
	def applicationDidFinishLaunching_(self, sender):
		for m in [appscriptsupport, osaxfinder, dictionaryexporter]:
			m.init()
		self.standardAdditions = osax.OSAX()
		aemreceive.installeventhandler(handle_get,'coregetd', 
				('----', 'ref', aemreceive.kae.typeObjectSpecifier))

	
	def awakeFromNib(self):
		userDefaults = NSUserDefaults.standardUserDefaults()
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
		userDefaults = NSUserDefaults.standardUserDefaults()
		userDefaults.setObject_forKey_(list(self.logDrawer.contentSize()), u'LogDrawer')

	
	#######
	# Update enabled/disabled status of 'Export' window's checkboxes and 'Export' button when
	# chosen files list or preferences change
	
	def _updateLocks(self):
		userDefaults = NSUserDefaults.standardUserDefaults()
		self.setHtmlOptionsEnabled_(userDefaults.boolForKey_(u'singleHTML') or userDefaults.boolForKey_(u'frameHTML'))
		hasSelectedFiles = bool(self.selectedFiles())
		willExportDict = self.htmlOptionsEnabled() or userDefaults.boolForKey_(u'plainText')
		willExportGlue = userDefaults.boolForKey_(u'objcGlue')
		hasSelectedStyles = bool([name for name 
				in [u'applescriptStyle', u'pythonStyle', u'rubyStyle', u'objcStyle'] 
				if userDefaults.boolForKey_(name)])
		self.setCanExport_(hasSelectedFiles and 
				((willExportDict and hasSelectedStyles) or willExportGlue))
		try:
			self.objcPrefixColumn.setHidden_(not willExportGlue) # 10.5+
		except:
			pass
	
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
	
	def _addPathToSelectedFiles(self, path, isosax=False):
		name = os.path.splitext(os.path.basename(path.rstrip('/')))[0]
		item = {'objcPrefix': nametoprefix(name), 'name': name, 'path': path, 'isOSAX': isosax}
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
			self._addPathToSelectedFiles(alias.path, alias.path.lower().endswith('.osax'))
	
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
		from appscript import app # TO DO: use NSWorkspace
		sysev = app('System Events')
		names = sysev.application_processes.name()
		names.sort(lambda a, b: cmp(a.lower(), b.lower()))
		selection = self.standardAdditions.choose_from_list(
				names, 
				with_prompt='Choose one or more running applications:', 
				multiple_selections_allowed=True)
		if selection == False:
			return
		for name in selection:
			self._addPathToSelectedFiles(sysev.application_processes[name].file().path)
		
	
	def chooseInstalledAdditions_(self, sender):
		selection = self.standardAdditions.choose_from_list(osaxfinder.names(), 
				with_prompt='Choose one or more scripting additions:', multiple_selections_allowed=True)
		for name in selection or []:
			self._addPathToSelectedFiles(osaxfinder.pathforname(name), True)
	
	
	#######
	# 'Export' button method
	
	def writeToLogWindow(self, text):
		store = self.logTextView.textStorage()
		store.appendAttributedString_(NSAttributedString.alloc().initWithString_(text))
		self.logTextView.scrollRangeToVisible_([store.length(), 0])

	
	
	def export_(self, sender):
		userDefaults = NSUserDefaults.standardUserDefaults()
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
		plainText, singleHTML, frameHTML, objcGlue = [userDefaults.boolForKey_(name) 
				for name in [u'plainText', u'singleHTML', u'frameHTML', u'objcGlue']]
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
		dictionaryexporter.export(selection, styles, plainText, singleHTML, frameHTML, objcGlue, options, outFolder, exportToSubfolders, progressObj)
	
	
	def stopProcessing_(self, sender): # cancel button on progress panel
		NSApp().stopModalWithCode_(-128)
	
	def windowWillClose_(self, sender): # quit on main window close
		if sender.object() == self.mainWindow:
			NSApp().terminate_(sender)


######################################################################
# dictionaryexporter.export() takes GUIProgress instance when invoked from GUI

class GUIProgress:

	def __init__(self, itemcount, stylecount, formatcount, appcontroller):
		self._appcontroller = appcontroller
		self._subincrement = 1.0 / max(1, (stylecount * formatcount))
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
		userDefaults = NSUserDefaults.standardUserDefaults()
		# dispose progress panel
		self._appcontroller.progressPanel.orderOut_(None)
		NSApp().endModalSession_(self._session)
		self._appcontroller.writeToLogWindow(u'Done.\n\n\n')
		self._appcontroller.standardAdditions.beep()
		try:
			if self._faileditems:
				buttons = ['OK']
				if not userDefaults.boolForKey_(u'showLog'):
					buttons.insert(0, 'View Log')
				action = self._appcontroller.standardAdditions.display_dialog(
						"Rendered terminology for %i items.\n\n" % (self._maincount - len(self._faileditems))
						+ "Couldn't render terminology for: \n    " + '\n    '.join(self._faileditems), 
						buttons=buttons, default_button='OK', with_icon=osax.k.caution)[osax.k.button_returned]
				if action == 'View Log':
					userDefaults.setBool_forKey_(True, u'showLog')
			else:
				self._appcontroller.standardAdditions.display_dialog("Rendered terminology for %i items." % self._maincount, 
						buttons=['OK'], default_button=1, with_icon=osax.k.note)
		except CommandError, e: # ignore timeout errors from osax calls
			if int(e) != -1712:
				raise


#######

AppHelper.runEventLoop()

