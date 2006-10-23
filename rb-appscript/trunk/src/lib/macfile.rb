#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module MacFile

	require "ae"
	require "kae"
	
	class FileBase
	
		URLPrefix = 'file://localhost'
	
		def FileBase._pathToURL(path)
			return URLPrefix + File.expand_path(path).gsub(/[^a-zA-Z0-9_.-\/]/) { |c| "%%%02x" % c[0] }
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
				if [-35, -43, -120, -1700].include?(e.number) # disk/file/folder not found, or coercion error
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
			return "MacFile::Alias.at(#{to_s.inspect})"
		end
		
		def to_Alias
			return self
		end
		
		def to_FileURL
			return MacFile::FileURL.newDesc(FileBase._coerce(@desc, KAE::TypeFileURL))
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
			return "MacFile::FileURL.at(#{to_s.inspect})"
		end
		
		def to_Alias
			return MacFile::Alias.newDesc(FileBase._coerce(desc, KAE::TypeAlias, to_s))
		end
		
		def to_FileURL
			return self
		end
	end
	
	##
	
	class FileNotFoundError < RuntimeError
	end
end

