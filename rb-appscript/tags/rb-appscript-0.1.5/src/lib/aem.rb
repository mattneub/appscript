#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module AEM
	
	require "ae"
	require "kae"
	require "_aem/codecs"
	require "_aem/aemreference"
	require "_aem/typewrappers"
	require "_aem/connect"
	require "_aem/send"
	
	#######
	# Constants
	
	Codecs = Codecs
	DefaultCodecs = DefaultCodecs
	NotUTF8TextError = NotUTF8TextError
	MacOSError = AE::MacOSError
	
	AEDesc = AE::AEDesc
	
	AETypeBase = TypeWrappers::AETypeBase
	AEType = TypeWrappers::AEType
	AEEnum = TypeWrappers::AEEnum
	AEProp = TypeWrappers::AEProp
	AEKey = TypeWrappers::AEKey
	AEEventName = TypeWrappers::AEEventName
	
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
		
		@@_appNumberCount = 0
		@@_transactionIDsByAppNo = {}

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
			@appNumber = appNumber = (@@_appNumberCount += 1)
			@@_transactionIDsByAppNo[appNumber] = @_transaction
			ObjectSpace.define_finalizer(WeakRef.new(self), proc do
				transactionID = @@_transactionIDsByAppNo.delete(appNumber)
				if transactionID != KAE::KAnyTransactionID
					Send::Event(address, 'miscendt', transaction=transactionID).send
				end
			end)
		end
		
		#######
		# constructors
		
		def Application.newPath(path)
			return new(path, Connect.localApp(path), [:path, path])
		end
		
		def Application.newURL(url)
			return new(nil, Connect.remoteApp(url), [:url, url])
		end
		
		def Application.newPID(pid)
			return new(nil, Connect.localAppByPID(pid), [:pid, pid])
		end
		
		def Application.newAEDesc(desc)
			return new(nil, desc, [:desc, desc.type, desc.data])
		end
		
		def Application.current
			return new(nil, Connect::CurrentApp, [:current])
		end
	
		def Application.launch(path)
			Connect.launchApp(path)
		end
		
		#######
		# methods
		
		def ==(val)
			return (self.class == val.class and @identity == val.identity)
		end
		
		alias_method :eql?, :== 
		
		# (hash is provided by readable @hash attribute)
		
		def running? # true/false or nil if unknown
			if @_path
				return Connect.running?(@_path)
			end
		end
		
		def reconnect
			if @_path
				@_address = Connect.localApp(@_path)
			end
			return
		end
		
		def event(event, params={}, atts={}, returnID=KAE::KAutoGenerateReturnID, codecs=DefaultCodecs)
			return self.class::Event.new(@_address, event, params, atts, @_transaction, returnID, codecs)
		end
		
		def starttransaction
			if @_transaction != KAE::KAnyTransactionID
				raise RuntimeError, "Transaction is already active."
			end
			@_transaction = self.class::Event(@_address, 'miscbegi').send
			@@_transactionIDsByAppNo[@appNumber] = @_transaction
			return
		end
		
		def endtransaction
			if @_transaction == KAE::KAnyTransactionID
				raise RuntimeError, "No transaction is active."
			end
			self.class::Event(@_address, 'miscendt', transaction=@_transaction).send
			@_transaction = KAE::KAnyTransactionID
			@@_transactionIDsByAppNo[@appNumber] = KAE::KAnyTransactionID
			return
		end
	end
end
