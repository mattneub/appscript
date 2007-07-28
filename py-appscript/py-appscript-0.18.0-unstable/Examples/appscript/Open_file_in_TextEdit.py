#!/usr/bin/env python

# Opens a file in TextEdit.

from appscript import *
import mactypes

app('TextEdit').open(mactypes.Alias('/Users/JSmith/ReadMe.txt'))