
import sys
import os.path

#######

DEBUG = 0
LOAD_MODULES_FROM_BUNDLE = 1

#######

pyosamodulesdir = os.path.split(__file__)[0]

usermodulesdir = '/Library/PyOSA/Modules/%i.%i' % sys.version_info[:2]

if LOAD_MODULES_FROM_BUNDLE:
	for path in [
			usermodulesdir,
			os.path.expanduser('~' + usermodulesdir),
			pyosamodulesdir,
			]:
		if path not in sys.path:
			sys.path.insert(0, path)

if DEBUG:
	print 'Python version =', sys.version
	print 'sys.path ='
	for path in sys.path:
		print '\t' + path


#######
# check appscript __version__, and disable component if < 0.17.2 to prevent older, incompatible CarbonX C API causing fatal memory errors

import appscript
vers, subvers, patch = getattr(appscript, '__version__', '0.0.0').split('.')
if int(vers) == 0 and (int(subvers) < 17 or (int(subvers) == 17 and int(patch) < 2)):
	print >> sys.stderr, "*" * 70
	print >> sys.stderr, "PyOSA: appscript version is too old (0.17.2+ required)."
	print >> sys.stderr, "*" * 70
	raise RuntimeError, "Appscript version is too old (0.17.2+ required)."

