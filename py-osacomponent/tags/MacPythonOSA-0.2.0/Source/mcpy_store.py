#!/usr/local/bin/pythonw

"""mcpy_store.py -- Stores all client scripts for a single component instance.

(C) 2005 HAS

--------------------------------------------------------------------------------
"""

# TO DO: marshal is not guaranteed to be compatilbe across Python versions, so forget about storing code objects; always store source and ignore 'read-only' flags; use pickle to store state

from struct import unpack
from types import ModuleType
import pickle, sys, MacOS

from CarbonX.AE import AECreateDesc

from mcpy_constants import *
import mcpy_pack
import mcpy_error

import mcpy_support
import mcpy_aemodule


######################################################################
# PRIVATE
######################################################################

_kSerialisationVersion = 0.5
_kOldestSupportedVersion = 0.5

#######
# Storage for scripts and script values

_kMaxIdCount = 2**32 - 1 # highest script ID allowed before restarting _idCount at 1 (OSAID = unsigned long)

_idCount = 0 # current highest ID; incremented each time a new ID is vended
_scriptStore = {} # compiled scripts and the results of their execution are stored by numerical ID


#######
# Replacement for stdout, stderr

class _Log:
	# TO DO: use different formatting for stderr vs. stdout
	# TO CHECK: any other methods need implemented?
	
	def write(self, s):
		mcpy_aemodule.host.event('ascrcmnt', {'----': s})


#######
# Value

class ValueObject:
	"""Holds a value returned by a script.""" # TO CHECK: can a script also be a [return] value?
	scriptIsTypeCompiledScript = False
	scriptIsTypeScriptValue = True
	scriptIsTypeScriptContext = False
	scriptIsModified = False
	canGetSource = False
	hasOpenHandler = False
	source = property(lambda self:repr(self.value))
	
	def __init__(self, value):
		self.value = value
		self.scriptBestType = _asInt('****') # TO FIX: get this info by packing value here instead of at retrieval? this will also allow us to type-check the script's returned value to make sure it can be converted to an AE type okay; it may be an idea to pack anything that can't be converted to a standard AE type as 'scpt'


#######

def _newID():
	# note: tries to protect sloppy clients against themselves by avoiding reuse of old IDs for as long as possible
	global _idCount
	_idCount += 1
	while _scriptStore.has_key(_idCount):
		_idCount += 1
		if _idCount > _kMaxIdCount:
			_idCount = 1
	return _idCount


#######

class PersistentStorage: 
	"""User data that should be stored in saved .scpt files and restored when that script is loaded."""
	def __init__(self, data):
		self.__dict__ = data
	
	def __call__(self, **args):
		# used to initialise state at compile-time; subsequent calls (made when script is loaded) are ignored
		if not self.__dict__:
			self.__dict__ = args


#######

def _asInt(s):
	return unpack('l',s)[0]


######################################################################
# PUBLIC
######################################################################
# Script

