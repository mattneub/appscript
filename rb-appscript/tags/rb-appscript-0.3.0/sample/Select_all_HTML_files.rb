#!/usr/bin/env ruby

# Selects all .htm/.html files in the top Finder window.

require "appscript"
include Appscript

finder = app('Finder')
finder.activate
folder = finder.Finder_windows[1].target.get
folder.files[its.name_extension.is_in(['htm', 'html'])].select