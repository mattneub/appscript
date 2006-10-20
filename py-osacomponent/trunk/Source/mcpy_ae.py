"""mcpy_ae.py -- Supports sending and receiving of Apple events in MacPythonOSA scripts; see also mcpy_aemodule.

(C) 2005 HAS

--------------------------------------------------------------------------------
"""

# TO DO: call callActive() at regular intervals; probably need a separate thread to do this

# TO DO: stdout, stderr (log command = <event ascrcmnt>)
# TO DO: redo event handler system to use a handler registry. Allow users to install raw handlers directly using aemreceive-style install function. When incoming event is received, check this registry for an event handler. If one is not found, use command/event terminology from host application to find a function with corresponding terminology-based name and add that to handler registry, then call it.


from sys import exc_info, stdout, stderr
from CarbonX.AE import AECreateDesc, AEDesc

from aem.send.connect import currentapp

from mcpy_constants import *
import mcpy_support
import mcpy_store
import mcpy_pack
import mcpy_error

######################################################################
# PRIVATE
######################################################################

_kRawAEHandlerPrefix = 'ae_'

_kEventAttributes = [
	(keyTransactionIDAttr, 'TransactionID'),
	(keyReturnIDAttr, 'ReturnID'),
	(keyEventClassAttr, 'EventClass'),
	(keyEventIDAttr, 'EventID'),
	(keyAddressAttr, 'Address'),
	(keyOptionalKeywordAttr, 'OptionalKeyword'),
	(keyTimeoutAttr, 'Timeout'),
	(keyInteractLevelAttr, 'InteractLevel'),
	(keyEventSourceAttr, 'EventSource'),
	(keyOriginalAddressAttr, 'OriginalAddress'),
	(keyAcceptTimeoutAttr, 'AcceptTimeout'),
	]

#######

def _aeCodeToIdentifier(s):
	r = ''
	for c in s:
		if c in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789':
			r += c
		else:
			r += '_%2.0x' % ord(c)
	return _kRawAEHandlerPrefix + r


def _unpackAppleEvent(desc):
	attributes, parameters = {}, {}
	for key, name in _kEventAttributes:
		try:
			attributes[name] = mcpy_pack.unpack(desc.AEGetAttributeDesc(key, typeWildCard))
		except:
			pass
	for i in range(desc.AECountItems()):
		key, value = desc.AEGetNthDesc(i + 1, typeWildCard)
		parameters[key] = mcpy_pack.unpack(value)
	return attributes, parameters


######################################################################
# PUBLIC
######################################################################

###################################
# Calling client's callbacks
###################################

# Following values are get and set by mcpy_controller (note: should be maintained on a per-component instance basis):

activeProc = (mcpy_support.defaultActiveProc(), 0)
createProc = (mcpy_support.defaultCreateAppleEventProc(), 0)
sendProc = (mcpy_support.defaultSendProc(), 0)
resumeDispatchProc = (mcpy_support.defaultResumeDispatchProc(), 0)

#######

def callActive():
	"""callActive() -> OSErr errorNum
	
		While compiling/running a script, controller should periodically call this to yield control to the client, allowing to perform other housekeeping tasks. Upon return, controller should check return value (OSErr) to see if client has returned an error; a non-zero result (e.g. -128 = user cancelled), means compilation/execution should halt.
	"""
	return mcpy_support.invokeActiveUPP(*activeProc)


def createAE(eventClass, eventID, target, returnID, transactionID):
	"""createAE(OSType eventClass, OSType eventID, AEAddressDesc target, AEReturnID returnID, AETransactionID transactionID) -> AppleEvent theAppleEvent
		Use this instead of CarbonX.AE.AECreateAppleEvent() to create Apple event descs.
	"""
	return mcpy_support.invokeCreateAppleEventUPP(eventClass, eventID, target, returnID, transactionID, *createProc)


def sendAE(theAppleEvent, sendMode, timeOutInTicks):
	"""sendAE(AppleEvent theAppleEvent, AESendMode sendMode, AESendPriority sendPriority, long timeOutInTicks) -> AppleEvent result
		Use this instead of CarbonX.AE.AEDesc.AECreateAppleEvent() to send Apple event descs.
	"""
	return mcpy_support.invokeSendUPP(theAppleEvent, sendMode, 0, timeOutInTicks, *sendProc)


