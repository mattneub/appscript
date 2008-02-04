#!/usr/bin/ruby

# TO DO: RubyCocoa performs lossy conversion of Symbols to NSCFStrings; 
# this is a problem when packing arrays/dictionaries of symbols, as they won't pack as correct AE type
# may be best to use bound 'k' namespace instead, which is also more reliable in embedded use


module RCAppscript

	require 'osx/cocoa'
	include OSX
	OSX.require_framework 'Appscript'
	require "cocoa_appscript/terminology"
	require "cocoa_appscript/safeobject"
	require "cocoa_appscript/referencerenderer"
	require "cocoa_appscript/kae"
	
	
	######################################################################
	# APPDATA
	######################################################################
	
	module RCAppDataAccessors
		attr_reader :target, :type_by_name, :type_by_code, :reference_by_name, :reference_by_code
	end
	
	class RCAppData < ASBridgeData
		
		def constructor # note: alias_method doesn't appear to work for ObjC methods
			targetType
		end
		
		def identifier
			targetData
		end
		
		# TO DO: reference codecs methods
		
		RCDefaultTerms = RCASTerminology.build_default_terms
		RCKeywordConverter = RCASTerminology::RCASKeywordConverter.new
	
		def initWithApplicationClass_constructor_identifier_terms_(aem_application_class, constructor, identifier, terms)
			if terms == true
				terms = RCAppscript::ASBoolean.True
			elsif terms == false
				terms = RCAppscript::ASBoolean.False
			end
			initWithApplicationClass_targetType_targetData_terminology_defaultTerms_keywordConverter_(
					aem_application_class, 
					constructor, 
					identifier,
					terms, 
					RCDefaultTerms, 
					RCKeywordConverter)
			return self
		end
		
		def connect
			@target, error = self.targetWithError_()
			raise RuntimeError, error.to_s if not @target
			@type_by_name = {}
			self.terminology.typeByNameTable.each do |name, code|
				@type_by_name[name.intern] = code
			end
			@type_by_code = {}
			self.terminology.typeByCodeTable.each do |name, code|
				@type_by_code[code] = name.to_s.intern
			end
			@reference_by_name = {}
			self.terminology.elementByNameTable.each do |name, code|
				@reference_by_name[name.intern] = [:element, code]
			end
			self.terminology.propertyByNameTable.each do |name, code|
				@reference_by_name[name.intern] = [:property, code]
			end
			self.terminology.commandByNameTable.each do |name, definition|
				@reference_by_name[name.intern] = [:command, definition]
			end
			@property_by_code = self.terminology.propertyByCodeTable
			@element_by_code = self.terminology.elementByCodeTable
			extend(RCAppDataAccessors)
		end
		
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
		
		def property_by_code
			connect
			return @property_by_code
		end
		
		def element_by_code
			connect
			return @element_by_code
		end
		
		#######
		
		TrueDesc = RCAppscript::ASBoolean.True.desc
		FalseDesc = RCAppscript::ASBoolean.False.desc
		
		def pack(data) 
			case data
				when RCGenericReference
					data = data.AS_resolve(self).AS_aem_reference
				when RCReference
					data = data.AS_aem_reference
				when RCKeyword
					data = data.AS_pack_self(self)
				when true
					return TrueDesc
				when false
					return FalseDesc
			end
			return super_pack(data)
		end
		
		##
		
		ClassType = RCAppscript::AEMType.typeWithCode_(RCKAE::PClass)
		
		
		# TO DO: finish pack, unpack support

	end

	
	######################################################################
	# KEYWORD
	######################################################################
	
	class RCKeyword
		
		def initialize(name)
			@name = name
		end
		
		def AS_pack_self(app_data)
			return app_data.type_by_name.fetch(@name) { |n| raise IndexError, "Keyword #{n} not found." }
		end
	end
	
	
	######################################################################
	# GENERIC REFERENCE
	######################################################################
	
	RCAEMApp = RCAppscript::AEMApplicationRoot.applicationRoot
	RCAEMCon = AEMCurrentContainerRoot.currentContainerRoot
	RCAEMIts = AEMObjectBeingExaminedRoot.objectBeingExaminedRoot
	
	
	class RCGenericReference < RCASSafeObject
	
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
			return RCAppscript::RCGenericReference.new(@_call + [[name, args]])
		end
	
		def to_s
			s= @_call[0]
			@_call[1, @_call.length].each do |name, args|					if name == :[]
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
			ref = RCReference.new(app_data, {
					'app' => RCAppscript::RCAEMApp, 
					'con' => RCAppscript::RCAEMCon, 
					'its' => RCAppscript::RCAEMIts,
					}[@_call[0]])
			@_call[1, @_call.length].each do |name, args|
				ref = ref.send(name, *args)
			end
			return ref
		end
	end
	
	######################################################################
	# REFERENCE
	######################################################################
	
	class RCNoArg
	end
	
	class RCReference < RCASSafeObject
		
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
			if selector.is_a?(RCAppscript::RCGenericReference)
				return selector.AS_resolve(@AS_app_data).AS_aem_reference
			elsif selector.is_a?(Reference)
				return selector.AS_aem_reference
			elsif selector.is_a?(String)
				return RCAppscript::RCAEMCon.elements(@AS_aem_reference.AEM_want).by_name(selector)
			else
				return RCAppscript::RCAEMCon.elements(@AS_aem_reference.AEM_want).by_index(selector)
			end
		end
		
		#######
		
		def help(flags='-t')
			return @AS_app_data.helpForFlags_reference_(flags, self) # TO DO
		end
		
		# TO DO: csig attributes
		
		##
		
		def _send_command(args, name, definition)
			# TO DO: set RCKAE::KeySubjectAttr to nil if not otherwise specified
			target, error = @AS_app_data.targetWithError_()
			raise RuntimeError, error.to_s if error
			eventClass, eventID = definition.eventClass, definition.eventID
			event = target.eventWithEventClass_eventID_codecs_(eventClass, eventID, @AS_app_data)
			direct_arg = RCAppscript::RCNoArg
			case args.length
				when 0
					keyword_args = {}
				when 1 # note: if a command takes a hash as its direct parameter, user must pass {} as a second arg otherwise hash will be assumed to be keyword parameters
					if args[0].is_a?(Hash)
						keyword_args = args[0]
					else
						direct_arg = args[0]
						keyword_args = {}
					end
				when 2
					direct_arg, keyword_args = args
			else
				raise ArgumentError, "Too many direct parameters."
			end
			if not keyword_args.is_a?(Hash)
				raise ArgumentError, "Second argument must be a Hash containing zero or more keyword parameters."
			end
			# get user-specified timeout, if any
			timeout = (keyword_args.delete(:timeout) {60}).to_i
			if timeout <= 0
				timeout = RCKAE::KNoTimeOut
			else
				timeout *= 60
			end
			# default send flags
			send_flags = RCKAE::KAECanSwitchLayer
			# ignore application's reply?
			send_flags += keyword_args.delete(:wait_reply) == false ? RCKAE::KAENoReply : RCKAE::KAEWaitReply
			# TO DO: add considering/ignoring attributes
			# optionally specify return value type
			if keyword_args.has_key?(:result_type)
				event.setParameter_forKeyword_(keyword_args.delete(:result_type), RCKAE::KeyAERequestedType)
			end
			# special cases
			if @AS_aem_reference != RCAppscript::AEMApplicationRoot
				if eventClass == 'core' and eventID == 'setd'
					if direct_arg != RCAppscript::RCNoArg and not keyword_args.has_key?(KAE::KeyAEData)
						keyword_args[KAE::KeyAEData] = direct_arg
						direct_arg = @AS_aem_reference
					elsif direct_arg != RCAppscript::RCNoArg
						event.setAttribute_forKeyword_(@AS_aem_reference, RCKAE::KeySubjectAttr)
					else
						direct_arg = @AS_aem_reference
					end
				elsif eventClass == 'core' and eventID == 'crel'
					if @AS_aem_reference.is_a?(AEMReference::InsertionSpecifier) \
							and not keyword_args.has_key?(KAE::KeyAEInsertHere)
						keyword_args[KAE::KeyAEInsertHere] = @AS_aem_reference
					else
						event.setAttribute_forKeyword_(@AS_aem_reference, RCKAE::KeySubjectAttr)
					end
				elsif direct_arg != RCAppscript::RCNoArg
					event.setAttribute_forKeyword_(@AS_aem_reference, RCKAE::KeySubjectAttr)
				else
					direct_arg = @AS_aem_reference
				end
			end
			# extract labelled parameters, if any
			keyword_args.each do |param_name, param_value|
				param_code = labelled_arg_terms.fetch(param_name) do |n|
					raise ArgumentError, "Unknown keyword parameter: #{n.inspect}"
				end
				event.setParameter_forKeyword_(param_value, param_code)
			end
			if direct_arg != RCAppscript::RCNoArg
				event.setParameter_forKeyword_(direct_arg, RCKAE::KeyDirectObject)
			end
			result, error = event.sendWithMode_timeout_error_(send_flags, timeout)
			# TO DO: error handling
			raise RuntimeError, error.to_s if error
			return result
		end
		
		
		#######
		# introspection
		
		# TO DO
		
		#######
		# standard object methods
		
		def ==(val)
			return (self.class == val.class \
					and @AS_app_data.target.isEqual_(val.AS_app_data.target) \
					and @AS_aem_reference.isEqual_(val.AS_aem_reference))
		end
		
		alias_method :eql?, :== 
		
		def hash
			if not defined? @_hash
				@_hash = 0 # [@AS_app_data.target, @AS_aem_reference].hash # TO DO
			end
			return @_hash
		end
		
		def to_s
			if not defined? @_to_s
				@_to_s = RCASReferenceRenderer.render(@AS_app_data, @AS_aem_reference)
			end
			return @_to_s
		end
		
		alias_method :inspect, :to_s
		
		#######
		# Utility methods
		
		def is_running?
			return true # TO DO
		end
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		def method_missing(name, *args)
			selector_type, code = @AS_app_data.reference_by_name[name]
			case selector_type # check if name is a property/element/command name, and if it is handle accordingly
				when :property
					return RCReference.new(@AS_app_data, @AS_aem_reference.property(code))
				when :element
					return RCReference.new(@AS_app_data, @AS_aem_reference.elements(code))
				when :command
					return _send_command(args, name, code)
			else 
				# see if it's a method that has been added to Object class [presumably] at runtime, but excluded
				# by RCASSafeObject to avoid potential conflicts with property/element/command names
				begin
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
			if end_range_selector != nil
				new_ref = @AS_aem_reference.byRange_to_(
						self._resolve_range_boundary(selector, 1),
						self._resolve_range_boundary(end_range_selector, -1))
			else
				case selector
					when String
						 new_ref = @AS_aem_reference.byName_(selector)
					when RCAppscript::RCGenericReference
						new_ref = @AS_aem_reference.byTest(
								selector.AS_resolve(@AS_app_data).AS_aem_reference)
					when RCAppscript::RCReference, RCAppscript::AEMTest
						new_ref = @AS_aem_reference.byTest(selector)
				else
					new_ref = @AS_aem_reference.byIndex(selector)
				end
			end
			return RCAppscript::RCReference.new(@AS_app_data, new_ref)
		end
		
		def first
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.first)
		end
		
		def middle
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.middle)
		end
		
		def last
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.last)
		end
		
		def any
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.any)
		end
		
		def beginning
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.beginning)
		end
		
		def end
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.end)
		end
		
		def before
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.before)
		end
		
		def after
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.after)
		end
		
		def previous(klass)
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.previous_(
					@AS_app_data.type_by_name.fetch(klass).typeCodeValue))
		end
		
		def next(klass)
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.next_(
					@AS_app_data.type_by_name.fetch(klass).typeCodeValue))
		end
		
		def ID(id)
			return RCAppscript::RCReference.new(@AS_app_data, @AS_aem_reference.byID_(id))
		end
		
		# TO DO: test methods
	end
	
	
	######################################################################
	# APPLICATION
	######################################################################
	
	class RCApplication < RCReference
		
		private_class_method :new
			
		def _aem_application_class # hook
			return RCAppscript::AEMApplication
		end
		
		def initialize(constructor, identifier, terms)
			super(RCAppData.alloc.initWithApplicationClass_constructor_identifier_terms_(
					_aem_application_class, constructor, identifier, terms), RCAEMApp)
		end
		
		# constructors
		
		def RCApplication.by_name(name, terms=true)
			return new(RCAppscript::KASTargetName, name, terms)
		end
		
		def RCApplication.by_id(id, terms=true)
			return new(RCAppscript::KASTargetBundleID, id, terms)
		end
		
		def RCApplication.by_creator(creator, terms=true)
			raise NotImplementedError
		end
		
		def RCApplication.by_pid(pid, terms=true)
			return new(RCAppscript::KASTargetPID, pid, terms)
		end
		
		def RCApplication.by_url(url, terms=true)
			return new(RCAppscript::KASTargetURL, url, terms)
		end
		
		def RCApplication.by_aem_app(aem_app, terms=true)
			raise NotImplementedError
		end
		
		def RCApplication.current(terms=true)
			return new(RCAppscript::KASTargetCurrent, nil, terms)
		end
		
		#
		
		def AS_new_reference(ref)
			if ref.is_a?(RCAppscript::RCGenericReference)
				return ref.AS_resolve(@AS_app_data)
			elsif ref.is_a?(RCAppscript::AEMQuery)
				return RCAppscript::RCReference.new(@AS_app_data, ref)
			elsif ref == nil
				return  RCAppscript::RCReference.new(@AS_app_data, AEM.app)
			else
				return RCAppscript::RCReference.new(@AS_app_data, AEM.custom_root(ref))
			end
		end
		
		def begin_transaction(session=nil)
			@AS_app_data.target.beginTransaction_(session)
		end
		
		def abort_transaction
			@AS_app_data.target.abortTransaction
		end
		
		def end_transaction
			@AS_app_data.target.endTransaction
		end
		
		def launch
			# TO DO
		end
	end
	
	##
	
	class RCGenericApplication < RCGenericReference
		
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
	
	AS_App = RCAppscript::RCGenericApplication.new(RCApplication)
	AS_Con = RCAppscript::RCGenericReference.new(['con'])
	AS_Its = RCAppscript::RCGenericReference.new(['its'])
	
	
	######################################################################
	# REFERENCE ROOTS
	######################################################################
	# public (note: Application & GenericApplication classes may also be accessed if subclassing Application class is required)
	
	def RCAppscript.app(*args)
		if args == []
			return AS_App
		else
			return AS_App.by_name(*args)
		end
	end

	def RCAppscript.con
		return AS_Con
	end
	
	def RCAppscript.its
		return AS_Its
	end
	
	# also define app, con, its as instance methods so that clients can 'include RCAppscript'
	
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
	
	# TO DO
	
end

