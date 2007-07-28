#!/usr/bin/env python

from aem import *

# get text of document 1 of application "TextEdit" of machine "eppc://192.168.2.5"
textedit = Application(url='eppc://192.168.2.5/TextEdit')
print textedit.event('coregetd', {'----':app.elements('docu').byindex(1).property('ctxt')}).send()

