"""reference -- High-level, terminology-driven wrapper for aem.types.objectspecifiers. 

Lots of syntactic sugar allows users to construct query-based references using familiar OO-like syntax.

(C) 2004 HAS"""

import struct, MacOS

from CarbonX import kAE, kOSA
from CarbonX.AE import AECreateList, AECreateDesc
import aem, mactypes, aem.types.objectspecifiers

from genericreference import GenericReference
import terminology
from terminology import kProperty, kElement
from referencerenderer import renderreference
from keywordwrapper import Keyword


######################################################################
# PRIVATE
######################################################################
# Codecs

_keyAECompOperator = aem.AEType(kAE.keyAECompOperator)
_keyAEObject1 = aem.AEType(kAE.keyAEObject1)
_keyAEObject2 = aem.AEType(kAE.keyAEObject2)

_kTypeCompDescriptorOperators = {
		kAE.kAEGreaterThan: 'AS__gt__',
		kAE.kAEGreaterThanEquals: 'AS__ge__',
		kAE.kAEEquals: 'AS__eq__',
		kAE.kAELessThan: 'AS__lt__',
		kAE.kAELessThanEquals: 'AS__le__',
		kAE.kAEBeginsWith: 'beginswith',
		kAE.kAEEndsWith: 'endswith',
		kAE.kAEContains: 'contains'
}


#######

_lowLevelCodecs = aem.Codecs()

# Terminology-aware pack/unpack functions used by the AppData class.
# These replace the default aem pack/unpack functions, which don't understand appscript Keyword and Reference objects.

_classKeyword = Keyword('class_')
_classType = aem.AEType('pcls')

def _packDict(val, codec):
	# Pack dictionary whose keys are strings (e.g. 'foo'), Keywords (e.g. k.name) or AETypes (e.g. AEType('pnam').
	record = AECreateList('', True)
	if val.has_key(_classKeyword) or val.has_key(_classType):
		# if hash contains a 'class' property containing a class name, coerce the AEDesc to that class
		newval = val.copy()
		if newval.has_key(_classKeyword):
			value = newval.pop(_classKeyword)
		else:
			value = newval.pop(_classType)
		if isinstance(value, Keyword): # get the corresponding AEType (assuming there is one)
			value = codec.typebyname.get(value.name, value)
		if isinstance(value, aem.AEType): # coerce the record to the desired type
			record = record.AECoerceDesc(value.code)
			val = newval
	usrf = None
	for key, value in val.items():
		if isinstance(key, Keyword):
			try:
				keyCode = codec.typebyname[key.AS_name].code
			except KeyError:
				raise KeyError, "Unknown Keyword: k.%s" % key.AS_name
			record.AEPutParamDesc(keyCode, codec.pack(value))
		elif isinstance(key, aem.AETypeBase): # AEType/AEProp (AEType is normally used in practice)
			record.AEPutParamDesc(key.code, codec.pack(value))
		else: # user-defined key (normally a string)
			if not usrf:
				usrf = AECreateList('', False)
			usrf.AEPutDesc(0, codec.pack(key))
			usrf.AEPutDesc(0, codec.pack(value))
	if usrf:
		record.AEPutParamDesc('usrf', usrf)
	return record


def _unpackAERecord(desc, codec):
	# Unpack typeAERecord,  converting record keys to Keyword objects (not AETypes) where possible.
	dct = {}
	for i in range(desc.AECountItems()):
		key, value = desc.AEGetNthDesc(i + 1, kAE.typeWildCard)
		if key == 'usrf':
			lst = codec.unpack(value)
			for i in range(0, len(lst), 2):
				dct[lst[i]] = lst[i+1]
		elif codec.typebycode.has_key(key):
			dct[codec.typebycode[key]] = codec.unpack(value)
		else:
			dct[aem.AEType(key)] = codec.unpack(value)
	return dct


def _unpackTypeOrEnum(desc, codecs):
	# Unpack typeType, typeEnum, typeProperty; replaces default aem decoders to convert types, enums, etc. to Keyword objects instead of AETypes, AEEnums, etc.
	aemValue = _lowLevelCodecs.unpack(desc)
	return codecs.typebycode.get(aemValue.code, aemValue)


