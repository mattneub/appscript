#!/usr/bin/ruby

module Appscript

	framework 'Appscript'
	require "_appscript/terminology"
	require "_appscript/safeobject"
	require "_appscript/referencerenderer"
	require "kae"
	
	
	######################################################################
	# KEYWORD
	######################################################################
	
	# RubyCocoa doesn't play well with Symbol objects, so use 'k' namespace instead
	
	class Keyword < NSObject # needs to support NSCopying protocol to be used as NSDictionary keys
		
		attr_reader :AS_name, :AS_aem_object
		
		def initWithName_aemObject_(name, obj)
			init
			@AS_name = name
			@AS_aem_object = obj
			return self
		end
		
		def copyWithZone(zone)
			return self.retain
		end
		
		def AS_pack_self(app_data)
			if @AS_aem_object 
				return @AS_aem_object.desc
			else
				return app_data.type_by_name.fetch(@AS_name) do |n| 
					raise IndexError, "Keyword #{n.is_a?(NSObject) ? n : n.inspect} not found."
				end
			end
		end
		
		def ==(v)
			return (self.class == v.class and @AS_name == v.AS_name)
		end
		
		alias_method :eql?, :== 
		
		def hash
			return @AS_name.hash
		end
		
		def description
			return "k.#{@AS_name}"
		end
		
		alias_method :to_s, :description
		alias_method :inspect, :description
	end

	
	class KeywordNamespace < ASSafeObject
		
		def method_missing(name)
			return Keyword.alloc.initWithName_aemObject_(name, nil)
		end
	end
	
	KN = KeywordNamespace.new
	
	def Appscript.k
		return Appscript::KN
	end
	
	def k
		return Appscript::KN
	end
	
	
	######################################################################
	# APPDATA
	######################################################################
	
	module AppDataAccessors
		attr_reader :target, :type_by_name, :type_by_code, :reference_by_name, :reference_by_code
	end
	
	class AppData < ASBridgeData
		
		# note: alias_method doesn't appear to work for ObjC methods
		
		def constructor
			return self.targetType
		end
		
		def identifier
			return self.targetData
		end
		
		##
		
		DefaultTerms = ASTerminology.build_default_terms
		KeywordConverter = ASTerminology::KeywordConverter.new
			
		def initWithApplicationClass_constructor_identifier_terms_(aem_application_class, constructor, identifier, terms)
			if terms == true
				terms = Appscript::ASBoolean.True
			elsif terms == false
				terms = Appscript::ASBoolean.False
			end
			initWithApplicationClass_targetType_targetData_terminology_defaultTerms_keywordConverter_(
					aem_application_class, 
					constructor, 
					identifier,
					terms, 
					DefaultTerms, 
					KeywordConverter)
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
			self.terminology.typeByCodeTable.each do |code, name|
				# note: using NSNumbers as Hash keys doesn't work so well, so cast them first
				@type_by_code[code.to_i] = name.to_s.intern
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
			extend(AppDataAccessors)
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
		
		TrueDesc = Appscript::ASBoolean.True.desc
		FalseDesc = Appscript::ASBoolean.False.desc
		
		def pack(data) 
			case data
				when GenericReference
					data = data.AS_resolve(self).AS_aem_reference
				when Reference
					data = data.AS_aem_reference
				when Keyword
					data = data.AS_pack_self(self)
				when true
					return TrueDesc
				when false
					return FalseDesc
			end
			return super_pack(data)
		end
		
		##
		
		ClassType = Appscript::AEMType.typeWithCode_(KAE::PClass)
		ClassKeyword = Appscript.k.class_
		
		def packDictionary(val)
			record = NSAppleEventDescriptor.recordDescriptor
			desired_type_obj = val.objectForKey_(ClassKeyword)
			desired_type_obj = val.objectForKey_(ClassType) if desired_type_obj == nil
			if desired_type_obj
				case desired_type_obj
					when Appscript::Keyword
						desired_type = desired_type_obj.AS_pack_self(self).typeCodeValue
					when Appscript::AEMType
						desired_type = desired_type_obj.code
					when NSAppleEventDescriptor
						desired_type = desired_type_obj.typeCodeValue
					else
						desired_type = nil
				end
				if desired_type != nil
					new_val = NSMutableDictionary.dictionaryWithDictionary_(val)
					new_val.removeObjectForKey_(desired_type_obj)
					record = record.coerce(desired_type)
					val = new_val
				end	
			end
			usrf = nil
			val.each do | key, value |
				if key.is_a?(Appscript::Keyword)
					key_type = @type_by_name.fetch(key.AS_name) do |k|
						raise IndexError, "Unknown keyword: #{k.is_a?(NSObject) ? k : k.inspect}"
					end
					record.setDescriptor_forKeyword_(pack_(value), key_type.typeCodeValue)
				elsif key.is_a?(Appscript::AEMType)
					record.setDescriptor_forKeyword_(pack(value), key.code)
				else
					usrf = NSAppleEventDescriptor.listDescriptor if usrf == nil
					usrf.insertDescriptor_atIndex_(pack(key), 0)
					usrf.insertDescriptor_atIndex_(pack(value), 0)
				end
			end
			record.setDescriptor_forKeyword_(usrf, KAE::KeyASUserRecordFields) if usrf
			return record
		end
		
		def unpack(desc)
			case desc.descriptorType
				when KAE::TypeTrue
					return true
				when KAE::TypeFalse
					return false
				when KAE::TypeBoolean
					return desc.booleanValue
			else
				return super_unpack(desc)
			end
		end
		
		def unpackType(desc)
			aem_object = super_unpackType(desc)
			name = @type_by_code[aem_object.code]
			return name ? Keyword.alloc.initWithName_aemObject_(name, aem_object) : aem_object
		end
		
		def unpackEnum(desc)
			aem_object = super_unpackEnum(desc)
			name = @type_by_code[aem_object.code]
			return name ? Keyword.alloc.initWithName_aemObject_(name, aem_object) : aem_object
		end
		
		def unpackProperty(desc)
			aem_object = super_unpackProperty(desc)
			name = @type_by_code[aem_object.code]
			return name ? Keyword.alloc.initWithName_aemObject_(name, aem_object) : aem_object
		end
		
		def unpackKeyword(desc)
			aem_object = super_unpackKeyword(desc)
			name = @type_by_code[aem_object.code]
			return name ? Keyword.alloc.initWithName_aemObject_(name, aem_object) : aem_object
		end
		
		def unpackAERecordKey(key)
			aem_object = Appscript::AEMType.typeWithCode_(key)
			name = @type_by_code[key]
			if name
				return Keyword.alloc.initWithName_aemObject_(name, aem_object)
			else
				return aem_object
			end
		end
		
		def unpackObjectSpecifier(desc)
			return Appscript::Reference.new(self, super_unpack(desc))
		end
		
		def unpackInsertionLoc(desc)
			return Appscript::Reference.new(self, super_unpack(desc))
		end
				
		def unpackContainsCompDescriptorWithOperand1_operand2(op1, op2)
			if op1.is_a?(Appscript::Reference) \
					and op1.AS_aem_reference.root == Appscript::AEMIts
				return op1.contains(op2)
			else
				return super_unpackContainsCompDescriptorWithOperand1_operand2(op1, op2)
			end
		end
		
		def unpackUnknown(desc)
			return case desc.descriptorType
				when KAE::TypeApplicationBundleID
					Appscript.app.by_id(self.unpackApplicationBundleID(desc))
				when KAE::TypeApplicationURL
					Appscript.app.by_url(self.unpackApplicationURL(desc))
				when KAE::TypeApplSignature
					Appscript.app.by_creator([self.unpackApplicationURL(desc)].pack('I'))
				when KAE::TypeKernelProcessID
					Appscript.app.by_pid(self.unpackProcessID(desc))
				when KAE::TypeProcessSerialNumber
					Appscript.app.by_pid(self.unpackProcessSerialNumber(desc))
				when KAE::TypeMachPort
					Appscript.app.by_aem_app(Appscript::AEMApplication.alloc.initWithDescriptor(desc))
			else
				super_unpackUnknown(desc)
			end
		end
	end
	
	
	class QualifiedAppData < AppData
		def applicationRootDescriptor
			return self.target.desc
		end
	end
	
	
	######################################################################
	# GENERIC REFERENCE
	######################################################################
	
	AEMApp = Appscript::AEMApplicationRoot.applicationRoot
	AEMCon = AEMCurrentContainerRoot.currentContainerRoot
	AEMIts = AEMObjectBeingExaminedRoot.objectBeingExaminedRoot
	
	
	class GenericReference < ASSafeObject
	
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
			return Appscript::GenericReference.new(@_call + [[name, args]])
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
			ref = Reference.new(app_data, {
					'app' => Appscript::AEMApp, 
					'con' => Appscript::AEMCon, 
					'its' => Appscript::AEMIts,
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
	
	class NOVALUE
	end
	
	class Reference < ASSafeObject
		
		attr_reader :AS_aem_reference, :AS_app_data
		attr_writer :AS_aem_reference, :AS_app_data
	
		def initialize(app_data, aem_reference)
			super()
			@AS_app_data = app_data
			@AS_aem_reference = aem_reference
		end
		
		#######
		
		def help(flags='-t')
			return @AS_app_data.helpForFlags_reference_(flags, self) # TO DO
		end
		
		# 'csig' attribute flags (see ASRegistry.h; note: there's no option for 'numeric strings' in 10.4)
		
		def Reference._pack_uint32(n) # used to pack csig attributes
			return Appscript::AEMCodecs.defaultCodecs.pack(n).coerceToDescriptorType_(KAE::TypeUInt32)
		end

		IgnoreEnums = [
			[Appscript.k.case, KAE::KAECaseConsiderMask, KAE::KAECaseIgnoreMask],
			[Appscript.k.diacriticals, KAE::KAEDiacriticConsiderMask, KAE::KAEDiacriticIgnoreMask],
			[Appscript.k.whitespace, KAE::KAEWhiteSpaceConsiderMask, KAE::KAEWhiteSpaceIgnoreMask],
			[Appscript.k.hyphens, KAE::KAEHyphensConsiderMask, KAE::KAEHyphensIgnoreMask],
			[Appscript.k.expansion, KAE::KAEExpansionConsiderMask, KAE::KAEExpansionIgnoreMask],
			[Appscript.k.punctuation, KAE::KAEPunctuationConsiderMask, KAE::KAEPunctuationIgnoreMask],
		]
		
		# default cons, csig attributes
		
		DefaultConsiderations =  Appscript::AEMCodecs.defaultCodecs \
				.pack([Appscript::AEMEnum.enumWithCode_(KAE::KAECase)])
		DefaultConsidersAndIgnores = Reference._pack_uint32(KAE::KAECaseIgnoreMask)
		
		##
		
		def _send_command(args, name, definition)
			target, error = @AS_app_data.targetWithError_()
			raise RuntimeError, error.to_s if error
			eventClass, eventID = definition.eventClass, definition.eventID
			subject_attr = NSAppleEventDescriptor.nullDescriptor
			direct_param = Appscript::NOVALUE
			case args.length
				when 0
					keyword_args = {}
				when 1 # note: if a command takes a hash as its direct parameter, user must pass {} as a second arg otherwise hash will be assumed to be keyword parameters
					if args[0].is_a?(Hash)
						keyword_args = args[0]
					else
						direct_param = args[0]
						keyword_args = {}
					end
				when 2
					direct_param, keyword_args = args
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
				enum_considerations = DefaultConsiderations
				enum_consids_and_ignores = DefaultConsidersAndIgnores
			else
				enum_considerations = ignore_options
				csig = 0
				IgnoreEnums.each do |option, consider_mask, ignore_mask|
					csig += ignore_options.include?(option) ? ignore_mask : consider_mask
				end
				enum_consids_and_ignores = Reference._pack_uint32(csig)
			end
			# optionally specify return value type
			result_type = keyword_args.delete(:result_type) { Appscript::NOVALUE }
			# special cases
			if @AS_aem_reference != Appscript::AEMApplicationRoot
				if eventClass == KAE::KAECoreSuite and eventID == KAE::KAESetData
					if direct_param != Appscript::NOVALUE and not keyword_args.has_key?(KAE::KeyAEData)
						keyword_args[KAE::KeyAEData] = direct_param
						direct_param = @AS_aem_reference
					elsif direct_param != Appscript::NOVALUE
						subject_attr = @AS_aem_reference
					else
						direct_param = @AS_aem_reference
					end
				elsif eventClass == KAE::KAECoreSuite and eventID == KAE::KAECreateElement
					if @AS_aem_reference.is_a?(Appscript::AEMInsertionSpecifier) \
							and not keyword_args.has_key?(KAE::KeyAEInsertHere)
						keyword_args[KAE::KeyAEInsertHere] = @AS_aem_reference
					else
						subject_attr = @AS_aem_reference
					end
				elsif direct_param != Appscript::NOVALUE
					subject_attr = @AS_aem_reference
				else
					direct_param = @AS_aem_reference
				end
			end
			# pack event
			event = target.eventWithEventClass_eventID_codecs_(eventClass, eventID, @AS_app_data)
			event.setAttribute_forKeyword_(enum_considerations, KAE::EnumConsiderations)
			event.setAttribute_forKeyword_(enum_consids_and_ignores, KAE::EnumConsidsAndIgnores)
			event.setAttribute_forKeyword_(subject_attr, KAE::KeySubjectAttr)
			event.setParameter_forKeyword_(direct_param, KAE::KeyDirectObject) if direct_param != Appscript::NOVALUE
			event.setParameter_forKeyword_(result_type, KAE::KeyAERequestedType) if result_type != Appscript::NOVALUE
			# extract labelled parameters, if any
			keyword_args.each do |param_name, param_value|
				param_code = definition.parameterForName_(param_name)
				raise ArgumentError, "Unknown keyword parameter: #{param_name}" if param_code == nil
				event.setParameter_forKeyword_(param_value, param_code)
			end
			# build and send the Apple event, returning its result, if any
			result, error = event.sendWithMode_timeout_error_(send_flags, timeout)
			return result if not error
			# relaunch/reconnect/resend/raise exception as needed
			# 'launch' events always return 'not handled' errors; just ignore these
			return if error.code == -1708 and eventClass == KAE::KASAppleScriptSuite and eventID == KAE::KASLaunchEvent
			if [-600, -609].include?(error.code) and target.targetType == Appscript::KAEMTargetFileURL
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
				p Appscript::AEMApplication.processExistsForFileURL_(target.targetData)
				# TO DO: next call should yield bool, but is int so block never executes as 'not 0' -> false (global check, fix)
				if not Appscript::AEMApplication.processExistsForFileURL_(target.targetData)
					if eventClass == KAE::KASAppleScriptSuite and eventID == KAE::KASLaunchEvent
						pid, error = Appscript::AEMApplication.launchApplication_error_(target.targetData)
						raise RuntimeError, error.to_s if error # TO DO: error class
					elsif eventClass != KAE::KCoreEventClass or eventID != KAE::KAEOpenApplication
						raise Appscript::CommandError.new(self, name, args, error)
					end
				end
				# update AEMApplication object's AEAddressDesc
				success, error = target.reconnectWithError_()
				raise RuntimeError, error.to_s if error # TO DO: error class
				# re-send command
				event = target.eventWithEventClass_eventID_codecs_(eventClass, eventID, @AS_app_data)
				event.setAttribute_forKeyword_(enum_considerations, KAE::EnumConsiderations)
				event.setAttribute_forKeyword_(enum_consids_and_ignores, KAE::EnumConsidsAndIgnores)
				event.setAttribute_forKeyword_(subject_attr, KAE::KeySubjectAttr)
				event.setParameter_forKeyword_(direct_param, KAE::KeyDirectObject) if direct_param != Appscript::NOVALUE
				keyword_args.each do |param_name, param_value|
					event.setParameter_forKeyword_(param_value, definition.parameterForName_(param_name))
				end
				event.setParameter_forKeyword_(result_type, KAE::KeyAERequestedType) if result_type != Appscript::NOVALUE
				result, error = event.sendWithMode_timeout_error_(send_flags, timeout)
				return result if not error
			end
			raise Appscript::CommandError.new(self, name, args, error)
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
				@_hash = [@AS_app_data.target, @AS_aem_reference].hash
			end
			return @_hash
		end
		
		def to_s
			if not defined? @_to_s
				@_to_s = ASReferenceRenderer.render(@AS_app_data, @AS_aem_reference)
			end
			return @_to_s
		end
		
		alias_method :inspect, :to_s
		
		#######
		# Utility methods
		
		def is_running?
			return @AS_app_data.isRunning
		end
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		def method_missing(name, *args)
			selector_type, code = @AS_app_data.reference_by_name[name]
			case selector_type # check if name is a property/element/command name, and if it is handle accordingly
				when :property
					return Reference.new(@AS_app_data, @AS_aem_reference.property(code))
				when :element
					return Reference.new(@AS_app_data, @AS_aem_reference.elements(code))
				when :command
					return _send_command(args, name, code)
			else 
				# see if it's a method that has been added to Object class [presumably] at runtime, but excluded
				# by ASSafeObject to avoid potential conflicts with property/element/command names
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
				new_ref = @AS_aem_reference.byRange_to_(selector, end_range_selector)
			else
				case selector
					when String
						 new_ref = @AS_aem_reference.byName_(selector)
					when Appscript::GenericReference
						new_ref = @AS_aem_reference.byTest(
								selector.AS_resolve(@AS_app_data).AS_aem_reference)
					when Appscript::Reference, Appscript::AEMTest
						new_ref = @AS_aem_reference.byTest(selector)
				else
					new_ref = @AS_aem_reference.byIndex(selector)
				end
			end
			return Appscript::Reference.new(@AS_app_data, new_ref)
		end
		
		def first
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.first)
		end
		
		def middle
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.middle)
		end
		
		def last
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.last)
		end
		
		def any
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.any)
		end
		
		def beginning
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.beginning)
		end
		
		def end
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.end)
		end
		
		def before
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.before)
		end
		
		def after
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.after)
		end
		
		def previous(klass)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.previous_(
					@AS_app_data.type_by_name.fetch(klass).typeCodeValue))
		end
		
		def next(klass)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.next_(
					@AS_app_data.type_by_name.fetch(klass).typeCodeValue))
		end
		
		def ID(id)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.byID_(id))
		end
		
		# Following methods will be called by its-based generic references
		
		def gt(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.greaterThan_(operand))
		end
		
		def ge(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.greaterOrEquals_(operand))
		end
		
		def eq(operand) # avoid colliding with comparison operators, which are normally used to compare two references
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.equals_(operand))
		end
		
		def ne(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.notEquals_(operand))
		end
		
		def lt(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.lessThan_(operand))
		end
		
		def le(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.lessOrEquals_(operand))
		end
		
		def begins_with(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.beginsWith_(operand))
		end
		
		def ends_with(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.endsWith_(operand))
		end
		
		def contains(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.contains_(operand))
		end
		
		def is_in(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.isIn_(operand))
		end
		
		def does_not_begin_with(operand)
			return self.begins_With(operand).not
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
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.AND(operands))
		end
			
		def or(*operands)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.OR(operands))
		end
		
		def not
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.NOT)
		end
	end
	
	
	######################################################################
	# APPLICATION
	######################################################################
	
	class Application < Reference
		
		private_class_method :new
			
		def _aem_application_class # hook
			return Appscript::AEMApplication
		end
		
		def initialize(constructor, identifier, terms)
			super(AppData.alloc.initWithApplicationClass_constructor_identifier_terms_(
					_aem_application_class, constructor, identifier, terms), AEMApp)
		end
		
		# constructors
		
		def Application.by_name(name, terms=true)
			return new(Appscript::KASTargetName, name, terms)
		end
		
		def Application.by_id(id, terms=true)
			return new(Appscript::KASTargetBundleID, id, terms)
		end
		
		def Application.by_creator(creator, terms=true)
			raise NotImplementedError # TO DO
		end
		
		def Application.by_pid(pid, terms=true)
			return new(Appscript::KASTargetPID, pid, terms)
		end
		
		def Application.by_url(url, terms=true)
			url = NSURL.URLWithString_(url) if not url.is_a?(NSURL)
			raise TypeError, "Bad URL: #{url}" if url == nil
			return new(Appscript::KASTargetURL, url, terms)
		end
		
		def Application.by_aem_app(aem_app, terms=true)
			raise NotImplementedError
		end
		
		def Application.current(terms=true)
			return new(Appscript::KASTargetCurrent, nil, terms)
		end
		
		#
		
		def AS_new_reference(ref)
			if ref.is_a?(Appscript::GenericReference)
				return ref.AS_resolve(@AS_app_data)
			elsif ref.is_a?(Appscript::AEMQuery)
				return Appscript::Reference.new(@AS_app_data, ref)
			elsif ref == nil
				return  Appscript::Reference.new(@AS_app_data, Appscript::AEMApp)
			else
				return Appscript::Reference.new(@AS_app_data, 
						Appscript::AEMCustomRoot.customRootWithObject_(ref))
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
		
		def _launch_app(url)
			pid, error = Appscript::AEMApplication.launchApplication_error_(url)
			raise RuntimeError, error.to_s if error # TO DO: error class
			success, error = @AS_app_data.target.reconnectWithError_()
			raise RuntimeError, error.to_s if error # TO DO: error class
		end
		
		def launch
			if @AS_app_data.targetType == Appscript::KASTargetName
				url, error = Appscript::AEMApplication.findApplicationForName_error_(@AS_app_data.targetData)
				raise RuntimeError, error.to_s if error # TO DO: error class
				_launch_app(url)
			elsif @AS_app_data.targetType == Appscript::KASTargetURL and @AS_app_data.targetData.isFileURL
				_launch_app(@AS_app_data.targetData)
			else
				event = target.eventWithEventClass_eventID_(KAE::KASAppleScriptSuite, KAE::KASLaunchEvent)
				result, error = event.sendWithError_()
				raise RuntimeError, error.to_s if error.code != -1708 # TO DO: error class
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
		
		def initialize(reference, command_name, parameters, real_error)
			@reference, @command_name, @parameters, @real_error = reference, command_name, parameters, real_error
			super()
		end
		
		def to_i
			if @real_error.is_a?(NSError)
				return @real_error.code
			else
				return -2700
			end
		end
		
		def to_s
			if @real_error.is_a?(NSError)
				real_error = "CommandError\n\t\tOSERROR: #{@real_error.code}\n\t\tMESSAGE: #{@real_error.localizedDescription}"
			else
				real_error = @real_error
			end
			return "#{real_error}\n\t\tCOMMAND: #{@reference}.#{@command_name}(#{(@parameters.collect { |item| item.inspect }).join(', ')})\n"
		end
		
		alias_method :inspect, :to_s
	end
	
	# TO DO
	# ApplicationNotFoundError
	# CantLaunchApplicationError
	
end

