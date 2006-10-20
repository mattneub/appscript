#!/usr/bin/env ruby

# Compose an outgoing message in Apple's Mail.app.

require "appscript"

def makeMessage(addresses, subject, content, showWindow=false)
	# Make an outgoing message in Mail.
	# 	addresses : list of unicode -- a list of email addresses
	# 	subject : unicode -- the message subject
	# 	content : unicode -- the message content
	# 	showWindow : Boolean -- show message window in Mail
	# Result : reference -- reference to the new outgoing message
	mail = AS.app('Mail')
	msg = mail.make(
			:new => :outgoing_message, 
			:with_properties => {:visible => showWindow})
	addresses.each do |anAddress|
		msg.to_recipients.end.make(
				:new => :recipient, 
				:with_properties => {:address => anAddress})
	end
	msg.subject.set(subject)
	msg.content.set(content)
	return msg
end

# test
p makeMessage(['joe@foo.com', 'jane@bar.net'], 'Hello World', 'Some body text.', true)
