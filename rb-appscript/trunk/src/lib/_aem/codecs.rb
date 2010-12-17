#
# rb-appscript
#
# codecs -- convert native Ruby objects to AEDescs, and vice-versa
#

require "date"

require "ae"
require "kae"
require "_aem/typewrappers"
require "_aem/aemreference"
require "_aem/mactypes"
require "_aem/encodingsupport"

# Note that AE strings (typeChar, typeUnicodeText, etc.) are unpacked as UTF8-encoded Ruby strings, and UTF8-encoded Ruby strings are packed as typeUnicodeText. Using UTF8 on the Ruby side avoids data loss; using typeUnicodeText on the AEM side provides compatibility with all [reasonably well designed] applications. To change this behaviour (e.g. to support legacy apps that demand typeChar and break on typeUnicodeText), subclass Codecs and override pack and/or unpack methods to provide alternative packing/unpacking of string values. Users can also pack data manually using AE::AEDesc.new(type, data).


######################################################################
# UNIT TYPE CODECS
######################################################################


class UnitTypeCodecs
	# Provides pack and unpack methods for converting between MacTypes::Units instances
	# and AE unit types. Each Codecs instance is allocated its own UnitTypeCodecs instance,
	#

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
		
		[:degrees_Celsius, KAE::TypeDegreesC],
		[:degrees_Fahrenheit, KAE::TypeDegreesF],
		[:degrees_Kelvin, KAE::TypeDegreesK],
	]
	
	DefaultPacker = proc { |units, code| AE::AEDesc.new(code, [units.value].pack('d')) }
	DefaultUnpacker = proc { |desc, name| MacTypes::Units.new(desc.data.unpack('d')[0], name) }

	def initialize
		@type_by_name = {}
		@type_by_code = {}
		add_types(DefaultUnitTypes)
	end
	
	def add_types(type_defs)
		# type_defs is a list of lists, where each sublist is of form:
		#	[typename, typecode, packproc, unpackproc]
		# or:
		#	[typename, typecode]
		# If optional packproc and unpackproc are omitted, default pack/unpack procs
		# are used instead; these pack/unpack AEDesc data as a double precision float.
		type_defs.each do |name, code, packer, unpacker|
			@type_by_name[name] = [code, (packer or DefaultPacker)]
			@type_by_code[code] = [name, (unpacker or DefaultUnpacker)]
		end
	end
	
	def pack(val)
		if val.is_a?(MacTypes::Units)
			code, packer = @type_by_name.fetch(val.type) { |v| raise IndexError, "Unknown unit type: #{v.inspect}" }
			return [true, packer.call(val, code)]
		else
			return [false, val]
		end
	end
	
	def unpack(desc)
		name, unpacker = @type_by_code.fetch(desc.type) { |d| return [false, d] }
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

module DisableObjectSpecifierCaching
	def unpack_object_specifier(desc)
		return fully_unpack_object_specifier(desc)
	end
end

#######

