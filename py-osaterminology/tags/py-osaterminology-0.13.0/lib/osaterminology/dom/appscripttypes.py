"""appscripttypes -- Provides tables for converting AEM-defined AE type codes to appscript Keyword names when parsing terminology.

(C) 2005 HAS
"""

from osaterminology.defaultterminology import getterms

__all__ = ['typetables']

######################################################################
# PRIVATE
######################################################################

_cache = {}

class TypeTables:
	def __init__(self, style):
		self.typebycode = {}
		typedefs = getterms(style)
		for defs in [typedefs.types, typedefs.pseudotypes]:
			for name, code in defs:
				self.typebycode[code] = name
		self.enumerationbycode = dict(typedefs.enumerations)


######################################################################
# PUBLIC
######################################################################


def typetables(style='py-appscript'):
	if not style in _cache:
		_cache[style] = TypeTables(style)
	return _cache[style]
	
	
