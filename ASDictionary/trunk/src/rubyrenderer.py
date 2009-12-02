""" rubyrenderer -- Render rb-appscript style references from py-appscript references

(C) 2007-2009 HAS
"""

import types, datetime

import aem, appscript
from osaterminology.tables.tablebuilder import *


######################################################################
# PRIVATE
######################################################################


kNested = 1
kNotNested = -1


class _Formatter:
	def __init__(self, typebycode, referencebycode, root='app', nested=kNotNested, indent='', codecs=None):
		self._codecs = codecs
		self._referencebycode = referencebycode
		self._typebycode = typebycode
		self._root = root
		self._nested = nested
		self._indent = indent
		self._valueFormatters = {
				types.NoneType: self.formatNone,
				types.BooleanType: self.formatBool,
				types.IntType: self.formatInt,
				types.LongType: self.formatInt,
				types.FloatType: self.formatFloat,
				types.StringType: self.formatStr,
				types.UnicodeType: self.formatUnicodeText, 
				types.ListType: self.formatList,
				types.DictionaryType: self.formatDict,
				datetime.datetime: self.formatDatetime,
				appscript.mactypes.Alias: self.formatAlias,
				appscript.mactypes.File: self.formatFile,
				aem.AEType: self.formatConstant,
				aem.AEEnum: self.formatConstant,
				aem.AEProp: self.formatConstant,
				aem.AEKey: self.formatConstant,
		}
		self.result =''
	
	#######
	# scalar/collection formatter
		
	def formatNone(self, val):
		return 'nil'
	
	def formatBool(self, val):
		return val and 'true' or 'false'
	
	def formatInt(self, val): # int, long
		return '%i' % val
		
	def formatFloat(self, val):
		return '%f' % val
	
	##
	
	def formatUnicodeText(self, val): # str, unicode
		s = val.replace('\\', '\\\\').replace('"', '\\"').replace('#{', '\\#{').replace('\r', '\\r').replace('\n', '\\n').replace('\t', '\\t') # "
		s = s.encode('utf8')
		r = []
		for c in s:
			i = ord(c)
			if 32 <= i < 127:
				r.append(c)
			else:
				r.append('\\%03o' % i)
		s = ''.join(r)
		return '"%s"' % s
	
	def formatStr(self, val):
		return self.formatUnicodeText(self._codecs.unpack(self._codecs.pack(val).coerce('utxt')))
	
	##
		
	def formatDatetime(self, val):
		return 'Time.local(%i, %i, %i, %i, %i, %i)' % (val.year, val.month, val.day, val.hour, val.minute, val.second)
	
	def formatAlias(self, val):
		return 'MacTypes::Alias.path(%s)' % self.format(val.path)
	
	def formatFile(self, val):
		return 'MacTypes::FileURL.path(%s)' % self.format(val.path)
	
	##
	
	def formatList(self, val):
		values = [self.format(v) for v in val]
		s = '[%s]' % ', '.join(values)
		if len(s) < 40:
			return s
		else:
			self._indent += '    '
			tmp = ['\n%s%s' % (self._indent, v) for v in values]
			self._indent = self._indent[:-4]
			return '[%s\n%s]' % (','.join(tmp), self._indent)
	
	def formatDict(self, val):
		if val:
			self._indent += '    '
			tmp = []
			for k, v in val.items():
				s = '\n%s%s => ' % (self._indent, self.format(k))
				indent = self._indent
				indent2 = len(s)
				self._indent += ' ' * (indent2 - 5)
				s += self.format(v)
				self._indent = indent
				tmp.append(s)
			self._indent = self._indent[:-4]
			return '{%s\n%s}' % (','.join(tmp), self._indent)
		else:
			return '{}'
	
	##
	
	def formatConstant(self, val): # type, enumerator, property, keyword
		return ':%s' % (self._typebycode[val.code]) # .AS_name
	


	#######
	# reference formatter
	
	def property(self, code):
		try:
			self.result = '%s.%s' % (self.result, self._referencebycode[kProperty+code][1])
		except KeyError:
			self.result = '%s.%s' % (self.result, self._referencebycode[kElement+code][1])
		return self

	def elements(self, code):
		try:
			self.result = '%s.%s' % (self.result, self._referencebycode[kElement+code][1])
		except KeyError:
			self.result = '%s.%s' % (self.result, self._referencebycode[kProperty+code][1])
		return self
	
	def byname(self, sel):
		self.result = '%s[%s]' % (self.result, self.format(sel))
		return self
	
	def byindex(self, sel):
		self.result = '%s[%s]' % (self.result, self.format(sel))
		return self
	
	
	def byid(self, sel):
		self.result = '%s.ID(%r)' % (self.result, self.format(sel))
		return self
	
	def byrange(self, sel1, sel2):
		self.result = '%s[%s, %s]' % (self.result, self.format(sel1), self.format(sel2))
		return self
		
	def byfilter(self, sel):
		self.result = '%s[%s]' % (self.result, self.format(sel))
		return self
	
	def previous(self, sel):
		self.result = '%s.previous(:%s)' % (self.result, self._typebycode[sel])
		return self
	
	def next(self, sel):
		self.result = '%s.next(:%s)' % (self.result, self._typebycode[sel])
		return self
	
	def __getattr__(self, name):
		if name == 'app':
			if self._nested:
				self.result = 'app'
			else:
				self.result = self._root
		elif name == 'con':
			self.result = 'con'
		elif name == 'its':
			self.result = 'its'
		elif name == 'NOT':
			self.result = '%s.not' % self.result
		else:
			self.result = '%s.%s' % (self.result, name)
		return self
	
	def gt(self, sel):
		self.result = '%s.gt(%s)' % (self.result, self.format(sel))
		return self
	
	def ge(self, sel):
		self.result = '%s.ge(%s)' % (self.result, self.format(sel))
		return self
	
	def eq(self, sel):
		self.result = '%s.eq(%s)' % (self.result, self.format(sel))
		return self
	
	def ne(self, sel):
		self.result = '%s.ne(%s)' % (self.result, self.format(sel))
		return self
	
	def lt(self, sel):
		self.result = '%s.lt(%s)' % (self.result, self.format(sel))
		return self
	
	def le(self, sel):
		self.result = '%s.le(%s)' % (self.result, self.format(sel))
		return self
	
	def beginswith(self, sel):
		self.result = '%s.begins_with(%s)' % (self.result, self.format(sel))
		return self
	
	def endswith(self, sel):
		self.result = '%s.ends_with(%s)' % (self.result, self.format(sel))
		return self
	
	def contains(self, sel):
		self.result = '%s.contains(%s)' % (self.result, self.format(sel))
		return self
	
	def isin(self, sel):
		self.result = '%s.is_in(%s)' % (self.result, self.format(sel))
		return self
	
	def AND(self, *operands):
		if len(operands) == 1:
			operands = operands[0]
		self.result ='(%s).and(%s)' % (self.result, self.format(operands))
		return self
		
	def OR(self, *operands):
		if len(operands) == 1:
			operands = operands[0]
		self.result ='(%s).or(%s)' % (self.result,self.format(operands))
		return self
	
	#######
	
	def format(self, val):
		if isinstance(val, aem.Query):
			f = _Formatter(self._typebycode, self._referencebycode, 
					self._root, self._nested + 1, self._indent, self._codecs)
			val.AEM_resolve(f)
			return f.result
		else:
			return self._valueFormatters[val.__class__](val)


