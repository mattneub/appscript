#!/usr/bin/env ruby

# Opens a file in TextEdit. (Demonstrates mactypes module usage.)

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

te = app('TextEdit')
te.activate
te.open(MacTypes::Alias.path('/Users/USERNAME/ReadMe.txt'))