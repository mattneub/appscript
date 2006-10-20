"""ASTranslate"""

import AppKit
from PyObjCTools import NibClassBuilder, AppHelper

import osascript

import eventformatter


NibClassBuilder.extractClasses("ASTranslateDocument")

_ci = osascript.Interpreter()	

class ASTranslateDocument(NibClassBuilder.AutoBaseClass): # (NSDocument)
	# Outlets:
	# codeView
	# resultView
	
	_script = None # an osascript.Script instance
	
	def _appendResult(self, s):
		self.resultView.textStorage().appendAttributedString_(AppKit.NSAttributedString.alloc().initWithString_(u'%s\n\n' % s))

	def windowNibName(self): # a default NSWindowController is created automatically
		return "ASTranslateDocument"

	def windowControllerDidLoadNib_(self, controller):
		self._script = _ci.newscript()
		self._script.setruncallbacks(send=eventformatter.makeCustomSendProc(self._appendResult, _ci.componentcallbacks()[2]))
	
	def runScript_(self, sender):
		self.resultView.setString_(u'')
		try:
			errorKind = 'Compilation'
			self.codeView.setString_(self._script.compile(self.codeView.string()))
			errorKind = 'Runtime'
			self._script.run()
			self._appendResult(u'Done.')			
		except osascript.ScriptError, e:
			start, end = e.range
			self.codeView.setSelectedRange_((start, end - start))
			self._appendResult(u'%s Error:\n%s (%i)' % (errorKind, e.message, e.number))
	
	def isDocumentEdited(self):
		return False


if __name__ == "__main__":
	AppHelper.runEventLoop()
