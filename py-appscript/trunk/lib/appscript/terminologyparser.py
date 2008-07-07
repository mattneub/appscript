"""terminologyparser -- Basic aete parser to construct name-code terminology tables from an application's class, enumerator, property, element and command definitions. 

The tables returned by this module are an intermediate format, suitable for exporting to Python modules via terminology.dump. The terminology module will convert these intermediate tables into the final format used in AppData objects.

(C) 2004-2008 HAS
"""

from struct import pack, unpack
try:
	set
except NameError: # Python 2.3
	from sets import Set as set
import string

from aem.ae import AEDesc
from reservedkeywords import kReservedKeywords


######################################################################
# PRIVATE
######################################################################

class Parser:
	_keywordCache = {}
	_reservedWords = set(kReservedKeywords)
	_specialConversions = {
			' ': '_',
			'-': '_',
			'&': 'and',
			'/': '_',
	}
	_legalChars = string.ascii_letters + '_'
	_alphanum = _legalChars + string.digits
		
	def __init__(self):
		# terminology tables; order is significant where synonym definitions occur
		self.commands = {}
		self.properties = []
		self.elements = []
		self.classes = []
		self.enumerators = []
		# use sets to record previously found definitions, and avoid adding duplicates to lists
		# (i.e. 'name+code not in <set>' is quicker than using 'name+code not in <list>')
		self._foundProperties = set()
		self._foundElements = set()
		self._foundClasses = set()
		self._foundEnumerators = set()
		# ideally, aetes should define both singular and plural names for each class, but
		# some define only one or the other so we need to fill in any missing ones afterwards
		self._spareClassNames = {}
		self._foundClassCodes = set()
		self._foundElementCodes = set()
	
	def convert(self, s):
		"""Convert string to identifier.
			s : str
			Result : str
		"""
		if not self._keywordCache.has_key(s):
			legal = self._legalChars
			res = ''
			for c in s:
				if c in legal:
					res += c
				elif self._specialConversions.has_key(c):
					res += self._specialConversions[c]
				else:
					if res == '':
						res = '_' # avoid creating an invalid identifier
					res += '0x%2.2X' % ord(c)
				legal = self._alphanum
			if res in self._reservedWords or res.startswith('_') or res.startswith('AS_'):
				res += '_'
			self._keywordCache[s] = str(res)
		return self._keywordCache[s]
		
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
		# Note: overlapping command definitions (e.g. InDesign) should be processed as follows:
		# - If their names and codes are the same, only the last definition is used; other definitions are ignored and will not compile.
		# - If their names are the same but their codes are different, only the first definition is used; other definitions are ignored and will not compile.
		# - If a dictionary-defined command has the same name but different code to a built-in definition, escape its name so it doesn't conflict with the default built-in definition.
		if not self.commands.has_key(name) or self.commands[name][1] == code:
			self.commands[name] =(name, code, currentCommandArgs)
		# add labelled parameters
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
				if flags & 1: # indicates class name is plural (see kAESpecialClassProperties)
					isPlural = True
				elif (propname + propcode) not in self._foundProperties:
					self.properties.append((propname, propcode)) # preserve ordering
					self._foundProperties.add(propname + propcode)
		for _ in range(self.integer()): # skip elements
			self._ptr += 4 # code word
			count = self.integer()
			self._ptr += 4 * count # reference forms
		if isPlural:
			if (name + code) not in self._foundElements:
				self.elements.append((name, code))
				self._foundElements.add(name + code)
				self._foundElementCodes.add(code)
		else:
			if (name + code) not in self._foundClasses:
				self.classes.append((name, code))
				self._foundClasses.add(name + code)
				self._foundClassCodes.add(code)
		self._spareClassNames[code] = name
	
	
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
			if (name + code) not in self._foundEnumerators:
				self.enumerators.append((name, code))
				self._foundEnumerators.add(name + code)

	
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
			if isinstance(aete, AEDesc) and aete.type in ['aete', 'aeut'] and aete.data:
				self._str = aete.data
				self._ptr = 6 # version, language, script integers
				for _ in range(self.integer()):
					self.parseSuite()
		# singular names are normally used in the classes table and plural names in the elements table. However, if an aete defines a singular name but not a plural name then the missing plural name is substituted with the singular name; and vice-versa if there's no singular equivalent for a plural name.
		missingElements = self._foundClassCodes - self._foundElementCodes
		missingClasses = self._foundElementCodes - self._foundClassCodes
		for code in missingElements:
			self.elements.append((self._spareClassNames[code], code))
		for code in missingClasses:
			self.classes.append((self._spareClassNames[code], code))
		return (self.classes, self.enumerators, self.properties, self.elements, self.commands.values())


class LittleEndianParser(Parser):

	def word(self):
		"""Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability)."""
		self._ptr += 4
		return self._str[self._ptr - 1:self._ptr - 5:-1] # little-endian


######################################################################
# PUBLIC
######################################################################

def buildtablesforaetes(aetes):
	"""
		aetes : list of AEDesc
	"""
	if pack("H", 1) == '\x00\x01': # is it big-endian?
		return Parser().parse(aetes)
	else:
		return LittleEndianParser().parse(aetes)


