#!/usr/bin/env python

"""sdefparser -- parse an application's sdef, given an application path, file path or XML string. Returns a Dictionary object model.

(C) 2006 HAS"""

# TO DO: objc-appscript support

# TO DO: find app with missing savo and see how this is represented

# Note: OSACopyScriptingDefinition's aete->sdef conversion has bug where classes and commands defined in hidden 'tpnm' suite aren't included in generated sdef (though enumerations are)

# note: xml.sax bug? parser.getProperty(all_properties), getFeature(all_features) raise an error (2.4)

import  xml.sax, xml.sax.xmlreader
from xml.sax.handler import * #ContentHandler, ErrorHandler, property_xml_string
from StringIO import StringIO
import struct

from aem import kae
from aem.ae import copyscriptingdefinition

from osaterminology import makeidentifier
from osadictionary import *


import applescripttypes, appscripttypes

######################################################################
# PRIVATE
######################################################################


class HandlerResult:
	def _add_(self, item):
		self.result = item


##


class Error(ErrorHandler):
	def error(self, exception): print 'error:', exception
	def fatalError(self, exception): print  'fatal:', exception
	def warning(self, exception): print  'warning:', exception


##

class Handler(ContentHandler):
	
	def __init__(self, parser, path):
		self._visibility = [kVisible] # TO DO
		self._parser = parser
		self._path = path
		self._types = {}
		self._classes = [] # used for cleanup
		self._hiddenname = '' # if dictionary element is hidden, all its sub-elements should be hidden too
		self._isvisible = True
		self._stack = [HandlerResult()]
		self._documentationdepth = 0
		
	#######
	
	def startElement(self, name, attrs):
		if self._isvisible and attrs.get('hidden') == 'yes': # start of hidden element; all sub-elements will be flagged as hidden too
			self._hiddenname = name
			self._isvisible = False
		if not self._documentationdepth: # not inside a documentation element, so process normally
			fn = getattr(self, 'start_'+name.replace('-', ''), None)
			if fn:
				fn(attrs)
	
	def endElement(self, name):
		if name == self._hiddenname: # end of hidden element
			self._hiddenname = ''
			self._isvisible = True
		if self._documentationdepth:
			if name == 'documentation':
				self._documentationdepth -= 1
		else:
			if name == self._stack[-1].kind:
				o = self._stack.pop()
				self._stack[-1]._add_(o)

	##
	
	def start_documentation(self, d): # TO DO: documentation support
		self._documentationdepth += 1


	#######
		
	def asname(self, s):
		return s
	
	def ascode(self, s):
		if len(s) in [4, 8]:
			return s.encode('MacRoman')
		else:
			return struct.pack('L', int(s, 16))
	
	def _gettype(self, name):
		name = self.asname(name)
		if not self._types.has_key(name):
			self._types[name] = Type(self._visibility, name)
		return self._types[name]
	
	##
	
	def start_dictionary(self, d):
		self._stack.append(Dictionary(self._visibility, d.get('title', self._path.split('/')[-1] or self._path.split('/')[-2]), self._path)) # OSAGetScriptingDefinition doesn't produce well-formed sdef (missing title) when converting from aete, so compensate here
	
	def start_suite(self, d):
		self._stack.append(Suite(self._visibility, d['name'], self.ascode(d['code']), d.get('description', ''), self._isvisible))
	
	##
	
	def start_class(self, d):
		t = self._gettype(d['name'])
		t.code = self.ascode(d['code'])
		suitename = self._stack[-1].name
		o = Class(self._visibility, t.name, t.code, d.get('description', ''), self._isvisible, 
				self.asname(d.get('plural', t.name+'s')), suitename, t)
		if d.has_key('inherits'):
			o._add_(self._gettype(d['inherits']))
		self._stack.append(o)
		self._classes.append(o)
		t._add_(o)
	
	def start_contents(self, d):
		self._stack.append(Contents(self._visibility, self.asname(d.get('name', 'contents')),
				self.ascode(d.get('code', 'pcnt')), d.get('description', ''), self._isvisible, d.get('access', 'rw')))
		if d.has_key('type'):
			self._stack[-1]._add_(self._gettype(d['type']))
	
	def end_contents(self, d):
		self._stack[-1].contents = self._stack.pop()
	
	def start_property(self, d):
		self._stack.append(Property(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				d.get('description', ''), self._isvisible, d.get('access', 'rw')))
		if d.has_key('type'):
			self._stack[-1]._add_(self._gettype(d['type']))
	
	def start_type(self, d): # type elements = alternative to type attribute
		t = self._gettype(d['type'])
		if d.get('list') == 'yes':
			t = ListOfType(self._visibility, t)
		self._stack.append(t)
	
	def start_element(self, d):
		self._stack.append(Element(self._visibility, self._gettype(d['type']), d.get('description', ''), 
				self._isvisible, d.get('access', 'rw'), self.elementnamesareplural))
	
	def start_accessor(self, d):
		self._stack.append(Accessor(self._visibility, d['style']))
	
	def start_respondsto(self, d):
		self._stack.append(RespondsTo(self._visibility, self.asname(d['name']), self._isvisible))
	
	##
	
	def start_command(self, d):
		suitename = self._stack[-1].name
		self._stack.append(Command(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				d.get('description', ''), self._isvisible, suitename))
	
	def start_parameter(self, d):
		self._stack.append(Parameter(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				 d.get('description', ''), self._isvisible, d.get('optional') == 'yes'))
		if d.has_key('type'):
			self._stack[-1]._add_(self._gettype(d['type']))
	
	def start_directparameter(self, d):
		self._stack.append(DirectParameter(self._visibility, d.get('description', ''), self._isvisible, 
				d.get('optional') == 'yes'))
		if d.has_key('type'):
			self._stack[-1]._add_(self._gettype(d['type']))
	
	def start_result(self, d):
		self._stack.append(Result(self._visibility, d.get('description', '')))
		if d.has_key('type'):
			self._stack[-1]._add_(self._gettype(d['type']))
	
	def start_event(self, d):
		self._stack.append(Event(self._visibility, self.asname(d['name']), self.ascode(d['code']), 
				d.get('description', ''), self._isvisible))
	
	##
	
	def start_enumeration(self, d):
		if d.has_key('inline'):
			inline = int(d['inline'])
		else:
			inline = None
		suitename = self._stack[-1].name
		o = Enumeration(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				d.get('description', ''), self._isvisible, inline, suitename)
		self._stack.append(o)
		t = self._gettype(d['name'])
		t.code = o.code
		t._add_(o)
	
	def start_enumerator(self, d):
		self._stack.append(Enumerator(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				d.get('description', ''), self._isvisible))
	
	def start_recordtype(self, d):
		suitename = self._stack[-1].name
		o = RecordType(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				d.get('description', ''), self._isvisible, suitename)
		self._stack.append(o)
		if d.has_key('type'):
			o._add_(self._gettype(d['type']))
		t = self._gettype(d['name'])
		t.code = o.code
		t._add_(o)
	
	def start_valuetype(self, d):
		suitename = self._stack[-1].name
		o = ValueType(self._visibility, self.asname(d['name']), self.ascode(d['code']),
				d.get('description', ''), self._isvisible, suitename)
		self._stack.append(o)
		t = self._gettype(d['name'])
		t.code = o.code
		t._add_(o)
	
	###
	
	def result(self):	
		# TO DO: fix type names for appscript; add codes for both
		#"""
		# add codes for standard sdef-format types
		#		"""
		# Add codes, etc. for AEM-defined types and enumerations
	#	aemtypesbycode, aemenumerations = self.typemodule.typesandenums()
	#	aemtypes = dict([(v, k) for k, v in aemtypesbycode]) # TO FIX: may use undesireable codes for appscript
	#			if aemtypes.has_key(type.name): # it's an AEM-defined type
	#				type.name = aemtypes[type.code]
			#	elif aemenumerations.has_key(type.code): # it's an AEM-defined enumeration
			#		type._add_(Enumeration('', k, '', True, None))
			#		for name, code in aemenumerations[code]:
			#			type._add_(Enumerator(name, code, '', True))
				# else it's unknown, in which case leave it as-is
	#	for i in self._types.values():
	#		if i.realvalue().kind == 'aem-type':
	#			print i#,'\t\t',i.special
		return self._stack[-1].result

