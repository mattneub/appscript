#!/usr/bin/env pythonw

from aem import *

textedit = Application(url='eppc://0.0.0.10/TextEdit')

# get text of document 1 of application "TextEdit" of machine "eppc://0.0.0.10"
print textedit.event('coregetd', {'----':app.elements('docu').byindex(1).property('ctxt')}).send()

