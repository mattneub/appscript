#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem import Codecs, Application

codecs = Codecs()

osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))


scriptDesc = codecs.pack('''
on run
	beep 3
	return {"hello", "world"}
end

on open x
	beep 2
	return reverse of x
end
''')



scriptID = osac.OSACompile(scriptDesc, kOSAModeCompileIntoContext, 0)

print 'SOURCE:', `codecs.unpack(osac.OSAGetSource(scriptID, typeUnicodeText))`

print

event1 = Application().event('aevtoapp', {}).AEM_event
resultID = osac.OSAExecuteEvent(event1, scriptID, kOSAModeNull)

print 'DISPLAY:', `codecs.unpack(osac.OSADisplay(resultID, typeWildCard, 0))` # u'{"hello", "world"}'

print 'RESULT:', `codecs.unpack(osac.OSACoerceToDesc(resultID, typeWildCard, 0))` # ['hello', 'world']

print

event2 = Application().event('aevtodoc', {'----': [1, 2, 3]}).AEM_event
replyEvent = Application().event('aevtansr').AEM_event
osac.OSADoEvent(event2, scriptID, kOSAModeNull, replyEvent)

print 'REPLY EVENT:', `codecs.unpack(replyEvent.AECoerceDesc(typeAERecord))` # {aem.AEType('----'): [3, 2, 1]}