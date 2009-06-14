#!/usr/bin/env python

from osaterminology.dom.osadictionary import kAll, Nodes

from codecs import getencoder

strtohex = getencoder('hex_codec')


######################################################################


class TypeRendererBase:

	def __init__(self):
		self._renderedtypes = {} # cache
	
	def render(self, types, sep=' | '): # TO DO: rename (typeorenum? typename?) 
#		oldvis = types.setvisibility(kAll) # TO DO: find right place for these calls
		res = []
		if not isinstance(types, (list, Nodes)):
			types = [types]
		for otype in types:
			type = otype.realvalue() # TO DO: this might throw up weird results if there's a mix (not that there should be if the dictionary is properly designed...)
			if type.code:
				if not self._renderedtypes.has_key(type.code):
					self._renderedtypes[type.code] = self._render(type)
				s = self._renderedtypes[type.code]
			else:
				s = type.name
			if otype.islist:
				s = 'list of '+s
			res.append(s)
#		types.setvisibility(oldvis)
		return sep.join(res)


######################################################################


class AppscriptTypeRenderer(TypeRendererBase):
	
	def _render(self, type):
		if type.kind == 'enumeration':
			return ' / '.join([e.name and self._keyword % e.name or self._enum % self.escapecode(e.code) 
					for e in type.enumerators()])
		else:
			return type.name or self._type % self.escapecode(type.code)
	
	def escapecode(self, s):
		# format non-ASCII characters as '\x00' hex values for readability (also backslash and single and double quotes)
		res = ''
		for c in s:
			n = ord(c)
			if 31 < n < 128 and c not in '\\\'"':
				res += c
			else:
				res += '\\x%02x' % n
		return res
	
	def elementname(self, type): # appscript uses plural names for elements
		type = type.realvalue()
		return getattr(type, 'pluralname', type.name) or self._render(type)


class ObjCAppscriptTypeRenderer(AppscriptTypeRenderer):
	_type = '<ASType %s>'
	_enum = '<ASEnum %s>'
	_keyword = '%s'
	
	def escapecode(self, s):
		if [c for c in s if not (31 < ord(c) < 128) or c in '\\\'"']:
			return '0x' + strtohex(s)[0]
		else:
			return "'%s'" % s


class PyAppscriptTypeRenderer(AppscriptTypeRenderer):
	_type = 'AEType("%s")'
	_enum = 'AEEnum("%s")'
	_keyword = 'k.%s'


class RbAppscriptTypeRenderer(AppscriptTypeRenderer):
	_type = 'AEType.new("%s")'
	_enum = 'AEEnum.new("%s")'
	_keyword = ':%s'


######################################################################


class ApplescriptTypeRenderer(TypeRendererBase):
		
	def _render(self, type):
		if type.kind == 'enumeration':
			return ' / '.join([e.name or '<constant ****%s>' % self.escapecode(e.code) 
					for e in type.enumerators()])
		else:
			return type.name or '<class %s>' % self.escapecode(type.code)
	
	def escapecode(self, s):
		return unicode(s, 'macroman')
	
	def elementname(self, type): # AppleScript uses singular names for elements
		return self._render(type.realvalue())


######################################################################

typerenderers = {
	'applescript': ApplescriptTypeRenderer,
	'appscript': PyAppscriptTypeRenderer,
	'objc-appscript': ObjCAppscriptTypeRenderer,
	'py-appscript': PyAppscriptTypeRenderer,
	'rb-appscript': RbAppscriptTypeRenderer,
	}

######################################################################


def gettyperenderer(name):
	try:
		return typerenderers[name]()
	except KeyError:
		raise KeyError, "Couldn't find a type renderer named %r." % name

