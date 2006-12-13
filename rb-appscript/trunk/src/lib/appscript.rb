#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "_aem/mactypes"

module Appscript
	# The following methods and classes are of interest to end users:
	# app, con, its, CommandError, ApplicationNotFoundError
	# Other classes are only of interest to implementors who need to hook in their own code.
	
	require "kae"
	require "aem"
	require "_appscript/referencerenderer"
	require "_appscript/terminology"
	
	######################################################################
	# APPDATA
	######################################################################
	
	module AppDataAccessors
		attr_reader :target, :type_by_name, :type_by_code, :reference_by_name, :reference_by_code
	end
	
	class AppData < AEM::Codecs
	
		attr_reader :path, :pid, :url
	
		def initialize(aem_application_class, path, pid, url, terms)
			super()
			@_aem_application_class = aem_application_class
			@_terms = terms
			@path = path
			@pid = pid
			@url = url
		end
		
		def _connect # initialize AEM::Application instance and terminology tables the first time they are needed
			if @path
				@target = @_aem_application_class.by_path(@path)
			elsif @pid
				@target = @_aem_application_class.by_pid(@pid)
			elsif @url
				@target = @_aem_application_class.by_url(@url)
			else
				@target = @_aem_application_class.current
			end
			case @_terms
				when true # obtain terminology from application
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = Terminology.tables_for_app(@path, @pid, @url)
				when false # use built-in terminology only (e.g. use this when running AppleScript applets)
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = Terminology.default_tables
				when nil # [developer-only] make Application#methods return names of built-in methods only (needed to generate reservedkeywords.rb file)
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = {}, {}, {}, {}
			else # @_terms is [assumed to be] a module containing dumped terminology, so use that
				@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = Terminology.tables_for_module(@_terms)
			end
			extend(AppDataAccessors)
		end
		
		#######
		
		def target
			_connect
			return @target
		end
		
		def type_by_name
			_connect
			return @type_by_name
		end
		
		def type_by_code
			_connect
			return @type_by_code
		end
		
		def reference_by_name
			_connect
			return @reference_by_name
		end
		
		def reference_by_code
			_connect
			return @reference_by_code
		end
		
		#######
		
		def pack(data)
			if data.is_a?(GenericReference)
				data = data.AS_resolve(self)
			end
			if data.is_a?(Reference)
				data = data.AS_aem_reference
			elsif data.is_a?(Symbol)
				data = self.type_by_name.fetch(data) { raise IndexError, "Unknown Keyword: #{data.inspect}" }
			end
			return super(data)
		end
		
		##
		
		ClassType = AEM::AEType.new('pcls')
		
		def pack_hash(val)
			record = AE::AEDesc.new_list(true)
			if val.has_key?(:class_) or val.has_key?(ClassType)
				# if hash contains a 'class' property containing a class name, coerce the AEDesc to that class
				new_val = Hash[val]
				if new_val.has_key?(:class_)
					value = new_val.delete(:class_)
				else
					value = new_val.delete(ClassType)
				end
				if value.is_a?(Symbol) # get the corresponding AEType (assuming there is one)
					value = @type_by_name.fetch(value, value)
				end
				if value.is_a?(AEM::AEType) # coerce the record to the desired type
					record = record.coerce(value.code)
					val = new_val
				end # else value wasn't a class name, so it'll be packed as a normal record property instead
			end	
			usrf = nil
			val.each do | key, value |
				if key.is_a?(Symbol)
					key_type = @type_by_name.fetch(key) { raise IndexError, "Unknown keyword: #{key.inspect}" }
					record.put_param(key_type.code, pack(value))
				elsif key.is_a?(AEM::AETypeBase)
					record.put_param(key.code, pack(value))
				else
					if usrf == nil
						usrf = AE::AEDesc.new_list(false)
					end
					usrf.put_item(0, pack(key))
					usrf.put_item(0, pack(value))
				end
			end
			if usrf
				record.put_param('usrf', usrf)
			end
			return record
		end
		
		def unpack_type(desc)
			aem_value = super(desc)
			return @type_by_code.fetch(aem_value.code, aem_value)
		end
		
		def unpack_enumerated(desc)
			aem_value = super(desc)
			return @type_by_code.fetch(aem_value.code, aem_value)
		end
		
		def unpack_property(desc)
			aem_value = super(desc)
			return @type_by_code.fetch(aem_value.code, aem_value)
		end
		
		def unpack_aerecord(desc)
			dct = {}
			desc.length().times do |i|
				key, value = desc.get_item(i + 1, KAE::TypeWildCard)
				if key == 'usrf'
					lst = unpack_aelist(value)
					(lst.length / 2).times do |i|
						dct[lst[i * 2]] = lst[i * 2 + 1]
					end
				else
					dct[@type_by_code.fetch(key) { AEM::AEType.new(key) }] = unpack(value)
				end
			end
			return dct
		end
		
		def unpack_object_specifier(desc)
			return Reference.new(self, DefaultCodecs.unpack_object_specifier(desc))
		end
		
		def unpack_insertion_loc(desc)
			return Reference.new(self, DefaultCodecs.unpack_insertion_loc(desc))
		end
				
		def unpack_contains_comp_descriptor(op1, op2)
			if op1.is_a?(Appscript::Reference) and op1.AS_aem_reference.AEM_root == AEMReference::Its
				return op1.contains(op2)
			else
				return super
			end
		end
	end
	
	
	######################################################################
	# GENERIC REFERENCE
	######################################################################
	
	class GenericReference
	
		attr_reader :_call
		protected :_call
		
		def initialize(call)
			@_call = call
		end
		
		def ==(v)
			return (self.class == v.class and @_call == v._call)
		end
		
		alias_method :eql?, :== 
		
		def hash
			return @_call.hash
		end
		
		def method_missing(name, *args)
			return AS::GenericReference.new(@_call + [[name, args]])
		end
	
		def to_s
			s= @_call[0]
			@_call[1, @_call.length].each do |name, args|					if name == :[]
					if args.length == 1
						s += "[#{args[0]}]"
					else
						s += "[#{args[0]}, #{args[1]}]"
					end
				else
					if args.length > 0
						s += ".#{name.to_s}(#{(args.map { |arg| arg.inspect }).join(', ')})"
					else
						s += ".#{name.to_s}"
					end
				end
			end
			return s
		end
		
		def inspect
			return to_s
		end
		
		def AS_resolve(app_data)
			ref = Reference.new(app_data, {'app' => AEM.app, 'con' => AEM.con, 'its' => AEM.its}[@_call[0]])
			@_call[1, @_call.length].each do |name, args|
				ref = ref.send(name, *args)
			end
			return ref
		end
	end
	
	
	######################################################################
	# REFERENCE
	######################################################################
	
	class Reference
	
		# users may occasionally require access to the following for creating workarounds to problem apps
		# note: calling #AS_app_data on a newly created application object will return an AppData instance
		# that is not yet fully initialised, so remember to call its #_connect method before use
		attr_reader :AS_aem_reference, :AS_app_data
		attr_writer :AS_aem_reference, :AS_app_data
	
		def initialize(app_data, aem_reference)
			@AS_app_data = app_data
			@AS_aem_reference = aem_reference
		end
		
		def _resolve_range_boundary(selector, value_if_none)
			if selector == nil
				selector = value_if_none
			end
			if selector.is_a?(Appscript::GenericReference)
				return selector.AS_resolve(@AS_app_data).AS_aem_reference
			elsif selector.is_a?(Reference)
				return selector.AS_aem_reference
			elsif selector.is_a?(String)
				return AEM.con.elements(@AS_aem_reference.AEM_want).by_name(selector)
			else
				return AEM.con.elements(@AS_aem_reference.AEM_want).by_index(selector)
			end
		end
		
		#######
		
		def Reference._pack_uint32(n) # used to pack csig attributes
			return AE::AEDesc.new(KAE::TypeUInt32, [n].pack('L'))
		end

		# 'csig' attribute flags (see ASRegistry.h; note: there's no option for 'numeric strings' in 10.4)

		IgnoreEnums = [
				[:case, KAE::KAECaseConsiderMask, KAE::KAECaseIgnoreMask],
				[:diacriticals, KAE::KAEDiacriticConsiderMask, KAE::KAEDiacriticIgnoreMask],
				[:whitespace, KAE::KAEWhiteSpaceConsiderMask, KAE::KAEWhiteSpaceIgnoreMask],
				[:hyphens, KAE::KAEHyphensConsiderMask, KAE::KAEHyphensIgnoreMask],
				[:expansion, KAE::KAEExpansionConsiderMask, KAE::KAEExpansionIgnoreMask],
				[:punctuation, KAE::KAEPunctuationConsiderMask, KAE::KAEPunctuationIgnoreMask],
				]
		
		# default cons, csig attributes
		
		DefaultConsiderations =  AEM::DefaultCodecs.pack([AEM::AEType.new('case')])
		DefaultConsidersAndIgnores = _pack_uint32(KAE::KAECaseIgnoreMask)
		
		##
		
		def _send_command(args, name, code, labelled_arg_terms)
	#		puts "Calling command #{name} \n\twith args #{args.inspect},\n\treference #{self}\n\tinfo #{code.inspect}, #{labelled_arg_terms.inspect}\n\n"
