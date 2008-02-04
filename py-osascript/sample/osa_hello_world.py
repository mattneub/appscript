#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem import Codecs

# create an aem Codecs instance to pack and unpack AEDescs
codecs = Codecs()

# open an AppleScript component instance, and wrap it in an OSAComponentInstance to provide the OSA API (clumsy arrangement, but it does the job)
osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

# define some AppleScript source code
script = '''
set s to "hello" & space & "world"
say s using "Zarvox"
return s
'''

# pack source code into an AEDesc
scriptDesc = codecs.pack(script)

# compile and run script, returning its result
resultDesc = osac.OSADoScript(scriptDesc, 0, typeChar, 0)
# unpack result
print `codecs.unpack(resultDesc)` # '"hello world"'