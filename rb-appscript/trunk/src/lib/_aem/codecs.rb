#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "ae"
require "kae"
require "_aem/typewrappers"
require "_aem/aemreference"
require "macfile"

# Note that AE strings (typeChar, typeUnicodeText, etc.) are unpacked as UTF8-encoded Ruby strings, and UTF8-encoded Ruby strings are packed as typeUnicodeText. Using UTF8 on the Ruby side avoids data loss; using typeUnicodeText on the AEM side provides compatibility with all [reasonably well designed] applications. To change this behaviour (e.g. to support legacy apps that demand typeChar and break on typeUnicodeText), subclass Codecs and override pack and/or unpack methods to provide alternative packing/unpacking of string values. Users can also pack data manually using AE::AEDesc.new(type, data).

######################################################################
# Endianness support

module BigEndianConverters
	
	def fourCharCode(code)
		return code
	end
	
	def eightCharCode(code)
		return code
	end

end


module SmallEndianConverters
	
	def fourCharCode(code)
		return code.reverse
	end
	
	def eightCharCode(code)
		return code[0,4].reverse + code[4,4].reverse
	end
	
end


CodeConverters = [1].pack('s') == "\001\000" ? SmallEndianConverters : BigEndianConverters


######################################################################

class NotUTF8TextError < RuntimeError
end


