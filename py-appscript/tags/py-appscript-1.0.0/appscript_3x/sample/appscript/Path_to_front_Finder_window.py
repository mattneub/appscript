#!/usr/bin/env python3

# Gets the path to the front Finder window, or to the Desktop folder if
# no Finder windows are open.

from appscript import *

finder = app('Finder')

w = finder.Finder_windows[1]

if w.exists(): # is there a Finder window open?
    if w.target.class_.get() == k.computer_object:
        # 'Computer' windows don't have a target folder, for obvious reasons.
        raise RuntimeError("Can't get path to 'Computer' window.")
    folder = w.target # get a reference to its target folder
else:
    folder = finder.desktop # get a reference to the desktop folder

path = folder.get(resulttype=k.alias).path # get folder's path

print(path)