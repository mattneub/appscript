#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module AS
	# The following methods and classes are of interest to end users:
	# app, con, its, CommandError, ApplicationNotFoundError
	# Other classes are only of interest to implementors who need to hook in their own code.

	require "kae"
	require "aem"
	require "findapp"
	require "_appscript/referencerenderer"
	require "_appscript/terminology"
	
	######################################################################
	# APPDATA
	######################################################################
	
	module AppDataAccessors
		attr_reader :target, :typebyname, :typebycode, :referencebyname, :referencebycode
	end
	
	class AppData < AEM::Codecs
	
		attr_reader :path, :pid, :url
	
		def initialize(aemApplicationClass, path, pid, url, terms)
			super()
			@_aemApplicationClass = aemApplicationClass
			@_terms = terms
			@path = path
			@pid = pid
			@url = url
		end
		
		def _connect # initialize AEM::Application instance and terminology tables the first time they are needed
			if @path
				@target = @_aemApplicationClass.newPath(@path)
			elsif @pid
				@target = @_aemApplicationClass.newPID(@pid)
			elsif @url
				@target = @_aemApplicationClass.newURL(@url)
			else
				@target = @_aemApplicationClass.current
			end
			case @_terms
				when true # obtain terminology from application
					@typebycode, @typebyname, @referencebycode, @referencebyname = Terminology.tablesForApp(@path, @pid, @url)
				when false # use built-in terminology only (e.g. use this when running AppleScript applets)
					@typebycode, @typebyname, @referencebycode, @referencebyname = Terminology.defaultTables
				when nil # [developer-only] make Application#methods return names of built-in methods only (needed to generate reservedkeywords.rb file)
					@typebycode, @typebyname, @referencebycode, @referencebyname = {}, {}, {}, {}
			else # @_terms is [assumed to be] a module containing dumped terminology, so use that
				@typebycode, @typebyname, @referencebycode, @referencebyname = Terminology.tablesForModule(@_terms)
			end
			extend(AppDataAccessors)
		end
		
		#######
		
		def target
			_connect
			return @target
		end
		
		def typebyname
			_connect
			return @typebyname
		end
		
		def typebycode
			_connect
			return @typebycode
		end
		
		def referencebyname
			_connect
			return @referencebyname
		end
		
		def referencebycode
			_connect
			return @referencebycode
		end
		
		#######
		
		def pack(data)
			if data.is_a?(GenericReference)
				data = data.AS_resolve(self)
			end
			if data.is_a?(Reference)
				data = data.AS_aemreference
			elsif data.is_a?(Symbol)
				begin
					data = self.typebyname[data]
				rescue KeyError
					raise KeyError, "Unknown Keyword: #{data.inspect}"
				end
			end
			return super(data)
		end
		
		##
		
		ClassType = AEM::AEType.new('pcls')
		
		def packHash(val)
			record = AE::AEDesc.newList(true)
			if val.has_key?(:class_) or val.has_key?(ClassType)
				# if hash contains a 'class' property containing a class name, coerce the AEDesc to that class
				newVal = Hash[val]
				if newVal.has_key?(:class_)
					value = newVal.delete(:class_)
				else
					value = newVal.delete(ClassType)
				end
				if value.is_a?(Symbol) # get the corresponding AEType (assuming there is one)
					value = @typebyname.fetch(value, value)
				end
				if value.is_a?(AEM::AEType) # coerce the record to the desired type
					record = record.coerce(value.code)
					val = newVal
				end # else value wasn't a class name, so it'll be packed as a normal record property instead
			end	
			usrf = nil
			val.each do | key, value |
				if key.is_a?(Symbol)
					keyType = @typebyname.fetch(key) { raise IndexError, "Unknown keyword: #{key.inspect}" }
					record.putParam(keyType.code, pack(value))
				elsif key.is_a?(AEM::AETypeBase)
					record.putParam(key.code, pack(value))
				else
					if usrf == nil
						usrf = AE::AEDesc.newList(false)
					end
					usrf.putItem(0, pack(key))
					usrf.putItem(0, pack(value))
				end
			end
			if usrf
				record.putParam('usrf', usrf)
			end
			return record
		end
		
		def unpackType(desc)
			aemValue = super(desc)
			return @typebycode.fetch(aemValue.code, aemValue)
		end
		
		def unpackEnumerated(desc)
			aemValue = super(desc)
			return @typebycode.fetch(aemValue.code, aemValue)
		end
		
		def unpackProperty(desc)
			aemValue = super(desc)
			return @typebycode.fetch(aemValue.code, aemValue)
		end
		
		def unpackAERecord(desc)
			dct = {}
			desc.length().times do |i|
				key, value = desc.get(i + 1, KAE::TypeWildCard)
				if key == 'usrf'
					lst = unpackAEList(value)
					(lst.length / 2).times do |i|
						dct[lst[i * 2]] = lst[i * 2 + 1]
					end
				elsif @typebycode.has_key?(key)
					dct[@typebycode[key]] = unpack(value)
				else
					dct[AEM::AEType.new(key)] = unpack(value)
				end
			end
			return dct
		end
		
		def unpackObjectSpecifier(desc)
			return Reference.new(self, DefaultCodecs.unpackObjectSpecifier(desc))
		end
		
		def unpackInsertionLoc(desc)
			return Reference.new(self, DefaultCodecs.unpackInsertionLoc(desc))
		end
				
		def unpackContainsCompDescriptor(op1, op2)
			if op1.is_a?(AS::Reference) and op1.AS_aemreference.AEM_root == AEMReference::Its
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
			s= 'AS.' + @_call[0]
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
		
		def AS_resolve(appData)
			ref = Reference.new(appData, {'app' => AEM.app, 'con' => AEM.con, 'its' => AEM.its}[@_call[0]])
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
		# note: calling #AS_appdata on a newly created application object will return an AppData instance
		# that is not yet fully initialised, so remember to call its #_connect method before use
		attr_reader :AS_aemreference, :AS_appdata
		attr_writer :AS_aemreference, :AS_appdata
	
		def initialize(appdata, aemreference)
			@AS_appdata = appdata
			@AS_aemreference = aemreference
		end
		
		def _resolveRangeBoundary(selector, valueIfNone)
			if selector == nil
				selector = valueIfNone
			end
			if selector.is_a?(AS::GenericReference)
				return selector.AS_resolve(@AS_appdata).AS_aemreference
			elsif selector.is_a?(Reference)
				return selector.AS_aemreference
			elsif selector.is_a?(String)
				return AEM.con.elements(@AS_aemreference.AEM_want).byname(selector)
			else
				return AEM.con.elements(@AS_aemreference.AEM_want).byindex(selector)
			end
		end
		
		#######
		
		def Reference._packUInt32(n) # used to pack csig attributes
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
		DefaultConsidersAndIgnores = _packUInt32(KAE::KAECaseIgnoreMask)
		
		##
		
		def _sendCommand(args, name, code, labelledArgTerms)
	#		puts "Calling command #{name} \n\twith args #{args.inspect},\n\treference #{self}\n\tinfo #{code.inspect}, #{labelledArgTerms.inspect}\n\n"
