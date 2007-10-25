"""ASDictionary build notes

Requirements:

- Python 2.4+ <http://www.python.org>

- appscript 0.18.0+ <http://appscript.sourceforge.net>

- PyObjC <http://pyobjc.sourceforge.net/>

- py2app <http://undefined.org/python/>

--

To build, cd to ASDictionary/src directory and run:

	python setup.py py2app

"""

from distutils.core import setup
import py2app
from plistlib import Plist

version='0.9.0'

setup(
	app=["ASDictionary.py"],
	data_files=["MainMenu.nib", "rubyrenderer.rb"],
	options=dict(
	

		py2app=dict(
			plist=Plist(
				CFBundleVersion=version,
				CFBundleShortVersionString=version,
				NSHumanReadableCopyright="(C) 2007 HAS",
				CFBundleIdentifier="net.sourceforge.appscript.asdictionary",
				CFBundleDocumentTypes = [
					dict(
						CFBundleTypeExtensions=["*"],
						CFBundleTypeName="public.item",
						CFBundleTypeRole="Viewer",
					),
				]
			),
			resources=['ASDictionary.icns'],
			iconfile='ASDictionary.icns'
		)
	)
)
