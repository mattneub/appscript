#!/usr/bin/env python3

# Rearranges Finder windows diagonally across screen with title bars one above
# another.
# 
# (Could be adapted to work with any scriptable application that defines a
#standard window class.)

from appscript import *

x, y = 0, 44
offset  = 22

for window in app('Finder').windows.get()[::-1]:
    x1, y1, x2, y2 = window.bounds.get()
    window.bounds.set((x, y, x2 - x1 + x, y2 - y1 + y))
    x += offset
    y += offset