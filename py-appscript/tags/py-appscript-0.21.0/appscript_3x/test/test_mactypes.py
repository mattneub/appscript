#!/usr/bin/env python3

import unittest, os, os.path, tempfile
from aem.ae import MacOSError
from aem import mactypes

class TC_MacTypes(unittest.TestCase):

	dir = '/private/tmp'
	
	def setUp(self):
		self.path1 = tempfile.mkstemp('', 'py-mactypes-test.', self.dir)[1] # tempnam raises a security warning re. security; it's part of the test code, not mactypes, so ignore it
		open(self.path1, 'w').close()
		fname = os.path.split(self.path1)[1]
		self.path2 = os.path.join(self.dir, 'moved-' + fname)
		# print "path: %r" % self.path1 # e.g. /private/tmp/py-mactypes-test.VLrUW7
	
	def test_alias(self):
		# make alias
		self.f = mactypes.Alias(self.path1)
				
		path1 = self.path1
		if not path1.startswith('/private/'):
			path1 = '/private' + path1 # KLUDGE: allow for altered temp path
		
		self.assertEqual("mactypes.Alias(%r)" % path1,  repr(self.f))
		
		#print "alias path 1: %s" % f.path # e.g. /private/tmp/py-mactypes-test.VLrUW7
		self.assertEqual(path1, self.f.path)
		
		# get desc
		#print `f.desc.type, f.desc.data` # alis, [binary data]
		self.assertEqual(b'alis', self.f.desc.type)

		
		# check alias keeps track of moved file
		os.rename(path1, self.path2)
		# print "alias path 2: %r" % f.path # /private/tmp/moved-py-mactypes-test.VLrUW7
		self.assertEqual(self.path2, self.f.path)

		self.assertEqual("mactypes.Alias(%r)" % self.path2, repr(self.f))
		
		# check a FileNotFoundError is raised if getting path/FileURL for a filesystem object that no longer exists
		os.remove(self.path2)
		self.assertRaises(MacOSError, lambda:self.f.path) # File not found.
		self.assertRaises(MacOSError, lambda:self.f.file) # File not found.


	def test_fileURL(self):

		g = mactypes.File('/non/existent path')

		self.assertEqual('/non/existent path', g.path)
		
		self.assertEqual(b'furl', g.desc.type)
		self.assertEqual('file://localhost/non/existent%20path', g.desc.data.decode('utf8'))

		self.assertEqual("mactypes.File('/non/existent path')", repr(g.file))

		# check a not-found error is raised if getting Alias for a filesystem object that doesn't exist
		self.assertRaises(MacOSError, lambda:g.alias) # File "/non/existent path" not found.


if __name__ == '__main__':
	unittest.main()
	