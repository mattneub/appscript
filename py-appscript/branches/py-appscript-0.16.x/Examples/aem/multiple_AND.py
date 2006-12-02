#!/usr/bin/env pythonw

from aem import *

c=Codecs()

r = its.property('size').ne(2).AND(its.property('name').ne(''), its.elements('item').ne([]))

print c.unpack(c.pack(r))


# TO FIX: these should really all return True
print r == c.unpack(c.pack(r)) # False (but they are equivalent)
print its.eq(3) == its.eq(3) # True
print its.ne(3) == its.eq(3).NOT # False (but they are equivalent)
print its == its.eq(True) # False (but they are equivalent)

