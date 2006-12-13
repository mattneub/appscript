#!/usr/bin/env python

from appscript import *

w = app('Finder').Finder_windows[1]
if w.exists(): # is there a Finder window open?
    folder = w.target # get its target folder
    if not folder.name.get(): # Computer window has no folder (its target is, oddly, app('Finder').folders(''))
        folder = None
else:
    folder = app('Finder').desktop # get desktop's folder
if folder:
    path = folder.get(resulttype=k.FSRef).path # appscript returns FSRef as mactypes.File
else:
    path = None
print path