#!/usr/bin/env ruby

# Selects all .htm/.html files in the top Finder window.

require "appscript"
include Appscript

w = app('Finder').Finder_windows[1].target.get
w.files[its.name_extension.is_in(['htm', 'html'])].select