#			begin # TO DO: enable error handling block once debugging is completed
				atts = {'subj' => nil}
				params = {}
				case args.length
					when 0
						keywordArgs = {}
					when 1 # note: if a command takes a hash as its direct parameter, user must pass {} as a second arg otherwise hash will be assumed to be keyword parameters
						if args[0].is_a?(Hash)
							keywordArgs = args[0]
						else
							params['----'] = args[0]
							keywordArgs = {}
						end
					when 2
						params['----'], keywordArgs = args
				else
					raise ArgumentError, "Too many direct parameters."
				end
				if not keywordArgs.is_a?(Hash)
					if keywordArgs == nil
						keywordArgs = {}
					else
						raise ArgumentError, "Second argument must be a Hash containing zero or more keyword parameters, or nil."
					end
				end
				# get user-specified timeout, if any
				timeout = (keywordArgs.delete(:timeout) {60}).to_i
				if timeout <= 0
					timeout = KAE::KNoTimeOut
				else
					timeout *= 60
				end
				# default send flags
				sendFlags = KAE::KAECanSwitchLayer
				# ignore application's reply?
				sendFlags += keywordArgs.delete(:waitreply) == false ? KAE::KAENoReply : KAE::KAEWaitReply
				# add considering/ignoring attributes
				ignoreOptions = keywordArgs.delete(:ignore)
				if ignoreOptions == nil
					atts['cons'] = DefaultConsiderations
					atts['csig'] = DefaultConsidersAndIgnores
				else
					atts['cons'] = ignoreOptions
					csig = 0
					IgnoreEnums.each do |option, considerMask, ignoreMask|
						csig += ignoreOptions.include?(option) ? ignoreMask : considerMask
					end
					atts['csig'] = Reference._packUInt32(csig)
				end
				# optionally specify return value type
				if keywordArgs.has_key?(:resulttype)
					params['rtyp'] = keywordArgs.delete(:resulttype)
				end
				# extract labelled parameters, if any
				keywordArgs.each do |paramName, paramValue|
					paramCode = labelledArgTerms[paramName]
					if paramCode == nil
						raise ArgumentError, "Unknown keyword parameter: #{paramName.inspect}"
					end
					params[paramCode] = paramValue
				end
				# apply special cases
				# Note: appscript does not replicate every little AppleScript quirk when packing event attributes and parameters (e.g. AS always packs a make command's tell block as the subject attribute, and always includes an each parameter in count commands), but should provide sufficient consistency with AS's habits and give good usability in their own right.
				if @AS_aemreference != AEM.app # If command is called on a Reference, rather than an Application...
					if code == 'coresetd'
						#  if ref.set(...) contains no 'to' argument, use direct argument for 'to' parameter and target reference for direct parameter
						if params.has_key?('----') and not params.has_key?('data')
							params['data'] = params['----']
							params['----'] = @AS_aemreference
						elsif not params.has_key?('----')
							params['----'] = @AS_aemreference
						else
							atts['subj'] = @AS_aemreference
						end
					elsif params.has_key?('----')
						# if user has already supplied a direct parameter, pack that reference as the subject attribute
						atts['subj'] = @AS_aemreference
					else
						# pack that reference as the direct parameter
						params['----'] = @AS_aemreference
					end
				end
