#!/usr/local/bin/python3.0

# Opens a file in TextEdit.

from appscript import *

app('TextEdit').open(mactypes.Alias('Open_file_in_TextEdit.py'))