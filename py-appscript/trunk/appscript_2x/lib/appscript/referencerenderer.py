"""referencerenderer -- Generates string representations of appscript references from aem object specifiers. """

import struct
from terminology import kProperty, kElement
from aem import Query

######################################################################
# PRIVATE
######################################################################

_property_ = property

class _Formatter:
	def __init__(self, appdata, nested=False):
		self._appdata = appdata
		if nested:
			self.root = 'app'
		elif self._appdata.constructor == 'current':
			self.root = 'app()'
		elif self._appdata.constructor == 'path':
			argstr = ''
			newinstancearg = self._appdata.aemconstructoroptions.get('newinstance')
			if newinstancearg:
				argstr += ', newinstance=%r' % ((self._appdata.isconnected and
						struct.unpack('II', self._appdata.target().addressdesc.data) or True),)
			self.root = 'app(%r%s)' % (self._appdata.identifier, argstr)
		else:
			self.root = 'app(%s=%r)' % (self._appdata.constructor, self._appdata.identifier)
		self.result = ''
	
	def _format(self, val):
		if isinstance(val, Query):
			return renderreference(self._appdata, val, True)
		else:
			return repr(val)
	
	# reference roots
	
	def app(self):
		self.result += self.root
		return self
	app = _property_(app)
	
	def con(self):
		self.result += 'con'
		return self
	con = _property_(con)
	
	def its(self):
		self.result += 'its'
		return self
	its = _property_(its)

	# insertion locs
	
	def beginning(self):
		self.result += '.beginning'
		return self
	beginning = _property_(beginning)
	
	def end(self):
		self.result += '.end'
		return self
	end = _property_(end)
	
	def before(self):
		self.result += '.before'
		return self
	before = _property_(before)
	
	def after(self):
		self.result += '.after'
		return self
	after = _property_(after)
	
	# property, elements specifiers
	
	def property(self, code):
		try:
			self.result += '.' + self._appdata.referencebycode()[kProperty+code][1]
		except KeyError:
			self.result += '.' + self._appdata.referencebycode()[kElement+code][1]
		return self

	def elements(self, code):
		try:
			self.result += '.' + self._appdata.referencebycode()[kElement+code][1]
		except KeyError:
			self.result += '.' + self._appdata.referencebycode()[kProperty+code][1]
		return self
	
	# single-element selectors
	
	def first(self):
		self.result += '.first'
		return self
	first = _property_(first)
	
	def middle(self):
		self.result += '.middle'
		return self
	middle = _property_(middle)
	
	def last(self):
		self.result += '.last'
		return self
	last = _property_(last)
	
	def any(self):
		self.result += '.any'
		return self
	any = _property_(any)
	
	def byindex(self, sel):
		self.result += '[%r]' % sel
		return self
	
	byname = byindex
	
	def byid(self, sel):
		self.result += '.ID(%r)' % sel
		return self
	
	def previous(self, sel):
		self.result += '.previous(%r)' % self._appdata.typebycode()[sel]
		return self
	
	def next(self, sel):
		self.result += '.next(%r)' % self._appdata.typebycode()[sel]
		return self
	
	# multi-element selectors
	
	def byrange(self, sel1, sel2):
		self.result += '[%s:%s]' %(self._format(sel1), self._format(sel2))
		return self
		
	def byfilter(self, sel):
		self.result += '[%s]' % self._format(sel)
		return self
	
	# comparison tests
	
	def gt(self, sel):
		self.result += ' > %s' % self._format(sel)
		return self
	
	def ge(self, sel):
		self.result += ' >= %s' % self._format(sel)
		return self
	
	def eq(self, sel):
		self.result += ' == %s' % self._format(sel)
		return self
	
	def ne(self, sel):
		self.result += ' != %s' % self._format(sel)
		return self
	
	def lt(self, sel):
		self.result += ' < %s' % self._format(sel)
		return self
	
	def le(self, sel):
		self.result += ' <= %s' % self._format(sel)
		return self
	
	def beginswith(self, sel):
		self.result += '.beginswith(%s)' % self._format(sel)
		return self
	
	def endswith(self, sel):
		self.result += '.endswith(%s)' % self._format(sel)
		return self
	
	def contains(self, sel):
		self.result += '.contains(%s)' % self._format(sel)
		return self
	
	def isin(self, sel):
		self.result += '.isin(%s)' % self._format(sel)
		return self
	
	# logical tests
	
	def AND(self, *operands):
		self.result = '(%s).AND(%s)' % (self.result, ', '.join([self._format(o) for o in operands]))
		return self
		
	def OR(self, *operands):
		self.result = '(%s).OR(%s)' % (self.result, ', '.join([self._format(o) for o in operands]))
		return self
	
	def NOT(self):
		self.result = '(%s).NOT' % self.result
		return self
	NOT = _property_(NOT)


######################################################################
# PUBLIC
######################################################################

def renderreference(appdata, aemreference, nested=False):
	"""Take an aem reference, e.g.:
	
		app.elements('docu').byindex(1).property('ctxt')
	
	and an AppData instance containing application's location and terminology, and render an appscript-style reference, e.g.:
	
		"app('/Applications/TextEdit.app').documents[1].text"
		
	Used by Reference.__repr__().
	"""
	f = _Formatter(appdata, nested)
	try:
		aemreference.AEM_resolve(f)
	except:
		return '%s.AS_newreference(%r)' % (f.root, aemreference)
	return f.result
	
