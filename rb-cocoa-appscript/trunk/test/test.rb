#!/usr/bin/ruby

require 'cocoa_appscript/appscript'
include RCAppscript





app_data = RCAppscript::RCAppData.alloc.initWithApplicationClass_constructor_identifier_terms_(
		RCAppscript::AEMApplication, RCAppscript::KASTargetName, 'TextEdit', true)

p app_data.reference_by_name[:documents]
puts
puts app_data.pack([RCAppscript::RCKeyword.new(:document), 33])
puts
p app_data.pack(RCAppscript::AS_Con.documents[1].text)
puts

puts RCAppscript.app('textedit').documents.get

puts RCAppscript.app('textedit').documents[1].text.get
