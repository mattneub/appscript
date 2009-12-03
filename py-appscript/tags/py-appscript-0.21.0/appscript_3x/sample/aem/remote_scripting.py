#!/usr/bin/env python3

from aem import *

# get text of document 1 of application "TextEdit" of machine "eppc://192.168.2.5"
textedit = Application(url='eppc://192.168.2.5/TextEdit')
print textedit.event(b'coregetd', {b'----':app.elements(b'docu').byindex(1).property(b'ctxt')}).send()

