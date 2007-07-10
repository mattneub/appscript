#!/usr/bin/env ruby

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

# 1. "Hello world" in TextEdit:

require "appscript"
include Appscript

te = app('TextEdit')
te.activate
te.documents.end.make(:new => :document, :with_properties => {:text => "Hello World!\n"})


# 2. "Hello world" using StandardAdditions:

require "osax"
include OSAX

osax.display_dialog("Hello World")