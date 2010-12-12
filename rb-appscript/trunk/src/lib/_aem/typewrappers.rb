#
# rb-appscript
#
# typewrappers -- Ruby classes representing type, enumerator, property and keyword AEDescs
#

module TypeWrappers
	
	class AETypeBase
		
		attr_reader :code
		
		def initialize(code)
			if not(code.is_a?(String) and code.length == 4)
				raise ArgumentError, "Code must be a four-character string: #{code.inspect}"
			end
			@code = code
		end
		
		def hash 
			return @code.hash
		end
		
		def ==(val)
			return (self.equal?(val) or (val.class == self.class and val.code == @code))
		end
		
		alias_method :eql?, :== 
			
		def to_s
			return "AEM::#{self.class::Name}.new(#{@code.inspect})"
		end
		
		def inspect
			return to_s
		end
	end
	
	
	class AEType < AETypeBase
		Name = 'AEType'
	end
	
	
	class AEEnum < AETypeBase
		Name = 'AEEnum'
	end
	
	
	class AEProp < AETypeBase
		Name = 'AEProp'
	end
	
	
	class AEKey < AETypeBase
		Name = 'AEKey'
	end

end