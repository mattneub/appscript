"""unpackspecifier -- Object specifier unpackers.

(C) 2005 HAS
"""

import struct

from CarbonX import kAE

from aem.types.basictypes import AEType, AEEnum
import specifier, base


######################################################################
# PRIVATE
######################################################################

if struct.pack("h", 1) == '\x00\x01': # host is big-endian
	fourCharCode = lambda code: code
else: # host is small-endian
	fourCharCode = lambda code: code[::-1]


_kInsertionLocSelectors = {
		fourCharCode(kAE.kAEBefore): 'before', 
		fourCharCode(kAE.kAEAfter): 'after', 
		fourCharCode(kAE.kAEBeginning): 'start', 
		fourCharCode(kAE.kAEEnd): 'end'
}

_kTypeCompDescriptorOperators = {
		fourCharCode(kAE.kAEGreaterThan): 'gt',
		fourCharCode(kAE.kAEGreaterThanEquals): 'ge',
		fourCharCode(kAE.kAEEquals): 'eq',
		fourCharCode(kAE.kAELessThan): 'lt',
		fourCharCode(kAE.kAELessThanEquals): 'le',
		fourCharCode(kAE.kAEBeginsWith): 'startswith',
		fourCharCode(kAE.kAEEndsWith): 'endswith',
		fourCharCode(kAE.kAEContains): 'contains'
}

_kTypeLogicalDescriptorOperators = {
		fourCharCode(kAE.kAEAND): 'AND',
		fourCharCode(kAE.kAEOR): 'OR',
		fourCharCode(kAE.kAENOT): 'NOT'
}


#######

class _Ordinal:
	def __init__(self, code):
		self.code = code

class _Range:
	def __init__(self, range):
		self.range = range


#######

def _fullyUnpackObjectSpecifier(desc, codecs):
	# This function performs a full recursive unpacking of object specifiers, reconstructing an 'app'/'con'/'its' based aem reference from the ground up.
	want = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEDesiredClass, kAE.typeType)).code # 4-letter code indicating element class
	keyForm = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEKeyForm, kAE.typeEnumeration)).code # 4-letter code indicating Specifier type
	key = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEKeyData, kAE.typeWildCard)) # value indicating which object(s) to select
	ref = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEContainer, kAE.typeWildCard)) # recursively unpack container structure
	if not isinstance(ref, base.BASE):
		if ref is None:
			ref = codecs.app
		else:
			ref = specifier.customroot(ref)
	# print want, keyForm, key, ref # DEBUG
	if keyForm == kAE.formPropertyID: # property specifier
		return ref.property(key.code)
	elif keyForm == 'usrp': # user-defined property specifier
		return ref.userproperty(key)
	elif keyForm == kAE.formRelativePosition: # relative element specifier
		if key.code == kAE.kAEPrevious:
			return ref.previous(want)
		elif key.code == kAE.kAENext:
			return ref.next(want)
		else:
			raise ValueError, "Bad relative position selector: %r" % want
	else: # other element(s) specifier
		ref = ref.elements(want)
		if keyForm == kAE.formName:
			return ref.byname(key)
		elif keyForm == kAE.formAbsolutePosition:
			if isinstance(key, _Ordinal):
				if key.code == kAE.kAEAll:
					return ref
				else:
					return getattr(ref, {kAE.kAEFirst: 'first', kAE.kAELast: 'last', kAE.kAEMiddle: 'middle', kAE.kAEAny: 'any'}[key.code])
			else:
				return ref.byindex(key)
		elif keyForm == kAE.formUniqueID:
			return ref.byid(key)
		elif keyForm == kAE.formRange:
			return ref.byrange(*key.range)
		elif keyForm == kAE.formTest:
			return ref.byfilter(key)
	raise TypeError


#######

