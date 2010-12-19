"""mcpy_syspath.py -- Sets additional module search paths prior to loading controller module.

(C) 2005 HAS

--------------------------------------------------------------------------------
"""

# Developer Notes:
#
# IMPORTANT: Don't forget to set LOAD_MODULES_FROM_BUNDLE to True before distribution!
#
# If LOAD_MODULES_FROM_BUNDLE is False, forces Python interpreter to use a .pth file [1] in site-packages to locate and load Python modules from MacPythonOSA/Source. This saves developer having to rebuild the entire project each time a module is modified. If True, loads modules from the component bundle.
#
# [1] A plain text file with .pth extension (e.g. MacPythonOSA_dev.pth) that contains the full POSIX path to MacPythonOSA/Source directory (e.g. /Users/has/MacPythonOSA/Source). If LOAD_MODULES_FROM_BUNDLE is False and no such .pth file exists, the MacPythonOSA component will - not surprisingly - raise an error when client attempts to open a connection.

DEBUG = 1
LOAD_MODULES_FROM_BUNDLE = 1

import sys
import os.path

if LOAD_MODULES_FROM_BUNDLE:
	sys.path.insert(0, os.path.join(os.path.split(__file__)[0], 'Modules'))
sys.path.append(os.path.expanduser('~/Library/MacPythonOSA/Modules')) # TO DO: Python versions
sys.path.append('/Library/MacPythonOSA/Modules') # TO DO: Python versions

if DEBUG:
	print 'Python version =', sys.version
	print 'sys.path =', sys.path