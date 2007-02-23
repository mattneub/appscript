
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