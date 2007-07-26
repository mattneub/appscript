"""parser -- Simple SAX-like parser for parsing aete and aeut terminology data.

(C) 2004 HAS	
"""

from struct import pack, unpack

from CarbonX.AE import AEDesc

__all__ = ['Receiver', 'parse', 'kBE', 'kLE', 'kAuto']


######################################################################
# PRIVATE
######################################################################

#Constants

_kAEInheritedProperties = 'c@#^'

# Note: kAEInheritedProperties isn't defined in IM:IAC; Jon Pugh documented it in Winter 1992 Registry Errata v4:
#
#	Inheritance from another object class is indicated by the inclusion of a special property in the new object class.
#	kAEInheritedProperties	'c@#^'
#	Name:	"<Inheritance>"
#	Object Class ID:	Class ID of parent object
#	Description:	All properties and elements of the given class are inherited by this class.  This is only for use by humans reading the dictionary.  AppleScript does nothing with this property.


#######
# Data source

class _BigEndianDataSource:
	"""Raw aete data source."""
	
	def __init__(self, aete):
		"""aete : str -- Raw aete/aeut data."""
		self._str = aete
		self._ptr = 0
		
	def integer(self):
		"""Read a 2-byte integer."""
		self._ptr += 2
		return unpack(">H", self._str[self._ptr - 2:self._ptr])[0] 
	
	def word(self):
		"""Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability)."""
		self._ptr += 4
		return self._str[self._ptr - 4:self._ptr]
	
	def string(self):
		"""Read a MacRoman-encoded Pascal string."""
		count = ord(self._str[self._ptr])
		self._ptr += 1 + count
		if count:
			return unicode(self._str[self._ptr - count:self._ptr], 'MacRoman') # note: this conversion is a significant bottleneck
		else:
			return u''
	
	name=string
	
	def align(self):
		"""Align internal pointer on an even byte."""
		if self._ptr & 1:
			self._ptr += 1
	
	def list(self, fn, receiver):
		"""Read a list using given function to parse each item."""
		for _ in range(self.integer()): 
			fn(self, receiver)
	
	def isComplete(self):
		return self._ptr == len(self._str)


class _LittleEndianDataSource(_BigEndianDataSource):
	"""Raw aete data source. (aete resource files always use big-endian format, but aetes obtained via 
	OS/AE calls use host system's native byte order)
	"""
	
	def integer(self):
		"""Read a 2-byte integer."""
		self._ptr += 2
		return unpack("<H", self._str[self._ptr - 2:self._ptr])[0] 
	
	def word(self):
		"""Read a 4-byte string (really a long, but represented as an 4-character 8-bit string for readability)."""
		self._ptr += 4
		return self._str[self._ptr - 1:self._ptr - 5:-1]


######################################################################
# Aete structure-parsing functions
# Each function knows how to parse a particular block of aete data.
# A function is passed to _DataSource's list() method where it's called to parse each item in the list.

#######
# Command

def _parseDirect(aete):
	datatype = aete.word()
	description = aete.string()
	aete.align()
	flags = aete.integer()
	isoptional = flags & 2 ** 15 > 0
	islist = flags & 2 ** 14 > 0
	isenum = flags & 2 ** 13 > 0
	return description, datatype, isoptional, islist, isenum

def _parseLabelledArg(aete, receiver):
	name = aete.name()
	aete.align()
	code = aete.word()
	receiver.add_labelledarg(code, name,*_parseDirect(aete))

def _parseCommand(aete, receiver):
	# TO DO: fire separate add_directarg and add_result events only when datatype != 'null'?
	name = aete.name()
	description = aete.string()
	aete.align()
	eventclass = aete.word()
	eventid = aete.word()
	reply = _parseDirect(aete)
	directarg = _parseDirect(aete)
	receiver.start_command(eventclass + eventid, name, description, directarg, reply)
	aete.list(_parseLabelledArg, receiver)
	receiver.end_command()

#######
# Class

def _parseSupportedReferenceForms(aete, receiver): 
	receiver.add_supportedform(aete.word())
	
def _parseElement(aete, receiver): 
	datatype = aete.word()
	receiver.start_element(datatype)
	aete.list(_parseSupportedReferenceForms, receiver)
	receiver.end_element()

