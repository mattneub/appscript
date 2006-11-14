#!/usr/local/bin/ruby

module OSAX
	
	######################################################################
	# PRIVATE
	######################################################################
	
	require "ae"
	require "kae"
	require "aem"
	require "appscript"
	require "findapp"
	
	#######
	# cache; stores osax paths and previously parsed terminology (if any) by osax name
	
	OSAXCache = {}
	OSAXNames = []
	
	se = AS.app('System Events')
	[se.system_domain, se.local_domain, se.user_domain].each do |domain|
		osaxen = domain.scripting_additions_folder.files[
				AS.its.file_type.eq('osax').or(AS.its.name_extension.eq('osax'))]
		osaxen.name.get.zip(osaxen.POSIX_path.get).each do |name, path|
			name = name.sub(/(?i)\.osax$/, '') # remove name extension, if any
			OSAXNames.push(name)
			OSAXCache[name.downcase] = [path, nil]
		end
	end
	OSAXNames.sort.uniq
	
	#######
	# modified AppData class
	
	class OSAXData < AS::AppData
	
		def initialize(name, pid, url, terms)
			super(AEM::Application, name, pid, url, terms)
		end
	
		def _connect
			if @path
				@target = @_aem_application_class.by_path(@path)
			elsif @pid
				@target = @_aem_application_class.by_pid(@pid)
			elsif @url
				@target = @_aem_application_class.by_url(@url)
			else
				@target = @_aem_application_class.current
			end
			begin
				@target.event('ascrgdut').send(300) # make sure target application loads osaxen
			rescue AEM::CommandError => e
				if e.number != -1708
					raise
				end
			end
			@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = @_terms
			extend(AS::AppDataAccessors)
		end
	
	end
	
	
	######################################################################
	# PUBLIC
	######################################################################
	
	def OSAX.scripting_additions
		return OSAXNames
	end
	
	def OSAX.osax(name, app_name=nil)
		addition = ScriptingAddition.new(name)
		if app_name
			addition = addition.by_name(app_name)
		end
		return addition
	end
	
	
	class ScriptingAddition < AS::Reference
		# Represents a single scripting addition.
		
		def initialize(name)
			@_osax_name = name
			if name.is_a?(OSAXData)
				osax_data = name
			else
				path, terms = OSAXCache[name.downcase.sub(/(?i)\.osax$/, '')]
				if not path
					raise ArgumentError, "Scripting addition not found: #{name.inspect}"
				end
				if terms
					@_terms = terms
				else
					desc = AE.get_app_terminology(path).coerce(KAE::TypeAEList)
					@_terms = OSAXCache[name.downcase][1] = \
							Terminology.tables_for_aetes(DefaultCodecs.unpack(desc))
				end
				osax_data = OSAXData.new(nil, nil, nil, @_terms)
			end
			super(osax_data, AEM.app)
		end
		
		def to_s
			return "#<OSAX::ScriptingAddition name=#{@_osax_name.inspect} target=#{@AS_app_data.target.inspect}>"
		end
		
		alias_method :inspect, :to_s
		
		##
		
		def method_missing(name, *args)
			begin
				super
			rescue AS::CommandError => e
				if e.to_i == -1713
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
			return ScriptingAddition.new(OSAXData.new(FindApp.by_name(name), nil, nil, @_terms))
		end
		
		def by_id(id)
			return ScriptingAddition.new(OSAXData.new(FindApp.by_id(id), nil, nil, @_terms))
		end
		
		def by_creator(creator)
			return ScriptingAddition.new(OSAXData.new(FindApp.by_creator(creator), nil, nil, @_terms))
		end
		
		def by_pid(pid)
			return ScriptingAddition.new(OSAXData.new(nil, pid, nil, @_terms))
		end
		
		def by_url(url)
			return ScriptingAddition.new(OSAXData.new(nil, nil, url, @_terms))
		end
		
		def current
			return ScriptingAddition.new(OSAXData.new(nil, nil, nil, @_terms))
		end
	end
	
end