def redispatchAE(theAppleEvent):
	"""redispatchAE(AppleEvent theAppleEvent) -> AppleEvent result
	
		Use this to pass an event to the application without going through its special dispatch tables again (which could result in a circular call if the special AE handler passes the event to the script). e.g. A script applet would install aevtquit handlers in both special and regular dispatch tables, so that an incoming event is handled first by the special handler which attempts to pass it to the attached script. If the script has a quit handler then it can control whether or not the app quits by either continuing the event so it passes to the app's regular dispatch table and is handled there or by returning. If the script doesn't handle the quit event then the special handler would send it on to the regular handler itself.
	
		kOSAUseStandardDispatch -- Used in the resumeDispatchProc parameter of OSASetResumeDispatchProc and OSAGetResumeDispatchProc to indicate that the event is dispatched using standard Apple event dispatching.
		kOSANoDispatch -- Used in the resumeDispatchProc parameter of OSASetResumeDispatchProc to dispatch the event using standard Apple event dispatching.
		kOSADontUsePhac -- Used in the refCon parameter of OSASetResumeDispatchProc to dispatch the event using standard Apple event dispatching, excluding the special handler table.
	"""
	return mcpy_support.invokeEventHandlerUPP(theAppleEvent, *resumeDispatchProc)


###################################
# Handle Apple events
###################################

def handleEvent(theAppleEvent, contextID, modeFlags):
	# TO DO: modeFlags support
	"""
	kOSAModeNeverInteract/kOSAModeCanInteract/kOSAModeAlwaysInteract
			| kOSAModeDontReconnect

			| kOSAModeCantSwitchLayer | kOSAModeDoRecord
			| kOSAModeDispatchToDirectObject -- This mode flag may be passed to OSAExecuteEvent (page 15) to cause the event to be dispatched to the direct object of the event. The direct object (or subject attribute if the direct object is a non-object specifier) will be resolved, and the resulting script object will be the recipient of the message. The context argument to OSAExecuteEvent (page 15) will serve as the root of the lookup/resolution process.
			| kOSAModeDontGetDataForArguments -- This mode flag may be passed to OSAExecuteEvent (page 15) to indicate that components do not have to get the data of object specifier arguments.
	"""
	atts, params = _unpackAppleEvent(theAppleEvent)
	eventCode = atts['EventClass'].code + atts['EventID'].code
	# BEGIN TEST
	if 0:
		print '\tEvent: %r' % eventCode
		print '\tAttributes:'
		for _, name in _kEventAttributes:
			if atts.has_key(name):
				if isinstance(atts[name], AEDesc):
					val = '<%r %r>' % (atts[name].type, atts[name].data)
				else:
					val = `atts[name]`
				print '\t\t%s: %s' % (name, val)
		print '\tParameters:'
		for name, val in params.items():
			print '\t\t%r %r' % (name, val)
	# END TEST
	# TO DO: this code will probably move to script to allow it to handle terminology; TO CHECK: should event terms be component instance level, script level, or both?
	script = mcpy_store.getScript(contextID)
	# handle raw AE event
	handler = script.getEventHandler(_aeCodeToIdentifier(eventCode))
	if params.has_key(keyDirectObject):
		direct = [params.pop(keyDirectObject)]
	else:
		direct = []
	kargs = {}
	for name, val in params.items():
		kargs[_aeCodeToIdentifier(name)] = val
	print 'Calling %s() with direct arg: %r, kargs: %r' % (handler.__name__, direct, kargs) # TEST
	try:
		result = handler(*direct, **kargs)
	except:
		script.raiseScriptError("Script's event handler raised an error.")
	print 'Result: %r' % (result,) # TEST
	return result


def packReply(desc, parameters):
	print '\tREPLY: %r\n' % parameters # TEST
	for key, value in parameters.items():
		desc.AEPutParamDesc(key, mcpy_pack.pack(value))


###################################
# Default target application
###################################

# TO DO: users should be able to use app() as target, where app() uses the _defaultTarget AEDesc (TO DECIDE: how should terminology be handled for this?)

_defaultTarget = currentapp

def setDefaultTarget(target):
	if target.type == typeNull:
		target = currentapp
	_defaultTarget = target

def getDefaultTarget():
	return _defaultTarget

