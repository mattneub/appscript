"""mcpy_controller.py -- Handles OSA component calls.

(C) 2005 HAS

--------------------------------------------------------------------------------

Notes:

- This module is essentially the hub of the MacPythonOSA implementation. The C wrapper simply forwards OSA calls sent by client to here.
"""

# TO DO: handle modeFlags and desiredTypes
# TO DO: lots of other things

# TO DECIDE: how to handle context IDs and delegation?

from CarbonX.AE import AEInstallEventHandler, AERemoveEventHandler

from aem import AEType

from mcpy_constants import *
import mcpy_support # various functions exported from C wrapper
import mcpy_store # stores all client scripts belonging to a single component instance
import mcpy_pack # pack and unpack AEDescs
import mcpy_ae # send and receive Apple events; see also mcpy_aemodule
import mcpy_error # raise OSA errors


######################################################################
# TEST
######################################################################

print '\tmcpy_controller module loading...'
from sys import path
#print '\t\tModule search paths:\n\t\t\t', '\n\t\t\t'.join([`s` for s in path])


######################################################################
# PRIVATE
######################################################################

_kMacPythonOSAName = 'MacPythonOSA'
_kMacPythonOSACode = 'McPy'

_kOSASourceFileRef = 'fref'

_scriptInfoSelectors = { # Specify which script information is set or returned. 
	_kOSASourceFileRef: 'scriptFileRef',
	kOSAScriptIsModified: 'scriptIsModified',
	kOSAScriptIsTypeCompiledScript: 'scriptIsTypeCompiledScript',
	kOSAScriptIsTypeScriptValue: 'scriptIsTypeScriptValue',
	kOSAScriptIsTypeScriptContext: 'scriptIsTypeScriptContext',
	kOSAScriptBestType: 'scriptBestType',
	kOSACanGetSource: 'canGetSource',
	kASHasOpenHandler: 'hasOpenHandler', # 'hsod'; defined by AS component; used by applets and supported here to keep them happy (and because it's useful)
	}


#######

def _load(scriptDesc, modeFlags):
	if scriptDesc.type != typeOSAGenericStorage or mcpy_support.getStorageType(scriptDesc) != _kMacPythonOSACode:
		raise mcpy_error.raiseError(errOSABadStorageType, "Can't load script: bad storage type (%r)." % mcpy_support.getStorageType(scriptDesc))
	mcpy_support.removeStorageType(scriptDesc)
	return mcpy_store.ScriptObject.makeFromAEDesc(
			scriptDesc, 
			modeFlags & kOSAModePreventGetSource)


def _compile(sourceData, modeFlags): # Used by OSACompileExecute, OSADoScript; OSACompile does its own thing as it additionally supports compiling into existing contexts
	source = sourceData.AECoerceDesc(typeChar).data
	return mcpy_store.ScriptObject.makeFromSource(source, modeFlags)


def _executeScriptReturningID(script, contextID, modeFlags):
	result = script.run(contextID, modeFlags)
	return mcpy_store.addValue(result)


def _display(value, desiredType, modeFlags):
	if not (modeFlags & kOSAModeDisplayForHumans and isinstance(value, basestring)):
		value = repr(value)
	return mcpy_pack.packAsType(value, desiredType)


######################################################################
# PUBLIC - Required scripting component routines
######################################################################

###################################
# Saving and Loading Script Data
###################################

