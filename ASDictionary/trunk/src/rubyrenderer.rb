#!/usr/bin/env ruby

begin; require 'rubygems'; rescue LoadError; end

require 'appscript'
require 'pp'

#######

class AEHandler

	# instances of this class are installed via AE.install_event_handler and
	# AE.install_coercion_handler, and are responsible for invoking 'handler'
	# methods in main Application instance
	
	def initialize(target, method_name)
		@target = target
		@method_name = method_name
	end

	def handle_event(request, reply)
		begin
			@target.send(@method_name, request, reply)
		rescue => e
			puts "Couldn't handle event: #{e}"
			return -2700
		end
		return 0
	end
end

#######


class Application

	def initialize
		@_cache = {}
	end
	
	def unpack_param(event, key, codecs= DefaultCodecs)
		return codecs.unpack(event.get_param(key, '****'))
	end
	
	def lookup_command(code, app_data)
		app_data.reference_by_name.each do |key, value|
			return [key, value[1][1]] if value[0] == :command and value[1][0] == code
		end
	end
	
	##
	
	def handle_render(request, reply)
		constructor = unpack_param(request, 'Cons')
		identity = unpack_param(request, 'Iden')
		id = [constructor, identity]
		if not @_cache.has_key?(id)
			appobj = case constructor
				when 'path' then Appscript.app(identity)
				when 'pid' then Appscript.app.by_pid(identity)
				when 'url' then Appscript.app(url=identity)
				when 'aemapp' then Appscript.app.by_aem_app(AEM::Application.by_desc(identity))
				when 'current' then Appscript.app.current
			else
				raise RuntimeError, "Unknown constructor: #{constructor}"
			end
			@_cache[id] = appobj
		end
		values = unpack_param(request, 'Data', @_cache[id].AS_app_data)
		if unpack_param(request, 'IsRe') # is reference? (typeNull should appear as app object, not nil)
			strings = values.collect { |o| o == nil ? @_cache[id].inspect : o.inspect }
		elsif unpack_param(request, 'PPri') # pretty print?
			strings = values.collect { |o| o.pretty_inspect }
		else
			strings = values.collect { |o| o.inspect }
		end
		return reply.put_param('----', DefaultCodecs.pack(strings))
	end
	
	
	def handle_quit(request, reply)
		AE.quit_application_event_loop
	end
end

application = Application.new

########

AE.install_event_handler('AppS', 'Fmt_', AEHandler.new(application, :handle_render))

AE.install_event_handler('aevt', 'quit', AEHandler.new(application, :handle_quit))

AE.run_application_event_loop
