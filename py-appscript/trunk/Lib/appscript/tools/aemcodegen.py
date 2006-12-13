#!/usr/bin/env python

"""aemcodegen -- A simple code generation tool that extends the appscript package so that it prints equivalent aem code to stdout instead of sending Apple events to applications. Useful if you want to script applications with aem without having to look up raw AE codes yourself. 

(C) 2005 HAS

The aemcodegen API is identical to appscript API with the addition of a global variable, outputfile, containing a file-like object to write output to (default is sys.stdout).

To use, import aemcodegen and execute one or more appscript commands to generate equivalent aem code. 

Example:

from appscript.aemcodegen import *

app('Finder.app').home.folders[1].name.get()

--> Application(u'/System/Library/CoreServices/Finder.app', None).event('coregetd', {'----': app.property('home').elements('cfol').byindex(1).property('pnam')}).send(3600, 3)
"""

# TO DO: clean up rendering in _Event.send() so default timeout/send flag arguments aren't shown

import sys as _sys
import aem as _aem
from appscript import *
from appscript import reference as _reference

#######
# PRIVATE

def _fmt(args, kargs):
	return ', '.join(['%r' % i for i in args] + ['%s=%r' % i for i in kargs.items()])


class _Base:
	_aemCodecs = _aem.Codecs()
	
	def _encfmt(self, *args):
		return _fmt(*[self._aemCodecs.unpack(self._codecs.pack(arg)) for arg in args])


class _Event(_Base):
	def __init__(self, repr, codecs):
		self._repr = repr
		self._codecs = codecs
	
	def send(self, *args, **kargs):
		# TO DO: should omit default timeout and flag values
		print >> outputfile, '%s.send(%s)\n' % (self._repr, self._encfmt(args, kargs))


class _Application(_Base):
	def __init__(self,*args, **kargs):
		self._repr = 'Application(%s)' % _fmt(args, kargs)
	
	def event(self, *args, **kargs):
		if kargs.get('resulttype', 0) is None:
			del kargs['resulttype']
		self._codecs = kargs.pop('codecs')
		return _Event('%s.event(%s)' % (self._repr, self._encfmt(args, kargs)), self._codecs)
	
	def starttransaction(self):
		print >> outputfile, self._repr + '.starttransaction()\n'
	
	def endtransaction(self):
		print >> outputfile, self._repr + '.endtransaction()\n'


#######
# PUBLIC

outputfile = _sys.stdout # user may replace this

class app(_reference.Application):
	_Application = _Application

# Other appscript attributes, classes, etc. are re-exported directly.

#######
# TEST

if __name__ == '__main__':
	app('Finder.app').home.folders[1].name.set('foo')
	from mactypes import *
	app('Finder').folders[File('/Users/has')].items[2:5].get(resulttype=k.Alias)
	f = app(id='com.apple.finder')
	f.home.files[1].duplicate(to=f.desktop)


