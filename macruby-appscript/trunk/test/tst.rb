#!/usr/local/bin/macruby

framework 'Appscript'

fn = AEMApplication.alloc.initWithBundleID('com.apple.textedit')
puts fn.description
puts

# make new document
evt = fn.eventWithEventClass('core'.unpack('N')[0], eventID: 'crel'.unpack('N')[0])


evt.setParameter(AEMType.typeWithCode('docu'.unpack('N')[0]), forKeyword:'kocl'.unpack('N')[0])
puts evt.description
puts

p evt.sendWithError(nil)


# get every document
evt = fn.eventWithEventClass('core'.unpack('N')[0], eventID: 'getd'.unpack('N')[0])

ref = AEMApplicationRoot.applicationRoot.elements('docu'.unpack('N')[0])
puts ref.description
puts

evt.setParameter(ref, forKeyword:'----'.unpack('N')[0])
puts evt.description
puts

p evt.sendWithError(nil)