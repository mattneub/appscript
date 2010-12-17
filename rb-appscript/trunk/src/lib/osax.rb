#
# rb-appscript
#
# osax -- invoke scripting addition (OSAX) commands from Ruby
#

require "appscript"

module OSAX

	
	######################################################################
	# PRIVATE
	######################################################################
	
	require 'rexml/document'
	require "ae"
	require "kae"
	require "aem"
	require "_appscript/reservedkeywords" # names of all existing methods on ASReference::Application
	
	StandardAdditionsEnums = [
			["stop", "\000\000\000\000"],
			["note", "\000\000\000\001"],
			["caution", "\000\000\000\002"]]
	
	UTF8ToMacRoman = {
			0 => 0,
			1 => 1,
			2 => 2,
			3 => 3,
			4 => 4,
			5 => 5,
			6 => 6,
			7 => 7,
			8 => 8,
			9 => 9,
			10 => 10,
			11 => 11,
			12 => 12,
			13 => 13,
			14 => 14,
			15 => 15,
			16 => 16,
			17 => 17,
			18 => 18,
			19 => 19,
			20 => 20,
			21 => 21,
			22 => 22,
			23 => 23,
			24 => 24,
			25 => 25,
			26 => 26,
			27 => 27,
			28 => 28,
			29 => 29,
			30 => 30,
			31 => 31,
			32 => 32,
			33 => 33,
			34 => 34,
			35 => 35,
			36 => 36,
			37 => 37,
			38 => 38,
			39 => 39,
			40 => 40,
			41 => 41,
			42 => 42,
			43 => 43,
			44 => 44,
			45 => 45,
			46 => 46,
			47 => 47,
			48 => 48,
			49 => 49,
			50 => 50,
			51 => 51,
			52 => 52,
			53 => 53,
			54 => 54,
			55 => 55,
			56 => 56,
			57 => 57,
			58 => 58,
			59 => 59,
			60 => 60,
			61 => 61,
			62 => 62,
			63 => 63,
			64 => 64,
			65 => 65,
			66 => 66,
			67 => 67,
			68 => 68,
			69 => 69,
			70 => 70,
			71 => 71,
			72 => 72,
			73 => 73,
			74 => 74,
			75 => 75,
			76 => 76,
			77 => 77,
			78 => 78,
			79 => 79,
			80 => 80,
			81 => 81,
			82 => 82,
			83 => 83,
			84 => 84,
			85 => 85,
			86 => 86,
			87 => 87,
			88 => 88,
			89 => 89,
			90 => 90,
			91 => 91,
			92 => 92,
			93 => 93,
			94 => 94,
			95 => 95,
			96 => 96,
			97 => 97,
			98 => 98,
			99 => 99,
			100 => 100,
			101 => 101,
			102 => 102,
			103 => 103,
			104 => 104,
			105 => 105,
			106 => 106,
			107 => 107,
			108 => 108,
			109 => 109,
			110 => 110,
			111 => 111,
			112 => 112,
			113 => 113,
			114 => 114,
			115 => 115,
			116 => 116,
			117 => 117,
			118 => 118,
			119 => 119,
			120 => 120,
			121 => 121,
			122 => 122,
			123 => 123,
			124 => 124,
			125 => 125,
			126 => 126,
			127 => 127,
			196 => 128,
			197 => 129,
			199 => 130,
			201 => 131,
			209 => 132,
			214 => 133,
			220 => 134,
			225 => 135,
			224 => 136,
			226 => 137,
			228 => 138,
			227 => 139,
			229 => 140,
			231 => 141,
			233 => 142,
			232 => 143,
			234 => 144,
			235 => 145,
			237 => 146,
			236 => 147,
			238 => 148,
			239 => 149,
			241 => 150,
			243 => 151,
			242 => 152,
			244 => 153,
			246 => 154,
			245 => 155,
			250 => 156,
			249 => 157,
			251 => 158,
			252 => 159,
			8224 => 160,
			176 => 161,
			162 => 162,
			163 => 163,
			167 => 164,
			8226 => 165,
			182 => 166,
			223 => 167,
			174 => 168,
			169 => 169,
			8482 => 170,
			180 => 171,
			168 => 172,
			8800 => 173,
			198 => 174,
			216 => 175,
			8734 => 176,
			177 => 177,
			8804 => 178,
			8805 => 179,
			165 => 180,
			181 => 181,
			8706 => 182,
			8721 => 183,
			8719 => 184,
			960 => 185,
			8747 => 186,
			170 => 187,
			186 => 188,
			937 => 189,
			230 => 190,
			248 => 191,
			191 => 192,
			161 => 193,
			172 => 194,
			8730 => 195,
			402 => 196,
			8776 => 197,
			8710 => 198,
			171 => 199,
			187 => 200,
			8230 => 201,
			160 => 202,
			192 => 203,
			195 => 204,
			213 => 205,
			338 => 206,
			339 => 207,
			8211 => 208,
			8212 => 209,
			8220 => 210,
			8221 => 211,
			8216 => 212,
			8217 => 213,
			247 => 214,
			9674 => 215,
			255 => 216,
			376 => 217,
			8260 => 218,
			8364 => 219,
			8249 => 220,
			8250 => 221,
			64257 => 222,
			64258 => 223,
			8225 => 224,
			183 => 225,
			8218 => 226,
			8222 => 227,
			8240 => 228,
			194 => 229,
			202 => 230,
			193 => 231,
			203 => 232,
			200 => 233,
			205 => 234,
			206 => 235,
			207 => 236,
			204 => 237,
			211 => 238,
			212 => 239,
			63743 => 240,
			210 => 241,
			218 => 242,
			219 => 243,
			217 => 244,
			305 => 245,
			710 => 246,
			732 => 247,
			175 => 248,
			728 => 249,
			729 => 250,
			730 => 251,
			184 => 252,
			733 => 253,
			731 => 254,
			711 => 255}
	
	class SdefParser
		@@_name_cache = {}
		LegalFirst = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
		LegalRest = LegalFirst + '0123456789'
		@@_reserved_keywords = {} # ersatz set
		ReservedKeywords.each { |name| @@_reserved_keywords[name] = nil }
		
		attr_reader :properties, :elements, :classes, :enumerators
		
		def commands
			return @commands.values
		end
		
		def initialize
			# terminology tables; order is significant where synonym definitions occur
			@commands = {}
			@properties = []
			@elements = []
			@classes = []
			@enumerators = []
		end
		
		def _name(s)
			# Read a MacRoman-encoded Pascal keyword string.
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
		
		def _code(s)
			return s.unpack('U*').collect do |c| # unpack UTF8-encoded byte string
				OSAX::UTF8ToMacRoman.fetch(c)
			end .pack('C*') # pack as MacRoman-encoded byte string (four- or eight-char code)
		end
			
		def _addnamecode(node, collection)
			name = _name(node.attributes['name'])
			code = _code(node.attributes['code'])
			if name != '' and code.size == 4 and not collection.include?([name, code])
				collection.push([name, code])
			end
		end
		
		def _addcommand(node)
			name = _name(node.attributes['name'])
			code = _code(node.attributes['code'])
			parameters = []
			# Note: overlapping command definitions (e.g. 'path to') should be processed as follows:
			# - If their names and codes are the same, only the last definition is used; other definitions are ignored and will not compile.
			# - If their names are the same but their codes are different, only the first definition is used; other definitions are ignored and will not compile.
			if name != '' and code.size == 8 and (not @commands.has_key?(name) or @commands[name][1] == code)
				@commands[name] = [name, code, parameters]
				node.each_element('parameter') do |pnode|
					_addnamecode(pnode, parameters)
				end
			end
		end
		
		def parse(xml)
			# Extract name-code mappings from an sdef.
			#
			#	xml : String -- sdef data
			xml = REXML::Document.new(xml)
			xml.root.each_element('suite/*') do |node| 
				begin
					if ['command', 'event'].include?(node.name)
						_addcommand(node)
					elsif ['class', 'record-type', 'value-type'].include?(node.name)
						_addnamecode(node, @classes)
						node.each_element('property') do |prop|
							_addnamecode(prop, @properties)
						end
						if node.name == 'class' # elements
							name = node.attributes['plural']
							if name == nil
								name = node.attributes['name']
								name = "#{name}s" if name != nil
							end
							name = _name(name)
							code = _code(node.attributes['code'])
							if name != '' and code.size == 4
								@elements.push([name, code])
							end
						end
					elsif node.name == 'enumeration'
						node.each_element('enumerator') do |enum|
							_addnamecode(enum, @enumerators)
						end
					end
				rescue # ignore problem definitions
				end
			end
		end
		
		def parse_file(path)
			# Extract name-code mappings from an sdef.
			#
			#	path :  String -- path to .sdef file
			parse(AE.copy_scripting_definition(path))
		end
		
	end
	
	#######
	# cache; stores osax paths and previously parsed terminology (if any) by osax name
	
	OSAXCache = {}
	OSAXNames = []

	#######
	# modified AppData class
	
	class OSAXData < Appscript::AppData
	
		def initialize(constructor, identifier, terms)
			super(AEM::Application, constructor, identifier, terms)
		end
	
		def connect
			super
			begin
				@target.event('ascrgdut').send(60 * 60) # make sure target application has loaded event handlers for all installed OSAXen
			rescue AEM::EventError => e
				if e.number != -1708 # ignore 'event not handled' error
					raise
				end
			end
		end
	
	end
	
	@_standard_additions = nil
	
	def OSAX._init_caches
		se = AEM::Application.by_path(FindApp.by_id('com.apple.systemevents'))
		['flds', 'fldl', 'fldu'].each do |domain_code|
			osaxen = AEM.app.property(domain_code).property('$scr').elements('file').by_filter(
					AEM.its.property('asty').eq('osax').or(AEM.its.property('extn').eq('osax')))
			if se.event('coredoex', {'----' => osaxen.property('pnam')}).send # domain has ScriptingAdditions folder
				names = se.event('coregetd', {'----' => osaxen.property('pnam')}).send
				paths = se.event('coregetd', {'----' => osaxen.property('posx')}).send
				names.zip(paths).each do |name, path|
					name = name.sub(/(?i)\.osax$/, '') # remove name extension, if any
					OSAXNames.push(name)
					OSAXCache[name.downcase] = [path, nil]
				end
			end
		end
		OSAXNames.sort!.uniq!
	end
	
	######################################################################
	# PUBLIC
	######################################################################
	
	def OSAX.scripting_additions
		# list names of all currently installed scripting additions
		OSAX._init_caches if OSAXNames == []
		return OSAXNames.clone
	end
	
	def OSAX.osax(name=nil, app_name=nil)
		# Convenience method for creating a new ScriptingAddition instance.
		#	name : String | nil -- scripting addition's name; nil = 'StandardAdditions'
		#	app_name : String | nil -- target application's name/path, or nil for current application
		#	Result : ScriptingAddition
		#
		# If both arguments are nil, a ScriptingAddition object for StandardAdditions is created
		# and returned. This object is cached for efficiency and returned in subsequent calls;
		# thus clients can conveniently write (e.g):
		#
		#	osax.some_command
		#	osax.another_command
		#
		# instead of:
		#
		#	sa = osax
		#	sa.some_command
		#	sa.another_command
		#
		# without the additional overhead of creating a new ScriptingAddition object each time.
		#
		if name == nil and app_name == nil
			if @_standard_additions == nil
				@_standard_additions = ScriptingAddition.new('StandardAdditions')
			end
			addition = @_standard_additions
		else
			if name == nil
				name = 'StandardAdditions'
			end
			addition = ScriptingAddition.new(name)
			if app_name
				addition = addition.by_name(app_name)
			end
		end
		return addition
	end
	
	# allow methods to be included via 'include OSAX'
	
	def scripting_additions
		return OSAX.scripting_additions
	end
	
	def osax(*args)
		return OSAX.osax(*args)
	end
	
	#######
	
	class ScriptingAddition < Appscript::Reference
		# Represents a single scripting addition.
		
		def initialize(name, terms=nil)
			# name: string -- a scripting addition's name, e.g. "StandardAdditions";
			#	basically its filename minus the '.osax' suffix
			#
			# terms : module or nil -- an optional terminology glue module,
			#	as exported by Terminology.dump; if given, ScriptingAddition
			#	will use this instead of retrieving the terminology dynamically
			#
			# Note that name is case-insensitive and an '.osax' suffix is ignored if given.
			@_osax_name = name
			if not terms
				osax_name = name.downcase.sub(/(?i)\.osax$/, '')
				OSAX._init_caches if OSAXCache == {}
				path, terminology_tables = OSAXCache[osax_name]
				if not path
					raise ArgumentError, "Scripting addition not found: #{name.inspect}"
				end
				if not terminology_tables
					sp = OSAX::SdefParser.new
					sp.parse_file(path)
					if osax_name == 'standardadditions'
						OSAX::StandardAdditionsEnums.each { |o| sp.enumerators.push(o)}
					end
					terminology_tables = Terminology.tables_for_parsed_sdef(sp)
					OSAXCache[osax_name][1] = terminology_tables
				end
				@_terms = terminology_tables
				terms = OSAXData.new(:current, nil, @_terms)
			elsif not terms.is_a?(OSAX::OSAXData) # assume it's a glue module
				terminology_tables = Terminology.tables_for_module(terms)
				@_terms = terminology_tables
				terms = OSAXData.new(:current, nil, @_terms)
			end
			super(terms, AEM.app)
		end
		
		def to_s
			return "#<OSAX::ScriptingAddition name=#{@_osax_name.inspect} target=#{@AS_app_data.target.inspect}>"
		end
		
		alias_method :inspect, :to_s
		
		##
		
		def method_missing(name, *args)
			begin
				super
			rescue Appscript::CommandError => e
				if e.to_i == -1713 # 'No user interaction allowed' error (e.g. user tried to send a 'display dialog' command to a non-GUI ruby process), so convert the target process to a full GUI process and try again
					AE.transform_process_to_foreground_application
					activate
					super
				else
					raise
				end
			end
		end
		
		# A client-created scripting addition is automatically targetted at the current application.
		# Clients can specify another application as target by calling one of the following methods:
		
		def by_name(name)
			# name : string -- name or full path to application
			return ScriptingAddition.new(@_osax_name, 
					OSAXData.new(:by_path, FindApp.by_name(name), @_terms))
		end
		
		def by_id(id)
			# id : string -- bundle id of application
			return ScriptingAddition.new(@_osax_name, 
					OSAXData.new(:by_path, FindApp.by_id(id), @_terms))
		end
		
		def by_creator(creator)
			# creator : string -- four-character creator code of application
			return ScriptingAddition.new(@_osax_name, 
					OSAXData.new(:by_path, FindApp.by_creator(creator), @_terms))
		end
		
		def by_pid(pid)
			# pid : integer -- Unix process id
			return ScriptingAddition.new(@_osax_name, OSAXData.new(:by_pid, pid, @_terms))
		end
		
		def by_url(url)
			# url : string -- eppc URL of application
			return ScriptingAddition.new(@_osax_name, OSAXData.new(:by_url, url, @_terms))
		end
		
		def by_aem_app(aem_app)
			# aem_app : AEM::Application -- an AEM::Application instance
			return ScriptingAddition.new(@_osax_name, OSAXData.new(:by_aem_app, aem_app, @_terms))
		end
		
		def current
			return ScriptingAddition.new(@_osax_name, OSAXData.new(:current, nil, @_terms))
		end
	end

	#######
	
	def OSAX.dump(osax_name, module_name, out_path)
		# Export scripting addition terminology tables as a Ruby module
		# osaxname : string -- name of installed scripting addition
		# module_name : string -- name of generated module (must be a valid Ruby constant)
		# out_path : string -- module file to write
		# 			
		# Generates a Ruby module containing a scripting addition's basic terminology 
		# (names and codes).
		# 
		# Call the #dump method to dump faulty sdefs to Ruby module, e.g.:
		# 
		# 	dump('MyOSAX', 'MyOSAXGlue', '/path/to/site-packages/myosaxglue.py')
		# 
		# Patch any errors by hand, then import the patched module into your script 
		# and pass it to OSAX.osax via its 'terms' argument, e.g.:
		# 
		# 	require 'osax'
		# 	require 'MyOSAXGlue'
		# 	
		# 	myapp = OSAX.osax('MyOSAX', terms => MyOSAXGlue)
		#
		OSAX._init_caches if OSAXNames == []
		original_name = osax_name
		osax_name = osax_name.downcase
		m = /^(.+).osax$/.match(osax_name)
		osax_name = m[1] if m != nil
		osax_path, terms = OSAXCache.fetch(osax_name) do
			raise ArgumentError, "Scripting addition not found: #{original_name.inspect}"
		end
		sp = OSAX::SdefParser.new
		sp.parsefile(osax_path)
		Terminology.dump_tables([sp.classes, sp.enumerators, sp.properties, sp.elements, sp.commands], 
				module_name, osax_path, out_path)
	end

end