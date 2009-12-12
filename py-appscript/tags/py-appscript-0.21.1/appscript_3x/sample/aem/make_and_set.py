#!/usr/bin/env python3

# create new TextEdit document containing 'Hello World' and current time

from time import strftime

from aem import *

textedit = Application('/Applications/TextEdit.app') # make Application object

#######

# tell app "TextEdit" to activate
textedit.event(b'miscactv').send()

# tell app "TextEdit" to make new document at end of documents with properties {text:"hello world\n\n\n\n"}
e = textedit.event(b'corecrel', {
		b'kocl':AEType(b'docu'),
		b'insh':app.elements(b'docu').end,
		b'prdt':{AEType(b'ctxt'):'Hello World\n\n\n\n\n\n'}
		})
		
print(e.send())
# Result: TextEdit returns a reference to the object created:
#
# app.elements(b'docu').byindex(1)


#######

# tell app "TextEdit" to set paragraph 3 of text of first document to strftime("%c")
textedit.event(b'coresetd', {
		b'----':app.elements(b'docu').first.property(b'ctxt').elements(b'cpar').byindex(3), 
		b'data':strftime('%c')
		}).send()


# tell app "TextEdit" to set every paragraph of text of first document where it = "\n" to "...\n"
textedit.event(b'coresetd', {
		b'----':app.elements(b'docu').first.property(b'ctxt').elements(b'cpar').byfilter(its.eq('\n')), 
		b'data':'...\n'
		}).send()

# Result should be a TextEdit document containing:
#
# Hello World
# ...
# [current date]
# ...
# ...
