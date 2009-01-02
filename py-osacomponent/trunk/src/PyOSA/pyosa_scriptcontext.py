
#
# pyosa_scriptcontext.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
# Defines ScriptContext class, instances of which represent a single 'compiled' script
# (i.e. a Python ModuleType instance). Provides methods for compiling, running and handling
# events. Note: compiled OSA scripts behave like Python modules, not shell scripts;
# executing a script is not the same as running it.
#
# Compiling a script involves the following steps:
# - create a new module object containing PyOSA functions and objects: appscript attributes, log(), an
#	appscript.app object targetted at current (i.e. host) application, etc. as top-level variables
# - compile script source code into code object
# - execute the resulting code object in the module context to initialise the script's own
#	top-level functions, variables, etc.
#
# Running a script involves calling its top-level run() function, if it has one.
#

from sys import stderr # debug
from pprint import pprint # debug

from types import ModuleType
from copy import deepcopy

from pyosa_appscript import aem, appscript
import appscript.reference
from pyosa_errors import *
from pyosa_eventhandlerdefinitions import kCommand, kBuiltInEventHandlerDefs

#######


class PersistentStorage:
	def __init__(self, data):
		self.__dict__ = data or {}
	
	def __call__(self, **args):
		# used by client script to initialise persistent state (using a top-level call to initialise it when script is compiled)
		if not self.__dict__: # don't reinitialise if there's existing state
			self.__dict__ = args


#######


# TO DO: what about ascrpsbr events? have a public installsubroutinehandler function that takes a callable and optional name (if name not given, use callable's name) and adds those to a _subroutinehandlerdefs table

# TO DO: public API for adding handler definitions?

class EventHandlerManager:

	def __init__(self, context, appdata):
		self._appdata = appdata
		self._context = context
		self._eventhandlerdefs = {}
		self._hasautoloaded = False
		self._handlernamebycode = {}
	
	def _eventhandlers(self):
		if not self._hasautoloaded: # initialize event handler table
			print >> stderr, 'Initialising event handler table...' # debug
			self._hasautoloaded = True
			# for each command definition in built-in list/host application dictionary...
			for defs in [kBuiltInEventHandlerDefs, self._appdata.referencebyname()]:
				for name, (kind, info) in defs.items():
					if kind == kCommand:
						code, paramdefs = info
						self._handlernamebycode[code] = name
						# if script has a function with same name as this command, get it
						callback = getattr(self._context, name, None)
						if callable(callback):
							# get keyword parameters
							paramdefs = dict([(paramcode, paramname) for paramname, paramcode in paramdefs.items()])
							# does this function take a direct parameter?
							argcount = callback.func_code.co_argcount
							argnames = callback.func_code.co_varnames[:argcount]
							if argcount:
								if argnames[0] not in paramdefs.values():
									paramdefs['----'] = argnames[0]
							# mark this function as 'bad' if it has any unrecognised parameter names
							# (which would cause an 'unexpected argument' TypeError if called)
							paramnames = paramdefs.values()
							for argname in argnames:
								if argname not in paramnames:
									print >> stderr, '    %r handler has unknown parameter (%s)' % (name, argname) # debug
									callback = lambda **args: raisecomponenterror(OSAMissingParameter)
							# add event handler function and code-name parameter translation table
							# to event handler table
							self._eventhandlerdefs[code] = (callback, paramdefs)
							print >> stderr, '    autoinstalled %r handler' % name # debug
		print >> stderr, '...done.' # debug
		return self._eventhandlerdefs
	
	#######
	
	def installeventhandler(self, callback, code, paramdefs): # users can add handlers using raw AE codes
		# TO DO: validate user-supplied args?
		self._eventhandlers()[code] = (callback, paramdefs)
	
	def hasopenhandler(self):
		return 'aevtodoc' in self._eventhandlers()
	
	def calleventhandler(self, eventcode, params):
		callback, paramdefs = self._eventhandlers().get(eventcode, (None, {}))
		if not callback:
			raisecomponenterror(OSAMessageNotUnderstood, "Script doesn't contain a handler for %r events." % 
					self._handlernamebycode.get(eventcode, eventcode)) # if event handler is missing, raise a ComponentError (not a ScriptError, which is only for errors that happen within the script)
		args = {}
		for code, value in params.items():
			paramname = paramdefs.get(code)
			if paramname: # according to SIG, event handlers should ignore unrecognised parameters
				args[paramname] = value
		try:
			return callback(**args)
		except Exception, e:
			raisescripterror(errOSAGeneralError, "Couldn't handle %r event" %
					self._handlernamebycode.get(eventcode, eventcode), e, None) # note: caller will need to add source later


