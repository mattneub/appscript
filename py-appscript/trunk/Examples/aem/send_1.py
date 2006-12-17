#!/usr/bin/env pythonw

from aem import Application, app, AEType
from CarbonX import kAE


textedit = Application('/Applications/TextEdit.app')

# name of application "TextEdit"
print textedit.event('coregetd', {'----':app.property('pnam')}).send()

print Application('/System/Library/CoreServices/Finder.app').event('coregetd', {
		kAE.keyDirectObject: app.property('home').elements('cobj'), 
		kAE.keyAERequestedType: 'alis'
		}).send()
		
		
