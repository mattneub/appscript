#!/usr/local/bin/python

import unittest, struct, datetime
import aem, mactypes
from CarbonX import AE, kAE

isSmallEndian = struct.pack('H', 1) == "\001\000"

def num(s):
	if isSmallEndian:
		return s[::-1]
	else:
		return s

def ut16(s):
	if isSmallEndian:
		return unicode(s, 'utf-16be').encode('utf-16le')
	else:
		return s




class TC_Codecs(unittest.TestCase):
	
	def setUp(self):
		self.c = aem.Codecs()
	
	def test_none(self):
		d = self.c.pack(None)
		self.assertEqual(kAE.typeNull, d.type)
		self.assertEqual('', d.data)
		self.assertEqual(None, self.c.unpack(d))
	
	def test_bool(self):
		for val, data in [
				[True, "\001"],
				[False, "\000"]
				]:
			d = self.c.pack(val)
			self.assertEqual(kAE.typeBoolean, d.type)
			self.assertEqual(1, len(d.data))
			self.assertEqual(data, d.data)
			self.assertEqual(val, self.c.unpack(d))
		self.assertEqual(True, self.c.unpack(AE.AECreateDesc(kAE.typeBoolean, "\xfe")))
		self.assertEqual(True, self.c.unpack(AE.AECreateDesc(kAE.typeTrue, '')))
		self.assertEqual(False, self.c.unpack(AE.AECreateDesc(kAE.typeFalse, '')))
	
	def test_num(self):
		for val, data, type, expected in [ # (mostly testing at threshold points where Codecs switches types when packing integers)
				[0, "\x00\x00\x00\x00", kAE.typeInteger, None],
				[2, "\x00\x00\x00\x02", kAE.typeInteger, None],
				[-9, "\xff\xff\xff\xf7", kAE.typeInteger, None],
				[2**31-1, "\x7f\xff\xff\xff", kAE.typeInteger, None],
				[-2**31, "\x80\x00\x00\x00", kAE.typeInteger, None],
				[2**31, "\x00\x00\x00\x00\x80\x00\x00\x00", kAE.typeSInt64, None],
				[2**32-1, "\x00\x00\x00\x00\xff\xff\xff\xff", kAE.typeSInt64, None],
				[2**32, "\x00\x00\x00\x01\x00\x00\x00\x00", kAE.typeSInt64, None], 
				[-2**32, "\xff\xff\xff\xff\x00\x00\x00\x00", kAE.typeSInt64, None],
				[2**63-1, "\x7f\xff\xff\xff\xff\xff\xff\xff", kAE.typeSInt64, None], 
				[-2**63, "\x80\x00\x00\x00\x00\x00\x00\x00", kAE.typeSInt64, None],
				[-2**63+1, "\x80\x00\x00\x00\x00\x00\x00\x01", kAE.typeSInt64, None],
				[2**63, "C\xe0\x00\x00\x00\x00\x00\x00", kAE.typeFloat, None],
				[-2**63-1, "\xc3\xe0\x00\x00\x00\x00\x00\x00", kAE.typeFloat, float(-2**63-1)],
				[0.1, "?\xb9\x99\x99\x99\x99\x99\x9a", kAE.typeFloat, None],
				[-0.9e-9, "\xbe\x0e\xec{\xd5\x12\xb5r", kAE.typeFloat, None],
				[2**300, "R\xb0\x00\x00\x00\x00\x00\x00", kAE.typeFloat, None],
				]:
			if type == kAE.typeInteger:
				val = int(val)
			data = num(data)
			d = self.c.pack(val)
			self.assertEqual(type, d.type)
			self.assertEqual(data, d.data)
			if expected is None:
				expected = val
			self.assertEqual(expected, self.c.unpack(d))
	
	# TO DO: test_str
	
	def test_unicode(self):
		for val, data in [
			# note: UTF16 BOM must be omitted when packing UTF16 data into typeUnicodeText AEDescs, as a BOM will upset stupid apps like iTunes 7 that don't recognise it as a BOM and treat it as character data instead
				[u'', ''],
				[u'hello', "\000h\000e\000l\000l\000o"],
				[unicode("\xc6\x92\xe2\x88\x82\xc2\xae\xd4\xb7\xd5\x96\xd4\xb9\xe0\xa8\x89\xe3\x82\xa2\xe3\x84\xbb", 'utf8'),
					"\x01\x92\"\x02\x00\xae\x057\x05V\x059\n\t0\xa21;"],
			]:
			data = ut16(data)
			d = self.c.pack(val)
			self.assertEqual(kAE.typeUnicodeText, d.type)
			self.assertEqual(data, d.data)
			self.assertEqual(val, self.c.unpack(d))
	
	def test_date(self):
		# note: not testing on ST-DST boundaries; this is known to have out-by-an-hour problems due to LongDateTime type being crap
		for t, data in [
				[datetime.datetime(2005, 12, 11, 15, 40, 43), "\x00\x00\x00\x00\xbf\xc1\xf8\xfb"],
				[datetime.datetime(2005, 5, 1, 6, 51, 7), "\x00\x00\x00\x00\xbe\x9a\x2c\xdb"],
				]:
			data = num(data)
			d = self.c.pack(t)
			self.assertEqual(kAE.typeLongDateTime, d.type)
			self.assertEqual(data, d.data)
			self.assertEqual(t, self.c.unpack(AE.AECreateDesc(kAE.typeLongDateTime, data)))
	
	def test_file(self):
		path = '/Applications/TextEdit.app'
		d = self.c.pack(mactypes.Alias(path))
		self.assertEqual(path, self.c.unpack(d).path)
		
		path = '/Applications/TextEdit.app'
		d = self.c.pack(mactypes.File(path))
		self.assertEqual(path, self.c.unpack(d).path)
	
	def test_typewrappers(self):
		for val in [
				aem.AEType("docu"),
				aem.AEEnum('yes '),
				aem.AEProp('pnam'),
				aem.AEKey('ABCD'),
				aem.AEEventName('coregetd'),
				]:
			d = self.c.pack(val)
			val2 = self.c.unpack(d)
			self.assertEqual(val, val2)
			self.assertEqual(val2, val)
		self.assertRaises(TypeError, aem.AEType, 3)
		self.assertRaises(ValueError, aem.AEType, "docum")
	
	def test_list(self):
		pass # TO DO
	
	def test_dict(self):
		val = {'foo': 1, aem.AEType('foob'): 2, aem.AEProp('barr'): 3} # TO DO: also need to test appscript codecs (in separate test) to check String, AEType and Keyword keys all pack and unpack correctly
		expectedVal = {'foo': 1, aem.AEType('foob'): 2, aem.AEType('barr'): 3} # note that four-char-code keys are always unpacked as AEType
		d = self.c.pack(val)
		self.assertEqual(expectedVal, self.c.unpack(d))


if __name__ == '__main__':
	unittest.main()
