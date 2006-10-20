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
	
	def Connect.makeAddressDesc(psn)
		return AE::AEDesc.new(KAE::TypeProcessSerialNumber, psn.pack('LL'))
	end
	
	NullAddress = makeAddressDesc([0,KNoProcess])
	LaunchEvent = Send::Event.new(Connect::NullAddress, 'ascrnoop').AEM_event
	RunEvent = Send::Event.new(Connect::NullAddress, 'aevtoapp').AEM_event
	
	#######
	# public
	
	def Connect.launchApp(path)
		begin
			psn = AE.psnForApplicationPath(path)
		rescue AE::MacOSError => err
			if err.number == -600
				sleep(1)
				AE.launchApplication(path, LaunchEvent,  
						LaunchContinue + LaunchNoFileFlags + LaunchDontSwitch)
			else
				raise
			end
		else
			Send::Event.new(makeAddressDesc(psn), 'ascrnoop').send()
		end
	end
	
	def Connect.running?(path)
		begin
			AE.psnForApplicationPath(path)
			return true
		rescue AE::MacOSError => err
			if err.number == -600
				return false
			else
				raise
			end
		end
	end
	
	CurrentApp = makeAddressDesc([0, KCurrentProcess])
	
	def Connect.localApp(path)
		begin
			psn = AE.psnForApplicationPath(path)
		rescue AE::MacOSError => err
			if err.number == -600
				sleep(1)
				psn = AE.launchApplication(path, RunEvent,  
						LaunchContinue + LaunchNoFileFlags + LaunchDontSwitch)
			else
				raise
			end
		end
		return makeAddressDesc(psn)
	end
	
	def Connect.localAppByPID(pid)
		return makeAddressDesc(AE.pidToPsn(pid))
	end
	
	def Connect.remoteApp(url)
		return AE::AEDesc.new(KAE::TypeApplicationURL, url)
	end
end
