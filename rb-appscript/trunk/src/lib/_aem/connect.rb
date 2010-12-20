#
# rb-appscript
#
# connect -- launch applications and create AEAddressDescs
#

module Connect
	# Creates Apple event descriptor records of typeProcessSerialNumber, typeKernelProcessID and typeApplicationURL, used to specify the target application in Send::Event constructor.
	
	require "ae"
	require "kae"
	require "_aem/codecs"
	require "_aem/send"
	require "_aem/encodingsupport"
	
	@@encoding_support = AEMEncodingSupport.encoding_support
	
	LSLaunchDefaults = 0x00000001
	LSLaunchAndPrint = 0x00000002
	LSLaunchReserved2 = 0x00000004
	LSLaunchReserved3 = 0x00000008
	LSLaunchReserved4 = 0x00000010
	LSLaunchReserved5 = 0x00000020
	LSLaunchAndDisplayErrors = 0x00000040
	LSLaunchInhibitBGOnly = 0x00000080
	LSLaunchDontAddToRecents = 0x00000100
	LSLaunchDontSwitch = 0x00000200
	LSLaunchNoParams = 0x00000800
	LSLaunchAsync = 0x00010000
	LSLaunchStartClassic = 0x00020000
	LSLaunchInClassic = 0x00040000
	LSLaunchNewInstance = 0x00080000
	LSLaunchAndHide = 0x00100000
	LSLaunchAndHideOthers = 0x00200000
	LSLaunchHasUntrustedContents = 0x00400000
	
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
	
	class CantLaunchApplicationError < RuntimeError
	
		# Taken from <http://developer.apple.com/documentation/Carbon/Reference/LaunchServicesReference>:
		LSErrors = {
			-10660 => "The application cannot be run because it is inside a Trash folder.",
			-10810 => "An unknown error has occurred.",
			-10811 => "The item to be registered is not an application.",
			-10813 => "Data of the desired type is not available (for example, there is no kind string).",
			-10814 => "No application in the Launch Services database matches the input criteria.",
			-10817 => "Data is structured improperly (for example, an item's information property list is malformed).",
			-10818 => "A launch of the application is already in progress.",
			-10822 => "There is a problem communicating with the server process that maintains the Launch Services database.",
			-10823 => "The filename extension to be hidden cannot be hidden.",
			-10825 => "The application to be launched cannot run on the current Mac OS version.",
			-10826 => "The user does not have permission to launch the application (on a managed network).",
			-10827 => "The executable file is missing or has an unusable format.",
			-10828 => "The Classic emulation environment was required but is not available.",
			-10829 => "The application to be launched cannot run simultaneously in two different user sessions.",
		}
	
		def initialize(error_number)
			@error_number = error_number
			super("#{ LSErrors.fetch(@error_number, 'OS error') } (#{ @error_number })")
		end
		
		def to_i
			return @error_number
		end
	end
	
	##
	
	def Connect.launch_application(path, event)
		path = @@encoding_support.to_utf8_string(path)
		begin
			return AE.launch_application(path, event,
					LSLaunchNoParams | LSLaunchStartClassic | LSLaunchDontSwitch)
		rescue AE::MacOSError => err
			raise CantLaunchApplicationError, err.to_i
		end
	end
	
	def Connect.launch_app_with_launch_event(path)
		# Send a 'launch' event to an application. If application is not already running, it will be launched in background first.
		path = @@encoding_support.to_utf8_string(path)
		begin
			# If app is already running, calling AE.launch_application will send a 'reopen' event, so need to check for this first:
			psn = AE.psn_for_application_path(path)
		rescue AE::MacOSError => err
			if err.to_i == -600 # Application isn't running, so launch it and send it a 'launch' event
				sleep(1)
				launch_application(path, LaunchEvent)
			else
				raise
			end
		else # App is already running, so send it a 'launch' event
			Send::Event.new(make_address_desc(psn), 'ascrnoop').send(60, KAE::KAENoReply)
		end
	end
	
	##
	
	def Connect.process_exists_for_path?(path)
		path = @@encoding_support.to_utf8_string(path)
		# Does a local process launched from the specified application file exist?
		# Note: if path is invalid, an AE::MacOSError is raised.
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

	def Connect.process_exists_for_pid?(pid)
		# Is there a local application process with the given unix process id?
		begin
			AE.psn_for_process_id(pid)
			return true
		rescue AE::MacOSError => err
			if err.to_i == -600
				return false
			else
				raise
			end
		end
	end
	
	def Connect.process_exists_for_url?(url)
		# Does an application process specified by the given eppc:// URL exist?
		# Note: this will send a 'launch' Apple event to the target application.
		raise ArgumentError, "Invalid url: #{url}" if not url.include?(':') # workaround: process will crash if no colon in URL (OS bug)
		return process_exists_for_desc?(AE::AEDesc.new(KAE::TypeApplicationURL, url))
	end
	
	def Connect.process_exists_for_desc?(desc)
		# Does an application process specified by the given AEAddressDesc exist?
		# Returns false if process doesn't exist OR remote Apple events aren't allowed.
		# Note: this will send a 'launch' Apple event to the target application.
		begin
			# This will usually raise error -1708 if process is running, and various errors
			# if the process doesn't exist/can't be reached. If app is running but busy,
			# AESendMessage may return a timeout error (this should be -1712, but
			# -609 is often returned instead for some reason).
			Send::Event.new(desc, 'ascrnoop').send
		rescue Send::EventError => err
			return (not [-600, -905].include?(err.to_i)) # not running/no network access
		end
		return true
	end
	
	##
	
	CurrentApp = make_address_desc([0, KCurrentProcess])
	
	def Connect.local_app(path)
		# Make an AEAddressDesc identifying a local application. (Application will be launched if not already running.)
		#	path : string -- full path to application, e.g. '/Applications/TextEdit.app'
		#	Result : AEAddressDesc
		#
		# Always creates AEAddressDesc by process serial number; that way there's no confusion if multiple versions of the same app are running.
		path = @@encoding_support.to_utf8_string(path)
		begin
			psn = AE.psn_for_application_path(path)
		rescue AE::MacOSError => err
			if err.to_i == -600 # Application isn't running, so launch it in background and send it a standard 'run' event.
				sleep(1)
				psn = launch_application(path, RunEvent)
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
		url = @@encoding_support.to_utf8_string(url)
		# Make an AEAddressDesc identifying a running application on another machine.
		#	url : string -- URL for remote application, e.g. 'eppc://user:password@0.0.0.1/TextEdit'
		#	Result : AEAddressDesc
		raise ArgumentError, "Invalid url: #{url}" if not url.include?(':') # workaround: process will crash if no colon in URL (OS bug)
		return AE::AEDesc.new(KAE::TypeApplicationURL, url)
	end
end
