#!/usr/bin/python

import types, datetime, os.path, re

import aem, appscript
from appscript import mactypes
from osaterminology import makeidentifier

from osaterminology.tables.tablebuilder import *

#######

_formatterCache = {}
_self = aem.Application()
_codecs = aem.Codecs()
_convert = makeidentifier.getconverter('objc-appscript')
_terminology = TerminologyTableBuilder('objc-appscript')

######################################################################
# PRIVATE
######################################################################


class _Formatter:
	def __init__(self, typebycode, referencebycode, appvar, prefix, indent=''):
		self._referencebycode = referencebycode
		self._typebycode = typebycode
		self._prefix = prefix
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
		return '[NSNull null]'
	
	def formatBool(self, val):
		return val and 'ASTrue' or 'ASFalse'
	
	def formatInt(self, val): # int, long
		if (-2**31) <= val < (2**31):
			return '[NSNumber numberWithInt: %s]' % val
		elif (-2**63) <= val < (2**63):
			return '[NSNumber numberWithLongLong: %s]' % val
		else:
			return self.format(float(val))
		
	def formatFloat(self, val):
		return '[NSNumber numberWithDouble: %s' % val
	
	##
	
	def formatUnicodeText(self, val): # str, unicode
		return '@"%s"' % val.replace('\\', '\\\\').replace('"', '\\"').replace('\r', '\\r').replace('\n', '\\n').replace('\t', '\\t') # "
	
	def formatStr(self, val):
		return self.formatUnicodeText(_codecs.unpack(_codecs.pack(val).AECoerceDesc('utxt')))
	
	##
		
	def formatDatetime(self, val):
		return '[NSDate dateWithString: %s]' % self.format(val.strftime('%Y-%m-%d %H:%M:%S +0000')) # TO DO: provide current timezone
	
	def formatAlias(self, val):
		return '[ASAlias aliasWithPath: %s]' % self.format(val.path)
	
	def formatFile(self, val):
		return '[NSURL fileURLWithPath: %s]' % self.format(val.path)
	
	##
	
	def formatList(self, val):
		if len(val) == 1:
			return '[NSArray arrayWithObject: %s]' % self.format(val[0])
		elif val:
			self._indent += '\t'
			tmp = ['\n%s%s,' % (self._indent, self.format(v)) for v in val]
			self._indent = self._indent[:-1]
			return '[NSArray arrayWithObjects: %s]' % ''.join(tmp + ['\n%snil' % self._indent])
		else:
			return '[NSArray array]'
	
	def formatDict(self, val):
		if len(val) == 1:
			return '[NSDictionary dictionaryWithObject: %s forKey: %s]' % (self.format(val.values()[0]), self.format(val.keys()[0]))
		elif val:
			self._indent += '\t'
			tmp =['\n%s%s, %s,' % (self._indent, self.format(v), self.format(k)) for k, v in val.items()]
			self._indent = self._indent[:-1]
			return '[NSDictionary dictionaryWithObjectsAndKeys: %s]' % ''.join(tmp + ['\n%snil' % self._indent])
		else:
			return '[NSDictionary dictionary]'
	
	##
	
	def formatConstant(self, val): # type, enumerator, property, keyword
		return '[%sConstant %s]' % (self._prefix, self._typebycode[val.code]) # .AS_name
	


	#######
	# reference formatter
	
	def property(self, code):
		try:
			self.result = '[%s %s]' % (self.result, self._referencebycode[kProperty+code][1])
		except KeyError:
			self.result = '[%s %s]' % (self.result, self._referencebycode[kElement+code][1])
		return self

	def elements(self, code):
		try:
			self.result = '[%s %s]' % (self.result, self._referencebycode[kElement+code][1])
		except KeyError:
			self.result = '[%s %s]' % (self.result, self._referencebycode[kProperty+code][1])
		return self
	
	def byname(self, sel):
		self.result = '[%s byName: %s]' % (self.result, self.format(sel))
		return self
	
	def byindex(self, sel):
		if isinstance(sel, int):
			self.result = '[%s at: %i]' % (self.result, sel)
		else:
			self.result = '[%s byName: %s]' % (self.result, self.format(sel))
		return self
	
	
	def byid(self, sel):
		self.result = '[%s byID: %s]' % (self.result, self.format(sel))
		return self
	
	def byrange(self, sel1, sel2):
		if isinstance(sel1, int) and isinstance(sel2, int):
			self.result = '[%s at: %i to: %i]' % (self.result, sel1, sel2)
		else:
			self.result = '[%s byRange: %s to: %s]' % (self.result, self.format(sel1), self.format(sel2))
		return self
		
	def byfilter(self, sel):
		self.result = '[%s byTest: %s]' % (self.result, self.format(sel))
		return self
	
	def previous(self, sel):
		self.result = '[%s previous: [%sConstant %s]]' % (self.result, self._prefix, self._typebycode[sel])
		return self
	
	def next(self, sel):
		self.result = '[%s next: [%sConstant %s]]' % (self.result, self._prefix, self._typebycode[sel])
		return self
	
	def __getattr__(self, name):
		if name == 'app':
			# TO DO: use 'PREFIXApp' instead of self.root for generic references (i.e. any refs except target ref)
			self.result = self.root
		elif name == 'con':
			self.result = '%sCon' % self._prefix
		elif name == 'its':
			self.result = '%sIts' % self._prefix
		elif name == 'NOT':
			self.result = '[%s NOT]' % self.result
		else:
			self.result = '[%s %s]' % (self.result, name) # TO DO: check
		return self
	
	def gt(self, sel):
		self.result = '[%s greaterThan: %s]' % (self.result, self.format(sel))
		return self
	
	def ge(self, sel):
		self.result = '[%s greaterOrEquals: %s]' % (self.result, self.format(sel))
		return self
	
	def eq(self, sel):
		self.result = '[%s equals: %s]' % (self.result, self.format(sel))
		return self
	
	def ne(self, sel):
		self.result = '[%s notEquals: %s]' % (self.result, self.format(sel))
		return self
	
	def lt(self, sel):
		self.result = '[%s lessThan: %s]' % (self.result, self.format(sel))
		return self
	
	def le(self, sel):
		self.result = '[%s lessOrEquals: %s]' % (self.result, self.format(sel))
		return self
	
	def beginswith(self, sel):
		self.result = '[%s beginsWith: %s]' % (self.result, self.format(sel))
		return self
	
	def endswith(self, sel):
		self.result = '[%s endsWith: %s]' % (self.result, self.format(sel))
		return self
	
	def contains(self, sel):
		self.result = '[%s contains: %s]' % (self.result, self.format(sel))
		return self
	
	def isin(self, sel):
		self.result = '[%s isIn: %s]' % (self.result, self.format(sel))
		return self
	
	def AND(self, *operands):
		if len(operands) == 1:
			operands = operands[0]
		self.result ='[%s AND: %s]' % (self.result, self.format(operands))
		return self
		
	def OR(self, *operands):
		if len(operands) == 1:
			operands = operands[0]
		self.result ='[%s OR: %s]' % (self.result,self.format(operands))
		return self
	
	#######
	
	def format(self, val):
		if isinstance(val, (appscript.Reference, appscript.Keyword)): # kludge; TO DO: eventformatter should pass aem objects to each renderer module
			val = _codecs.unpack(_appData.pack(val))
		if isinstance(val, aem.Query):
			f = _Formatter(self._typebycode, self._referencebycode, self.root, self._prefix, self._indent)
			val.AEM_resolve(f)
			return f.result
		else:
			return self._valueFormatters[val.__class__](val)


