#!/usr/bin/env pythonw

"""appscripttypedefs -- translation tables between appscript-style typenames and corresponding AE codes

(C) 2005 HAS
"""

from CarbonX import kAE

######################################################################
# PRIVATE
######################################################################


# note that names are still capitalised; this should reduce chance of initial collisions with application-defined keywords (at least in a case-sensitive language like Python), which are generally lowercase, given that they're all being stored in a single namespace. To be 100% collision-proof, terminology parsers should also check to make sure when adding application keywords, and munge any problem application-defined keywords to ensure no problems occur.

alltypes = [] # everything
for name in dir(kAE):
	if name.startswith('type'):
		code = getattr(kAE, name)
		displayname = name[4:]
		if displayname[0] in '1234567890':
			displayname = 'k' + displayname
		alltypes.append((displayname, code))


commontypes = [
		# common types for which we want specific names; use to remap typesbycode, typesbyname
		('Anything', kAE.typeWildCard),
		('Null', kAE.typeNull),
		('Reference', kAE.typeObjectSpecifier),
		('InsertionRef', kAE.typeInsertionLoc),
		('Boolean', kAE.typeBoolean),
		('Integer', kAE.typeInteger),
		('ShortInteger', kAE.typeSInt16),
		('UnsignedInteger', kAE.typeUInt32),
		('DoubleInteger', kAE.typeSInt64),
		('ShortFloat', kAE.typeShortFloat),
		('Float', kAE.typeFloat),
		('String', kAE.typeText),
		('Unicode', kAE.typeUnicodeText),
		('List', kAE.typeAEList),
		('Record', kAE.typeAERecord),
		('Type', kAE.typeType),
		('QDPoint', kAE.typeQDPoint),
		('QDRectangle', kAE.typeQDRectangle),
		('FSSpec', kAE.typeFSS),
		('FSRef', kAE.typeFSRef),
		('Alias', kAE.typeAlias),
		('DateTime', kAE.typeLongDateTime),
		# concrete types not defined in CarbonX.kAE:
		('MissingValue', 'msng'),
		('FileURL', 'furl'),
		('JPEG', 'JPEG'),
		('GIF', 'GIFf'),
]


pseudotypes = [ # non-concrete types that are only used for documentation purposes; use to remap typesbycode
		('File', 'file'), # typically FileURL, but could be other file types as well
		('Number', 'nmbr'), # any numerical type: Integer, Float, Long
		# ('Text', 'ctxt'), # Word X, Excel X uses this instead of 'TEXT' or 'utxt' (TO CHECK: is this Excel's stupidity, or is it acceptable?)
]


remappedtypes = [ # remapped for documentation purposes; use to remap typesbycode
		('Unicode', kAE.typeIntlText), # remapped in aem
]


properties = [ # Finder forgets to define this property in its dictionary
		('class_', 'pcls'),
]


enumerations = [
		(kAE.enumSaveOptions, [
				('yes', kAE.kAEYes), 
				('no', kAE.kAENo), 
				('ask', kAE.kAEAsk),
		]),
		# constants used in commands' 'ignore' argument (note: most apps currently ignore these):
		('cons', [
			('case', 'case'),
			('diacriticals', 'diac'),
			('expansion', 'expa'),
			('punctuation', 'punc'),
			('hyphens', 'hyph'),
			('whitespace', 'whit'),
		#	('numeric_strings', 'nume'),
		]),
]

