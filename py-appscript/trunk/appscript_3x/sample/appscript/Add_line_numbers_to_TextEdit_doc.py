#!/usr/bin/env python3

# Adds a zero-padded line number to every line in the front TextEdit document.

from appscript import *
from math import log10

textref = app('TextEdit').documents[1].text

lc = textref.paragraphs.count()
fstr = '%%.%ii ' % (int(log10(lc)) + 1)
for i in range(lc):
    textref.paragraphs[i+1].characters.beginning.make(
            new=k.character, with_data=fstr % (i + 1))