def _parseProperty(aete, receiver): 
	name = aete.name()
	aete.align()
	code = aete.word()
	datatype = aete.word()
	description = aete.string()
	aete.align()
	flags = aete.integer()
	if code == _kAEInheritedProperties:
		receiver.add_superclass(datatype)
	elif flags & 1: # name is plural (used by kAESpecialClassProperties to define plural synonyms)
		receiver.is_plural()
	else:
		receiver.add_property(code, name, description, datatype,
			bool(flags & 16384), bool(flags & 8192), bool(flags & 4096)) # islist, isenum, ismutable

def _parseClass(aete, receiver):
	name = aete.name()
	aete.align()
	code = aete.word()
	description = aete.string()
	aete.align()
	receiver.start_class(code, name, description)
	aete.list(_parseProperty, receiver)
	aete.list(_parseElement, receiver)
	receiver.end_class()

#######
# Comparison

def _parseComparison(aete, receiver): # comparison info isn't used
	aete.string() # name
	aete.align()
	aete.word() # code
	aete.string() # description
	aete.align()

#######
# Enumeration

def _parseEnumerator(aete, receiver):
	name = aete.name()
	aete.align()
	code = aete.word()
	description = aete.string()
	aete.align()
	receiver.add_enumerator(code, name, description)

def _parseEnumeration(aete, receiver): 
	receiver.start_enumeration(aete.word())
	aete.list(_parseEnumerator, receiver)
	receiver.end_enumeration()

#######
# Suite

def _parseSuite(aete, receiver):
	name = aete.string()
	description = aete.string()
	aete.align()
	code = aete.word()
	aete.integer() # level
	aete.integer() # version
	receiver.start_suite(code, name, description)
	for fn in [_parseCommand, _parseClass, _parseComparison, _parseEnumeration]:
		aete.list(fn, receiver)
	receiver.end_suite()


######################################################################
# PUBLIC
######################################################################

# constants for specifying byte order to use

kBE = 'be'
kLE = 'le'
kAuto = 'auto'
kNative = 'native'


# base class for constructing parsing event receivers

class Receiver:
	"""Abstract base class; subclass and override some or all methods to create an parsing event receiver for use in parse()."""

	def start_suite(self, code, name, description):
		pass
		
	def start_command(self, code, name, description, directarg, reply):
		pass
		
	def add_labelledarg(self, code, name, description, datatype, isoptional, islist, isenum):
		pass
		
	def end_command(self):
		pass
		
	def start_class(self, code, name, description):
		pass
		
	def is_plural(self):
		pass
		
	def add_superclass(self, datatype):
		pass
		
	def add_property(self, code, name, description, datatype, islist, isenum, ismutable):
		pass
		
	def start_element(self, datatype):
		pass
		
	def add_supportedform(self, code):
		pass
		
	def end_element(self):
		pass
		
	def end_class(self):
		pass
		
	def start_enumeration(self, code):
		pass
		
	def add_enumerator(self, code, name, description):
		pass
		
	def end_enumeration(self):
		pass
		
	def end_suite(self):
		pass


# parse function

def parse(aetes, receiver, byteorder=kNative):
	"""Parse an application or scripting component's scripting terminology.
		aetes : str | list of AEDesc -- zero or more aete/aeut descriptors
		receiver : Receiver -- object to receive parsing events
		byteorder : kBE / kLE / kAuto / kNative -- the byte order to use [1]
		
		[1] If kAuto is used, aete data's byte order is deduced by sniffing bytes. (This will fail if aete
			has more than 255 suites, but such aetes are extremely unlikely to occur in practice.)
	"""
	if not isinstance(aetes, list):
		aetes = [aetes]
	for aete in aetes:
		if isinstance(aete, AEDesc) and aete.type in ['aete', 'aeut'] and aete.data:
			aete = aete.data
			if byteorder == kNative:
				isBigEndian = pack("H", 1) == '\x00\x01'
			elif byteorder == kAuto:
				isBigEndian = aete[6] == '\x00'
			else:
				isBigEndian = byteorder == kBE
			a = (isBigEndian and _BigEndianDataSource or _LittleEndianDataSource)(aete)
			a.integer() # version
			a.integer() # language
			a.integer() # script
			a.list(_parseSuite, receiver)

