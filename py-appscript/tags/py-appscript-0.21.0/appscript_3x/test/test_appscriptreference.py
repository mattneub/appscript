#!/usr/bin/env python3

import unittest
import appscript as AS


class TC_AppscriptReferences(unittest.TestCase):

	def setUp(self):
		self.te = AS.app('TextEdit')
		self.s = repr(self.te)

	def test_referenceForms(self):
		for val, res, unpackedVersion in [
				[self.te.text, self.s+'.text', None],
				
				[self.te.documents, self.s+'.documents', None],
				
				[self.te.documents[1], 
						self.s+'.documents[1]', None],
				[self.te.documents['foo'], 
						self.s+".documents['foo']", None],
				[self.te.documents.ID(300), 
						self.s+'.documents.ID(300)', None],
				
				[self.te.documents.next(AS.k.document), 
						self.s+'.documents.next(k.document)', None],
				[self.te.documents.previous(AS.k.document), 
						self.s+'.documents.previous(k.document)', None],
				
				[self.te.documents.first, self.s+'.documents.first', None],
				[self.te.documents.middle, self.s+'.documents.middle', None],
				[self.te.documents.last, self.s+'.documents.last', None],
				[self.te.documents.any, self.s+'.documents.any', None],
				
				[AS.con.documents[3], 'con.documents[3]', None],
				
				[self.te.documents[
						AS.con.documents[3]:
						AS.con.documents['foo']], 
						self.s+'.documents[' +
						'con.documents[3]:' +
						"con.documents['foo']]", None],
				
				
				[(AS.its.name == 'foo').AND(AS.its.words == []), 
						"(its.name == 'foo').AND(its.words == [])", None],
				
				[AS.its.words != [], 
						'its.words != []', 
						(AS.its.words == []).NOT], # i.e. there isn't a KAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
						
				[AS.its.words == None, 'its.words == None', None],
				[AS.its.words.size > 0, 
						'its.words.size > 0', None],
				[AS.its.words <= '', "its.words <= ''", None],
				[AS.its.words.beginswith('foo').NOT, 
						"(its.words.beginswith('foo')).NOT", None],
				
				
				[AS.its.words.contains('foo'), "its.words.contains('foo')", None],
				[AS.its.words.isin('foo'), "its.words.isin('foo')", None],
				
				[self.te.documents[AS.its.size >= 42], 
						self.s+'.documents[its.size >= 42]', None],
				
				[self.te.documents[1:'bar'], 
						self.s+".documents[1:'bar']", 
						self.te.documents[AS.con.documents[1]:AS.con.documents['bar']]],
				
				[self.te.documents[1].text \
						.paragraphs.characters[
								AS.con.characters[3]:
								AS.con.characters[55]
						].next(AS.k.character).after,
						self.s+'.documents[1].text.paragraphs.characters' +
						'[con.characters[3]:con.characters[55]]' +
						'.next(k.character).after', None],
				
				[(AS.its.name != 'foo').AND(AS.its.words == []).NOT,
						"((its.name != 'foo').AND(its.words == [])).NOT",
						(AS.its.name == 'foo').NOT.AND(AS.its.words == []).NOT],
				
				[self.te.documents.beginning, self.s+'.documents.beginning', None],
				[self.te.documents.end, self.s+'.documents.end', None],
				[self.te.documents[3].before, self.s+'.documents[3].before', None],
				[self.te.documents['foo'].after, self.s+".documents['foo'].after", None],
				
				]:
			
			self.assertEqual(res, repr(val))
			d = self.te.AS_appdata.pack(val)
			val = unpackedVersion or val
			val2 = self.te.AS_appdata.unpack(d)
			if val.__class__ == self.te.AS_appdata.unpack(d).__class__: # note: Reference and GenericReference currently aren't comparable with each other, so the next test would always fail for those
				self.assertEqual(val, val2)
			val2 = self.te.AS_appdata.unpack(d)
			if val.__class__ == self.te.AS_appdata.unpack(d).__class__: # note: Reference and GenericReference currently aren't comparable with each other, so the next test would always fail for those
				self.assertEqual(val2, val)



if __name__ == '__main__':
	unittest.main()
