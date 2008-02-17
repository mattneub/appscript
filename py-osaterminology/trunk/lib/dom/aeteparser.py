#!/usr/bin/env pythonw

# TO DO: synonym support, e.g. In Word:

#    ins (see Type Names Suite)
#    insertion_point -- An insertion location between ...
# Note: when adding synonyms, ignore doubles


# TO DO: any plural classes without matching singular classes should be made singular too


"""aeteparser -- parse an application's aete, given an application path, file path(s) or aete string. Returns a Dictionary object model.

(C) 2006 HAS
"""

from aem.ae import AECreateDesc
from aem import kae

from osadictionary import *
from osaterminology import getterminology, makeidentifier
from osaterminology.sax import aeteparser

# moved following from typemodule methods as putting them there causes import(?) problems in ASDictionary
import applescripttypes, appscripttypes, objcappscripttypes


######################################################################

_expandedtypes = {
		'lr  ': ['list', 'reco'],
		'ls  ': ['list', 'TEXT'],
		'ns  ': ['nmbr', 'TEXT'],
		'sf  ': ['alis', 'TEXT'],
		'lrs ': ['list', 'reco', 'TEXT'],
		'nd  ': ['nmbr', 'ldt '],
		'nds ': ['nmbr', 'ldt ', 'TEXT'],
		} # archaic pseudo-types defined in AppleScript component as a workaround for the aete format's inability to list >1 type per property/parameter
		# Note: OSAGetScriptingDefinition's aete->sdef converter doesn't expand these, using the type attribute (e.g. <...type="list or record".../>) instead of multiple type elements. Similar pseudo-types defined by individual applications' aetes won't be expanded by either aeteparser or sdefparser.


class _Parser(aeteparser.Receiver):

	def __init__(self, path=''):
		self._visibility = [kVisible] # TO DO
		name = '/' in path and (path.split('/')[-1] or path.split('/')[-2]) or path
		self._stack = [Dictionary(self._visibility, name, path)]
		self._visible = True
		self._types = {}
		self._classes = [] # used to add plural names to classes in postprocessing
		self._pluralclassnames = {} # used to add plural names to classes in postprocessing
		self._accessors ={
				kae.formAbsolutePosition:Accessor(self._visibility, 'index'), 
				kae.formName:Accessor(self._visibility, 'name'),
				kae.formUniqueID:Accessor(self._visibility, 'id'),
				kae.formRange:Accessor(self._visibility, 'range'),
				kae.formRelativePosition:Accessor(self._visibility, 'relative'), 
				kae.formTest:Accessor(self._visibility, 'test')}


	def asname(self, s): # overrideable
		return s
	
	def _gettype(self, code):
		if not self._types.has_key(code):
			self._types[code] = Type(self._visibility, code=code)
		return self._types[code]
	
	def _end(self):
		n = self._stack.pop()
		self._stack[-1]._add_(n)
			
	def addtypes(self, type, islist, parent):
		for code in _expandedtypes.get(type, [type]):
			t = self._gettype(code=code)
			if islist:
				t = ListOfType(self._visibility, t)
			parent._add_(t)
	
	#######
	# parse suite
	
	def start_suite(self, code, name, description):
		self._visible = code != 'tpnm' # hidden Type Name Suite; note: suspect OSAGetScriptingDefinition arses up the content of  this suite when converting aete->sdef
		self._stack.append(Suite(self._visibility, name, code, description, self._visible))
	
	def end_suite(self):
		self._visible = True
		self._end()
	
	#######
	# parse command
	
	def start_command(self, code, name, description, directarg, reply):
		self._kargs = []
		suitename = self._stack[-1].name
		self._stack.append(Command(self._visibility, self.asname(name), code, description, self._visible, suitename))
		description, type, isoptional, islist, isenum = directarg
		if type != 'null':
			o = DirectParameter(self._visibility, description, self._visible, isoptional)
			self.addtypes(type, islist, o)
			self._stack[-1]._add_(o)
		description, type, isoptional, islist, isenum = reply
		if type != 'null':
			o = Result(self._visibility, description)
			self.addtypes(type, islist, o)
			self._stack[-1]._add_(o)
	
	def add_labelledarg(self, code, name, description, type, isoptional, islist, isenum):
		o = Parameter(self._visibility, self.asname(name), code, description, self._visible, isoptional)
		self.addtypes(type, islist, o)
		self._stack[-1]._add_(o)	
	
	end_command = _end
	
	#######
	# parse class
	
	def start_class(self, code, name, description):	
		self._isPlural = False
		name = self.asname(name)
		suitename = self._stack[-1].name
		o = Class(self._visibility, name, code, description, self._visible, name, suitename, self._gettype(code))
		self._stack.append(o) # no plural name yet
	
	def end_class(self):
		o = self._stack.pop()
		if self._isPlural:
			self._pluralclassnames[o.code] = o.name
		else:
			self._stack[-1]._add_(o)
			self._classes.append(o)
			t = self._gettype(o.code)
			t.name = o.name
			t._add_(o)
	
	def add_superclass(self, type):
		self._stack[-1]._add_(self._gettype(code=type))
		
	def is_plural(self):
		self._isPlural  = True
	
	def add_property(self, code, name, description, type, islist, isenum, ismutable):
		o = Property(self._visibility, self.asname(name), code, description, self._visible, ismutable and 'rw' or 'r')
		self.addtypes(type, islist, o)
		self._stack[-1]._add_(o)
	
	def start_element(self, type):
		self._stack.append(Element(self._visibility, self._gettype(type), '', self._visible, 'rw', self.elementnamesareplural))
		
	def add_supportedform(self, formcode):
		try:
			self._stack[-1]._add_(self._accessors[formcode])
		except KeyError: # squelch invalid element reference forms (e.g. iMagine Photo includes 'prop')
			pass
	
	end_element = _end
	
	#######
	# parse enumeration
	
	def start_enumeration(self, code):
		suitename = self._stack[-1].name
		o = Enumeration([kAll], '', code, '', self._visible, None, suitename) # TO DO: temporary kludge (replacing self._visibility with [kAll]) to stop enums being hidden in (e.g.) Finder just because they're defined in the hidden tpnm suite
		self._stack.append(o)
		t = self._gettype(code)
		t.name = code
		t._add_(o)
	
	def add_enumerator(self, code, name, description):
		self._stack[-1]._add_(Enumerator([kAll], self.asname(name), code, description, self._visible)) # TO DO: temporary kludge (replacing self._visibility with [kAll]) to stop enums being hidden in (e.g.) Finder just because they're defined in the hidden tpnm suite
	
	end_enumeration = _end
	
	#######
	
	def result(self):
		# Add plural class names to Class instances.
		for klass in self._classes:
			klass.pluralname = self._pluralclassnames.get(klass.code, klass.name)
		# Add names, etc. for AEM-defined types and enumerations
		defs = self.typemodule()
		for type in self._types.values():
			if not type.name: # not an application-defined class
				if defs.typebycode.has_key(type.code): # it's an AEM-defined type
					type.name = defs.typebycode[type.code]
				elif defs.enumerationbycode.has_key(type.code): # it's an AEM-defined enumeration
					type._add_(Enumeration(self._visibility, '', k, '', True, None))
					for name, code in defs.enumerationbycode[code]:
						type._add_(Enumerator(self._visibility, name, code, '', True))
				# else it's unknown, in which case leave it as-is
		# Return Dictionary instance
		return self._stack[0]


