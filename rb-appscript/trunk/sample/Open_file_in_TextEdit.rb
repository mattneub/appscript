#!/usr/bin/env ruby

# Opens a file in TextEdit. (Demonstrates macfile module usage.)

require "appscript"
require "macfile"

AS.app('TextEdit').open(MacFile::Alias.at('~/ReadMe.txt'))