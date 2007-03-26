#!/usr/bin/python

# Call PyOSA functions from Python via osascript module/CarbonX.OSA extension

# note: doesn't work yet with Python 2.4/2.5 for some reason (framework functions fail to bind)

from osascript import *

pyosa = Interpreter('PyOC')

scpt = pyosa.newscript()

scpt.compile('def run(): return 2 + 2')

print '\nRESULT:', scpt.run()