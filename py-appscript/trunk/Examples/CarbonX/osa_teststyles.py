#!/usr/bin/env pythonw

from CarbonX.OSA import OSAComponentInstance
from Carbon.Cm import OpenDefaultComponent
from CarbonX.kAE import *
from CarbonX.kOSA import *
from aem import Codecs, AEType
from sys import exit
from pprint import pprint

codecs = Codecs()

ascr = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))


names = codecs.unpack(ascr.ASGetSourceStyleNames(kOSAModeNull))
values = codecs.unpack(ascr.ASGetSourceStyles())
#print `st.type, st.data`
pprint(zip(names, values))

values[0][AEType('ptsz')] = 42

ascr.ASSetSourceStyles(codecs.pack(values))
values = codecs.unpack(ascr.ASGetSourceStyles())
pprint(zip(names, values))