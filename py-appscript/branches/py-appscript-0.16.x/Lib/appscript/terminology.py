#!/usr/bin/env python

"""terminology -- Obtains an application's aete resource(s) using a 'ascrgdte' event and converts them into lookup tables for use in AppData objects.

(C) 2004 HAS
"""

from aem import AEType, AEEnum, Application
from osaterminology import appscripttypedefs

from terminologyparser import buildtablesforaetes
from keywordwrapper import Keyword

__all__ = ['tablesforapp', 'tablesfordata', 'kProperty', 'kElement', 'kCommand', 'defaulttypesbycode']


######################################################################
# PUBLIC
######################################################################
# Constants

kProperty = 'p'
kElement = 'e'
kCommand = 'c'

######################################################################
# PRIVATE
######################################################################
# Cache

_terminologyCache = {} # cache parsed terminology

######################################################################
# Default terminology tables for converting between human-readable identifiers and Apple event codes; used by all apps.
# Includes default entries for Required Suite, get/set and miscellaneous other commands; application may override some or all of these definitions.

# Type tables; used to translate constants
# e.g. k.document <-> AEType('docu')
# e.g. k.ask <-> AEEnum('ask ')

_typebyname = {} # used to encode class and enumerator keywords
_typebycode = {} # used to decode class (typeType) and enumerator (typeEnum) descriptors

for _, enumerators in appscripttypedefs.enumerations:
	for name, code in enumerators:
		_typebyname[name] = AEEnum(code)
		_typebycode[code] = Keyword(name)
for defs in [
		appscripttypedefs.alltypes, 
		appscripttypedefs.commontypes, 
		appscripttypedefs.properties]:
	for name, code in defs:
		_typebyname[name] = AEType(code)
		_typebycode[code] = Keyword(name)

# Reference tables; used to translate references and commands
# e.g. app(...).documents.text <-> app.elements('docu').property('ctxt')
# e.g. app(...).quit(saving=k.ask) <-> Application(...).event('aevtquit', {'savo': AEEnum('ask ')})

_defaultcommands = {
		# 'run', 'open', 'print' and 'quit' are Required Suite commands so should always be available.
		'run': (kCommand, ('aevtoapp', {})),
		'open': (kCommand, ('aevtodoc', {})),
		'print_': (kCommand, ('aevtpdoc', {})),
		'quit': (kCommand, ('aevtquit', {'saving': 'savo'})),
		# 'reopen' and 'activate' aren't normally listed in terminology.
		'reopen': (kCommand, ('aevtrapp', {})),
		'activate': (kCommand, ('miscactv', {})),
		# 'launch' is a special case not listed in terminology. The 'real' implementation is actually in reference.Reference, as it needs to use the Process Manager to launch an application without sending it a run/open event.
		'launch': (kCommand, ('ascrnoop', {})),
		# 'get' and 'set' command often aren't listed in terminology
		'get': (kCommand, ('coregetd', {})),
		'set': (kCommand, ('coresetd', {'to': 'data'})),
		# some apps (e.g. Safari) which support GetURL events may omit it from their terminology; 'open location' is the name Standard Additions defines for this event
		'open_location': (kCommand, ('GURLGURL', {'window': 'WIND'})), 
		}

_referencebycode = { # used to decode property and element specifiers
		# some apps, e.g. Jaguar Finder, may omit 'class' property from terminology
		'ppcls': (kProperty, 'class_'),
		# some apps, e.g. iTunes, may omit 'id' property from terminology
		'pID  ': (kProperty, 'id'),
		}

_referencebyname = { # used to encode property and element specifiers and Apple events
		'class_': (kProperty, 'pcls'),
		'id': (kProperty, 'ID  '),
		}
_referencebyname.update(_defaultcommands)


######################################################################
# Translation table parsers

