#!/usr/bin/env python3

from aem import *

# tell app "Finder" to get every item of home whose name begins with "d" and name is not "Documents"

print (Application(findapp.byname('Finder')).event(b'coregetd', {b'----': 

		app.property(b'home').elements(b'cobj').byfilter(

				its.property(b'pnam').beginswith('d') .AND (its.property(b'pnam').ne('Documents'))
		
				)
		}).send())

# Result should be list of folders of home whose name begins with 'd' except for 'Documents', e.g.:
#
#	[
#	app.property(b'sdsk').elements(b'cfol').byname('Users').elements(b'cfol').byname('has').elements(b'cfol').byname('Desktop'), 
#	app.property(b'sdsk').elements(b'cfol').byname('Users').elements(b'cfol').byname('has').elements(b'cfol').byname('Downloads')
#	]