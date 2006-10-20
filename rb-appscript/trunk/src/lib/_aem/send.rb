#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module Send

	require "ae"
	require "kae"
	require "_aem/codecs"
	
	MacOSErrorDescriptions = { # Following default error descriptions are mostly cribbed from AppleScript Language Guide.
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
			# Application scripting errors
			-10000 => "Apple event handler failed.",
			-10001 => "errAETypeError",
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
			-10023 => "errAENotAnEnumMember",
			-10024 => "errAECantPutThatThere",
			-10025 => "errAEPropertiesClash",
	}
	
	CocoaErrorDescriptions = [
			["NSReceiverEvaluationScriptError", "The object or objects specified by the direct parameter to a command could not be found."],
			["NSKeySpecifierEvaluationScriptError", "The object or objects specified by a key (for commands that support key specifiers) could not be found."],
			["NSArgumentEvaluationScriptError", "The object specified by an argument could not be found."],
			["NSReceiversCantHandleCommandScriptError", "The receivers don't support the command sent to them."],
			["NSRequiredArgumentsMissingScriptError", "An argument (or more than one argument) is missing."],
			["NSArgumentsWrongScriptError", "An argument (or more than one argument) is of the wrong type or is otherwise invalid."],
			["NSUnknownKeyScriptError", "An unidentified error occurred; indicates an error in the scripting support of your application."],
			["NSInternalScriptError", "An unidentified internal error occurred; indicates an error in the scripting support of your application."],
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
	
	class Event
		attr_reader :AEM_event
	
		def initialize(address, event, params={}, atts={}, transaction=KAE::KAnyTransactionID, 
				returnID= KAE::KAutoGenerateReturnID, codecs=DefaultCodecs)
			@_eventCode = event
			@_codecs = codecs
			@AEM_event = _createAppleEvent(event[0, 4], event[-4, 4], address, returnID, transaction)
			atts.each {|key, value| @AEM_event.putAttr(key, codecs.pack(value))}
			params.each {|key, value| @AEM_event.putParam(key, codecs.pack(value))}
		end
		
		def _createAppleEvent(eventClass, eventID, target, returnID, transactionID)
			return AE::AEDesc.newAppleEvent(eventClass, eventID, target, returnID, transactionID)
		end
		
		def _sendAppleEvent(flags, timeout)
			return @AEM_event.send(flags, timeout)
		end
		
		def send(timeout=KAE::KAEDefaultTimeout, flags=KAE::KAEWaitReply)
			begin
				replyEvent = _sendAppleEvent(flags, timeout)
			rescue AE::MacOSError => err
				if not @_eventCode == 'aevtquit' and err.number == -609
					raise CommandError.new(err.number, err.message, nil)
				end
			else
				if replyEvent.type != KAE::TypeNull
					eventResult = {}
					replyEvent.length.times do |i|
						key, value = replyEvent.get(i + 1, KAE::TypeWildCard)
						eventResult[key] = value
					end
					if eventResult.has_key?(KAE::KeyErrorNumber)
						eNum = DefaultCodecs.unpack(eventResult[KAE::KeyErrorNumber])
						if eNum != 0
							eMsg = eventResult[KAE::KeyErrorString]
							if eMsg
								eMsg = DefaultCodecs.unpack(eMsg)
							end
							raise CommandError.new(eNum, eMsg, replyEvent)
						end
					end
					if eventResult.has_key?(KAE::KeyAEResult)
						return @_codecs.unpack(eventResult[KAE::KeyAEResult])
					end
				end
			end
		end
	end
	
	
	class CommandError < RuntimeError
		
		attr_reader :number, :message, :raw
		
		def initialize(number, message, raw)
			if message == nil
				message = MacOSErrorDescriptions[number]
			end
			if number > 0
				CocoaErrorDescriptions.each do |name, description|
					if message[0, name.length] == name
						message += " (#{description})"
						break
					end
				end
			end
			@number = number
			@message = message
			@raw = raw
		end
		
		def to_s
			if message
				return "CommandError\n\t\tOSERROR: #{number}\n\t\tMESSAGE: #{message}"
			else
				return "CommandError\n\t\tOSERROR: #{number}"
			end
		end
	end
end
