#!/usr/bin/env python

"""dump -- Generates a Python module containing an application's basic terminology 
(names and codes) as used by appscript.

(C) 2004 HAS

To use:

Call the dump() function or run from shell to dump faulty aetes to Python module. 
Patch any errors by hand, then import the patched module into your script and 
pass it to appscript's app() constructor via its 'terms' argument.

Note that dumped terminologies have no effect on appscript's built-in help system, 
which obtains its terminology data separately.
"""

from pprint import pprint
from sys import argv

from aem import findapp
from osaterminology.getterminology import getaete
from appscript.terminologyparser import buildtablesforaetes


######################################################################
# PUBLIC
######################################################################

def dump(apppath, modulepath):
	"""Dump terminology data to Python module.
		apppath : str -- name or path of application
		modulepath : str -- path to generated module
	"""
	apppath = findapp.byname(apppath)
	tables = buildtablesforaetes(getaete(apppath))
	atts = zip(('classes', 'enums', 'properties', 'elements', 'commands'), tables)
	f = file(modulepath, 'w')
	print >> f, 'version = 1.1'
	print >> f, 'path = %r' % apppath
	for key, value in atts:
		if key[0] != '_':
			print >> f, '\n%s = \\' % key
			pprint(value, f)
	f.close()


######################################################################
# SHELL
######################################################################

if __name__ == '__main__':
	if len(argv) == 3:
		dump(argv[1], argv[2])
	else:
		print 'Usage: python dump.py application-name-or-path module-path'
