#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module Connect
	# Creates Apple event descriptor records of typeProcessSerialNumber, typeKernelProcessID and typeApplicationURL, used to specify the target application in Send::Event constructor.
	
	require "ae"
	require "kae"
	require "_aem/codecs"
	require "_aem/send"
	
	LaunchContinue = 0x4000
	LaunchNoFileFlags = 0x0800
	LaunchDontSwitch = 0x0200
	
	KNoProcess = 0
	KCurrentProcess = 2
	
	def Connect.make_address_desc(psn)
		return AE::AEDesc.new(KAE::TypeProcessSerialNumber, psn.pack('LL'))
	end
	
	NullAddress = make_address_desc([0,KNoProcess])
	LaunchEvent = Send::Event.new(Connect::NullAddress, 'ascrnoop').AEM_event
	RunEvent = Send::Event.new(Connect::NullAddress, 'aevtoapp').AEM_event
	
	#######
	# public
	
	def Connect.launch_app(path)
		# Send a 'launch' event to an application. If application is not already running, it will be launched in background first.
		begin
			# If app is already running, calling AE.launch_application will send a 'reopen' event, so need to check for this first:
			psn = AE.psn_for_application_path(path)
		rescue AE::MacOSError => err
			if err.to_i == -600 # Application isn't running, so launch it and send it a 'launch' event
				sleep(1)
				AE.launch_application(path, LaunchEvent,  
						LaunchContinue + LaunchNoFileFlags + LaunchDontSwitch)
			else
				raise
			end
		else # App is already running, so send it a 'launch' event
			Send::Event.new(make_address_desc(psn), 'ascrnoop').send(60, KAE::KAENoReply)
		end
	end
	
	def Connect.is_running?(path)
		# Is a local application running?
		begin
			AE.psn_for_application_path(path)
			return true
		rescue AE::MacOSError => err
			if err.to_i == -600
				return false
			else
				raise
			end
		end
	end
	
	CurrentApp = make_address_desc([0, KCurrentProcess])
	
	def Connect.local_app(path)
		# Make an AEAddressDesc identifying a local application. (Application will be launched if not already running.)
		#	path : string -- full path to application, e.g. '/Applications/TextEdit.app'
		#	Result : AEAddressDesc
		#
		# Always creates AEAddressDesc by process serial number; that way there's no confusion if multiple versions of the same app are running.
		begin
			psn = AE.psn_for_application_path(path)
		rescue AE::MacOSError => err
			if err.to_i == -600 # Application isn't running, so launch it in background and send it a standard 'run' event.
				sleep(1)
				psn = AE.launch_application(path, RunEvent,  
						LaunchContinue + LaunchNoFileFlags + LaunchDontSwitch)
			else
				raise
			end
		end
		return make_address_desc(psn)
	end
	
	def Connect.local_app_by_pid(pid)
		# Make an AEAddressDesc identifying a running application by Unix process id.
		#	pid : integer -- unsigned 32-bit integer
		#	Result : AEAddressDesc
		return AE::AEDesc.new(KAE::TypeKernelProcessID, [pid].pack('L'))
	end
	
	def Connect.remote_app(url)
		# Make an AEAddressDesc identifying a running application on another machine.
		#	url : string -- URL for remote application, e.g. 'eppc://user:password@0.0.0.1/TextEdit'
		#	Result : AEAddressDesc
		return AE::AEDesc.new(KAE::TypeApplicationURL, url)
	end
end
