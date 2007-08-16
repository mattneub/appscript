#!/usr/local/bin/ruby

require 'appscript'
include Appscript

help_agent = AEM::Application.by_path(FindApp.by_id('net.sourceforge.appscript.appscripthelpagent'))
help_agent.event('aevtquit').send