#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "ae"
require "kae"
require "_aem/findapp"
require "_aem/mactypes"

module AEM

	# Mid-level wrapper for building and sending Apple events to local and remote applications.
	
	require "_aem/codecs"
	require "_aem/aemreference"
	require "_aem/typewrappers"
	require "_aem/connect"
	require "_aem/send"
	
	#######
	# Constants
	
	Codecs = Codecs
	DefaultCodecs = DefaultCodecs
	MacOSError = AE::MacOSError
	
	AEDesc = AE::AEDesc
	
	AETypeBase = TypeWrappers::AETypeBase
	AEType = TypeWrappers::AEType
	AEEnum = TypeWrappers::AEEnum
	AEProp = TypeWrappers::AEProp
	AEKey = TypeWrappers::AEKey
	
	CommandError = Send::CommandError
	
	#######
	# Reference roots
	
	def AEM.app
		return AEMReference::App
	end
	
	def AEM.con
		return AEMReference::Con
	end
	
	def AEM.its
		return AEMReference::Its
	end
	
	#######
	# Application class
	
	class Application
		# Identifies an application and provides an #event method for constructing Apple events targetted at it.
	
		require "weakref"
		
		private_class_method :new
		attr_reader :hash, :identity, :address_desc
		
		#######
		# Workaround for lack of proper destructors in Ruby; see #initialize method.
		
		@@_app_number_count = 0
		@@_transaction_ids_by_app_no = {}

		#######
	
		Event = Send::Event # Application subclasses can override this class constant (usually with a subclass of Send::Event) to modify how Apple events are created and/or sent.
		
		#######
		
		def initialize(path, address_desc, identity)
			# called by constructor method
			# path is used by #reconnect
			# address_desc is an AEAddressDesc identifying the target application
			# identity is used by #inspect, #hash, #==
			@_transaction = KAE::KAnyTransactionID
			@_path = path
			@address_desc = address_desc
			@identity = identity
			@hash = identity.hash
			# workaround for lack of proper destructors; if a transaction is still open when Application instance is garbage collected, the following finalizer will automatically close it. Note: object IDs were different for some reason, so class maintains its own unique ids.
			@app_number = app_number = (@@_app_number_count += 1)
			@@_transaction_ids_by_app_no[app_number] = @_transaction
			ObjectSpace.define_finalizer(WeakRef.new(self), proc do
				transaction_id = @@_transaction_ids_by_app_no.delete(app_number)
				if transaction_id != KAE::KAnyTransactionID
					self.class::Event.new(@address_desc, 'miscendt', {}, {}, transaction_id).send(60, KAE::KAENoReply)
				end
			end)
		end
	
		#######
		# utility class methods; placed here for convenience
		
		def Application.launch(path)
			# Launches a local application without sending it the usual 'run' event (aevtoapp).
			Connect.launch_app(path)
		end
		
		def Application.is_running?(path)
			# Checks if a local application is running.
			return Connect.is_running?(path)
		end
		
		#######
		# constructors
		
		def Application.by_path(path)
			# path : string  -- full path to local application
			#
			# Note: application will be launched if not already running.
			return new(path, Connect.local_app(path), [:path, path])
		end
		
		def Application.by_url(url)
			# url : string -- eppc URL for remote process
			return new(nil, Connect.remote_app(url), [:url, url])
		end
		
		def Application.by_pid(pid)
			# pid : integer -- Unix process id
			return new(nil, Connect.local_app_by_pid(pid), [:pid, pid])
		end
		
		def Application.by_desc(desc)
			# desc : AEDesc -- an AEAddressDesc
			return new(nil, desc, [:desc, desc.type, desc.data])
		end
		
		def Application.current
			return new(nil, Connect::CurrentApp, [:current])
		end
		
		#######
		# methods
		
		def inspect
			if @identity[0] == :current
				return 'AEM::Application.current'
			else
				con_name = {:path => 'by_path', :url => 'by_url', :pid => 'by_pid', :desc => 'by_desc'}[@identity[0]]
				return "AEM::Application.#{con_name}(#{@identity[1].inspect})"
			end
		end
		
		alias_method :to_s, :inspect
		
		def ==(val)
			return (self.class == val.class and @identity == val.identity)
		end
		
		alias_method :eql?, :== 
		
		# (hash method is provided by attr_reader :hash)
		
		def reconnect
			# If application has quit since this Application object was created, its AEAddressDesc
			# is no longer valid so this Application object will not work even when application is restarted.
			# #reconnect will update this Application object's AEAddressDesc so it's valid again.
			#
			# Note that this only works for Application objects created via the by_path constructor. 
			# Also note that any Event objects created prior to calling #reconnect will still be invalid.
			if @_path
				@address_desc = Connect.local_app(@_path)
			end
			return
		end
		
		def event(event, params={}, atts={}, return_id=KAE::KAutoGenerateReturnID, codecs=DefaultCodecs)
			# Construct an Apple event targetted at this application.
			#	event  : string -- 8-letter code indicating event's class, e.g. 'coregetd'
			#	params : hash -- a dict of form {AE_code:anything,...} containing zero or more event parameters (message arguments)
			#	atts : hash -- a dict of form {AE_code:anything,...} containing zero or more event attributes (event info)
			#	return_id : integer  -- reply event's ID
			#	codecs : Codecs -- codecs object to use when packing/unpacking this event
			return self.class::Event.new(@address_desc, event, params, atts, @_transaction, return_id, codecs)
		end
		
		def start_transaction(session=nil)
			# Start a new transaction.
			if @_transaction != KAE::KAnyTransactionID
				raise RuntimeError, "Transaction is already active."
			end
			@_transaction = self.class::Event.new(@address_desc, 'miscbegi', session != nil ? {'----' => session} : {}).send
			@@_transaction_ids_by_app_no[@app_number] = @_transaction
			return
		end
		
		def abort_transaction
			# Abort the current transaction.
			if @_transaction == KAE::KAnyTransactionID
				raise RuntimeError, "No transaction is active."
			end
			self.class::Event.new(@address_desc, 'miscttrm', {}, {}, @_transaction).send
			@_transaction = KAE::KAnyTransactionID
			@@_transaction_ids_by_app_no[@app_number] = KAE::KAnyTransactionID
			return
		end
		
		def end_transaction
			# End the current transaction.
			if @_transaction == KAE::KAnyTransactionID
				raise RuntimeError, "No transaction is active."
			end
			self.class::Event.new(@address_desc, 'miscendt', {}, {}, @_transaction).send
			@_transaction = KAE::KAnyTransactionID
			@@_transaction_ids_by_app_no[@app_number] = KAE::KAnyTransactionID
			return
		end
	end
end
