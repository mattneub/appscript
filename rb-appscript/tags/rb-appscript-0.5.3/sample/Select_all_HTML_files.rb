#!/usr/bin/env ruby

# Selects all .htm/.html files in the top Finder window.

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

finder = app('Finder')
finder.activate
folder = finder.Finder_windows[1].target.get
folder.files[its.name_extension.is_in(['htm', 'html'])].select