"""referencerenderer -- Generates string representations of appscript references from aem object specifiers.

(C) 2004-2008 HAS"""

from terminology import kProperty, kElement
from aem import Query

######################################################################
# PRIVATE
######################################################################

class _Formatter:
	def __init__(self, appData):
		self._appData = appData
		if self._appData.constructor == 'current':
			self.root = 'app()'
		elif self._appData.constructor == 'path':
			self.root = 'app(%r)' % self._appData.identifier
		else:
			self.root = 'app(%s=%r)' % (self._appData.constructor, self._appData.identifier)
		self.result = ''
	
	def _format(self, val):
		if isinstance(val, Query):
			return renderreference(self._appData, val)
		else:
			return repr(val)
	
	def property(self, code):
		try:
			self.result += '.' + self._appData.referencebycode[kProperty+code][1]
		except KeyError:
			self.result += '.' + self._appData.referencebycode[kElement+code][1]
		return self

	def elements(self, code):
		try:
			self.result += '.' + self._appData.referencebycode[kElement+code][1]
		except KeyError:
			self.result += '.' + self._appData.referencebycode[kProperty+code][1]
		return self
	
	def byname(self, sel):
		self.result += '[%r]' % sel
		return self
	
	byindex = byname
	
	def byid(self, sel):
		self.result += '.ID(%r)' % sel
		return self
	
	def byrange(self, sel1, sel2):
		self.result += '[%s:%s]' %(renderreference(self._appData, sel1), renderreference(self._appData, sel2))
		return self
		
	def byfilter(self, sel):
		self.result += '[%s]' % renderreference(self._appData, sel)
		return self
	
	def previous(self, sel):
		self.result += '.previous(%r)' % self._appData.typebycode[sel]
		return self
	
	def next(self, sel):
		self.result += '.next(%r)' % self._appData.typebycode[sel]
		return self
	
	def __getattr__(self, name):
		if name == 'app':
			self.result += self.root
		elif name == 'NOT':
			self.result = '(%s).NOT' % self.result
		else:
			if name not in ['con', 'its']:
				self.result += '.'
			self.result += name
		return self
	
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
	
	def AND(self, *operands):
		self.result = '(%s).AND(%s)' % (self.result, ', '.join([self._format(o) for o in operands]))
		return self
		
	def OR(self, *operands):
		self.result = '(%s).OR(%s)' % (self.result, ', '.join([self._format(o) for o in operands]))
		return self


######################################################################
# PUBLIC
######################################################################

def renderreference(appdata, aemreference):
	"""Take an aem reference, e.g.:
	
		app.elements('docu').byindex(1).property('ctxt')
	
	and an AppData instance containing application's location and terminology, and render an appscript-style reference, e.g.:
	
		"app('/Applications/TextEdit.app').documents[1].text"
		
	Used by Reference.__repr__().
	"""
	f = _Formatter(appdata)
	try:
		aemreference.AEM_resolve(f)
	except:
		return '%s.AS_newreference(%r)' % (f.root, aemreference)
	return f.result
	
