#!/usr/local/bin/macruby

framework 'Appscript'

class String
	def to_ostype
		unpack('N')[0]
	end
end

fn = AEMApplication.alloc.initWithBundleID('com.apple.textedit')
puts fn.description
puts

# make new document
evt = fn.eventWithEventClass('core'.to_ostype, eventID: 'crel'.to_ostype)


evt.setParameter(AEMType.typeWithCode('docu'.to_ostype), forKeyword:'kocl'.to_ostype)
puts evt.description
puts

p evt.sendWithError(nil)


# get every document
evt = fn.eventWithEventClass('core'.to_ostype, eventID: 'getd'.to_ostype)

ref = AEMApplicationRoot.applicationRoot.elements('docu'.to_ostype)
puts ref.description
puts

evt.setParameter(ref, forKeyword:'----'.to_ostype)
puts evt.description
puts

p evt.sendWithError(nil)