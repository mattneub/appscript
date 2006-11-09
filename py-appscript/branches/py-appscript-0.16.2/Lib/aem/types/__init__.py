"""aem.types -- Convert from Python to Apple Event Manager types and vice-versa.

(C) 2005 HAS
"""

from basictypes import AETypeBase, AEType, AEEnum, AEProp, AEKey, AEEventName, encoders, decoders
from objectspecifiers import app, con, its, Specifier, Test, osdecoders

__all__ = ['Codecs', 'AETypeBase', 'AEType', 'AEEnum', 'AEProp', 'AEKey', 'AEEventName', 'app', 'con', 'its']

######################################################################
# PRIVATE
######################################################################

decoders = decoders.copy()
decoders.update(osdecoders)

######################################################################
# PUBLIC
######################################################################

class Codecs:
	"""Convert between Python and Apple event data types.
	Clients may add additional encoders/decoders and/or subclass to suit their needs.
	"""
	# These 3 attributes are used by unpackspecifier to construct object specifiers; may be overridden in Codecs subclasses:
	app = app
	con = con
	its = its
	
	def __init__(self):
		# Clients may add/remove/replace encoder and decoder items:
		self.encoders = encoders.copy()
		self.decoders = decoders.copy()
	
	def packfailed(self, data):
		raise TypeError, "Can't pack data into an AEDesc (unsupported type): %r" % data
	
	def pack(self, data):
		"""Pack Python data.
			data : anything -- a Python value
			Result : CarbonX.AE.AEDesc -- an Apple event descriptor, or error if no encoder exists for this type of data
		"""
		if isinstance(data, (Specifier, Test)):
			return data.AEM_packSelf(self)
		else:
			try:
				return self.encoders[data.__class__](data, self) # quick lookup by type/class
			except (KeyError, AttributeError):
				for type, encoder in self.encoders.items(): # slower but more thorough lookup that can handle subtypes/subclasses
					if isinstance(data, type):
						return encoder(data, self)
				self.packfailed(data)
	
	def unpack(self, desc):
		"""Unpack an Apple event descriptor.
			desc : CarbonX.AE.AEDesc -- an Apple event descriptor
			Result : anything -- a Python value, or the AEDesc object if no decoder is found
		"""
		return self.decoders.get(desc.type, lambda desc, codecs: desc)(desc, self)

