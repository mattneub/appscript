#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem import Codecs, ae

codecs = Codecs()

osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

script = '''
property foo : 1
property bar : 42
property name : "hello"

on run
end

on open x
end

on baz()
end

on fub()
end
'''

scriptDesc = codecs.pack(script)

scriptID = osac.OSACompile(scriptDesc, kOSAModeCompileIntoContext, kOSANullScript)

def AEEventName(code):
	import struct
	if struct.pack("h", 1) == '\x00\x01': fcc = lambda code: code
	else: fcc = lambda code: code[::-1]
	return ae.AECreateDesc(cEventIdentifier, fcc(code[0:4]) + fcc(code[4:8]))


print `codecs.unpack(osac.OSAGetHandlerNames(kOSAModeNull, scriptID))`

i = osac.OSAGetHandler(kOSAModeNull, scriptID, codecs.pack(AEEventName('aevtodoc')))
print i, `codecs.unpack(osac.OSADisplay(i, typeWildCard, kOSAModeNull))`

print `codecs.unpack(osac.OSAGetPropertyNames(kOSAModeNull, scriptID))`

o = osac.OSAGetProperty(kOSAModeNull, scriptID, codecs.pack('bar'))
print `codecs.unpack(osac.OSACoerceToDesc(o, typeWildCard, 0))`