def _unpackReference(desc, codecs):
	return Reference(codecs, _lowLevelCodecs.unpack(desc))


def _unpackCompDescriptor(desc, codecs): # TO DO: is this needed?
	# need to do some typechecking when unpacking 'contains' comparisons, so have to override the low-level unpacker
	rec = codecs.unpack(desc.AECoerceDesc(kAE.typeAERecord))
	operator = _kTypeCompDescriptorOperators[rec[_keyAECompOperator].code]
	op1 = rec[_keyAEObject1]
	op2 = rec[_keyAEObject2]
	if operator == 'contains':
		if isinstance(op1, Reference) and op1.AS_aemreference.AEM_root() == aem.its:
			return op1.contains(op2)
		elif isinstance(op2, Reference) and op2.AS_aemreference.AEM_root() == aem.its:
			return op2.isin(op1)
		else:
			return _lowLevelCodecs.unpack(desc)
	else:
		return getattr(op1, operator)(op2)

##

def _unpackApplicationByID(desc, codecs):
	return app(id=desc.data)

def _unpackApplicationByURL(desc, codecs):
	if desc.data.startswith('file'): # workaround for converting AEAddressDescs containing file:// URLs to application paths, since AEAddressDescs containing file URLs don't seem to work correctly
		return app(mactypes.File.makewithurl(desc.data).path)
	else: # presumably contains an eppc:// URL
		return app(url=desc.data)

def _unpackApplicationBySignature(desc, codecs):
	return app(creator=struct.pack('>L', struct.unpack('L', desc.data)[0]))

def _unpackApplicationByPID(desc, codecs):
	return app(pid=struct.unpack('L', desc.data)[0])

def _unpackApplicationByDesc(desc, codecs):
	return app(aemapp=aem.Application(desc=desc))

##

_appscriptEncoders = {
		dict: _packDict,
		}


_appscriptDecoders = {
		kAE.typeType: _unpackTypeOrEnum,
		kAE.typeEnumerated: _unpackTypeOrEnum,
		kAE.typeProperty: _unpackTypeOrEnum,
		kAE.typeAERecord: _unpackAERecord,
		kAE.typeObjectSpecifier: _unpackReference,
		kAE.typeInsertionLoc: _unpackReference,
		kAE.typeCompDescriptor: _unpackCompDescriptor,
		# AEAddressDesc types
		kAE.typeApplicationBundleID: _unpackApplicationByID,
		kAE.typeApplicationURL: _unpackApplicationByURL,
		kAE.typeApplSignature: _unpackApplicationBySignature,
		kAE.typeKernelProcessID: _unpackApplicationByPID,
		kAE.typeMachPort: _unpackApplicationByDesc,
		kAE.typeProcessSerialNumber: _unpackApplicationByDesc,
		}


######################################################################
# Application-specific data/codecs

