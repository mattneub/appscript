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
				@target = @_aemApplicationClass.newPath(@path)
			elsif @pid
				@target = @_aemApplicationClass.newPID(@pid)
			elsif @url
				@target = @_aemApplicationClass.newURL(@url)
			else
				@target = @_aemApplicationClass.current
			end
			begin
				@target.event('ascrgdut').send(300) # make sure target application loads osaxen
			rescue AEM::CommandError => e
				if e.number != -1708
					raise
				end
			end
			@typebycode, @typebyname, @referencebycode, @referencebyname = @_terms
			extend(AS::AppDataAccessors)
		end
	
	end
	
	
	######################################################################
	# PUBLIC
	######################################################################
	
	def OSAX.scripting_additions
		return OSAXNames
	end
	
	def OSAX.osax(name, appName=nil)
		addition = ScriptingAddition.new(name)
		if appName
			addition = addition.targetName(appName)
		end
		return addition
	end
	
	
	class ScriptingAddition < AS::Reference
		# Represents a single scripting addition.
		
		def initialize(name)
			@_osaxName = name
			if name.is_a?(OSAXData)
				osaxData = name
			else
				path, terms = OSAXCache[name.downcase.sub(/(?i)\.osax$/, '')]
				if not path
					raise ArgumentError, "Scripting addition not found: #{name.inspect}"
				end
				if terms
					@_terms = terms
				else
					desc = AE.getAETE(path).coerce(KAE::TypeAEList)
					@_terms = OSAXCache[name.downcase][1] = \
							Terminology.tablesForAetes(DefaultCodecs.unpack(desc))
				end
				osaxData = OSAXData.new(nil, nil, nil, @_terms)
			end
			super(osaxData, AEM.app)
		end
		
		def to_s
			return "#<OSAX::ScriptingAddition name=#{@_osaxName.inspect} target=#{@AS_appdata.target.inspect}>"
		end
		
		alias_method :inspect, :to_s
		
		# A client-created scripting addition is automatically targetted at the current application.
		# Clients can specify another application as target by calling one of the following methods:
		
		def targetName(name)
			return ScriptingAddition.new(OSAXData.new(FindApp.byName(name), nil, nil, @_terms))
		end
		
		def targetID(id)
			return ScriptingAddition.new(OSAXData.new(FindApp.byID(id), nil, nil, @_terms))
		end
		
		def targetCreator(creator)
			return ScriptingAddition.new(OSAXData.new(FindApp.byCreator(creator), nil, nil, @_terms))
		end
		
		def targetPID(pid)
			return ScriptingAddition.new(OSAXData.new(nil, pid, nil, @_terms))
		end
		
		def targetURL(url)
			return ScriptingAddition.new(OSAXData.new(nil, nil, url, @_terms))
		end
	end
	
end