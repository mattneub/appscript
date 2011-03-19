#
# rb-appscript
#
# send -- Event class represents a packed AppleEvent that's ready to send via AESendMessage
#

module Send

	# Defines the Event class, which represents an Apple event that's packed and ready to send, 
	# and the EventError class, which contains error information for a failed event.

	require "ae"
	require "kae"
	require "_aem/codecs"
	
	class Event
		# Represents an Apple event.
		
		# Clients don't instantiate this class directly; instead, new instances are returned by AEM::Application#event.
		
		attr_reader :AEM_event
	
		def initialize(address, event_code, params={}, atts={}, transaction=KAE::KAnyTransactionID, 
				return_id= KAE::KAutoGenerateReturnID, codecs=DefaultCodecs)
			# Create and pack a new Apple event ready for sending.
			# address : AEAddressDesc -- the target application, identified by PSN, URL, etc.
			# event_code : string -- 8-letter code indicating event's class and id, e.g. 'coregetd'
			# params : hash -- a hash of form {AE_code=>anything,...} containing zero or more event parameters (message arguments)
			# atts : hash -- a hash of form {AE_code=>anything,...} containing zero or more event attributes (event info)
			# transaction : integer -- transaction number; AEM::Application takes care of this value
			# return_id : integer  -- reply event's ID
			# codecs : Codecs -- clients can provide custom Codecs object for packing parameters and unpacking result of this event
			@_event_code = event_code
			@_codecs = codecs
			@AEM_event = _create_apple_event(event_code[0, 4], event_code[-4, 4], address, return_id, transaction)
			atts.each {|key, value| @AEM_event.put_attr(key, codecs.pack(value))}
			params.each {|key, value| @AEM_event.put_param(key, codecs.pack(value))}
		end
		
		def _create_apple_event(event_class, event_id, target, return_id, transaction_id)
			# Hook method; may be overridden to customise how AppleEvent descriptors are created.
			return AE::AEDesc.new_apple_event(event_class, event_id, target, return_id, transaction_id)
		end
		
		def _send_apple_event(flags, timeout)
			# Hook method; may be overridden to customise how events are sent.
			return @AEM_event.send_thread_safe(flags, timeout)
		end
		
		def inspect
			return "#<AEM::Event @code=#{@_event_code}>"
		end
		
		alias_method :to_s, :inspect
		
		def send(timeout=KAE::KAEDefaultTimeout, flags=KAE::KAECanSwitchLayer + KAE::KAEWaitReply)
			# Send this Apple event (may be called any number of times).
			# timeout : int | KAEDefaultTimeout | KNoTimeOut -- number of ticks to wait for target process to reply before raising timeout error
			# flags : integer -- bitwise flags [1] indicating how target process should handle event
			# Result : anything -- value returned by application, if any
			#
			# [1] Should be the sum of zero or more of the following kae module constants:
			#
			#	KAENoReply | KAEQueueReply | KAEWaitReply
			#	KAEDontReconnect
			#	KAEWantReceipt
			#	KAENeverInteract | KAECanInteract | KAEAlwaysInteract
			#	KAECanSwitchLayer

			begin
				reply_event = _send_apple_event(flags, timeout)
			rescue AE::MacOSError => err # The Apple Event Manager raised an error.
				if not(@_event_code == 'aevtquit' and err.to_i == -609) # Ignore invalid connection errors (-609) when quitting
					raise EventError.new(err.to_i)
				end
			else # Decode application's reply, if any. May be a return value, error number (and optional message), or nothing.
				if reply_event.type != KAE::TypeNull
					event_result = {}
					reply_event.length.times do |i|
						key, value = reply_event.get_item(i + 1, KAE::TypeWildCard)
						event_result[key] = value
					end
					if event_result.has_key?(KAE::KeyErrorNumber) # The application raised an error.
						# Error info is unpacked using default codecs for reliability.
						e_num = DefaultCodecs.unpack(event_result[KAE::KeyErrorNumber])
						if e_num != 0 # Some apps (e.g. Finder) may return error code 0 to indicate a successful operation, so ignore this.
							raise EventError.new(e_num, event_result)
						end
					end
					if event_result.has_key?(KAE::KeyAEResult)
						# Return values are unpacked using [optionally] client-supplied codecs.
						# This allows aem clients such as appscript to customise how values are unpacked
						# (e.g. to unpack object specifier descs as appscript references instead of aem references).
						return @_codecs.unpack(event_result[KAE::KeyAEResult])
					end
				end
			end
		end
	end
	
	
	class EventError < RuntimeError
		# Represents an error raised by the Apple Event Manager or target application when a command fails.
		#
		# Methods:
		#	number : integer -- MacOS error number
		#	message : string -- application error message if any, or default error description if available
		
		# Most applications don't provide error description strings, so define default descriptions for the common ones.
		# Following default error descriptions are cribbed from the AppleScript Language Guide/MacErrors.h:
		
		MacOSErrorDescriptions = {
				# OS errors
				-34 => "Disk is full.",
				-35 => "Disk wasn't found.",
				-37 => "Bad name for file.",
				-38 => "File wasn't open.",
				-39 => "End of file error.",
				-42 => "Too many files open.",
				-43 => "File wasn't found.",
				-44 => "Disk is write protected.",
				-45 => "File is locked.",
				-46 => "Disk is locked.",
				-47 => "File is busy.",
				-48 => "Duplicate file name.",
				-49 => "File is already open.",
				-50 => "Parameter error.",
				-51 => "File reference number error.",
				-61 => "File not open with write permission.",
				-108 => "Out of memory.",
				-120 => "Folder wasn't found.",
				-124 => "Disk is disconnected.",
				-128 => "User canceled.",
				-192 => "A resource wasn't found.",
				-600 => "Application isn't running.",
				-601 => "Not enough room to launch application with special requirements.",
				-602 => "Application is not 32-bit clean.",
				-605 => "More memory is needed than is specified in the size resource.",
				-606 => "Application is background-only.",
				-607 => "Buffer is too small.",
				-608 => "No outstanding high-level event.",
				-609 => "Connection is invalid.",
				-904 => "Not enough system memory to connect to remote application.",
				-905 => "Remote access is not allowed.",
				-906 => "Application isn't running or program linking isn't enabled.",
				-915 => "Can't find remote machine.",
				-30720 => "Invalid date and time.",
				# AE errors
				-1700 => "Can't make some data into the expected type.",
				-1701 => "Some parameter is missing for command.",
				-1702 => "Some data could not be read.",
				-1703 => "Some data was the wrong type.",
				-1704 => "Some parameter was invalid.",
				-1705 => "Operation involving a list item failed.",
				-1706 => "Need a newer version of the Apple Event Manager.",
				-1707 => "Event isn't an Apple event.",
				-1708 => "Application could not handle this command.",
				-1709 => "AEResetTimer was passed an invalid reply.",
				-1710 => "Invalid sending mode was passed.",
				-1711 => "User canceled out of wait loop for reply or receipt.",
				-1712 => "Apple event timed out.",
				-1713 => "No user interaction allowed.",
				-1714 => "Wrong keyword for a special function.",
				-1715 => "Some parameter wasn't understood.",
				-1716 => "Unknown Apple event address type.",
				-1717 => "The handler is not defined.",
				-1718 => "Reply has not yet arrived.",
				-1719 => "Can't get reference. Invalid index.",
				-1720 => "Invalid range.",
				-1721 => "Wrong number of parameters for command.",
				-1723 => "Can't get reference. Access not allowed.",
				-1725 => "Illegal logical operator called.",
				-1726 => "Illegal comparison or logical.",
				-1727 => "Expected a reference.",
				-1728 => "Can't get reference.",
				-1729 => "Object counting procedure returned a negative count.",
				-1730 => "Container specified was an empty list.",
				-1731 => "Unknown object type.",
				-1739 => "Attempting to perform an invalid operation on a null descriptor.",
				# Application scripting errors
				-10000 => "Apple event handler failed.",
				-10001 => "Type error.",
				-10002 => "Invalid key form.",
				-10003 => "Can't set reference to given value. Access not allowed.",
				-10004 => "A privilege violation occurred.",
				-10005 => "The read operation wasn't allowed.",
				-10006 => "Can't set reference to given value.",
				-10007 => "The index of the event is too large to be valid.",
				-10008 => "The specified object is a property, not an element.",
				-10009 => "Can't supply the requested descriptor type for the data.",
				-10010 => "The Apple event handler can't handle objects of this class.",
				-10011 => "Couldn't handle this command because it wasn't part of the current transaction.",
				-10012 => "The transaction to which this command belonged isn't a valid transaction.",
				-10013 => "There is no user selection.",
				-10014 => "Handler only handles single objects.",
				-10015 => "Can't undo the previous Apple event or user action.",
				-10023 => "Enumerated value is not allowed for this property.",
				-10024 => "Class can't be an element of container.",
				-10025 => "Illegal combination of properties settings.",
		}
		
		# Following Cocoa Scripting error descriptions taken from:
		# http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/NSScriptCommand.html
		# http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/NSScriptObjectSpecifier.html
	
		CocoaErrorDescriptions = [
				["NSReceiverEvaluationScriptError", "The object or objects specified by the direct parameter to a command could not be found."],
				["NSKeySpecifierEvaluationScriptError", "The object or objects specified by a key (for commands that support key specifiers) could not be found."],
				["NSArgumentEvaluationScriptError", "The object specified by an argument could not be found."],
				["NSReceiversCantHandleCommandScriptError", "The receivers don't support the command sent to them."],
				["NSRequiredArgumentsMissingScriptError", "An argument (or more than one argument) is missing."],
				["NSArgumentsWrongScriptError", "An argument (or more than one argument) is of the wrong type or is otherwise invalid."],
				["NSUnknownKeyScriptError", "An unidentified error occurred; indicates an error in the scripting support of the application."],
				["NSInternalScriptError", "An unidentified internal error occurred; indicates an error in the scripting support of the application."],
				["NSOperationNotSupportedForKeyScriptError", "The implementation of a scripting command signaled an error."],
				["NSCannotCreateScriptCommandError", "Could not create the script command; an invalid or unrecognized Apple event was received."],
				["NSNoSpecifierError", "No error encountered."],
				["NSNoTopLevelContainersSpecifierError", "Someone called evaluate with nil."],
				["NSContainerSpecifierError", "Error evaluating container specifier."],
				["NSUnknownKeySpecifierError", "Receivers do not understand the key."],
				["NSInvalidIndexSpecifierError", "Index out of bounds."],
				["NSInternalSpecifierError", "Other internal error."],
				["NSOperationNotSupportedForKeySpecifierError", "Attempt made to perform an unsupported operation on some key."]
		]
		
		attr_reader :number, :raw
		alias_method :to_i, :number
		
		def initialize(number, reply_params={})
			@number = number
			@message = nil
			@raw = reply_params
		end
		
		def message
			if not @message
				desc = @raw[KAE::KeyErrorString]
				@message = DefaultCodecs.unpack(desc) if desc
				if @message.is_a?(String) and @number > 0
					# add clarification to default Cocoa Scripting error messages
					CocoaErrorDescriptions.each do |name, description|
						if @message[0, name.length] == name
							@message += " (#{description})"
							break
						end
					end
				end
				# if no message supplied or is a MacOSError, use default message if one is available
				@message = MacOSErrorDescriptions.fetch(number, '') if @message == nil
			end
			return @message
		end
		
		def to_s
			if message != ''
				return "EventError\n\t\tOSERROR: #{number}\n\t\tMESSAGE: #{message}"
			else
				return "EventError\n\t\tOSERROR: #{number}"
			end
		end
		
		# extended error info (some apps may return additional error info, though most don't)
		
		def offending_object
			desc = @raw[KAE::KOSAErrorOffendingObject]
			return desc ? DefaultCodecs.unpack(desc) : nil
		end
		
		def expected_type
			desc = @raw[KAE::KOSAErrorExpectedType]
			return desc ? DefaultCodecs.unpack(desc) : nil
		end
		
		def partial_result
			desc = @raw[KAE::KOSAErrorPartialResult]
			return desc ? DefaultCodecs.unpack(desc) : nil
		end
	end
end
