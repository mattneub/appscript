"""aem.types -- Convert from Python to Apple Event Manager types and vice-versa.

(C) 2005 HAS
"""

from basictypes import AETypeBase, AEType, AEEnum, AEProp, AEKey, encoders, decoders, UnitTypeCodecs
from objectspecifiers import app, con, its, customroot, osdecoders, BASE, Specifier, Test

__all__ = ['Codecs', 'AETypeBase', 'AEType', 'AEEnum', 'AEProp', 'AEKey', 'app', 'con', 'its', 'customroot']

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
		self._unittypecodecs = UnitTypeCodecs()
	
	##
	
	def addunittypes(self, typedefs):
		"""Register custom unit type definitions with this Codecs instance
			e.g. Adobe apps define additional unit types (ciceros, pixels, etc.)
		"""
		self._unittypecodecs.addtypes(typedefs)
	
	##
	
	def packunknown(self, data):
		"""Clients may override this to provide additional packers."""
		raise TypeError, "Can't pack data into an AEDesc (unsupported type): %r" % data
	
	def unpackunknown(self, desc):
		"""Clients may override this to provide additional unpackers."""
		if desc.AECheckIsRecord():
			rec = desc.AECoerceDesc('reco')
			rec.AEPutParamDesc('pcls', self.pack(AEType(desc.type)))
			decoder = self.decoders.get('reco')
			if decoder:
				return decoder(rec, self)
			else:
				return rec
		else:
			return desc
	
	##
	
	def pack(self, data):
		"""Pack Python data.
			data : anything -- a Python value
			Result : CarbonX.AE.AEDesc -- an Apple event descriptor, or error if no encoder exists for this type of data
		"""
		if isinstance(data, BASE):
			return data.AEM_packSelf(self)
		else:
			try:
				return self.encoders[data.__class__](data, self) # quick lookup by type/class
			except (KeyError, AttributeError):
				for type, encoder in self.encoders.items(): # slower but more thorough lookup that can handle subtypes/subclasses
					if isinstance(data, type):
						return encoder(data, self)
				didpack, desc = self._unittypecodecs.pack(data)
				if didpack:
					return desc
				else:
					self.packunknown(data)
	
	def unpack(self, desc):
		"""Unpack an Apple event descriptor.
			desc : CarbonX.AE.AEDesc -- an Apple event descriptor
			Result : anything -- a Python value, or the AEDesc object if no decoder is found
		"""
		decoder = self.decoders.get(desc.type)
		if decoder:
			return decoder(desc, self)
		else:
			didunpack, val = self._unittypecodecs.unpack(desc)
			if didunpack:
				return val
			else:
				return self.unpackunknown(desc)

