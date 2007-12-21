#!/usr/bin/env python

# create new TextEdit document containing 'Hello World' and current time

from time import strftime

from aem import *

textedit = Application('/Applications/TextEdit.app') # make Application object

#######

# tell app "TextEdit" to activate
textedit.event('miscactv').send()

# tell app "TextEdit" to make new document at end of documents with properties {text:"hello world\n\n\n\n"}
e = textedit.event('corecrel', {
		'kocl':AEType('docu'),
		'insh':app.elements('docu').end,
		'prdt':{AEType('ctxt'):'Hello World\n\n\n\n\n\n'}
		})
		
print e.send() 
# Result: TextEdit returns a reference to the object created:
#
# app.elements('docu').byindex(1)


#######

# tell app "TextEdit" to set paragraph 3 of text of first document to strftime("%c")
textedit.event('coresetd', {
		'----':app.elements('docu').first.property('ctxt').elements('cpar').byindex(3), 
		'data':strftime('%c')
		}).send()


# tell app "TextEdit" to set every paragraph of text of first document where it = "\n" to "...\n"
textedit.event('coresetd', {
		'----':app.elements('docu').first.property('ctxt').elements('cpar').byfilter(its.eq('\n')), 
		'data':'...\n'
		}).send()

# Result should be a TextEdit document containing:
#
# Hello World
# ...
# [current date]
# ...
# ...
