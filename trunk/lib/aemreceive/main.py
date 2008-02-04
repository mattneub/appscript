"""main -- Provides functions for installing and removing Apple event handlers in Python-based applications.

(C) 2005 HAS
"""

from StringIO import StringIO
from traceback import print_exc
import struct

import mactypes
import aem
from aem import ae, kae

from typedefs import buildDefs
from handlererror import EventHandlerError


if struct.pack("h", 1) == '\x00\x01': # host is big-endian
	fourCharCode = lambda code: code
else: # host is small-endian
	fourCharCode = lambda code: code[::-1]


######################################################################
# PUBLIC
######################################################################

kMissingValue = ae.AECreateDesc(kae.typeType, fourCharCode('msng')) # 'missing value' constant


class Codecs(aem.Codecs):
	"""Default Codecs for aemreceive; same as aem.Codecs except that None is packed as 'missing value' constant instead of 'null'.
	"""
	def __init__(self):
		aem.Codecs.__init__(self)
		self.encoders[type(None)] = lambda value, codecs: kMissingValue


######################################################################
# PRIVATE
######################################################################
# Constants

_standardCodecs = Codecs()  # default codecs for unpacking incoming events' attribute and parameter data and packing result/error data into reply events

_eventAttributes = [
	(kae.keyTransactionIDAttr, 'TransactionID'),
	(kae.keyReturnIDAttr, 'ReturnID'),
	(kae.keyEventClassAttr, 'EventClass'),
	(kae.keyEventIDAttr, 'EventID'),
	(kae.keyAddressAttr, 'Address'),
	(kae.keyOptionalKeywordAttr, 'OptionalKeyword'),
	(kae.keyTimeoutAttr, 'Timeout'),
	(kae.keyInteractLevelAttr, 'InteractLevel'),
	(kae.keyEventSourceAttr, 'EventSource'),
	(kae.keyOriginalAddressAttr, 'OriginalAddress'),
	(kae.keyAcceptTimeoutAttr, 'AcceptTimeout'),
	(kae.keyReplyRequestedAttr, 'ReplyRequested'),
	(kae.keySubjectAttr, 'Subject'),
	(kae.enumConsiderations, 'Ignore'), # deprecated; use enumConsidsAndIgnores instead
	(kae.enumConsidsAndIgnores, 'ConsiderIgnore'),
	]

_attributesArgName = 'attributes'


#######
# Used when installing event handler callbacks

def _processArgDefs(callback, argDefs, eventCode):
	total = callback.func_code.co_argcount
	argNames = callback.func_code.co_varnames[:total]
	optionalArgNames = argNames[total - len(callback.func_defaults or []):]
	includeAttributes = argNames and argNames[0] == _attributesArgName
	if includeAttributes:
		argNames = argNames[1:]
	if len(argNames) != len(argDefs):
		raise TypeError, "Can't install event handler %r: expected %i parameters but function %r has %i." % (eventCode, len(argNames), callback.__name__, len(argDefs))
	requiredArgDefs = []
	optionalArgDefs = {}
	for (code, argName, datatypes) in argDefs:
		if argName not in argNames:
			raise TypeError, "Can't install event handler %r: function %r has no parameter named %r." % (eventCode, callback.__name__, argName)
		datatypes = buildDefs(datatypes)		
		if argName in optionalArgNames:
			optionalArgDefs[code] = (argName, datatypes)
		else:
			requiredArgDefs.append((code, argName, datatypes))
	return includeAttributes, requiredArgDefs, optionalArgDefs
	

#######
# Used to unpack attributes and parameters of incoming events 

def _unpackEventAttributes(event):
	attributes = {}
	for code, name in _eventAttributes:
		try:
			attributes[name] = _standardCodecs.unpack(event.AEGetAttributeDesc(code, kae.typeWildCard))
		except Exception:
			pass
	return attributes


def _unpackValue(value, datatypes, codecs):
	success, result = datatypes.AEM_unpack(value, codecs)
	if success:
		return result
	else:
		raise result


def _unpackAppleEvent(event, includeAttributes, requiredArgDefs, optionalArgDefs, codecs):
	desiredResultType = None
	if includeAttributes:
		kargs = {_attributesArgName: _unpackEventAttributes(event)}
	else:
		kargs = {}
	params = dict([event.AEGetNthDesc(i + 1, kae.typeWildCard) for i in range(event.AECountItems())])
	for code, argName, datatypes in requiredArgDefs:
		try:
			argValue = params.pop(code)
		except KeyError:
			raise EventHandlerError(-1721, "Required parameter %r is missing." % code)
		else:
			kargs[argName] = _unpackValue(argValue, datatypes, codecs)
	for code, argValue in params.items():
		try:
			argName, datatypes = optionalArgDefs[code]
		except KeyError: # (note: SIG says that any unrecognised parameters should be ignored)
			if code == kae.keyAERequestedType: # event contains a 'desired result type' parameter but callback doesn't handle this explicitly, so have callback wrapper attempt to perform coercion automatically when packing result
				desiredResultType = argValue
		else:
			kargs[argName] = _unpackValue(argValue, datatypes, codecs)
	return kargs, desiredResultType