def _makeTypeTable(classes, enums, properties):
	# Used for constructing k.keywords
	# Each parameter is of format [[name, code], ...]
	typebycode = _typebycode.copy()
	typebyname = _typebyname.copy()
	for klass, table in [(AEType, classes), (AEEnum, enums), (AEType, properties)]: # note: packing properties as AEProp causes problems when the same name is used for both a class and a property, and the property's definition masks the class's one (e.g. Finder's 'file'); if an AEProp is passed where an AEType is expected, it can cause an error as it's not what the receiving app expects. (Whereas they may be more tolerant of an AEType being passed where an AEProp is expected.) Also, note that AppleScript always seems to pack property names as typeType, so we should be ok following its lead here.
		for name, code in table:
			# TO DO: decide where best to apply AE keyword escaping, language keyword escaping
			# TO DO: make sure same collision avoidance is done in help terminology (i.e. need to centralise all this stuff in a single osaterminology module)
			# If an application-defined name overlaps an existing type name but has a different code, append '_' to avoid collision:
			if _typebyname.has_key(name) and _typebyname[name].code != code:
				name += '_'
			typebycode[code] = Keyword(name)
			typebyname[name] = klass(code)
	return typebycode, typebyname


def _makeReferenceTable(properties, elements, commands):
	# Used for constructing references and commands
	# First two parameters are of format [[name, code], ...]
	# Last parameter is of format [name, code, direct arg type, [[arg code, arg name], ...]]
	referencebycode = _referencebycode.copy()
	referencebyname = _referencebyname.copy()
	for kind, table in [(kProperty, properties), (kElement, elements)]: # note that when an element and a property have the same name and code, we want to pack as an all-elements specifier (this is what AS does)
		for name, code in table:
			referencebycode[kind+code] = (kind, name)
			referencebyname[name] = (kind, code)
	if commands:
		for name, code, args in commands[::-1]: # if two commands have same name but different codes, only the first definition should be used (iterating over the commands list in reverse ensures this)
			# TO DO: make sure same collision avoidance is done in help terminology (i.e. need to centralise all this stuff in a single osaterminology module)
			# Avoid collisions between default commands and application-defined commands with same name but different code (e.g. 'get' and 'set' in InDesign CS2):
			if _defaultcommands.has_key(name) and code != _defaultcommands[name][1][0]:
				name += '_'
			referencebyname[name] = (kCommand, (code, dict(args)))
	return referencebycode, referencebyname


######################################################################
# PUBLIC
######################################################################

defaulttypesbycode= _typebycode # used by help system


def tablesfordata(terms):
	"""Build terminology tables from a dumped terminology module."""
	return _makeTypeTable(terms.classes, terms.enums, terms.properties) \
			+ _makeReferenceTable(terms.properties, terms.elements, terms.commands)


def tablesforapp(path=None, url=None):
	if not _terminologyCache.has_key(path or url):
		try:
			aetes = Application(path, url).event('ascrgdte', {'----':0}).send()
		except Exception, e: # (e.g.application not running)
			raise RuntimeError, "Can't get terminology for application (%s): %s" % (path or url, e)
		if not isinstance(aetes, list):
			aetes = [aetes]
		#print [aete.data for aete in aetes if aete.type == 'aete']
		classes, enums, properties, elements, commands = buildtablesforaetes([aete.data for aete in aetes if aete.type == 'aete'])
		_terminologyCache[path or url] = _makeTypeTable(classes, enums, properties) + _makeReferenceTable(properties, elements, commands)
	return _terminologyCache[path or url]


######################################################################
# TEST
######################################################################

if __name__ == '__main__':
	#for t in tablesforlocalapp('/Applications/TextEdit.app'):
	#	print t, '\n\n'
#	tablesforapp(url='eppc://mini.local/TextEdit')
#	_terminologyCache.clear()
	from time import time as t
	d=tablesforapp('/Applications/textedit.app')
	tt=t()
#	d=tablesforapp(url='eppc://mini.local/TextEdit')
	print t()-tt
	'''
	from aem import Codecs
	import InDesignCS2 as i
	c=Codecs()
	o=c.pack((i.classes, i.enums, i.properties, i.elements, i.commands))
	tt=t()
	c.unpack(o)
	d = tablesfordata(i)
	print t()-tt
	'''
	if 1:
		from pprint import pprint
		for n in d:
			pprint(n)
			print
			print