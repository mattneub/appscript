#!/usr/bin/env python3

# Convert the front TextEdit document to HTML.

from appscript import *

te = app('TextEdit')

s = te.documents[1].text.get()
for c, r in [('&', '&amp;'), ('<', '&lt;'), ('>', '&gt;'), ('\t', '    ')]:
	s = s.replace(c, r)
te.documents[1].text.set(s)

# Note: in theory, it should be possible to use TextEdit's 'set' command to
# perform the substitutions directly:
#
# for c, r in [('&', '&amp;'), ('<', '&lt;'), ('>', '&gt;')]:
# 	te.documents[1].characters[its == c].set(r)
#
# Unfortunately, the Text Suite is buggy and doesn't handle this correctly,
# so it's necessary to retrieve the document text and process it in Python.