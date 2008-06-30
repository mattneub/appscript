"""defaultterminology -- translation tables between appscript-style typenames and corresponding AE codes

(C) 2005-2008 HAS
"""

# import pyappscript, rbappscript, objcappscript

# TO DO: have a single constants file


'''
typebycode = {}

for defs in [appscripttypedefs.types, 
		appscripttypedefs.pseudotypes]:
	for name, code in defs:
		typebycode[code] = name


enumerationbycode = dict(appscripttypedefs.enumerations)


'''

def getterms(style='py-appscript'):
	if style == 'py-appscript':
		import pyappscript as terms
	elif style == 'rb-appscript':
		import rbappscript as terms
	elif style == 'objc-appscript':
		import objcappscript as terms
	else:
		raise KeyError, 'Unknown style %r' % style
	return terms