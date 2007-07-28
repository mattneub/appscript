"""send -- Construct and send Apple events.

(C) 2005 HAS
"""

from CarbonX.AE import AECreateAppleEvent, AECreateDesc
from CarbonX import kAE
import MacOS

from aem.types import Codecs
from errors import errorMessage

__all__ = ['CommandError', 'Event']

######################################################################
# PRIVATE
######################################################################

_defaultCodecs = Codecs() # used to unpack application errors and, optionally, return values

# Following Cocoa Scripting error descriptions taken from:
# http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/NSScriptCommand.html
# http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/NSScriptObjectSpecifier.html

_cocoaErrorDescriptions = (
		('NSReceiverEvaluationScriptError', 'The object or objects specified by the direct parameter to a command could not be found.'),
		('NSKeySpecifierEvaluationScriptError', 'The object or objects specified by a key (for commands that support key specifiers) could not be found.'),
		('NSArgumentEvaluationScriptError', 'The object specified by an argument could not be found.'),
		('NSReceiversCantHandleCommandScriptError', "The receivers don't support the command sent to them."),
		('NSRequiredArgumentsMissingScriptError', 'An argument (or more than one argument) is missing.'),
		('NSArgumentsWrongScriptError', 'An argument (or more than one argument) is of the wrong type or is otherwise invalid.'),
		('NSUnknownKeyScriptError', 'An unidentified error occurred; indicates an error in the scripting support of your application.'),
		('NSInternalScriptError', 'An unidentified internal error occurred; indicates an error in the scripting support of your application.'),
		('NSOperationNotSupportedForKeyScriptError', 'The implementation of a scripting command signaled an error.'),
		('NSCannotCreateScriptCommandError', 'Could not create the script command; an invalid or unrecognized Apple event was received.'),
		('NSNoSpecifierError', 'No error encountered.'),
		('NSNoTopLevelContainersSpecifierError', 'Someone called evaluate with nil.'),
		('NSContainerSpecifierError', 'Error evaluating container specifier.'),
		('NSUnknownKeySpecifierError', 'Receivers do not understand the key.'),
		('NSInvalidIndexSpecifierError', 'Index out of bounds.'),
		('NSInternalSpecifierError', 'Other internal error.'),
		('NSOperationNotSupportedForKeySpecifierError', 'Attempt made to perform an unsupported operation on some key.'),
		)

######################################################################
# PUBLIC
######################################################################


class Event(object):
	"""Represents an Apple event (serialised message)."""
	
	def __init__(self, address, event, params={}, atts={}, transaction=kAE.kAnyTransactionID, 
			returnid= kAE.kAutoGenerateReturnID, codecs=_defaultCodecs):
		"""Called by aem.send.__init__.Application.event(); users shouldn't instantiate this class themselves.
			address : AEAddressDesc -- the target application
			event : str -- 8-letter code indicating event's class and id, e.g. 'coregetd'
			params : dict -- a dict of form {AE_code:anything,...} containing zero or more event parameters (message arguments)
			atts : dict -- a dict of form {AE_code:anything,...} containing zero or more event attributes (event info)
			transaction : int -- transaction number (default = kAnyTransactionID)
			returnid : int  -- reply event's ID (default = kAutoGenerateReturnID)
			codecs : Codecs -- user can provide custom parameter & result encoder/decoder (default = standard codecs); supplied by Application class
		"""
		self._eventCode = event
		self._codecs = codecs
		self.AEM_event = self._createAppleEvent(event[:4], event[4:], address, returnid, transaction)
		for key, value in atts.items():
			self.AEM_event.AEPutAttributeDesc(key, codecs.pack(value))
		for key, value in params.items():
			self.AEM_event.AEPutParamDesc(key, codecs.pack(value))
	
	# Hooks
	
	_createAppleEvent = AECreateAppleEvent
	
	def _sendAppleEvent(self, flags, timeout):
		"""Hook method; may be overridden to modify event sending."""
		#return self.AEM_event.AESendMessage(flags, timeout)
		return self.AEM_event.SendMessageThreadSafe(flags, timeout)
	
	# Public
	
	def send(self, timeout=kAE.kAEDefaultTimeout, flags= kAE.kAECanSwitchLayer + kAE.kAEWaitReply):
		"""Send this Apple event (may be called any number of times).
			timeout : int | aem.k.DefaultTimeout | aem.k.NoTimeout -- number of ticks to wait for target process to reply before raising timeout error (default=DefaultTimeout)
			flags : int -- bitwise flags [1] indicating how target process should handle event (default=WaitReply)
			Result : anything -- value returned by application, if any
			
			[1] aem.k provides the following constants for convenience:
			
				[ aem.k.NoReply | aem.k.QueueReply | aem.k.WaitReply ]
				[ aem.k.DontReconnect ]
				[ aem.k.WantReceipt ]
				[ aem.k.NeverInteract | aem.k.CanInteract | aem.k.AlwaysInteract ]
				[ aem.k.CanSwitchLayer ]
		"""
		try:
			replyEvent = self._sendAppleEvent(flags, timeout)
		except MacOS.Error, err: # an OS-level error occurred
			if not (self._eventCode == 'aevtquit' and err[0] == -609): # Ignore invalid connection error (-609) when quitting
				raise CommandError(err[0], err.args[1:] and err[1] or '', None)
		else: # decode application's reply, if any
			if replyEvent.type != kAE.typeNull:
				eventResult = dict([replyEvent.AEGetNthDesc(i + 1, kAE.typeWildCard) 
						for i in range(replyEvent.AECountItems())])
				# note: while Apple docs say that both keyErrorNumber and keyErrorString should be
				# tested for when determining if an error has occurred, AppleScript tests for keyErrorNumber
				# only, so do the same here for compatibility
				if eventResult.has_key(kAE.keyErrorNumber): # an application-level error occurred
					# note: uses standard codecs to unpack error info to ensure consistent conversion
					eNum = _defaultCodecs.unpack(eventResult[kAE.keyErrorNumber])
					if eNum != 0: # Stupid Finder returns non-error error number and message for successful move/duplicate command, so just ignore it
						eMsg = eventResult.get(kAE.keyErrorString)
						if eMsg:
							eMsg = _defaultCodecs.unpack(eMsg)
						raise CommandError(eNum, eMsg, replyEvent)
				if eventResult.has_key(kAE.keyAEResult): # application has returned a value
					# note: unpack result with [optionally] user-specified codecs, allowing clients to customise unpacking (e.g. appscript)
					return self._codecs.unpack(eventResult[kAE.keyAEResult])



######################################################################


class CommandError(MacOS.Error):
	"""Represents an error message returned by application/Apple Event Manager.
	
		Attributes:
			number : int -- MacOS error number
			message : str | None -- application error message, if any
			raw : AppleEvent | None -- raw reply event, in case alternate/additional processing of error info is required, or None if error occurred while outgoing event was being sent
	"""
	
	def __init__(self, number, message, raw):
		MacOS.Error.__init__(self, *(message and [number, message] or [number]))
		self.number, self.message, self.raw = number, message, raw
	
	def __repr__(self):
		return "aem.CommandError(%r, %r, %r)" % (self.number, self.message, self.raw)
		
	def __int__(self):
		return self.number
	
	def __str__(self):
		message = self.message
		if self.number > 0:
			for name, description in _cocoaErrorDescriptions:
				if message.startswith(name):
					message = '%s (%s)' % (message, description)
					break
		return "CommandError %i: %s" % (self.number, message or errorMessage(self.number))

