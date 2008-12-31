#!/usr/bin/env python

from aem import *

# tell app "Finder" to get every item of home whose name begins with "d" and name is not "Documents"

print Application(findapp.byname('Finder')).event('coregetd', {'----': 

		app.property('home').elements('cobj').byfilter(

				its.property('pnam').beginswith('d') .AND (its.property('pnam').ne('Documents'))
		
				)
		}).send()

# Result should be list of folders of home whose name begins with 'd' except for 'Documents', e.g.:
#
#	[
#	app.property('sdsk').elements('cfol').byname(u'Users').elements('cfol').byname(u'has').elements('cfol').byname(u'Desktop'), 
#	app.property('sdsk').elements('cfol').byname(u'Users').elements('cfol').byname(u'has').elements('cfol').byname(u'Downloads')
#	]