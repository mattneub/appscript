#!/usr/bin/env ruby

# List names of playlists in iTunes.

require "appscript"

p AS.app('iTunes').sources[1].user_playlists.name.get