""" ASTranslate -- render Apple events sent by AppleScript in appscript syntax """

from AppKit import *
import objc
from PyObjCTools import AppHelper

import aem

import astranslate, eventformatter
from constants import *


#######

_userDefaults = NSUserDefaults.standardUserDefaults()

if not _userDefaults.integerForKey_(u'defaultOutputLanguage'):
	_userDefaults.setInteger_forKey_(0, u'defaultOutputLanguage')

_standardCodecs = aem.Codecs()


#######

class ASTranslateDocument(NSDocument):
	
	codeView = objc.IBOutlet()
	resultView = objc.IBOutlet()
	styleControl = objc.IBOutlet()
		
	currentStyle = 0

#	import osax; osax.ScriptingAddition().display_dialog('add to all %r'%val)
	
	def _addResult(self, kind, val):
		if kind == kLangAll:
			for lang in self._resultStores:
				lang.append(val)
		else:
			self._resultStores[kind].append(val)
		if kind == self.currentStyle or kind == kLangAll:
			self.resultView.textStorage().appendAttributedString_(
				NSAttributedString.alloc().initWithString_(u'%s\n\n' % self._resultStores[self.currentStyle][-1]))
	
	
	def windowNibName(self): # a default NSWindowController is created automatically
		return "ASTranslateDocument"

	def windowControllerDidLoadNib_(self, controller):
		self._resultStores = [[] for _ in range(eventformatter.kLanguageCount)]
		self.currentStyle = _userDefaults.integerForKey_(u'defaultOutputLanguage')
	
	@objc.IBAction
	def runScript_(self, sender):
		self.resultView.setString_(u'')
		for lang in self._resultStores:
			while lang:
				lang.pop()
		try:
			sourceDesc = _standardCodecs.pack(self.codeView.string())
			handler = eventformatter.makeCustomSendProc(
					self._addResult, _userDefaults.boolForKey_('sendEvents'))
			result = astranslate.translate(sourceDesc, handler) # returns tuple; first item indicates if ok
			if result[0]: # script result
				script, result = (_standardCodecs.unpack(desc) for desc in result[1:])
				self.codeView.setString_(script)
				self._addResult(kLangAll, u'OK')
			else: # script error info
				script, errorNum, errorMsg, pos = (_standardCodecs.unpack(desc) for desc in result[1:])
				start, end = (pos[aem.AEType(k)] for k in ['srcs', 'srce'])
				if script:
					errorKind = 'Runtime'
					self.codeView.setString_(script)
				else:
					errorKind = 'Compilation'
				self._addResult(kLangAll, 
						u'%s Error:\n%s (%i)' % (errorKind, errorMsg, errorNum))
				self.codeView.setSelectedRange_((start, end - start))
		except aem.ae.MacOSError, e:
			self._addResult(kLangAll, u'OS Error: %i' % e.args[0])
	
	@objc.IBAction
	def selectStyle_(self, sender):
		self.resultView.setString_(u'\n\n'.join(self._resultStores[self.currentStyle]))
		_userDefaults.setInteger_forKey_(self.currentStyle, u'defaultOutputLanguage')
	
	def isDocumentEdited(self):
		return False


#######

AppHelper.runEventLoop()

