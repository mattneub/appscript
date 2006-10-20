#!/usr/bin/env python

from appscript import *
from math import log10

textRef = app('TextEdit').documents[1].text

lc = textRef.paragraphs.count()
fstr = '%%.%ii ' % (int(log10(lc)) + 1)
for i in range(lc):
    textRef.paragraphs[i+1].characters.start.make(
            new=k.character, with_data=fstr % i)