#
# rb-appscript
#
# appscript -- syntactically sugared wrapper around the mid-level aem API;
#    provides a high-level, easy-to-use API for creating and sending Apple events
#

require "_aem/mactypes"

module Appscript

	Version = '0.5.3'

	# The following methods and classes are of interest to end users:
	# app, con, its, CommandError, ApplicationNotFoundError, CantLaunchApplicationError
	# Other classes are only of interest to implementors who need to hook in their own code.
	
	require "kae"
	require "aem"
	require "_aem/aemreference"
	require "_appscript/referencerenderer"
	require "_appscript/terminology"
	require "_appscript/safeobject"
	
	######################################################################
	# APPDATA
	######################################################################
	
	module AppDataAccessors
		attr_reader :target, :type_by_name, :type_by_code, :reference_by_name, :reference_by_code
	end
	
	class AppData < AEM::Codecs
	
		ASDictionaryBundleID = 'net.sourceforge.appscript.asdictionary'
	
		attr_reader :constructor, :identifier, :reference_codecs
		attr_writer :reference_codecs
	
		def initialize(aem_application_class, constructor, identifier, terms)
			super()
			@_aem_application_class = aem_application_class # AEM::Application class or subclass to use when constructing target
			@_terms = terms # user-supplied terminology tables/true/false
			@constructor = constructor # name of AEM::Application constructor to use/:by_aem_app
			@identifier = identifier # argument for AEM::Application constructor
			@reference_codecs = AEM::Codecs.new # low-level Codecs object used to unpack references; used by AppData#unpack_object_specifier, AppData#unpack_insertion_loc. Note: this is a bit kludgy, and it's be better to use AppData for all unpacking, but it should be 'good enough' in practice.
			@_help_agent = nil
		end
		
		def connect # initialize AEM::Application instance and terminology tables the first time they are needed
			case @constructor
				when :by_aem_app
					@target = @identifier
				when :current
					@target = @_aem_application_class.current
			else
				@target = @_aem_application_class.send(@constructor, @identifier)
			end
			case @_terms
				when true # obtain terminology from application
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = Terminology.tables_for_app(@target)
				when false # use built-in terminology only (e.g. use this when running AppleScript applets)
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = Terminology.default_tables
				when nil # [developer-only] make Application#methods return names of built-in methods only (needed to generate reservedkeywords.rb file)
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = {}, {}, {}, {}
				when Array # ready-to-use terminology tables
					@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = @_terms
			else # @_terms is [assumed to be] a module containing dumped terminology, so use that
				@type_by_code, @type_by_name, @reference_by_code, @reference_by_name = Terminology.tables_for_module(@_terms)
			end
			extend(AppDataAccessors)
		end
		
		#######
		
		def dont_cache_unpacked_specifiers
			@reference_codecs.dont_cache_unpacked_specifiers
		end
		
		#######
		
		Constructors = {
			:by_path => 'path',
			:by_pid => 'pid',
			:by_url => 'url',
			:by_aem_app => 'aemapp',
			:current => 'current',
		}
		
		def _init_help_agent
			begin
				apppath = FindApp.by_id(ASDictionaryBundleID)
				asdictionary_is_running = AEM::Application.process_exists_for_path?(apppath)
				@_help_agent = AEM::Application.by_path(apppath)
				if not asdictionary_is_running # hide ASDictionary after launching it
					AEM::Application.by_path(FindApp.by_id('com.apple.systemevents')).event('coresetd', {
							'----' => AEM.app.elements('prcs').by_name('ASDictionary').property('pvis'), 
							'data' => false}).send
				end
				return true
			rescue FindApp::ApplicationNotFoundError => e
				$stderr.puts("No help available: ASDictionary application not found (#{e}).")
			rescue AEM::CantLaunchApplicationError => e
				$stderr.puts("No help available: can't launch ASDictionary application (#{e}).")
			end
			return false
		end
		
		def _display_help(flags, ref)
			begin
				$stderr.puts(@_help_agent.event('AppSHelp', {
						'Cons' => Constructors[@constructor],
						'Iden' => @identifier,
						'Styl' => 'rb-appscript',
						'Flag' => flags,
						'aRef' => pack(ref),
					}).send)
				return nil
			rescue AEM::EventError => e
				return e
			end
		end
		
		def help(flags, ref)
			begin
				if not @_help_agent
					return ref if not _init_help_agent
				end
				e = _display_help(flags, ref)
				if e and [-600, -609].include?(e.number) # not running
					return ref if not _init_help_agent
					e = _display_help(flags, ref)
				end
				$stderr.puts("No help available: ASDictionary raised an error: #{e}.") if e
			rescue => err
				$stderr.puts("No help available: unknown error: #{err}")
			end
			return ref
		end
		
		#######
		
		def target
			connect
			return @target
		end
		
		def type_by_name
			connect
			return @type_by_name
		end
		
		def type_by_code
			connect
			return @type_by_code
		end
		
		def reference_by_name
			connect
			return @reference_by_name
		end
		
		def reference_by_code
			connect
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
		
		ClassType = AEM::AEType.new(KAE::PClass)
		
		def pack_hash(val)
			record = AE::AEDesc.new_list(true)
			if val.has_key?(:class_) or val.has_key?(ClassType)
				# if hash contains a 'class' property containing a class name, coerce the AEDesc to that class
				new_val = Hash[val]
				if new_val.has_key?(:class_)
					val2 = new_val.delete(:class_)
				else
					val2 = new_val.delete(ClassType)
				end
				if val2.is_a?(Symbol) # get the corresponding AEType (assuming there is one)
					val2 = @type_by_name.fetch(val2, val2)
				end
				if val2.is_a?(AEM::AEType) # coerce the record to the desired type
					record = record.coerce(val2.code)
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
				record.put_param(KAE::KeyASUserRecordFields, usrf)
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
				if key == KAE::KeyASUserRecordFields
					lst = unpack_aelist(value)
					(lst.length / 2).times do |j|
						dct[lst[j * 2]] = lst[j * 2 + 1]
					end
				else
					dct[@type_by_code.fetch(key) { AEM::AEType.new(key) }] = unpack(value)
				end
			end
			return dct
		end
		
		def unpack_object_specifier(desc)
			return Reference.new(self, @reference_codecs.unpack(desc))
		end
		
		def unpack_insertion_loc(desc)
			return Reference.new(self, @reference_codecs.unpack(desc))
		end
				
		def unpack_contains_comp_descriptor(op1, op2)
			if op1.is_a?(Appscript::Reference) and op1.AS_aem_reference.AEM_root == AEMReference::Its
				return op1.contains(op2)
			else
				return super
			end
		end
		
		def unpack_unknown(desc)
			return case desc.type
				when KAE::TypeApplicationBundleID
					Appscript.app.by_id(desc.data)
				when KAE::TypeApplicationURL
					if desc.data[0, 4] == 'file' # workaround for converting AEAddressDescs containing file:// URLs to application paths, since AEAddressDescs containing file URLs don't seem to work correctly
						Appscript.app(MacTypes::FileURL.url(desc.data).path)
					else # presumably contains an eppc:// URL
						Appscript.app.by_url(desc.data)
					end
				when KAE::TypeApplSignature
					Appscript.app.by_creator(AEM::Codecs.four_char_code(desc.data))
				when KAE::TypeKernelProcessID
					Appscript.app.by_pid(desc.data.unpack('L')[0])
				when KAE::TypeMachPort, KAE::TypeProcessSerialNumber
					Appscript.app.by_aem_app(AEM::Application.by_desc(desc))
			else
				super
			end
		end
	end
	
	
	######################################################################
	# GENERIC REFERENCE
	######################################################################
	
	class GenericReference < AS_SafeObject
	
		attr_reader :_call
		protected :_call
		
		def initialize(call)
			super()
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
			return Appscript::GenericReference.new(@_call + [[name, args]])
		end
	
		def to_s
			s= @_call[0]
			@_call[1, @_call.length].each do |name, args|
				if name == :[]
					if args.length == 1
						s += "[#{args[0].inspect}]"
					else
						s += "[#{args[0].inspect}, #{args[1].inspect}]"
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
	
	class Reference < AS_SafeObject
	
		# users may occasionally require access to the following for creating workarounds to problem apps
		# note: calling #AS_app_data on a newly created application object will return an AppData instance
		# that is not yet fully initialised, so remember to call its #connect method before use
		attr_reader :AS_aem_reference, :AS_app_data
		attr_writer :AS_aem_reference, :AS_app_data
	
		def initialize(app_data, aem_reference)
			super()
			@AS_app_data = app_data
			@AS_aem_reference = aem_reference
		end
		
		def _resolve_range_boundary(selector)
			if selector.is_a?(Appscript::GenericReference)
				return selector.AS_resolve(@AS_app_data).AS_aem_reference
			elsif selector.is_a?(Reference)
				return selector.AS_aem_reference
			else
				return selector
			end
		end
		
		#######
		
		def help(flags='-t')
			return @AS_app_data.help(flags, self)
		end
		
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
		
		DefaultConsiderations =  AEM::DefaultCodecs.pack([AEM::AEEnum.new(KAE::KAECase)])
		DefaultConsidersAndIgnores = _pack_uint32(KAE::KAECaseIgnoreMask)
		
		##
		
		def _send_command(args, name, code, labelled_arg_terms)
			atts = {KAE::KeySubjectAttr => nil}
			params = {}
			case args.length
				when 0
					keyword_args = {}
				when 1 # note: if a command takes a hash as its direct parameter, user must pass {} as a second arg otherwise hash will be assumed to be keyword parameters
					if args[0].is_a?(Hash)
						keyword_args = args[0]
					else
						params[KAE::KeyDirectObject] = args[0]
						keyword_args = {}
					end
				when 2
					params[KAE::KeyDirectObject], keyword_args = args
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
				atts[KAE::EnumConsiderations] = DefaultConsiderations
				atts[KAE::EnumConsidsAndIgnores] = DefaultConsidersAndIgnores
			else
				atts[KAE::EnumConsiderations] = ignore_options
				csig = 0
				IgnoreEnums.each do |option, consider_mask, ignore_mask|
					csig += ignore_options.include?(option) ? ignore_mask : consider_mask
				end
				atts[KAE::EnumConsidsAndIgnores] = Reference._pack_uint32(csig)
			end
			# optionally specify return value type
			if keyword_args.has_key?(:result_type)
				params[KAE::KeyAERequestedType] = keyword_args.delete(:result_type)
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
					if params.has_key?(KAE::KeyDirectObject) and not params.has_key?(KAE::KeyAEData)
						params[KAE::KeyAEData] = params[KAE::KeyDirectObject]
						params[KAE::KeyDirectObject] = @AS_aem_reference
					elsif not params.has_key?(KAE::KeyDirectObject)
						params[KAE::KeyDirectObject] = @AS_aem_reference
					else
						atts[KAE::KeySubjectAttr] = @AS_aem_reference
					end
				elsif code == 'corecrel'
					# this next bit is a bit tricky: 
					# - While it should be possible to pack the target reference as a subject attribute, when the target is of typeInsertionLoc, CocoaScripting stupidly tries to coerce it to typeObjectSpecifier, which causes a coercion error.
					# - While it should be possible to pack the target reference as the 'at' parameter, some less-well-designed applications won't accept this and require it to be supplied as a subject attribute (i.e. how AppleScript supplies it).
					# One option is to follow the AppleScript approach and force users to always supply subject attributes as target references and 'at' parameters as 'at' parameters, but the syntax for the latter is clumsy and not backwards-compatible with a lot of existing appscript code (since earlier versions allowed the 'at' parameter to be given as the target reference). So for now we split the difference when deciding what to do with a target reference: if it's an insertion location then pack it as the 'at' parameter (where possible), otherwise pack it as the subject attribute (and if the application doesn't like that then it's up to the client to pack it as an 'at' parameter themselves).
					#
					# if ref.make(...) contains no 'at' argument and target is an insertion reference, use target reference for 'at' parameter...
					if @AS_aem_reference.is_a?(AEMReference::InsertionSpecifier) \
							and not params.has_key?(KAE::KeyAEInsertHere)
						params[KAE::KeyAEInsertHere] = @AS_aem_reference
					else # ...otherwise pack the target reference as the subject attribute
						atts[KAE::KeySubjectAttr] = @AS_aem_reference
					end
				elsif params.has_key?(KAE::KeyDirectObject)
					# if user has already supplied a direct parameter, pack that reference as the subject attribute
					atts[KAE::KeySubjectAttr] = @AS_aem_reference
				else
					# pack that reference as the direct parameter
					params[KAE::KeyDirectObject] = @AS_aem_reference
				end
			end
			# build and send the Apple event, returning its result, if any
			begin
				return @AS_app_data.target.event(code, params, atts, 
						KAE::KAutoGenerateReturnID, @AS_app_data).send(timeout, send_flags)
			rescue AEM::EventError => e
				if e.number == -1708 and code == 'ascrnoop'
					return # 'launch' events always return 'not handled' errors; just ignore these
				elsif [-600, -609].include?(e.number) and @AS_app_data.constructor == :by_path 
					#
					# Event was sent to a local app for which we no longer have a valid address
					# (i.e. the application has quit since this AEM::Application object was made).
					#
					# - If application is running under a new process id, we just update the 
					#   AEM::Application object and resend the event.
					#
					# - If application isn't running, then we see if the event being sent is one of 
					#   those allowed to relaunch the application (i.e. 'run' or 'launch'). If it is, the
					#   application is relaunched, the process id updated and the event resent;
					#   if not, the error is rethrown.
					#
					if not AEM::Application.process_exists_for_path?(@AS_app_data.identifier)
						if code == 'ascrnoop'
							AEM::Application.launch(@AS_app_data.identifier)
						elsif code != 'aevtoapp'
							raise CommandError.new(self, name, args, e, @AS_app_data)
						end
					end
					# update AEMApplication object's AEAddressDesc
					@AS_app_data.target.reconnect
					# re-send command
					begin
						return @AS_app_data.target.event(code, params, atts, 
								KAE::KAutoGenerateReturnID, @AS_app_data).send(timeout, send_flags)
					rescue AEM::EventError => e
						raise CommandError.new(self, name, args, e, @AS_app_data)
					end
				end
			end
			raise CommandError.new(self, name, args, e, @AS_app_data)
		end
		
		
		#######
		# introspection
	
		def respond_to?(name, includePriv=false)
			if Object.respond_to?(name)
				return true
			else
				return @AS_app_data.reference_by_name.has_key?(name.is_a?(String) ? name.intern : name)
			end
		end
		
		def methods
			return (Object.instance_methods + @AS_app_data.reference_by_name.keys.collect { |name| name.to_s }).uniq
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
		# Utility methods
		
		def is_running?
			identifier = @AS_app_data.identifier
			case @AS_app_data.constructor
				when :by_path
					return AEM::Application.process_exists_for_path?(identifier)
				when :by_pid
					return AEM::Application.process_exists_for_pid?(identifier)
				when :by_url
					return AEM::Application.process_exists_for_url?(identifier)
				when :by_aem_app
					return AEM::Application.process_exists_for_desc?(identifier.address_desc)
			else # when :current
				return true
			end
		end
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		def method_missing(name, *args)
			selector_type, code = @AS_app_data.reference_by_name[name]
			case selector_type # check if name is a property/element/command name, and if it is handle accordingly
				when :property
					raise ArgumentError, "wrong number of arguments for '#{name}' property (1 for 0)" if args != []
					return Reference.new(@AS_app_data, @AS_aem_reference.property(code))
				when :element
					raise ArgumentError, "wrong number of arguments for '#{name}' elements (1 for 0)" if args != []
					return Reference.new(@AS_app_data, @AS_aem_reference.elements(code))
				when :command
					return _send_command(args, name, code[0], code[1])
			else 
				# see if it's a method that has been added to Object class [presumably] at runtime, but excluded
				# by AS_SafeObject to avoid potential conflicts with property/element/command names
				begin
					# Notes:
					# rb-appscript has to prevent arbitrary methods that are added to Ruby's base Object class
					# by client code from automatically appearing in Appscript::Reference as well, as these new
					# methods may inadvertently mask property/element/command names, causing appscript to
					# behave incorrectly. However, once it is confirmed that a given method will not mask an existing 
					# property/element/command name, it can be added retrospectively to the Reference instance
					# upon which it was called, which is what happens here.
					# 
					# This means that methods such as #pretty_print and #pretty_inspect, which are
					# injected into Object when the 'pp' module is loaded, will still be available in appscript
					# references, even though they are not on AS_SafeObject's official list of permitted methods,
					# *as long as* properties/elements/commands of the same name do not already exist for that
					# reference. 
					#
					# Where properties/elements/commands of the same name do already exist, appscript
					# will still defer to those, of course, and this may cause problems for the caller if
					# they were wanting the other behaviour. (But, that's the risk one runs with any sort
					# of subclassing exercise when the contents of the superclass are not known for certain
					# beforehand.) Clients that require access to these methods will need to add their names
					# to the ReservedKeywords list (see _appscript/reservedkeywords.rb) at runtime, thereby
					# forcing appscript to append underscores to the conflicting property/element/command
					# names in order to disambiguate them, and modifying any code that refers to those
					# properties/elements/commands accordingly.
					meth = Object.instance_method(name)
				rescue NameError # message not handled
					msg = "Unknown property, element or command: '#{name}'"
					if @AS_app_data.reference_by_name.has_key?("#{name}_".intern)
						msg += " (Did you mean '#{name}_'?)"
					end
					raise RuntimeError, msg
				end
				return meth.bind(self).call(*args)
			end
		end
		
		def [](selector, end_range_selector=nil)
			raise TypeError, "Bad selector: nil not allowed." if selector == nil
			if end_range_selector != nil
				new_ref = @AS_aem_reference.by_range(
						self._resolve_range_boundary(selector),
						self._resolve_range_boundary(end_range_selector))
			else
				case selector
					when String
						 new_ref = @AS_aem_reference.by_name(selector)
					when Appscript::GenericReference, Appscript::Reference, AEMReference::Test
						case selector
							when Appscript::GenericReference
								test_clause = selector.AS_resolve(@AS_app_data)
								begin
									test_clause = test_clause.AS_aem_reference
								rescue NoMethodError
									raise ArgumentError, "Not a valid its-based test: #{selector}"
								end
							when Appscript::Reference
								test_clause = selector.AS_aem_reference
						else
							test_clause = selector	
						end
						if not test_clause.is_a?(AEMReference::Test)
							raise TypeError, "Not an its-based test: #{selector}"
						end
						new_ref = @AS_aem_reference.by_filter(test_clause)
				else
					new_ref = @AS_aem_reference.by_index(selector)
				end
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
		
		def beginning
			return Reference.new(@AS_app_data, @AS_aem_reference.beginning)
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
		
		def begins_with(operand)
			return Reference.new(@AS_app_data, @AS_aem_reference.begins_with(operand))
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
		
		def does_not_begin_with(operand)
			return self.begins_with(operand).not
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
		
		def initialize(constructor, identifier, terms)
			super(AppData.new(_aem_application_class, constructor, identifier, terms), AEM.app)
		end
		
		# constructors
		
		def Application.by_name(name, terms=true)
			return new(:by_path, FindApp.by_name(name), terms)
		end
		
		def Application.by_id(id, terms=true)
			return new(:by_path, FindApp.by_id(id), terms)
		end
		
		def Application.by_creator(creator, terms=true)
			return new(:by_path, FindApp.by_creator(creator), terms)
		end
		
		def Application.by_pid(pid, terms=true)
			return new(:by_pid, pid, terms)
		end
		
		def Application.by_url(url, terms=true)
			return new(:by_url, url, terms)
		end
		
		def Application.by_aem_app(aem_app, terms=true)
			return new(:by_aem_app, aem_app, terms)
		end
		
		def Application.current(terms=true)
			return new(:current, nil, terms)
		end
		
		#
		
		def AS_new_reference(ref)
			if ref.is_a?(Appscript::GenericReference)
				return ref.AS_resolve(@AS_app_data)
			elsif ref.is_a?(AEMReference::Query)
				return Reference.new(@AS_app_data, ref)
			elsif ref == nil
				return  Reference.new(@AS_app_data, AEM.app)
			else
				return Reference.new(@AS_app_data, AEM.custom_root(ref))
			end
		end
		
		def begin_transaction(session=nil)
			@AS_app_data.target.begin_transaction(session)
		end
		
		def abort_transaction
			@AS_app_data.target.abort_transaction
		end
		
		def end_transaction
			@AS_app_data.target.end_transaction
		end
		
		def launch
			if @AS_app_data.constructor == :by_path
				AEM::Application.launch(@AS_app_data.identifier)
				@AS_app_data.target.reconnect
			else
				begin
					@AS_app_data.target.event('ascrnoop').send # will send launch event to app if already running; else will error
				rescue AEM::EventError => e
					raise if e.to_i != -1708
				end
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
		
		def by_aem_app(aem_app, terms=true)
			return @_app_class.by_aem_app(aem_app, terms)
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
		
		def initialize(reference, command_name, parameters, real_error, codecs)
			@reference, @command_name, @parameters = reference, command_name, parameters
			@real_error, @codecs = real_error, codecs
			super()
		end
		
		def to_s
			if @real_error.is_a?(AEM::EventError)
				err = "CommandError\n\t\tOSERROR: #{error_number}"
				err += "\n\t\tMESSAGE: #{error_message}" if error_message != ''
				[
					["\n\t\tOFFENDING OBJECT", KAE::KOSAErrorOffendingObject],
					["\n\t\tEXPECTED TYPE", KAE::KOSAErrorExpectedType],
					["\n\t\tPARTIAL RESULT", KAE::KOSAErrorPartialResult],
				].each do |label, key|
					desc = @real_error.raw[key]
					err += "#{label}: #{@codecs.unpack(desc).inspect}" if desc
				end
			else
				err = @real_error
			end
			return "#{err}\n\t\tCOMMAND: #{@reference}.#{@command_name}(#{(@parameters.collect { |item| item.inspect }).join(', ')})\n"
		end
		
		def error_number
			if @real_error.is_a?(AE::MacOSError) or @real_error.is_a?(AEM::EventError)
				return @real_error.to_i
			else
				return -2700
			end
		end
		
		alias_method :to_i, :error_number
		
		def error_message
			return @real_error.message
		end
		
		def offending_object
			return nil if not @real_error.is_a?(AEM::EventError)
			desc = @real_error.raw[KAE::KOSAErrorOffendingObject]
			return desc ? @codecs.unpack(desc) : nil
		end
		
		def expected_type
			return nil if not @real_error.is_a?(AEM::EventError)
			desc = @real_error.raw[KAE::KOSAErrorExpectedType]
			return desc ? @codecs.unpack(desc) : nil
		end
		
		def partial_result
			return nil if not @real_error.is_a?(AEM::EventError)
			desc = @real_error.raw[KAE::KOSAErrorPartialResult]
			return desc ? @codecs.unpack(desc) : nil
		end
	end
	
	ApplicationNotFoundError = FindApp::ApplicationNotFoundError
	CantLaunchApplicationError = Connect::CantLaunchApplicationError
end