def handleOSAStore(scriptID, desiredType, modeFlags):
	"""handleOSAStore(OSAID scriptID, DescType desiredType, long modeFlags) -> AEDesc scriptData
		
		Serialise a MacPythonOSA script as an AEDesc of typeScript that can be sent to other applications, saved to file, etc.
		
		scriptID : int -- ID of script to store
		desiredType : typeOSAGenericStorage
		modeFlags : kOSAModeNull | kOSAModePreventGetSource | kOSAModeDontStoreParent -- don't include source code and/or parent script
		Result : AEDesc -- an AEDesc of typeScript with 'McPy' trailer
		
		Notes:
			- kOSAModePreventGetSource isn't very secure since the compiled code object can always be run through a Python decompiler.
			- kOSAModeDontStoreParent currently doesn't do anything.
	"""
	print '\thandleOSAStore(scriptID=%r, desiredType=%r, modeFlags=%4.4X)' % (scriptID, desiredType, modeFlags) # TEST
	if desiredType != typeOSAGenericStorage:
		raise mcpy_error.raiseError(errOSABadStorageType, "Can't store script %i: unknown storage type (%r)." % (scriptID, desiredType))
	scriptDesc = mcpy_store.getScript(scriptID).asScriptDesc(
					modeFlags & kOSAModePreventGetSource, 
					modeFlags & kOSAModeDontStoreParent)
	mcpy_support.addStorageType(scriptDesc, _kMacPythonOSACode)
	return scriptDesc


def handleOSALoad(scriptData, modeFlags):
	"""handleOSALoad(AEDesc scriptData, long modeFlags) -> OSAID scriptID
	
		De-serialise an AEDesc of typeScript, converting it back into an executable MacPythonOSA script.
		
		scriptData : AEDesc -- an AEDesc of typeScript with 'McPy' trailer
		modeFlags :  kOSAModeNull | kOSAModePreventGetSource -- don't include source code
		Result : int -- ID of loaded script
	"""
	print '\thandleOSALoad(scriptData=%r, modeFlags=%4.4X)' % (mcpy_pack.unpack(scriptData), modeFlags) # TEST
	return mcpy_store.setScript(kOSANullScript, _load(scriptData, modeFlags))


###################################
# Executing and Disposing of Scripts
###################################

def handleOSAExecute(scriptID, contextID, modeFlags):
	"""handleOSAExecute(OSAID scriptID, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID
	
		Execute a script by calling its run() handler.
	
		scriptID : int
		contextID : int
		modeFlags : kOSAModeNeverInteract/kOSAModeCanInteract/kOSAModeAlwaysInteract | 
				kOSAModeDontReconnect | kOSAModeCantSwitchLayer | kOSAModeDoRecord
		Result : int -- ID of value returned by run()
				
	"""
	print '\thandleOSAExecute(scriptID=%r, contextID=%r, modeFlags=%4.4X)' % (scriptID, contextID, modeFlags) # TEST
	return _executeScriptReturningID(mcpy_store.getScript(scriptID), contextID, modeFlags)


def handleOSADisplay(scriptValueID, desiredType, modeFlags):
	"""handleOSADisplay(OSAID scriptValueID, DescType desiredType, long modeFlags) -> AEDesc result
		
		Get a script's result in human-readable format.
	
		scriptValueID : int
		desiredType : str -- 4-letter code for AE text type, e.g. typeChar, typeStyledText, typeUnicodeText
		modeFlags : kOSAModeNull | kOSAModeDisplayForHumans -- beautify output, e.g. quotes may be left off of string values, long lists may have elipses
	"""
	print '\thandleOSADisplay(scriptValueID=%r, desiredType=%r, modeFlags=%4.4X)' % (scriptValueID, desiredType, modeFlags)
	return _display(mcpy_store.getValue(scriptValueID).value, desiredType, modeFlags)


