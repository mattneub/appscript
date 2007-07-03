#!/usr/local/bin/python

"""aemcodegen -- A simple code generation tool that extends the appscript package so that it prints equivalent aem code to stdout instead of sending Apple events to applications. Useful if you want to script applications with aem without having to look up raw AE codes yourself. 

(C) 2005 HAS

The aemcodegen API is identical to appscript API with the addition of a global variable, outputfile, containing a file-like object to write output to (default is sys.stdout).

To use, import aemcodegen and execute one or more appscript commands to generate equivalent aem code. 

Example:

from appscript.aemcodegen import *

app('Finder.app').home.folders[1].name.get()

--> Application(u'/System/Library/CoreServices/Finder.app', None).event('coregetd', {'----': app.property('home').elements('cfol').byindex(1).property('pnam')}).send(3600, 3)
"""

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
	def __init__(self, repr, realEvent, codecs):
		self._repr = repr
		self._realEvent = realEvent
		self._codecs = codecs
	
	def send(self, *args, **kargs):
		print >> outputfile, '%s.send(%s)\n' % (self._repr, self._encfmt(args, kargs))
		if sendevents:
			return self._realEvent.send(*args, **kargs)


class _Application(_Base):
	def __init__(self, *args, **kargs):
		self._realApp = _aem.Application(*args, **kargs)
		self._repr = 'Application(%s)' % _fmt(args, kargs)
	
	AEM_identity = property(lambda self:self._realApp.AEM_identity)
	
	def event(self, event, *args, **kargs):
		realEvent = self._realApp.event(event, *args, **kargs)
		if event == 'ascrgdte':
			return realEvent
		else:
			self._codecs = kargs.pop('codecs')
			args = (event,) + args
			return _Event('%s.event(%s)' % (self._repr, self._encfmt(args, kargs)), realEvent, self._codecs)
	
	def begintransaction(self):
		print >> outputfile, self._repr + '.begintransaction()\n'
	
	def endtransaction(self):
		print >> outputfile, self._repr + '.endtransaction()\n'


#######
# PUBLIC

sendevents = False

outputfile = _sys.stdout # user may replace this

class app(_reference.Application):
	_Application = _Application

# Other appscript attributes, classes, etc. are re-exported directly.

#######
# TEST

if __name__ == '__main__':
	app('Finder.app').home.folders[1].name.set('foo')
	from mactypes import *
	app('Finder').folders[File('/Users/has')].items[2:5].get(resulttype=k.alias)
	f = app(id='com.apple.finder')
	f.home.files[1].duplicate(to=f.desktop)


