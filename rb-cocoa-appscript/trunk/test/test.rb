#!/usr/bin/ruby

require 'cocoa_appscript/appscript'
require 'cocoa_appscript/kae'
include RCAppscript



te = app('textedit')

te.make(:new => k.document, :with_properties => {k.text => 'Hello World'})

puts app('textedit').documents[1].text.get

puts te.documents.count

p app('textedit').documents.get.to_a