def makeprefix(name):
	m = re.findall('\\b.*?([A-Z])\W*?([A-Z]*)', name.upper())
	s = m[0][0]
	if len(m) >= 2:
		s += m[1][0]
	else:
		s += m[0][1][0]
	return s


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
		appvar = _convert(appname.lower())
		prefix = makeprefix(appname)
		
		s = '// To create glue:  osaglue  -o %sGlue  -p %s  %s\n\n' % (prefix, prefix, appname)
		
		f = _Formatter(typebycode, referencebycode, '', '')
		s += '%sApplication *%s = [%sApplication applicationWithName: %s];\n\n' % (
				prefix, appvar, prefix, f.format(appname)) # TO DO: use bundle ID if available

		commandname, paramnamebycode = referencebycode[kCommand+eventcode][1]
		
		if directparam is not None:
			f = _Formatter(typebycode, referencebycode, appvar, prefix)
			directparam = f.format(directparam)
		
		params = []
		for k, v in paramsdict.items():
			f = _Formatter(typebycode, referencebycode, appvar, prefix)
			params.append('%s: %s' % (paramnamebycode[k], f.format(v)))
		
		if targetref and not isinstance(targetref, appscript.Application):
			f = _Formatter(typebycode, referencebycode, appvar, prefix)
			s += '%sReference *ref = %s;\n\n' % (prefix, f.format(targetref))
			target = 'ref'
		else:
			target = appvar
		if params or resulttype or modeflags != 0x1043 or timeout != -1:
			if eventcode == 'coresetd': 
				# unlike py-appscript, objc-appscript doesn't special-case 'set' command's 'to' param,
				# so put it back in params list
				params = ['to: %s' % directparam] + params
				directparam = None
			classprefix = commandname[0].upper() + commandname[1:]
			if directparam:
				tmp = '[%s %s: %s]' % (target, commandname, directparam)
			else:
				tmp = '[%s %s]' % (target, commandname)
			for param in params:
				tmp = '[%s %s]' % (tmp, param)
			# args
			if resulttype:
				code = _codecs.unpack(appdata.pack(resulttype)).code
				tmp = '[%s requestedType: [ASConstant %s]]' % (tmp, typebycode[code]) # .AS_name
			if timeout != -1:
				tmp = '[%s timeout: %i]' % (tmp, timeout / 60)
			if modeflags & 3 == aem.kae.kAENoReply:
				tmp = '[%s ignoreReply]' % tmp
			
			s += '%s%sCommand *cmd = %s;\n\n' % (prefix, classprefix, tmp)
			target = 'cmd'
		elif eventcode == 'coresetd':
			return s + 'id result = [%s setItem: %s];\n' % (target, directparam)
		elif eventcode == 'coregetd':
			return s + 'id result = [%s getItem];\n' % target
		else:
			target = '[%s %s]' % (target, commandname)
		s += 'id result = [%s send];\n' % target
		return s
		
	except Exception, e:
		import traceback
		
		return '%s\n\n%s' % (e, traceback.format_exc())


