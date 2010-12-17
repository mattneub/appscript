#
# rb-appscript
#
# findapp -- locate an application by name, bundle ID or creator code
#

module FindApp
	# Support module for obtaining the full path to a local application given its name, bundle id or creator type. If application isn't found, an ApplicationNotFoundError exception is raised.

	require "ae"
	
	class ApplicationNotFoundError < RuntimeError
	
		attr_reader :creator_type, :bundle_id, :application_name
		
		def initialize(creator, id, name)
			@creator_type, @bundle_id, @application_name  = creator, id, name 
			super()
		end
	end
	
	#######
	
	def FindApp._find_app(creator, id, name)
		begin
			return AE.find_application(creator, id, name)
		rescue AE::MacOSError => err
			if err.to_i == -10814
				ident = [creator, id, name].compact.to_s.inspect
				raise ApplicationNotFoundError.new(creator, id, name), "Application #{ident} not found."
			else
				raise
			end
		end
	end
	
	#######

	def FindApp.by_name(name)		
		# Find the application with the given name and return its full path. 
		#
		# Absolute paths are also accepted. An '.app' suffix is optional.
		#
		# Examples: 
		#	FindApp.by_name('TextEdit')
		#	FindApp.by_name('Finder.app')
		#
		if name[0, 1] != '/' # application name only, not its full path
			begin
				new_name = _find_app(nil, nil, name)
			rescue ApplicationNotFoundError
				if ('----' + name)[-4, 4].downcase == '.app'
					raise ApplicationNotFoundError.new(nil, nil, name), "Application #{name.inspect} not found."
				end
				new_name = _find_app(nil, nil, name + '.app')
			end
			name = new_name
		end
		if not FileTest.exist?(name) and name[-4, 4].downcase != '.app' and not FileTest.exist?(name+ '.app')
			name += '.app'
		end
		if not FileTest.exist?(name)
			raise ApplicationNotFoundError.new(nil, nil, name), "Application #{name.inspect} not found."
		end
		return name
	end
	
	def FindApp.by_id(id)
		# Find the application with the given bundle id and return its full path.
		#
		# Examples:
		#	FindApp.by_id('com.apple.textedit')
		#
		return _find_app(nil, id, nil)
	end
	
	def FindApp.by_creator(creator)
		# Find the application with the given creator type and return its full path.
		#
		# Examples:
		#	FindApp.by_creator('ttxt')
		#
		return _find_app(creator, nil, nil)
	end
end
