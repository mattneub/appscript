#!/usr/bin/env pythonw

import MacOS
from Carbon.Cm import OpenDefaultComponent as _OpenDefaultComponent
from CarbonX.OSA import OSAComponentInstance as _OSAComponentInstance
from CarbonX.kAE import *
from CarbonX.kOSA import *
from aem import *
from aem.send.connect import currentapp

__all__ = ['Interpreter', 'ScriptError']

######################################################################

# TO DO: define EventIdentifier class to replace AEEventName class (see ASRegistry.h -> cEventIdentifier, OSAGetHandlerNames)

# TO DO: squelch error -2700s (or handle some other way?) # not sure what this refers to  (-2700 = unknown error)

# TO DO: OSA Value class and Interpreter.newvalue(); alternatively, allow multiple return types to be specified as [optional] arg to source(), run(), call(), etc.

_defaultCodecs = Codecs()

_kNull = _defaultCodecs.pack(None)

_event = Application().event


######################################################################

class Interpreter:
	"""Wrapper for an OSA component instance."""

	def __init__(self, type='ascr', codecs=_defaultCodecs):
		self._type = type
		self.OC_codecs = codecs
		self.OC_ci = _OSAComponentInstance(_OpenDefaultComponent(kOSAComponentType, type))
		self.OC_compilecallbacks = (None, None, None, None)
		self.OC_recordcallbacks = (None, None, None, None)
		self.OC_runcallbacks = (None, None, None, None)
	
	def componentcallbacks(self):
		return (
				self.OC_ci.OSAGetActiveProc(),
				self.OC_ci.OSAGetCreateProc(),
				self.OC_ci.OSAGetSendProc(),
				self.OC_ci.OSAGetResumeDispatchProc())
	
	def setcompilecallbacks(self, active=None, create=None, send=None, resume=None):
		"""Install callback functions to be used during compilation. Use this before creating any scripts."""
		self.OC_compilecallbacks = (active, create, send, resume)
	
	def setrecordcallbacks(self, active=None, create=None, send=None, resume=None):
		"""Install callback functions to be used during recording. Use this before creating any scripts."""
		self.OC_recordcallbacks = (active, create, send, resume)
	
	def setruncallbacks(self, active=None, create=None, send=None, resume=None):
		"""Install callback functions to be used while running/calling scripts. Use this before creating any scripts."""
		self.OC_runcallbacks = (active, create, send, resume)

	def stylenames(self): 
		"""Get names of text styles used by the AS language for pretty printing. Result is a list of strings."""
		return self.OC_codecs.unpack(self.OC_ci.ASGetSourceStyleNames(kOSAModeNull))
	
	def styles(self): 
		"""Get text styles used by the AS language for pretty printing. Result is a list of dicts."""
		return self.OC_codecs.unpack(self.OC_ci.ASGetSourceStyles())
	
	def setstyles(self, styles):
		"""Set text styles used by the AS language for pretty printing. 'styles' argument is a list of dicts.
		
		Note: this changes the AS styles preferences across current user's account.
		"""
		self.OC_ci.ASSetSourceStyles(self.OC_codecs.pack(styles))

	def newscript(self): # TO DO: convenience parameters
		return Script(self)
	
	###
	# used for pretty-printing Apple events and values (e.g. a custom send proc may want to record event traffic in an event log window, c.f. Script Editor)
	# TO DO: support pretty-printing of lists and records
	# TO DO: just return None instead of (False, '')
	
	def displayevent(self, event):
		if event.type != 'aevt':
			raise TypeError, 'Not an Apple event descriptor.'
		app = event.AEGetAttributeDesc(keyAddressAttr, typeWildCard)
		if (app.type, app.data) == (currentapp.type, currentapp.data): # TO DELETE: shouldn't be needed
			return (False, '', '')
		return (True, self.displayvalue(app), self.displayvalue(event, app))
	
	
	def displayreply(self, event):
		if event.type != 'aevt':
			raise TypeError, 'Not an Apple event descriptor.'
		app = event.AEGetAttributeDesc(keyOriginalAddressAttr, typeWildCard)
		if (app.type, app.data) == (currentapp.type, currentapp.data): # TO DELETE: shouldn't be needed
			return (False, '')
		try:
			resultDesc = event.AEGetParamDesc('----', typeWildCard)
		except MacOS.Error: # no reply value given
			return (False, '')
		return (True, self.displayvalue(resultDesc, app))


	def displayvalue(self, desc, app=None):
		if app and (app.type, app.data) == (currentapp.type, currentapp.data): # TO DO: delete (shouldn't be needed)
			app = None
		valueid = self.OC_ci.OSACoerceFromDesc(desc, kOSAModeNull)
		if app:
			self.OC_ci.OSASetDefaultTarget(app)
		result = self.OC_codecs.unpack(self.OC_ci.OSAGetSource(valueid, typeUnicodeText)) # TO FIX: should really use OSADisplay if poss, as source and value representations may differ for other languages (e.g. MacPythonOSA)
		if app:
			self.OC_ci.OSASetDefaultTarget(_kNull) # TO DO: make this settable
		self.OC_ci.OSADispose(valueid)
		return result



