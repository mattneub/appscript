#!/usr/bin/env ruby

# Hello world in TextEdit.

require "appscript"
include Appscript

te = app('TextEdit')
te.activate
te.documents.end.make(:new => :document, :with_properties => {:text => "Hello World!\n"})
