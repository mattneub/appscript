#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module FindApp

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

	def FindApp.by_name(name)
		if name[0, 1] != '/'
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
			raise RuntimeError, name
		end
		return name
	end
	
	def FindApp.by_id(id)
		return _find_app(nil, id, nil)
	end
	
	def FindApp.by_creator(creator)
		return _find_app(creator, nil, nil)
	end
end