#######
# AppleScript dictionary parser

class AppleScriptParser(_Parser):
	elementnamesareplural = False
	
	def typemodule(self):
		return applescripttypes


#######
# appscript dictionary parser

class AppscriptParser(_Parser):
	elementnamesareplural = True
	
	def typemodule(self):
		return appscripttypes
	
	def start_command(self, code, name, description, directarg, reply):
		if (name == 'get' and code != 'coregetd') or (name == 'set' and code != 'coresetd'):
			name += '_' # escape non-standard get/set commands (e.g. InDesign)
		_Parser.start_command(self, code, name, description, directarg, reply)


class ObjCAppscriptParser(AppscriptParser):
	asname = staticmethod(makeidentifier.getconverter('objc-appscript'))
	
	def typemodule(self):
		return objcappscripttypes


class PyAppscriptParser(AppscriptParser):
	asname = staticmethod(makeidentifier.getconverter('py-appscript'))


class RbAppscriptParser(AppscriptParser):
	asname = staticmethod(makeidentifier.getconverter('rb-appscript'))


_parsers = {
		'applescript': AppleScriptParser, 
		'appscript': PyAppscriptParser,
		'objc-appscript': ObjCAppscriptParser,
		'py-appscript': PyAppscriptParser,
		'rb-appscript': RbAppscriptParser,
}


######################################################################
# Main

def parseaetes(aetes, path='', style='appscript'):
	# aetes : list of AEDesc -- a list of zero or more AEDescs of typeAETE/typeAEUT
	p = _parsers[style](path)
	aeteparser.parse(aetes, p)
	return p.result()


def parselang(code='ascr', style='appscript'):
	return parseaetes(getterminology.getaeut(code), '', style)


def parsefile(paths, style='appscript'):
	if isinstance(paths, basestring):
		paths = [paths]
	aetes = []
	for path in paths:
		f = file(path)
		aetes.append(AECreateDesc(kae.typeAETE, f.read()))
		f.close()
	return parseaetes(aetes, paths[0], style)
	

def parseapp(path, style='appscript'):
	return parseaetes(getterminology.getaete(path), path, style)