class AppData(aem.Codecs):
	"""Provides application-specific:
		- aem.Application instance
		- name-code terminology translation tables
		- pack/unpack methods
		- help system
	"""
	
	def __init__(self, aemApplicationClass, constructor, identifier, terms):
		"""
			aemApplicationClass : class -- aem.Application or equivalent
			constructor : str -- indicates how to construct the aem.Application instance ('path', 'pid', 'url', 'aemapp', 'current')
			identifier : any -- value identifying the target application (its type is dependent on constructor parameter)
			terms : bool | module | tuple
		"""
		# initialise codecs
		aem.Codecs.__init__(self)
		self.encoders.update(_appscriptEncoders)
		self.decoders.update(_appscriptDecoders)
		# store parameters for later use
		self._aemApplicationClass = aemApplicationClass
		self.constructor, self.identifier = constructor, identifier
		self._terms = terms
	
	def connect(self):
		"""Initialises application target and terminology lookup tables.
		
		Called automatically the first time clients retrieve target, typebycode, typebyname,
		referencebycode, referencebyname; clients should not need to call it themselves.
		"""
		# initialise target (by default an aem.Application instance)
		if self.constructor == 'aemapp':
			self.target = self.identifier
		elif self.constructor == 'current':
			self.target = self._aemApplicationClass()
		else:
			self.target = self._aemApplicationClass(**{self.constructor: self.identifier})
		# initialise translation tables
		if self._terms == True: # obtain terminology from application
			self._terms = terminology.tablesforapp(self.target)
		elif self._terms == False: # use built-in terminology only (e.g. use this when running AppleScript applets)
			self._terms = terminology.defaulttables
		elif not isinstance(self._terms, tuple): # use user-supplied terminology module
			self._terms = terminology.tablesformodule(self._terms)
		self.typebycode, self.typebyname, self.referencebycode, self.referencebyname = self._terms
		return self
	
	target = property(lambda self: self.connect().target)
	typebycode = property(lambda self: self.connect().typebycode)
	typebyname = property(lambda self: self.connect().typebyname)
	referencebycode = property(lambda self: self.connect().referencebycode)
	referencebyname = property(lambda self: self.connect().referencebyname)

	def pack(self, data):
		if isinstance(data, GenericReference):
			data = data.AS_resolve(Reference, self)
		if isinstance(data, Reference):
			data = data.AS_aemreference
		elif isinstance(data, Keyword):
			try:
				data = self.typebyname[data.AS_name]
			except KeyError:
				raise KeyError, "Unknown Keyword: k.%s" % data.AS_name
		return aem.Codecs.pack(self, data)
		
	# Help system
	
	def help(self, flags, ref):
		# Stub method; initialises Help object and replaces itself with a real help() function the first time it's called.
		from helpsystem import Help
		helpObj = Help(terminology.aetesforapp(self.target), self.identifier or 'Current Application')
		self.help = lambda flags, ref: helpObj.help(flags, ref) # replace stub method with real help
		return self.help(flags, ref) # call real help. Note that help system is responsible for providing a return value (usually the same reference it was called upon, but it may modify this).


######################################################################
# Considering/ignoring constants

def _packUInt32(n): # used to pack csig attributes
	return AECreateDesc(kAE.typeUInt32, struct.pack('L', n))

# 'csig' attribute flags (see ASRegistry.h; note: there's no option for 'numeric strings' in 10.4)

_ignoreEnums = [
	(Keyword('case'), kOSA.kAECaseConsiderMask, kOSA.kAECaseIgnoreMask),
	(Keyword('diacriticals'), kOSA.kAEDiacriticConsiderMask, kOSA.kAEDiacriticIgnoreMask),
	(Keyword('whitespace'), kOSA.kAEWhiteSpaceConsiderMask, kOSA.kAEWhiteSpaceIgnoreMask),
	(Keyword('hyphens'), kOSA.kAEHyphensConsiderMask, kOSA.kAEHyphensIgnoreMask),
	(Keyword('expansion'), kOSA.kAEExpansionConsiderMask, kOSA.kAEExpansionIgnoreMask),
	(Keyword('punctuation'), kOSA.kAEPunctuationConsiderMask, kOSA.kAEPunctuationIgnoreMask),
	]

# default cons, csig attributes

_defaultConsiderations =  _lowLevelCodecs.pack([aem.AEEnum(kOSA.kAECase)])
_defaultConsidsAndIgnores = _packUInt32(kOSA.kAECaseIgnoreMask)


######################################################################
# Base class for references and commands

class _Base(object):
	# Base class for Command and Reference objects.
	def __init__(self, appdata):
		self.AS_appdata = appdata
		
	# Help system
	
	def help(self, flags='-t'): # add a help() method to all concrete app, reference and command objects
		"""Print help. Use help('-h') for more info."""
		return self.AS_appdata.help(flags, self)


######################################################################
# PUBLIC
######################################################################
# The Reference and Command classes are used to construct references and commands applying to those references