def handleOSAScriptError(selector, desiredType):
	"""handleOSAScriptError(OSType selector, DescType desiredType) -> AEDesc errorDesc
	"""
	print '\thandleOSAScriptError(selector=%r, desiredType=%r)' % (selector, desiredType)
	if selector == kOSAErrorNumber:
		result = mcpy_error.scriptErrorNumber() # (as typeShortInteger)
	elif selector == kOSAErrorMessage:
		result = mcpy_error.scriptErrorMessage() # (as typeChar or another text descriptor type)
	elif selector == kOSAErrorBriefMessage:
		result = mcpy_error.briefScriptErrorMessage() # (as typeChar or another text descriptor type)
	elif selector == kOSAErrorApp:
		result = mcpy_error.errorApp() # (as typeProcessSerialNumber or a text descriptor type, e.g. typeChar)
	elif selector == kOSAErrorPartialResult: # return partial result, if any (apparently, all OSA components should support this, though no idea why)
		result = None # (as typeBest/typeWildCard)
	elif selector == kOSAErrorOffendingObject: # returns info about offending object, if any
		result = None # (as typeObjectSpecifier/typeBest/typeWildCard)
	elif selector == kOSAErrorExpectedType: # determines the type expected by a coercion operation if a type error occurred
		# TO CHECK: do we need this? (i.e. does OSACoerceToDesc() need it?) We can hopefully ignore it if it's only used for script errors; only thing that might cause problems is if client script raises MacOS.Error(-1700) if/when we decide to forward those. These may cause client to request this value - not sure what the result of this will be.)
		result = None # TO DO: AEType(toType) # (as typeType)
	elif selector == kOSAErrorRange:
		startPos, endPos = mcpy_error.scriptErrorRange()
		result = {AEType(keyOSASourceStart): startPos, AEType(keyOSASourceEnd): endPos} # (as typeOSAErrorRange)
	else:
		mcpy_error.raiseError(errOSABadSelector)
	return mcpy_pack.packAsType(result, desiredType)


def handleOSADispose(scriptID):
	"""handleOSADispose(OSAID scriptID) -> None"""
	print '\thandleOSADispose(scriptID=%r)' % scriptID
	mcpy_store.deleteItem(scriptID)


###################################
# Setting and Getting Script Information
###################################

def handleOSASetScriptInfo(scriptID, selector, value):
	"""handleOSASetScriptInfo(OSAID scriptID, OSType selector, long value) -> None"""
	print '\thandleOSASetScriptInfo(scriptID=%r, selector=%r, value=%r)' % (scriptID, selector, value)
	setattr(mcpy_store.getScript(scriptID), _scriptInfoSelectors[selector], value) # TO DO: which selectors should be write-only, if any?


def handleOSAGetScriptInfo(scriptID, selector):
	"""handleOSAGetScriptInfo(OSAID scriptID, OSType selector) -> long result"""
	print '\thandleOSAGetScriptInfo(scriptID=%r, selector=%r)' % (scriptID, selector)
	v=getattr(mcpy_store.getScript(scriptID), _scriptInfoSelectors[selector])
	print `selector`, `v`
	return int(v) # TO FIX: need to convert bestType to int (use struct.pack, or just construct AEDesc directly)


###################################
# Manipulating the Active Function
###################################

def handleOSASetActiveProc(activeProc, refCon):
	"""handleOSASetActiveProc(OSAActiveUPP activeProc, long refCon) -> None"""
	print '\thandleOSASetActiveProc(activeProc=0x%8.8X, refCon=%r)' % (mcpy_support.cobjectToInt(activeProc), refCon)
	mcpy_ae.activeProc = (activeProc, refCon)


def handleOSAGetActiveProc():
	"""handleOSASetActiveProc() -> OSAActiveUPP activeProc, long refCon"""
	print '\thandleOSASetActiveProc()'
	return mcpy_ae.activeProc


######################################################################
# PUBLIC - Optional scripting component routines
######################################################################

###################################
# Compiling Scripts
###################################

def handleOSAScriptingComponentName():
	"""handleOSAScriptingComponentName() -> AEDesc resultingScriptingComponentName"""
	print '\thandleOSAScriptingComponentName()'
	return mcpy_pack.pack(_kMacPythonOSAName)


