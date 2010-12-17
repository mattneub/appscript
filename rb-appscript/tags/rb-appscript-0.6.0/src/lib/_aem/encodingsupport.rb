#
# rb-appscript
#
# encodingsupport -- support string encodings in Ruby 1.9+
#


module AEMEncodingSupport

	module EnableStringEncodings
		# AE extension methods consume and return Strings containing UTF-8 encoded data, ignoring
		# any attached encoding information. This module provides wrappers for AE interactions that
		# take care of any encoding issues in Ruby 1.9+.
		
		def EnableStringEncodings.to_utf8_string(s)
			# Call before passing a string to an AE method that expects it to contain UTF-8 encoded data.
			return s if [Encoding::ASCII_8BIT, Encoding::UTF_8].include?(s.encoding)
			return s.encode('UTF-8')
		end
		
		def EnableStringEncodings.pack_string(s, as_type)
			begin
				return AE::AEDesc.new(KAE::TypeUTF8Text, EnableStringEncodings.to_utf8_string(s)).coerce(as_type)
			rescue AE::MacOSError => e
				if e.to_i == -1700 # couldn't coerce to TypeUnicodeText
					raise TypeError, "Not valid UTF8 data or couldn't coerce to type %{as_type}: #{s.inspect}"
				else
					raise
				end
			end
		end
		
		def EnableStringEncodings.unpack_string(desc)
			# String instances returned by AE methods contain UTF-8 data and ASCII-8BIT encoding,
			# so change the encoding to match the data
			return desc.coerce(KAE::TypeUTF8Text).data.force_encoding('UTF-8')
		end
	end
	
	
	module DisableStringEncodings
		# Support for Ruby 1.8 Strings, which do not contain encoding information. User is responsible
		# for ensuring String instances passed to AE APIs contain UTF-8 encoded data; String instances
		# returned by unpack_string will always contain contain UTF-8 encoded data.
		
		def DisableStringEncodings.to_utf8_string(s)
			return s
		end
		
		def DisableStringEncodings.pack_string(s, as_type)
			begin
				# Note: while the BOM is optional in typeUnicodeText, it's not included by AS
				# and some apps, e.g. iTunes 7, will handle it incorrectly, so it's omitted here.)
				return AE::AEDesc.new(KAE::TypeUTF8Text, s).coerce(as_type)
			rescue AE::MacOSError => e
				if e.to_i == -1700 # couldn't coerce to TypeUnicodeText
					raise TypeError, "Not valid UTF8 data or couldn't coerce to type %{as_type}: #{s.inspect}"
				else
					raise
				end
			end
		end
		
		def DisableStringEncodings.unpack_string(desc)
			return desc.coerce(KAE::TypeUTF8Text).data
		end
		
	end
	
	
	def AEMEncodingSupport.encoding_support
		# get the appropriate module for the Ruby version used
		version, sub_version = RUBY_VERSION.split('.').collect {|n| n.to_i} [0, 2]
		return (version >= 1 and sub_version >= 9) ? AEMEncodingSupport::EnableStringEncodings : AEMEncodingSupport::DisableStringEncodings
	end

end