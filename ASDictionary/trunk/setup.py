from distutils.core import setup
import py2app
from plistlib import Plist

setup(
	app=['ASDictionary.py'],
	options={
		'py2app': {
			'argv_emulation': True,
			'plist': Plist(
				CFBundleVersion='0.6.2',
				CFBundleShortVersionString='0.6.2'
				),
			'resources': ['ASDictionary.icns'],
			'iconfile': 'ASDictionary.icns',
		}
	},
)


# kludge to copy dialogs.rsrc into application bundle as py2app doesn't do it

import EasyDialogs
from shutil import copy
from os.path import split, join

rsrc = join(split(EasyDialogs.__file__)[0], 'dialogs.rsrc')
rdst = join(split(__file__)[0], 'dist/ASDictionary.app/Contents/Resources/')
copy(rsrc, rdst)