#			rescue => e
#				raise AS::CommandError.new(self, name, args, e)
#			end
			# build and send the Apple event, returning its result, if any
			begin
				# puts 'SENDING EVENT: ' + [code, params, atts, timeout, sendFlags].inspect
				return @AS_appdata.target.event(code, params, atts, 
						KAE::KAutoGenerateReturnID, @AS_appdata).send(timeout, sendFlags)
			rescue => e
				if e.is_a?(AEM::CommandError)
					if [-600, -609].include?(e.number) and @AS_appdata.path
						if not @AS_appdata.target.running?
							if code == 'ascrnoop'
								AEM::Application.launch(@AS_appdata.path)
							elsif code != 'aevtoapp'
								raise CommandError.new(self, name, args, e)
							end
						end
						@AS_appdata.target.reconnect
						begin
							return @AS_appdata.target.event(code, params, atts, 
									KAE::KAutoGenerateReturnID, @AS_appdata).send(timeout, sendFlags)
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
				return @AS_appdata.referencebyname.has_key?(name.is_a?(String) ? name.intern : name)
			end
		end
		
		def methods
			return super + @AS_appdata.referencebyname.keys.collect { |name| name.to_s }
		end
		
		def commands
			return (@AS_appdata.referencebyname.collect { |name, info| info[0] == :command ? name.to_s : nil }).compact.sort
		end
		
		def parameters(commandName)
			if not @AS_appdata.referencebyname.has_key?(commandName.intern)
				raise ArgumentError, "Command not found: #{commandName}"
			end
			return (@AS_appdata.referencebyname[commandName.intern][1][1].keys.collect { |name| name.to_s }).sort
		end
		
		def properties
			return (@AS_appdata.referencebyname.collect { |name, info| info[0] == :property ? name.to_s : nil }).compact.sort
		end
		
		def elements
			return (@AS_appdata.referencebyname.collect { |name, info| info[0] == :element ? name.to_s : nil }).compact.sort
		end
		
		def keywords
			return (@AS_appdata.typebyname.collect { |name, code| name.to_s }).sort
		end

		#######
		# standard object methods
		
		def ==(val)
			return (self.class == val.class and @AS_appdata.target == val.AS_appdata.target \
					and @AS_aemreference == val.AS_aemreference)
		end
		
		alias_method :eql?, :== 
		
		def hash
			if not defined? @_hash
				@_hash = [@AS_appdata.target, @AS_aemreference].hash
			end
			return @_hash
		end
		
		def to_s
			if not defined? @_to_s
				@_to_s = ReferenceRenderer.render(@AS_appdata, @AS_aemreference)
			end
			return @_to_s
		end
		
		alias_method :inspect, :to_s
		
		#######
		# Public properties and methods; these are called by end-user and other clients (e.g. generic references)
		
		def method_missing(name, *args)
			selectorType, code = @AS_appdata.referencebyname[name]
			case selectorType
				when :property
					return Reference.new(self.AS_appdata, self.AS_aemreference.property(code))
				when :element
					return Reference.new(self.AS_appdata, self.AS_aemreference.elements(code))
				when :command
					return _sendCommand(args, name, code[0], code[1])
			else
				# convenience shortcuts # TO DO: decide if these should be kept or not; note: if enabled, reserved keywords list will need to be expanded to include methods whose names end in '?' and '='
				# - if name ends with '?', remove that and look up again; if property/element found, make new reference and send it a 'get' event, else raise 'unknown' error
				# - if name ends with '=', remove that and look up again; if property/element found, make new reference and send it a 'set' event, else raise 'unknown' error
				#nameStr = name.to_s
				#modifier = nameStr[-1, 1]
				#if modifier == '?' or modifier == '=' and nameStr.length > 0
				#	newName = nameStr.chop.intern
				#	selectorType, code = @AS_appdata.referencebyname[newName]
				#	if [:property, :element].include?(selectorType) and
				#		case modifier
				#			when '?'
				#				return self.send(newName, *args).get
				#			when '='
				#				return self.send(newName, *args).set(*args)
				#		end
				#	end
				#end
				msg = "Unknown property, element or command: '#{name}'"
				if @AS_appdata.referencebyname.has_key?("#{name}_".intern)
					msg += " (Did you mean '#{name}_'?)"
				end
				raise RuntimeError, msg
			end
		end
		
		def [](selector, endRangeSelector=nil)
			if endRangeSelector != nil
				newRef = self.AS_aemreference.byrange(
						self._resolveRangeBoundary(selector, 1),
						self._resolveRangeBoundary(endRangeSelector, -1))
			elsif selector.is_a?(String)
				 newRef = @AS_aemreference.byname(selector)
			elsif selector.is_a?(AS::GenericReference)
				newRef = @AS_aemreference.byfilter(
						selector.AS_resolve(@AS_appdata).AS_aemreference)
			else
				newRef = @AS_aemreference.byindex(selector)
			end
			return Reference.new(self.AS_appdata, newRef)
		end
		
		def first
			return Reference.new(@AS_appdata, @AS_aemreference.first)
		end
		
		def middle
			return Reference.new(@AS_appdata, @AS_aemreference.middle)
		end
		
		def last
			return Reference.new(@AS_appdata, @AS_aemreference.last)
		end
		
		def any
			return Reference.new(@AS_appdata, @AS_aemreference.any)
		end
		
		def start
			return Reference.new(@AS_appdata, @AS_aemreference.start)
		end
		
		def end
			return Reference.new(@AS_appdata, @AS_aemreference.end)
		end
		
		def before
			return Reference.new(@AS_appdata, @AS_aemreference.before)
		end
		
		def after
			return Reference.new(@AS_appdata, @AS_aemreference.after)
		end
		
		def previous(klass)
			return Reference.new(@AS_appdata, @AS_aemreference.previous(
					@AS_appdata.typebyname[klass].code))
		end
		
		def next(klass)
			return Reference.new(@AS_appdata, @AS_aemreference.next(
					@AS_appdata.typebyname[klass].code))
		end
		
		def ID(id)
			return Reference.new(@AS_appdata, @AS_aemreference.byid(id))
		end
		
		# Following methods will be called by its-based generic references
		# Note that rb-appscript's comparison 'operator' names are gt/ge/eq/ne/lt/le, not >/>=/==/!=/</<= as in py-appscript. Unlike Python, Ruby's != operator isn't overridable, and a mixture of styles would be confusing to users. On the plus side, it does mean that rb-appscript's generic refs can be compared for equality.
		
		def gt(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.gt(operand))
		end
		
		def ge(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.ge(operand))
		end
		
		def eq(operand) # avoid colliding with comparison operators, which are normally used to compare two references
			return Reference.new(@AS_appdata, @AS_aemreference.eq(operand))
		end
		
		def ne(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.ne(operand))
		end
		
		def lt(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.lt(operand))
		end
		
		def le(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.le(operand))
		end
		
		def startswith(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.startswith(operand))
		end
		
		def endswith(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.endswith(operand))
		end
		
		def contains(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.contains(operand))
		end
		
		def isin(operand)
			return Reference.new(@AS_appdata, @AS_aemreference.isin(operand))
		end
		
		def doesnotstartwith(operand)
			return self.startswith(operand).not
		end
		
		def doesnotendwith(operand)
			return self.endswith(operand).not
		end
		
		def doesnotcontain(operand)
			return self.contains(operand).not
		end
		
		def isnotin(operand)
			return self.isin(operand).not
		end
		
		def and(*operands)
			return Reference.new(@AS_appdata, @AS_aemreference.and(*operands))
		end
			
		def or(*operands)
			return Reference.new(@AS_appdata, @AS_aemreference.or(*operands))
		end
		
		def not
			return Reference.new(@AS_appdata, @AS_aemreference.not)
		end
	end
		
	
	######################################################################
	# APPLICATION
	######################################################################
	
	class Application < Reference
		
		private_class_method :new
			
		def _aemApplicationClass # hook
			return AEM::Application
		end
		
		def initialize(path, pid, url, terms)
			super(AppData.new(_aemApplicationClass, path, pid, url, terms), AEM.app)
		end
		
		# constructors
		
		def Application.byName(name, terms=true)
			return new(FindApp.byName(name), nil, nil, terms)
		end
		
		def Application.byID(id, terms=true)
			return new(FindApp.byID(id), nil, nil, terms)
		end
		
		def Application.byCreator(creator, terms=true)
			return new(FindApp.byCreator(creator), nil, nil, terms)
		end
		
		def Application.byPID(pid, terms=true)
			return new(nil, pid, nil, terms)
		end
		
		def Application.byURL(url, terms=true)
			return new(nil, nil, url, terms)
		end
		
		def Application.current(terms=true)
			return new(nil, nil, nil, terms)
		end
		
		#
		
		def starttransaction
			@AS_appdata.target.starttransaction
		end
		
		def endtransaction
			@AS_appdata.target.endtransaction
		end
		
		def launch
			if @AS_appdata.path
				AEM::Application.launch(@AS_appdata.path)
				@AS_appdata.target.reconnect
			else
				@AS_appdata.target.event('ascrnoop').send # will send launch event to app if already running; else will error
			end
		end
	end
	
	##
	
	class GenericApplication < GenericReference
		
		def initialize(appClass)
			@_appClass = appClass
			super(['app'])
		end
		
		def byName(name, terms=true)
			return @_appClass.byName(name, terms)
		end
		
		def byID(id, terms=true)
			return @_appClass.byID(id, terms)
		end
		
		def byCreator(creator, terms=true)
			return @_appClass.byCreator(creator, terms)
		end
		
		def byPID(pid, terms=true)
			return @_appClass.byPID(pid, terms)
		end
		
		def byURL(url, terms=true)
			return @_appClass.byURL(url, terms)
		end
		
		def current(terms=true)
			return @_appClass.current(terms)
		end
	end
	
	#######
	
	AS_App = AS::GenericApplication.new(Application)
	AS_Con = AS::GenericReference.new(['con'])
	AS_Its = AS::GenericReference.new(['its'])
	
	
	######################################################################
	# REFERENCE ROOTS
	######################################################################
	# public (note: Application & GenericApplication classes may also be accessed if subclassing Application class is required)
	
	def AS.app(*args)
		if args == []
			return AS_App
		else
			return AS_App.byName(*args)
		end
	end

	def AS.con
		return AS_Con
	end
	
	def AS.its
		return AS_Its
	end
	
	
	######################################################################
	# COMMAND ERROR
	######################################################################
	# public
	
	class CommandError < RuntimeError
		
		attr_reader :reference, :name, :parameters, :realerror
		
		def initialize(reference, commandName, parameters, realerror)
			@reference, @commandName, @parameters, @realerror = reference, commandName, parameters, realerror
			super()
		end
		
		def to_s
			return "#{@realerror}\n\t\tCOMMAND: #{@reference}.#{@commandName}(#{(@parameters.collect { |item| item.inspect }).join(', ')})\n"
		end
	end
	
	
	ApplicationNotFoundError = FindApp::ApplicationNotFoundError
end
