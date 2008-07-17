"""ASTranslate"""

import AppKit
from PyObjCTools import NibClassBuilder, AppHelper
from Foundation import NSUserDefaults

import MacOS

import osascript, aem

import eventformatter
import rubyrenderer, objcrenderer


NibClassBuilder.extractClasses("MainMenu")
NibClassBuilder.extractClasses("ASTranslateDocument")

_ci = osascript.Interpreter()


#######

_userDefaults = NSUserDefaults.standardUserDefaults()

if not _userDefaults.integerForKey_(u'defaultOutputLanguage'):
	_userDefaults.setInteger_forKey_(0, u'defaultOutputLanguage')



#######

class ASApplicationDelegate(NibClassBuilder.AutoBaseClass):
	pass


#######

class ASTranslateDocument(NibClassBuilder.AutoBaseClass): # (NSDocument)
	# Outlets:
	# codeView
	# resultView
	# styleControl
	
	_script = None # an osascript.Script instance
	
	currentStyle = 0

#	import osax; osax.ScriptingAddition().display_dialog('add to all %r'%val)
	
	def _addResult(self, kind, val):
		if kind == eventformatter.kAll:
			for lang in self._resultStores:
				lang.append(val)
		else:
			self._resultStores[kind].append(val)
		if kind == self.currentStyle or kind == eventformatter.kAll:
			self.resultView.textStorage().appendAttributedString_(
				AppKit.NSAttributedString.alloc().initWithString_(u'%s\n\n' % self._resultStores[self.currentStyle][-1]))
	
	
	def windowNibName(self): # a default NSWindowController is created automatically
		return "ASTranslateDocument"

	def windowControllerDidLoadNib_(self, controller):
		self._resultStores = [[] for _ in range(eventformatter.kLanguageCount)]
		self._script = _ci.newscript()
		self._script.setruncallbacks(send=eventformatter.makeCustomSendProc(
				self._addResult, _ci.componentcallbacks()[2]))
		self.currentStyle = _userDefaults.integerForKey_(u'defaultOutputLanguage')
	
	def runScript_(self, sender):
		self.resultView.setString_(u'')
		for lang in self._resultStores:
			while lang:
				lang.pop()
		try:
			errorKind = 'Compilation'
			self.codeView.setString_(self._script.compile(self.codeView.string()))
			errorKind = 'Runtime'
			self._script.run()
			self._addResult(eventformatter.kAll, u'Done.')
		except osascript.ScriptError, e:
			start, end = e.range
			self.codeView.setSelectedRange_((start, end - start))
			errstr = u'%s Error:\n%s (%i)' % (errorKind, e.message, e.number)
			self._addResult(eventformatter.kAll, errstr)
		except (aem.ae.MacOSError, MacOS.Error), e:
			errstr = u'%s Error: %i' % (errorKind, e.args[0])
			self._addResult(eventformatter.kAll, errstr)
			
	
	def selectStyle_(self, sender):
		self.resultView.setString_(u'\n\n'.join(self._resultStores[self.currentStyle]))
		_userDefaults.setInteger_forKey_(self.currentStyle, u'defaultOutputLanguage')
	
	def isDocumentEdited(self):
		return False

#######


AppHelper.runEventLoop()

