#!/usr/bin/env python3

import aem


# Get name of application "TextEdit"
textedit = aem.Application('/Applications/TextEdit.app')
print(textedit.event(b'coregetd', {b'----': aem.app.property(b'pnam')}).send())


# Get list of items in home folder as mactype.Alias objects:
finder = aem.Application(aem.findapp.byname('Finder'))
print(finder.event(b'coregetd', {
		b'----': aem.app.property(b'home').elements(b'cobj'), 
		aem.kae.keyAERequestedType: aem.AEType(aem.kae.typeAlias),
		}).send())
		
		
