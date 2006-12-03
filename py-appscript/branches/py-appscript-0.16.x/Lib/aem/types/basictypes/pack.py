"""pack -- Pack Python data types and classes into AEDescs.

(C) 2005 HAS
"""

import struct, types, datetime, time
from Carbon import File
from CarbonX import kAE
from CarbonX.AE import AEDesc, AECreateDesc, AECreateList

import macfile

from typewrappers import AEType, AEEnum, AEProp, AEKey, AEEventName


######################################################################
# PRIVATE
######################################################################

_kNullDesc = AECreateDesc(kAE.typeNull, '')
_macEpoch = datetime.datetime(1904, 1, 1) # used in packing datetime objects as AEDesc typeLongDateTime
_macEpochT = time.mktime(_macEpoch.timetuple())
_shortMacEpoch = _macEpoch.date() # used in packing date objects as AEDesc typeLongDateTime

_trueDesc = AECreateDesc(kAE.typeTrue, '')
_falseDesc = AECreateDesc(kAE.typeFalse, '')

#######
# Packing functions

def _packLong(val, codecs):
	if (-2**31) <= val < (2**31): # pack as typeSInt32 if possible (non-lossy)
		return codecs.pack(int(val))
	elif (-2**63) <= val < (2**63): # else pack as typeSInt64 if possible (non-lossy)
		return AECreateDesc(kAE.typeSInt64, struct.pack('q', val))
	else: # else pack as typeFloat (lossy)
		return codecs.pack(float(val))

def _packList(val, codecs):
	lst = AECreateList('', False)
	for item in val:
		lst.AEPutDesc(0, codecs.pack(item))
	return lst


def _packDict(val, codecs):
	record = AECreateList('', True)
	usrf = None
	for key, value in val.items():
		if isinstance(key, (AEType, AEProp)):
			if key.code == 'pcls': # AS packs records that contain a 'class' property by coercing the packed record to that type at the end
				try:
					record = record.AECoerceDesc(value.code)
				except:
					record.AEPutParamDesc(key.code, codecs.pack(value))
			else:
				record.AEPutParamDesc(key.code, codecs.pack(value))
		else:
			if not usrf:
				usrf = AECreateList('', False)
			usrf.AEPutDesc(0, codecs.pack(key))
			usrf.AEPutDesc(0, codecs.pack(value))
	if usrf:
		record.AEPutParamDesc('usrf', usrf)
	return record


def _packDate(val, codecs):
	delta = val - _shortMacEpoch
	sec = delta.days * 3600 * 24 + delta.seconds
	return AECreateDesc(kAE.typeLongDateTime, struct.pack('q', sec))


def _packDatetime(val, codecs):
	delta = val - _macEpoch
	sec = delta.days * 3600 * 24 + delta.seconds
	return AECreateDesc(kAE.typeLongDateTime, struct.pack('q', sec))


def _packTime(val, codecs):
	return _packDatetime(datetime.datetime.combine(datetime.date.today(), val), codecs)


def _packStructTime(val, codecs):
	sec = int(time.mktime(val) - _macEpochT)
	return AECreateDesc(kAE.typeLongDateTime, struct.pack('q', sec))


######################################################################
# PUBLIC
######################################################################
# Packing function lookup table; used by Codecs.pack(); users may add additional conversions there

encoders = {
	AEDesc: lambda val, codecs: val,
	types.NoneType: lambda val, codecs: _kNullDesc,
	types.BooleanType: lambda val, codecs: val and _trueDesc or _falseDesc,
	types.IntType: lambda val, codecs: AECreateDesc(kAE.typeSInt32, struct.pack('l', val)),
	types.LongType: _packLong,
	types.FloatType: lambda val, codecs: AECreateDesc(kAE.typeFloat, struct.pack('d', val)),
	types.StringType: lambda val, codecs: AECreateDesc(kAE.typeChar, val),
	types.UnicodeType: lambda val, codecs: AECreateDesc(kAE.typeUnicodeText, val.encode('utf16')[2:]), # note: optional BOM is omitted as this causes problems with stupid apps like iTunes 7 that don't handle BOMs correctly; note: while typeUnicodeText is not recommended as of OS 10.4, it's still being used rather than typeUTF8Text or typeUTF16ExternalRepresentation to provide compatibility with not-so-well-designed applications that may have problems with these newer types
	types.ListType: _packList,
	types.TupleType: _packList,
	types.DictionaryType: _packDict,
	datetime.date: _packDate,
	datetime.datetime: _packDatetime,
	datetime.time: _packTime,
	time.struct_time: _packStructTime,
	File.AliasType: lambda val, codecs: AECreateDesc(kAE.typeAlias, val.data),
	File.FSSpecType: lambda val, codecs: AECreateDesc(kAE.typeFSS, val.data),
	File.FSRefType: lambda val, codecs: AECreateDesc(kAE.typeFSRef, val.data),
	macfile.Alias: lambda val, codecs: val.aedesc,
	macfile.File: lambda val, codecs: val.aedesc,
	# ensure correct endianness in following
	AEType: lambda val, codecs: AECreateDesc(kAE.typeType, struct.pack("L", *struct.unpack(">L", val.code))),
	AEEnum: lambda val, codecs: AECreateDesc(kAE.typeEnumeration, struct.pack("L", *struct.unpack(">L", val.code))),
	AEProp: lambda val, codecs: AECreateDesc(kAE.typeProperty, struct.pack("L", *struct.unpack(">L", val.code))),
	AEKey: lambda val, codecs: AECreateDesc(kAE.typeKeyword, struct.pack("L", *struct.unpack(">L", val.code))),
	AEEventName: lambda val, codecs: AECreateDesc('evnt', struct.pack("LL", *struct.unpack(">LL", val.code))),
}

