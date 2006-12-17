#!/usr/local/bin/python

"""unittypes -- Provides pack and unpack methods for converting between mactypes.Units instances and AE unit types. Each Codecs instance is allocated its own UnitTypeCodecs instance."""

from CarbonX import AE, kAE
from struct import pack, unpack
from mactypes import Units


class UnitTypeCodecs:
	"""Provides pack and unpack methods for converting between mactypes.Units instances and AE unit types. Each Codecs instance is allocated its own UnitTypeCodecs instance.
	"""
	
	_defaultunittypes = [
		['centimeters', kAE.typeCentimeters],
		['meters', kAE.typeMeters],
		['kilometers', kAE.typeKilometers],
		['inches', kAE.typeInches],
		['feet', kAE.typeFeet],
		['yards', kAE.typeYards],
		['miles', kAE.typeMiles],
		
		['square meters', kAE.typeSquareMeters],
		['square kilometers', kAE.typeSquareKilometers],
		['square feet', kAE.typeSquareFeet],
		['square yards', kAE.typeSquareYards],
		['square miles', kAE.typeSquareMiles],
		
		['cubic centimeters', kAE.typeCubicCentimeter],
		['cubic meters', kAE.typeCubicMeters],
		['cubic inches', kAE.typeCubicInches],
		['cubic feet', kAE.typeCubicFeet],
		['cubic yards', kAE.typeCubicYards],
		
		['liters', kAE.typeLiters],
		['quarts', kAE.typeQuarts],
		['gallons', kAE.typeGallons],
		
		['grams', kAE.typeGrams],
		['kilograms', kAE.typeKilograms],
		['ounces', kAE.typeOunces],
		['pounds', kAE.typePounds],
		
		['degrees Celsius', kAE.typeDegreesC],
		['degrees Fahrenheit', kAE.typeDegreesF],
		['degrees Kelvin', kAE.typeDegreesK],
	]
	
	##
	
	def _defaultpacker(self, value, code): 
		return AE.AECreateDesc(code, pack('d', value))
	
	def _defaultunpacker(self, desc, name):
		return Units(unpack('d', desc.data)[0], name)
	
	##
	
	def __init__(self):
		self._typebyname = {}
		self._typebycode = {}
		self.addtypes(self._defaultunittypes)
	
	def addtypes(self, typedefs):
		""" Add application-specific unit type definitions to this UnitTypeCodecs instance.
		
			typedefs is a list of lists, where each sublist is of form:
				[typename, typecode, packer, unpacker]
			or:
				[typename, typecode]
			
			If optional packer and unpacker functions are omitted, default pack/unpack functions
			are used instead; these pack/unpack AEDesc data as a double precision float.
		"""
		for item in typedefs:
			if len(item) == 2:
				item = item + [self._defaultpacker, self._defaultunpacker]
			name, code, packer, unpacker = item
			self._typebyname[name] = (code, packer)
			self._typebycode[code] = (name, unpacker)
	
	def pack(self, val):
		if isinstance(val, Units):
			try:
				code, packer = self._typebyname[val.type]
			except KeyError:
				raise TypeError, 'Unknown unit type: %r' % val
			else:
				return True, packer(val.value, code)
		else:
			return False, val
	
	def unpack(self, desc):
		if self._typebycode.has_key(desc.type):
			name, unpacker = self._typebycode[desc.type]
			return True, unpacker(desc, name)
		else:
			return False, desc

