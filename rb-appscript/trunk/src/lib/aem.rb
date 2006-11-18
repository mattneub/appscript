#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "ae"
require "kae"
require "_aem/findapp"
require "_aem/mactypes"

module AEM
	
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
	
		require "weakref"
		
		private_class_method :new
		attr_reader :hash, :identity
		protected :identity
		
		@@_app_number_count = 0
		@@_transaction_ids_by_app_no = {}

		#######
	
		Event = Send::Event # hook
		
		#######
		
		def initialize(path, address, identity)
			@_transaction = KAE::KAnyTransactionID
			@_path = path
			@_address = address
			@identity = identity
			@hash = identity.hash
			# workaround for lack of proper destructors; if a transaction is still open when Application instance is garbage collected, the following finalizer will automatically close it. Note: object IDs were different for some reason, so class maintains its own unique ids.
			@app_number = app_number = (@@_app_number_count += 1)
			@@_transaction_ids_by_app_no[app_number] = @_transaction
			ObjectSpace.define_finalizer(WeakRef.new(self), proc do
				transaction_id = @@_transaction_ids_by_app_no.delete(app_number)
				if transaction_id != KAE::KAnyTransactionID
					Send::Event(address, 'miscendt', transaction=transaction_id).send
				end
			end)
		end
		
		#######
		# constructors
		
		def Application.by_path(path)
			return new(path, Connect.local_app(path), [:path, path])
		end
		
		def Application.by_url(url)
			return new(nil, Connect.remote_app(url), [:url, url])
		end
		
		def Application.by_pid(pid)
			return new(nil, Connect.local_app_by_pid(pid), [:pid, pid])
		end
		
		def Application.by_desc(desc)
			return new(nil, desc, [:desc, desc.type, desc.data])
		end
		
		def Application.current
			return new(nil, Connect::CurrentApp, [:current])
		end
	
		#######
		# utility methods;
		
		def Application.launch(path)
			Connect.launch_app(path)
		end
		
		def Application.is_running?(path)
			return Connect.is_running?(path)
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
		
		# (hash is provided by readable @hash attribute)
		
		def reconnect
			if @_path
				@_address = Connect.local_app(@_path)
			end
			return
		end
		
		def event(event, params={}, atts={}, return_id=KAE::KAutoGenerateReturnID, codecs=DefaultCodecs)
			return self.class::Event.new(@_address, event, params, atts, @_transaction, return_id, codecs)
		end
		
		def start_transaction
			if @_transaction != KAE::KAnyTransactionID
				raise RuntimeError, "Transaction is already active."
			end
			@_transaction = self.class::Event(@_address, 'miscbegi').send
			@@_transaction_ids_by_app_no[@app_number] = @_transaction
			return
		end
		
		def end_transaction
			if @_transaction == KAE::KAnyTransactionID
				raise RuntimeError, "No transaction is active."
			end
			self.class::Event(@_address, 'miscendt', {}, {}, @_transaction).send
			@_transaction = KAE::KAnyTransactionID
			@@_transaction_ids_by_app_no[@app_number] = KAE::KAnyTransactionID
			return
		end
	end
end
