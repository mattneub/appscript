#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem import Codecs
from sys import exit

# create an aem Codecs instance to pack and unpack AEDescs
codecs = Codecs()

# open an AppleScript component instance, and wrap it in an OSAComponentInstance to provide the OSA API (clumsy arrangement, but it does the job)
scpt = OSAComponentInstance(OpenDefaultComponent('osa ', 'scpt'))
ascr = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

#print `codecs.unpack(osac.OSAScriptingComponentName())`

#print `codecs.unpack(scpt.ASGetSourceStyleNames(kOSAModeNull))`

#osac.OSASetDefaultScriptingComponent('McPy')

#print `osac.OSAGetDefaultScriptingComponent()`

#exit()
#print dir(OpenDefaultComponent('osa ', 'scpt'))

id = scpt.OSACompile(codecs.pack('2+2'), 0, 0)

id = scpt.OSACompile(codecs.pack('2+2'), 0, 0)


id2, ascr2 = scpt.OSAGenericToRealID(id)
print id2, codecs.unpack(ascr2.OSAScriptingComponentName())

print ascr2.OSAExecute(id2, 0,0)

id3 = scpt.OSARealToGenericID(id2, ascr2)

r = scpt.OSAExecute(id3, 0,0)
print `codecs.unpack(scpt.OSADisplay(r, typeBest, 0))`

print 'Done.'