class Command(_Base):
	
	def __init__(self, appdata, aemreference, repr, name, info):
		_Base.__init__(self, appdata)
		self._aemreference, self._repr, self.AS_name = aemreference, repr, name
		self._code, self._labelledArgTerms = info
	
	def __repr__(self):
		return self._repr() + '.' + self.AS_name
	
	def __call__(self, *args, **kargs):
		keywordArgs = kargs.copy()
		if len(args) > 1:
			raise TypeError, "Command received more than one direct parameter %r." % (args,)
		# get user-specified timeout, if any
		timeout = int(keywordArgs.pop('timeout', 60)) # appscript's default is 60 sec
		if timeout <= 0:
			timeout = kAE.kNoTimeOut
		else:
			timeout *= 60 # convert to ticks
		# ignore application's reply?
		sendFlags = keywordArgs.pop('waitreply', True) and kAE.kAEWaitReply or kAE.kAENoReply
		atts, params = {'subj':None}, {}
		# add considering/ignoring attributes (note: most apps currently ignore these)
		ignoreOptions = keywordArgs.pop('ignore', None)
		if ignoreOptions is None:
			atts['cons'] = _defaultConsiderations # 'csig' obsoletes 'cons', but latter is retained for compatibility
			atts['csig'] = _defaultConsidsAndIgnores
		else:
			atts['cons'] = ignoreOptions
			csig = 0
			for option, considerMask, ignoreMask in _ignoreEnums:
				csig += option in ignoreOptions and ignoreMask or considerMask
			atts['csig'] = _packUInt32(csig)
		# optionally have application supply return value as specified type
		if keywordArgs.has_key('resulttype'):
			params['rtyp'] = keywordArgs.pop('resulttype')
		# add direct parameter, if any
		if args:
			params['----'] = args[0]
		# extract Apple event's labelled parameters, if any
		try:
			for name, value in keywordArgs.items():
				params[self._labelledArgTerms[name]] = value
		except KeyError:
			raise TypeError, 'Unknown keyword argument %r.' % name
		# apply special cases for certain commands (make, set, any command that takes target object specifier as its direct parameter); appscript provides these as a convenience to users, making its syntax more concise, OO-like and nicer to use
		if self._aemreference is not aem.app:
			if self._code == 'coresetd':
				# Special case: if ref.set(...) contains no 'to' argument, use direct argument for 'to' parameter and target reference for direct parameter
				if  params.has_key('----') and not params.has_key('data'):
					params['data'] = params['----']
					params['----'] = self._aemreference
				elif not params.has_key('----'):
					params['----'] = self._aemreference
				else:
					atts['subj'] = self._aemreference
			elif self._code == 'corecrel':
				# this next bit is a bit tricky: 
				# - While it should be possible to pack the target reference as a subject attribute, when the target is of typeInsertionLoc, CocoaScripting stupidly tries to coerce it to typeObjectSpecifier, which causes a coercion error.
				# - While it should be possible to pack the target reference as the 'at' parameter, some less-well-designed applications won't accept this and require it to be supplied as a subject attribute (i.e. how AppleScript supplies it).
				# One option is to follow the AppleScript approach and force users to always supply subject attributes as target references and 'at' parameters as 'at' parameters, but the syntax for the latter is clumsy and not backwards-compatible with a lot of existing appscript code (since earlier versions allowed the 'at' parameter to be given as the target reference). So for now we split the difference when deciding what to do with a target reference: if it's an insertion location then pack it as the 'at' parameter (where possible), otherwise pack it as the subject attribute (and if the application doesn't like that then it's up to the client to pack it as an 'at' parameter themselves).
				#
				# if ref.make(...) contains no 'at' argument and target is an insertion reference, use target reference for 'at' parameter...
				if isinstance(self._aemreference, aem.types.objectspecifiers.specifier.InsertionSpecifier) and not params.has_key('insh'):
					params['insh'] = self._aemreference
				else: # ...otherwise pack the target reference as the subject attribute
					atts['subj'] = self._aemreference
			elif params.has_key('----'):
				# if user has already supplied a direct parameter, pack that reference as the subject attribute
				atts['subj'] = self._aemreference
			else:
				# pack that reference as the direct parameter
				params['----'] = self._aemreference
		# build and send the Apple event, returning its result, if any
		try:
			return self.AS_appdata.target.event(self._code, params, atts, codecs=self.AS_appdata).send(timeout, sendFlags)
		except aem.CommandError, e:
			if e.number in [-600, -609] and self.AS_appdata.constructor == 'path': # event was sent to a local app for which we no longer have a valid address (i.e. the application has quit since this aem.Application object was made).
				# - If application is running under a new process id, we just update the aem.Application object and resend the event.
				# - If application isn't running, then we see if the event being sent is one of those allowed to relaunch the application (i.e. 'run' or 'launch'). If it is, the aplication is relaunched, the process id updated and the event resent; if not, the error is rethrown.
				if not self.AS_appdata.target.isrunning(self.AS_appdata.identifier):
					if self._code == 'ascrnoop':
						aem.Application.launch(self.AS_appdata.identifier) # relaunch app in background
					elif self._code != 'aevtoapp': # only 'launch' and 'run' are allowed to restart a local application that's been quit
						raise CommandError(self, (args, kargs), e)
				self.AS_appdata.target.reconnect() # update aem.Application object so it has a valid address for app
				try:
					return self.AS_appdata.target.event(self._code, params, atts, codecs=self.AS_appdata).send(timeout, sendFlags)
				except Exception, e:
					pass
			elif e.number == -1708 and self._code == 'ascrnoop': # squelch 'not handled' error for 'launch' event
				return
			raise CommandError(self, (args, kargs), e)
	
	def AS_formatCommand(self, args):
		return '%r(%s)' % (self, ', '.join(['%r' % (v,) for v in args[0]] + ['%s=%r' % (k, v) for (k, v) in args[1].items()]))
		

