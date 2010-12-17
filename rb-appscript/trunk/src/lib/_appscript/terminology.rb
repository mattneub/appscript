#
# rb-appscript
#
# terminology -- retrieve and convert an application's terminology into lookup tables
#

######################################################################
# TERMINOLOGY PARSER
######################################################################

module TerminologyParser
	
	require "ae"
	require "kae"
	require "_appscript/reservedkeywords" # names of all existing methods on ASReference::Application
	
	class BigEndianParser
		@@_name_cache = {}
		LegalFirst = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
		LegalRest = LegalFirst + '0123456789'
		@@_reserved_keywords = {} # ersatz set
		ReservedKeywords.each { |name| @@_reserved_keywords[name] = nil }
		
		def initialize
			# terminology tables; order is significant where synonym definitions occur
			@commands = {}
			@properties = []
			@elements = []
			@classes = []
			@enumerators = []
			# use ersatz sets to record previously found definitions, and avoid adding duplicates to lists
			# (i.e. 'name+code not in <set>' is quicker than using 'name+code not in <list>')
			@_found_properties = {} # set
			@_found_elements = {} # set
			@_found_classes = {} # set
			@_found_enumerators = {} # set
			# ideally, aetes should define both singular and plural names for each class, but
			# some define only one or the other so we need to fill in any missing ones afterwards
			@_spare_class_names = {} # names by code
			@_found_class_codes = {} # set
			@_found_element_codes = {} # set
		end
		
		def _integer
			# Read a 2-byte integer.
			@_ptr += 2
			return @_str[@_ptr - 2, 2].unpack('S')[0]
		end
		
		def _word
			# Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability).
			@_ptr += 4
			return @_str[@_ptr - 4, 4] # big-endian
		end
		
		# Ruby 1.9 has changed the way that a character ordinal is obtained
		maj, min, rev = RUBY_VERSION.split('.')
		if (maj == '1' and min.to_i < 9) # is Ruby 1.8
			def _length
				return @_str[@_ptr]
			end
		else
			def _length
				return @_str[@_ptr].ord
			end
		end
		
		def _name
			# Read a MacRoman-encoded Pascal keyword string.
			count = _length
			@_ptr += 1 + count
			s = @_str[@_ptr - count, count]
			if not @@_name_cache.has_key?(s)
				legal = LegalFirst
				res = ''
				s.split(//).each do |c|
					if legal[c]
						res += c
					else
						case c
							when ' ', '-', '/'
								res += '_'
							when '&'
								res += 'and'
						else
							if res == ''
								res = '_'
							end
							res += "0x#{c.unpack('HXh')}"
						end
					end
					legal = LegalRest
				end
				if res[0, 3] == 'AS_' or @@_reserved_keywords.has_key?(res) or res[0, 1] == '_'
					res += '_'
				end
				@@_name_cache[s] = res
			end
			return @@_name_cache[s]
		end
		
		##
		
		def parse_command
			name = _name
			@_ptr += 1 + _length # description string
			@_ptr += @_ptr & 1 # align
			code = _word + _word # event class + event id
			# skip result
			@_ptr += 4 # datatype word
			@_ptr += 1 + _length # description string
			@_ptr += @_ptr & 1 # align
			@_ptr += 2 # flags integer
			# skip direct parameter
			@_ptr += 4 # datatype word
			@_ptr += 1 + _length # description string
			@_ptr += @_ptr & 1 # align
			@_ptr += 2 # flags integer
			#
			current_command_args = []
			# Note: overlapping command definitions (e.g. InDesign) should be processed as follows:
			# - If their names and codes are the same, only the last definition is used; other definitions are ignored and will not compile.
			# - If their names are the same but their codes are different, only the first definition is used; other definitions are ignored and will not compile.
			# - If a dictionary-defined command has the same name but different code to a built-in definition, escape its name so it doesn't conflict with the default built-in definition.
			if not @commands.has_key?(name) or @commands[name][1] == code
				@commands[name] = [name, code, current_command_args]
			end
			# add labelled parameters
			_integer.times do
				parameter_name = _name
				@_ptr += @_ptr & 1 # align
				parameter_code = _word
				@_ptr += 4 # datatype word
				@_ptr += 1 + _length # description string
				@_ptr += @_ptr & 1 # align
				@_ptr += 2 # flags integer
				current_command_args.push([parameter_name, parameter_code])
			end
		end
		
		def parse_class
			name = _name
			@_ptr += @_ptr & 1 # align
			code = _word
			@_ptr += 1 + _length # description string
			@_ptr += @_ptr & 1 # align
			is_plural = false
			_integer.times do # properties
				propname = _name
				@_ptr += @_ptr & 1 # align
				propcode = _word
				@_ptr += 4 # datatype word
				@_ptr += 1 + _length # description string
				@_ptr += @_ptr & 1 # align
				flags = _integer
				if propcode != 'c@#^' # not a superclass definition (see kAEInheritedProperties)
					if flags & 1 == 1 # indicates class name is plural (see kAESpecialClassProperties)
						is_plural = true
					elsif not @_found_properties.has_key?(propname + propcode)
						@properties.push([propname, propcode]) # preserve ordering
						@_found_properties[propname + propcode] = nil # add to found set
					end
				end
			end
			_integer.times do # skip elements
				@_ptr += 4 # code word
				count = _integer
				@_ptr += 4 * count # reference forms
			end
			if is_plural
				if not @_found_elements.has_key?(name + code)
					@elements.push([name, code])
					@_found_elements[name + code] = nil # add to found set
					@_found_element_codes[code] = nil # add to found set
				end
			else
				if not @_found_classes.has_key?(name + code)
					@classes.push([name, code])
					@_found_classes[name + code] = nil # add to found set
					@_found_class_codes[code] = nil # add to found set
				end
			end
			@_spare_class_names[code] = name
		end
		
		def parse_comparison # comparison info isn't used
			@_ptr += 1 + _length # name string
			@_ptr += @_ptr & 1 # align
			@_ptr += 4 # code word
			@_ptr += 1 + _length # description string
			@_ptr += @_ptr & 1 # align
		end
		
		def parse_enumeration
			@_ptr += 4 # code word
			_integer.times do # enumerators
				name = _name
				@_ptr += @_ptr & 1 # align
				code = _word
				@_ptr += 1 + _length # description string
				@_ptr += @_ptr & 1 # align
				if not @_found_enumerators.has_key?(name + code)
					@enumerators.push([name, code])
					@_found_enumerators[name + code] = nil # add to found set
				end
			end
		end
		
		def parse_suite
			@_ptr += 1 + _length # name string
			@_ptr += 1 + _length # description string
			@_ptr += @_ptr & 1 # align
			@_ptr += 4 # code word
			@_ptr += 4 # level, version integers
			_integer.times { parse_command }
			_integer.times { parse_class }
			_integer.times { parse_comparison }
			_integer.times { parse_enumeration }
		end
		
		def parse(aetes)
			aetes.each do |aete|
				if aete.is_a?(AE::AEDesc) and aete.type == KAE::TypeAETE and aete.data != ''
					@_str = aete.data
					@_ptr = 6 # version, language, script integers
					_integer.times { parse_suite }
				end
			end
			# singular names are normally used in the classes table and plural names in the elements table. However, if an aete defines a singular name but not a plural name then the missing plural name is substituted with the singular name; and vice-versa if there's no singular equivalent for a plural name.
			missing_elements = @_found_class_codes.keys - @_found_element_codes.keys
			missing_classes = @_found_element_codes.keys - @_found_class_codes.keys
			missing_elements.each do |code|
				@elements.push([@_spare_class_names[code], code])
			end
			missing_classes.each do |code|
				@classes.push([@_spare_class_names[code], code])
			end
			return [@classes, @enumerators, @properties, @elements, @commands.values]
		end
	end
	
	
	class LittleEndianParser < BigEndianParser
		def _word
			# Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability).
			return super.reverse # little-endian
		end
	end
	
	
	#######
	# Public
	
	def TerminologyParser.build_tables_for_aetes(aetes)
		if [1].pack('S') == "\000\001" # is it big-endian?
			return BigEndianParser.new.parse(aetes)
		else
			return LittleEndianParser.new.parse(aetes)
		end
	end

end


######################################################################
# TERMINOLOGY TABLES BUILDER
######################################################################

module Terminology

	require "aem"
	require "_appscript/defaultterminology"

	@@_terminology_cache = {}
	
	def Terminology._make_type_table(classes, enums, properties)
		# builds tables used for converting symbols to/from AEType, AEEnums
		type_by_code = DefaultTerminology::TypeByCode.clone
		type_by_name = DefaultTerminology::TypeByName.clone
		[[AEM::AEType, properties], [AEM::AEEnum, enums], [AEM::AEType, classes]].each do |klass, table|
			table.each_with_index do |item, i|
				name, code = item
				# If an application-defined name overlaps an existing type name but has a different code, append '_' to avoid collision:
				name += '_' if DefaultTerminology::TypeCodeByName.fetch(name, code) != code
				begin
					type_by_code[code] = name.intern # to handle synonyms, if same code appears more than once then use name from last definition in list
				rescue ArgumentError # ignore #intern error if name is empty string
				end
				name, code = table[-i - 1]
				name += '_' if DefaultTerminology::TypeCodeByName.fetch(name, code) != code
				begin
					type_by_name[name.intern] = klass.new(code) # to handle synonyms, if same name appears more than once then use code from first definition in list
				rescue ArgumentError # ignore #intern error if name is empty string
				end
			end
		end
		return [type_by_code, type_by_name]
	end
	
	def Terminology._make_reference_table(properties, elements, commands)
		# builds tables used for constructing references and commands
		reference_by_code = DefaultTerminology::ReferenceByCode.clone
		reference_by_name = DefaultTerminology::ReferenceByName.clone
		[[:element, elements, 'e'], [:property, properties, 'p']].each do |kind, table, prefix|
			# note: if property and element names are same (e.g. 'file' in BBEdit), will pack as property specifier unless it's a special case (i.e. see :text below). Note that there is currently no way to override this, i.e. to force appscript to pack it as an all-elements specifier instead (in AS, this would be done by prepending the 'every' keyword), so clients would need to use aem for that (but could add an 'all' method to Reference class if there was demand for a built-in workaround)
			table.each_with_index do |item, i|
				name, code = item
				# If an application-defined name overlaps an existing type name but has a different code, append '_' to avoid collision:
				name += '_' if DefaultTerminology::TypeCodeByName.fetch(name, code) != code
				reference_by_code[prefix + code] = name # to handle synonyms, if same code appears more than once then use name from last definition in list
				name, code = table[-i - 1]
				name += '_' if DefaultTerminology::TypeCodeByName.fetch(name, code) != code
				begin
					reference_by_name[name.intern] = [kind, code] # to handle synonyms, if same name appears more than once then use code from first definition in list
				rescue ArgumentError # ignore #intern error if name is empty string
				end
			end
		end
		if reference_by_name.has_key?(:text) # special case: AppleScript always packs 'text of...' as all-elements specifier
			reference_by_name[:text][0] = :element
		end
		commands.reverse.each do |name, code, args| # to handle synonyms, if two commands have same name but different codes, only the first definition should be used (iterating over the commands list in reverse ensures this)
			# Avoid collisions between default commands and application-defined commands with same name but different code (e.g. 'get' and 'set' in InDesign CS2):
			name += '_' if DefaultTerminology::CommandCodeByName.fetch(name, code) != code
			dct = {}
			args.each do |arg_name, arg_code|
				begin
					dct[arg_name.intern] = arg_code
				rescue ArgumentError # ignore #intern error if name is empty string
				end
			end
			begin
				reference_by_name[name.intern] = [:command, [code, dct]]
			rescue ArgumentError # ignore #intern error if name is empty string
			end
		end
		return reference_by_code, reference_by_name
	end
	
	def Terminology.dump_tables(tables, module_name, source_path, out_path)
		# Parse aete(s) into intermediate tables, suitable for use by Terminology#tables_for_module
		if not(/^[A-Z][A-Za-z0-9_]*$/ === module_name)
			raise RuntimeError, "Invalid module name."
		end
		# Write module
		File.open(out_path, "w") do |f|
			f.puts "module #{module_name}"
			f.puts "\tVersion = 1.1"
			f.puts "\tPath = #{source_path.inspect}"
			f.puts
			(["Classes", "Enumerators", "Properties", "Elements"].zip(tables[0,4])).each do |name, table|
				f.puts "\t#{name} = ["
				table.sort.each do |item|
					f.puts "\t\t#{item.inspect},"
				end
				f.puts "\t]"
				f.puts
			end
			f.puts "\tCommands = ["
			tables[4].sort.each do |name, code, params|
				f.puts "\t\t[#{name.inspect}, #{code.inspect}, ["
					params.each do |item|
						f.puts "\t\t\t#{item.inspect},"
					end
				f.puts "\t\t]],"
			end
			f.puts "\t]"
			f.puts "end"
		end
	end
	
	#######
	# public
	
	def Terminology.default_tables
		# [typebycode, typebyname, referencebycode, referencebyname]
		return _make_type_table([], [], []) + _make_reference_table([], [], [])
	end
	
	def Terminology.tables_for_aetes(aetes)
		# Build terminology tables from a list of unpacked aete byte strings.
		# Result : list of hash -- [typebycode, typebyname, referencebycode, referencebyname]
		aetes = aetes.reject { |aete| not(aete.is_a?(AE::AEDesc) and aete.type == KAE::TypeAETE and aete.data != '') }
		classes, enums, properties, elements, commands = TerminologyParser.build_tables_for_aetes(aetes)
		return _make_type_table(classes, enums, properties) + _make_reference_table(properties, elements, commands)
	end
	
	##
	
	def Terminology.tables_for_module(terms)
		# Build terminology tables from a dumped terminology module.
		# Result : list of hash -- [typebycode, typebyname, referencebycode, referencebyname]
		if terms::Version != 1.1
			raise RuntimeError, "Unsupported terminology module version: #{terms::Version} (requires version 1.1)."
		end
		return _make_type_table(terms::Classes, terms::Enumerators, terms::Properties) \
			+ _make_reference_table(terms::Properties, terms::Elements, terms::Commands)
	end
	
	def Terminology.tables_for_parsed_sdef(terms)
		# Build terminology tables from an SdefParser instance.
		# Result : list of hash -- [typebycode, typebyname, referencebycode, referencebyname]
		return _make_type_table(terms.classes, terms.enumerators, terms.properties) \
			+ _make_reference_table(terms.properties, terms.elements, terms.commands)
	end
	
	def Terminology.aetes_for_app(aem_app)
		begin
			begin
				aetes = aem_app.event('ascrgdte', {'----' => 0}).send(120 * 60)
			rescue AEM::EventError => e
				if  e.number == -192 # aete resource not found
					aetes = []
				else
					raise
				end
			end
		rescue => err
			raise RuntimeError, "Can't get terminology for application (#{aem_app}): #{err}"
		end
		aetes = [aetes] if not aetes.is_a?(Array)
		return aetes
	end
	
	def Terminology.tables_for_app(aem_app)
		# Build terminology tables for an application.
		# app : AEM::Application
		# Result : list of hash -- [typebycode, typebyname, referencebycode, referencebyname]
		if not @@_terminology_cache.has_key?(aem_app.identity)
			aetes = Terminology.aetes_for_app(aem_app)
			@@_terminology_cache[aem_app.identity] = Terminology.tables_for_aetes(aetes)
		end
		return @@_terminology_cache[aem_app.identity]
	end
	
	#######
	# public
	
	def Terminology.dump(app_name, module_name, out_path)
		# Export application terminology tables as a Ruby module
		# app_path : string -- name or path of application
		# module_name : string -- name of generated module (must be a valid Ruby constant)
		# out_path : string -- module file to write
		# 	
		# Generates a Ruby module containing an application's basic terminology 
		# (names and codes) as used by appscript.
		# 
		# Call the #dump method to dump faulty aetes to Ruby module, e.g.:
		# 
		# 	Terminology.dump('MyApp', 'MyAppGlue', '/path/to/ruby/modules/myappglue.rb')
		# 
		# Patch any errors by hand, then import the patched module into your script 
		# and pass it to appscript's app() constructor via its 'terms' argument, e.g.:
		# 
		# 	require 'appscript'; include Appscript
		# 	require 'myappglue'
		# 	
		# 	myapp = app('MyApp', terms => MyAppGlue)
		# 
		# Note that dumped terminologies aren't used by appscript's built-in help system.
		#
		app_path = FindApp.by_name(app_name)
		# Get aete(s)
		aetes = Terminology.aetes_for_app(Application.by_path(app_path))
		aetes.delete_if { |aete| not(aete.is_a?(AE::AEDesc) and aete.type == KAE::TypeAETE) }
		tables = TerminologyParser.build_tables_for_aetes(aetes)
		Terminology.dump_tables(tables, module_name, app_path, out_path)
	end
	
end

