#!/usr/bin/env pythonw

from aem import *

print Application('/System/Library/CoreServices/Finder.app').event('coregetd', {'----': 

		app.property('home').elements('cobj').byfilter(

				its.property('pnam').startswith('d') .AND (its.property('pnam').ne('Documents'))
		
				)
		}).send()

# Result should be list of folders of home whose name begins with 'd' except for 'Documents', e.g.:
#
#	[
#	app.property('sdsk').elements('cfol').byname(u'Users').elements('cfol').byname(u'has').elements('cfol').byname(u'Desktop'), 
#	app.property('sdsk').elements('cfol').byname(u'Users').elements('cfol').byname(u'has').elements('cfol').byname(u'Downloads')
#	]