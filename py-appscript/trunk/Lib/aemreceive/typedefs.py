"""typedefs -- Used by client in installeventhandler() to specify the required type(s) of each parameter of an Apple event handler. These classes are also responsible for coercing and unpacking event parameters on behalf of unpackevent.py.

(C) 2005 HAS
"""

from CarbonX import kAE
import MacOS

from aem import AEType

from handlererror import EventHandlerError

# TO DO: build decent error messages pinpointing problem.

######################################################################
# PUBLIC
######################################################################

class ArgDef: 
	"""Abstract base class, used internally for typechecking."""
	
	def AEM_unpack(self, desc, codecs):
		try:
			return self._unpack(desc, codecs)
		except MacOS.Error, e:
			number, message = e[0], e.args[1:] and e[1] or None
			if number == -1700: # coercion error
				return False, EventHandlerError(number, message, object=desc, coercion= AEType(self.AEM_code))
			else:
				return False, EventHandlerError(number, message, object=desc)


#######
# Concrete classes

class ArgDesc(ArgDef):
	def AEM_unpack(self, desc, codecs):
		return desc

kArgDesc = ArgDesc()


class ArgType(ArgDef):
	"""
		Describes a simple AE type, e.g. ArgType('utxt') = a value of typeUnicodeText
		
		- aemreceive will attempt to coerce descriptors of other types to the specified type before unpacking.
	"""
	def __init__(self, code):
		"""
			code : str -- a 4-character AE code
		"""
		if not isinstance(code, str) and len(code) == 4:
			raise TypeError, "Invalid AE type code: %r" % code
		self.AEM_code = code
	
	def _unpack(self, desc, codecs):
		return True, codecs.unpack(desc.AECoerceDesc(self.AEM_code))


class ArgEnum(ArgDef):
	"""
		Describes an AE enumeration, taking one or more enumerator codes in its constructor, 
			e.g. ArgEnum('yes ', 'no  ', 'ask ') = AEEnum('yes ') | AEEnum('no  ') | AEEnum('ask ')
		
		- aemreceive will attempt to coerce descriptors of other types to typeEnumerated before unpacking.
		- aemreceive will raise error -1704 if the given enum if not one of those specified.
	"""
	AEM_code = kAE.typeEnumerated
	
	def __init__(self, *codes):
		"""
			*codes : str -- one or more 4-character AE codes
		"""
		if not codes:
			raise TypeError, "__init__() requires at least 2 arguments"
		for code in codes:
			if not isinstance(code, str) and len(code) == 4:
				raise TypeError, "Invalid AE enum code: %r" % code
		self._codes = codes
	
	def _unpack(self, desc, codecs):
		desc = desc.AECoerceDesc(kAE.typeEnumerated)
		if desc.data not in self._codes:
			return False, EventHandlerError(-1704, "Bad enumerator.", desc, AEType(kAE.typeEnumerated))
		return True, codecs.unpack(desc)


class ArgListOf(ArgDef):
	"""
		Describes a list of values of given type(s). Takes a single ArgType/ArgEnum or list of ArgTypes/ArgEnums as its only argument.
	"""
	
	def __init__(self, datatype):
		"""
			datatype : ArgType | ArgEnum | ArgMultiChoice -- (strings/lists will be converted to ArgType/ArgMultiChoice automatically)
		"""
		self._datatype = buildDefs(datatype)
	
	def _unpack(self, desc, codecs):
		desc = desc.AECoerceDesc(kAE.typeAEList)
		result = []
		for i in range(1, desc.AECountItems() + 1):
			succeeded, value = self._datatype.AEM_unpack(desc.AEGetNthDesc(i, kAE.typeWildCard)[1], codecs)
			if not succeeded:
				return False, value
			result.append(value)
		return True, result


class ArgMultiChoice(ArgDef):
	"""
		Used to encapsulate multiple acceptable types. If event parameter's type matches one of those given, will unpack exactly; otherwise will attempt to coerce and upack with each in turn until one succeeds or all fail.
	"""
	AEM_code = None # TO DECIDE

	def __init__(self, *datatypes):
		# datatypes = a list of ArgDef subclasses
		self._exactTypeDefs = {} # When unpacking an AEDesc, if its type exactly matches one of the unpackers provided then use that
		self._exactEnumDefs = [] # (all enums share same type, typeEnumerated, so we store them in this list instead of dict above)
		self._datatypesByOrder = [] # If no exact match exists, try coercing and unpacking with each unpacker provided until one succeeds
		if not datatypes:
			raise TypeError, "No argument type definitions given."
		for datatype in datatypes:
			datatype = buildDefs(datatype)
			self._datatypesByOrder.append(datatype)
			if datatype.AEM_code == kAE.typeEnumerated:
				self._exactEnumDefs.append(datatype)
			else:
				self._exactTypeDefs[datatype.AEM_code] = datatype
	
	def AEM_unpack(self, desc, codecs):
		# If AEDesc's type exactly matches one of the supplied unpackers (not including typeEnumerated), use that
		if self._exactTypeDefs.has_key(desc.type):
			succeeded, value = self._exactTypeDefs[desc.type].AEM_unpack(desc, codecs)
			if succeeded:
				return True, value
		# If AEDesc is an enumerator, try to unpack it exactly
		if desc.type == kAE.typeEnumerated:
			for datatype in self._exactEnumDefs:
				succeeded, value = datatype.AEM_unpack(desc, codecs)
				if succeeded:
					return True, value
		# No exact conversion, so apply each unpacker in turn until one of them manages to coerce and unpack the value
		for datatype in self._datatypesByOrder:
			succeeded, value = datatype.AEM_unpack(desc, codecs)
			if succeeded:
				return True, value
		# Unable to unpack value as any of the desired types
		return False, value # returns last failed coercion details


#######


def buildDefs(datatype):
	if isinstance(datatype, ArgDef):
		return datatype
	elif isinstance(datatype, list): # user may supply ArgMultiChoice as list for convenience
		return ArgMultiChoice(*datatype)
	else: # user may supply ArgType as 4-char code string for convenience
		return ArgType(datatype)


