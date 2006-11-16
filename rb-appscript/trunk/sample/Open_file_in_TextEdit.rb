#!/usr/bin/env ruby

# Opens a file in TextEdit. (Demonstrates mactypes module usage.)

require "appscript"

AS.app('TextEdit').open(MacTypes::Alias.path('/Users/NAME/ReadMe.txt'))