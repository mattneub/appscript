#!/usr/bin/env python

"""terminologyparser -- Basic aete parser to construct name-code terminology tables from an application's class, enumerator, property, element and command definitions. 

The tables returned by this module are an intermediate format, suitable for exporting to Python modules via tools.dump. The terminology module will convert these intermediate tables into the final format used in AppData objects.

(C) 2004 HAS"""

from osaterminology.makeidentifier import getconverter
from struct import pack, unpack

# TO DO: what about synonyms?


######################################################################
# PRIVATE
######################################################################

class Parser:
	def __init__(self, style):
		self.convert = getconverter(style)
		# terminology tables (items are stored by code to eliminate duplicates)
		self.enumerators = {}
		self.properties = {}
		# Note: overlapping command definitions (e.g. InDesign) should be processed as follows:
		# - If their names and codes are the same, only the last definition is used; other definitions are ignored and will not compile.
		# - If their names are the same but their codes are different, only the first definition is used; other definitions are ignored and will not compile.
		# - If a dictionary-defined command has the same name but different code to a built-in definition, escape its name so it doesn't conflict with the default built-in definition.
		self.commands = {}
		self._pluralClassNames = {}
		self._singularClassNames = {}
		
	def integer(self):
		"""Read a 2-byte integer."""
		self._ptr += 2
		return unpack("H", self._str[self._ptr - 2:self._ptr])[0] 
	
	def word(self):
		"""Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability)."""
		self._ptr += 4
		return self._str[self._ptr - 4:self._ptr] # big-endian
	
	def name(self):
		"""Read a MacRoman-encoded Pascal keyword string."""
		count = ord(self._str[self._ptr])
		self._ptr += 1 + count
		return self.convert(self._str[self._ptr - count:self._ptr]) # Note: non-ASCII characters will be differently encoded than in osaterminology.sax.aeteparser, which turns everything into unicode first. Not aware of any apps using non-ASCII characters in keywords though.
	
	##
	
	def parseCommand(self):
		name = self.name()
		self._ptr += 1 + ord(self._str[self._ptr]) # description string
		self._ptr += self._ptr & 1 # align
		code = self.word() + self.word() # event class + event id
		# skip result
		self._ptr += 4 # datatype word
		self._ptr += 1 + ord(self._str[self._ptr]) # description string
		self._ptr += self._ptr & 1 # align
		self._ptr += 2 # flags integer
		# skip direct parameter
		self._ptr += 4 # datatype word
		self._ptr += 1 + ord(self._str[self._ptr]) # description string
		self._ptr += self._ptr & 1 # align
		self._ptr += 2 # flags integer
		#
		currentCommandArgs = []
		self.commands[code] =(name, code, currentCommandArgs)
		# add labelled args
		for _ in range(self.integer()):
			name = self.name()
			self._ptr += self._ptr & 1 # align
			code = self.word()
			self._ptr += 4 # datatype word
			self._ptr += 1 + ord(self._str[self._ptr]) # description string
			self._ptr += self._ptr & 1 # align
			self._ptr += 2 # flags integer
			currentCommandArgs.append((name, code))
	
	
	def parseClass(self):
		name = self.name()
		self._ptr += self._ptr & 1 # align
		code = self.word()
		self._ptr += 1 + ord(self._str[self._ptr]) # description string
		self._ptr += self._ptr & 1 # align
		isPlural = False
		for _ in range(self.integer()): # properties
			propname = self.name()
			self._ptr += self._ptr & 1 # align
			propcode = self.word()
			self._ptr += 4 # datatype word
			self._ptr += 1 + ord(self._str[self._ptr]) # description string
			self._ptr += self._ptr & 1 # align
			flags = self.integer()
			if propcode != 'c@#^': # not a superclass definition (see kAEInheritedProperties)
				if flags & 1: # class name is plural (see kAESpecialClassProperties)
					isPlural = True
				else:
					self.properties[propcode] = (propname, propcode)
		for _ in range(self.integer()): # skip elements
			self._ptr += 4 # code word
			count = self.integer()
			self._ptr += 4 * count
		if isPlural:
			self._pluralClassNames[code] = (name, code)
		else:
			self._singularClassNames[code] = (name, code)
	
	
	def parseComparison(self): # comparison info isn't used
		self._ptr += 1 + ord(self._str[self._ptr]) # name string
		self._ptr += self._ptr & 1 # align
		self._ptr += 4 # code word
		self._ptr += 1 + ord(self._str[self._ptr]) # description string
		self._ptr += self._ptr & 1 # align
	
	
	def parseEnumeration(self): 
		self._ptr += 4 # code word
		for _ in range(self.integer()): # enumerators
			name = self.name()
			self._ptr += self._ptr & 1 # align
			code = self.word()
			self._ptr += 1 + ord(self._str[self._ptr]) # description string
			self._ptr += self._ptr & 1 # align
			self.enumerators[code + name] = (name, code)

	
	def parseSuite(self):
		self._ptr += 1 + ord(self._str[self._ptr]) # name string
		self._ptr += 1 + ord(self._str[self._ptr]) # description string
		self._ptr += self._ptr & 1 # align
		self._ptr += 4 # code word
		self._ptr += 4 # level, version integers
		for fn in [self.parseCommand, self.parseClass, self.parseComparison, self.parseEnumeration]:
			for _ in range(self.integer()):
				fn()
	
	#######
	# Public
	
	def parse(self, aetes):
		for aete in aetes:
			self._str = aete
			self._ptr = 6 # version, language, script integers
			for _ in range(self.integer()):
				self.parseSuite()
			if not self._ptr == len(self._str):
				raise RuntimeError, "aete was not fully parsed."
		# singular names are preferred for the class table and plural names for the element table:
		classes = self._pluralClassNames.copy()
		classes.update(self._singularClassNames)
		elements = self._singularClassNames.copy()
		elements.update(self._pluralClassNames)
		return [d.values() for d in [classes, self.enumerators, self.properties, elements, self.commands]]


class LittleEndianParser(Parser):

	def word(self):
		"""Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability)."""
		self._ptr += 4
		return self._str[self._ptr - 1:self._ptr - 5:-1] # little-endian


######################################################################
# PUBLIC
######################################################################

def buildtablesforaetes(aetes, style='py-appscript'):
	if pack("H", 1) == '\x00\x01': # is it big-endian?
		return Parser(style).parse(aetes)
	else:
		return LittleEndianParser(style).parse(aetes)


