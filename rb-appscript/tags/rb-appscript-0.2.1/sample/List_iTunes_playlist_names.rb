#!/usr/bin/env ruby

# List names of playlists in iTunes.

require "appscript"
include Appscript

p app('iTunes').sources[1].user_playlists.name.get