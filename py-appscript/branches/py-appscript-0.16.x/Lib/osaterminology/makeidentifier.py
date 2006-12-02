"""makeidentifier -- Convert AppleScript keywords to Python identifiers.

(C) 2004 HAS
"""

import keyword, string

# NOTE: 'filter' is deprecated as reserved word; TO DO: remove 'filter' from list of reserved words in next release

######################################################################
# PRIVATE
######################################################################
# Reserved names of identifiers used in Specifier and Test classes

# IMPORTANT: reserved words and prefix defined here must match reserved function and property names defined in appscript.specifier classes and method keyword args

_reservedPrefix = 'AS_'

_reservedWords = """
		timeout waitreply resulttype ignore telltarget
		filter
		ID previous next
		start end before after
		first last middle any
		startswith endswith contains isin
		doesnotstartwith doesnotendwith doesnotcontain isnotin
		AND OR NOT
		starttransaction endtransaction
		help
		""".split()

# Special conversions for selected characters in AppleScript keywords; makes appscript users' lives easier. Note this is a lossy conversion, but chances of this causing name collisions are very low unless application developers are very stupid in choosing keyword names in their dictionaries. (Mind, this wouldn't have been a problem had Apple restricted them all to using only alphanumeric and space characters to begin with, which would've allowed simple, unambiguous conversion to C-style identifiers and back.)

_specialConversions = {
		' ': '_',
		'-': '_',
		'&': 'and',
		'/': '_',
		}

_cache = {}

_legalChars = string.ascii_letters + '_'
_alphanum = _legalChars + string.digits

######################################################################
# PUBLIC
######################################################################

def convert(s):
	"""Convert unicode string to Python identifier.
		s : string or unicode
		Result : string
	"""
	if not _cache.has_key(s):
		legal = _legalChars
		res = ''
		for c in s:
			if c in legal:
				res += c
			elif _specialConversions.has_key(c):
				res += _specialConversions[c]
			else:
				if res == '':
					res = '_' # avoid creating an invalid identifier
				res += '0x%2.2X' % ord(c)
			legal = _alphanum
		if keyword.iskeyword(res) or res in _reservedWords or res.startswith('_') or res.startswith(_reservedPrefix):
			res += '_'
		_cache[s] = str(res)
	return _cache[s]
