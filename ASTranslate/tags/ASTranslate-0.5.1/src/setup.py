"""
Requirements (available from PyPI except where noted):

- distribute 0.6.14+

- py-appscript 0.22.0+

- py-osaterminology 0.14.6+ (from appscript svn repository)

- pyobjc 1.4+

- py2app 0.5.2+

--

To build, cd to this directory and run:

	python setup.py py2app

"""

from setuptools import setup, Extension
import py2app
from plistlib import Plist

version = '0.5.1'


setup(
	app=["ASTranslate.py"],
	data_files=["MainMenu.nib", "ASTranslateDocument.nib"],
	
	ext_modules = [
		Extension('astranslate',
			sources=['astranslate.c'],
			extra_compile_args=['-DMAC_OS_X_VERSION_MIN_REQUIRED=MAC_OS_X_VERSION_10_4'],
			extra_link_args=['-framework', 'Carbon'],
		),
	],

	options=dict(
	
		py2app=dict(
			plist=Plist(
				CFBundleIdentifier="net.sourceforge.appscript.astranslate",
				CFBundleVersion=version,
				CFBundleShortVersionString=version,
				NSHumanReadableCopyright="",
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

