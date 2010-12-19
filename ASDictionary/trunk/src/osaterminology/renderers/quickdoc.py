"""quickdoc -- Dump application terminology (aete) data to file/stdout."""

from aem import kae
from os import sys

from osaterminology.sax.aeteparser import Receiver, parse
from aem.ae import getappterminology, getsysterminology


__all__ = ['app', 'component', 'QuickDoc']


######################################################################
# PRIVATE
######################################################################

def _code(s): # TO DO: move to makeidentifier module?
	r = ''
	for c in s:
		if c in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -*':
			r += c
		else:
			r += '\\x%2.2x' % ord(c)
	return r


def _fopts(l):
	opts = ', '.join([s for s in l if s])
	return opts and ' (%s)' % opts or ''


class QuickDoc(Receiver):
	"""Quick-n-dirty documentation generator."""
	
	def __init__(self, out=sys.stdout, converter=None):
		self._out = out
		self._convert = converter or (lambda s:s)
	
	def _write(self, utxt=''):
		self._out.write(utxt.encode('utf8'))
	
	def _writen(self, utxt=''):
		self._write(utxt + '\n')
	
	def start_suite(self, code, name, description):
		self._writen(u'\n\nSuite: %s [%s]%s\n' % (name, _code(code), description and ' -- ' + description or ''))
	
	def start_enumeration(self, code):
		self._writen(u'\n\tEnums: [%s]' % _code(code))
		
	def add_enumerator(self, code, name, description):
		self._writen(u'\t\t%s [%s]%s' % (self._convert(name), _code(code), description and ' -- ' + description or ''))
	
	def start_class(self, code, name, description):
		self._writen(u'\n\tClass: %s [%s]%s' % (self._convert(name), _code(code), description and ' -- ' + description or ''))
	
	def add_superclass(self, datatype):
		self._writen(u'\t\t<Inheritance> <%s> -- All of the properties of the superclass.' % _code(datatype))
	
	def is_plural(self):
		self._writen(u'\t\t(plural synonym)')
	
	def add_property(self, code, name, description, datatype, l, e, m):
		self._writen(u'\t\t%s [%s] <%s>%s%s' % (self._convert(name), _code(code), _code(datatype), 
				_fopts([l and 'list', e and 'enum', not m and 'r/o']), description and ' -- ' + description or ''))
	
	def start_element(self, datatype):
		self._write(u'\t\t[%s] --' % _code(datatype))
	
	def add_supportedform(self, formCode):
		self._write({
			kae.formName:u'name',
			kae.formAbsolutePosition:u'index',
			kae.formUniqueID:u'id',
			kae.formRelativePosition:u'relative',
			kae.formRange:u'range',
			kae.formTest:u'test'}.get(formCode, '(Bad code: %r)' % formCode) + ' ')
	
	def end_element(self):
		self._writen()
	
	def start_command(self, code, name, description, directArg, reply):
		self._writen(u'\tEvent: %s [%s] -- %s' % (self._convert(name), _code(code), description))
		d, t, o, l, e = directArg
		self._writen(u'\t\t<%s>%s%s' % (t, 
				_fopts([o and 'optional', l and 'list', e and 'enum']), d and ' -- ' + d or ''))
		d, t, o, l, e = reply
		self._commandResult = u'\t\tResult: <%s>%s%s' % (t, 
				_fopts([o and 'optional', l and 'list', e and 'enum']), d and ' -- ' + d or '')
	
	def end_command(self):
		self._writen(self._commandResult)
		self._writen()
	
	def add_labelledarg(self, code, name, description, datatype, o, l, e):
		self._writen(u'\t\t%s [%s] <%s>%s%s' % (self._convert(name), _code(code), _code(datatype), 
				_fopts([o and 'optional', l and 'list', e and 'enum']), description and ' -- ' + description or ''))


######################################################################
# PUBLIC
######################################################################

def app(path, out=sys.stdout, converter=None):
	"""Render raw terminology for application.
		path : str -- full path to application
		out : file -- open file object to write to (default: stdout)
		converter : function -- function to convert AppleScript-style keywords (default: None)
	"""
	data = getappterminology(path)
	parse(data, QuickDoc(out, converter))

def component(code='ascr', out=sys.stdout, converter=None):
	"""Render raw terminology for scripting component.
		code : str -- four-letter code indication component's subtype (default: AppleScript)
		out : file -- open file object to write to (default: stdout)
		converter : function -- function to convert AppleScript-style keywords (default: None)
	"""
	data = getsysterminology(code)
	parse(data, QuickDoc(out, converter))