def handleOSACompile(sourceData, modeFlags, previousScriptID):
	"""handleOSACompile(AEDesc sourceData, long modeFlags, OSAID previousScriptID) -> OSAID resultingScriptID
	
		sourceData : AEDesc -- text descriptor containing Python source code
		modeFlags : kOSAModeNull | kOSAModePreventGetSource | kOSAModeCompileIntoContext | kOSAModeAugmentContext | ... -- omit source code from compiled script object; make new context/add to existing one; additional flags used in AESend [1]
		previousScriptID : int/kOSANullScript -- ID to store the compiled script under, or kOSANullScript to create a new ID
		Result : int -- script ID of compiled script
		
		[1] Other flags:
			- these should be added to sendMode argument of AESend():
				kOSAModeNeverInteract/kOSAModeCanInteract/kOSAModeAlwaysInteract | kOSAModeDontReconnect
			- kOSAModeCantSwitchLayer -- omit kAECanSwitchLayer when calling AESend()
			- kOSAModeDoRecord -- omit kAEDontRecord when calling AESend()
	"""
	print '\thandleOSACompile(sourceData=%r, modeFlags=%4.4X, previousScriptID=%r)' % (mcpy_pack.unpack(sourceData), modeFlags, previousScriptID)
	source = sourceData.AECoerceDesc(typeChar).data # note: for now we just deal in ASCII source
	if modeFlags & kOSAModeAugmentContext:
		mcpy_store.getScript(previousScriptID).augmentContext(source) # TO CHECK: how should new modeFlags be applied to existing context, if at all?
		return previousScriptID
	else:
		# TO DO: note: this completely replaces existing ScriptObject instance, losing any values supplied by OSASetScriptInfo; not sure if this is correct behaviour, or if previous info state should be retained # note: SE2 doesn't care anyway; it just creates a new script each time
		script = mcpy_store.ScriptObject.makeFromSource(source, modeFlags)
		return mcpy_store.setScript(previousScriptID, script)


def handleOSACopyID(fromID, toID):
	"""handleOSACopyID(OSAID fromID, OSAID toID) -> OSAID toID
	
		fromID : int
		toID : int/kOSANullScript
		Result : int
	"""
	print '\thandleOSACopyID(fromID=%r, toID=%r)' % (fromID, toID)
	# TO DO (TO CHECK: should this create a deepcopy of script at fromID and insert it at toID?)


###################################
# Getting Source Data
###################################

def handleOSAGetSource(scriptID, desiredType):
	"""handleOSAGetSource(OSAID scriptID, DescType desiredType) -> AEDesc resultingSourceData"""
	print '\thandleOSAGetSource(scriptID=%r, desiredType=%r)' % (scriptID, desiredType)
	# TO CHECK: how to format result (Apple API docs are confusing)
	print 'RES', mcpy_pack.packAsType(mcpy_store.getScript(scriptID).source, desiredType)
	return mcpy_pack.packAsType(mcpy_store.getScript(scriptID).source, desiredType)


###################################
# Coercing Script Values
###################################

# Note: after SE calls OSADisplay it requests the original  value (i.e. coerce to '****'). Maybe so it can display any Unicode values correctly? Anyway, we oblige it otherwise it sulks and refuses to display the result of handleOSADisplay(). All seems a bit weird; would be more logical to call OSADisplay again to get the original value, though maybe the AS component doesn't like that.

def handleOSACoerceFromDesc(scriptData, modeFlags):
	"""handleOSACoerceFromDesc(AEDesc scriptData, long modeFlags) -> OSAID resultingScriptValueID"""
	print '\thandleOSACoerceFromDesc(scriptData=%r, modeFlags=%4.4X)' % (mcpy_pack.unpack(scriptData), modeFlags)
	# TO CHECK: how to handle modeFlags (Apple API docs are really confusing)
	# note: if Apple event is passed (e.g. when SE is generating an Event Log), I think we're supposed to create a script from it
	from CarbonX.AE import AEDesc # TEST
	if isinstance(mcpy_pack.unpack(scriptData), AEDesc): # TEST
		if scriptData.type == 'aevt':
			print 'AEVT:', mcpy_ae._unpackAppleEvent(scriptData)
		else:
			print '\tTYPE: %r, DATA: %r' % (scriptData.type, scriptData.data)
	return mcpy_store.addValue(scriptData) # note: not unpacking here # TO DO: probably should unpack here, returning error if there's a problem


