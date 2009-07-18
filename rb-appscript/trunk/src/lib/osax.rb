#
# rb-appscript
#
# osax -- invoke scripting addition (OSAX) commands from Ruby
#
# Copyright (C) 2006-2009 HAS. Released under MIT License.
#

require "appscript"

module OSAX
	
	######################################################################
	# PRIVATE
	######################################################################
	
	require "ae"
	require "kae"
	require "aem"
	
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
			rescue AEM::CommandError => e
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
					begin
						aetes_desc = AE.get_app_terminology(path) # will raise NotImplementedError in 64-bit processes
					rescue NotImplementedError
						raise RuntimeError, "OSAX::ScriptingAddition can't dynamically retrieve scripting addition terminology within a 64-bit process."
					end
					aetes = DefaultCodecs.unpack(aetes_desc.coerce(KAE::TypeAEList))
					terminology_tables = Terminology.tables_for_aetes(aetes)
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
	
end