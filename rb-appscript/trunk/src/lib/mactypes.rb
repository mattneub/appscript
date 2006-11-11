#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module MacTypes

	require "ae"
	require "kae"
	
	class FileBase
	
		URLPrefix = 'file://localhost'
	
		def FileBase._pathToURL(path)
			return URLPrefix + path.gsub(/[^a-zA-Z0-9_.-\/]/) { |c| "%%%02x" % c[0] }
		end
	
		def FileBase._urlToPath(url)
			if url[0, URLPrefix.length] != URLPrefix
				raise ArgumentError, "Not a file:// URL."
			end
			return url[URLPrefix.length, url.length].gsub(/%../) { |s| "%c" % s[1,2].hex }
		end
		
		def FileBase._coerce(desc, type, path=nil)
			begin
				return desc.coerce(type)
			rescue AE::MacOSError => e
				if [-35, -43, -120, -1700].include?(e.to_i) # disk/file/folder not found, or coercion error
					if path != nil
						raise FileNotFoundError, "File #{path.inspect} not found."
					else
						raise FileNotFoundError, "File not found."
					end
				else
					raise
				end
			end
		end
	end
	
	# public
	
	class Alias < FileBase
		
		attr_reader :desc
		private_class_method :new
		
		def initialize(desc)
			@desc = desc
		end
		
		def Alias.at(path)
			return new(FileBase._coerce(
					AE::AEDesc.new(KAE::TypeFileURL, FileBase._pathToURL(path)),
					KAE::TypeAlias, path))
		end
		
		def Alias.newDesc(desc)
			return new(desc)
		end
		
		def desc
			return @desc
		end
		
		def to_s
			return FileBase._urlToPath(FileBase._coerce(@desc, KAE::TypeFileURL).data)
		end
		
		def inspect
			return "MacTypes::Alias.at(#{to_s.inspect})"
		end
		
		def to_Alias
			return self
		end
		
		def to_FileURL
			return MacTypes::FileURL.newDesc(FileBase._coerce(@desc, KAE::TypeFileURL))
		end
	end
	
	##
	
	class FileURL < FileBase
		private_class_method :new
		
		def initialize(path, desc)
			@path = path
			@desc = desc
		end
		
		def FileURL.at(path)
			return new(path, nil)
		end
		
		def FileURL.newDesc(desc)
			return new(nil, desc)
		end
		
		def desc
			if not @desc
				@desc = AE::AEDesc.new(KAE::TypeFileURL, FileBase._pathToURL(@path))
			end
			return @desc
		end
		
		def to_s
			if not @path
				@path = FileBase._urlToPath(FileBase._coerce(@desc, KAE::TypeFileURL).data)
			end
			return @path
		end
		
		def inspect
			return "MacTypes::FileURL.at(#{to_s.inspect})"
		end
		
		def to_Alias
			return MacTypes::Alias.newDesc(FileBase._coerce(desc, KAE::TypeAlias, to_s))
		end
		
		def to_FileURL
			return self
		end
	end
	
	##
	
	class FileNotFoundError < RuntimeError
	end
	
	#######
		
	class Units
	
		private_class_method :new
		attr_reader :value, :type
	
		def Units.method_missing(name, value)
			return new(value, name)
		end
		
		def initialize(value, type)
			@value = value
			@type = type
		end
		
		def ==(val)
			return (self.equal?(val) or (
					self.class == val.class and 
					@value == val.value and @type == val.type))
		end
		
		alias_method :eql?, :==
		
		def hash
			return [@value, @type].hash
		end
		
		def to_i
			return @value.to_i
		end
		
		def to_f
			return @value.to_f
		end
		
		def to_s
			inspect
		end
		
		def inspect
			return "MacTypes::Units.#{@type}(#{@value.inspect})"
		end
	end

end