######################################################################

class Script:
	"""Wrapper for an OSA script."""

	def __init__(self, interpreter):
		"""Called by Interpreter.newscript(). Clients should not call this directly."""
		# self._interpreter = interpreter
		self._ci = interpreter.OC_ci
		self._id = 0 # will be set first time source/loadfile is called
		self._pack = interpreter.OC_codecs.pack
		self._unpack = interpreter.OC_codecs.unpack
		self._compilecallbacks = interpreter.OC_compilecallbacks
		self._recordcallbacks = interpreter.OC_recordcallbacks
		self._runcallbacks = interpreter.OC_runcallbacks
		self._originalcallbacks = [None, None, None, None]
		
	def __del__(self):
		if self._id:
			self._ci.OSADispose(self._id)
	
	def _installcallbacks(self, callbacks):
		for i, cb in enumerate(callbacks):
			if cb:
				self._originalcallbacks[i] = [
						self._ci.OSAGetActiveProc,
						self._ci.OSAGetCreateProc,
						self._ci.OSAGetSendProc,
						self._ci.OSAGetResumeDispatchProc][i]()
				[self._ci.OSASetActiveProc,
				self._ci.OSASetCreateProc,
				self._ci.OSASetSendProc, 
				self._ci.OSASetResumeDispatchProc][i](cb)
	
	def _removecallbacks(self):
		for i, cb in enumerate(self._originalcallbacks): 
			if cb: [
					self._ci.OSASetActiveProc,
					self._ci.OSASetCreateProc,
					self._ci.OSASetSendProc, 
					self._ci.OSASetResumeDispatchProc][i](cb)
		self._originalcallbacks = [None, None, None, None]	
	##
	
	def setcompilecallbacks(self, active=None, create=None, send=None, resume=None):
		"""Install callback functions to be used during compilation. This should be done before use."""
		self._compilecallbacks = [custom or standard for custom, standard in 
				zip((active, create, send, resume), self._compilecallbacks)]
	
	def setrecordcallbacks(self, active=None, create=None, send=None, resume=None):
		"""Install callback functions to be used during recording. This should be done before use."""
		self._recordcallbacks = [custom or standard for custom, standard in 
				zip((active, create, send, resume), self._recordcallbacks)]
	
	def setruncallbacks(self, active=None, create=None, send=None, resume=None):
		"""Install callback functions to be used while running/calling script. This should be done before use."""
		self._runcallbacks = [custom or standard for custom, standard in 
				zip((active, create, send, resume), self._runcallbacks)]
	
	##
	
	# TO DO: make sure calling methods before a script id is assigned doesn't cause problems
	
	def isinitialized(self):
		return bool(self._id)
	
	def ismodified(self):
		return  bool(self._ci.OSAGetScriptInfo(self._id, kOSAScriptIsModified))
	
	def cangetsource(self):
		return  bool(self._ci.OSAGetScriptInfo(self._id, kOSACanGetSource))
	
	def hasopenhandler(self): # allow users to 'run open handler', throwing up 'choose files/folders' dialog, or provide some sort of drag-n-drop option (e.g. drag to file/folder list in drop-down sheet)
		return  bool(self._ci.OSAGetScriptInfo(self._id, kASHasOpenHandler))
	
	def compile(self, source):
		self._installcallbacks(self._compilecallbacks)
		try:
			try:
				self._id = self._ci.OSACompile(self._pack(source), kOSAModeCompileIntoContext, self._id)
			except MacOS.Error, e:
				if e[0] == -1753:
					raise ScriptError(self._ci)
				raise
		finally:
			self._removecallbacks()
		return self.source()
	
	def source(self):
		try:
			return self._unpack(self._ci.OSAGetSource(self._id, typeUnicodeText)) # TO DO: style support
		except MacOS.Error, e:
			print e
			raise # TO DO: better error reporting (e.g. opened read-only script)
	
	def loadfile(self, path, mode=kOSAModeNull): # TO DECIDE: on Panther, optionally(?) install a 'path to' handler to provide 'path to me' support
		"""Load script from file.
		
			mode flags: kOSAModePreventGetSource, plus any from OSACompile if it's a text file.
			
			Notes: 
			- On OS 10.4+, AppleScripts loaded using loadfile() can obtain their own filesystem locations using 'path to me'.
		"""
		self._id, storable = self._ci.OSALoadFile(path, mode)
	
	def storefile(self, path, type=typeOSAGenericStorage, mode=kOSAModeNull):
		"""Store script in file.
		
			mode flags: kOSAModePreventGetSource, kOSAModeDontStoreParent
		"""
		self._ciOSAStoreFile(self._id, type, mode, path)
	
	def load(self, desc, mode=kOSAModeNull):
		"""Load script from AEDesc.
		
			mode flags: kOSAModePreventGetSource
		"""
		self._id = self._ci.OSALoad(desc, mode)
	
	def store(self, type=typeOSAGenericStorage, mode= kOSAModeNull):
		"""Store script in AEDesc.
		
			mode flags: kOSAModePreventGetSource, kOSAModeDontStoreParent
		"""
		return self._ciOSAStore(self._id, type, mode)
	
	def run(self):
		if not self._id:
			self.compile('')
		self._installcallbacks(self._runcallbacks)
		try:
			try:
				resultid = self._ci.OSAExecute(self._id, kOSANullScript, kOSAModeNull)
			except MacOS.Error, e:
				if e[0] == -1753:
					raise ScriptError(self._ci)
				raise
		finally:
			self._removecallbacks()
		if resultid != kOSANullScript:
			result = self._unpack(self._ci.OSADisplay(resultid, typeUnicodeText, kOSAModeNull))
			self._ci.OSADispose(resultid)
			return result
		else:
			return ''

	def startrecording(self):
		self._installcallbacks(self._recordcallbacks)
		try:
			self._id = self._ci.OSAStartRecording(self._id)
		except MacOS.Error, e:
			if e[0] != -2700:
				raise
		print 'RECORDING'
	
	def stoprecording(self):
		self._ci.OSAStopRecording(self._id)
		self._removecallbacks()
		print 'STOPPED'


	def call(self, *args, **kargs):
		modeflags = kargs.pop('mode', kOSAModeNull)
		resulttype = kargs.pop('type', typeWildCard)
		event = _event(*args, **kargs).AEM_event
		try:
			self._installcallbacks(self._runcallbacks)
			try:
				resultid = self._ci.OSAExecuteEvent(event, self._id, modeflags)
			except MacOS.Error, e:
				if e[0] == -1753:
					raise ScriptError(self._ci)
				raise
		finally:
			self._removecallbacks()
		if resultid != kOSANullScript:
			# TO DO: allow caller to optionally request OSADisplay be used instead (or just have them ask for Value, and get display value from that)
			result = self._unpack(self._ci.OSACoerceToDesc(resultid, resulttype, kOSAModeNull))
			self._ci.OSADispose(resultid)
			return result




######################################################################

class ScriptError(Exception): # TO DO: make subclass of MacOS.Error?
	"""A script error."""
	
	def __init__(self, ci):
		errorinfo = [_defaultCodecs.unpack(ci.OSAScriptError(key, aetype)) for key, aetype in [
				(kOSAErrorNumber, typeWildCard),
				(kOSAErrorMessage, typeUnicodeText),
				(kOSAErrorBriefMessage, typeUnicodeText),
				(kOSAErrorApp, typeWildCard),
				(kOSAErrorPartialResult, typeWildCard),
				(kOSAErrorOffendingObject, typeWildCard),
				(kOSAErrorExpectedType, typeWildCard)]]
		range = _defaultCodecs.unpack(ci.OSAScriptError(kOSAErrorRange, typeAERecord))
		errorinfo.append((
				range[AEType(keyOSASourceStart)], 
				range[AEType(keyOSASourceEnd)]))
		Exception.__init__(self, *errorinfo)
		self.number, self.message, self.briefMessage, self.app, self.partialResult, \
				self.offendingObject, self.expectedType, self.range = errorinfo
	
	def __str__(self):
		return '%s (%i) [%i:%i]' % ((self.message, self.number) + self.range)

