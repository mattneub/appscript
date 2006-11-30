#!/usr/bin/env ruby

# Opens a file in TextEdit. (Demonstrates mactypes module usage.)

require "appscript"
include Appscript

te = app('TextEdit')
te.activate
te.open(MacTypes::Alias.path('/Users/USERNAME/ReadMe.txt'))