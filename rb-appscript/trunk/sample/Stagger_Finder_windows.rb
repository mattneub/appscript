#!/usr/bin/env ruby

# Rearranges Finder windows diagonally across screen with title bars one above another. (Could easily be made to work with any scriptable application that uses standard window class terminology.)

require "appscript"

x, y = 0, 44
offset  = 22

window_list = AS.app('Finder').windows.get

window_list.reverse.each do |window|
    x1, y1, x2, y2 = window.bounds.get
    window.bounds.set([x, y, x2 - x1 + x, y2 - y1 + y])
    x += offset
    y += offset
end