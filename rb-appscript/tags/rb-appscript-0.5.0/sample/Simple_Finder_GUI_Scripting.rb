#!/usr/bin/env ruby

# Opens a new Finder smart folder that searches for 'ruby', via GUI Scripting

# (Note: to use GUI Scripting, 'Enable access for assistive devices' option must
# be enabled in the Universal Access panel of System Preferences.)

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require 'appscript'
include Appscript

se = app('System Events')

app('Finder').activate
se.keystroke('n', :using=>[:command_down, :option_down])
se.keystroke('ruby')