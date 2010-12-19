"""appscripttypes -- Provides tables for converting AEM-defined AE type codes to appscript Keyword names when parsing terminology."""

from osaterminology.defaultterminology import getterms

__all__ = ['typetables']

######################################################################
# PRIVATE
######################################################################

_cache = {}

class TypeTables:
	def __init__(self, style):
		typedefs = getterms(style)
		# build tables used to provide built-in names for [usually] type codes used in dictionaries
		self.enumerationbycode = dict(typedefs.enumerations)
		self.typebycode = {}
		for defs in [typedefs.types, typedefs.pseudotypes]:
			for name, code in defs:
				self.typebycode[code] = name
		# build tables used for collision checking (appscript only) where an application-defined name
		# overlaps a built-in name, but has a different code
		self.typecodebyname = {}
		self.commandcodebyname = {}
		for _, enumerators in typedefs.enumerations:
			for name, code in enumerators:
				self.typecodebyname[name] = code
		for defs in [typedefs.types, typedefs.properties]:
			for name, code in defs:
				self.typecodebyname[name] = code
		for name, code, params in typedefs.commands:
			self.commandcodebyname[name] = code


######################################################################
# PUBLIC
######################################################################


def typetables(style='py-appscript'):
	if not style in _cache:
		_cache[style] = TypeTables(style)
	return _cache[style]
	
	
