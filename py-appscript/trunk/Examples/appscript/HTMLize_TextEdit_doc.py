#!/usr/bin/env python

from appscript import *

te = app('TextEdit')

s = te.documents[1].text.get().replace('&', '&amp;') \
        .replace('<', '&lt;').replace('>', '&gt;') \
        .replace('"', '&quot;').replace('\t', '    ')
te.documents[1].text.set(s)