######################################################################

class Reference(_Base):
	# A general-purpose class used to construct all real appscript references. It's a simple wrapper around an aem reference that provides syntactic sugar and terminology->AE code conversion. Calling a reference-building method returns a new Reference object containing the new reference, except where it would create a structurally invalid reference (e.g. ref.items[1]['foo']), in which case the aem reference will raise an AttributeError.
	
	def __init__(self, appdata, aemreference):
		_Base.__init__(self, appdata)
		self.AS_aemreference = aemreference # an aem app-/con-/its-based reference
	
	def _resolveRangeBoundary(self, selector, valueIfNone): # used by __getitem__() below
		if selector is None:
			selector = valueIfNone 
		if isinstance(selector, GenericReference):
			return selector.AS_resolve(Reference, self.AS_appdata).AS_aemreference
		elif isinstance(selector, Reference):
			return selector.AS_aemreference
		elif isinstance(selector, basestring):
			return aem.con.elements(self.AS_aemreference.AEM_want).byname(selector)
		else:
			return aem.con.elements(self.AS_aemreference.AEM_want).byindex(selector)
	
	# Full references are hashable and comparable for equality. (Generic references aren't, however, as __eq__() is overridden for other purposes, but the user shouldn't be troubled by this given how generic refs are normally used.)
	
	def __eq__(self, val):
		return self.__class__ == val.__class__ and \
				self.AS_appdata.target == val.AS_appdata.target and \
				self.AS_aemreference == val.AS_aemreference
	
	def __ne__(self, val):
		return not self == val
	
	def __hash__(self):
		val = hash((self.AS_aemreference, self.AS_appdata.target))
		self.__hash__ = lambda: val
		return val
	
	def __iter__(self): # dummy-proof
		raise RuntimeError, "Can't iterate an application reference; use ref.get() to return a list of references first."
	
	def __repr__(self): # references display as themselves
		val = renderreference(self.AS_appdata, self.AS_aemreference)
		self.__repr__ = lambda: val
		return val
	
	# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
	
	def __getattr__(self, name):
		try:
			selectorType, code = self.AS_appdata.referencebyname[name]
		except KeyError:
			raise AttributeError, "Unknown property, element or command: %r" % name
		if selectorType == kProperty:
			return Reference(self.AS_appdata, self.AS_aemreference.property(code))
		elif selectorType == kElement:
			return Reference(self.AS_appdata, self.AS_aemreference.elements(code))
		else: # kCommand (note: 'code' variable here actually contains a (code, args) struct)
			return Command(self.AS_appdata, self.AS_aemreference, self.__repr__, name, code)
	
	def __getitem__(self, selector): # by name/index
		if isinstance(selector, basestring):
			return Reference(self.AS_appdata, self.AS_aemreference.byname(selector))
		elif isinstance(selector, GenericReference):
			return Reference(self.AS_appdata, self.AS_aemreference.byfilter(
					selector.AS_resolve(Reference, self.AS_appdata).AS_aemreference))
		elif isinstance(selector, (Reference, aem.types.objectspecifiers.Test)):
			return Reference(self.AS_appdata, self.AS_aemreference.byfilter(selector))
		elif isinstance(selector, slice):
			return Reference(self.AS_appdata, self.AS_aemreference.byrange(
					self._resolveRangeBoundary(selector.start, 1),
					self._resolveRangeBoundary(selector.stop, -1)))
		else:
			return Reference(self.AS_appdata, self.AS_aemreference.byindex(selector))
	
	first = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.first))
	middle = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.middle))
	last = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.last))
	any = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.any))
	beginning = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.beginning))
	end = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.end))
	before = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.before))
	after = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.after))
	
	def previous(self, klass):
		try:
			aemtype = self.AS_appdata.typebyname[klass.AS_name]
		except AttributeError: # can't get klass.AS_name
			raise TypeError, "Not a keyword: %r" % name
		except KeyError: # can't get typebyname[<name>]
			raise ValueError, "Unknown class: %r" % name
		return Reference(self.AS_appdata, self.AS_aemreference.previous(aemtype.code))
	
	def next(self, klass):
		try:
			aemtype = self.AS_appdata.typebyname[klass.AS_name]
		except AttributeError: # can't get klass.AS_name
			raise TypeError, "Not a keyword: %r" % name
		except KeyError: # can't get typebyname[<name>]
			raise ValueError, "Unknown class: %r" % name
		return Reference(self.AS_appdata, self.AS_aemreference.next(aemtype.code))
	
	def ID(self, id):
		return Reference(self.AS_appdata, self.AS_aemreference.byid(id))
	
	def __call__(self, *args, **kargs):
		return self.get(*args, **kargs)
	
	# Following methods will be called by its-based generic references when resolving themselves into real references; end-users and other clients shouldn't call them directly.
	
	def AS__gt__(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.gt(operand))
	
	def AS__ge__(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.ge(operand))
	
	def AS__eq__(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.eq(operand))
	
	def AS__ne__(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.ne(operand))
	
	def AS__lt__(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.lt(operand))
	
	def AS__le__(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.le(operand))
	
	def beginswith(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.beginswith(operand))
	
	def endswith(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.endswith(operand))
	
	def contains(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.contains(operand))
	
	def isin(self, operand):
		return Reference(self.AS_appdata, self.AS_aemreference.isin(operand))
	
	def doesnotbeginwith(self, operand):
		return self.beginswith(operand).NOT
	
	def doesnotendwith(self, operand):
		return self.endswith(operand).NOT
	
	def doesnotcontain(self, operand):
		return self.contains(operand).NOT
	
	def isnotin(self, operand):
		return self.isin(operand).NOT
	
	def AND(self, *operands):
		return Reference(self.AS_appdata, self.AS_aemreference.AND(*operands))
		
	def OR(self, *operands):
		return Reference(self.AS_appdata, self.AS_aemreference.OR(*operands))
	
	NOT = property(lambda self: Reference(self.AS_appdata, self.AS_aemreference.NOT))


