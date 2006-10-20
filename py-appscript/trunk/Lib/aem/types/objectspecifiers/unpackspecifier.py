"""unpackspecifier -- Object specifier unpackers.

(C) 2005 HAS
"""

from CarbonX import kAE

from aem.types.basictypes import AEType, AEEnum
import specifier


######################################################################
# PRIVATE
######################################################################

_kTypeCompDescriptorOperators = {
		kAE.kAEGreaterThan:'gt',
		kAE.kAEGreaterThanEquals:'ge',
		kAE.kAEEquals:'eq',
		kAE.kAELessThan:'lt',
		kAE.kAELessThanEquals:'le',
		kAE.kAEBeginsWith:'startswith',
		kAE.kAEEndsWith:'endswith',
		kAE.kAEContains:'contains'
}

_kTypeLogicalDescriptorOperators = {
		kAE.kAEAND:'AND',
		kAE.kAEOR:'OR',
		kAE.kAENOT:'NOT'
}


#######

class _Ordinal:
	def __init__(self, code):
		self.code = code


def _descToDict(desc): # Shallow unpack an AEDesc
	desc = desc.AECoerceDesc(kAE.typeAERecord) # needed in 10.3, otherwise the next line raises MacOS.Error(-1704) (annoying, as it makes unpacking references 5% slower)
	return dict([desc.AEGetNthDesc(i + 1, kAE.typeWildCard) for i in range(desc.AECountItems())])


#######
# performance optimised unpacking of object specifiers by doing a shallow unpack now and a full unpack only if needed (e.g. when __repr__ is called)

def _unpackDeferredObjectSpecifier(desc, codecs):
	rec = _descToDict(desc)
	keyForm = codecs.unpack(rec[kAE.keyAEKeyForm]).code
	if keyForm in [kAE.formPropertyID, kAE.formAbsolutePosition, kAE.formName, kAE.formUniqueID]:
		want = codecs.unpack(rec[kAE.keyAEDesiredClass]).code # 4-letter code indicating element class
		key = codecs.unpack(rec[kAE.keyAEKeyData]) # value indicating which object(s) to select
		container = specifier.DeferredSpecifier(rec[kAE.keyAEContainer], codecs)
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
		return _unpackObjectSpecifier(desc, codecs)


#######
# full recursive unpacking of object specifiers; recreates an 'app'/'con'/'its' based aem reference from the ground up

def _unpackObjectSpecifier(desc, codecs): # TO DECIDE: what, if any, type/value checking should be done here?
	rec = _descToDict(desc)
	want = codecs.unpack(rec[kAE.keyAEDesiredClass]).code # 4-letter code indicating element class
	keyForm = codecs.unpack(rec[kAE.keyAEKeyForm]).code # 4-letter code indicating Specifier type
	key = codecs.unpack(rec[kAE.keyAEKeyData]) # value indicating which object(s) to select
	ref = codecs.unpack(rec[kAE.keyAEContainer]) or codecs.app # recursively unpack container structure
	# print want, keyForm, key, ref # DEBUG
	if keyForm == kAE.formPropertyID: # property specifier
		return ref.property(key.code)
	elif keyForm == 'usrp': # user-defined property specifier
		return ref.userproperty(key)
	elif keyForm == kAE.formRelativePosition: # relative element specifier
		if key.code == kAE.kAEPrevious:
			return ref.previous(AEType(want))
		elif key.code == kAE.kAENext:
			return ref.next(AEType(want))
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
			rec = _descToDict(key)
			return ref.byrange(codecs.unpack(rec[kAE.keyAERangeStart]), codecs.unpack(rec[kAE.keyAERangeStop]))
		elif keyForm == kAE.formTest:
			return ref.byfilter(key)
	raise TypeError

##

def _unpackInsertionLoc(desc, codecs):
	rec = _descToDict(desc)
	return getattr(_unpackObjectSpecifier(rec[kAE.keyAEObject], codecs), 
			{kAE.kAEBefore: 'before', kAE.kAEAfter: 'after', kAE.kAEBeginning: 'start', kAE.kAEEnd: 'end'}[rec[kAE.keyAEPosition].data])


def _unpackCompDescriptor(desc, codecs):
	rec = _descToDict(desc)
	operator = _kTypeCompDescriptorOperators[rec[kAE.keyAECompOperator].data]
	return getattr(codecs.unpack(rec[kAE.keyAEObject1]), operator)(codecs.unpack(rec[kAE.keyAEObject2]))


def _unpackLogicalDescriptor(desc, codecs):
	rec = _descToDict(desc)
	operator = _kTypeLogicalDescriptorOperators[rec[kAE.keyAELogicalOperator].data]
	operands = codecs.unpack(rec[kAE.keyAELogicalTerms])
	return operator == 'NOT' and operands[0].NOT or getattr(operands[0], operator)(*operands[1:])


######################################################################
# PUBLIC
######################################################################

osdecoders = {
	kAE.typeInsertionLoc: _unpackInsertionLoc,
	kAE.typeObjectSpecifier: _unpackDeferredObjectSpecifier, #_unpackObjectSpecifier,#
	kAE.typeAbsoluteOrdinal: lambda desc,codecs: _Ordinal(desc.data),
	kAE.typeCurrentContainer: lambda desc, codecs: codecs.con,
	kAE.typeObjectBeingExamined: lambda desc, codecs: codecs.its,
	kAE.typeCompDescriptor: _unpackCompDescriptor,
	kAE.typeLogicalDescriptor: _unpackLogicalDescriptor,
}

