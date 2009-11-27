#!/usr/bin/env python

import unittest, commands
import osax, mactypes, aem

class TC_OSAX(unittest.TestCase):
	
	def test_1(self):
		sa = osax.OSAX('Standardadditions')
		
		self.assertEqual(65, sa.ASCII_number('A'))
		
		self.assertEqual(mactypes.Alias("/Applications/"), sa.path_to(osax.k.applications_folder))
		
		self.assertEqual(mactypes.Alias("/Library/Scripts/"), 
				sa.path_to(osax.k.scripts_folder, from_=osax.k.local_domain))
		
		self.assertRaises(AttributeError, getattr, sa, 'non_existent_command')
	
	
	def test_2(self):
		sa = osax.OSAX('Standardadditions', name='Finder')
		sa.activate()
		self.assertEqual({osax.k.button_returned: '', osax.k.gave_up: True}, sa.display_dialog('test', giving_up_after=1))
		self.assertEqual(mactypes.Alias("/System/Library/CoreServices/Finder.app/"), sa.path_to(None))
	
	
	def test_3(self):
		sa = osax.OSAX('Standardadditions', creator='MACS')
		sa.activate()
		self.assertEqual({osax.k.button_returned: '', osax.k.gave_up: True}, sa.display_dialog('test', giving_up_after=1))
		self.assertEqual(mactypes.Alias("/System/Library/CoreServices/Finder.app/"), sa.path_to(None))
	
	
	def test_4(self):
		sa = osax.OSAX('Standardadditions', id='com.apple.finder')
		sa.activate()
		self.assertEqual({osax.k.button_returned: '', osax.k.gave_up: True}, sa.display_dialog('test', giving_up_after=1))
		self.assertEqual(mactypes.Alias("/System/Library/CoreServices/Finder.app/"), sa.path_to(None))
	
	
	def test_5(self):
		pid = int(commands.getoutput("top -l1 | grep Finder | awk '{ print $1 }'"))
		sa = osax.OSAX('Standardadditions', pid=pid)
		self.assertEqual(mactypes.Alias("/System/Library/CoreServices/Finder.app/"), sa.path_to(None))
		sa.activate()
		self.assertEqual({osax.k.button_returned: '', osax.k.gave_up: True}, sa.display_dialog('test', giving_up_after=1))
	

	def test_6(self):
		sa = osax.OSAX('Standardadditions', aemapp=aem.Application("/System/Library/CoreServices/Finder.app/"))
		sa.activate()
		self.assertEqual({osax.k.button_returned: '', osax.k.gave_up: True}, sa.display_dialog('test', giving_up_after=1))
		self.assertEqual(mactypes.Alias("/System/Library/CoreServices/Finder.app/"), sa.path_to(None))
	


if __name__ == '__main__':
	unittest.main()

