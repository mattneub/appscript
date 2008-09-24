# Copyright (C) 2008 HAS. 
# Released under MIT License.

module Appscript

	framework 'Appscript'

	require "_appscript/terminology"
	require "_appscript/safeobject"
	require "_appscript/referencerenderer"
	require "kae"
	
	
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
		
		DefaultTerms = MRATerminology.build_default_terms
		KeywordConverter = MRATerminology::KeywordConverter.new
			
		def initWithApplicationClass(aem_application_class, constructor:constructor, identifier:identifier, terms:terms)
			if terms == true
				terms = ASBoolean.True
			elsif terms == false
				terms = ASBoolean.False
			end
			initWithApplicationClass(aem_application_class, 
							targetType:constructor, 
							targetData:identifier,
							terminology:terms, 
							defaultTerms:DefaultTerms, 
							keywordConverter:KeywordConverter)
			return self
		end
		
		def connect
			error = nil
			@target = self.targetWithError(error) # TO DO
			raise RuntimeError, error.to_s if not @target
			@type_by_name = {}
			self.terminology.typeByNameTable.each do |name, code|
				@type_by_name[name.intern] = code
			end
			@type_by_code = {}
			self.terminology.typeByCodeTable.each do |code, name|
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
		
		TrueDesc = ASBoolean.True.descriptor
		FalseDesc = ASBoolean.False.descriptor
		
		def pack(data) 
			case data
				when GenericReference
					data = data.AS_resolve(self).AS_aem_reference
				when Reference
					data = data.AS_aem_reference
				when Symbol
					data = self.type_by_name.fetch(data) { raise IndexError, "Unknown keyword: #{data.inspect}" }
				when true
					return TrueDesc
				when false
					return FalseDesc
			end
			return super(data)
		end
		
		##
		
		ClassType = AEMType.typeWithCode(KAE::PClass)
		
		def packDictionary(val)
			record = NSAppleEventDescriptor.recordDescriptor
			desired_type_obj = val.objectForKey(:class_)
			desired_type_obj = val.objectForKey(:class_) if desired_type_obj == nil
			if desired_type_obj
				case desired_type_obj
					when Symbol
						desired_type = self.pack(desired_type_obj).typeCodeValue
					when AEMType
						desired_type = desired_type_obj.fourCharCode
					when NSAppleEventDescriptor
						desired_type = desired_type_obj.typeCodeValue
					else
						desired_type = nil
				end
				if desired_type != nil
					new_val = NSMutableDictionary.dictionaryWithDictionary(val)
					new_val.removeObjectForKey(desired_type_obj)
					record = record.coerce(desired_type)
					val = new_val
				end	
			end
			usrf = nil
			val.each do | key, value |
				if key.is_a?(Symbol)
					key_type = @type_by_name.fetch(key) do |k|
						raise IndexError, "Unknown keyword: #{k.is_a?(NSObject) ? k : k.inspect}"
					end
					record.setDescriptor(pack(value), forKeyword:key_type.typeCodeValue)
				elsif key.is_a?(AEMType)
					record.setDescriptor(pack(value), forKeyword:key.fourCharCode)
				else
					usrf = NSAppleEventDescriptor.listDescriptor if usrf == nil
					usrf.insertDescriptor(pack(key), atIndex:0)
					usrf.insertDescriptor(pack(value), atIndex:0)
				end
			end
			record.setDescriptor(usrf, forKeyword:KAE::KeyASUserRecordFields) if usrf
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
				return super(desc)
			end
		end
		
		def unpackType(desc)
			aem_object = super(desc)
			return @type_by_code.fetch(AEMType.typeWithCode(aem_object.fourCharCode), aem_object)
		end
		
		def unpackEnum(desc)
			aem_object = super(desc)
			return @type_by_code.fetch(AEMType.typeWithCode(aem_object.fourCharCode), aem_object)
		end
		
		def unpackProperty(desc)
			aem_object = super(desc)
			return @type_by_code.fetch(AEMType.typeWithCode(aem_object.fourCharCode), aem_object)
		end
		
		def unpackKeyword(desc)
			aem_object = super(desc)
			return @type_by_code.fetch(AEMType.typeWithCode(aem_object.fourCharCode), aem_object)
		end
		
		def unpackAERecordKey(key)
			return @type_by_code.fetch(key) { |k| AEMType.typeWithCode(k) }
		end
		
		def unpackObjectSpecifier(desc)
			return Appscript::Reference.new(self, super(desc))
		end
		
		def unpackInsertionLoc(desc)
			return Appscript::Reference.new(self, super(desc))
		end
				
		def unpackContainsCompDescriptorWithOperand1(op1, operand2:op2)
			if op1.is_a?(Appscript::Reference) and op1.AS_aem_reference.root == AEMIts
				return op1.contains(op2)
			else
				return super(op1, op2)
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
					Appscript.app.by_aem_app(AEMApplication.alloc.initWithDescriptor(desc))
			else
				super(desc)
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
	
	AEMApp = AEMApplicationRoot.applicationRoot
	AEMCon = AEMCurrentContainerRoot.currentContainerRoot
	AEMIts = AEMObjectBeingExaminedRoot.objectBeingExaminedRoot
	
	
	class GenericReference < MRASafeObject
	
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
					'app' => AEMApp, 
					'con' => AEMCon, 
					'its' => AEMIts,
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
	
	class Reference < MRASafeObject
		
		attr_reader :AS_aem_reference, :AS_app_data
		attr_writer :AS_aem_reference, :AS_app_data
	
		def initialize(app_data, aem_reference)
			super()
			@AS_app_data = app_data
			@AS_aem_reference = aem_reference
		end
		
		#######
		
		def help(flags='-t')
			return @AS_app_data.helpForFlags(flags, reference:self) # TO DO
		end
		
		# 'csig' attribute flags (see ASRegistry.h; note: there's no option for 'numeric strings' in 10.4)
		
		def Reference._pack_uint32(n) # used to pack csig attributes
			return AEMCodecs.defaultCodecs.pack(n).coerceToDescriptorType(KAE::TypeUInt32)
		end

		IgnoreEnums = [
			[:case, KAE::KAECaseConsiderMask, KAE::KAECaseIgnoreMask],
			[:diacriticals, KAE::KAEDiacriticConsiderMask, KAE::KAEDiacriticIgnoreMask],
			[:whitespace, KAE::KAEWhiteSpaceConsiderMask, KAE::KAEWhiteSpaceIgnoreMask],
			[:hyphens, KAE::KAEHyphensConsiderMask, KAE::KAEHyphensIgnoreMask],
			[:expansion, KAE::KAEExpansionConsiderMask, KAE::KAEExpansionIgnoreMask],
			[:punctuation, KAE::KAEPunctuationConsiderMask, KAE::KAEPunctuationIgnoreMask],
		]
		
		# default cons, csig attributes
		
		DefaultConsiderations =  AEMCodecs.defaultCodecs.pack([AEMEnum.enumWithCode(KAE::KAECase)])
		DefaultConsidersAndIgnores = Reference._pack_uint32(KAE::KAECaseIgnoreMask)
		
		##
		
		def _send_command(args, name, definition)
			error = nil
			target = @AS_app_data.targetWithError(error) # TO DO
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
			if @AS_aem_reference != AEMApplicationRoot
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
					if @AS_aem_reference.is_a?(AEMInsertionSpecifier) \
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
			event = target.eventWithEventClass(eventClass, eventID:eventID, codecs:@AS_app_data)
			event.setAttribute(enum_considerations, forKeyword:KAE::EnumConsiderations)
			event.setAttribute(enum_consids_and_ignores, forKeyword:KAE::EnumConsidsAndIgnores)
			event.setAttribute(subject_attr, forKeyword:KAE::KeySubjectAttr)
			event.setParameter(direct_param, forKeyword:KAE::KeyDirectObject) if direct_param != Appscript::NOVALUE
			event.setParameter(result_type, forKeyword:KAE::KeyAERequestedType) if result_type != Appscript::NOVALUE
			# extract labelled parameters, if any
			keyword_args.each do |param_name, param_value|
				param_code = definition.parameterForName(param_name)
				raise ArgumentError, "Unknown keyword parameter: #{param_name}" if param_code == nil
				event.setParameter(param_value, forKeyword:param_code)
			end
			# build and send the Apple event, returning its result, if any
			error = nil
			result = event.sendWithMode(send_flags, timeout:timeout, error:error) # TO DO
