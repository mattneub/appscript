#!/usr/bin/ruby

require 'cocoa_appscript/appscript'
require 'cocoa_appscript/kae'
include RCAppscript





app_data = RCAppscript::RCAppData.alloc.initWithApplicationClass_constructor_identifier_terms_(
		RCAppscript::AEMApplication, RCAppscript::KASTargetName, 'TextEdit', true)
app_data.connect		



d = app_data.pack({k.name=>k.document})
puts app_data.unpack(d)
puts

d = app_data.pack(k.document)
p app_data.unpack(d)
puts

p app_data.reference_by_name[:documents]
puts
puts app_data.pack([k.document, 33, "Hello"])
puts

d = app_data.pack({3=>4, AEMType.typeWithCode_(RCKAE::PName) => k.document, k.name=>1, k.document => 33, "Hello" => "World", AEMType.typeWithCode_(RCKAE::PName) => 5, 'goo' => RCAppscript::AS_Con.documents[1].text})
puts d

p app_data.pack(RCAppscript::AS_Con.documents[1].text)
puts

puts RCAppscript.app('textedit').documents.get

puts RCAppscript.app('textedit').documents[1].text.get