def handleOSACoerceToDesc(scriptValueID, desiredType, modeFlags):
	"""handleOSACoerceToDesc(OSAID scriptValueID, DescType desiredType, long modeFlags) -> AEDesc result
	
		modeFlags : kOSAModeNull | kOSAModeFullyQualifyDescriptors -- indicates that the resulting descriptor should be fully qualified (i.e. should include the root application reference)
	"""
	print '\thandleOSACoerceToDesc(scriptValueID=%r, desiredType=%r, modeFlags=%4.4X)' % (scriptValueID, desiredType, modeFlags)
	value = mcpy_store.getValue(scriptValueID).value # TO FIX: what if ID is for a script?
	try:
		print '\tcoercing value: %r' % (value,)
		return mcpy_pack.packAsType(value, desiredType)
	except:
		# TO DO: need to figure out how to handle coercion failures better as SE (as usual) throws a wobbly when trying to coerce the result of OSAExecute to displayable value and it's a non-coercible value.
		raise mcpy_error.raiseError(errOSACantCoerce, "\tCan't coerce value (%r) to desired type (%r)." % (value, desiredType))


###################################
# Manipulating the Create and Send Functions
###################################

def handleOSASetCreateProc(createProc, refCon):
	"""handleOSASetCreateProc(OSACreateAppleEventUPP createProc, long refCon) -> None
	"""
	print '\thandleOSASetCreateProc(createProc=0x%8.8X, refCon=%r)' % (mcpy_support.cobjectToInt(createProc), refCon) # TEST
	mcpy_ae.createProc = (createProc, refCon)


def handleOSAGetCreateProc():
	"""handleOSAGetCreateProc() -> OSACreateAppleEventUPP createProc, long refCon
	"""
	print '\thandleOSAGetCreateProc()' # TEST
	return mcpy_ae.createProc


def handleOSASetSendProc(sendProc, refCon):
	"""handleOSASetSendProc(OSACreateAppleEventUPP sendProc, long refCon) -> None
	"""
	print '\thandleOSASetSendProc(sendProc=0x%8.8X, refCon=%r)' % (mcpy_support.cobjectToInt(sendProc), refCon) # TEST
	mcpy_ae.sendProc = (sendProc, refCon)


def handleOSAGetSendProc():
	"""handleOSAGetSendProc() -> OSACreateAppleEventUPP sendProc, long refCon
	"""
	print '\thandleOSAGetSendProc()' # TEST
	return mcpy_ae.sendProc


def handleOSASetDefaultTarget(target):
	"""handleOSASetDefaultTarget(AEAddressDesc target) -> None
	
		target : AEDesc -- an AEAddressDesc, or AEDesc of typeNull if target should be current application
	"""
	print '\thandleOSASetDefaultTarget(target=%r)' % target # TEST
	mcpy_ae.setDefaultTarget(target)


###################################
# Recording Scripts
###################################

"""
kAEStartRecording -- Event ID for an event sent by a scripting component to the recording process (or to any running process on the local computer), but handled by the Apple Event Manager. The Apple Event Manager responds by turning on recording and sending a Recording On event to all running processes on the local computer. If sent by process serial number (PSN), this event must be addressed using a real PSN; it should never be sent to an address specified as kCurrentProcess.

kAEStopRecording - Event ID for an event sent by a scripting component to the recording process (or to any running process on the local computer), but handled by the Apple Event Manager. The Apple Event Manager responds by sending a Recording Off event to all running processes on the local computer. If sent by a PSN, this event must be addressed using a real PSN; it should never be sent to an address specified as kCurrentProcess.

kAENotifyRecording -- Wildcard event class and event ID handled by a recording process in order to receive and record copies of recordable events sent to it by the Apple Event Manager. Scripting components install a handler for this event on behalf of a recording process when recording is turned on and remove the handler when recording is turned off.
"""

