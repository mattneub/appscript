"""ASTranslate"""

from subprocess import Popen

import AppKit
from PyObjCTools import NibClassBuilder, AppHelper

import osascript, aem

import eventformatter


NibClassBuilder.extractClasses("MainMenu")
NibClassBuilder.extractClasses("ASTranslateDocument")

_ci = osascript.Interpreter()

_rendererscript = AppKit.NSBundle.mainBundle().pathForResource_ofType_('rubyrenderer', 'rb')
_rubyproc = Popen(['ruby', _rendererscript])
_rubyapp = aem.Application(pid=_rubyproc.pid)

#######

class ASApplicationDelegate(NibClassBuilder.AutoBaseClass):

	def applicationWillTerminate_(self, notification):
		try:
			_rubyapp.event('aevtquit').send()
		except:
			pass
		
	

class ASTranslateDocument(NibClassBuilder.AutoBaseClass): # (NSDocument)
	# Outlets:
	# codeView
	# resultView
	# styleControl
	
	_script = None # an osascript.Script instance
	
	def _appendResult(self, pythonCode, rubyCode):
		self._pythonOutput.append(pythonCode)
		self._rubyOutput.append(rubyCode)
		self.resultView.textStorage().appendAttributedString_(
				AppKit.NSAttributedString.alloc().initWithString_(u'%s\n\n' % self._currentStyle[-1]))

	def windowNibName(self): # a default NSWindowController is created automatically
		return "ASTranslateDocument"

	def windowControllerDidLoadNib_(self, controller):
		self._script = _ci.newscript()
		self._pythonOutput = []
		self._rubyOutput = []
		self._currentStyle = self._pythonOutput
		self._script.setruncallbacks(send=eventformatter.makeCustomSendProc(
				_rubyapp, self._appendResult, _ci.componentcallbacks()[2]))
	
	def runScript_(self, sender):
		self.resultView.setString_(u'')
		while self._pythonOutput:
			self._pythonOutput.pop()
			self._rubyOutput.pop()
		try:
			errorKind = 'Compilation'
			self.codeView.setString_(self._script.compile(self.codeView.string()))
			errorKind = 'Runtime'
			self._script.run()
			self._appendResult(u'Done.', u'Done.')
		except osascript.ScriptError, e:
			start, end = e.range
			self.codeView.setSelectedRange_((start, end - start))
			errstr = u'%s Error:\n%s (%i)' % (errorKind, e.message, e.number)
			self._appendResult(errstr, errstr)
	
	def selectStyle_(self, sender):
		self._currentStyle = [self._pythonOutput, self._rubyOutput][self.styleControl.selectedSegment()]
		self.resultView.setString_(u'\n\n'.join(self._currentStyle))
	
	def isDocumentEdited(self):
		return False

#######

AppHelper.runEventLoop()

