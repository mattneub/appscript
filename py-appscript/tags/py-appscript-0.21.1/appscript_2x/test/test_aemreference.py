#!/usr/bin/env python

import unittest
import aem

DefaultCodecs = aem.Codecs()


class TC_AEMReferences(unittest.TestCase):

	def test_referenceForms(self):
		for val, res, unpackedVersion in [
				[aem.app.property("ctxt"), "app.property('ctxt')", None],
				
				[aem.app.elements("docu"), "app.elements('docu')", None],
				
				[aem.app.elements("docu").byindex(1), 
						"app.elements('docu').byindex(1)", None],
				[aem.app.elements("docu").byname("foo"), 
						"app.elements('docu').byname('foo')", None],
				[aem.app.elements("docu").byid(300), 
						"app.elements('docu').byid(300)", None],
				
				[aem.app.elements("docu").next("docu"), 
						"app.elements('docu').next('docu')", None],
				[aem.app.elements("docu").previous("docu"), 
						"app.elements('docu').previous('docu')", None],
				
				[aem.app.elements("docu").first, "app.elements('docu').first", None],
				[aem.app.elements("docu").middle, "app.elements('docu').middle", None],
				[aem.app.elements("docu").last, "app.elements('docu').last", None],
				[aem.app.elements("docu").any, "app.elements('docu').any", None],
				
				[aem.con.elements('docu').byindex(3), "con.elements('docu').byindex(3)", None],
				
				[aem.app.elements("docu").byrange(
						aem.con.elements("docu").byindex(3),
						aem.con.elements("docu").byname("foo")), 
						"app.elements('docu').byrange(" +
						"con.elements('docu').byindex(3), " +
						"con.elements('docu').byname('foo'))", None],
								
				[aem.its.property("name").eq("foo").AND(aem.its.elements("cwor").eq([])), 
						"its.property('name').eq('foo').AND(its.elements('cwor').eq([]))", None],
				
				[aem.its.elements("cwor").ne([]), 
						"its.elements('cwor').ne([])", 
						aem.its.elements('cwor').eq([]).NOT], # i.e. there isn"t a kAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
						
				[aem.its.elements("cwor").eq(None), "its.elements('cwor').eq(None)", None],
				[aem.its.elements("cwor").property("leng").gt(0), 
						"its.elements('cwor').property('leng').gt(0)", None],
				[aem.its.elements("cwor").le(""), "its.elements('cwor').le('')", None],
				[aem.its.elements("cwor").beginswith("foo").NOT, 
						"its.elements('cwor').beginswith('foo').NOT", None],
				
				
				[aem.its.elements("cwor").contains("foo"), "its.elements('cwor').contains('foo')", None],
				[aem.its.elements("cwor").isin("foo"), "its.elements('cwor').isin('foo')", None],
				
				[aem.app.elements("docu").byfilter(aem.its.property("size").ge(42)), 
						"app.elements('docu').byfilter(its.property('size').ge(42))", None],
						
				[aem.app.elements("docu").byindex(1).property("ctxt") \
						.elements("cpar").elements("cha ").byrange(
								aem.con.elements("cha ").byindex(3), 
								aem.con.elements("cha ").byindex(55)
						).next("cha ").after,
						"app.elements('docu').byindex(1).property('ctxt').elements('cpar').elements('cha ')" +
						".byrange(con.elements('cha ').byindex(3), con.elements('cha ').byindex(55))" +
						".next('cha ').after", None],
				
				[aem.its.property("pnam").ne("foo").AND(aem.its.elements("cfol").eq([])).NOT,
						"its.property('pnam').ne('foo').AND(its.elements('cfol').eq([])).NOT",
						aem.its.property("pnam").eq("foo").NOT.AND(aem.its.elements("cfol").eq([])).NOT],
				
				[aem.app.elements("docu").beginning, "app.elements('docu').beginning", None],
				[aem.app.elements("docu").end, "app.elements('docu').end", None],
				[aem.app.elements("docu").byindex(3).before, "app.elements('docu').byindex(3).before", None],
				[aem.app.elements("docu").byname("foo").after, "app.elements('docu').byname('foo').after", None],
				
				]:
			self.assertEqual(res, str(val))
			d = DefaultCodecs.pack(val)
			val = unpackedVersion and unpackedVersion or val
			#print val, d
			val2 = DefaultCodecs.unpack(d)
			self.assertEqual(val, val2)
			val2 = DefaultCodecs.unpack(d)
			self.assertEqual(val2, val)
		self.assertNotEqual(aem.app.property('ctxt').property('ctxt'), aem.con.property('ctxt').property('ctxt'))
		self.assertNotEqual(aem.app.property('foob').property('ctxt'), aem.app.property('ctxt').property('ctxt'))
		self.assertNotEqual(aem.app.elements('ctxt').property('ctxt'), aem.app.property('ctxt').property('ctxt'))
		self.assertNotEqual(aem.app.elements('ctxt').property('ctxt'), 333)
		self.assertNotEqual(333, aem.app.property('ctxt').property('ctxt'))
		# by-filter references do basic type checking to ensure a reference is given
		self.assertRaises(TypeError, aem.app.elements('docu').byfilter, 1)




if __name__ == '__main__':
	unittest.main()
