#!/usr/bin/env pythonw

from aem import *

c = Codecs()

ref = app.elements('docu').byindex(1).property('ctxt')
print ref # -> app.elements('docu').byindex(1).property('ctxt')
print c.pack(ref) # -> <_AE.AEDesc object at ...>
print c.unpack(c.pack(ref)) # -> same as ref
print c.unpack(c.pack(ref)) == ref # -> True