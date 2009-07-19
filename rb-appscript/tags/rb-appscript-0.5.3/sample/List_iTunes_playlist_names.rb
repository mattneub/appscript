#!/usr/bin/env ruby

# List names of playlists in iTunes.

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

p app('iTunes').sources[1].user_playlists.name.get