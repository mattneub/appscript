#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "_aem/aemreference"


class ReferenceRenderer

	private_class_method :new
	attr_reader :result
	
	def initialize(app_data)
		@_app_data = app_data
		@result = "AS"
	end
	
	def _format(val)
		if val.is_a?(AEMReference::Base)
			return ReferenceRenderer.render(@_app_data, val)
		else
			return val.inspect
		end
	end
	
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
	
	def app
		if @_app_data.path
			@result += ".app(#{@_app_data.path.inspect})"
		elsif @_app_data.pid
			@result += ".app.by_pid(#{@_app_data.pid.inspect})"
		elsif @_app_data.url
			@result += ".app.by_url(#{@_app_data.url.inspect})"
		else
			@result += ".app.current"
		end
		return self
	end
	
	def con
		@result += ".con"
		return self
	end
	
	def its
		@result += ".its"
		return self
	end
	
	def method_missing(name, *args)
		if args.length > 0
			@result += ".#{name.to_s}(#{(args.map { |arg| arg.inspect }).join(', ')})"
		else
			@result += ".#{name.to_s}"
		end
		return self
	end
	
	# public
	
	def ReferenceRenderer.render(app_data, aem_reference)
		f = new(app_data)
		begin
			aem_reference.AEM_resolve(f)
			return f.result
		rescue
			return aem_reference.inspect
		end
	end

end

	
	