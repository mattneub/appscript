#!/usr/bin/env ruby

# Hello world in TextEdit.

require "appscript"

te = AS.app('TextEdit')
te.activate
te.documents.end.make(:new => :document, :with_properties => {:text => "Hello World!\n"})
