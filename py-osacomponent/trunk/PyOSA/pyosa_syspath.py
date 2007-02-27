
#
# pyosa_syspath.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
# Called each time a component instance is opened, allowing sys.path to be configured
# for PyOSA. It then verifies that a compatible version of appscript is available.
#

# TO DO: including prebuilt appscript packages, one for each Python version, and
# having PyOSA load one of those may be worth exploring as an alternative to relying
# on users to install appscript separately.

import sys
import os.path

#######
# Development flags

# Use True to display additional debug messages.
DEBUG = 1

# Use False to load PyOSA_ modules a .pth file in site-packages; this then avoids the need
# to recompile when testing changes to PyOSA_ modules. Also disables PyOSA site-packages.
# Important: must be True for distribution builds.
LOAD_PYOSA_MODULES_FROM_BUNDLE = 1 

#######

pyosamodulesdir = os.path.split(__file__)[0]

usermodulesdir = '/Library/PyOSA/%i.%i/site-packages' % sys.version_info[:2]

if LOAD_PYOSA_MODULES_FROM_BUNDLE:
	for path in [
			usermodulesdir,
			os.path.expanduser('~' + usermodulesdir),
			pyosamodulesdir,
			]:
		if path not in sys.path:
			sys.path.insert(0, path)

	
if DEBUG:
	print >> sys.stderr, 'PyOSA: using Python %s\n' % sys.version
#	print >> sys.stderr, 'PyOSA: using sys.path:'
#	for path in sys.path:
#		print >> sys.stderr, '\t' + path
	print >> sys.stderr


#######
# check appscript is available, and disable component if not

try:
	import appscript
except ImportError:
	print >> sys.stderr, "*" * 70
	print >> sys.stderr, "PyOSA: can't open component: appscript module not found."
	print >> sys.stderr, "*" * 70
	raise RuntimeError, "Appscript module not found."


# check appscript __version__, and disable component if it's earlier than 0.17.2
# to prevent older CarbonX.AE extensions causing fatal memory errors due to their
# incompatible C API

vers, subvers, patch = getattr(appscript, '__version__', '0.0.0').split('.')
if int(vers) == 0 and (int(subvers) < 17 or (int(subvers) == 17 and int(patch) < 2)):
	print >> sys.stderr, "*" * 70
	print >> sys.stderr, "PyOSA: can't open component: appscript version is too old (0.17.2+ required)."
	print >> sys.stderr, "*" * 70
	raise RuntimeError, "Appscript version is too old (0.17.2+ required)."

if DEBUG:
	print >> sys.stderr, 'PyOSA: using appscript %s\n' % appscript.__version__

