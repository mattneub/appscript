#!/usr/local/bin/ruby

require 'appscript'

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
		# get terminology for target application
		app_path = unpack_param(request, 'AppP')
		app_obj = Appscript.app(app_path)
		app_data = app_obj.AS_app_data
		# get command name
		event_code = unpack_param(request, 'Evnt')
		command_name, param_by_name = lookup_command(event_code, app_data)
		param_by_code = {}
		param_by_name.each { |k, v| param_by_code[v] = k }
		# get reference upon which command is being called
		target = unpack_param(request, 'Targ', app_data)
		target = app_obj if target == nil
		# format keyword parameters
		params = []
		keyword_params = unpack_param(request, 'KPar', app_data)
		keyword_params.each do |key, value|
			params << "#{param_by_code[key].inspect} => #{value.inspect}"
		end
		# format attributes
		result_type = unpack_param(request, 'RTyp', app_data)
		mode_flags = unpack_param(request, 'Mode')
		timeout = unpack_param(request, 'Time')
		params << ":result_type => #{result_type.inspect}" if result_type != nil
		params << ":wait_reply => false" if mode_flags & KAE::KAEWaitReply == 0
		params << ":timeout => #{timeout.inspect}" if timeout != 3600 and timeout != -1
		# format direct parameter, if given
		direct_param = unpack_param(request, 'DPar', app_data)
		if direct_param != nil
			# add an empty hash for keyword atts/params argument if needed
			params = ["{}"] if params == [] and direct_param.is_a?(Hash)
			params[0, 0] = direct_param.inspect
		end
		# assemble and return finished string
		params = params.join(', ')
		params = "(#{params})" if params != ''
		return reply.put_param('----', DefaultCodecs.pack(
				"#{target.inspect}.#{command_name}#{params}"))
	end
	
	
	def handle_quit(request, reply)
		AE.quit_application_event_loop
	end
end

application = Application.new

########


AE.install_event_handler('Evnt', 'Fmt_', AEHandler.new(application, :handle_render))

AE.install_event_handler('aevt', 'quit', AEHandler.new(application, :handle_quit))

AE.run_application_event_loop
