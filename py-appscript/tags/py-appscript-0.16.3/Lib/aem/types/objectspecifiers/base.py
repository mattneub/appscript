"""base -- classes and functions shared by specifier and testclause

(C) 2006 HAS
"""

import struct

from CarbonX import AE, kAE

######################################################################
# PUBLIC
######################################################################

def packType(code):
	return AE.AECreateDesc(kAE.typeType, struct.pack("L", *struct.unpack(">L", code))) # ensure correct endianness

def packAbsoluteOrdinal(code): 
	return AE.AECreateDesc(kAE.typeAbsoluteOrdinal, struct.pack("L", *struct.unpack(">L", code)))

def packEnum(code):
	return AE.AECreateDesc(kAE.typeEnumeration, struct.pack("L", *struct.unpack(">L", code)))

def packListAs(type, lst):
	desc = AE.AECreateList('', True)
	for key, value in lst:
		desc.AEPutParamDesc(key, value)
	return desc.AECoerceDesc(type)


class _CollectComparable:
	def __init__(self):
		self.result = []
	
	def __getattr__(self, name):
		self.result.append(name)
		return self
	
	def __call__(self, *args):
		self.result.append(args)
		return self


class BASE(object):
	"""Base class for all specifier and testclause classes."""
	
	def __hash__(self):
		"""References are immutable, so may be used as dictionary keys."""
		return hash(repr(self))
	
	def __ne__(self, v):
		"""References may be compared for equality."""
		return not (self == v)
	
	def __eq__(self, v):
		"""References may be compared for equality."""
		return self is v or (
				self.__class__ == v.__class__ and 
				self.AEM_comparable() == v.AEM_comparable())
	
	def AEM_comparable(self):
		collector = _CollectComparable()
		self.AEM_resolve(collector)
		val = collector.result
		self.AEM_comparable = lambda: val
		return val

