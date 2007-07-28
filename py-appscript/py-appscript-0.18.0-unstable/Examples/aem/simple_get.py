#!/usr/bin/env python

import aem
from CarbonX import kAE


# Get name of application "TextEdit"
textedit = aem.Application('/Applications/TextEdit.app')
print textedit.event('coregetd', {'----': aem.app.property('pnam')}).send()


# Get list of items in home folder as mactype.Alias objects:
finder = aem.Application(aem.findapp.byname('Finder'))
print finder.event('coregetd', {
		'----': aem.app.property('home').elements('cobj'), 
		kAE.keyAERequestedType: kAE.typeAlias,
		}).send()
		
		