def _recordingCallback(*args, **kargs):
	"""
	TO DO: send client a Recorded Text event
	Event class kOSASuite
	Event ID kOSARecordedText
	Required parameter
		Keyword: keyDirectObject
		Descriptor type: typeStyledText or any other text descriptor type
		Data: Decompiled source data for recorded event
	Description Sent by a scripting component to a recording process for each event recorded after a call to OSAStartRecording
	
	This will kinda suck for us, since we really want recorded events appended to run() function, not the body of the script, so they'll only execute at runtime, not compilation/initialisation time.
	
	Presumably we're also supposed to add recorded events to compiledScriptToModifyID.
	"""
	print 'RECORD:', args, kargs # TEST


def handleOSAStartRecording(compiledScriptToModifyID):
	"""handleOSAStartRecording(OSAID compiledScriptToModifyID) -> OSAID compiledScriptToModifyID"""
	print '\thandleOSAStartRecording(compiledScriptToModifyID=%r)' % compiledScriptToModifyID # TEST
	AEInstallEventHandler(kAENotifyRecording, kAENotifyRecording, _recordingCallback)
	# TO DO:  send ?|kAEStartRecording event to client app (try kCoreEventClass)
	return 9999 # TO DO


def handleOSAStopRecording(compiledScriptID):
	"""handleOSAStopRecording(OSAID compiledScriptID) -> None"""
	print '\thandleOSAStopRecording(compiledScriptID=%r)' % compiledScriptID # TEST
	# TO DO: send ?|kAEStopRecording event to client app
	AERemoveEventHandler(kAENotifyRecording, kAENotifyRecording)


###################################
# Executing Scripts in One Step
###################################

def handleOSALoadExecute(scriptData, contextID, modeFlags):
	"""handleOSALoadExecute(AEDesc scriptData, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID
	
		Loads and executes a script in a single step rather than calling OSALoad() and OSAExecute().
	
		Mode flags:
			kOSAModeNeverInteract | kOSAModeCanInteract | kOSAModeAlwaysInteract | 
			kOSAModeDontReconnect | kOSAModeCantSwitchLayer | kOSAModeDoRecord
	"""
	return _executeScriptReturningID(_load(scriptData, modeFlags), contextID, modeFlags)


def handleOSACompileExecute(sourceData, contextID, modeFlags):
	"""handleOSACompileExecute(AEDesc sourceData, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID
	
		Compiles and executes a script in a single step rather than calling OSACompile() and OSAExecute().
	
		Mode flags:
			kOSAModeNeverInteract | kOSAModeCanInteract | kOSAModeAlwaysInteract | 
			kOSAModeDontReconnect | kOSAModeCantSwitchLayer | kOSAModeDoRecord
	"""
	return _executeScriptReturningID(_compile(sourceData, modeFlags), contextID, modeFlags)


def handleOSADoScript(sourceData, contextID, desiredType, modeFlags):
	"""handleOSADoScript(AEDesc sourceData, OSAID contextID, DescType desiredType, long modeFlags) -> AEDesc resultingText
	
		Compiles and executes a script and convert the resulting script value to text in a single step rather than calling OSACompile(), OSAExecute(), and OSADisplay().
	
		Mode flags:
			kOSAModeNeverInteract | kOSAModeCanInteract | kOSAModeAlwaysInteract | 
			kOSAModeDontReconnect | kOSAModeCantSwitchLayer | kOSAModeDoRecord |
			kOSAModeDisplayForHumans
	"""
	return _display(_compile(sourceData, modeFlags).run(contextID, modeFlags), desiredType, modeFlags)


###################################
# Using Script Contexts to Handle Apple Events
###################################

