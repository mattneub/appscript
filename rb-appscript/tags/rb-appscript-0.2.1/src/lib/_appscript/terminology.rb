#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

######################################################################
# TERMINOLOGY PARSER
######################################################################

module TerminologyParser
	
	require "_appscript/reservedkeywords" # names of all existing methods on ASReference::Application
	
	class BigEndianParser
		@@_name_cache = {}
		LegalFirst = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
		LegalRest = LegalFirst + '0123456789'
		
		def initialize
			@enumerators = {}
			@properties = {}
			@commands = {}
			@_plural_class_names = {}
			@_singular_class_names = {}
		end
		
		def _integer
			@_ptr += 2
			return @_str[@_ptr - 2, 2].unpack('S')[0]
		end
		
		def _word
			@_ptr += 4
			return @_str[@_ptr - 4, 4]
		end
		
		def _name
			count = @_str[@_ptr]
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
				if res[0, 3] == 'AS_' or ReservedKeywords.include?(res) or res[0, 1] == '_'
					res += '_'
				end
				@@_name_cache[s] = res
			end
			return @@_name_cache[s]
		end
		
		##
		
		def parse_command
			name = _name
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
			code = _word + _word
			# skip result
			@_ptr += 4
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
			@_ptr += 2
			# skip direct
			@_ptr += 4
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
			@_ptr += 2
			#
			current_command_args = []
			@commands[code] = [name, code, current_command_args]
			# args
			_integer.times do
				parameter_name = _name
				@_ptr += @_ptr & 1
				parameter_code = _word
				@_ptr += 4
				@_ptr += 1 + @_str[@_ptr]
				@_ptr += @_ptr & 1
				@_ptr += 2
				current_command_args.push([parameter_name, parameter_code])
			end
		end
		
		def parse_class
			name = _name
			@_ptr += @_ptr & 1
			code = _word
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
			is_plural = false
			_integer.times do
				propname = _name
				@_ptr += @_ptr & 1
				propcode = _word
				@_ptr += 4
				@_ptr += 1 + @_str[@_ptr]
				@_ptr += @_ptr & 1
				flags = _integer
				if propcode != 'c@#^'
					if flags & 1 == 1
						is_plural = true
					else
						@properties[propcode] = [propname, propcode]
					end
				end
			end
			_integer.times do
				@_ptr += 4
				count = _integer
				@_ptr += 4 * count
			end
			if is_plural
				@_plural_class_names[code] = [name, code]
			else
				@_singular_class_names[code] = [name, code]
			end
		end
		
		def parse_comparison
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
			@_ptr += 4
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
		end
		
		def parse_enumeration
			@_ptr += 4
			_integer.times do
				name = _name
				@_ptr += @_ptr & 1
				code = _word
				@_ptr += 1 + @_str[@_ptr]
				@_ptr += @_ptr & 1
				@enumerators[code + name] = [name, code]
			end
		end
		
		def parse_suite
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += 1 + @_str[@_ptr]
			@_ptr += @_ptr & 1
			@_ptr += 4
			@_ptr += 4
			_integer.times { parse_command }
			_integer.times { parse_class }
			_integer.times { parse_comparison }
			_integer.times { parse_enumeration }
		end
		
		def parse(aetes)
			aetes.each do |aete|
				@_str = aete.data
				@_ptr = 6
				_integer.times { parse_suite }
				if not @_ptr == @_str.length
					raise RuntimeError, "aete was not fully parsed."
				end
			end
			classes = @_plural_class_names.clone
			classes.update(@_singular_class_names)
			elements = @_singular_class_names.clone
			elements.update(@_plural_class_names)
			return [classes, @enumerators, @properties, elements, @commands].map! { |d| d.values }
		end
	end
	
	
	class LittleEndianParser < BigEndianParser
		def _word
			return super.reverse
		end
	end
	
	
	#######
	# Public
	
	def TerminologyParser.build_tables_for_aetes(aetes)
		if [1].pack('S') == "\000\001"
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
		type_by_code = DefaultTerminology::TypeByCode.clone
		type_by_name = DefaultTerminology::TypeByName.clone
		[[AEM::AEType, properties], [AEM::AEEnum, enums], [AEM::AEType, classes]].each do |klass, table|
			table.each do |name, code|
				if DefaultTerminology::TypeByName.has_key?(name) and \
						DefaultTerminology::TypeByName[name].code != code
					name += '_'
				end
				type_by_code[code] = name.intern
				type_by_name[name.intern] = klass.new(code)
			end
		end
		return [type_by_code, type_by_name]
	end
	
	def Terminology._make_reference_table(properties, elements, commands)
		reference_by_code = DefaultTerminology::ReferenceByCode.clone
		reference_by_name = DefaultTerminology::ReferenceByName.clone
		[[:element, elements, 'e'], [:property, properties, 'p']].each do |kind, table, prefix|
			# note: if property and element names are same (e.g. 'file' in BBEdit), will pack as property specifier unless it's a special case (i.e. see :text below). Note that there is currently no way to override this, i.e. to force appscript to pack it as an all-elements specifier instead (in AS, this would be done by prepending the 'every' keyword), so clients would need to use aem for that (but could add an 'all' method to Reference class if there was demand for a built-in workaround)
			table.each do |name, code|
				reference_by_code[prefix + code] = name
				reference_by_name[name.intern] = [kind, code]
			end
		end
		if reference_by_name.has_key?(:text) # special case: AppleScript always packs 'text of...' as all-elements specifier
			reference_by_name[:text][0] = :element
		end
		commands.reverse.each do |name, code, args|
			if DefaultTerminology::DefaultCommands.has_key?(name) and \
					code != DefaultTerminology::DefaultCommands[name]
						name += '_'
			end
			dct = {}
			args.each { |arg_name, arg_code| dct[arg_name.intern] = arg_code }
			reference_by_name[name.intern] = [:command, [code, dct]]
		end
		return reference_by_code, reference_by_name
	end
	
	#######
	# public
	
	def Terminology.default_tables
		return _make_type_table([], [], []) + _make_reference_table([], [], [])
	end
	
	def Terminology.tables_for_aetes(aetes)
		classes, enums, properties, elements, commands = TerminologyParser.build_tables_for_aetes(aetes.delete_if { |aete| not (aete.is_a?(AE::AEDesc) and aete.type == 'aete') })
		return _make_type_table(classes, enums, properties) + _make_reference_table(properties, elements, commands)
	end
	
	##
	
	def Terminology.tables_for_module(terms)
		if terms::Version != 1.1
			raise RuntimeError, "Unsupported terminology module version: #{terms::Version} (requires version 1.1)."
		end
		return _make_type_table(terms::Classes, terms::Enumerators, terms::Properties) \
			+ _make_reference_table(terms::Properties, terms::Elements, terms::Commands)
	end
	
	def Terminology.tables_for_app(path, pid, url)
		if not @@_terminology_cache.has_key?([path, pid, url])
			begin
				if path
					app = AEM::Application.by_path(path)
				elsif pid
					app = AEM::Application.by_pid(pid)
				elsif url
					app = AEM::Application.by_url(url)
				else
					app = AEM::Application.current
				end
				begin
					aetes = app.event('ascrgdte', {'----' => 0}).send(30 * 60)
				rescue AEM::CommandError => e
					if  e.number == -192 # aete resource not found
						aetes = []
					else
						raise
					end
				end
				if not aetes.is_a?(Array)
					aetes = [aetes]
				end
			rescue => err
				raise RuntimeError, "Can't get terminology for application (#{path or pid or url}): #{err}"
			end
			@@_terminology_cache[[path, pid, url]] = Terminology.tables_for_aetes(aetes)
		end
		return @@_terminology_cache[[path, pid, url]]
	end
end