#######
# Used to pack result/error data into reply events

def _packAppleEvent(desc, parameters, codecs=_standardCodecs):
	if desc.type == kae.typeAppleEvent: # only pack and return a result/error where event has requested one
		for key, value in parameters.items():
			desc.AEPutParamDesc(key, codecs.pack(value))


#######
# Wrap user-defined callback function with automatic data unpacking/packing and error handling

def makeCallbackWrapper(callback, eventCode, parameterDefinitions, codecs):
	includeAttributes, requiredArgDefs, optionalArgDefs = _processArgDefs(callback, parameterDefinitions, eventCode)
	def wrapper(requestDesc, replyDesc):
		try:
			kargs, desiredResultType = _unpackAppleEvent(requestDesc, includeAttributes, requiredArgDefs, optionalArgDefs, codecs)
			reply = callback(**kargs)
			if desiredResultType:
				try:
					reply = codecs.pack(reply).AECoerceDesc(desiredResultType)
				except: # TO DECIDE: should we raise coercion error -1700 here, or return value as-is? (latter is safest if we can't find out)
					pass
			if reply is not None:
				_packAppleEvent(replyDesc, {kae.keyAEResult: reply}, codecs)
		except EventHandlerError, err: # unpacking failed, so send an error message back to client
			_packAppleEvent(replyDesc, err.get())
		except: # an untrapped (i.e. unexpected) error occurred, so construct an error message for caller's benefit then rethrow error
			s = StringIO()
			print_exc(file=s)
			_packAppleEvent(replyDesc, {
					kae.keyErrorNumber: -10000, # Apple event handler failed
					kae.keyErrorString: 'An internal error occurred: untrapped exception in AE handler %r.\n%s' % (eventCode, s.getvalue())
					})
			s.close()
			raise # re-raise error to be caught by application
	return wrapper


######################################################################
# PUBLIC
######################################################################

def installeventhandler(callback, eventCode, *parameterDefinitions, **kargs):
	"""Install an Apple event handler."""
	codecs = kargs.pop('codecs', _standardCodecs)
	ae.AEInstallEventHandler(eventCode[:4], eventCode[4:], 
			makeCallbackWrapper(callback, eventCode, parameterDefinitions, codecs))

def removeeventhandler(eventCode):
	"""Remove an installed Apple event handler."""
	ae.AERemoveEventHandler(eventCode[:4], eventCode[4:])

def installcoercionhandler(callback, fromType, toType):
	"""Install an AEDesc coercion handler."""
	ae.AEInstallCoercionHandler(fromType, toType, callback)

def removecoercionhandler(fromType, toType):
	"""Remove an installed AEDesc coercion handler."""
	ae.AERemoveCoercionHandler(fromType, toType)


######################################################################
# PRIVATE
######################################################################
# Install various xxxx-to-unicode coercions if the OS (10.2, 10.3) doesn't already provide them

def _coerceTypeAndEnum(desc, toType):
	return _standardCodecs.pack(unicode(fourCharCode(desc.data)))

def _coerceBoolAndNum(desc, toType):
	return desc.AECoerceDesc('TEXT').AECoerceDesc('utxt')

def _coerceFileTypes(desc, toType):
	return desc.AECoerceDesc('furl').AECoerceDesc('utxt')

_extraCoercions = [
		(aem.AEType('utxt'), kae.typeType, _coerceTypeAndEnum),
		(aem.AEEnum('yes '), kae.typeEnumerated, _coerceTypeAndEnum),
		(True, kae.typeBoolean, _coerceBoolAndNum),
		(3, kae.typeInteger, _coerceBoolAndNum),
		(3.1, kae.typeFloat, _coerceBoolAndNum),
#		(mactypes.File('/').fsalias, kae.typeAlias, _coerceFileTypes),
#		(mactypes.File('/').fsref, kae.typeFSRef, _coerceFileTypes),
#		(mactypes.File('/').fsspec, kae.typeFSS, _coerceFileTypes),
		]


for testVal, fromType, func in _extraCoercions:
	try:
		_standardCodecs.pack(testVal).AECoerceDesc(kae.typeUnicodeText)
	except ae.MacOSError, err:
		if err[0] == -1700:
			try:
				installcoercionhandler(func, fromType, kae.typeUnicodeText)
			except:
				pass
		else:
			raise
