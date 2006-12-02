#!/usr/bin/env pythonw

from aem import Application, app, AEType, k


textedit = Application('/Applications/TextEdit.app')

# name of application "TextEdit"
print textedit.event('coregetd', {'----':app.property('pnam')}).send()

print Application('/System/Library/CoreServices/Finder.app').event(
		'coregetd', {k.Direct: app.property('home').elements('cobj'), k.ResultType: 'alis'}).send()