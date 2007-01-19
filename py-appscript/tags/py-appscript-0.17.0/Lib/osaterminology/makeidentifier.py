#!/usr/local/bin/python

"""makeidentifier -- Convert AppleScript keywords to identifiers.

(C) 2004 HAS
"""

import keyword, string

try:
	set
except: # Python 2.3
	from sets import Set as set


######################################################################
# PRIVATE
######################################################################
# Reserved keywords

# py-appscript
#
# Important: the following must be reserved:
#
# - names of properties and methods used in reference.Application and reference.Reference classes
# - names of built-in keyword arguments in reference.Command.__call__

kPyAppscriptReservedWords = [
	"ID",
	"start",
	"end",
	"before",
	"after",
	"previous",
	"next",
	"first",
	"middle",
	"last",
	"any",
	"startswith",
	"endswith",
	"contains",
	"isin",
	"doesnotstartwith",
	"doesnotendwith",
	"doesnotcontain",
	"isnotin",
	"AND",
	"NOT",
	"OR",
	"starttransaction",
	"aborttransaction",
	"endtransaction",
	"resulttype",
	"ignore",
	"timeout",
	"waitreply"
	"help",
	 ] + keyword.kwlist


# rb-appscript
#
# Important: the following must be reserved:
#
# - names of properties and methods used in AS::Application and AS::Reference classes
# - names of built-in keyword arguments in AS::Reference._send

kRbAppscriptReservedWords = [
	"==",
	"===",
	"=~",
	"AS_aem_reference",
	"AS_aem_reference=",
	"AS_app_data",
	"AS_app_data=",
	"AS_resolve",
	"ID",
	"[]",
	"__id__",
	"__send__",
	"_aem_application_class",
	"_call",
	"_resolve_range_boundary",
	"_send_command",
	"abort_transaction",
	"after",
	"and",
	"any",
	"before",
	"by_creator",
	"by_id",
	"by_name",
	"by_pid",
	"by_url",
	"class",
	"clone",
	"commands",
	"contains",
	"current",
	"display",
	"does_not_contain",
	"does_not_end_with",
	"does_not_start_with",
	"dup",
	"elements",
	"end",
	"end_transaction",
	"ends_with",
	"eq",
	"eql?",
	"equal?",
	"extend",
	"first",
	"freeze",
	"frozen?",
	"ge",
	"gt",
	"hash",
	"help",
	"id",
	"ignore",
	"inspect",
	"instance_eval",
	"instance_of?",
	"instance_variable_get",
	"instance_variable_set",
	"instance_variables",
	"is_a?",
	"is_in",
	"is_not_in",
	"keywords",
	"kind_of?",
	"last",
	"launch",
	"le",
	"lt",
	"method",
	"method_missing",
	"methods",
	"middle",
	"ne",
	"next",
	"nil?",
	"not",
	"object_id",
	"or",
	"parameters",
	"previous",
	"private_methods",
	"properties",
	"protected_methods",
	"public_methods",
	"respond_to?",
	"result_type",
	"send",
	"singleton_methods",
	"start",
	"start_transaction",
	"starts_with",
	"taint",
	"tainted?",
	"timeout",
	"to_a",
	"to_s",
	"type",
	"untaint",
	"wait_reply",
]


######################################################################

class Converter:
	# Special conversions for selected characters in AppleScript keywords; makes appscript users' lives easier. Note this is a lossy conversion, but chances of this causing name collisions are very low unless application developers are very stupid in choosing keyword names in their dictionaries. (Mind, this wouldn't have been a problem had Apple restricted them all to using only alphanumeric and space characters to begin with, which would've allowed simple, unambiguous conversion to C-style identifiers and back.)
	
	_specialConversions = {
			' ': '_',
			'-': '_',
			'&': 'and',
			'/': '_',
			}

	_legalChars = string.ascii_letters + '_'
	_alphanum = _legalChars + string.digits

	def __init__(self, reservedWords=kPyAppscriptReservedWords):
		self._cache = {}
		self._reservedWords = set(reservedWords)
		
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


_pyconverter = Converter().convert


_converters = {
	'applescript': lambda s:s,
	'appscript': _pyconverter,
	'py-appscript': _pyconverter,
	'rb-appscript': Converter(kRbAppscriptReservedWords).convert,
}


######################################################################
# PUBLIC
######################################################################


def getconverter(name='py-appscript'):
	try:
		return _converters[name]
	except:
		raise KeyError, "Keyword converter not found: %r" % name


