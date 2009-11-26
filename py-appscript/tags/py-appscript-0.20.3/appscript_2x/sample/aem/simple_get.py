#!/usr/bin/env python

import aem


# Get name of application "TextEdit"
textedit = aem.Application('/Applications/TextEdit.app')
print textedit.event('coregetd', {'----': aem.app.property('pnam')}).send()


# Get list of items in home folder as mactype.Alias objects:
finder = aem.Application(aem.findapp.byname('Finder'))
print finder.event('coregetd', {
		'----': aem.app.property('home').elements('cobj'), 
		aem.kae.keyAERequestedType: aem.AEType(aem.kae.typeAlias),
		}).send()
		
		
