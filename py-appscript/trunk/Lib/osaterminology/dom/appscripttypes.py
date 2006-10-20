#!/usr/bin/env pythonw

"""appscripttypes -- Provides tables for converting AEM-defined AE type codes to appscript Keyword names when parsing terminology.

(C) 2005 HAS
"""

from osaterminology import appscripttypedefs

__all__ = ['typebycode', 'enumerationbycode']

######################################################################
# PUBLIC
######################################################################

typebycode = {}

for defs in [appscripttypedefs.alltypes, 
		appscripttypedefs.commontypes, 
		appscripttypedefs.pseudotypes,
		appscripttypedefs.remappedtypes]:
	for name, code in defs:
		typebycode[code] = name


enumerationbycode = dict(appscripttypedefs.enumerations)