#			begin # TO DO: enable error handling block once debugging is completed
				atts = {'subj' => nil}
				params = {}
				case args.length
					when 0
						keyword_args = {}
					when 1 # note: if a command takes a hash as its direct parameter, user must pass {} as a second arg otherwise hash will be assumed to be keyword parameters
						if args[0].is_a?(Hash)
							keyword_args = args[0]
						else
							params['----'] = args[0]
							keyword_args = {}
						end
					when 2
						params['----'], keyword_args = args
				else
					raise ArgumentError, "Too many direct parameters."
				end
				if not keyword_args.is_a?(Hash)
					raise ArgumentError, "Second argument must be a Hash containing zero or more keyword parameters."
				end
				# get user-specified timeout, if any
				timeout = (keyword_args.delete(:timeout) {60}).to_i
				if timeout <= 0
					timeout = KAE::KNoTimeOut
				else
					timeout *= 60
				end
				# default send flags
				send_flags = KAE::KAECanSwitchLayer
				# ignore application's reply?
				send_flags += keyword_args.delete(:wait_reply) == false ? KAE::KAENoReply : KAE::KAEWaitReply
				# add considering/ignoring attributes
				ignore_options = keyword_args.delete(:ignore)
				if ignore_options == nil
					atts['cons'] = DefaultConsiderations
					atts['csig'] = DefaultConsidersAndIgnores
				else
					atts['cons'] = ignore_options
					csig = 0
					IgnoreEnums.each do |option, consider_mask, ignore_mask|
						csig += ignore_options.include?(option) ? ignore_mask : consider_mask
					end
					atts['csig'] = Reference._pack_uint32(csig)
				end
				# optionally specify return value type
				if keyword_args.has_key?(:result_type)
					params['rtyp'] = keyword_args.delete(:result_type)
				end
				# extract labelled parameters, if any
				keyword_args.each do |param_name, param_value|
					param_code = labelled_arg_terms[param_name]
					if param_code == nil
						raise ArgumentError, "Unknown keyword parameter: #{param_name.inspect}"
					end
					params[param_code] = param_value
				end
				# apply special cases
				# Note: appscript does not replicate every little AppleScript quirk when packing event attributes and parameters (e.g. AS always packs a make command's tell block as the subject attribute, and always includes an each parameter in count commands), but should provide sufficient consistency with AS's habits and give good usability in their own right.
				if @AS_aem_reference != AEM.app # If command is called on a Reference, rather than an Application...
					if code == 'coresetd'
						#  if ref.set(...) contains no 'to' argument, use direct argument for 'to' parameter and target reference for direct parameter
						if params.has_key?('----') and not params.has_key?('data')
							params['data'] = params['----']
							params['----'] = @AS_aem_reference
						elsif not params.has_key?('----')
							params['----'] = @AS_aem_reference
						else
							atts['subj'] = @AS_aem_reference
						end
					elsif code == 'corecrel'
						# this next bit is a bit tricky: 
						# - While it should be possible to pack the target reference as a subject attribute, when the target is of typeInsertionLoc, CocoaScripting stupidly tries to coerce it to typeObjectSpecifier, which causes a coercion error.
						# - While it should be possible to pack the target reference as the 'at' parameter, some less-well-designed applications won't accept this and require it to be supplied as a subject attribute (i.e. how AppleScript supplies it).
						# One option is to follow the AppleScript approach and force users to always supply subject attributes as target references and 'at' parameters as 'at' parameters, but the syntax for the latter is clumsy and not backwards-compatible with a lot of existing appscript code (since earlier versions allowed the 'at' parameter to be given as the target reference). So for now we split the difference when deciding what to do with a target reference: if it's an insertion location then pack it as the 'at' parameter (where possible), otherwise pack it as the subject attribute (and if the application doesn't like that then it's up to the client to pack it as an 'at' parameter themselves).
						#
						# if ref.make(...) contains no 'at' argument and target is an insertion reference, use target reference for 'at' parameter...
						if @AS_aem_reference.is_a?(AEMReference::InsertionSpecifier) and not params.has_key?('insh')
							params['insh'] = @AS_aem_reference
						else # ...otherwise pack the target reference as the subject attribute
							atts['subj'] = @AS_aem_reference
						end
					elsif params.has_key?('----')
						# if user has already supplied a direct parameter, pack that reference as the subject attribute
						atts['subj'] = @AS_aem_reference
					else
						# pack that reference as the direct parameter
						params['----'] = @AS_aem_reference
					end
				end