#######

# TO DO: is there a way to use custom Builtins instance for _context.__builtins__ and put osadict, etc. in that? (note: putting osadict in existing __builtin__ module is no good, since each ScriptContext needs a different one)

class ScriptContext:
	def __init__(self, appscriptservices, source=None, state=None):
		# customise aem's classes so that they use host-supplied callbacks for creating and sending events
		appscriptservices.installcallbacks()
		# create the module object representing the client's script # TO DO: most of this code should probably be executed by compile(), not here
		self._source = ''
		self._context = ModuleType('__main__')
		# add appscript and aem attributes to client script
		self._context.appscript = appscript
		self._context.aem = aem
		for name in ['k', 'ApplicationNotFoundError', 'CommandError', 'con', 'its', 'app']:
			setattr(self._context, name, getattr(appscript, name))
		# log() is equivalent to AppleScript's log command
		self._aemhost = appscript.app().AS_appdata.target()
		self._context.log = self._log
		# parent.somecommand(...) is equivalent to AppleScript's continue somecommand(...) statement
		self._context.parent = appscript.reference.Reference(appscriptservices, aem.app)
		# EventHandlerManager is responsible for handling events sent to this script, providing
		# automatic installation of event handlers based on the host application's dictionary
		self._eventhandlermanager = EventHandlerManager(self._context, appscriptservices)
		# client scripts can call installeventhandler to install functions using raw AE codes
		# (equivalent to writing 'on <<event abcd1234>> ... end' in AppleScript)
		self._context.installeventhandler = self._eventhandlermanager.installeventhandler
		# for convenience, compile script if source was provided here (if not, ScriptManager will
		# need to call the new ScriptContext instance's compile() method separately)
		if source is not None:
			self.compile(source, state)
	
	
	
	def _log(self, val=None):
		self._aemhost.event('ascrcmnt', val is not None and {'----':val} or {}).send()
	
	
	def _executeincontext(self, source):
		# compile source code into a code object, then execute it in the script module's context
		# to initialise its top-level state (functions, classes, global variables, etc)
		try:
			bytecode = compile(source.replace('\r', '\n') + '\n', '<PyOSAScript>', 'exec')
		except Exception, e:
			raisescripterror(OSASyntaxError, "Couldn't compile script", e, self._source)
		try:
			exec bytecode in self._context.__dict__
		except Exception, e:
			raisescripterror(OSASyntaxError, "Couldn't initialize script", e, self._source)
	
	#######
	
	def state(self):
		# retrieve the script's persistent statel used by ScriptManager when storing script (OSAStore)
		# or checking if script has been modified (OSAGetScriptInfo)
		return self._context.state.__dict__
	
	
	def hasopenhandler(self):
		# does script have an 'open' event handler - either a function named open that's installed
		# automatically, or one installed manually by calling installeventhandler(fn, 'aevtodoc', ...)
		return self._eventhandlermanager.hasopenhandler()
	
	#######
	
	def compile(self, source, state=None):
		self._source = source
		self._initialstate = deepcopy(state)
		self._context.state = PersistentStorage(state)
		self._executeincontext(source)
	
	
	def execute(self, modeflags):
		try:
			return self._context.run()
		except Exception, e:
			if not callable(getattr(self._context, 'run', None)):
				e = NameError("run handler is not defined")
			raisescripterror(errOSAGeneralError, "Couldn't run script", e, self._source)
	
	
	def handleevent(self, code, atts, params, modeflags):
		print >> stderr, 'Handling %r event' % code # debug
		pprint(atts, stderr) # debug
		pprint(params, stderr) # debug
		# TO DO: how to handle subject attribute, if at all? (i.e. could evaluate reference against module)
		try:
			return self._eventhandlermanager.calleventhandler(code, params)
		except ScriptError, e:
			e.setsource(self._source)
			raise



