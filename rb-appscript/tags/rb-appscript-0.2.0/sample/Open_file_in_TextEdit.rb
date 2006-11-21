#!/usr/bin/env ruby

# Opens a file in TextEdit. (Demonstrates mactypes module usage.)

require "appscript"

te = AS.app('TextEdit')
te.activate
te.open(MacTypes::Alias.path('/Users/USERNAME/ReadMe.txt'))