def handleOSASetResumeDispatchProc(resumeDispatchProc, refCon):
	"""handleOSASetResumeDispatchProc(AEEventHandlerUPP resumeDispatchProc, long refCon) -> None
	
		resumeDispatchProc used by script when it handles an event and wants to 'forward' the event to the application for additional handling; e.g. an applet's script might intercept incoming aevtquit events and only forward them to the applet shell once it's ok to quit.
	
		Notes:
			- resumeDispatchProc constants:
				kOSAUseStandardDispatch = kAEUseStandardDispatch = 0xFFFFFFFF # tells AEM to dispatch the event using standard Apple event dispatching
				kOSANoDispatch = kAENoDispatch = 0x00000000 # tells AEM that processing of event is complete and it does not need to be dispatched
			- refCon constant:
				kOSADontUsePhac = 1 # used in conjunction with kOSAUseStandardDispatch; causes AEM to bypass special event handlers and send event straight to standard event handlers (avoids possible circular calls where special event handler would send the event straight back to the script that just forwarded it)
	"""
	print '\thandleOSASetResumeDispatchProc(resumeDispatchProc=0x%8.8X, refCon=%r)' % (mcpy_support.cobjectToInt(resumeDispatchProc), refCon) # TEST
	mcpy_ae.resumeDispatchProc = (resumeDispatchProc, refCon)


def handleOSAGetResumeDispatchProc():
	"""handleOSAGetResumeDispatchProc() -> AEEventHandlerUPP resumeDispatchProc, long refCon
	"""
	print '\thandleOSAGetResumeDispatchProc()' # TEST
	return mcpy_ae.resumeDispatchProc


def handleOSAExecuteEvent(theAppleEvent, contextID, modeFlags):
	"""handleOSAExecuteEvent(AppleEvent theAppleEvent, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID
	
		kOSAModeNeverInteract/kOSAModeCanInteract/kOSAModeAlwaysInteract
			| kOSAModeDontReconnect

			| kOSAModeCantSwitchLayer | kOSAModeDoRecord
			| kOSAModeDispatchToDirectObject -- This mode flag may be passed to OSAExecuteEvent (page 15) to cause the event to be dispatched to the direct object of the event. The direct object (or subject attribute if the direct object is a non-object specifier) will be resolved, and the resulting script object will be the recipient of the message. The context argument to OSAExecuteEvent (page 15) will serve as the root of the lookup/resolution process.
			| kOSAModeDontGetDataForArguments -- This mode flag may be passed to OSAExecuteEvent (page 15) to indicate that components do not have to get the data of object specifier arguments.
	"""
	print '\thandleOSAExecuteEvent(theAppleEvent=%r, contextID=%r, modeFlags=%r)' % (theAppleEvent, contextID, modeFlags) # TEST
	return mcpy_store.addValue(mcpy_ae.handleEvent(theAppleEvent, contextID, modeFlags))


def handleOSADoEvent(theAppleEvent, contextID, modeFlags, reply):
	"""handleOSADoEvent(AppleEvent theAppleEvent, OSAID contextID, long modeFlags, AppleEvent reply) -> None
	"""
	print '\thandleOSADoEvent(theAppleEvent=%r, contextID=%r, modeFlags=%r, reply=%r)' % (theAppleEvent, contextID, modeFlags, reply) # TEST
	try:
		result = {
				keyAEResult: mcpy_ae.handleEvent(theAppleEvent, contextID, modeFlags)}
	except mcpy_error.ScriptError:
		result = {
				keyErrorNumber: mcpy_error.scriptErrorNumber(), 
				keyErrorString: mcpy_error.scriptErrorMessage()}
	mcpy_ae.packReply(reply, result)


def handleOSAMakeContext(contextName, parentContext):
	"""handleOSAMakeContext(AEDesc contextName, OSAID parentContext) -> OSAID resultingContextID
	"""
	print '\thandleOSAMakeContext(contextName=%r, parentContext=%r)' % (contextName, parentContext) # TEST
	# TO DO


