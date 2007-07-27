from distutils.core import setup
import py2app
from plistlib import Plist

#######

name = 'AppscriptHelpAgent'
version = '0.1.0'

#######

setup(
	name= name,
	version=version,
	app=[name + '.py'],
	data_files=["MainMenu.nib"],
	options={
		'py2app': {
			'plist': Plist(
				LSUIElement=1, 
				NSAppleScriptEnabled=True,
				CFBundleVersion=version, 
				CFBundleShortVersionString=version,
				NSHumanReadableCopyright="(C) 2007 HAS",
				CFBundleIdentifier="net.sourceforge.appscript.appscripthelpagent"
			)
		}
	}
)

