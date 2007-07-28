#!/usr/local/bin/python

"""unittypes -- Provides pack and unpack methods for converting between mactypes.Units instances and AE unit types. Each Codecs instance is allocated its own UnitTypeCodecs instance."""

from CarbonX import AE, kAE
from struct import pack, unpack
from mactypes import Units


class UnitTypeCodecs:
	"""Provides pack and unpack methods for converting between mactypes.Units instances and AE unit types. Each Codecs instance is allocated its own UnitTypeCodecs instance.
	"""
	
	_defaultunittypes = [
		('centimeters', 'cmtr'),
		('meters', 'metr'),
		('kilometers', 'kmtr'),
		('inches', 'inch'),
		('feet', 'feet'),
		('yards', 'yard'),
		('miles', 'mile'),
		
		('square_meters', 'sqrm'),
		('square_kilometers', 'sqkm'),
		('square_feet', 'sqft'),
		('square_yards', 'sqyd'),
		('square_miles', 'sqmi'),
		
		('cubic_centimeters', 'ccmt'),
		('cubic_meters', 'cmet'),
		('cubic_inches', 'cuin'),
		('cubic_feet', 'cfet'),
		('cubic_yards', 'cyrd'),
		
		('liters', 'litr'),
		('quarts', 'qrts'),
		('gallons', 'galn'),
		
		('grams', 'gram'),
		('kilograms', 'kgrm'),
		('ounces', 'ozs '),
		('pounds', 'lbs '),
		
		('degrees_Celsius', 'degc'),
		('degrees_Fahrenheit', 'degf'),
		('degrees_Kelvin', 'degk'),
	]
	
	##
	
	def _defaultpacker(self, units, code): 
		return AE.AECreateDesc(code, pack('d', units.value))
	
	def _defaultunpacker(self, desc, name):
		return Units(unpack('d', desc.data)[0], name)
	
	##
	
	def __init__(self):
		self._typebyname = {}
		self._typebycode = {}
		self.addtypes(self._defaultunittypes)
	
	def addtypes(self, typedefs):
		""" Add application-specific unit type definitions to this UnitTypeCodecs instance.
		
			typedefs is a list of tuples, where each tuple is of form:
				(typename, typecode, packer, unpacker)
			or:
				(typename, typecode)
			
			If optional packer and unpacker functions are omitted, default pack/unpack functions
			are used instead; these pack/unpack AEDesc data as a double precision float.
		"""
		for item in typedefs:
			if len(item) == 2:
				item = item + (self._defaultpacker, self._defaultunpacker)
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
				return True, packer(val, code)
		else:
			return False, val
	
	def unpack(self, desc):
		if self._typebycode.has_key(desc.type):
			name, unpacker = self._typebycode[desc.type]
			return True, unpacker(desc, name)
		else:
			return False, desc

