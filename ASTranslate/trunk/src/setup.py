"""
Requirements:

- appscript 0.19.0+ <http://appscript.sourceforge.net>

- pyobjc <http://pyobjc.sourceforge.net>

- py2app <http://undefined.org/python/>

--

To build, cd to this directory and run:

	python setup.py py2app

"""

from distutils.core import setup, Extension
import py2app
from plistlib import Plist

version = '0.4.0'


setup(
	app=["ASTranslate.py"],
	data_files=["MainMenu.nib", "ASTranslateDocument.nib"],
	options=dict(
	
		py2app=dict(
			plist=Plist(
				NSAppleScriptEnabled=True,
				CFBundleIdentifier="net.sourceforge.appscript.astranslate",
				CFBundleVersion=version,
				CFBundleShortVersionString=version,
				NSHumanReadableCopyright="(C) 2007-2008 HAS",
				CFBundleDocumentTypes = [
					dict(
						CFBundleTypeExtensions=[],
						CFBundleTypeName="Text File",
						CFBundleTypeRole="Editor",
						NSDocumentClass="ASTranslateDocument"
					)
				]
			),
			resources=['ASTranslate.icns'],
			iconfile='ASTranslate.icns'
		)
	)
)

