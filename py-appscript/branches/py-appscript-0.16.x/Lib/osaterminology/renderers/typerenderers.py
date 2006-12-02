#!/usr/bin/env pythonw

from osaterminology.dom.osadictionary import kAll, Nodes

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


##

class AppscriptTypeRenderer(TypeRendererBase):
	
	def _render(self, type):
		if type.kind == 'type':
			return type.name or 'AEType(%r)' % self.escapecode(type.code)
		elif type.kind == 'enumeration':
			return ' / '.join([e.name and 'k.%s'%e.name or 'AEEnum(%r)' % self.escapecode(e.code) 
					for e in type.enumerators()])
		else:
			return type.name and 'k.%s'%type.name or 'AEType(%r)' % self.escapecode(type.code)
	
	def escapecode(self, s):
		# format non-ASCII characters as '\x00' hex values for readability; TO FIX: escape backslashes correctly
		return ''.join([(31 < ord(c) < 128) and c != '\x5c' and c or '\\x%2.0x' % ord(c) for c in s])
	
	def elementname(self, type): # appscript uses plural names for elements
		type = type.realvalue()
		return getattr(type, 'pluralname', type.name) or self._render(type)


##

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


#######

typerenderers = {
	'applescript': ApplescriptTypeRenderer,
	'appscript': AppscriptTypeRenderer,
	}

