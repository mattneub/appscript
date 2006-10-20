#!/usr/bin/env ruby

# Selects all .htm/.html files in the top Finder window.

require "appscript"

w = AS.app('Finder').Finder_windows[1].target.get
w.files[AS.its.name_extension.isin(['htm', 'html'])].select