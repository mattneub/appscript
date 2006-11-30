#!/usr/bin/env ruby

# Set iChat's status message to the name of the currently selected
# iTunes track.
#
# Based on an AppleScript example from:
# <http://developer.apple.com/cocoa/applescriptforapps.html>

require "appscript"
include Appscript

begin
	track_name = app("iTunes").current_track.name.get
rescue CommandError => e
	if e.to_i == -1728 # Can't get reference.
		track_name = 'No track selected.'
	else
		raise
	end
end
app("iChat").status_message.set(track_name)