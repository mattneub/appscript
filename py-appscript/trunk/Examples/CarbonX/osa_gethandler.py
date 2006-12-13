#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from CarbonX.OSA import OSAComponentInstance
from CarbonX.kOSA import *
from CarbonX.kAE import *
from aem import Codecs, AEEventName

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


print `codecs.unpack(osac.OSAGetHandlerNames(kOSAModeNull, scriptID))`

i = osac.OSAGetHandler(kOSAModeNull, scriptID, codecs.pack(AEEventName('aevtodoc')))
print i, `codecs.unpack(osac.OSADisplay(i, typeWildCard, kOSAModeNull))`

print `codecs.unpack(osac.OSAGetPropertyNames(kOSAModeNull, scriptID))`

o = osac.OSAGetProperty(kOSAModeNull, scriptID, codecs.pack('bar'))
print `codecs.unpack(osac.OSACoerceToDesc(o, typeWildCard, 0))`

