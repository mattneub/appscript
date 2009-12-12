#!/usr/bin/env python3

import unittest
import aem

DefaultCodecs = aem.Codecs()


class TC_AEMReferences(unittest.TestCase):

	def test_referenceForms(self):
		for val, res, unpackedVersion in [
				[aem.app.property(b"ctxt"), "app.property(b'ctxt')", None],
				
				[aem.app.elements(b"docu"), "app.elements(b'docu')", None],
				
				[aem.app.elements(b"docu").byindex(1), 
						"app.elements(b'docu').byindex(1)", None],
				[aem.app.elements(b"docu").byname("foo"), 
						"app.elements(b'docu').byname('foo')", None],
				[aem.app.elements(b"docu").byid(300), 
						"app.elements(b'docu').byid(300)", None],
				
				[aem.app.elements(b"docu").next(b"docu"), 
						"app.elements(b'docu').next(b'docu')", None],
				[aem.app.elements(b"docu").previous(b"docu"), 
						"app.elements(b'docu').previous(b'docu')", None],
				
				[aem.app.elements(b"docu").first, "app.elements(b'docu').first", None],
				[aem.app.elements(b"docu").middle, "app.elements(b'docu').middle", None],
				[aem.app.elements(b"docu").last, "app.elements(b'docu').last", None],
				[aem.app.elements(b"docu").any, "app.elements(b'docu').any", None],
				
				[aem.con.elements(b'docu').byindex(3), "con.elements(b'docu').byindex(3)", None],
				
				[aem.app.elements(b"docu").byrange(
						aem.con.elements(b"docu").byindex(3),
						aem.con.elements(b"docu").byname("foo")), 
						"app.elements(b'docu').byrange(" +
						"con.elements(b'docu').byindex(3), " +
						"con.elements(b'docu').byname('foo'))", None],
								
				[aem.its.property(b"name").eq("foo").AND(aem.its.elements(b"cwor").eq([])), 
						"its.property(b'name').eq('foo').AND(its.elements(b'cwor').eq([]))", None],
				
				[aem.its.elements(b"cwor").ne([]), 
						"its.elements(b'cwor').ne([])", 
						aem.its.elements(b'cwor').eq([]).NOT], # i.e. there isn"t a kAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
						
				[aem.its.elements(b"cwor").eq(None), "its.elements(b'cwor').eq(None)", None],
				[aem.its.elements(b"cwor").property(b"leng").gt(0), 
						"its.elements(b'cwor').property(b'leng').gt(0)", None],
				[aem.its.elements(b"cwor").le(""), "its.elements(b'cwor').le('')", None],
				[aem.its.elements(b"cwor").beginswith("foo").NOT, 
						"its.elements(b'cwor').beginswith('foo').NOT", None],
				
				
				[aem.its.elements(b"cwor").contains("foo"), "its.elements(b'cwor').contains('foo')", None],
				[aem.its.elements(b"cwor").isin("foo"), "its.elements(b'cwor').isin('foo')", None],
				
				[aem.app.elements(b"docu").byfilter(aem.its.property(b"size").ge(42)), 
						"app.elements(b'docu').byfilter(its.property(b'size').ge(42))", None],
						
				[aem.app.elements(b"docu").byindex(1).property(b"ctxt") \
						.elements(b"cpar").elements(b"cha ").byrange(
								aem.con.elements(b"cha ").byindex(3), 
								aem.con.elements(b"cha ").byindex(55)
						).next(b"cha ").after,
						"app.elements(b'docu').byindex(1).property(b'ctxt').elements(b'cpar').elements(b'cha ')" +
						".byrange(con.elements(b'cha ').byindex(3), con.elements(b'cha ').byindex(55))" +
						".next(b'cha ').after", None],
				
				[aem.its.property(b"pnam").ne("foo").AND(aem.its.elements(b"cfol").eq([])).NOT,
						"its.property(b'pnam').ne('foo').AND(its.elements(b'cfol').eq([])).NOT",
						aem.its.property(b"pnam").eq("foo").NOT.AND(aem.its.elements(b"cfol").eq([])).NOT],
				
				[aem.app.elements(b"docu").beginning, "app.elements(b'docu').beginning", None],
				[aem.app.elements(b"docu").end, "app.elements(b'docu').end", None],
				[aem.app.elements(b"docu").byindex(3).before, "app.elements(b'docu').byindex(3).before", None],
				[aem.app.elements(b"docu").byname("foo").after, "app.elements(b'docu').byname('foo').after", None],
				
				]:
			self.assertEqual(res, str(val))
			d = DefaultCodecs.pack(val)
			val = unpackedVersion and unpackedVersion or val
			#print val, d
			val2 = DefaultCodecs.unpack(d)
			self.assertEqual(val, val2)
			val2 = DefaultCodecs.unpack(d)
			self.assertEqual(val2, val)
		self.assertNotEqual(aem.app.property(b'ctxt').property(b'ctxt'), aem.con.property(b'ctxt').property(b'ctxt'))
		self.assertNotEqual(aem.app.property(b'foob').property(b'ctxt'), aem.app.property(b'ctxt').property(b'ctxt'))
		self.assertNotEqual(aem.app.elements(b'ctxt').property(b'ctxt'), aem.app.property(b'ctxt').property(b'ctxt'))
		self.assertNotEqual(aem.app.elements(b'ctxt').property(b'ctxt'), 333)
		self.assertNotEqual(333, aem.app.property(b'ctxt').property(b'ctxt'))
		# by-filter references do basic type checking to ensure a reference is given
		self.assertRaises(TypeError, aem.app.elements(b'docu').byfilter, 1)




if __name__ == '__main__':
	unittest.main()