class ScriptObject(object):
	"""Holds a compiled script; contains compiled source (Python code object) plus optional source code (text) and/or context (module object)."""
	
	#######
		
	def _makeNewContext(state=None):
		"""
			state : dict -- dictionary extracted from a previous PersistentStorage instance
			Result : module
		"""
		# A Python module provides a persistent, non-serialisable context. The module is initialised (i.e. top-level statements are executed) when the script is compiled (or, if client doesn't request 'compile into context', each time script is run). 
		# Note that running a script involves calling a designated top-level function, run(*args); all MacPythonOSA scripts must provide this handler to operate correctly. # TO DO: need to map 'ascroapp' events to 'run' function and vice-versa.(Currently, applets need an ae_aevtoapp function while scripts run in Script Editor need a run function; this needs fixed.)
		# This module-based approach prevents MacPythonOSA from supporting traditional Python shell scripts (where running a script = executing top-level statements), but allows it to support OSA behaviours correctly.
		context = ModuleType('__osamain__') # TO DO: rename __main__?
		context.osastore = PersistentStorage(state or {})
		context.ae = mcpy_aemodule
		# TO DO: delegate stdout and stderr write()s to client as 'log' events? (client may choose to ignore these events, but that's its choice)
		return context
	_makeNewContext = staticmethod(_makeNewContext)


	def _execSourceInContext(context, source):
		# TO DO: need to sort out error raising/diagnosing/reporting
		try:
			bytecode = compile(source.replace('\r', '\n')+'\n', '<OSA script>', 'exec')
		except Exception, e:
			mcpy_error.raiseScriptCompileError(source, 'Script compilation failed.')
		try:
			exec bytecode in context.__dict__
		except Exception, e:
			mcpy_error.raiseScriptError(source, 'Script initialisation failed.')
	_execSourceInContext = staticmethod(_execSourceInContext)
	
	#######
	# Constructors
	
	def makeFromSource(klass, source, modeFlags):
		"""
			source : str -- Python source code
			modeFlags : kOSAModeNull | kOSAModeCompileIntoContext | ... -- make new context; additional flags used in AESend
			Result : ScriptObject
		"""
		return klass(source, None, modeFlags)
	makeFromSource = classmethod(makeFromSource)
	
	
	def makeFromAEDesc(klass, scriptDesc, modeFlags):
		"""
			scriptDesc : AEDesc -- AEDesc of typeScript
			modeFlags : kOSAModeNull | kOSAModeCompileIntoContext -- # TO DO: check what flags are needed
			Result : ScriptObject
		"""
		rec = mcpy_pack.unpack(AECreateDesc(typeAERecord, scriptDesc.data))
		if rec['componentVersion'] < _kOldestSupportedVersion:
			mcpy_error.raiseError(errOSADataFormatObsolete, "Can't de-serialise script: script format is obsolete.")
		if rec['componentVersion'] > _kSerialisationVersion:
			mcpy_error.raiseError(errOSADataFormatTooNew, "Can't de-serialise script: script format is too new.")
		modeFlags = rec['modeFlags'] | modeFlags 
		return klass(rec['source'], rec['state'], modeFlags)
	makeFromAEDesc = classmethod(makeFromAEDesc)
	
	
	#######
	# note: clients don't call __init__ themselves; instead they should use makeFromSource/makeFromAEDesc
	
	filePath = None
	
	def __init__(self, source, serialisedState, modeFlags):
		# script data
		self.source = source
		if modeFlags & kOSAModeCompileIntoContext:
			if serialisedState:
				try:
					self.context = self._makeNewContext(pickle.loads(serialisedState))
				except:
					mcpy_error.raiseError(errOSASystemError, "Can't de-serialise script's stored state.")
			else:
				self.context = self._makeNewContext()
			self._execSourceInContext(self.context, self.source)
		else:
			self.context = None # TO DO: context should be private; clients probably shouldn't need to access it directly, but if they do then they should use getContext() instead
		self.modeFlags = modeFlags # used in AESend
		# script info
		self._originalState = serialisedState # used to check if script has been modified
		self.scriptBestType = _asInt(typeChar) # TO DO (not really sure what this should be)
		self._scriptReallyIsModified = False # SE 1.x sets this flag itself
	
	def _getState(self):
		return getattr(getattr(self.context, 'osastore', None), '__dict__', None)
	
	def _scriptIsModified(self):
		# compare original serialised state with current serialised state; TO CHECK: what if client replaces this ScriptObject in store with a new one?
		try:
			return self._scriptReallyIsModified or pickle.dumps(self._getState()) != self._originalState
		except:
			mcpy_error.raiseError(errOSASystemError, "Can't check script's current state.")
	
	def _setScriptIsModified(self, val):
		self._scriptReallyIsModified = True
	
	def _scriptFileRef(self):
		mcpy_error.raiseError(errOSASystemError, "Can't get source file's FSRef.")
	
	def _setScriptFileRef(self, filePtr): # OSALoadFile invokes this
		self.filePath = unicode(mcpy_support.intToFSRef(filePtr).as_pathname(), 'utf8')
		print 'Source file set: %r' % self.filePath
	
	#######
	# Script info
	scriptIsTypeCompiledScript = True
	scriptIsTypeScriptValue = False
	scriptIsTypeScriptContext = property(lambda self: self.context != None)
	canGetSource = True
	hasOpenHandler = property(lambda self:callable(getattr(self.context, 'ae_aevtodoc', None))) # TO FIX: handler name(s)
	scriptIsModified = property(_scriptIsModified, _setScriptIsModified)
	scriptFileRef = property(_scriptFileRef, _setScriptFileRef)
	
	#######
	
	
	def asScriptDesc(self, omitSource, omitParent):
		"""Convert script to an AEDesc of typeScript."""
		# TO DO: support storing parent? TO DECIDE: do we actually need this, and if so, how should it work? kOSAModeDontStoreParent; how is parent determined (by client and/or language?)?
		try:
			return AECreateDesc(typeScript, mcpy_pack.pack({
					'componentVersion': _kSerialisationVersion,
					'source': not omitSource and self.source or None,
					'state': pickle.dumps(self._getState()),
					'modeFlags': self.modeFlags,
					'pythonVersion': sys.version_info,
					}).data)
		except Exception, e:
			# TO DO: should probably write detailed error info to stderr here
			mcpy_error.raiseError(errOSASystemError, "Can't serialise script.")
	
	def raiseScriptError(self, msg=''):
		mcpy_error.raiseScriptError(self.source, msg)
	
	def augmentContext(self, source):
		# TO FIX: need to store source objects in lists so they can be retained and reapplied in order when the script is stored and loaded from disk (note: this could get pretty awkward, especially when viewing source)
		if self.context:
			self._execSourceInContext(self.context, source)
		else:
			mcpy_error.raiseError(errOSAInvalidID, "Can't augment script: not a script context.")
	
	def _getContext(self):
		if self.context:
			context = self.context
		else:
			context = self._makeNewContext()
			self._execSourceInContext(context, self.source)
		return context
	
	def run(self, contextID, modeFlags): # TO DO: contextID and AESend modeFlags
		# TO DO: delegate stdout and stderr write()s to client as 'log' events
		context = self._getContext()
		if not hasattr(context, 'run'):
			try: # TO DO: kludge
				raise RuntimeError, "Can't run script: no run() handler found."
			except:
				self.raiseScriptError( 'No run() handler found.')
		try:
			return context.run()
		except:
			self.raiseScriptError('Script execution failed.')
	
	
	def getEventHandler(self, handlerName):
		handler = getattr(self._getContext(), handlerName, None)
		if not handler:
			mcpy_error.raiseError(errAEEventNotHandled, 'Event handler %r not found.' % handlerName)
		return handler


#######
# Store access

def setScript(id, scriptObject):
	if id == kOSANullScript:
		id = _newID()
	_scriptStore[id] = scriptObject
	print '\tSetting script %i' % id # TEST
	return id

def addValue(data):
	id = _newID()
	_scriptStore[id] = ValueObject(data)
	return id

def getScript(id):
	# TO DO: check it's the right type of object (script/script value)
	try:
		return _scriptStore[id]
	except KeyError:
		raise mcpy_error.ControllerError(errOSAInvalidID)

getItem = getValue = getScript # TO CHECK: is getItem needed?

def deleteItem(id):
	if _scriptStore.has_key(id):
		del _scriptStore[id]

