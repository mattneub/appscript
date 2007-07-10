#!/usr/bin/env ruby

# Rearranges Finder windows diagonally across screen with title bars one above
# another. (Could easily be adapted to work with any scriptable application
# that uses standard window class terminology.)

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

x, y = 0, 44
offset  = 22

# Get list of window references, ignoring any minimised windows
window_list = app('Finder').windows[its.collapsed.not].get

# Move windows while preserving their original sizes
window_list.reverse.each do |window|
    x1, y1, x2, y2 = window.bounds.get
    window.bounds.set([x, y, x2 - x1 + x, y2 - y1 + y])
    x += offset
    y += offset
end