######################################################################
# The Application class is not directly instantiated by the user; instead, they call the GenericApp instance and this returns the real Application instance. This allows users to write generic app-based references, e.g. app.documents.end, as well as real ones, e.g. app('TextEdit').documents.end

class Application(Reference):
	"""Creates objects for communicating with scriptable applications."""
	
	_Application = aem.Application # overridable hook; appscript.Application subclasses can modify creating and/or sending Apple events by using custom aem.Application and aem.Event classes # Note: subclassing this class is now a bit trickier due to introduction of generic 'app'; clients need to import this class directly, subclass it, and then create their own GenericApp instance to use in place of the standard version.
	
	def __init__(self, name=None, id=None, creator=None, pid=None, url=None, aemapp=None, terms=True):
		"""
			app(name=None, id=None, creator=None, pid=None, url=None, terms=True)
				name : str -- name or path of application, e.g. 'TextEdit', 'TextEdit.app', '/Applications/Textedit.app'
				id : str -- bundle id of application, e.g. 'com.apple.textedit'
				creator : str -- 4-character creator type of application, e.g. 'ttxt'
				pid : int -- Unix process id, e.g. 955
				url : str -- eppc:// URL, e.g. eppc://G4.local/TextEdit'
				aemapp : aem.Application
				terms : module | bool -- if a module, get terminology from it; if True, get terminology from target application; if False, use built-in terminology only
    		"""
		if len([i for i in [name, id, creator, pid, url, aemapp] if i]) > 1:
			raise TypeError, 'app() received more than one of the following arguments: name, id, creator, pid, url, aemapp'
		if name:
			constructor, identifier = 'path', aem.findapp.byname(name)
		elif id:
			constructor, identifier = 'path',  aem.findapp.byid(id)
		elif creator:
			constructor, identifier = 'path',  aem.findapp.bycreator(creator)
		elif pid:
			constructor, identifier = 'pid', pid
		elif url:
			constructor, identifier = 'url', url
		elif aemapp:
			constructor, identifier = 'aemapp', aemapp
		else:
			constructor, identifier = 'current', None
		# Defer initialisation of AppData until it's needed. This allows user to call launch() on a non-running application without the application being launched by aem.Application, which automatically launches local applications in order to construct an AEAddressDesc of typeProcessSerialNumber.
		# launch()'s usefulness is somewhat limited, since constructing a real app-based reference will also launch the application normally in order to get its terminology. So to actually launch an application, you have to use launch() before constructing any real references to its objects; i.e.:
		#     te = app('TextEdit'); te.launch(); d = app.documents
		# will launch TE without it creating any new documents (i.e. app receives 'ascrnoop' as its first event), but:
		#     te = app('TextEdit'); d = app.documents; te.launch()
		# will launch TE normally (i.e. app receives 'aevtoapp' as its first event), causing it to open a new, empty window.
		Reference.__init__(self, AppData(self._Application, constructor, identifier, terms), aem.app)
	
	def AS_newreference(self, aemreference):
		"""Create a new appscript reference from an aem reference."""
		return Reference(self.AS_appdata, aemreference)
	
	def begintransaction(self, session=None):
		self.AS_appdata.target.begintransaction(session)
	
	def aborttransaction(self):
		self.AS_appdata.target.aborttransaction()
	
	def endtransaction(self):
		self.AS_appdata.target.endtransaction()
	
	def launch(self):
		"""Launch a non-running application in the background and send it a 'launch' event. Note: this will only launch non-running apps that are specified by name/path/bundle id/creator type. Apps specified by other means will be still sent a launch event if already running, but an error will occur if they're not."""
		if self.AS_appdata.constructor == 'path':
			aem.Application.launch(self.AS_appdata.identifier)
			self.AS_appdata.target.reconnect() # make sure aem.Application object's AEAddressDesc is up to date
		else:
			self.AS_appdata.target.event('ascrnoop').send() # will send launch event to app if already running; else will error


