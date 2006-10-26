#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module FindApp

	require "ae"
	
	class ApplicationNotFoundError < RuntimeError
	
		attr_reader :creatorType, :bundleID, :applicationName
		
		def initialize(creator, id, name)
			@creatorType, @bundleID, @applicationName  = creator, id, name 
			super()
		end
	end
	
	#######
	
	def FindApp._findApp(creator, id, name)
		begin
			return AE.findApplication(creator, id, name)
		rescue AE::MacOSError => err
			if err.to_i == -10814
				ident = [creator, id, name].compact.to_s.inspect
				raise ApplicationNotFoundError.new(creator, id, name), "Application #{ident} not found."
			else
				raise
			end
		end
	end

	def FindApp.byName(name)
		if name[0, 1] != '/'
			begin
				newName = _findApp(nil, nil, name)
			rescue ApplicationNotFoundError
				if ('----' + name)[-4, 4].downcase == '.app'
					raise ApplicationNotFoundError.new(creator, id, name), "Application #{name.inspect} not found."
				end
				newName = _findApp(nil, nil, name + '.app')
			end
			name = newName
		end
		if not FileTest.exist?(name) and name[-4, 4].downcase != '.app' and not FileTest.exist?(name+ '.app')
			name += '.app'
		end
		if not FileTest.exist?(name)
			raise RuntimeError, name
		end
		return name
	end
	
	def FindApp.byID(id)
		return _findApp(nil, id, nil)
	end
	
	def FindApp.byCreator(creator)
		return _findApp(creator, nil, nil)
	end
end