#######
# AppleScript dictionary parser

class AppleScriptHandler(Handler):
	elementnamesareplural = False

#######
# appscript dictionary parser


class AppscriptHandler(Handler):
	elementnamesareplural = True
	applescripttypesbyname = {}
	
	sdeftypesbyname = {
			'any': kae.typeWildCard, 
			'text': kae.typeUnicodeText, 
			'integer': kae.typeInteger, 
			'real': kae.typeFloat, 
			'number': 'nmbr', 
			'boolean': kae.typeBoolean, 
			'specifier': kae.typeObjectSpecifier, 
			'location specifier': kae.typeInsertionLoc,
			'record': kae.typeAERecord, 
			'date': kae.typeLongDateTime,
			'file': 'file', 
			'point': kae.typeQDPoint, 
			'rectangle': kae.typeQDRectangle, 
			'type': kae.typeType}

	# TO DO: expand pseudo-types (start_directparameter, start_parameter, start_result, start_property; c.f. aeteparser, addtypes)
	
	def start_command(self, d):
		# escape any non-standard get/set commands (e.g. InDesign) to avoid conflicts with standard versions
		name, code = d['name'], d['code']
		if (name == 'get' and code != 'coregetd') or (name == 'set' and code != 'coresetd'):
			d = dict(d)	
			d['name'] += '_'
		Handler.start_command(self, d)
	
	def result(self):
		# convert AppleScript type names to AE codes to appscript type names
		# (note: wouldn't need to do this if appscript used AppleScript-style type names)
		if not self.applescripttypesbyname:
			# since parser has already converted type names to appscript style, need to convert our lookup table as well
			for k, v in applescripttypes.typebyname.items():
				self.applescripttypesbyname[self.asname(k)] = v
		for type in self._types.values():
			if not type.code: # not application-defined
				if self.sdeftypesbyname.has_key(type.name):
					type.code = self.sdeftypesbyname[type.name]
				elif self.applescripttypesbyname.has_key(type.name):
					type.code = self.applescripttypesbyname[type.name]
				if type.code:
					if appscripttypemodule.typebycode.has_key(type.code):
						type.name = appscripttypemodule.typebycode[type.code]
					else:
						type.name = '' # TO DO: decide
		return Handler.result(self)



