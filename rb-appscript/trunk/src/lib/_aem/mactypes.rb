#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module MacTypes

	require "ae"
	require "kae"
	
	class FileBase
	
		URLPrefix = 'file://localhost'
	
		def FileBase._path_to_url(path)
			return URLPrefix + path.gsub(/[^a-zA-Z0-9_.-\/]/) { |c| "%%%02x" % c[0] }
		end
	
		def FileBase._url_to_path(url)
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
		
		def Alias.path(path)
			return new(FileBase._coerce(
					AE::AEDesc.new(KAE::TypeFileURL, FileBase._path_to_url(path)),
					KAE::TypeAlias, path))
		end
		
		def Alias.desc(desc)
			return new(desc)
		end
		
		def desc
			return @desc
		end
		
		def path
			return FileBase._url_to_path(FileBase._coerce(@desc, KAE::TypeFileURL).data)
		end
		
		alias_method :to_s, :path
		
		def inspect
			return "MacTypes::Alias.path(#{to_s.inspect})"
		end
		
		def to_alias
			return self
		end
		
		def to_file_url
			return MacTypes::FileURL.desc(FileBase._coerce(@desc, KAE::TypeFileURL))
		end
	end
	
	##
	
	class FileURL < FileBase
		private_class_method :new
		
		def initialize(path, desc)
			@path = path
			@desc = desc
		end
		
		def FileURL.path(path)
			return new(path, nil)
		end
		
		def FileURL.desc(desc)
			return new(nil, desc)
		end
		
		def desc
			if not @desc
				@desc = AE::AEDesc.new(KAE::TypeFileURL, FileBase._path_to_url(@path))
			end
			return @desc
		end
		
		def path
			if not @path
				@path = FileBase._url_to_path(FileBase._coerce(@desc, KAE::TypeFileURL).data)
			end
			return @path
		end
		
		alias_method :to_s, :path
		
		def inspect
			return "MacTypes::FileURL.path(#{to_s.inspect})"
		end
		
		def to_alias
			return MacTypes::Alias.desc(FileBase._coerce(desc, KAE::TypeAlias, to_s))
		end
		
		def to_file_url
			return MacTypes::FileURL.desc(FileBase._coerce(desc, KAE::TypeFileURL, to_s))
		end
	end
	
	##
	
	class FileNotFoundError < RuntimeError
	end
	
	#######
		
	class Units
	
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
			return "#{@value.inspect} #{@type.tr('_', ' ')}"
		end
		
		def inspect
			return "MacTypes::Units.new(#{@value.inspect}, #{@type.inspect})"
		end
	end

end

