#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.
	
module Connect
	
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
		begin
			psn = AE.psn_for_application_path(path)
		rescue AE::MacOSError => err
			if err.to_i == -600
				sleep(1)
				AE.launch_application(path, LaunchEvent,  
						LaunchContinue + LaunchNoFileFlags + LaunchDontSwitch)
			else
				raise
			end
		else
			Send::Event.new(make_address_desc(psn), 'ascrnoop').send()
		end
	end
	
	def Connect.running?(path)
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
		begin
			psn = AE.psn_for_application_path(path)
		rescue AE::MacOSError => err
			if err.to_i == -600
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
		return make_address_desc(AE.pid_to_psn(pid))
	end
	
	def Connect.remote_app(url)
		return AE::AEDesc.new(KAE::TypeApplicationURL, url)
	end
end
