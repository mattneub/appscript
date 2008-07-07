"""defaultterminology -- translation tables between appscript-style typenames and corresponding AE codes

(C) 2005-2008 HAS
"""

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