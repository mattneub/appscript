#!/usr/bin/env ruby

# Compose an outgoing message in Apple's Mail.app.

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

def make_message(addresses, subject, content, show_window=false)
	# Make an outgoing message in Mail.
	# 	addresses : list of unicode -- a list of email addresses
	# 	subject : unicode -- the message subject
	# 	content : unicode -- the message content
	# 	show_window : Boolean -- show message window in Mail
	# Result : reference -- reference to the new outgoing message
	mail = app('Mail')
	msg = mail.make(
			:new => :outgoing_message, 
			:with_properties => {:visible => show_window})
	addresses.each do |an_address|
		msg.to_recipients.end.make(
				:new => :recipient, 
				:with_properties => {:address => an_address})
	end
	msg.subject.set(subject)
	msg.content.set(content)
	return msg
end

# test
p make_message(['joe@foo.com', 'jane@bar.net'], 'Hello World', 'Some body text.', true)
