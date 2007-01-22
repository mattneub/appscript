#!/usr/bin/env python

# Prints the sub-folder hierarchy of a given folder as a list of folder names
# indented according to depth.

from appscript import *


def printFolderTree(folder, indent=''):
    """Print a tab-indented list of a folder tree."""
    print indent + folder.name.get().encode('utf8')
    for folder in folder.folders.get():
        printFolderTree(folder, indent + '\t')


printFolderTree(app('Finder').home.folders['Documents'])