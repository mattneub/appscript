#!/usr/bin/env python3

# Prints the sub-folder hierarchy of a given folder as a list of folder names
# indented according to depth.

from appscript import *


def printfoldertree(folder, indent=''):
    """Print a tab-indented list of a folder tree."""
    print(indent + folder.name.get())
    for folder in folder.folders.get():
        printfoldertree(folder, indent + '\t')


printfoldertree(app('Finder').home.folders['Documents'])