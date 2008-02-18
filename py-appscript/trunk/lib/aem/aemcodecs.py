"""codecs -- Convert from Python to Apple Event Manager types and vice-versa.

(C) 2005-2008 HAS
"""

import struct, types, datetime, time
from codecs import BOM_UTF16_LE

import kae
from ae import AEDesc, AECreateDesc, AECreateList

from typewrappers import AEType, AEEnum, AEProp, AEKey
import aemreference, mactypes


######################################################################
# PRIVATE
######################################################################

if struct.pack("h", 1) == '\x00\x01': # host is big-endian
	fourcharcode = lambda code: code
else: # host is small-endian
	fourcharcode = lambda code: code[::-1]


class _Ordinal:
	def __init__(self, code):
		self.code = code

class _Range:
	def __init__(self, range):
		self.range = range


######################################################################
# PUBLIC
######################################################################


class UnitTypeCodecs:
	"""Provides pack and unpack methods for converting between mactypes.Units instances and AE unit types. Each Codecs instance is allocated its own UnitTypeCodecs instance.
	"""
	
	_defaultunittypes = [
		('centimeters', 'cmtr'),
		('meters', 'metr'),
		('kilometers', 'kmtr'),
		('inches', 'inch'),
		('feet', 'feet'),
		('yards', 'yard'),
		('miles', 'mile'),
		
		('square_meters', 'sqrm'),
		('square_kilometers', 'sqkm'),
		('square_feet', 'sqft'),
		('square_yards', 'sqyd'),
		('square_miles', 'sqmi'),
		
		('cubic_centimeters', 'ccmt'),
		('cubic_meters', 'cmet'),
		('cubic_inches', 'cuin'),
		('cubic_feet', 'cfet'),
		('cubic_yards', 'cyrd'),
		
		('liters', 'litr'),
		('quarts', 'qrts'),
		('gallons', 'galn'),
		
		('grams', 'gram'),
		('kilograms', 'kgrm'),
		('ounces', 'ozs '),
		('pounds', 'lbs '),
		
		('degrees_Celsius', 'degc'),
		('degrees_Fahrenheit', 'degf'),
		('degrees_Kelvin', 'degk'),
	]
	
	##
	
	def _defaultpacker(self, units, code): 
		return AECreateDesc(code, struct.pack('d', units.value))
	
	def _defaultunpacker(self, desc, name):
		return mactypes.Units(struct.unpack('d', desc.data)[0], name)
	
	##
	
	def __init__(self):
		self._typebyname = {}
		self._typebycode = {}
		self.addtypes(self._defaultunittypes)
	
	def addtypes(self, typedefs):
		""" Add application-specific unit type definitions to this UnitTypeCodecs instance.
		
			typedefs is a list of tuples, where each tuple is of form:
				(typename, typecode, packer, unpacker)
			or:
				(typename, typecode)
			
			If optional packer and unpacker functions are omitted, default pack/unpack functions
			are used instead; these pack/unpack AEDesc data as a double precision float.
		"""
		for item in typedefs:
			if len(item) == 2:
				item = item + (self._defaultpacker, self._defaultunpacker)
			name, code, packer, unpacker = item
			self._typebyname[name] = (code, packer)
			self._typebycode[code] = (name, unpacker)
	
	def pack(self, val):
		if isinstance(val, mactypes.Units):
			try:
				code, packer = self._typebyname[val.type]
			except KeyError:
				raise TypeError, 'Unknown unit type: %r' % val
			else:
				return True, packer(val, code)
		else:
			return False, val
	
	def unpack(self, desc):
		if self._typebycode.has_key(desc.type):
			name, unpacker = self._typebycode[desc.type]
			return True, unpacker(desc, name)
		else:
			return False, desc



######################################################################


