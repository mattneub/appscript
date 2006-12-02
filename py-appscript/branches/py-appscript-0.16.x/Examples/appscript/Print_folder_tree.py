#!/usr/bin/env python

from appscript import *


def printFolderTree(folder, indent=''):
    """Print a tab-indented list of a folder tree."""
    print indent + folder.name.get().encode('utf8')
    for folder in folder.folders.get():
        printFolderTree(folder, indent + '\t')


printFolderTree(app('Finder').home.folders['Documents'])