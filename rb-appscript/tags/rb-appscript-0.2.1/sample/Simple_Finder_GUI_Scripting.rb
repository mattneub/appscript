#!/usr/bin/env ruby

require 'appscript'
include Appscript

# Opens a new Finder smart folder that searches for 'ruby', via GUI Scripting

# (Note: to use GUI Scripting, 'Enable access for assistive devices' option must
# be enabled in the Universal Access panel of System Preferences.)

se = app('System Events')

app('Finder').activate
se.keystroke('n', :using=>[:command_down, :option_down])
se.keystroke('ruby')