class PyAppscriptHandler(AppscriptHandler):
	asname = staticmethod(makeidentifier.getconverter('py-appscript'))
	appscripttypemodule = appscripttypes.typetables('py-appscript')


class RbAppscriptHandler(AppscriptHandler):
	asname = staticmethod(makeidentifier.getconverter('rb-appscript'))
	appscripttypemodule = appscripttypes.typetables('rb-appscript')


handlers = {
		'applescript': AppleScriptHandler,
		'appscript': PyAppscriptHandler,
		'py-appscript': PyAppscriptHandler,
		'rb-appscript': RbAppscriptHandler,
}

######################################################################
# PUBLIC
######################################################################


def parsexml(sdef, path='', style='appscript'):
	parser = xml.sax.make_parser()
	handler = handlers[style](parser, path)
	parser.setContentHandler(handler)
	parser.setErrorHandler(Error()) # TO DO: better error reporting/handling
	source = xml.sax.xmlreader.InputSource()
	source.setByteStream(StringIO(sdef))
	parser.parse(source)
	return parser.getContentHandler().result()

def parsefile(path, style='appscript'):
	f = file(path)
	sdef = f.read()
	f.close()
	return parsexml(sdef, path, style)

def parseapp(path, style='appscript'):
	sdef = copyscriptingdefinition(path)
	if sdef is None:
		raise RuntimeError, "Can't get sdef (requires OS 10.4+)."
	return parsexml(sdef, path, style)



