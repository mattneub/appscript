from distutils.core import setup
import py2app
from plistlib import Plist
import os

#######

kName = 'MiniTC'
kVersion = '0.1.0'
kBundleID = 'net.sourceforge.appscript.py-aemreceive.MiniTC'

# For testing, use kHide = False to so that MiniTC application can be seen when running.
# For deployment, use kHide = True to build MiniTC as a faceless background application.
kHide = False # True


#######
# generate .rsrc file containing application's terminology for 10.4 and earlier

# note: older versions of Mac OS X may install sdp and/or Rez in /Developer/Tools;
# if so, modify your shell's profile include /Developer/Tools on its $PATH, e.g. for bash,
# open ~/.bash_profile and add the following line:
# export PATH=${PATH}:/Developer/Tools

os.system("sdp -fa '%s.sdef' && Rez '%sScripting.r' -o '%s.rsrc' -useDF" % (kName, kName, kName))


#######

setup(
	name=kName,
	version=kVersion,
	app=[kName + '.py'],
	options={
		'py2app': {
			'plist': Plist(
				LSUIElement=int(kHide), 
				NSAppleScriptEnabled=True,
				CFBundleIdentifier=kBundleID,
				CFBundleVersion=kVersion, 
				CFBundleShortVersionString=kVersion,
				CFBundleIconFile=kName + '.icns'
			),
			'resources': [
					kName + '.rsrc', 
					kName + '.icns', 
					kName + '.sdef'
			]
		}
	}
)


