
from types import ModuleType
from copy import deepcopy

from pyosa_appscript import aem, appscript
from pyosa_errors import *

#######


class PersistentStorage:
	def __init__(self, data):
		self.__dict__ = data or {}
	
	def __call__(self, **args):
		# used by client script to initialise persistent state when script is compiled
		if not self.__dict__: # don't reinitialise if there's existing state
			self.__dict__ = args


#######



class ScriptContext:
	def __init__(self, appscriptservices, source=None, state=None):
		self._source = ''
		self._context = ModuleType('__main__')
		self._context.appscript = appscript
		appscriptservices.installcallbacks()
		for name in ['k', 'ApplicationNotFoundError', 'CommandError', 'con', 'its', 'app']:
			setattr(self._context, name, getattr(appscript, name))
		self._host = appscript.app()
		self._context.host = self._host
		self._context.log = self._log
		self._initialstate = {}
		if source is not None:
			self.compile(source, state)
	
	
	def _log(self, val=None):
		self._host.AS_appdata.target.event('ascrcmnt', 
				val is not None and {'----':val} or {}).send()
	
	
	def _executeincontext(self, source):
		try:
			bytecode = compile(source.replace('\r', '\n') + '\n', '<PyOSAScript>', 'exec')
		except Exception, e:
			raiseScriptError(OSASyntaxError, "Couldn't compile script", e, self._source)
		try:
			exec bytecode in self._context.__dict__
		except Exception, e:
			raiseScriptError(OSASyntaxError, "Couldn't initialize script", e, self._source)
	
	#######
	
	def state(self):
		return self._context.osadata.__dict__
	
	
	def ismodified(self):
		return self._initialstate == self.state()
	
	
	def hasopenhandler(self):
		return callable(getattr(self._context, 'open', None))
	
	#######
	
	def compile(self, source, state=None):
		self._source = source
		self._initialstate = deepcopy(state)
		self._context.osadata = PersistentStorage(state)
		self._executeincontext(source)
	
	
	def execute(self, modeflags):
		try:
			return self._context.run()
		except Exception, e:
			raiseScriptError(errOSAGeneralError, "Couldn't run script", e, self._source)
	
	
	def handleevent(self, code, atts, params, modeflags):
		print 'Handling %r event' % code
		from pprint import pprint
		pprint(atts)
		pprint(params)
		print
		try:
			# TO DO: proper event handling system
			if code == 'aevtoapp':
				if params:
					return self._context.run(params['----'])
				else:
					return self._context.run()
			elif code == 'aevtodoc':
				return self._context.open(params['----'])
			else:
				return '<REPLY_EVENT>'
		except Exception, e:
			raiseScriptError(errOSAGeneralError, "Couldn't handle event", e, self._source)