class Codecs
	# Provides pack and unpack methods for converting data between Ruby and AE types.
	#
	# May be subclassed to extend/alter its behaviour (e.g. the appscript layer does this).
	# Conversions that are most likely to be modified (e.g. for packing and and unpacking
	# references, records, types and enums) are exposed as overrideable hook methods.
	
	extend([1].pack('s') == "\001\000" ? SmallEndianConverters : BigEndianConverters)

	def initialize
		@unit_type_codecs = UnitTypeCodecs.new
		# Note: while typeUnicodeText is deprecated (see AEDataModel.h), it's still the
		# most commonly used Unicode type so is used here for compatibility's sake.
		# typeUTF8Text was initially tried, but existing applications had problems with it; i.e.
		# some apps make unsafe assumptions on what to expect based on AS's behaviour.
		# Once AppleScript is using typeUTF8Text/typeUTF16ExternalRepresentation
		# and existing applications don't choke, this code can be similarly upgraded.
		@pack_text_as_type = KAE::TypeUnicodeText
		# on Ruby 1.9+, set String encoding to UTF-8
		@encoding_support = AEMEncodingSupport.encoding_support
		@unpack_dates_as_datetime = false
	end
	
	######################################################################
	# Compatibility options
	
	def add_unit_types(type_defs)
		# register custom unit type definitions with this Codecs instance
		# e.g. Adobe apps define additional unit types (ciceros, pixels, etc.)
		@unit_type_codecs.add_types(type_defs)
	end
	
	def dont_cache_unpacked_specifiers
		# When unpacking object specifiers, unlike AppleScript, appscript caches
		# the original AEDesc for efficiency, allowing the resulting reference to
		# be re-packed much more quickly. Occasionally this causes compatibility
		# problems with applications that returned subtly malformed specifiers.
		# To force a Codecs object to fully unpack and repack object specifiers,
		# call its dont_cache_unpacked_specifiers method.
		extend(DisableObjectSpecifierCaching)
	end

	def pack_strings_as_type(code)
		# Some older (pre-OS X) applications may require text to be passed as 
		# typeChar or typeIntlText rather than the usual typeUnicodeText. To force
		# an AEM::Codecs object to pack strings as one of these older types, call 
		# its pack_strings_as_type method, specifying the type you want used instead.
		if not(code.is_a?(String) and code.length == 4)
			raise ArgumentError, "Code must be a four-character string: #{code.inspect}"
		end
		@pack_text_as_type = code
	end
	
	def use_ascii_8bit
		# By default on Ruby 1.9+, Codecs#pack creates String instances with UTF-8 
		# encoding and #unpack ensures all strings are UTF-8 encoded before packing 
		# them into AEDescs of typeUTF8Text. To force the old-style behaviour where
		# strings are treated as byte strings containing UTF-8 data, call:
		#
		#	some_application.AS_app_data.use_ascii_8bit_strings
		#
		# This will cause Strings to use the binary ASCII-8BIT encoding; as in Ruby 1.8, 
		# the user is responsible for ensuring that strings contain UTF-8 data.
		@encoding_support = AEMEncodingSupport::DisableStringEncodings
	end
	
	def use_datetime
		# By default dates are unpacked as Time instances, which have limited range.
		# Call this method to unpack dates as DateTime instances instead.
		@unpack_dates_as_datetime = true
	end

	######################################################################
	# Subclasses could override these to provide their own reference roots if needed
	
	App = AEMReference::App
	Con = AEMReference::Con
	Its = AEMReference::Its
	
	######################################################################
	# Pack
	
	SInt32Bounds = (-2**31)..(2**31-1)
	SInt64Bounds = (-2**63)..(2**63-1)
	UInt64Bounds = (2**63)..(2**64-1)

	NullDesc = AE::AEDesc.new(KAE::TypeNull, '')
	TrueDesc = AE::AEDesc.new(KAE::TypeTrue, '')
	FalseDesc = AE::AEDesc.new(KAE::TypeFalse, '')
	
	##
	
	def pack_unknown(val) # clients may override this to provide additional packers
		raise TypeError, "Can't pack data into an AEDesc (unsupported type): #{val.inspect}"
	end
	
	
	def pack(val) # clients may override this to replace existing packers
		case val
			when AEMReference::Query then val.AEM_pack_self(self)
			
			when Fixnum, Bignum then
				if SInt32Bounds === val
					AE::AEDesc.new(KAE::TypeSInt32, [val].pack('l')) 
				elsif SInt64Bounds === val
					AE::AEDesc.new(KAE::TypeSInt64, [val].pack('q'))
				elsif UInt64Bounds === val
					pack_uint64(val)
				else
					AE::AEDesc.new(KAE::TypeFloat, [val.to_f].pack('d'))
				end
			
			when String then 
				@encoding_support.pack_string(val, @pack_text_as_type)
			
			when TrueClass then TrueDesc
			when FalseClass then FalseDesc
			
			when Float then AE::AEDesc.new(KAE::TypeFloat, [val].pack('d'))
			
			when Time
				AE::AEDesc.new(KAE::TypeLongDateTime,
					[AE.convert_unix_seconds_to_long_date_time(val.to_i)].pack('q'))
			
			when DateTime, Date then
				AE::AEDesc.new(KAE::TypeLongDateTime,
					[AE.convert_string_to_long_date_time(val.strftime('%F %T'))].pack('q'))
			
			when Array then pack_array(val)
			when Hash then pack_hash(val)
			
			when MacTypes::FileBase then val.desc
			
			when TypeWrappers::AEType then
				AE::AEDesc.new(KAE::TypeType, Codecs.four_char_code(val.code))
			when TypeWrappers::AEEnum then
				AE::AEDesc.new(KAE::TypeEnumerated, Codecs.four_char_code(val.code))
			when TypeWrappers::AEProp then 
				AE::AEDesc.new(KAE::TypeProperty, Codecs.four_char_code(val.code))
			when TypeWrappers::AEKey then
				AE::AEDesc.new(KAE::TypeKeyword, Codecs.four_char_code(val.code))
			
			when AE::AEDesc then val
				
			when NilClass then NullDesc
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
	
	def pack_uint64(val) 
		# On 10.5+, clients could override this method to do a non-lossy conversion,
		# (assuming target app knows how to handle new UInt64 type):
		#
		# def pack_uint64(val)
		# 	AE::AEDesc.new(KAE::TypeUInt64, [val.to_f].pack('Q'))
		# end
		AE::AEDesc.new(KAE::TypeFloat, [val.to_f].pack('d')) # pack as 64-bit float for compatibility (lossy conversion)
	end
	
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
				if key.code == KAE::PClass # AS packs records that contain a 'class' property by coercing the packed record to that type at the end
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
			record.put_param(KAE::KeyASUserRecordFields, usrf)
		end
		return record
	end
	
	######################################################################
	# Unpack
	
	def unpack_unknown(desc) # clients may override this to provide additional unpackers
		if desc.is_record? # if it's a record-like structure with an unknown/unsupported type then unpack it as a hash, including the original type info as a 'class' property
			rec = desc.coerce(KAE::TypeAERecord)
			rec.put_param(KAE::PClass, pack(TypeWrappers::AEType.new(desc.type)))
			unpack(rec)
		else # else return unchanged
			desc
		end
	end
	
	
	def unpack(desc) # clients may override this to replace existing unpackers
		return case desc.type
			
			when KAE::TypeObjectSpecifier then unpack_object_specifier(desc)
			
			when KAE::TypeSInt32 then desc.data.unpack('l')[0]
			when KAE::TypeIEEE64BitFloatingPoint then desc.data.unpack('d')[0]
			
			when 
					KAE::TypeUnicodeText,
					KAE::TypeChar, 
					KAE::TypeIntlText, 
					KAE::TypeUTF16ExternalRepresentation,
					KAE::TypeStyledText
				@encoding_support.unpack_string(desc)
				
			when KAE::TypeFalse then false
			when KAE::TypeTrue then true
			
			when KAE::TypeLongDateTime then
				t = desc.data.unpack('q')[0]
				if @unpack_dates_as_datetime
					DateTime.strptime(AE.convert_long_date_time_to_string(t), '%F %T')
				else
					Time.at(AE.convert_long_date_time_to_unix_seconds(t))
				end
			
			when KAE::TypeAEList then unpack_aelist(desc)
			when KAE::TypeAERecord then unpack_aerecord(desc)
			
			when KAE::TypeAlias then MacTypes::Alias.desc(desc)
			when 
					KAE::TypeFileURL,
					KAE::TypeFSRef,
					KAE::TypeFSS
				MacTypes::FileURL.desc(desc)
			
			when KAE::TypeType then unpack_type(desc)
			when KAE::TypeEnumerated then unpack_enumerated(desc)
			when KAE::TypeProperty then unpack_property(desc)
			when KAE::TypeKeyword then unpack_keyword(desc)
			
			when KAE::TypeSInt16 then desc.data.unpack('s')[0]
			when KAE::TypeUInt32 then desc.data.unpack('L')[0]
			when KAE::TypeSInt64 then desc.data.unpack('q')[0]
			
			when KAE::TypeNull then nil
			
			when KAE::TypeUTF8Text then desc.data
			
			when KAE::TypeInsertionLoc then unpack_insertion_loc(desc)
			when KAE::TypeCurrentContainer then unpack_current_container(desc)
			when KAE::TypeObjectBeingExamined then unpack_object_being_examined(desc)
			when KAE::TypeCompDescriptor then unpack_comp_descriptor(desc)
			when KAE::TypeLogicalDescriptor then unpack_logical_descriptor(desc)
			
			when KAE::TypeIEEE32BitFloatingPoint then desc.data.unpack('f')[0]
			when KAE::Type128BitFloatingPoint then 
				desc.coerce(KAE::TypeIEEE64BitFloatingPoint).data.unpack('d')[0]
			
			when KAE::TypeQDPoint then desc.data.unpack('ss').reverse
			when KAE::TypeQDRectangle then
				x1, y1, x2, y2 = desc.data.unpack('ssss')
				[y1, x1, y2, x2]
			when KAE::TypeRGBColor then desc.data.unpack('SSS')
				
			when KAE::TypeVersion
				begin
					unpack(desc.coerce(KAE::TypeUnicodeText)) # supported in 10.4+
				rescue
					vers, lo = desc.data.unpack('CC')
					subvers, patch = lo.divmod(16)
					"#{vers}.#{subvers}.#{patch}"
				end	
			when KAE::TypeBoolean then desc.data[0,1] != "\000"
			
			when KAE::TypeUInt16 then desc.data.unpack('S')[0] # 10.5+
			when KAE::TypeUInt64 then desc.data.unpack('Q')[0] # 10.5+
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
			lst.push(unpack(desc.get_item(i + 1, KAE::TypeWildCard)[1]))
		end
		return lst
	end

	def unpack_aerecord(desc)
		dct = {}
		desc.length().times do |i|
			key, value = desc.get_item(i + 1, KAE::TypeWildCard)
			if key == KAE::KeyASUserRecordFields
				lst = unpack_aelist(value)
				(lst.length / 2).times do |j|
					dct[lst[j * 2]] = lst[j * 2 + 1]
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
	
	#######
	# Lookup tables for converting enumerator, ordinal codes to aem reference method names.
	# Used by unpack_object_specifier, fully_unpack_object_specifier to construct aem references.
	
	AbsoluteOrdinals = {
			Codecs.four_char_code(KAE::KAEFirst) => 'first', 
			Codecs.four_char_code(KAE::KAELast) => 'last', 
			Codecs.four_char_code(KAE::KAEMiddle) => 'middle', 
			Codecs.four_char_code(KAE::KAEAny) => 'any',
			}
	
	AllAbsoluteOrdinal = Codecs.four_char_code(KAE::KAEAll)
	
	RelativePositionEnums = {
			Codecs.four_char_code(KAE::KAEPrevious) => 'previous', 
			Codecs.four_char_code(KAE::KAENext) => 'next', 
			}
	
	InsertionLocEnums = {
			Codecs.four_char_code(KAE::KAEBefore) => 'before', 
			Codecs.four_char_code(KAE::KAEAfter) => 'after', 
			Codecs.four_char_code(KAE::KAEBeginning) => 'beginning',
			Codecs.four_char_code(KAE::KAEEnd) => 'end',
			}

	ComparisonEnums = {
			Codecs.four_char_code(KAE::KAEGreaterThan) => 'gt',
			Codecs.four_char_code(KAE::KAEGreaterThanEquals) => 'ge',
			Codecs.four_char_code(KAE::KAEEquals) => 'eq',
			Codecs.four_char_code(KAE::KAELessThan) => 'lt',
			Codecs.four_char_code(KAE::KAELessThanEquals) => 'le',
			Codecs.four_char_code(KAE::KAEBeginsWith) => 'begins_with',
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
		# Recursively unpack an object specifier and all of its container descs.
		# (Note: Codecs#unpack_object_specifier and AEMReference::DeferredSpecifier#_real_ref will call this when needed.)
		case desc.type
			when KAE::TypeObjectSpecifier
				want = Codecs.four_char_code(desc.get_param(KAE::KeyAEDesiredClass, KAE::TypeType).data)
				key_form = Codecs.four_char_code(desc.get_param(KAE::KeyAEKeyForm, KAE::TypeEnumeration).data)
				key = desc.get_param(KAE::KeyAEKeyData, KAE::TypeWildCard)
				ref = fully_unpack_object_specifier(desc.get_param(KAE::KeyAEContainer, KAE::TypeWildCard))
				case key_form
					when KAE::FormPropertyID
						return ref.property(Codecs.four_char_code(key.data))
					when KAE::FormUserPropertyID
						return ref.userproperty(unpack(key))
					when KAE::FormRelativePosition
						return ref.send(RelativePositionEnums[key.data], want)
				else
					ref = ref.elements(want)
					case key_form
						when KAE::FormAbsolutePosition
							if key.type == KAE::TypeAbsoluteOrdinal
								if key.data == AllAbsoluteOrdinal
									return ref
								else
									return ref.send(AbsoluteOrdinals[key.data])
								end
							else
								return ref.by_index(unpack(key))
							end
						when KAE::FormName
							return ref.by_name(unpack(key))
						when KAE::FormUniqueID
							return ref.by_id(unpack(key))
						when KAE::FormRange
							return ref.by_range(
									unpack(key.get_param(KAE::KeyAERangeStart, KAE::TypeWildCard)),
									unpack(key.get_param(KAE::KeyAERangeStop, KAE::TypeWildCard)))
						when KAE::FormTest
							return ref.by_filter(unpack(key))
					end
				end
				raise TypeError
			when KAE::TypeNull then return self.class::App
			when KAE::TypeCurrentContainer then return self.class::Con
			when KAE::TypeObjectBeingExamined then return self.class::Its
		else
			return unpack(desc)
		end
	end
	
	##
	
	def unpack_object_specifier(desc)
		# Shallow-unpack an object specifier, retaining the container AEDesc as-is.
		# (i.e. Defers full unpacking of [most] object specifiers for efficiency.)
		key_form = Codecs.four_char_code(desc.get_param(KAE::KeyAEKeyForm, KAE::TypeEnumeration).data)
		if [KAE::FormPropertyID, KAE::FormAbsolutePosition, KAE::FormName, KAE::FormUniqueID].include?(key_form)
			want = Codecs.four_char_code(desc.get_param(KAE::KeyAEDesiredClass, KAE::TypeType).data)
			key = desc.get_param(KAE::KeyAEKeyData, KAE::TypeWildCard)
			container = AEMReference::DeferredSpecifier.new(desc.get_param(KAE::KeyAEContainer, KAE::TypeWildCard), self)
			case key_form
				when KAE::FormPropertyID
					ref = AEMReference::Property.new(want, container, Codecs.four_char_code(key.data))
				when KAE::FormAbsolutePosition
					if key.type == KAE::TypeAbsoluteOrdinal
						if key.data == AllAbsoluteOrdinal
							ref = AEMReference::AllElements.new(want, container)
						else
							ref = fully_unpack_object_specifier(desc) # do a full unpack of rarely returned reference forms
						end
					else
						ref = AEMReference::ElementByIndex.new(want, AEMReference::UnkeyedElements.new(want, container), unpack(key))
					end
				when KAE::FormName
					ref = AEMReference::ElementByName.new(want, AEMReference::UnkeyedElements.new(want, container), unpack(key))
				when KAE::FormUniqueID
					ref = AEMReference::ElementByID.new(want, AEMReference::UnkeyedElements.new(want, container), unpack(key))
			end
		else
			ref = fully_unpack_object_specifier(desc) # do a full unpack of more complex, rarely returned reference forms
		end
		ref.AEM_set_desc(desc) # retain existing AEDesc for efficiency
		return ref
	end
			
	
	def unpack_insertion_loc(desc)
		return unpack_object_specifier(desc.get_param(KAE::KeyAEObject, KAE::TypeWildCard)).send(InsertionLocEnums[desc.get_param(KAE::KeyAEPosition, KAE::TypeEnumeration).data])
	end
	
	##
	
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
		if  op1.is_a?(AEMReference::Query) and op1.AEM_root == AEMReference::Its
			return op1.contains(op2)
		else
			return op2.is_in(op1)
		end
	end
	
	def unpack_comp_descriptor(desc)
		operator = ComparisonEnums[desc.get_param(KAE::KeyAECompOperator, KAE::TypeEnumeration).data]
		op1 = unpack(desc.get_param(KAE::KeyAEObject1, KAE::TypeWildCard))
		op2 = unpack(desc.get_param(KAE::KeyAEObject2, KAE::TypeWildCard))
		if operator == 'contains'
			return unpack_contains_comp_descriptor(op1, op2)
		else
			return op1.send(operator, op2)
		end
	end
	
	def unpack_logical_descriptor(desc)
		operator = LogicalEnums[desc.get_param(KAE::KeyAELogicalOperator, KAE::TypeEnumeration).data]
		operands = unpack(desc.get_param(KAE::KeyAELogicalTerms, KAE::TypeAEList))
		return operands[0].send(operator, *operands[1, operands.length])
	end
	
end

DefaultCodecs = Codecs.new

