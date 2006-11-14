#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "ae"
require "kae"
require "_aem/typewrappers"
require "_aem/aemreference"
require "mactypes"

# Note that AE strings (typeChar, typeUnicodeText, etc.) are unpacked as UTF8-encoded Ruby strings, and UTF8-encoded Ruby strings are packed as typeUnicodeText. Using UTF8 on the Ruby side avoids data loss; using typeUnicodeText on the AEM side provides compatibility with all [reasonably well designed] applications. To change this behaviour (e.g. to support legacy apps that demand typeChar and break on typeUnicodeText), subclass Codecs and override pack and/or unpack methods to provide alternative packing/unpacking of string values. Users can also pack data manually using AE::AEDesc.new(type, data).


######################################################################
# UNIT TYPE CODECS
######################################################################


class UnitTypeCodecs

	DefaultUnitTypes = [
		[:centimeters, KAE::TypeCentimeters],
		[:meters, KAE::TypeMeters],
		[:kilometers, KAE::TypeKilometers],
		[:inches, KAE::TypeInches],
		[:feet, KAE::TypeFeet],
		[:yards, KAE::TypeYards],
		[:miles, KAE::TypeMiles],
		
		[:square_meters, KAE::TypeSquareMeters],
		[:square_kilometers, KAE::TypeSquareKilometers],
		[:square_feet, KAE::TypeSquareFeet],
		[:square_yards, KAE::TypeSquareYards],
		[:square_miles, KAE::TypeSquareMiles],
		
		[:cubic_centimeters, KAE::TypeCubicCentimeter],
		[:cubic_meters, KAE::TypeCubicMeters],
		[:cubic_inches, KAE::TypeCubicInches],
		[:cubic_feet, KAE::TypeCubicFeet],
		[:cubic_yards, KAE::TypeCubicYards],
		
		[:liters, KAE::TypeLiters],
		[:quarts, KAE::TypeQuarts],
		[:gallons, KAE::TypeGallons],
		
		[:grams, KAE::TypeGrams],
		[:kilograms, KAE::TypeKilograms],
		[:ounces, KAE::TypeOunces],
		[:pounds, KAE::TypePounds],
		
		[:Celsius, KAE::TypeDegreesC],
		[:Fahrenheit, KAE::TypeDegreesF],
		[:Kelvin, KAE::TypeDegreesK],
	]
	
	DefaultPacker = proc { |value, code| AE::AEDesc.new(code, [value].pack('d')) }
	DefaultUnpacker = proc { |desc, name| MacTypes::Units.new(desc.data.unpack('d')[0], name) }

	def initialize
		@type_by_name = {}
		@type_by_code = {}
		add_types(DefaultUnitTypes)
	end
	
	def add_types(typedefs)
		# typedefs is a list of lists, where each sublist is of form:
		#	[typename, typecode, packproc, unpackproc]
		# or:
		#	[typename, typecode, packproc, unpackproc]
		# If optional packproc and unpackproc are omitted, default pack/unpack procs
		# are used instead; these pack/unpack AEDesc data as a double precision float.
		typedefs.each do |name, code, packer, unpacker|
			@type_by_name[name] = [code, (packer or DefaultPacker)]
			@type_by_code[code] = [name, (unpacker or DefaultUnpacker)]
		end
	end
	
	def pack(val)
		if val.is_a?(MacTypes::Units)
			code, packer = @type_by_name.fetch(val.type) { |val| raise IndexError, "Unknown unit type: #{val.inspect}" }
			return [true, packer.call(val.value, code)]
		else
			return [false, val]
		end
	end
	
	def unpack(desc)
		name, unpacker = @type_by_code.fetch(desc.type) { |desc| return [false, desc] }
		return [true, unpacker.call(desc, name)]
	end
end


######################################################################
# CODECS
######################################################################
# Endianness support

module BigEndianConverters
	
	def four_char_code(code)
		return code
	end

end


module SmallEndianConverters
	
	def four_char_code(code)
		return code.reverse
	end
	
end


######################################################################

class NotUTF8TextError < RuntimeError
end


