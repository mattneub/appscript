"""makeidentifier -- Convert AppleScript keywords to identifiers.

(C) 2004-2008 HAS
"""

import keyword, string

try:
	set
except: # Python 2.3
	from sets import Set as set

import pyappscript, rbappscript, objcappscript


######################################################################
# PRIVATE
######################################################################

class _Converter:
	# Special conversions for selected characters in AppleScript keywords; makes appscript users' lives easier. Note this is a lossy conversion, but chances of this causing name collisions are very low unless application developers are very stupid in choosing keyword names in their dictionaries. (Mind, this wouldn't have been a problem had Apple restricted them all to using only alphanumeric and space characters to begin with, which would've allowed simple, unambiguous conversion to C-style identifiers and back.)
	
	_specialConversions = {
			' ': '_',
			'-': '_',
			'&': 'and',
			'/': '_',
			}
	
	_legalChars = string.ascii_letters + '_'
	_alphanum = _legalChars + string.digits
	
	def __init__(self, reservedWords):
		self._cache = {}
		self._reservedWords = set(reservedWords)



class CamelCaseConverter(_Converter):
		
	def convert(self, s):
		"""Convert string to identifier.
			s : str
			Result : str
		"""
		if not self._cache.has_key(s):
			legal = self._legalChars
			res = ''
			uppercaseNext = False
			for c in s:
				if c in legal:
					if uppercaseNext:
						c = c.upper()
						uppercaseNext = False
					res += c
				elif c in ' -/':
					uppercaseNext = True
				elif c == '&':
					res += 'And'
				else:
					if res == '':
						res = '_' # avoid creating an invalid identifier
					res += '0x%2.2X' % ord(c)
				legal = self._alphanum
			if res in self._reservedWords or res.startswith('_') or res.startswith('AS_'):
				res += '_'
			self._cache[s] = str(res)
		return self._cache[s]



class UnderscoreConverter(_Converter):
		
	def convert(self, s):
		"""Convert string to identifier.
			s : str
			Result : str
		"""
		if not self._cache.has_key(s):
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
			self._cache[s] = str(res)
		return self._cache[s]



_converters = {
	'applescript': lambda s:s,
	'py-appscript': UnderscoreConverter(pyappscript.kReservedWords).convert,
	'rb-appscript': UnderscoreConverter(rbappscript.kReservedWords).convert,
	'objc-appscript': CamelCaseConverter(objcappscript.kReservedWords).convert,
}


######################################################################
# PUBLIC
######################################################################


def getconverter(name='py-appscript'):
	try:
		return _converters[name]
	except:
		raise KeyError, "Keyword converter not found: %r" % name

