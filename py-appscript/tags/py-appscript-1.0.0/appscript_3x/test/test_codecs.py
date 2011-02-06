#!/usr/bin/env python3

import unittest, struct, datetime
import aem, mactypes

isSmallEndian = struct.pack('H', 1) == b"\001\000"

def num(s):
	if isSmallEndian:
		return s[::-1]
	else:
		return s

def ut16(s):
	if isSmallEndian:
		return str(s, 'utf-16be').encode('utf-16le')
	else:
		return s




class TC_Codecs(unittest.TestCase):
	
	def setUp(self):
		self.c = aem.Codecs()
	
	def test_none(self):
		d = self.c.pack(None)
		self.assertEqual(aem.kae.typeNull, d.type)
		self.assertEqual(b'', d.data)
		self.assertEqual(None, self.c.unpack(d))
	
	def test_bool(self):
		self.assertEqual(True, self.c.unpack(aem.ae.newdesc(aem.kae.typeBoolean, b"\xfe")))
		self.assertEqual(False, self.c.unpack(aem.ae.newdesc(aem.kae.typeBoolean, b"\x00")))
		self.assertEqual(True, self.c.unpack(aem.ae.newdesc(aem.kae.typeTrue, b'')))
		self.assertEqual(False, self.c.unpack(aem.ae.newdesc(aem.kae.typeFalse, b'')))
	
	def test_num(self):
		for val, data, type, expected in [ # (mostly testing at threshold points where Codecs switches types when packing integers)
				[0, b"\x00\x00\x00\x00", aem.kae.typeInteger, None],
				[2, b"\x00\x00\x00\x02", aem.kae.typeInteger, None],
				[-9, b"\xff\xff\xff\xf7", aem.kae.typeInteger, None],
				[2**31-1, b"\x7f\xff\xff\xff", aem.kae.typeInteger, None],
				[-2**31, b"\x80\x00\x00\x00", aem.kae.typeInteger, None],
				[2**31, b"\x00\x00\x00\x00\x80\x00\x00\x00", aem.kae.typeSInt64, None],
				[2**32-1, b"\x00\x00\x00\x00\xff\xff\xff\xff", aem.kae.typeSInt64, None],
				[2**32, b"\x00\x00\x00\x01\x00\x00\x00\x00", aem.kae.typeSInt64, None], 
				[-2**32, b"\xff\xff\xff\xff\x00\x00\x00\x00", aem.kae.typeSInt64, None],
				[2**63-1, b"\x7f\xff\xff\xff\xff\xff\xff\xff", aem.kae.typeSInt64, None], 
				[-2**63, b"\x80\x00\x00\x00\x00\x00\x00\x00", aem.kae.typeSInt64, None],
				[-2**63+1, b"\x80\x00\x00\x00\x00\x00\x00\x01", aem.kae.typeSInt64, None],
				[2**63, b"C\xe0\x00\x00\x00\x00\x00\x00", aem.kae.typeFloat, None],
				[-2**63-1, b"\xc3\xe0\x00\x00\x00\x00\x00\x00", aem.kae.typeFloat, float(-2**63-1)],
				[0.1, b"?\xb9\x99\x99\x99\x99\x99\x9a", aem.kae.typeFloat, None],
				[-0.9e-9, b"\xbe\x0e\xec{\xd5\x12\xb5r", aem.kae.typeFloat, None],
				[2**300, b"R\xb0\x00\x00\x00\x00\x00\x00", aem.kae.typeFloat, None],
				]:
			if type == aem.kae.typeInteger:
				val = int(val)
			data = num(data)
			d = self.c.pack(val)
			self.assertEqual(type, d.type)
			self.assertEqual(data, d.data)
			if expected is None:
				expected = val
			self.assertEqual(expected, self.c.unpack(d))
	
	def test_unicode(self):
		for val, data in [
			# note: UTF16 BOM must be omitted when packing UTF16 data into typeUnicodeText AEDescs, as a BOM will upset stupid apps like iTunes 7 that don't recognise it as a BOM and treat it as character data instead
				['', b''],
				['hello', b"\000h\000e\000l\000l\000o"],
				[str(b"\xc6\x92\xe2\x88\x82\xc2\xae\xd4\xb7\xd5\x96\xd4\xb9\xe0\xa8\x89\xe3\x82\xa2\xe3\x84\xbb", 'utf8'),
					b"\x01\x92\"\x02\x00\xae\x057\x05V\x059\n\t0\xa21;"],
			]:
			data = ut16(data)
			d = self.c.pack(val)
			self.assertEqual(aem.kae.typeUnicodeText, d.type)
			self.assertEqual(data, d.data)
			self.assertEqual(val, self.c.unpack(d))
	
	def test_date(self):
		# note: not testing on ST-DST boundaries; this is known to have out-by-an-hour problems due to LongDateTime type being crap
		for t, data in [
				[datetime.datetime(2005, 12, 11, 15, 40, 43), b"\x00\x00\x00\x00\xbf\xc1\xf8\xfb"],
				[datetime.datetime(2005, 5, 1, 6, 51, 7), b"\x00\x00\x00\x00\xbe\x9a\x2c\xdb"],
				]:
			data = num(data)
			d = self.c.pack(t)
			self.assertEqual(aem.kae.typeLongDateTime, d.type)
			self.assertEqual(data, d.data)
			self.assertEqual(t, self.c.unpack(aem.ae.newdesc(aem.kae.typeLongDateTime, data)))
	
	def test_file(self):
		path = '/Applications/TextEdit.app'
		d = self.c.pack(mactypes.Alias(path))
		self.assertEqual(path, self.c.unpack(d).path)
		
		path = '/Applications/TextEdit.app'
		d = self.c.pack(mactypes.File(path))
		self.assertEqual(path, self.c.unpack(d).path)
	
	def test_typewrappers(self):
		for val in [
				aem.AEType(b"docu"),
				aem.AEEnum(b'yes '),
				aem.AEProp(b'pnam'),
				aem.AEKey(b'ABCD'),
				]:
			d = self.c.pack(val)
			val2 = self.c.unpack(d)
			self.assertEqual(val, val2)
			self.assertEqual(val2, val)
		self.assertRaises(TypeError, aem.AEType, 3)
		self.assertRaises(ValueError, aem.AEType, b"docum")
	
	def test_dict(self):
		val = {'foo': 1, aem.AEType(b'foob'): 2, aem.AEProp(b'barr'): 3}
		expectedVal = {'foo': 1, aem.AEType(b'foob'): 2, aem.AEType(b'barr'): 3} # note that four-char-code keys are always unpacked as AEType
		d = self.c.pack(val)
		self.assertEqual(expectedVal, self.c.unpack(d))
	
	def test_units(self):
		val = mactypes.Units(3.3, 'inches')
		self.assertEqual('inches', val.type)
		self.assertEqual(3.3, val.value)
		d = self.c.pack(val)
		self.assertEqual(b'inch', d.type)
		self.assertEqual(3.3, self.c.unpack(d.coerce(aem.kae.typeFloat)))
		val2 = self.c.unpack(d)
		self.assertEqual(val, val2)
		self.assertEqual('inches', val2.type)
		self.assertEqual(3.3, val2.value)


if __name__ == '__main__':
	unittest.main()
