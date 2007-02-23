#!/usr/bin/env python

"""terminology -- Obtains an application's aete resource(s) using a 'ascrgdte' event and converts them into lookup tables for use in AppData objects.

(C) 2004 HAS
"""

from aem import AEType, AEEnum, CommandError
from osaterminology import appscripttypedefs
from CarbonX.AE import AEDesc

from terminologyparser import buildtablesforaetes
from keywordwrapper import Keyword

__all__ = ['tablesforapp', 'tablesformodule', 'tablesforaetedata', 'kProperty', 'kElement', 'kCommand', 'defaulttables', 'aetedataforapp']


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
for defs in [appscripttypedefs.types, appscripttypedefs.properties]:
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
	# Each argument is of format [[name, code], ...]
	typebycode = _typebycode.copy()
	typebyname = _typebyname.copy()
	# TO DO: testing indicates that where name+code clashes occur, classes have highest priority, followed by properties, with enums last; currently this code gives higher priority to enums:
	for klass, table in [(AEType, properties), (AEEnum, enums), (AEType, classes)]: # note: packing properties as AEProp causes problems when the same name is used for both a class and a property, and the property's definition masks the class's one (e.g. Finder's 'file'); if an AEProp is passed where an AEType is expected, it can cause an error as it's not what the receiving app expects. (Whereas they may be more tolerant of an AEType being passed where an AEProp is expected.) Also, note that AppleScript always seems to pack property names as typeType, so we should be ok following its lead here.
		for i, (name, code) in enumerate(table):
			# TO DO: decide where best to apply AE keyword escaping, language keyword escaping
			# TO DO: make sure same collision avoidance is done in help terminology (i.e. need to centralise all this stuff in a single osaterminology module)
			# If an application-defined name overlaps an existing type name but has a different code, append '_' to avoid collision:
			if _typebyname.has_key(name) and _typebyname[name].code != code:
				name += '_'
			typebycode[code] = Keyword(name) # to handle synonyms, if same code appears more than once then use name from last definition in list
			name, code = table[-i - 1]
			if _typebyname.has_key(name) and _typebyname[name].code != code:
				name += '_'
			typebyname[name] = klass(code) # to handle synonyms, if same name appears more than once then use code from first definition in list
	return typebycode, typebyname


def _makeReferenceTable(properties, elements, commands):
	# Used for constructing references and commands
	# First two parameters are of format [[name, code], ...]
	# Last parameter is of format [name, code, direct arg type, [[arg code, arg name], ...]]
	referencebycode = _referencebycode.copy()
	referencebyname = _referencebyname.copy()
	for kind, table in [(kElement, elements), (kProperty, properties)]:
		# note: if property and element names are same (e.g. 'file' in BBEdit), will pack as property specifier unless it's a special case (i.e. see :text below). Note that there is currently no way to override this, i.e. to force appscript to pack it as an all-elements specifier instead (in AS, this would be done by prepending the 'every' keyword), so clients would need to use aem for that (but could add an 'all' method to Reference class if there was demand for a built-in workaround)
		for i, (name, code) in enumerate(table):
			referencebycode[kind+code] = (kind, name) # to handle synonyms, if same code appears more than once then use name from last definition in list
			name, code = table[-i - 1]
			referencebyname[name] = (kind, code) # to handle synonyms, if same name appears more than once then use code from first definition in list
	if referencebyname.has_key('text'): # special case: AppleScript always packs 'text of...' as all-elements specifier
		referencebyname['text'] = (kElement, referencebyname['text'][1])
	for name, code, args in commands[::-1]: # to handle synonyms, if two commands have same name but different codes, only the first definition should be used (iterating over the commands list in reverse ensures this)
		# TO DO: make sure same collision avoidance is done in help terminology (i.e. need to centralise all this stuff in a single osaterminology module)
		# Avoid collisions between default commands and application-defined commands with same name but different code (e.g. 'get' and 'set' in InDesign CS2):
		if _defaultcommands.has_key(name) and code != _defaultcommands[name][1][0]:
			name += '_'
		referencebyname[name] = (kCommand, (code, dict(args)))
	return referencebycode, referencebyname


######################################################################
# PUBLIC
######################################################################


defaulttables = _makeTypeTable([], [], []) + _makeReferenceTable([], [], []) # (typebycode, typebyname, referencebycode, referencebyname)


def aetedataforapp(app):
	"""Get aetes from local/remote app via an ascrgdte event; result is a list of byte strings."""
	try:
		aetes = app.event('ascrgdte', {'----':0}).send(60 * 30)
	except Exception, e: # (e.g.application not running)
		if isinstance(e, CommandError) and e.number == -192:
			aetes = []
		else:
			raise RuntimeError, "Can't get terminology for application (%r): %s" % (app, e)
	if not isinstance(aetes, list):
		aetes = [aetes]
	return [aete.data for aete in aetes if isinstance(aete, AEDesc) and aete.type == 'aete']


def tablesforaetedata(aetes, style='py-appscript'):
	"""Build terminology tables from a list of unpacked aete byte strings.
		Result : tuple of dict -- (typebycode, typebyname, referencebycode, referencebyname)
	"""
	classes, enums, properties, elements, commands = buildtablesforaetes(aetes, style)
	return _makeTypeTable(classes, enums, properties) + _makeReferenceTable(properties, elements, commands)


def tablesformodule(terms):
	"""Build terminology tables from a dumped terminology module.
		Result : tuple of dict -- (typebycode, typebyname, referencebycode, referencebyname)
	"""
	return _makeTypeTable(terms.classes, terms.enums, terms.properties) \
			+ _makeReferenceTable(terms.properties, terms.elements, terms.commands)


def tablesforapp(app, style='py-appscript'):
	"""Build terminology tables for an application.
		app : aem.Application
		Result : tuple of dict -- (typebycode, typebyname, referencebycode, referencebyname)
	"""
	if not _terminologyCache.has_key(app.AEM_identity):
		_terminologyCache[app.AEM_identity] = tablesforaetedata(aetedataforapp(app), style)
	return _terminologyCache[app.AEM_identity]