def _unpackObjectSpecifier(desc, codecs):
	# This function performance-optimises the unpacking of some object specifiers by only doing a shallow unpack where only the topmost descriptor is unpacked.
	# The container AEDesc is retained as-is, allowing a full recursive unpack to be performed later on only if needed (e.g. if the __repr__ method is called).
	# For simplicity, only the commonly encountered forms are optimised this way; forms that are rarely returned by applications (e.g. typeRange) are always fully unpacked.
	keyForm = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEKeyForm, kAE.typeEnumeration)).code
	if keyForm in [kAE.formPropertyID, kAE.formAbsolutePosition, kAE.formName, kAE.formUniqueID]:
		want = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEDesiredClass, kAE.typeType)).code # 4-letter code indicating element class
		key = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEKeyData, kAE.typeWildCard)) # value indicating which object(s) to select
		container = specifier.DeferredSpecifier(desc.AEGetParamDesc(kAE.keyAEContainer, kAE.typeWildCard), codecs)
		if keyForm == kAE.formPropertyID:
			ref = specifier.Property(want, container, key.code)
		elif keyForm == kAE.formAbsolutePosition:
			if isinstance(key, _Ordinal):
				if key.code == kAE.kAEAll:
					ref = specifier.AllElements(want, container)
				else:
					keyname = {kAE.kAEFirst: 'first', kAE.kAELast: 'last', kAE.kAEMiddle: 'middle', kAE.kAEAny: 'any'}[key.code]
					ref = specifier.ElementByOrdinal(want, specifier.UnkeyedElements(want, container), key, keyname)
			else:
				ref = specifier.ElementByIndex(want, specifier.UnkeyedElements(want, container), key)
		elif keyForm == kAE.formName:
			ref = specifier.ElementByName(want, specifier.UnkeyedElements(want, container), key)
		elif keyForm == kAE.formUniqueID:
			ref = specifier.ElementByID(want, specifier.UnkeyedElements(want, container), key)
		ref.AEM_packSelf = lambda codecs:desc
		return ref
	else: # do full unpack of more complex, rarely returned reference forms
		return _fullyUnpackObjectSpecifier(desc, codecs)


def _unpackInsertionLoc(desc, codecs):
	return getattr(_fullyUnpackObjectSpecifier(desc.AEGetParamDesc(kAE.keyAEObject, kAE.typeWildCard), codecs), 
			_kInsertionLocSelectors[desc.AEGetParamDesc(kAE.keyAEPosition, kAE.typeEnumeration).data])


def _unpackCompDescriptor(desc, codecs):
	operator = _kTypeCompDescriptorOperators[desc.AEGetParamDesc(kAE.keyAECompOperator, kAE.typeEnumeration).data]
	op1 = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEObject1, kAE.typeWildCard))
	op2 = codecs.unpack(desc.AEGetParamDesc(kAE.keyAEObject2, kAE.typeWildCard))
	if operator == 'contains':
		if isinstance(op1, base.BASE) and op1.AEM_root() == specifier.its:
			return op1.contains(op2)
		else:
			return op2.isin(op1)
	return getattr(op1, operator)(op2)


def _unpackLogicalDescriptor(desc, codecs):
	operator = _kTypeLogicalDescriptorOperators[desc.AEGetParamDesc(kAE.keyAELogicalOperator, kAE.typeEnumeration).data]
	operands = codecs.unpack(desc.AEGetParamDesc(kAE.keyAELogicalTerms, kAE.typeAEList))
	return operator == 'NOT' and operands[0].NOT or getattr(operands[0], operator)(*operands[1:])

def _unpackRangeDescriptor(desc, codecs):
	return _Range([codecs.unpack(desc.AEGetParamDesc(kAE.keyAERangeStart, kAE.typeWildCard)), 
			codecs.unpack(desc.AEGetParamDesc(kAE.keyAERangeStop, kAE.typeWildCard))])


######################################################################
# PUBLIC
######################################################################

osdecoders = {
	kAE.typeInsertionLoc: _unpackInsertionLoc,
	kAE.typeObjectSpecifier: _unpackObjectSpecifier,
	kAE.typeAbsoluteOrdinal: lambda desc,codecs: _Ordinal(fourCharCode(desc.data)),
	kAE.typeCurrentContainer: lambda desc, codecs: codecs.con,
	kAE.typeObjectBeingExamined: lambda desc, codecs: codecs.its,
	kAE.typeCompDescriptor: _unpackCompDescriptor,
	kAE.typeLogicalDescriptor: _unpackLogicalDescriptor,
	kAE.typeRangeDescriptor: _unpackRangeDescriptor,
}

