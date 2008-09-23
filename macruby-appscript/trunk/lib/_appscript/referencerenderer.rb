# Copyright (C) 2008 HAS. 
# Released under MIT License.

framework 'Appscript'


class MRAReferenceRenderer < AEMResolver
	# Generates string representations of appscript references from aem object specifiers.

	private_class_method :new
	attr_reader :result
	
	def initWithAppData(app_data)
		init
		@_app_data = app_data
		@result = ""
		return self
	end
	
	def _format(val)
		case val
			when AEMQuery
				return MRAReferenceRenderer.render(@_app_data, val)
			when NSString
				return val.to_s.inspect
			# TO DO: reformat ObjC values as Ruby values
			when NSObject
				return val
		else
			return val.inspect
		end
	end
	
	##
	
	def property(code)
		code = AEMType.typeWithCode(code)
		name = @_app_data.property_by_code.objectForKey(code)
		name = @_app_data.element_by_code.objectForKey(code) if not name
		name = "<#{code}>" if not name
		@result += ".#{name}"
		return self
	end
	
	def elements(code)
		code = AEMType.typeWithCode(code)
		name = @_app_data.element_by_code.objectForKey(code)
		name = @_app_data.property_by_code.objectForKey(code) if not name
		name = "<#{code}>" if not name
		@result += ".#{name}"
		return self
	end
	
	def byName(name)
		@result += "[#{_format(name)}]"
		return self
	end
	
	def byIndex(index)
		@result += "[#{_format(index)}]"
		return self
	end
	
	def byID(id)
		@result += ".ID(#{_format(id)})"
		return self
	end
	
	def byRange_to(sel1, sel2)
		@result += "[#{_format(sel1)}, #{_format(sel2)}]"
		return self
	end
	
	def byTest(sel)
		@result += "[#{_format(sel)}]"
		return self
	end
	
	def previous(sel)
		@result += ".previous(#{_format(@_app_data.type_by_code[sel])})"
		return self
	end
	
	def next(sel)
		@result += ".next(#{_format(@_app_data.type_by_code[sel])})"
		return self
	end
	
	##
	
	def customRoot(value)
		app
		@result += ".AS_new_reference(#{_format(value)})"
		return self
	end
	
	ConstructorNames = {
			KASTargetCurrent => :current,
			KASTargetName => :by_name,
			KASTargetBundleID => :by_id,
			KASTargetURL => :by_url,
			KASTargetPID => :by_pid,
			KASTargetDescriptor => :by_aedesc, # TO DO
	}
	
	def app
		case @_app_data.constructor
			when KASTargetCurrent
				@result = "app.current"
			when KASTargetName
				@result = "app(#{_format(@_app_data.identifier)})"
		else
			@result = "app.#{ConstructorNames[@_app_data.constructor]}(#{_format(@_app_data.identifier)})"
		end
		return self
	end
	
	def con
		@result = "con"
		return self
	end
	
	def its
		@result = "its"
		return self
	end
	
	##
	
	def beginning
		@result += ".beginning"
		return self
	end
	
	def end
		@result += ".end"
		return self
	end
	
	def before
		@result += ".before"
		return self
	end
	
	def after
		@result += ".after"
		return self
	end
	
	##
	
	def first
		@result += ".first"
		return self
	end
	
	def middle
		@result += ".middle"
		return self
	end
	
	def last
		@result += ".last"
		return self
	end
	
	def any
		@result += ".any"
		return self
	end
	
	##
	
	def greaterThan(val)
		@result += ".gt(#{_format(val)})"
		return self
	end
	
	def greaterOrEquals(val)
		@result += ".ge(#{_format(val)})"
		return self
	end
	
	def equals(val)
		@result += ".eq(#{_format(val)})"
		return self
	end
	
	def notEquals(val)
		@result += ".ne(#{_format(val)})"
		return self
	end
	
	def lessThan(val)
		@result += ".lt(#{_format(val)})"
		return self
	end
	
	def lessOrEquals(val)
		@result += ".le(#{_format(val)})"
		return self
	end
	
	def beginsWith(val)
		@result += ".begins_with(#{_format(val)})"
		return self
	end
	
	def endsWith(val)
		@result += ".ends_with(#{_format(val)})"
		return self
	end
	
	def contains(val)
		@result += ".contains(#{_format(val)})"
		return self
	end
	
	def isIn(val)
		@result += ".is_in(#{_format(val)})"
		return self
	end
	
	def AND(operands)
		@result += ".and(#{(operands.map { |val| _format(val) }).join(', ')})" # TO DO: check
		return self
	end
	
	def OR(operands)
		@result += ".or(#{(operands.map { |val| _format(val) }).join(', ')})"
		return self
	end
	
	def NOT
		@result += ".not"
		return self
	end
	
	# public
	
	def MRAReferenceRenderer.render(app_data, aem_reference)
		f = self.alloc.initWithAppData(app_data)
		begin
			aem_reference.resolveWithObject(f)
			return f.result
		rescue
			return "#{new(app_data).app.result}.AS_new_reference(#{_format(aem_reference)})"
		end
	end

end

	
	