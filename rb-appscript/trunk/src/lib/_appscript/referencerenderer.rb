#!/usr/local/bin/ruby

require "_aem/aemreference"


class ReferenceRenderer

	private_class_method :new
	attr_reader :result
	
	def initialize(appdata)
		@_appdata = appdata
		@_referencebycode = appdata.referencebycode
		@_typebycode = appdata.typebycode
		if  appdata.path
			@_root = "AS.app(#{appdata.path.inspect})"
		elsif  appdata.pid
			@_root = "AS.app.byPID(#{appdata.pid.inspect})"
		elsif  appdata.url
			@_root = "AS.app.byURL(#{appdata.url.inspect})"
		else
			@_root = "AS.app.current"
		end
		@result = ''
	end
	
	def _format(val)
		if val.is_a?(AEMReference::Base)
			return ReferenceRenderer.render(@_appdata, val)
		else
			return val.inspect
		end
	end
	
	def property(code)
		@result += ".#{@_appdata.referencebycode[code]}"
		return self
	end
	
	def elements(code)
		@result += ".#{@_appdata.referencebycode[code]}"
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
		@result += ".previous(#{_format(@_typebycode[sel])})"
		return self
	end
	
	def next(sel)
		@result += ".next(#{_format(@_typebycode[sel])})"
		return self
	end
	
	def method_missing(name, *args)
		case name
			when :app
				@result = @_root
			when :con, :its
				@result = "AS.#{name}"
		else
			if args.length > 0
				@result += ".#{name.to_s}(#{(args.map { |arg| arg.inspect }).join(', ')})"
			else
				@result += ".#{name.to_s}"
			end
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

	
	