class Codecs
	
	extend([1].pack('s') == "\001\000" ? SmallEndianConverters : BigEndianConverters)

	def initialize
		@unit_type_codecs = UnitTypeCodecs.new
	end
	
	def addunits(types)
		@unit_type_codecs.add_types(types)
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
	
	##
	
	def pack_unknown(val) # clients may override this to provide additional packers
		raise TypeError, "Can't pack data into an AEDesc (unsupported type): #{val.inspect}"
	end
	
	
	def pack(val) # clients may override this to replace existing packers
		if val.is_a?(AEMReference::Base) then val.AEM_pack_self(self)
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
					[AE.convert_unix_seconds_to_long_date_time(val.to_i)].pack('q'))
		elsif val.is_a?(Array) then pack_array(val)
		elsif val.is_a?(Hash) then pack_hash(val)
		elsif val.is_a?(MacTypes::FileBase) then val.desc
		elsif val.is_a?(TypeWrappers::AEType) then
			AE::AEDesc.new(KAE::TypeType, Codecs.four_char_code(val.code))
		elsif val.is_a?(TypeWrappers::AEEnum) then
			AE::AEDesc.new(KAE::TypeEnumerated, Codecs.four_char_code(val.code))
		elsif val.is_a?(TypeWrappers::AEProp) then 
			AE::AEDesc.new(KAE::TypeProperty, Codecs.four_char_code(val.code))
		elsif val.is_a?(TypeWrappers::AEKey) then
			AE::AEDesc.new(KAE::TypeKeyword, Codecs.four_char_code(val.code))
		elsif val.is_a?(TypeWrappers::AEEventName) then 
			AE::AEDesc.new(KAE::TypeEventName, val.code)
		elsif val.is_a?(AE::AEDesc) then val
		else
			did_pack, desc = @unit_type_codecs.pack(val)
			if did_pack
				desc
			else
				pack_unknown(val)
			end
		end
	end
	
	#######
	
	def pack_array(val)
		lst = AE::AEDesc.new_list(false)
		val.each do |item|
			lst.put_item(0, pack(item))
		end
		return lst
	end
	
	def pack_hash(val)
		record = AE::AEDesc.new_list(true)
		usrf = nil
		val.each do | key, value |
			if key.is_a?(TypeWrappers::AETypeBase)
				if key.code == 'pcls' # AS packs records that contain a 'class' property by coercing the packed record to that type at the end
					begin
						record = record.coerce(value.code)
					rescue
						record.put_param(key.code, pack(value))
					end
				else
					record.put_param(key.code, pack(value))
				end
			else
				if usrf == nil
					usrf = AE::AEDesc.new_list(false)
				end
				usrf.put_item(0, pack(key))
				usrf.put_item(0, pack(value))
			end
		end
		if usrf
			record.put_param('usrf', usrf)
		end
		return record
	end
	
	######################################################################
	# Unpack
	
	def unpack_unknown(desc) # clients may override this to provide additional unpackers
		if desc.is_record? # if it's a record-like structure with an unknown/unsupported type then unpack it as a hash, including the original type info as a 'class' property
			rec = desc.coerce(KAE::TypeAERecord)
			rec.put_param('pcls', pack(TypeWrappers::AEType.new(desc.type)))
			unpack(rec)
		else # else return unchanged
			desc
		end
	end
	
	
	def unpack(desc) # clients may override this to replace existing unpackers
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
				Time.at(AE.convert_long_date_time_to_unix_seconds(desc.data.unpack('q')[0]))
				
			when KAE::TypeVersion
				vers, lo = desc.data.unpack('CC')
				subvers, patch = lo.divmod(16)
				"#{vers}.#{subvers}.#{patch}"
			
			when KAE::TypeAEList then unpack_aelist(desc)
			when KAE::TypeAERecord then unpack_aerecord(desc)
			
			when KAE::TypeAlias then MacTypes::Alias.desc(desc)
			when KAE::TypeFSS then MacTypes::FileURL.desc(desc)
			when KAE::TypeFSRef then MacTypes::FileURL.desc(desc)
			when KAE::TypeFileURL then MacTypes::FileURL.desc(desc)
			
			when KAE::TypeQDPoint then desc.data.unpack('ss').reverse
			when KAE::TypeQDRectangle then
				x1, y1, x2, y2 = desc.data.unpack('ssss')
				[y1, x1, y2, x2]
			when KAE::TypeRGBColor then desc.data.unpack('SSS')
			
			when KAE::TypeType then unpack_type(desc)
			when KAE::TypeEnumerated then unpack_enumerated(desc)
			when KAE::TypeProperty then unpack_property(desc)
			when KAE::TypeKeyword then unpack_keyword(desc)
			when KAE::TypeEventName then unpack_event_name(desc)
			
			when KAE::TypeInsertionLoc then unpack_insertion_loc(desc)
			when KAE::TypeObjectSpecifier then unpack_object_specifier(desc)
			when KAE::TypeAbsoluteOrdinal then unpack_absolute_ordinal(desc)
			when KAE::TypeCurrentContainer then unpack_current_container(desc)
			when KAE::TypeObjectBeingExamined then unpack_object_being_examined(desc)
			when KAE::TypeCompDescriptor then unpack_comp_descriptor(desc)
			when KAE::TypeLogicalDescriptor then unpack_logical_descriptor(desc)
			when KAE::TypeRangeDescriptor then unpack_range_descriptor(desc)
			
		else
			did_unpack, val = @unit_type_codecs.unpack(desc)
			if did_unpack
				val
			else
				unpack_unknown(desc)
			end
		end
	end
	
	#######
	
	def unpack_aelist(desc)
		lst = []
		desc.length().times do |i|
			lst.push(unpack(desc.get(i + 1, KAE::TypeWildCard)[1]))
		end
		return lst
	end

	def unpack_aerecord(desc)
		dct = {}
		desc.length().times do |i|
			key, value = desc.get(i + 1, KAE::TypeWildCard)
			if key == 'usrf'
				lst = unpack_aelist(value)
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
	
	def unpack_type(desc)
		return TypeWrappers::AEType.new(Codecs.four_char_code(desc.data))
	end
	
	def unpack_enumerated(desc)
		return TypeWrappers::AEEnum.new(Codecs.four_char_code(desc.data))
	end
	
	def unpack_property(desc)
		return TypeWrappers::AEProp.new(Codecs.four_char_code(desc.data))
	end
	
	def unpack_keyword(desc)
		return TypeWrappers::AEKey.new(Codecs.four_char_code(desc.data))
	end
	
	def unpack_event_name(desc)
		return TypeWrappers::AEEventName.new(desc.data)
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
	
	def _desc_to_hash(desc)
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
	# so need to call four_char_codes to swap bytes here.
	
	InsertionLocEnums = {
			Codecs.four_char_code(KAE::KAEBefore) => 'before', 
			Codecs.four_char_code(KAE::KAEAfter) => 'after', 
			Codecs.four_char_code(KAE::KAEBeginning) => 'start',
			Codecs.four_char_code(KAE::KAEEnd) => 'end',
			}

	ComparisonEnums = {
			Codecs.four_char_code(KAE::KAEGreaterThan) => 'gt',
			Codecs.four_char_code(KAE::KAEGreaterThanEquals) => 'ge',
			Codecs.four_char_code(KAE::KAEEquals) => 'eq',
			Codecs.four_char_code(KAE::KAELessThan) => 'lt',
			Codecs.four_char_code(KAE::KAELessThanEquals) => 'le',
			Codecs.four_char_code(KAE::KAEBeginsWith) => 'starts_with',
			Codecs.four_char_code(KAE::KAEEndsWith) => 'ends_with',
			Codecs.four_char_code(KAE::KAEContains) => 'contains',
			}

	LogicalEnums = {
			Codecs.four_char_code(KAE::KAEAND) => 'and',
			Codecs.four_char_code(KAE::KAEOR) => 'or',
			Codecs.four_char_code(KAE::KAENOT) => 'not',
			}
	
	#######
	
	def fully_unpack_object_specifier(desc) 
		# Codecs.unpack_object_specifier and DeferredSpecifier._real_ref will call this when needed
		case desc.type
			when KAE::TypeNull then return self.class::App
			when KAE::TypeCurrentContainer then return self.class::Con
			when KAE::TypeObjectBeingExamined then return self.class::Its
		end
		rec = _desc_to_hash(desc)
		want = unpack(rec[KAE::KeyAEDesiredClass]).code 
		key_form = unpack(rec[KAE::KeyAEKeyForm]).code
		key = unpack(rec[KAE::KeyAEKeyData])
		ref = unpack(rec[KAE::KeyAEContainer])
		if ref == nil
			ref = self.class::App
		end
		if key_form == KAE::FormPropertyID
			return ref.property(key.code)
		elsif key_form == 'usrp'
			return ref.userproperty(key)
		elsif key_form == KAE::FormRelativePosition
			if key.code == KAE::KAEPrevious
				return ref.previous(want)
			elsif key.code == KAE::KAENext
				return ref.next(want)
			else
				raise RuntimeError, "Bad relative position selector: #{key}"
			end
		else
			ref = ref.elements(want)
			if key_form == KAE::FormName
				return ref.by_name(key)
			elsif key_form == KAE::FormAbsolutePosition
				if key.is_a?(Ordinal)
					if key.code == KAE::KAEAll
						return ref
					else
						return ref.send(FullUnpackOrdinals[key.code])
					end
				else
					return ref.by_index(key)
				end
			elsif key_form == KAE::FormUniqueID
				return ref.by_id(key)
			elsif key_form == KAE::FormRange
				return ref.by_range(*key.range)
			elsif key_form == KAE::FormTest
				return ref.by_filter(key)
			end
		end
		raise TypeError
	end
	
	##
	
	def unpack_object_specifier(desc) 
		# defers full unpacking of [most] object specifiers for efficiency
		rec = _desc_to_hash(desc)
		key_form = unpack(rec[KAE::KeyAEKeyForm]).code
		if [KAE::FormPropertyID, KAE::FormAbsolutePosition, KAE::FormName, KAE::FormUniqueID].include?(key_form)
			want = unpack(rec[KAE::KeyAEDesiredClass]).code
			key = unpack(rec[KAE::KeyAEKeyData])
			container = AEMReference::DeferredSpecifier.new(rec[KAE::KeyAEContainer], self)
			if key_form == KAE::FormPropertyID
				ref = AEMReference::Property.new(want, container, key.code)
			elsif key_form == KAE::FormAbsolutePosition
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
			elsif key_form == KAE::FormName
				ref = AEMReference::ElementByName.new(want, AEMReference::UnkeyedElements.new(want, container), key)
			elsif key_form == KAE::FormUniqueID
				ref = AEMReference::ElementByID.new(want, AEMReference::UnkeyedElements.new(want, container), key)
			end
			ref.AEM_set_desc(desc) # retain existing AEDesc for efficiency
			return ref
		else # do full unpack of more complex, rarely returned reference forms
			return fully_unpack_object_specifier(desc)
		end
	end
			
	
	def unpack_insertion_loc(desc)
		rec = _desc_to_hash(desc)
		return unpack_object_specifier(rec[KAE::KeyAEObject]).send(InsertionLocEnums[rec[KAE::KeyAEPosition].data])
	end
	
	##
	
	def unpack_absolute_ordinal(desc)
		return Ordinal.new(Codecs.four_char_code(desc.data))
	end
	
	def unpack_current_container(desc)
		return Con
	end
	
	def unpack_object_being_examined(desc)
		return Its
	end
	
	##
	
	def unpack_contains_comp_descriptor(op1, op2)
		# KAEContains is also used to construct 'is_in' tests, where test value is first operand and
		# reference being tested is second operand, so need to make sure first operand is an its-based ref;
		# if not, rearrange accordingly.
		# Since type-checking is involved, this extra hook is provided so that appscript's AppData subclass can override this method to add its own type checking
		if  op1.is_a?(AEMReference::Base) and op1.AEM_root == AEMReference::Its
			return op1.contains(op2)
		else
			return op2.is_in(op1)
		end
	end
	
	def unpack_comp_descriptor(desc)
		rec = _desc_to_hash(desc)
		operator = ComparisonEnums[rec[KAE::KeyAECompOperator].data]
		op1 = unpack(rec[KAE::KeyAEObject1])
		op2 = unpack(rec[KAE::KeyAEObject2])
		if operator == 'contains'
			return unpack_contains_comp_descriptor(op1, op2)
		else
			return op1.send(operator, op2)
		end
	end
	
	def unpack_logical_descriptor(desc)
		rec = _desc_to_hash(desc)
		operator = LogicalEnums[rec[KAE::KeyAELogicalOperator].data]
		operands = unpack(rec[KAE::KeyAELogicalTerms])
		return operands[0].send(operator, *operands[1, operands.length])
	end
	
	def unpack_range_descriptor(desc)
		rec = _desc_to_hash(desc)
		return Range.new([unpack(rec[KAE::KeyAERangeStart]), unpack(rec[KAE::KeyAERangeStop])])
	end
	
end

DefaultCodecs = Codecs.new