class Codecs:
	"""Convert between Python and Apple event data types.
	Clients may add additional encoders/decoders and/or subclass to suit their needs.
	"""
	
	# Constants
	
	kNullDesc = AECreateDesc(kae.typeNull, '')
	kMacEpoch = datetime.datetime(1904, 1, 1) # used in packing datetime objects as AEDesc typeLongDateTime
	kMacEpochT = time.mktime(kMacEpoch.timetuple())
	kShortMacEpoch = kMacEpoch.date() # used in packing date objects as AEDesc typeLongDateTime

	kTrueDesc = AECreateDesc(kae.typeTrue, '')
	kFalseDesc = AECreateDesc(kae.typeFalse, '')
	
	#######
	# tables to map AE codes to aem method names
	
	kInsertionLocSelectors = {
			fourcharcode(kae.kAEBefore): 'before', 
			fourcharcode(kae.kAEAfter): 'after', 
			fourcharcode(kae.kAEBeginning): 'beginning', 
			fourcharcode(kae.kAEEnd): 'end'
	}
	
	kTypeCompDescriptorOperators = {
			fourcharcode(kae.kAEGreaterThan): 'gt',
			fourcharcode(kae.kAEGreaterThanEquals): 'ge',
			fourcharcode(kae.kAEEquals): 'eq',
			fourcharcode(kae.kAELessThan): 'lt',
			fourcharcode(kae.kAELessThanEquals): 'le',
			fourcharcode(kae.kAEBeginsWith): 'beginswith',
			fourcharcode(kae.kAEEndsWith): 'endswith',
			fourcharcode(kae.kAEContains): 'contains'
	}
	
	kTypeLogicalDescriptorOperators = {
			fourcharcode(kae.kAEAND): 'AND',
			fourcharcode(kae.kAEOR): 'OR',
			fourcharcode(kae.kAENOT): 'NOT'
	}
	
	
	###################################
	
	
	def __init__(self):
		# Clients may add/remove/replace encoder and decoder items:
		self.encoders = {
				AEDesc: self.packDesc,
				types.NoneType: self.packNone,
				types.BooleanType: self.packBool,
				types.IntType: self.packInt,
				types.LongType: self.packLong,
				types.FloatType: self.packFloat,
				
				types.StringType: self.packStr,
				types.UnicodeType: self.packUnicodeText, 
				
				types.ListType: self.packList,
				types.TupleType: self.packList,
				types.DictionaryType: self.packDict,
				datetime.date: self.packDate,
				datetime.datetime: self.packDatetime,
				datetime.time: self.packTime,
				time.struct_time: self.packStructTime,
				
				mactypes.Alias: self.packAlias,
				mactypes.File: self.packFile,
				
				AEType: self.packType,
				AEEnum: self.packEnum,
				AEProp: self.packProp,
				AEKey: self.packKey,
		}
		
		self. decoders = {
				kae.typeNull: self.unpackNull,
				kae.typeBoolean: self.unpackBoolean,
				kae.typeFalse: self.unpackFalse,
				kae.typeTrue: self.unpackTrue,
				kae.typeSInt16: self.unpackSInt16,
				kae.typeUInt16: self.unpackUInt16,
				kae.typeSInt32: self.unpackSInt32,
				kae.typeUInt32: self.unpackUInt32,
				kae.typeSInt64: self.unpackSInt64,
				kae.typeUInt64: self.unpackUInt64,
				kae.typeIEEE32BitFloatingPoint: self.unpackFloat32,
				kae.typeIEEE64BitFloatingPoint: self.unpackFloat64,
				kae.type128BitFloatingPoint: self.unpackFloat128,
				
				kae.typeChar: self.unpackChar,
				kae.typeIntlText: self.unpackIntlText,
				kae.typeUTF8Text: self.unpackUTF8Text,
				kae.typeUTF16ExternalRepresentation: self.unpackUTF16ExternalRepresentation,
				kae.typeStyledText: self.unpackStyledText,
				kae.typeUnicodeText: self.unpackUnicodeText,
				
				kae.typeLongDateTime: self.unpackLongDateTime,
				kae.typeAEList: self.unpackAEList,
				kae.typeAERecord: self.unpackAERecord,
				kae.typeVersion: self.unpackVersion,
				
				kae.typeAlias: self.unpackAlias,
				kae.typeFSS: self.unpackFSS,
				kae.typeFSRef: self.unpackFSRef,
				kae.typeFileURL: self.unpackFileURL,
				
				kae.typeQDPoint: self.unpackQDPoint,
				kae.typeQDRectangle: self.unpackQDRect, 
				kae.typeRGBColor: self.unpackRGBColor,
				
				kae.typeType: self.unpackType,
				kae.typeEnumeration: self.unpackEnumeration,
				kae.typeProperty: self.unpackProperty,
				kae.typeKeyword: self.unpackKeyword,
				
				kae.typeInsertionLoc: self.unpackInsertionLoc,
				kae.typeObjectSpecifier: self.unpackObjectSpecifier,
				kae.typeAbsoluteOrdinal: self.unpackAbsoluteOrdinal,
				kae.typeCompDescriptor: self.unpackCompDescriptor,
				kae.typeLogicalDescriptor: self.unpackLogicalDescriptor,
				kae.typeRangeDescriptor: self.unpackRangeDescriptor,
				
				kae.typeCurrentContainer: lambda desc: self.con,
				kae.typeObjectBeingExamined: lambda desc: self.its,
		}

		self._unittypecodecs = UnitTypeCodecs()
	
	
	###################################
	
	def addunittypes(self, typedefs):
		"""Register custom unit type definitions with this Codecs instance
			e.g. Adobe apps define additional unit types (ciceros, pixels, etc.)
		"""
		self._unittypecodecs.addtypes(typedefs)
	
	###################################
	
	def packunknown(self, data):
		"""Clients may override this to provide additional packers."""
		raise TypeError, "Can't pack data into an AEDesc (unsupported type): %r" % data
	
	def unpackunknown(self, desc):
		"""Clients may override this to provide additional unpackers."""
		if desc.AECheckIsRecord():
			rec = desc.AECoerceDesc('reco')
			rec.AEPutParamDesc('pcls', self.pack(AEType(desc.type)))
			decoder = self.decoders.get('reco')
			if decoder:
				return decoder(rec)
			else:
				return rec
		else:
			return desc
	
	##
	
	def pack(self, data):
		"""Pack Python data.
			data : anything -- a Python value
			Result : CarbonX.AE.AEDesc -- an Apple event descriptor, or error if no encoder exists for this type of data
		"""
		if isinstance(data, aemreference.Query):
			return data.AEM_packSelf(self)
		else:
			try:
				return self.encoders[data.__class__](data) # quick lookup by type/class
			except (KeyError, AttributeError):
				for type, encoder in self.encoders.items(): # slower but more thorough lookup that can handle subtypes/subclasses
					if isinstance(data, type):
						return encoder(data)
				didpack, desc = self._unittypecodecs.pack(data)
				if didpack:
					return desc
				else:
					self.packunknown(data)
	
	def unpack(self, desc):
		"""Unpack an Apple event descriptor.
			desc : CarbonX.AE.AEDesc -- an Apple event descriptor
			Result : anything -- a Python value, or the AEDesc object if no decoder is found
		"""
		decoder = self.decoders.get(desc.type)
		if decoder:
			return decoder(desc)
		else:
			didunpack, val = self._unittypecodecs.unpack(desc)
			if didunpack:
				return val
			else:
				return self.unpackunknown(desc)
	
	
	###################################
	
	def packDesc(self, val):
		return val
	
	def packNone(self, val):
		return self.kNullDesc
	
	def packBool(self, val):
		return val and self.kTrueDesc or self.kFalseDesc
	
	def packLong(self, val):
		if (-2**31) <= val < (2**31): # pack as typeSInt32 if possible (non-lossy)
			return AECreateDesc(kae.typeSInt32, struct.pack('i', val))
		elif (-2**63) <= val < (2**63): # else pack as typeSInt64 if possible (non-lossy)
			return AECreateDesc(kae.typeSInt64, struct.pack('q', val))
		else: # else pack as typeFloat (lossy)
			return self.pack(float(val))
	
	packInt = packLong # note: Python int = C long, so may need to pack as typeSInt64 on 64-bit
	
	def packFloat(self, val):
		return AECreateDesc(kae.typeFloat, struct.pack('d', val))
	
	##
	
	def packUnicodeText(self, val):
		# Note: optional BOM is omitted as this causes problems with stupid apps like iTunes 7 that don't
		# handle BOMs correctly; note: while typeUnicodeText is not recommended as of OS 10.4, it's still
		# being used rather than typeUTF8Text or typeUTF16ExternalRepresentation to provide compatibility
		#with not-so-well-designed applications that may have problems with these newer types.
		return AECreateDesc(kae.typeUnicodeText, val.encode('utf16')[2:])
	
	def packStr(self, val):
		return AECreateDesc(kae.typeChar, val)
	
	##
	
	def packDate(self, val):
		delta = val - self.kShortMacEpoch
		sec = delta.days * 3600 * 24 + delta.seconds
		return AECreateDesc(kae.typeLongDateTime, struct.pack('q', sec))
	
	def packDatetime(self, val):
		delta = val - self.kMacEpoch
		sec = delta.days * 3600 * 24 + delta.seconds
		return AECreateDesc(kae.typeLongDateTime, struct.pack('q', sec))
	
	def packTime(self, val):
		return _packDatetime(datetime.datetime.combine(datetime.date.today(), val), self)
	
	def packStructTime(self, val):
		sec = int(time.mktime(val) - self.kMacEpochT)
		return AECreateDesc(kae.typeLongDateTime, struct.pack('q', sec))
	
	def packAlias(self, val):
		return val.desc
	packFile = packAlias
	
	##
	
	def packList(self, val):
		lst = AECreateList('', False)
		for item in val:
			lst.AEPutDesc(0, self.pack(item))
		return lst
	
	def packDict(self, val):
		record = AECreateList('', True)
		usrf = None
		for key, value in val.items():
			if isinstance(key, (AEType, AEProp)):
				if key.code == 'pcls': # AS packs records that contain a 'class' property by coercing the packed record to that type at the end
					try:
						record = record.AECoerceDesc(value.code)
					except:
						record.AEPutParamDesc(key.code, self.pack(value))
				else:
					record.AEPutParamDesc(key.code, self.pack(value))
			else:
				if not usrf:
					usrf = AECreateList('', False)
				usrf.AEPutDesc(0, self.pack(key))
				usrf.AEPutDesc(0, self.pack(value))
		if usrf:
			record.AEPutParamDesc('usrf', usrf)
		return record
	
	##
	
	def packType(self, val):
		return AECreateDesc(kae.typeType, fourcharcode(val.code))
	
	def packEnum(self, val): 
		return AECreateDesc(kae.typeEnumeration, fourcharcode(val.code))
	
	def packProp(self, val): 
		return AECreateDesc(kae.typeProperty, fourcharcode(val.code))
	
	def packKey(self, val): 
		return AECreateDesc(kae.typeKeyword, fourcharcode(val.code))

	
	###################################
	# unpack
	
	def unpackNull(self, desc):
		return None
	
	def unpackBoolean(self, desc):
		return desc.data != '\x00'
	
	def unpackTrue(self, desc):
		return True
	
	def unpackFalse(self, desc):
		return False
	
	def unpackSInt16(self, desc):
		return struct.unpack('h', desc.data)[0]
	
	def unpackUInt16(self, desc):
		return struct.unpack('H', desc.data)[0]
	
	def unpackSInt32(self, desc):
		return struct.unpack('i', desc.data)[0]
	
	def unpackUInt32(self, desc):
		return struct.unpack('I', desc.data)[0]
	
	def unpackSInt64(self, desc):
		return struct.unpack('q', desc.data)[0]
	
	def unpackUInt64(self, desc):
		return struct.unpack('Q', desc.data)[0]
	
	def unpackFloat32(self, desc):
		return struct.unpack('f', desc.data)[0]
	
	def unpackFloat64(self, desc):
		return struct.unpack('d', desc.data)[0]
	
	def unpackFloat128(self, desc):
		return struct.unpack('d', desc.AECoerceDesc(kae.typeIEEE64BitFloatingPoint).data)[0]

	##
	
	def unpackChar(self, desc):
		return desc.data
	
	def unpackIntlText(self, desc):
		return self.unpackUnicodeText(desc.AECoerceDesc(kae.typeUnicodeText))
	
	def unpackUTF8Text(self, desc):
		return unicode(desc.data, 'utf8')
	
	def unpackStyledText(self, desc):
		return self.unpackUnicodeText(desc.AECoerceDesc(kae.typeUnicodeText))
	
	def unpackUnicodeText(self, desc):
		# typeUnicodeText = native endian UTF16 with optional BOM
		return unicode(desc.data, 'utf16')
	
	def unpackUTF16ExternalRepresentation(self, desc): 
		# type UTF16ExternalRepresentation = big-endian UTF16 with optional byte-order-mark 
		# OR little-endian UTF16 with required byte-order-mark
		if desc.data.startswith(BOM_UTF16_LE):
			return unicode(desc.data, 'UTF-16LE')
		else:
			return unicode(desc.data, 'UTF-16BE')
	
	##
	
	def unpackLongDateTime(self, desc):
		return self.kMacEpoch + datetime.timedelta(seconds=struct.unpack('q', desc.data)[0])
	
	def unpackQDPoint(self, desc): 
		x, y = struct.unpack('hh', desc.data)
		return (y, x)
	
	def unpackQDRect(self, desc):
		x1, y1, x2, y2 = struct.unpack('hhhh', desc.data)
		return (y1, x1, y2, x2)
	
	def unpackRGBColor(self, desc):
		return struct.unpack('HHH', desc.data)
	
	def unpackVersion(self, desc):
		# Cocoa apps use unicode strings for version numbers, so return as string for consistency
		try:
			return self.unpack(desc.AECoerceDesc(kae.typeUnicodeText)) # supported in 10.4+
		except:
			return '%i.%i.%i' % ((ord(desc.data[0]),) + divmod(ord(desc.data[1]), 16)) # note: always big-endian
	
	##
	
	def unpackAlias(self, desc):
		return mactypes.Alias.makewithdesc(desc)
		
	def unpackFileURL(self, desc):
		return mactypes.File.makewithdesc(desc)
	unpackFSRef = unpackFSS = unpackFileURL
	
	##
	
	def unpackAEList(self, desc):
		# Unpack list and its values.
		return [self.unpack(desc.AEGetNthDesc(i + 1, kae.typeWildCard)[1]) for i in range(desc.AECountItems())]
	
	def unpackAERecord(self, desc):
		# Unpack record to dict, converting keys from 4-letter codes to AEType instances and unpacking values.
		dct = {}
		for i in range(desc.AECountItems()):
			key, value = desc.AEGetNthDesc(i + 1, kae.typeWildCard)
			if key == 'usrf':
				lst = self.unpackAEList(value)
				for i in range(0, len(lst), 2):
					dct[lst[i]] = lst[i+1]
			else:
				dct[AEType(key)] = self.unpack(value)
		return dct

	##
	
	def unpackType(self, desc):
		return AEType(fourcharcode(desc.data))
	
	def unpackEnumeration(self, desc):
		return AEEnum(fourcharcode(desc.data))
	
	def unpackProperty(self, desc):
		return AEProp(fourcharcode(desc.data))
	
	def unpackKeyword(self, desc):
		return AEKey(fourcharcode(desc.data))
					
	##
	
	def fullyUnpackObjectSpecifier(self, desc):
		# This function performs a full recursive unpacking of object specifiers, reconstructing an 'app'/'con'/'its' based aem reference from the ground up.
		want = self.unpack(desc.AEGetParamDesc(kae.keyAEDesiredClass, kae.typeType)).code # 4-letter code indicating element class
		keyForm = self.unpack(desc.AEGetParamDesc(kae.keyAEKeyForm, kae.typeEnumeration)).code # 4-letter code indicating Specifier type
		key = self.unpack(desc.AEGetParamDesc(kae.keyAEKeyData, kae.typeWildCard)) # value indicating which object(s) to select
		ref = self.unpack(desc.AEGetParamDesc(kae.keyAEContainer, kae.typeWildCard)) # recursively unpack container structure
		if not isinstance(ref, aemreference.Query):
			if ref is None:
				ref = self.app
			else:
				ref = self.customroot(ref)
		# print want, keyForm, key, ref # DEBUG
		if keyForm == kae.formPropertyID: # property specifier
			return ref.property(key.code)
		elif keyForm == 'usrp': # user-defined property specifier
			return ref.userproperty(key)
		elif keyForm == kae.formRelativePosition: # relative element specifier
			if key.code == kae.kAEPrevious:
				return ref.previous(want)
			elif key.code == kae.kAENext:
				return ref.next(want)
			else:
				raise ValueError, "Bad relative position selector: %r" % want
		else: # other element(s) specifier
			ref = ref.elements(want)
			if keyForm == kae.formName:
				return ref.byname(key)
			elif keyForm == kae.formAbsolutePosition:
				if isinstance(key, _Ordinal):
					if key.code == kae.kAEAll:
						return ref
					else:
						return getattr(ref, {kae.kAEFirst: 'first', kae.kAELast: 'last', kae.kAEMiddle: 'middle', kae.kAEAny: 'any'}[key.code])
				else:
					return ref.byindex(key)
			elif keyForm == kae.formUniqueID:
				return ref.byid(key)
			elif keyForm == kae.formRange:
				return ref.byrange(*key.range)
			elif keyForm == kae.formTest:
				return ref.byfilter(key)
		raise TypeError
	
	
	def unpackObjectSpecifier(self, desc):
		# This function performance-optimises the unpacking of some object specifiers by only doing a shallow unpack where only the topmost descriptor is unpacked.
		# The container AEDesc is retained as-is, allowing a full recursive unpack to be performed later on only if needed (e.g. if the __repr__ method is called).
		# For simplicity, only the commonly encountered forms are optimised this way; forms that are rarely returned by applications (e.g. typeRange) are always fully unpacked.
		keyForm = self.unpack(desc.AEGetParamDesc(kae.keyAEKeyForm, kae.typeEnumeration)).code
		if keyForm in [kae.formPropertyID, kae.formAbsolutePosition, kae.formName, kae.formUniqueID]:
			want = self.unpack(desc.AEGetParamDesc(kae.keyAEDesiredClass, kae.typeType)).code # 4-letter code indicating element class
			key = self.unpack(desc.AEGetParamDesc(kae.keyAEKeyData, kae.typeWildCard)) # value indicating which object(s) to select
			container = aemreference.DeferredSpecifier(desc.AEGetParamDesc(kae.keyAEContainer, kae.typeWildCard), self)
			if keyForm == kae.formPropertyID:
				ref = aemreference.Property(want, container, key.code)
			elif keyForm == kae.formAbsolutePosition:
				if isinstance(key, _Ordinal):
					if key.code == kae.kAEAll:
						ref = aemreference.AllElements(want, container)
					else:
						keyname = {kae.kAEFirst: 'first', kae.kAELast: 'last', kae.kAEMiddle: 'middle', kae.kAEAny: 'any'}[key.code]
						ref = aemreference.ElementByOrdinal(want, aemreference.UnkeyedElements(want, container), key, keyname)
				else:
					ref = aemreference.ElementByIndex(want, aemreference.UnkeyedElements(want, container), key)
			elif keyForm == kae.formName:
				ref = aemreference.ElementByName(want, aemreference.UnkeyedElements(want, container), key)
			elif keyForm == kae.formUniqueID:
				ref = aemreference.ElementByID(want, aemreference.UnkeyedElements(want, container), key)
			ref.AEM_packSelf = lambda codecs:desc
			return ref
		else: # do full unpack of more complex, rarely returned reference forms
			return self.fullyUnpackObjectSpecifier(desc)
	
	
	def unpackInsertionLoc(self, desc):
		return getattr(self.fullyUnpackObjectSpecifier(desc.AEGetParamDesc(kae.keyAEObject, kae.typeWildCard)), 
				self.kInsertionLocSelectors[desc.AEGetParamDesc(kae.keyAEPosition, kae.typeEnumeration).data])
	
	
	def unpackCompDescriptor(self, desc):
		operator = self.kTypeCompDescriptorOperators[desc.AEGetParamDesc(kae.keyAECompOperator, kae.typeEnumeration).data]
		op1 = self.unpack(desc.AEGetParamDesc(kae.keyAEObject1, kae.typeWildCard))
		op2 = self.unpack(desc.AEGetParamDesc(kae.keyAEObject2, kae.typeWildCard))
		if operator == 'contains':
			if isinstance(op1, aemreference.Query) and op1.AEM_root() == aemreference.its:
				return op1.contains(op2)
			else:
				return op2.isin(op1)
		return getattr(op1, operator)(op2)
	
	
	def unpackLogicalDescriptor(self, desc):
		operator = self.kTypeLogicalDescriptorOperators[desc.AEGetParamDesc(kae.keyAELogicalOperator, kae.typeEnumeration).data]
		operands = self.unpack(desc.AEGetParamDesc(kae.keyAELogicalTerms, kae.typeAEList))
		return operator == 'NOT' and operands[0].NOT or getattr(operands[0], operator)(*operands[1:])
	
	def unpackRangeDescriptor(self, desc):
		return _Range([self.unpack(desc.AEGetParamDesc(kae.keyAERangeStart, kae.typeWildCard)), 
				self.unpack(desc.AEGetParamDesc(kae.keyAERangeStop, kae.typeWildCard))])
	
	
	def unpackAbsoluteOrdinal(self, desc):
		return _Ordinal(fourcharcode(desc.data))
	
	##
	
	app = aemreference.app
	con = aemreference.con
	its = aemreference.its
	customroot = aemreference.customroot
	

