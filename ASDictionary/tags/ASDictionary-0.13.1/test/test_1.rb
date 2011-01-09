#!/usr/bin/ruby

require 'appscript'
include Appscript

Constructors = {
	:by_path => 'path',
	:by_pid => 'pid',
	:by_url => 'url',
	:by_aem_app => 'aemapp',
	:current => 'current',
}

te = app('TextEdit')

help_agent = AEM::Application.by_path(FindApp.by_id('net.sourceforge.appscript.asdictionary'))

ref = te.documents

app_data = te.AS_app_data

puts help_agent.event('AppSHelp', {
	'Cons' => Constructors[app_data.constructor],
	'Iden' => app_data.constructor == :by_aem_app ? app_data.identifier.address_desc : app_data.identifier,
	'Styl' => 'rb-appscript',
	'Flag' => '-t',
	'aRef' => app_data.pack(ref),
}).send
