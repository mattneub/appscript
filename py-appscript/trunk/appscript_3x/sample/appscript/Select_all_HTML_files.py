#!/usr/bin/env python3

# Selects all .htm/.html files in the top Finder window.

from appscript import *

finder = app('Finder')

finder.activate()

w = finder.Finder_windows[1].target.get()
w.files[its.name_extension.isin(['htm', 'html'])].select()