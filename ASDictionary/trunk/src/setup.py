"""

Requirements:

- appscript 0.18.0+ <http://appscript.sourceforge.net>

- PyObjC <http://pyobjc.sourceforge.net/>

- py2app <http://undefined.org/python/>

--

To build, cd to ASDictionary-x.x.x directory and run:

	python setup.py py2app

"""

from distutils.core import setup
import py2app
from plistlib import Plist

version='0.8.0'

setup(
	app=["ASDictionary.py"],
	data_files=["MainMenu.nib"],
	options=dict(
		py2app=dict(
			plist=Plist(
				CFBundleVersion=version,
				CFBundleShortVersionString=version,
				NSHumanReadableCopyright="(C) 2007 HAS",
				CFBundleIdentifier="net.sourceforge.appscript.asdictionary"
			),
			resources=['ASDictionary.icns'],
			iconfile='ASDictionary.icns'
		)
	)
)
