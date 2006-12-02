"""aem.send -- Send Apple events to local and remote applications.

(C) 2005 HAS
"""

from CarbonX import kAE
from CarbonX.AE import AEDesc

from aem.types import Codecs

import connect
from send import *

import constants as k # re-export

__all__ = ['Application', 'CommandError', 'k', 'Event', 'launch']

######################################################################
# PRIVATE
######################################################################

_defaultCodecs = Codecs()

######################################################################
# PUBLIC
######################################################################

launch = connect.launchapp # should this be Application class method to avoid top-level namespace pollution? ditto for run(), open(files)

class Application:
	"""Target application for Apple events."""
	
	_Event = Event # Application subclasses can override this attribute (normally with a subclass of the standard aem.send.Event class) to have the event() method return a different class instance; simpler than overriding the event() method

	_transaction = _kAnyTransactionID = kAE.kAnyTransactionID # (we need to keep a local copy of this constant to avoid upsetting Application.__del__() at cleanup time, otherwise it may be disposed of before __del__() has a chance to use it)
	
	def __init__(self, path=None, url=None, desc=None, codecs= _defaultCodecs):
		"""
			path : string | None -- full path to local application
			url : string | None -- url for remote process
			desc : AEAddressDesc | None -- AEAddressDesc for application
			codecs : Codecs -- used to convert Python values to AEDescs and vice-versa
			
			Notes: 
				- If no path, url or aedesc is given, target will be 'current application'.
				- If path is given, application will be launched automatically; if url or desc is given, user is responsible for ensuring application is running before sending it events.
		"""
		self._codecs = codecs
		self._path = path
		if path:
			self._address = connect.localapp(path)
			self._identity = (path, 0, 0, 0)
		elif url:
			self._address = connect.remoteapp(url)
			self._identity = (0, url, 0, 0)
		elif desc:
			self._address = desc
			self._identity = (0, 0, desc.type, desc.data)
		else:
			self._address = connect.currentapp
	
	def __eq__(self, val):
		return self.__class__ == val.__class__ and self._identity == val._identity
	
	def __ne__(self, val):
		return not self == val
	
	def __hash__(self):
		return hash(self._identity)
	
	def __del__(self):
		if self._transaction != self._kAnyTransactionID: # If user forgot to close a transaction before throwing away the Application object that opened it, try to close it for them. Otherwise application will be left in mid-transaction, preventing anyone else from using it.
			self.endtransaction()
	
	##
	
	def isrunning(self):
		"""Is application running? 
		
		Note: this only works for Application objects specified by path, not by URL or AEDesc.
		"""
		return connect.isrunning(self._path)
	
	def reconnect(self):
		"""If application has quit since this Application object was created, its AEAddressDesc is no longer valid so this Application object will not work even when application is restarted. reconnect() will update this Application object's AEAddressDesc so it's valid again.
		
		Note: this only works for Application objects specified by path, not by URL or AEDesc. Also, any Event objects created prior to calling reconnect() will still be invalid.
		"""
		if self._path:
			self._address = connect.localapp(self._path)
	
	##
	
	def event(self, event, params={}, atts={}, returnid=kAE.kAutoGenerateReturnID, codecs=None):
		"""Construct an Apple event.
			event  : str -- 8-letter code indicating event's class, e.g. 'coregetd'
			params : dict -- a dict of form {AE_code:anything,...} containing zero or more event parameters (message arguments)
			atts : dict -- a dict of form {AE_code:anything,...} containing zero or more event attributes (event info)
			returnid : int  -- reply event's ID (default = kAutoGenerateReturnID)
			codecs : Codecs | None -- custom codecs to use when packing/unpacking this event; if None, codecs supplied in Application constructor are used
		"""
		return self._Event(self._address, event, params, atts, self._transaction, returnid, codecs or self._codecs)
	
	def starttransaction(self):
		"""Start a transaction."""
		if self._transaction != self._kAnyTransactionID:
			raise RuntimeError, "Transaction is already active."
		self._transaction = self._Event(self._address, 'miscbegi', codecs=_defaultCodecs).send()
	
	def endtransaction(self):
		"""End the current transaction."""
		if self._transaction == self._kAnyTransactionID:
			raise RuntimeError, "No transaction is active."
		self._Event(self._address, 'miscendt', transaction=self._transaction).send()
		self._transaction = self._kAnyTransactionID

