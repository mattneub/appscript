"""main -- Provides functions for installing and removing Apple event handlers in Python-based applications.

(C) 2005 HAS
"""

from StringIO import StringIO
from traceback import print_exc
from CarbonX import AE, kAE
import MacOS

import macfile
import aem

from typedefs import buildDefs
from handlererror import EventHandlerError


######################################################################
# PUBLIC
######################################################################

kMissingValue = AE.AECreateDesc(kAE.typeType, 'msng') # 'missing value' constant


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
	(aem.k.TransactionID, 'TransactionID'),
	(aem.k.ReturnID, 'ReturnID'),
	(aem.k.EventClass, 'EventClass'),
	(aem.k.EventID, 'EventID'),
	(aem.k.Address, 'Address'),
	(aem.k.OptionalKeyword, 'OptionalKeyword'),
	(aem.k.Timeout, 'Timeout'),
	(aem.k.InteractLevel, 'InteractLevel'),
	(aem.k.EventSource, 'EventSource'),
	(aem.k.OriginalAddress, 'OriginalAddress'),
	(aem.k.AcceptTimeout, 'AcceptTimeout'),
	(aem.k.Subject, 'Subject'),
	(aem.k.Ignore, 'Ignore'),
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
			attributes[name] = _standardCodecs.unpack(event.AEGetAttributeDesc(code, kAE.typeWildCard))
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
	params = dict([event.AEGetNthDesc(i + 1, kAE.typeWildCard) for i in range(event.AECountItems())])
	for code, argName, datatypes in requiredArgDefs:
		try:
			argValue = params.pop(code)
			if argValue.type == kAE.typeNull:
				raise KeyError
		except KeyError:
			raise EventHandlerError(-1721, "Required parameter %r is missing." % code)
		else:
			kargs[argName] = _unpackValue(argValue, datatypes, codecs)
	for code, argValue in params.items():
		if argValue.type != kAE.typeNull:
			try:
				argName, datatypes = optionalArgDefs[code]
			except KeyError:
				if code == kAE.keyAERequestedType: # event contains a 'desired result type' parameter but callback doesn't handle this explicitly, so have callback wrapper attempt to perform coercion automatically when packing result
					desiredResultType = argValue
				else:
					raise EventHandlerError(-1721, "Parameter %r is not supported for this command." % code)
			else:
				kargs[argName] = _unpackValue(argValue, datatypes, codecs)
	return kargs, desiredResultType


#######
# Used to pack result/error data into reply events

def _packAppleEvent(desc, parameters, codecs=_standardCodecs):
	if desc.type == kAE.typeAppleEvent: # only pack and return a result/error where event has requested one
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
				_packAppleEvent(replyDesc, {kAE.keyAEResult: reply}, codecs)
		except EventHandlerError, err: # unpacking failed, so send an error message back to client
			_packAppleEvent(replyDesc, err.get())
		except: # an untrapped (i.e. unexpected) error occurred, so construct an error message for caller's benefit then rethrow error
			s = StringIO()
			print_exc(file=s)
			_packAppleEvent(replyDesc, {
					kAE.keyErrorNumber: -10000, # Apple event handler failed
					kAE.keyErrorString: 'An internal error occurred: untrapped exception in AE handler %r.\n%s' % (eventCode, s.getvalue())
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
	AE.AEInstallEventHandler(eventCode[:4], eventCode[4:], 
			makeCallbackWrapper(callback, eventCode, parameterDefinitions, codecs))

def removeeventhandler(eventCode):
	"""Remove an installed Apple event handler."""
	AE.AERemoveEventHandler(eventCode[:4], eventCode[4:])

def installcoercionhandler(callback, fromType, toType):
	"""Install an AEDesc coercion handler."""
	AE.AEInstallCoercionHandler(fromType, toType, callback)

def removecoercionhandler(fromType, toType):
	"""Remove an installed AEDesc coercion handler."""
	AE.AERemoveCoercionHandler(fromType, toType)


######################################################################
# PRIVATE
######################################################################
# Install various xxxx-to-unicode coercions if the OS (10.2, 10.3) doesn't already provide them

def _coerceTypeAndEnum(desc, toType):
	return _standardCodecs.pack(unicode(desc.data))

def _coerceBoolAndNum(desc, toType):
	return desc.AECoerceDesc('TEXT').AECoerceDesc('utxt')

def _coerceFileTypes(desc, toType):
	return desc.AECoerceDesc('furl').AECoerceDesc('utxt')

_extraCoercions = [
		(aem.AEType('utxt'), kAE.typeType, _coerceTypeAndEnum),
		(aem.AEEnum('yes '), kAE.typeEnumerated, _coerceTypeAndEnum),
		(True, kAE.typeBoolean, _coerceBoolAndNum),
		(3, kAE.typeInteger, _coerceBoolAndNum),
		(3.1, kAE.typeFloat, _coerceBoolAndNum),
		(macfile.File('/').fsalias, kAE.typeAlias, _coerceFileTypes),
		(macfile.File('/').fsref, kAE.typeFSRef, _coerceFileTypes),
		(macfile.File('/').fsspec, kAE.typeFSS, _coerceFileTypes),
		]


for testVal, fromType, func in _extraCoercions:
	try:
		_standardCodecs.pack(testVal).AECoerceDesc(kAE.typeUnicodeText)
	except MacOS.Error, err:
		if err[0] == -1700:
			try:
				installcoercionhandler(func, fromType, kAE.typeUnicodeText)
			except:
				pass
		else:
			raise
