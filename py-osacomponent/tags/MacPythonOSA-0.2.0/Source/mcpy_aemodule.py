"""mcpy_aemodule -- Inserted into each client script's namespace to provide access to aem. (It is recommended that client scripts don't import aem directly.)

(C) 2005 HAS

--------------------------------------------------------------------------------

Notes:

API is same as aem's, plus the addition of 'host' variable which contains an Application instance that client scripts should use to target the host application. The host object's event() method creates a special Event object that implements an extra method, resend(), which should be used to send an event to the host application bypassing its special event handlers (equivalent to using a 'continue' statement in AppleScript). Example:

	def ae_aevtquit():
		ae.host.event('aevtquit').resend()

"""

from aem import *
from mcpy_support import pathToHost as _pathToHost
import mcpy_ae as _ae
import aem as _aem


#######
# PRIVATE

_hostPath = _pathToHost() # Note: this will error if application path changes between application launch and component open

class Event(_aem.Event):
	"""Extends standard Event class so that client can provide custom functions for creating and/or sending Apple events.
	
	Clients should not instantiate this class directly.
	"""
	
	def _createAppleEvent(self, eventclass, eventid, address, returnid, transaction):
		return _ae.createAE(eventclass, eventid, address, returnid, transaction)
	
	def _sendAppleEvent(self, flags, timeout):
		return _ae.sendAE(self.AEM_event, flags, timeout)


class HostEvent(Event):
	"""Special-case version of Event subclass used when target is host application. Extends existing Event class to support dispatching of events without them going through the special event handler table.
	
	Clients should not instantiate this class directly.
	"""

	def resend(self):
		return _ae.redispatchAE(self.AEM_event)


#######
# PUBLIC

class Application(_aem.Application):

	_Event = Event
	
	def __init__(self, path=None, url=None, desc=None, codecs=None):
		if not path or url or desc:
			self._Event = HostEvent
			desc = _ae.getDefaultTarget() # TO CHECK: should we be using default target instead of 'current application'? Will this affect resend()?
		args = codecs or []
		_aem.Application.__init__(self, path, url, desc, *args)


host = Application()

