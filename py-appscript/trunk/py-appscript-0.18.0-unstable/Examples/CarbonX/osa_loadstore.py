#!/usr/bin/env pythonw

from os.path import split, join

from Carbon.Cm import OpenDefaultComponent
from CarbonX.OSA import OSAComponentInstance
from CarbonX.kAE import *
from CarbonX.kOSA import *
from aem import Codecs

# create an aem Codecs instance to pack and unpack AEDescs
codecs = Codecs()

# open an AppleScript component instance, and wrap it in an OSAComponentInstance to provide the OSA API (clumsy arrangement, but it does the job)
osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

root = split(__file__)[0]
src = join(root, 'test.scpt')
dest = join(root, 'test_out.scpt')

id, storable = osac.OSALoadFile(src, kOSAModeNull)

print id, storable

print osac.OSAExecute(id, kOSANullScript, kOSAModeNull)

osac.OSAStoreFile(id, typeOSAGenericStorage, kOSAModeNull, dest)

print osac.OSALoadExecuteFile(src, kOSANullScript, kOSAModeNull)

print `codecs.unpack(osac.OSADoScriptFile(src, kOSANullScript, typeWildCard, kOSAModeNull))`

d = osac.OSAStore(id, typeOSAGenericStorage, kOSAModeNull)
print d

i = osac.OSALoadExecute(d, kOSANullScript, kOSAModeNull)
print i

print `codecs.unpack(osac.OSADisplay(i, typeWildCard, kOSAModeNull))`