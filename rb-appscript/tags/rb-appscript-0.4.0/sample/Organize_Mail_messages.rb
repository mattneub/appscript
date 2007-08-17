#!/usr/bin/env ruby

# Set up a Mail mailbox folder for organising incoming emails from a 
# particular sender.
#
# Based on an AppleScript by Michelle Steiner.
#
# To use: in Mail, select an incoming email message from the desired sender
# (e.g. a mailing list), then run this script. The script will first make a
# new mailbox folder for storing messages from this sender if one doesn't
# already exist. It will then create a new Mail rule that automatically moves
# incoming messages from this sender directly into this mailbox.

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

mail = app('Mail')

# get the current selection in Mail and make sure it's an email message
selection = mail.selection.get

if  selection == [] or selection[0].class_.get != :message
	puts "Please select a message and try again."
	exit
end

# get a reference to the first selected message
msg = selection[0]

recipient = msg.to_recipients[1]
address = recipient.address.get

# determine the new mailbox's name based on the sender's name/address
if recipient.name.exists
	folder_name = recipient.name.get
else
	folder_name = /^[^@]*/.match(address)[0]
end

# make a new mailbox if one doesn't already exist
if not mail.mailboxes[folder_name].exists
	mail.mailboxes.end.make(:new=>:mailbox, :with_properties=>{
			:name=>folder_name})
end

# make a new mail rule to move list messages to the mailbox
if not mail.rules[folder_name].exists
	new_rule = mail.rules[1].after.make(:new=>:rule, :with_properties=>{
			:name=>folder_name, 
			:should_move_message=>true,
			:move_message=>app.mailboxes[folder_name],
			:stop_evaluating_rules=>true})
	new_rule.make(:new=>:rule_condition, :with_properties=>{
			:expression=>address,
			:rule_type=>:to_header,
			:qualifier=>:does_contain_value})
	new_rule.enabled.set(true)
end
