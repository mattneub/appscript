#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "_aem/aemreference"


class ReferenceRenderer

	private_class_method :new
	attr_reader :result
	
	def initialize(appdata)
		@_appdata = appdata
		@result = "AS"
	end
	
	def _format(val)
		if val.is_a?(AEMReference::Base)
			return ReferenceRenderer.render(@_appdata, val)
		else
			return val.inspect
		end
	end
	
	def property(code)
		name = @_appdata.referencebycode.fetch('p'+code) { @_appdata.referencebycode.fetch('e'+code) }
		@result += ".#{name}"
		return self
	end
	
	def elements(code)
		name = @_appdata.referencebycode.fetch('e'+code) { @_appdata.referencebycode.fetch('p'+code) }
		@result += ".#{name}"
		return self
	end
	
	def byname(name)
		@result += "[#{_format(name)}]"
		return self
	end
	
	def byindex(index)
		@result += "[#{_format(index)}]"
		return self
	end
	
	def byid(id)
		@result += ".ID(#{_format(id)})"
		return self
	end
	
	def byrange(sel1, sel2)
		@result += "[#{_format(sel1)}, #{_format(sel2)}]"
		return self
	end
	
	def byfilter(sel)
		@result += "[#{_format(sel)}]"
		return self
	end
	
	def previous(sel)
		@result += ".previous(#{_format(@_appdata.typebycode[sel])})"
		return self
	end
	
	def next(sel)
		@result += ".next(#{_format(@_appdata.typebycode[sel])})"
		return self
	end
	
	def app
		if @_appdata.path
			@result += ".app(#{@_appdata.path.inspect})"
		elsif @_appdata.pid
			@result += ".app.bypid(#{@_appdata.pid.inspect})"
		elsif @_appdata.url
			@result += ".app.byurl(#{@_appdata.url.inspect})"
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
	
	def ReferenceRenderer.render(appdata, aemreference)
		f = new(appdata)
		begin
			aemreference.AEM_resolve(f)
			return f.result
		rescue
			return aemreference.inspect
		end
	end

end

	
	