#			rescue => e
#				raise Appscript::CommandError.new(self, name, args, e)
#			end
			# build and send the Apple event, returning its result, if any
			begin
				# puts 'SENDING EVENT: ' + [code, params, atts, timeout, send_flags].inspect
				return @AS_app_data.target.event(code, params, atts, 
						KAE::KAutoGenerateReturnID, @AS_app_data).send(timeout, send_flags)
			rescue => e
				if e.is_a?(AEM::CommandError)
					if [-600, -609].include?(e.number) and @AS_app_data.path
						if not AEM::Application.is_running?(@AS_app_data.path)
							if code == 'ascrnoop'
								AEM::Application.launch(@AS_app_data.path)
							elsif code != 'aevtoapp'
								raise CommandError.new(self, name, args, e)
							end
						end
						@AS_app_data.target.reconnect
						begin
							return @AS_app_data.target.event(code, params, atts, 
									KAE::KAutoGenerateReturnID, @AS_app_data).send(timeout, send_flags)
						rescue
						end
					elsif e.number == -1708 and code == 'ascrnoop'
						return
					end
				end
				raise CommandError.new(self, name, args, e)
			end
		end
		
		
		#######
		# introspection
	
		def respond_to?(name)
			if super 
				return true
			else
				return @AS_app_data.reference_by_name.has_key?(name.is_a?(String) ? name.intern : name)
			end
		end
		
		def methods
			return super + @AS_app_data.reference_by_name.keys.collect { |name| name.to_s }
		end
		
		def commands
			return (@AS_app_data.reference_by_name.collect { |name, info| info[0] == :command ? name.to_s : nil }).compact.sort
		end
		
		def parameters(command_name)
			if not @AS_app_data.reference_by_name.has_key?(command_name.intern)
				raise ArgumentError, "Command not found: #{command_name}"
			end
			return (@AS_app_data.reference_by_name[command_name.intern][1][1].keys.collect { |name| name.to_s }).sort
		end
		
		def properties
			return (@AS_app_data.reference_by_name.collect { |name, info| info[0] == :property ? name.to_s : nil }).compact.sort
		end
		
		def elements
			return (@AS_app_data.reference_by_name.collect { |name, info| info[0] == :element ? name.to_s : nil }).compact.sort
		end
		
		def keywords
			return (@AS_app_data.type_by_name.collect { |name, code| name.to_s }).sort
		end

		#######
		# standard object methods
		
		def ==(val)
			return (self.class == val.class and @AS_app_data.target == val.AS_app_data.target \
					and @AS_aem_reference == val.AS_aem_reference)
		end
		
		alias_method :eql?, :== 
		
		def hash
			if not defined? @_hash
				@_hash = [@AS_app_data.target, @AS_aem_reference].hash
			end
			return @_hash
		end
		
		def to_s
			if not defined? @_to_s
				@_to_s = ReferenceRenderer.render(@AS_app_data, @AS_aem_reference)
			end
			return @_to_s
		end
		
		alias_method :inspect, :to_s
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		def method_missing(name, *args)
			selector_type, code = @AS_app_data.reference_by_name[name]
			case selector_type
				when :property
					return Reference.new(@AS_app_data, @AS_aem_reference.property(code))
				when :element
					return Reference.new(@AS_app_data, @AS_aem_reference.elements(code))
				when :command
					return _send_command(args, name, code[0], code[1])
			else
				msg = "Unknown property, element or command: '#{name}'"
				if @AS_app_data.reference_by_name.has_key?("#{name}_".intern)
					msg += " (Did you mean '#{name}_'?)"
				end
				raise RuntimeError, msg
			end
		end
		
		def [](selector, end_range_selector=nil)
			if end_range_selector != nil
				new_ref = @AS_aem_reference.by_range(
						self._resolve_range_boundary(selector, 1),
						self._resolve_range_boundary(end_range_selector, -1))
			elsif selector.is_a?(String)
				 new_ref = @AS_aem_reference.by_name(selector)
			elsif selector.is_a?(Appscript::GenericReference)
				new_ref = @AS_aem_reference.by_filter(
						selector.AS_resolve(@AS_app_data).AS_aem_reference)
			else
				new_ref = @AS_aem_reference.by_index(selector)
			end
			return Reference.new(@AS_app_data, new_ref)
		end
		
		def first
			return Reference.new(@AS_app_data, @AS_aem_reference.first)
		end
		
		def middle
			return Reference.new(@AS_app_data, @AS_aem_reference.middle)
		end
		
		def last
			return Reference.new(@AS_app_data, @AS_aem_reference.last)
		end
		
		def any
			return Reference.new(@AS_app_data, @AS_aem_reference.any)
		end
		
		def start
			return Reference.new(@AS_app_data, @AS_aem_reference.start)
		end
		
		def end
			return Reference.new(@AS_app_data, @AS_aem_reference.end)
		end
		
		def before
			return Reference.new(@AS_app_data, @AS_aem_reference.before)
		end
		
		def after
			return Reference.new(@AS_app_data, @AS_aem_reference.after)
		end
		
		def previous(klass)
			return Reference.new(@AS_app_data, @AS_aem_reference.previous(
					@AS_app_data.type_by_name.fetch(klass).code))
		end
		
		def next(klass)
			return Reference.new(@AS_app_data, @AS_aem_reference.next(
					@AS_app_data.type_by_name.fetch(klass).code))
		end
		
		def ID(id)
			return Reference.new(@AS_app_data, @AS_aem_reference.by_id(id))
		end
		
		# Following methods will be called by its-based generic references
		# Note that rb-appscript's comparison 'operator' names are gt/ge/eq/ne/lt/le, not >/>=/==/!=/</<= as in py-appscript. Unlike Python, Ruby's != operator isn't overridable, and a mixture of styles would be confusing to users. On the plus side, it does mean that rb-appscript's generic refs can be compared for equality.
		
		def gt(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.gt(operand))
		end
		
		def ge(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.ge(operand))
		end
		
		def eq(operand) # avoid colliding with comparison operators, which are normally used to compare two references
			return Reference.new(@AS_app_data, @AS_aem_reference.eq(operand))
		end
		
		def ne(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.ne(operand))
		end
		
		def lt(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.lt(operand))
		end
		
		def le(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.le(operand))
		end
		
		def starts_with(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.starts_with(operand))
		end
		
		def ends_with(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.ends_with(operand))
		end
		
		def contains(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.contains(operand))
		end
		
		def is_in(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.is_in(operand))
		end
		
		def does_not_start_with(operand)
			return self.starts_with(operand).not
		end
		
		def does_not_end_with(operand)
			return self.ends_with(operand).not
		end
		
		def does_not_contain(operand)
			return self.contains(operand).not
		end
		
		def is_not_in(operand)
			return self.is_in(operand).not
		end
		
		def and(*operands)
			return Reference.new(@AS_app_data, @AS_aem_reference.and(*operands))
		end
			
		def or(*operands)
			return Reference.new(@AS_app_data, @AS_aem_reference.or(*operands))
		end
		
		def not
			return Reference.new(@AS_app_data, @AS_aem_reference.not)
		end
	end
		
	
	######################################################################
	# APPLICATION
	######################################################################
	
	class Application < Reference
		
		private_class_method :new
			
		def _aem_application_class # hook
			return AEM::Application
		end
		
		def initialize(path, pid, url, terms)
			super(AppData.new(_aem_application_class, path, pid, url, terms), AEM.app)
		end
		
		# constructors
		
		def Application.by_name(name, terms=true)
			return new(FindApp.by_name(name), nil, nil, terms)
		end
		
		def Application.by_id(id, terms=true)
			return new(FindApp.by_id(id), nil, nil, terms)
		end
		
		def Application.by_creator(creator, terms=true)
			return new(FindApp.by_creator(creator), nil, nil, terms)
		end
		
		def Application.by_pid(pid, terms=true)
			return new(nil, pid, nil, terms)
		end
		
		def Application.by_url(url, terms=true)
			return new(nil, nil, url, terms)
		end
		
		def Application.current(terms=true)
			return new(nil, nil, nil, terms)
		end
		
		#
		
		def start_transaction(session=nil)
			@AS_app_data.target.start_transaction(session)
		end
		
		def abort_transaction
			@AS_app_data.target.abort_transaction
		end
		
		def end_transaction
			@AS_app_data.target.end_transaction
		end
		
		def launch
			if @AS_app_data.path
				AEM::Application.launch(@AS_app_data.path)
				@AS_app_data.target.reconnect
			else
				@AS_app_data.target.event('ascrnoop').send # will send launch event to app if already running; else will error
			end
		end
	end
	
	##
	
	class GenericApplication < GenericReference
		
		def initialize(app_class)
			@_app_class = app_class
			super(['app'])
		end
		
		def by_name(name, terms=true)
			return @_app_class.by_name(name, terms)
		end
		
		def by_id(id, terms=true)
			return @_app_class.by_id(id, terms)
		end
		
		def by_creator(creator, terms=true)
			return @_app_class.by_creator(creator, terms)
		end
		
		def by_pid(pid, terms=true)
			return @_app_class.by_pid(pid, terms)
		end
		
		def by_url(url, terms=true)
			return @_app_class.by_url(url, terms)
		end
		
		def current(terms=true)
			return @_app_class.current(terms)
		end
	end
	
	#######
	
	AS_App = Appscript::GenericApplication.new(Application)
	AS_Con = Appscript::GenericReference.new(['con'])
	AS_Its = Appscript::GenericReference.new(['its'])
	
	
	######################################################################
	# REFERENCE ROOTS
	######################################################################
	# public (note: Application & GenericApplication classes may also be accessed if subclassing Application class is required)
	
	def Appscript.app(*args)
		if args == []
			return AS_App
		else
			return AS_App.by_name(*args)
		end
	end

	def Appscript.con
		return AS_Con
	end
	
	def Appscript.its
		return AS_Its
	end
	
	# also define app, con, its as instance methods so that clients can 'include Appscript'
	
	def app(*args)
		if args == []
			return AS_App
		else
			return AS_App.by_name(*args)
		end
	end

	def con
		return AS_Con
	end
	
	def its
		return AS_Its
	end
	
	
	######################################################################
	# COMMAND ERROR
	######################################################################
	# public
	
	class CommandError < RuntimeError
		
		attr_reader :reference, :name, :parameters, :real_error
		
		def initialize(reference, command_name, parameters, real_error)
			@reference, @command_name, @parameters, @real_error = reference, command_name, parameters, real_error
			super()
		end
		
		def to_i
			if @real_error.is_a?(AE::MacOSError) or @real_error.is_a?(AEM::CommandError)
				return @real_error.to_i
			else
				return -2700
			end
		end
		
		def to_s
			return "#{@real_error}\n\t\tCOMMAND: #{@reference}.#{@command_name}(#{(@parameters.collect { |item| item.inspect }).join(', ')})\n"
		end
	end
	
	
	ApplicationNotFoundError = FindApp::ApplicationNotFoundError
end

AS = Appscript # backwards compatibility # TO DO: remove in 0.3.0
