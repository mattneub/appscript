#!/usr/bin/env pythonw

from aem import *

fmp = Application('/Applications/FileMaker Pro 6/FileMaker Pro.app')

fmp.starttransaction()

print fmp.event('coregetd', {'----':app.property('pnam')}).send()

fmp.endtransaction()