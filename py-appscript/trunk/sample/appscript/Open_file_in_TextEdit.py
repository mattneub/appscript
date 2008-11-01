#!/usr/bin/env python

# Opens a file in TextEdit.

from appscript import *

app('TextEdit').open(mactypes.Alias('Open_file_in_TextEdit.py'))