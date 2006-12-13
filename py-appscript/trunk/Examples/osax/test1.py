#!/usr/local/bin/python

from osax import *

sa = OSAX('StandardAdditions')

sa.beep(2)

sa.activate()
sa.display_dialog('hello')