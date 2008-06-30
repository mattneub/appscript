#!/usr/bin/python

import types, datetime, os.path

import aem, appscript
from appscript import mactypes
from osaterminology import makeidentifier

from terminology import *

#######

_formatterCache = {}
_self = aem.Application()
_codecs = aem.Codecs()
_convert = makeidentifier.getconverter('rb-appscript')
_terminology = Terminology('rb-appscript')

######################################################################
# PRIVATE
######################################################################


kNested = 1
kNotNested = -1


class _Formatter:
	def __init__(self, typebycode, referencebycode, appvar, nested=kNested, indent=''):
		self._referencebycode = referencebycode
		self._typebycode = typebycode
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
				mactypes.Alias: self.formatAlias,
				mactypes.File: self.formatFile,
				aem.AEType: self.formatConstant,
				aem.AEEnum: self.formatConstant,
				aem.AEProp: self.formatConstant,
				aem.AEKey: self.formatConstant,
		}
		self.root = appvar
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
		return "'%s'" % val.replace('\\', '\\\\').replace("'", "\\'").replace('\r', '\\r').replace('\n', '\\n').replace('\t', '\\t') # '
	
	def formatStr(self, val):
		return self.formatUnicodeText(_codecs.unpack(_codecs.pack(val).AECoerceDesc('utxt')))
	
	##
		
	def formatDatetime(self, val):
		return 'Time.local(%i, %i, %i, %i, %i, %i)' % (val.year, val.month, val.day, val.hour, val.minute, val.second)
	
	def formatAlias(self, val):
		return 'MacTypes::Alias.path(%s)' % self.format(val.path)
	
	def formatFile(self, val):
		return 'MacTypes::FileURL.path(%s)' % self.format(val.path)
	
	##
	
	def formatList(self, val):
			self._indent += '\t'
			tmp = ['\n%s%s,' % (self._indent, self.format(v)) for v in val]
			self._indent = self._indent[:-1]
			return '[%s]' % ''.join(tmp)
	
	def formatDict(self, val):
		self._indent += '\t'
		tmp =['\n%s%s => %s,' % (self._indent, self.format(v), self.format(k)) for k, v in val.items()]
		self._indent = self._indent[:-1]
		return '{%s}' % ''.join(tmp)
	
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
				self.result = self.root
		elif name == 'NOT':
			self.result = '%s.not' % self.result
		else:
			if name not in ['con', 'its']: # TO DO
				self.result += '.'
			self.result += name
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
		if isinstance(val, (appscript.Reference, appscript.Keyword)): # kludge; TO DO: eventformatter should pass aem objects to each renderer module
			val = _codecs.unpack(_appData.pack(val))
		if isinstance(val, aem.Query):
			f = _Formatter(self._typebycode, self._referencebycode, self.root, self._nested + 1, self._indent)
			val.AEM_resolve(f)
			return f.result
		else:
			return self._valueFormatters[val.__class__](val)

######################################################################
# PUBLIC
######################################################################


def renderCommand(apppath, addressdesc, 
		eventcode, 
		targetref, directparam, paramsdict, 
		resulttype, modeflags, timeout, 
		appdata):
	global _appData
	_appData = appdata
	try:
		if not _formatterCache.has_key((addressdesc.type, addressdesc.data)):
			typebycode, typebyname, referencebycode, referencebyname = \
					_terminology.tablesforapp(aem.Application(desc=addressdesc))
			_formatterCache[(addressdesc.type, addressdesc.data)] = typebycode, referencebycode
		typebycode, referencebycode = _formatterCache[(addressdesc.type, addressdesc.data)]
		
		appname = os.path.splitext(os.path.basename(apppath))[0]
		f = _Formatter(typebycode, referencebycode, '', kNotNested)
		appvar = 'app(%s)' % f.format(appname)
		
		if targetref and not isinstance(targetref, appscript.Application):
			f = _Formatter(typebycode, referencebycode, appvar, kNotNested)
			target = f.format(targetref)
		else:
			target = appvar
		
		commandname, paramnamebycode = referencebycode[kCommand+eventcode][1]
		
		args = []
		
		if directparam is not None:
			args.append(_Formatter(typebycode, referencebycode, appvar).format(directparam))
		
		for k, v in paramsdict.items():
			f = _Formatter(typebycode, referencebycode, appvar)
			args.append(':%s => %s' % (paramnamebycode[k], f.format(v)))
		
		if resulttype:
			code = _codecs.unpack(appdata.pack(resulttype)).code
			args.append(':result_type => :%s' % typebycode[code]) # .AS_name
		if timeout != -1:
			args.append(':timeout => %i' % (timeout / 60))
		if modeflags & 3 == aem.kae.kAENoReply:
			args.append(':wait_reply => false')
		
		return '%s.%s(%s)' % (target, commandname, ', '.join(args))
		
	except Exception, e:
		import traceback
		
		return '%s\n\n%s' % (e, traceback.format_exc())