class Codecs

	def initialize
		extend(CodeConverters)
	end
	
	######################################################################
	
	App = AEMReference::App
	Con = AEMReference::Con
	Its = AEMReference::Its
	
	######################################################################
	# Pack
	
	SInt32Bounds = (-2**31)..(2**31-1)
	SInt64Bounds = (-2**63)..(2**63-1)

	NullDesc = AE::AEDesc.new(KAE::TypeNull, '')
	TrueDesc = AE::AEDesc.new(KAE::TypeTrue, '')
	FalseDesc = AE::AEDesc.new(KAE::TypeFalse, '')
	
	def packFailed(val)
		raise TypeError, "Can't pack data into an AEDesc (unsupported type): #{val.inspect}"
	end
	
	##
	
	def pack(val)
		if val.is_a?(AEMReference::Base) then val.AEM_packSelf(self)
		elsif val == nil then NullDesc
		elsif val == true then TrueDesc
		elsif val == false then FalseDesc
		elsif val.is_a?(Fixnum) then AE::AEDesc.new(KAE::TypeSInt32, [val].pack('l'))
		elsif val.is_a?(Bignum) then
			if SInt32Bounds === val
				AE::AEDesc.new(KAE::TypeSInt32, [val].pack('l')) 
			elsif SInt64Bounds === val
				AE::AEDesc.new(KAE::TypeSInt64, [val].pack('q'))
			else
				AE::AEDesc.new(KAE::TypeFloat, [val.to_f].pack('d'))
			end
		elsif val.is_a?(Float) then AE::AEDesc.new(KAE::TypeFloat, [val].pack('d'))
		elsif val.is_a?(String) then 
			begin
				AE::AEDesc.new(KAE::TypeUTF8Text, val).coerce(KAE::TypeUnicodeText)
			rescue AE::MacOSError => e
				if e.to_i == -1700
					raise NotUTF8TextError, "Not valid UTF8 data: #{val.inspect}"
				else
					raise
				end
			end
		elsif val.is_a?(Time) then
			AE::AEDesc.new(KAE::TypeLongDateTime,
					[AE.convertUnixSecondsToLongDateTime(val.to_i)].pack('q'))
		elsif val.is_a?(Array) then packArray(val)
		elsif val.is_a?(Hash) then packHash(val)
		elsif val.is_a?(MacFile::FileBase) then val.desc
		elsif val.is_a?(TypeWrappers::AEType) then
			AE::AEDesc.new(KAE::TypeType, fourCharCode(val.code))
		elsif val.is_a?(TypeWrappers::AEEnum) then
			AE::AEDesc.new(KAE::TypeEnumerated, fourCharCode(val.code))
		elsif val.is_a?(TypeWrappers::AEProp) then 
			AE::AEDesc.new(KAE::TypeProperty, fourCharCode(val.code))
		elsif val.is_a?(TypeWrappers::AEKey) then
			AE::AEDesc.new(KAE::TypeKeyword, fourCharCode(val.code))
		elsif val.is_a?(TypeWrappers::AEEventName) then 
			AE::AEDesc.new(KAE::TypeEventName, eightCharCode(val.code))
		elsif val.is_a?(AE::AEDesc) then val
		else
			raise TypeError
		end
	end
	
	#######
	
	def packArray(val)
		lst = AE::AEDesc.newList(false)
		val.each do |item|
			lst.putItem(0, pack(item))
		end
		return lst
	end
	
	def packHash(val)
		record = AE::AEDesc.newList(true)
		usrf = nil
		val.each do | key, value |
			if key.is_a?(TypeWrappers::AETypeBase)
				if key.code == 'pcls' # AS packs records that contain a 'class' property by coercing the packed record to that type at the end
					begin
						record = record.coerce(value.code)
					rescue
						record.putParam(key.code, pack(value))
					end
				else
					record.putParam(key.code, pack(value))
				end
			else
				if usrf == nil
					usrf = AE::AEDesc.newList(false)
				end
				usrf.putItem(0, pack(key))
				usrf.putItem(0, pack(value))
			end
		end
		if usrf
			record.putParam('usrf', usrf)
		end
		return record
	end
	
	######################################################################
	# Unpack
	
	def unpack(desc)
		return case desc.type
			
			when KAE::TypeNull then nil
			when KAE::TypeBoolean then desc.data != "\000"
			when KAE::TypeFalse then false
			when KAE::TypeTrue then true
			
			when KAE::TypeSInt16 then desc.data.unpack('s')[0]
			when KAE::TypeSInt32 then desc.data.unpack('l')[0]
			when KAE::TypeUInt32 then desc.data.unpack('L')[0]
			when KAE::TypeSInt64 then desc.data.unpack('q')[0]
			when KAE::TypeIEEE32BitFloatingPoint then desc.data.unpack('f')[0]
			when KAE::TypeIEEE64BitFloatingPoint then desc.data.unpack('d')[0]
			when KAE::Type128BitFloatingPoint then 
				unpack(desc.AECoerceDesc(KAE::TypeIEEE64BitFloatingPoint))[0]
			
			when KAE::TypeChar then desc.coerce(KAE::TypeUTF8Text).data
			when KAE::TypeIntlText then desc.coerce(KAE::TypeUTF8Text).data
			when KAE::TypeUTF8Text then desc.data
			when KAE::TypeUTF16ExternalRepresentation then desc.coerce(KAE::TypeUTF8Text).data
			when KAE::TypeUnicodeText then desc.coerce(KAE::TypeUTF8Text).data
			when KAE::TypeStyledText then desc.coerce(KAE::TypeUTF8Text).data
			when KAE::TypeStyledUnicodeText then desc.coerce(KAE::TypeUTF8Text).data
			
			when KAE::TypeLongDateTime then
				Time.at(AE.convertLongDateTimeToUnixSeconds(desc.data.unpack('q')[0]))
				
			when KAE::TypeVersion
				vers, lo = desc.data.unpack('CC')
				subvers, patch = lo.divmod(16)
				"#{vers}.#{subvers}.#{patch}"
			
			when KAE::TypeAEList then unpackAEList(desc)
			when KAE::TypeAERecord then unpackAERecord(desc)
			
			when KAE::TypeAlias then MacFile::Alias.newDesc(desc)
			when KAE::TypeFSS then MacFile::FileURL.newDesc(desc)
			when KAE::TypeFSRef then MacFile::FileURL.newDesc(desc)
			when KAE::TypeFileURL then MacFile::FileURL.newDesc(desc)
			
			when KAE::TypeQDPoint then desc.data.unpack('ss').reverse
			when KAE::TypeQDRectangle then
				x1, y1, x2, y2 = desc.data.unpack('ssss')
				[y1, x1, y2, x2]
			when KAE::TypeRGBColor then desc.data.unpack('SSS')
			
			when KAE::TypeType then unpackType(desc)
			when KAE::TypeEnumerated then unpackEnumerated(desc)
			when KAE::TypeProperty then unpackProperty(desc)
			when KAE::TypeKeyword then unpackKeyword(desc)
			when KAE::TypeEventName then unpackEventName(desc)
			
			when KAE::TypeInsertionLoc then unpackInsertionLoc(desc)
			when KAE::TypeObjectSpecifier then unpackObjectSpecifier(desc)
			when KAE::TypeAbsoluteOrdinal then unpackAbsoluteOrdinal(desc)
			when KAE::TypeCurrentContainer then unpackCurrentContainer(desc)
			when KAE::TypeObjectBeingExamined then unpackObjectBeingExamined(desc)
			when KAE::TypeCompDescriptor then unpackCompDescriptor(desc)
			when KAE::TypeLogicalDescriptor then unpackLogicalDescriptor(desc)
			when KAE::TypeRangeDescriptor then unpackRangeDescriptor(desc)
		else
			if desc.isRecord? # if it's a record-like structure with an unknown/unsupported type then unpack it as a hash, including the original type info as a 'class' property
				rec = desc.coerce(KAE::TypeAERecord)
				rec.putParam('pcls', pack(TypeWrappers::AEType.new(desc.type)))
				return unpack(rec)
			else # else return unchanged
				return desc
			end
		end
	end
	
	#######
	
	def unpackAEList(desc)
		lst = []
		desc.length().times do |i|
			lst.push(unpack(desc.get(i + 1, KAE::TypeWildCard)[1]))
		end
		return lst
	end

	def unpackAERecord(desc)
		dct = {}
		desc.length().times do |i|
			key, value = desc.get(i + 1, KAE::TypeWildCard)
			if key == 'usrf'
				lst = unpackAEList(value)
				(lst.length / 2).times do |i|
					dct[lst[i * 2]] = lst[i * 2 + 1]
				end
			else
				dct[TypeWrappers::AEType.new(key)] = unpack(value)
			end
		end
		return dct
	end
	
	#######
	
	def unpackType(desc)
		return TypeWrappers::AEType.new(fourCharCode(desc.data))
	end
	
	def unpackEnumerated(desc)
		return TypeWrappers::AEEnum.new(fourCharCode(desc.data))
	end
	
	def unpackProperty(desc)
		return TypeWrappers::AEProp.new(fourCharCode(desc.data))
	end
	
	def unpackKeyword(desc)
		return TypeWrappers::AEKey.new(fourCharCode(desc.data))
	end
	
	def unpackEventName(desc)
		return TypeWrappers::AEEventName.new(eightCharCode(desc.data))
	end
	
	#######
	
	class Range
		attr_reader :range
		
		def initialize(range)
			@range = range
		end
	end
	
	class Ordinal
		attr_reader :code
		
		def initialize(code)
			@code = code
		end
	end
	
	def _descToHash(desc)
		desc = desc.coerce(KAE::TypeAERecord)
		h = {}
		desc.length.times do |i|
			k, v = desc.get(i + 1, KAE::TypeWildCard)
			h[k] = v
		end
		return h
	end
	
	#######
	
	FullUnpackOrdinals = {
			KAE::KAEFirst => 'first', 
			KAE::KAELast => 'last', 
			KAE::KAEMiddle => 'middle', 
			KAE::KAEAny => 'any',
			}
	
	DeferredUnpackOrdinals = {
			KAE::KAEFirst => ['first', AEMReference::MultipleElements::First],
			KAE::KAELast => ['last', AEMReference::MultipleElements::Last],
			KAE::KAEMiddle => ['middle', AEMReference::MultipleElements::Middle],
			KAE::KAEAny => ['any', AEMReference::MultipleElements::Any],
			}
	
	# InsertionLoc keys and comparison and logic comparison operators aren't unpacked before use,
	# so need to call _fourCharCodes to swap bytes here.
	
	def Codecs._fourCharCode(code)
		return code.unpack('N').pack('L')
	end
	
	InsertionLocEnums = {
			_fourCharCode(KAE::KAEBefore) => 'before', 
			_fourCharCode(KAE::KAEAfter) => 'after', 
			_fourCharCode(KAE::KAEBeginning) => 'start',
			_fourCharCode(KAE::KAEEnd) => 'end',
			}

	ComparisonEnums = {
			_fourCharCode(KAE::KAEGreaterThan) => 'gt',
			_fourCharCode(KAE::KAEGreaterThanEquals) => 'ge',
			_fourCharCode(KAE::KAEEquals) => 'eq',
			_fourCharCode(KAE::KAELessThan) => 'lt',
			_fourCharCode(KAE::KAELessThanEquals) => 'le',
			_fourCharCode(KAE::KAEBeginsWith) => 'startswith',
			_fourCharCode(KAE::KAEEndsWith) => 'endswith',
			_fourCharCode(KAE::KAEContains) => 'contains',
			}

	LogicalEnums = {
			_fourCharCode(KAE::KAEAND) => 'and',
			_fourCharCode(KAE::KAEOR) => 'or',
			_fourCharCode(KAE::KAENOT) => 'not',
			}
	
	#######
	
	def fullyUnpackObjectSpecifier(desc) 
		# Codecs.unpackObjectSpecifier and DeferredSpecifier._realRef will call this when needed
		case desc.type
			when KAE::TypeNull then return self.class::App
			when KAE::TypeCurrentContainer then return self.class::Con
			when KAE::TypeObjectBeingExamined then return self.class::Its
		end
		rec = _descToHash(desc)
		want = unpack(rec[KAE::KeyAEDesiredClass]).code 
		keyForm = unpack(rec[KAE::KeyAEKeyForm]).code
		key = unpack(rec[KAE::KeyAEKeyData])
		ref = unpack(rec[KAE::KeyAEContainer])
		if ref == nil
			ref = self.class::App
		end
		if keyForm == KAE::FormPropertyID
			return ref.property(key.code)
		elsif keyForm == 'usrp'
			return ref.userproperty(key)
		elsif keyForm == KAE::FormRelativePosition
			if key.code == KAE::KAEPrevious
				return ref.previous(want)
			elsif key.code == KAE::KAENext
				return ref.next(want)
			else
				raise RuntimeError, "Bad relative position selector: #{key}"
			end
		else
			ref = ref.elements(want)
			if keyForm == KAE::FormName
				return ref.byname(key)
			elsif keyForm == KAE::FormAbsolutePosition
				if key.is_a?(Ordinal)
					if key.code == KAE::KAEAll
						return ref
					else
						return ref.send(FullUnpackOrdinals[key.code])
					end
				else
					return ref.byindex(key)
				end
			elsif keyForm == KAE::FormUniqueID
				return ref.byid(key)
			elsif keyForm == KAE::FormRange
				return ref.byrange(*key.range)
			elsif keyForm == KAE::FormTest
				return ref.byfilter(key)
			end
		end
		raise TypeError
	end
	
	##
	
	def unpackObjectSpecifier(desc) 
		# defers full unpacking of [most] object specifiers for efficiency
		rec = _descToHash(desc)
		keyForm = unpack(rec[KAE::KeyAEKeyForm]).code
		if [KAE::FormPropertyID, KAE::FormAbsolutePosition, KAE::FormName, KAE::FormUniqueID].include?(keyForm)
			want = unpack(rec[KAE::KeyAEDesiredClass]).code
			key = unpack(rec[KAE::KeyAEKeyData])
			container = AEMReference::DeferredSpecifier.new(rec[KAE::KeyAEContainer], self)
			if keyForm == KAE::FormPropertyID
				ref = AEMReference::Property.new(want, container, key.code)
			elsif keyForm == KAE::FormAbsolutePosition
				if key.is_a?(Ordinal)
					if key.code == KAE::KAEAll
						ref = AEMReference::AllElements.new(want, container)
					else
						keyname, key = DeferredUnpackOrdinals[key.code]
						ref = AEMReference::ElementByOrdinal.new(want, AEMReference::UnkeyedElements.new(want, container), key, keyname)
					end
				else
					ref = AEMReference::ElementByIndex.new(want, AEMReference::UnkeyedElements.new(want, container), key)
				end
			elsif keyForm == KAE::FormName
				ref = AEMReference::ElementByName.new(want, AEMReference::UnkeyedElements.new(want, container), key)
			elsif keyForm == KAE::FormUniqueID
				ref = AEMReference::ElementByID.new(want, AEMReference::UnkeyedElements.new(want, container), key)
			end
			ref.AEM_setDesc(desc) # retain existing AEDesc for efficiency
			return ref
		else # do full unpack of more complex, rarely returned reference forms
			return fullyUnpackObjectSpecifier(desc)
		end
	end
			
	
	def unpackInsertionLoc(desc)
		rec = _descToHash(desc)
		return unpackObjectSpecifier(rec[KAE::KeyAEObject]).send(InsertionLocEnums[rec[KAE::KeyAEPosition].data])
	end
	
	##
	
	def unpackAbsoluteOrdinal(desc)
		return Ordinal.new(fourCharCode(desc.data))
	end
	
	def unpackCurrentContainer(desc)
		return Con
	end
	
	def unpackObjectBeingExamined(desc)
		return Its
	end
	
	##
	
	def unpackContainsCompDescriptor(op1, op2)
		# KAEContains is also used to construct 'isin' tests, where test value is first operand and
		# reference being tested is second operand, so need to make sure first operand is an its-based ref;
		# if not, rearrange accordingly.
		# Since type-checking is involved, this extra hook is provided so that appscript's AppData subclass can override this method to add its own type checking
		if  op1.is_a?(AEMReference::Base) and op1.AEM_root == AEMReference::Its
			return op1.contains(op2)
		else
			return op2.isin(op1)
		end
	end
	
	def unpackCompDescriptor(desc)
		rec = _descToHash(desc)
		operator = ComparisonEnums[rec[KAE::KeyAECompOperator].data]
		op1 = unpack(rec[KAE::KeyAEObject1])
		op2 = unpack(rec[KAE::KeyAEObject2])
		if operator == 'contains'
			return unpackContainsCompDescriptor(op1, op2)
		else
			return op1.send(operator, op2)
		end
	end
	
	def unpackLogicalDescriptor(desc)
		rec = _descToHash(desc)
		operator = LogicalEnums[rec[KAE::KeyAELogicalOperator].data]
		operands = unpack(rec[KAE::KeyAELogicalTerms])
		return operands[0].send(operator, *operands[1, operands.length])
	end
	
	def unpackRangeDescriptor(desc)
		rec = _descToHash(desc)
		return Range.new([unpack(rec[KAE::KeyAERangeStart]), unpack(rec[KAE::KeyAERangeStop])])
	end
	
end

DefaultCodecs = Codecs.new