#######

class GenericApp(GenericReference):
	def __init__(self, appclass):
		self._appclass = appclass
		GenericReference.__init__(self, ['app'])
		
	def __call__(self, *args, **kargs):
		return self._appclass(*args, **kargs)


app = GenericApp(Application) # app-based references are generic references unless you specify an application by calling app, e.g. app.home is generic, app('Finder').home is real


######################################################################
# The CommandError class is exposed for use in try...except... blocks

class CommandError(Exception):
	"""An error raised when sending a command (e.g. aem.CommandError). Contains the original exception object and the command on which the error was raised.
	
		Attributes:
			command : Command -- command reference
			parameters : tuple -- two-item tuple containing tuple of positional args and dict of keyword args
			realerror : Exception -- the original error raised
	"""
	def __init__(self, command, parameters, realerror):
		self.command, self. parameters, self.realerror = command, parameters, realerror
		Exception.__init__(self, command, parameters, realerror)
		
	def __int__(self):
		if isinstance(self.realerror, aem.CommandError):
			return int(self.realerror)
		elif isinstance(self.realerror, MacOS.Error):
			return self.realerror[0]
		else:
			return -2700
	
	def __repr__(self):
		return 'appscript.CommandError(%r, %r, %r)' % (self.command, self. parameters, self.realerror)
	
	def __str__(self):
		return "%s\n\tFailed command: %s" % (self.realerror, 
				self.command.AS_formatCommand(self.parameters))

