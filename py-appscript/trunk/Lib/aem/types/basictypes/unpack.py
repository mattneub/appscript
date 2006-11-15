"""unpack -- Unpack AEDescs into Python data types and classes.

(C) 2005 HAS
"""

import struct, datetime
from CarbonX import kAE
from codecs import BOM_UTF16_LE

import macfile

from typewrappers import AEType, AEEnum, AEProp, AEKey, AEEventName


######################################################################
# PRIVATE
######################################################################
# Constants

_typeFileURL = 'furl'
_typeUTF8Text = 'utf8'
_typeUTF16ExternalRepresentation = 'ut16'

# Mac OS epoch; used to convert AEDescs of typeLongDateTime to datetime objects
_macEpoch = datetime.datetime(1904, 1, 1)

#######

if struct.pack("h", 1) == '\x00\x01': # host is big-endian
	fourCharCode = lambda code: code
else: # host is small-endian
	fourCharCode = lambda code: code[::-1]

#######
# AEDesc Decoders

def _unpackUnicodeText(desc,codecs):
	# typeUnicodeText = native endian UTF16 with optional BOM
	# TO DO: typeUnicodeText is not recommended as of 10.4; not sure how backwards-compatible a switch to typeUTF16ExternalRepresentation would be
	return unicode(desc.data, 'utf16')

def _unpackUTF16ExternalRepresentation(desc, codecs): 
	# type UTF16ExternalRepresentation = big-endian UTF16 with optional byte-order-mark OR little-endian UTF16 with required byte-order-mark
	if desc.data.startswith(BOM_UTF16_LE):
		return unicode(desc.data, 'UTF-16LE')
	else:
		return unicode(desc.data, 'UTF-16BE')

def _unpackLongDateTime(desc, codecs):
	return _macEpoch + datetime.timedelta(seconds=struct.unpack('q', desc.data)[0])

def _unpackQDPoint(desc, codecs): 
	x, y = struct.unpack('hh', desc.data)
	return (y, x)

def _unpackQDRect(desc, codecs):
	x1, y1, x2, y2 = struct.unpack('hhhh', desc.data)
	return (y1, x1, y2, x2)

def _unpackAEList(desc,codecs):
	# Unpack list and its values.
	return [codecs.unpack(desc.AEGetNthDesc(i + 1, kAE.typeWildCard)[1]) for i in range(desc.AECountItems())]

def _unpackAERecord(desc, codecs):
	# Unpack record to dict, converting keys from 4-letter codes to AEType instances and unpacking values.
	dct = {}
	for i in range(desc.AECountItems()):
		key, value = desc.AEGetNthDesc(i + 1, kAE.typeWildCard)
		if key == 'usrf':
			lst = _unpackAEList(value,codecs)
			for i in range(0, len(lst), 2):
				dct[lst[i]] = lst[i+1]
		else:
			dct[AEType(key)] = codecs.unpack(value)
	return dct


######################################################################
# PUBLIC
######################################################################
# Used by Codecs.unpack(); clients may add additional conversions there

decoders = {
	kAE.typeNull: lambda desc,codecs: None,
	kAE.typeBoolean: lambda desc,codecs: desc.data != '\x00',
	kAE.typeFalse: lambda desc,codecs: False,
	kAE.typeTrue: lambda desc,codecs: True,
	kAE.typeSInt16: lambda desc,codecs: struct.unpack('h', desc.data)[0],
	kAE.typeSInt32: lambda desc,codecs: struct.unpack('l', desc.data)[0],
	kAE.typeUInt32: lambda desc,codecs: struct.unpack('L', desc.data)[0],
	kAE.typeSInt64: lambda desc,codecs: struct.unpack('q', desc.data)[0],
	kAE.typeIEEE32BitFloatingPoint: lambda desc,codecs: struct.unpack('f', desc.data)[0],
	kAE.typeIEEE64BitFloatingPoint: lambda desc,codecs: struct.unpack('d', desc.data)[0],
	kAE.type128BitFloatingPoint: lambda desc,codecs: struct.unpack('d', desc.AECoerceDesc(kAE.typeIEEE64BitFloatingPoint).data)[0],
	kAE.typeChar: lambda desc,codecs: desc.data,
	kAE.typeIntlText: lambda desc,codecs: _unpackUnicodeText(desc.AECoerceDesc(kAE.typeUnicodeText), codecs),
	_typeUTF8Text: lambda desc, codecs: unicode(desc.data, 'utf8'),
	_typeUTF16ExternalRepresentation: _unpackUTF16ExternalRepresentation,
	kAE.typeUnicodeText: _unpackUnicodeText,
	kAE.typeLongDateTime: _unpackLongDateTime,
	kAE.typeAEList: _unpackAEList,
	kAE.typeAERecord: _unpackAERecord,
	kAE.typeVersion: lambda desc,codecs: '%i.%i.%i' % ((ord(desc.data[0]),) + divmod(ord(desc.data[1]), 16)), # Cocoa apps use unicode strings for version numbers, so return as string for consistency; (note: typeVersion always big-endian)
	kAE.typeAlias: lambda desc,codecs: macfile.Alias.makewithaedesc(desc),
	kAE.typeFSS: lambda desc,codecs: macfile.File.makewithaedesc(desc),
	kAE.typeFSRef: lambda desc,codecs: macfile.File.makewithaedesc(desc),
	_typeFileURL: lambda desc,codecs: macfile.File.makewithaedesc(desc),
	kAE.typeQDPoint: _unpackQDPoint,
	kAE.typeQDRectangle: _unpackQDRect, 
	kAE.typeRGBColor: lambda desc,codecs: struct.unpack('HHH', desc.data),
	# ensure correct endianness in following
	kAE.typeType: lambda desc,codecs: AEType(fourCharCode(desc.data)),
	kAE.typeEnumeration: lambda desc,codecs: AEEnum(fourCharCode(desc.data)),
	kAE.typeProperty: lambda desc,codecs: AEProp(fourCharCode(desc.data)),
	kAE.typeKeyword: lambda desc,codecs: AEKey(fourCharCode(desc.data)),
	'evnt': lambda desc,codecs: AEEventName(desc.data), # event name
	
	kAE.typeStyledText: lambda desc,codecs: _unpackUnicodeText(desc.AECoerceDesc(kAE.typeUnicodeText), codecs),
	kAE.typeStyledUnicodeText: lambda desc,codecs: _unpackUnicodeText(desc.AECoerceDesc(kAE.typeUnicodeText), codecs),
}