#			p [result, result.description, result.class]
			return result if not error
			# relaunch/reconnect/resend/raise exception as needed
			# 'launch' events always return 'not handled' errors; just ignore these
			return if error.code == -1708 and eventClass == KAE::KASAppleScriptSuite and eventID == KAE::KASLaunchEvent
			if [-600, -609].include?(error.code) and target.targetType == KAEMTargetFileURL
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
#				p AEMApplication.processExistsForFileURL(target.targetData) # test; TO DO: delete
				# TO DO: next call should yield bool, but is int so block never executes as 'not 0' -> false (global check, fix)
				if not AEMApplication.processExistsForFileURL(target.targetData)
					if eventClass == KAE::KASAppleScriptSuite and eventID == KAE::KASLaunchEvent
						error = nil
						pid = AEMApplication.launchApplication(target.targetData, error:error) # TO DO
						raise RuntimeError, error.to_s if error # TO DO: error class
					elsif eventClass != KAE::KCoreEventClass or eventID != KAE::KAEOpenApplication
						raise Appscript::CommandError.new(self, name, args, error)
					end
				end
				# update AEMApplication object's AEAddressDesc
				error = nil
				success = target.reconnectWithError(error) # TO DO
				raise RuntimeError, error.to_s if error # TO DO: error class
				# re-send command
				event = target.eventWithEventClass(eventClass, eventID:eventID, codecs:@AS_app_data)
				event.setAttribute(enum_considerations, forKeyword:KAE::EnumConsiderations)
				event.setAttribute(enum_consids_and_ignores, forKeyword:KAE::EnumConsidsAndIgnores)
				event.setAttribute(subject_attr, forKeyword:KAE::KeySubjectAttr)
				event.setParameter(direct_param, forKeyword:KAE::KeyDirectObject) if direct_param != Appscript::NOVALUE
				keyword_args.each do |param_name, param_value|
					event.setParameter(param_value, forKeyword:definition.parameterForName(param_name))
				end
				event.setParameter(result_type, forKeyword:KAE::KeyAERequestedType) if result_type != Appscript::NOVALUE
				error = nil
				result = event.sendWithMode(send_flags, timeout:timeout, error:error) # TO DO
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
					and @AS_app_data.target.isEqual(val.AS_app_data.target) \
					and @AS_aem_reference.isEqual(val.AS_aem_reference))
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
				@_to_s = MRAReferenceRenderer.render(@AS_app_data, @AS_aem_reference)
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
					return Reference.new(@AS_app_data, @AS_aem_reference.property(code.fourCharCode))
				when :element
					return Reference.new(@AS_app_data, @AS_aem_reference.elements(code.fourCharCode))
				when :command
					return _send_command(args, name, code)
			else 
				# MacRuby munges unhandled messages of form ref.name(arg1, key1:arg2, ...) into
				# ref.method_missing(:'name:key1:', [arg1, arg2]), so check for this form as well
				name, *argnames = name.to_s.split(':', -1).collect { |s| s.intern }
				argnames.pop
				if argnames.size == args.size - 1
					selector_type, code = @AS_app_data.reference_by_name[name]
					return _send_command([args.shift, Hash[argnames.zip(args)]], name, code) if selector_type == :command
				end
				# see if it's a method that has been added to Object class [presumably] at runtime, but excluded
				# by MRASafeObject to avoid potential conflicts with property/element/command names
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
				new_ref = @AS_aem_reference.byRange(selector, to:end_range_selector)
			else
				case selector
					when String
						 new_ref = @AS_aem_reference.byName(selector)
					when Appscript::GenericReference
						new_ref = @AS_aem_reference.byTest(
								selector.AS_resolve(@AS_app_data).AS_aem_reference)
					when Appscript::Reference, AEMTest
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
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.previous(
					@AS_app_data.type_by_name.fetch(klass).typeCodeValue))
		end
		
		def next(klass)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.next(
					@AS_app_data.type_by_name.fetch(klass).typeCodeValue))
		end
		
		def ID(id)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.byID(id))
		end
		
		# Following methods will be called by its-based generic references
		
		def gt(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.greaterThan(operand))
		end
		
		def ge(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.greaterOrEquals(operand))
		end
		
		def eq(operand) # avoid colliding with comparison operators, which are normally used to compare two references
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.equals(operand))
		end
		
		def ne(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.notEquals(operand))
		end
		
		def lt(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.lessThan(operand))
		end
		
		def le(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.lessOrEquals(operand))
		end
		
		def begins_with(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.beginsWith(operand))
		end
		
		def ends_with(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.endsWith(operand))
		end
		
		def contains(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.contains(operand))
		end
		
		def is_in(operand)
			return Appscript::Reference.new(@AS_app_data, @AS_aem_reference.isIn(operand))
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
			return AEMApplication
		end
		
		def initialize(constructor, identifier, terms)
			super(AppData.alloc.initWithApplicationClass(_aem_application_class, 
					constructor:constructor, identifier:identifier, terms:terms), AEMApp)
		end
		
		# constructors
		
		def Application.by_name(name, terms=true)
			return new(KASTargetName, name, terms)
		end
		
		def Application.by_id(id, terms=true)
			return new(KASTargetBundleID, id, terms)
		end
		
		def Application.by_creator(creator, terms=true)
			raise NotImplementedError # TO DO
		end
		
		def Application.by_pid(pid, terms=true)
			return new(KASTargetPID, pid, terms)
		end
		
		def Application.by_url(url, terms=true)
			url = NSURL.URLWithString(url) if not url.is_a?(NSURL)
			raise TypeError, "Bad URL: #{url}" if url == nil
			return new(KASTargetURL, url, terms)
		end
		
		def Application.by_aem_app(aem_app, terms=true)
			raise NotImplementedError
		end
		
		def Application.current(terms=true)
			return new(KASTargetCurrent, nil, terms)
		end
		
		#
		
		def AS_new_reference(ref)
			if ref.is_a?(Appscript::GenericReference)
				return ref.AS_resolve(@AS_app_data)
			elsif ref.is_a?(AEMQuery)
				return Appscript::Reference.new(@AS_app_data, ref)
			elsif ref == nil
				return  Appscript::Reference.new(@AS_app_data, AEMApp)
			else
				return Appscript::Reference.new(@AS_app_data, 
						AEMCustomRoot.customRootWithObject(ref))
			end
		end
		
		def begin_transaction(session=nil)
			@AS_app_data.target.beginTransaction(session)
		end
		
		def abort_transaction
			@AS_app_data.target.abortTransaction
		end
		
		def end_transaction
			@AS_app_data.target.endTransaction
		end
		
		def _launch_app(url)
			error = nil
			pid = AEMApplication.launchApplication(url, error:error) # TO DO
			raise RuntimeError, error.to_s if error # TO DO: error class
			error = nil
			success = @AS_app_data.target.reconnectWithError(error) # TO DO
			raise RuntimeError, error.to_s if error # TO DO: error class
		end
		
		def launch
			if @AS_app_data.targetType == KASTargetName
				error = nil
				url = AEMApplication.findApplicationForName(@AS_app_data.targetData, error:error) # TO DO
				raise RuntimeError, error.to_s if error # TO DO: error class
				_launch_app(url)
			elsif @AS_app_data.targetType == KASTargetURL and @AS_app_data.targetData.isFileURL
				_launch_app(@AS_app_data.targetData)
			else
				event = target.eventWithEventClass(KAE::KASAppleScriptSuite, eventID:KAE::KASLaunchEvent)
				error = nil
				result = event.sendWithError(error) # TO DO
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
	
	MRA_App = Appscript::GenericApplication.new(Application)
	MRA_Con = Appscript::GenericReference.new(['con'])
	MRA_Its = Appscript::GenericReference.new(['its'])
	
	
	######################################################################
	# REFERENCE ROOTS
	######################################################################
	# public (note: Application & GenericApplication classes may also be accessed if subclassing Application class is required)
	
	def Appscript.app(*args)
		if args == []
			return MRA_App
		else
			return MRA_App.by_name(*args)
		end
	end

	def Appscript.con
		return MRA_Con
	end
	
	def Appscript.its
		return MRA_Its
	end
	
	# also define app, con, its as instance methods so that clients can 'include Appscript'
	
	def app(*args)
		if args == []
			return MRA_App
		else
			return MRA_App.by_name(*args)
		end
	end

	def con
		return MRA_Con
	end
	
	def its
		return MRA_Its
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

