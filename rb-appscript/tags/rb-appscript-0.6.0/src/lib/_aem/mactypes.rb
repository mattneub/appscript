#
# rb-appscript
#
# mactypes -- Ruby classes representing Alias, FileURL and unit type AEDescs
#

module MacTypes
	# Defines wrapper classes for Mac OS datatypes that don't have a suitable Ruby equivalent.
	#
	# Note: all path strings are/must be valid UTF8.

	require "ae"
	require "kae"
	
	KCFURLPOSIXPathStyle = 0
	KCFURLHFSPathStyle = 1
	KCFURLWindowsPathStyle = 2
	
	class FileBase
		
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
		
		def ==(val)
			return (self.equal?(val) or (self.class == val.class and self.url == val.url))
		end
		
		alias_method :eql?, :==
		
		def hash
			return [desc.type, desc.data].hash
		end
	end
	
	# public
	
	class Alias < FileBase
		# Wraps AEDescs of typeAlias. Alias objects keep track of filesystem objects as they're moved around the disk or renamed.
		#
		# Since Ruby doesn't already bridge the Mac OS's Alias Manager, simplest solution is to always store data internally as an AEDesc of typeAlias, and convert this to other forms on demand (e.g. when casting to string).
		
		private_class_method :new
		
		def initialize(desc)
			@desc = desc
		end
		
		# Constructors
		
		def Alias.path(path)
			# Make Alias object from POSIX path.
			return new(FileBase._coerce(
					AE::AEDesc.new(KAE::TypeFileURL, AE.convert_path_to_url(path, KCFURLPOSIXPathStyle)),
					KAE::TypeAlias, path))
		end
		
		def Alias.hfs_path(path)
			# Make Alias object from HFS path.
			return new(FileBase._coerce(
					AE::AEDesc.new(KAE::TypeFileURL, AE.convert_path_to_url(path, KCFURLHFSPathStyle)),
					KAE::TypeAlias, path))
		end
		
		def Alias.url(url)
			# Make Alias object from file URL. Note: only the path portion of the URL is used; the domain will always be localhost.
			return Alias.path(AE.convert_url_to_path(url, KCFURLPOSIXPathStyle))
		end
		
		def Alias.desc(desc)
			# Make Alias object from CarbonX.AE.AEDesc of typeAlias. Note: descriptor type is not checked; clients are responsible for passing the correct type as other types will cause unexpected problems/errors.
			return new(desc)
		end
		
		# Methods
		
		attr_reader :desc # Return AEDesc of typeAlias. If clients want a different type, they can subsequently call this AEDesc's coerce method.
		
		def url
			# Get as URL string.
			return desc.coerce(KAE::TypeFileURL).data
		end
		
		def path
			# Get as POSIX path.
			return AE.convert_url_to_path(FileBase._coerce(@desc, KAE::TypeFileURL).data, KCFURLPOSIXPathStyle)
		end
		
		def hfs_path
			# Get as HFS path.
			return AE.convert_url_to_path(FileBase._coerce(@desc, KAE::TypeFileURL).data, KCFURLHFSPathStyle)
		end
		
		alias_method :to_s, :path
		
		def inspect
			return "MacTypes::Alias.path(#{to_s.inspect})"
		end
		
		def to_alias
			# Get as MacTypes::Alias.
			return self
		end
		
		def to_file_url
			# Get as MacTypes::FileURL; note that the resulting FileURL object will always pack as an AEDesc of typeFileURL.
			return MacTypes::FileURL.desc(FileBase._coerce(@desc, KAE::TypeFileURL))
		end
	end
	
	##
	
	class FileURL < FileBase
		# Wraps AEDescs of typeFSRef/typeFSS/typeFileURL to save user from having to deal with them directly. FileURL objects refer to specific locations on the filesystem which may or may not already exist.
		
		private_class_method :new
		
		def initialize(path, desc)
			@path = path
			@desc = desc
		end
		
		# Constructors
		
		def FileURL.path(path)
			# Make FileURL object from POSIX path.
			return new(path, nil)
		end
		
		def FileURL.hfs_path(path)
			# Make FileURL object from HFS path.
			return new(AE.convert_url_to_path(AE.convert_path_to_url(path, KCFURLHFSPathStyle), KCFURLPOSIXPathStyle), nil)
		end
		
		def FileURL.url(url)
			# Make FileURL object from file URL. Note: only the path portion of the URL is used; the domain will always be localhost.
			return FileURL.path(AE.convert_url_to_path(url, KCFURLPOSIXPathStyle))
		end
		
		def FileURL.desc(desc)
			# Make FileURL object from AEDesc of typeFSS, typeFSRef, typeFileURL. Note: descriptor type is not checked; clients are responsible for passing the correct type as other types will cause unexpected problems/errors.
			return new(nil, desc)
		end
		
		# Methods
		
		def desc
			# Get as AEDesc. If constructed from Ruby, descriptor's type is always typeFileURL; if returned by aem, its type may be typeFSS, typeFSRef or typeFileURL.
			if not @desc
				@desc = AE::AEDesc.new(KAE::TypeFileURL, AE.convert_path_to_url(@path, KCFURLPOSIXPathStyle))
			end
			return @desc
		end
		
		def url
			# Get as URL string.
			return desc.coerce(KAE::TypeFileURL).data
		end
		
		def path
			# Get as POSIX path.
			if not @path
				@path = AE.convert_url_to_path(FileBase._coerce(@desc, KAE::TypeFileURL).data, KCFURLPOSIXPathStyle)
			end
			return @path
		end
		
		def hfs_path
			return AE.convert_url_to_path(AE.convert_path_to_url(path, KCFURLPOSIXPathStyle), KCFURLHFSPathStyle)
		end
		
		alias_method :to_s, :path
		
		def inspect
			return "MacTypes::FileURL.path(#{to_s.inspect})"
		end
		
		def to_alias
			# Get as MacTypes::Alias.
			return MacTypes::Alias.desc(FileBase._coerce(desc, KAE::TypeAlias, to_s))
		end
		
		def to_file_url
			# Get as MacTypes::FileURL; note that the resulting FileURL object will always pack as an AEDesc of typeFileURL.
			return MacTypes::FileURL.desc(FileBase._coerce(desc, KAE::TypeFileURL, to_s))
		end
	end
	
	##
	
	class FileNotFoundError < RuntimeError
		# Raised when an operation that only works for an existing filesystem object/location is performed on an Alias/FileURL object that identifies a non-existent object/location.
	end
	
	#######
		
	class Units
		# Represents a measurement; e.g. 3 inches, 98.5 degrees Fahrenheit.
		#
		# The AEM defines a standard set of unit types; some applications may define additional types for their own use. This wrapper stores the raw unit type and value data; aem/appscript Codecs objects will convert this to/from an AEDesc, or raise an error if the unit type is unrecognised.
	
		attr_reader :value, :type
		
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

