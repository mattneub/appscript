#!/usr/bin/env python3

import unittest
from aem import findapp


class TC_FindApp(unittest.TestCase):

	def test_find(self):
		for val, res in [
			['/Applications/iCal.app', '/Applications/iCal.app'],
			['ical.app', '/Applications/iCal.app'],
			['ICAL.APP', '/Applications/iCal.app'],
			['ICAL', '/Applications/iCal.app'],
		]:
			self.assertEqual(res, findapp.byname(val))
		self.assertEqual('/Applications/TextEdit.app', findapp.bycreator(b'ttxt'))
		self.assertEqual('/System/Library/CoreServices/Finder.app', findapp.byid('com.apple.finder'))
		self.assertRaises(findapp.ApplicationNotFoundError, findapp.byname, 'NON-EXISTENT-APP')

		#self.assertEqual(unicode("/Users/has/\306\222\303\270u\314\210.app", 'utf8'), findapp.byname(unicode("\306\222\303\270u\314\210.app", 'utf8'))) # Unicode paths work ok

if __name__ == '__main__':
	unittest.main()
