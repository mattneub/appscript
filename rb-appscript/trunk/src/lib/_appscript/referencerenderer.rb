#
# rb-appscript
#
# referencerenderer -- obtain an appscript-style string representation of an aem reference
#

require "_aem/aemreference"


class ReferenceRenderer
	# Generates string representations of appscript references from aem object specifiers.

	private_class_method :new
	attr_reader :result
	
	def initialize(app_data)
		@_app_data = app_data
		@result = ""
	end
	
	def _format(val)
		if val.is_a?(AEMReference::Query)
			return ReferenceRenderer.render(@_app_data, val)
		else
			return val.inspect
		end
	end
	
	##
	
	def property(code)
		name = @_app_data.reference_by_code.fetch('p'+code) { @_app_data.reference_by_code.fetch('e'+code) }
		@result += ".#{name}"
		return self
	end
	
	def elements(code)
		name = @_app_data.reference_by_code.fetch('e'+code) { @_app_data.reference_by_code.fetch('p'+code) }
		@result += ".#{name}"
		return self
	end
	
	def by_name(name)
		@result += "[#{_format(name)}]"
		return self
	end
	
	def by_index(index)
		@result += "[#{_format(index)}]"
		return self
	end
	
	def by_id(id)
		@result += ".ID(#{_format(id)})"
		return self
	end
	
	def by_range(sel1, sel2)
		@result += "[#{_format(sel1)}, #{_format(sel2)}]"
		return self
	end
	
	def by_filter(sel)
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
	
	def custom_root(value)
		app
		@result += ".AS_new_reference(#{value.inspect})"
		return self
	end
	
	def app
		case @_app_data.constructor
			when :current
				@result = "app.current"
			when :by_path
				@result = "app(#{@_app_data.identifier.inspect})"
		else
			@result = "app.#{@_app_data.constructor}(#{@_app_data.identifier.inspect})"
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
	
	def gt(val)
		@result += ".gt(#{_format(val)})"
		return self
	end
	
	def ge(val)
		@result += ".ge(#{_format(val)})"
		return self
	end
	
	def eq(val)
		@result += ".eq(#{_format(val)})"
		return self
	end
	
	def ne(val)
		@result += ".ne(#{_format(val)})"
		return self
	end
	
	def lt(val)
		@result += ".lt(#{_format(val)})"
		return self
	end
	
	def le(val)
		@result += ".le(#{_format(val)})"
		return self
	end
	
	def begins_with(val)
		@result += ".begins_with(#{_format(val)})"
		return self
	end
	
	def ends_with(val)
		@result += ".ends_with(#{_format(val)})"
		return self
	end
	
	def contains(val)
		@result += ".contains(#{_format(val)})"
		return self
	end
	
	def is_in(val)
		@result += ".is_in(#{_format(val)})"
		return self
	end
	
	def and(*operands)
		@result += ".and(#{(operands.map { |val| _format(val) }).join(', ')})"
		return self
	end
	
	def or(*operands)
		@result += ".or(#{(operands.map { |val| _format(val) }).join(', ')})"
		return self
	end
	
	def not
		@result += ".not"
		return self
	end
	
	# public
	
	def ReferenceRenderer.render(app_data, aem_reference)
		# Take an aem reference, e.g.:
		#
		#	app.elements('docu').by_index(1).property('ctxt')
		#
		# and an AppData instance containing application's location and terminology, 
		# and render an appscript-style reference string, e.g.:
		#
		#	"AS.app('/Applications/TextEdit.app').documents[1].text"
		#
		# Used by AS::Reference#to_s
		#
		f = new(app_data)
		begin
			aem_reference.AEM_resolve(f)
			return f.result
		rescue
			return "#{new(app_data).app.result}.AS_new_reference(#{aem_reference.inspect})"
		end
	end

end

	
	