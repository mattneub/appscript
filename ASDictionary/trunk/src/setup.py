"""ASDictionary build notes

Requirements:

- Python 2.4+ <http://www.python.org>

- appscript 0.19.0+ <http://appscript.sourceforge.net>
- aeserver 0.5.0+

- PyObjC <http://pyobjc.sourceforge.net/>

- py2app <http://undefined.org/python/>

--

To build, cd to ASDictionary/src directory and run:

	python setup.py py2app

"""

from distutils.core import setup
import py2app
from plistlib import Plist
import os

name = 'ASDictionary'
version='0.9.1'

os.system('''
sdp -fa %s.sdef;
Rez %sScripting.r -o %s.rsrc -useDF
''' % ((name,) * 3))

setup(
	app=[name+".py"],
	data_files=["MainMenu.nib"],
	options=dict(
	

		py2app=dict(
			plist=Plist(
				NSAppleScriptEnabled=True,
				CFBundleVersion=version,
				CFBundleShortVersionString=version,
				NSHumanReadableCopyright="(C) 2005-2008 HAS",
				CFBundleIdentifier="net.sourceforge.appscript.asdictionary",
				CFBundleDocumentTypes = [
					dict(
						CFBundleTypeExtensions=["*"],
						CFBundleTypeName="public.item",
						CFBundleTypeRole="Viewer",
					),
				]
			),
			resources=[name+'.icns', name+'.rsrc'],
			iconfile=name+'.icns'
		)
	)
)