######################################################################
# PUBLIC
######################################################################

# note: appscriptsupport module provides caching

class RubyRenderer:
	
	_codecs = _terminology = None
	
	def __init__(self, appobj, aetes):
		if not self._codecs:
			self.__class__._codecs = aem.Codecs()
			self.__class__._terminology = TerminologyTableBuilder('rb-appscript')
		self.appobj = appobj
		self.typebycode, typebyname, self.referencebycode, referencebyname = \
				self._terminology.tablesforaetes(aetes)
		f = _Formatter(self.typebycode, self.referencebycode, codecs=self._codecs)
		constructor = appobj.AS_appdata.constructor
		identity = appobj.AS_appdata.identifier
		if constructor == 'path':
			self.root = 'app(%s)' % f.format(identity)
		elif constructor == 'pid':
			self.root = 'app.by_pid(%s)' % f.format(identity)
		elif constructor == 'url':
			self.root = 'app.by_url(%s)' % f.format(identity)
		elif constructor == 'current':
			self.root = 'app.current'
		else: # note: 'aemapp' constructor is unsupported
			raise RuntimeError, 'Unknown constructor: %r' % constructor
		
	
	def rendervalue(self, value, prettyprint=False): 
		# (note: pretty printing flag ignored; this renderer always pretty prints)
		desc = self.appobj.AS_appdata.pack(value)
		value = self._codecs.unpack(desc)
		f = _Formatter(self.typebycode, self.referencebycode, self.root, codecs=self._codecs)
		return f.format(value)


