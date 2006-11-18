#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

# Note: unit type names have been altered to match built-in unit types in codecs.rb

module DefaultTerminology

	require "aem"
	
	Enums = {
		'yes ' => :yes,
		'no  ' => :no,
		'ask ' => :ask,
		
		'case' => :case,
		'diac' => :diacriticals,
		'expa' => :expansion,
		'hyph' => :hyphens,
		'punc' => :punctuation,
		'whit' => :whitespace,
		'nume' => :numeric_strings,
		'rmte' => :application_responses,
	}

	Types = {
		'****' => :anything,
		'null' => :null,
		'bool' => :boolean,
		'msng' => :missing_value,
		
		'shor' => :short_integer,
		'long' => :integer,
		'magn' => :unsigned_integer,
		'comp' => :double_integer,
		
		'fixd' => :fixed,
		'decm' => :decimal_struct,
		
		'sing' => :short_float,
		'doub' => :float,
		'exte' => :extended_float,
		'ldbl' => :float_128bit,
		
		'TEXT' => :string,
		'cstr' => :c_string,
		'pstr' => :pascal_string,
		'STXT' => :styled_text,
		'tsty' => :text_style_info,
		'styl' => :styled_clipboard_text,
		'encs' => :encoded_string,
		'psct' => :writing_code,
		'intl' => :international_writing_code,
		'itxt' => :international_text,
		'sutx' => :styled_unicode_text,
		'utxt' => :unicode_text,
  		'utf8' => :utf8_text, # typeUTF8Text
		'ut16' => :utf16_text, # typeUTF16ExternalRepresentation
		
		'vers' => :version,
		'ldt ' => :date,
		'list' => :list,
		'reco' => :record,
		'rdat' => :data,
		'scpt' => :script,
		
		'insl' => :location_reference,
		'obj ' => :reference,
		
		'alis' => :alias,
		'fsrf' => :file_ref,
		'fss ' => :file_specification,
		'furl' => :file_url,
		
		'QDpt' => :point,
		'qdrt' => :bounding_rectangle,
		'fpnt' => :fixed_point,
		'frct' => :fixed_rectangle,
		'lpnt' => :long_point,
		'lrct' => :long_rectangle,
		'lfxd' => :long_fixed,
		'lfpt' => :long_fixed_point,
		'lfrc' => :long_fixed_rectangle,
		
		'EPS ' => :EPS_picture,
		'GIFf' => :GIF_picture,
		'JPEG' => :JPEG_picture,
		'PICT' => :PICT_picture,
		'TIFF' => :TIFF_picture,
		'cRGB' => :RGB_color,
		'tr16' => :RGB16_color,
		'tr96' => :RGB96_color,
		'cgtx' => :graphic_text,
		'clrt' => :color_table,
		'tpmm' => :pixel_map_record,
		
		'best' => :best,
		'type' => :type_class,
		'enum' => :enumerator,
		'prop' => :property,
		
		'port' => :mach_port,
		'kpid' => :kernel_process_id,
		'bund' => :application_bundle_id,
		'psn ' => :process_serial_number,
		'sign' => :application_signature,
		'aprl' => :application_url,
		'mLoc' => :machine_location,
		'mach' => :machine,
		
		'suin' => :suite_info,
		'gcli' => :class_info,
		'pinf' => :property_info,
		'elin' => :element_info,
		'evin' => :event_info,
		'pmin' => :parameter_info,
		
		'tdas' => :dash_style,
		'trot' => :rotation,
		
		'pcls' => :class_,
		
		# unit types
		
		'cmtr' => :centimeters,
		'metr' => :meters,
		'kmtr' => :kilometers,
		'inch' => :inches,
		'feet' => :feet,
		'yard' => :yards,
		'mile' => :miles,
		
		'sqrm' => :square_meters,
		'sqkm' => :square_kilometers,
		'sqft' => :square_feet,
		'sqyd' => :square_yards,
		'sqmi' => :square_miles,
		
		'ccmt' => :cubic_centimeter,
		'cmet' => :cubic_meters,
		'cuin' => :cubic_inches,
		'cfet' => :cubic_feet,
		'cyrd' => :cubic_yards,
		
		'litr' => :liters,
		'qrts' => :quarts,
		'galn' => :gallons,
		
		'gram' => :grams,
		'kgrm' => :kilograms,
		'ozs ' => :ounces,
		'lbs ' => :pounds,
		
		'degc' => :degrees_Celsius,
		'degf' => :degrees_Fahrenheit,
		'degk' => :degrees_Kelvin,
		
		# month and weekday
		
		'jan ' => :January,
		'feb ' => :February,
		'mar ' => :March,
		'apr ' => :April,
		'may ' => :May,
		'jun ' => :June,
		'jul ' => :July,
		'aug ' => :August,
		'sep ' => :September,
		'oct ' => :October,
		'nov ' => :November,
		'dec ' => :December,
		
		'sun ' => :Sunday,
		'mon ' => :Monday,
		'tue ' => :Tuesday,
		'wed ' => :Wednesday,
		'thu ' => :Thursday,
		'fri ' => :Friday,
		'sat ' => :Saturday,
	}
	
	##
	
	TypeByCode = Types.clone.update(Enums)

	TypeByName = {}
	Types.each { |code, name| TypeByName[name] = AEM::AEType.new(code) }
	Enums.each { |code, name| TypeByName[name] = AEM::AEEnum.new(code) }
	
	##
	
	ReferenceByCode = {
		'pcls' => 'class_',
		'ID  ' => 'id_',
	}
	
	ReferenceByName = {
		:quit => [:command, ['aevtquit', {
				:saving => 'savo',
				}]],
		:activate => [:command, ['miscactv', {
				}]],
		:run => [:command, ['aevtoapp', {
				}]],
		:launch => [:command, ['ascrnoop', {
				}]],
		:open => [:command, ['aevtodoc', {
				}]],
		:get => [:command, ['coregetd', {
				}]],
		:print => [:command, ['aevtpdoc', {
				}]],
		:class_ => [:property, 'pcls'],
		:set => [:command, ['coresetd', {
				:to => 'data',
				}]],
		:reopen => [:command, ['aevtrapp', {
				}]],
		:id_ => [:property, 'ID  '],
		:open_location => [:command, ['GURLGURL', {
				:window => 'WIND',
				}]],
	}

	DefaultCommands = {} # {'quit' => 'aevtquit', 'activate' => 'miscactv',...}; used by Terminology._make_reference_table to check for any collisions between standard and application-defined commands
	
	ReferenceByName.each do |name, info|
		if info[0] == :command
			DefaultCommands[name.to_s] = info[1][0]
		end
	end
end
