from distutils.core import setup
import py2app
from plistlib import Plist
import os

#######

name = 'MiniTC'
version = '0.1.0'
#url = 'org.foo.MiniTC'


hide = True # set to False during development so that application is visible while running; set to True for deployment


# sdpPath = '/Developer/Tools/sdp' # Panther?
sdpPath = 'sdp' # Tiger
RezPath = '/Developer/Tools/Rez'

#######

os.system('''
%r -fa %s.sdef;
%r %sScripting.r -o %s.rsrc -useDF
''' % (sdpPath, name, RezPath, name, name))

setup(
	name= name,
	version=version,
	app=[name + '.py'],
	options={
		'py2app': {
			'plist': Plist(
				LSUIElement=int(hide), 
				NSAppleScriptEnabled=True,
				#CFBundleIdentifier=url,
				CFBundleVersion=version, 
				CFBundleShortVersionString=version,
				CFBundleIconFile=name + '.icns'
			),
			'resources': [name + '.rsrc', name + '.icns']
		}
	}
)


