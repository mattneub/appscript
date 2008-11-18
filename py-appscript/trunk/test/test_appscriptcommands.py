#!/usr/local/bin/python

import unittest, commands
import appscript, aem, mactypes

class TC_appscriptNewApp(unittest.TestCase):

	def test_by_name(self):
		for name in [
				'/Applications/TextEdit.app',
				'Finder.app',
				'System Events'
		]:
			a = appscript.app(name)
			self.assertNotEqual(None, a)
			self.assertEqual(appscript.reference.Application, a.__class__)
			self.assertEqual(appscript.reference.Reference, a.name.__class__)
		
		self.assertEqual("app(u'/Applications/TextEdit.app')", str(appscript.app('TextEdit')))
		self.assertEqual("app(u'/Applications/TextEdit.app')", str(appscript.app(name='TextEdit')))
		
		self.assertRaises(appscript.ApplicationNotFoundError, appscript.app, '/non-existent/app')
		self.assertRaises(appscript.ApplicationNotFoundError, appscript.app, 'non-existent.app')
	
	
	def test_by_id(self):
		for name in [
				'com.apple.textedit',
				'com.apple.finder',
		]:
			a = appscript.app(id=name)
			self.assertNotEqual(None, a)
			self.assertEqual(appscript.reference.Application, a.__class__)
			self.assertEqual(appscript.reference.Reference, a.name.__class__)
		
		self.assertEqual("app(u'/Applications/TextEdit.app')", str(appscript.app(id='com.apple.textedit')))
		
		self.assertRaises(appscript.ApplicationNotFoundError, appscript.app, id='non.existent.app')
	

	def test_by_creator(self):
		a = appscript.app(creator='ttxt')
		self.assertEqual(appscript.reference.Application, a.__class__)
		self.assertEqual(appscript.reference.Reference, a.name.__class__)
		self.assertEqual("app(u'/Applications/TextEdit.app')", str(a))
		self.assertRaises(appscript.ApplicationNotFoundError, appscript.app, id='!self.$o')
	
	
	def test_by_pid(self):
		pid = int(commands.getoutput("top -l1 | grep Finder | awk '{ print $1 }'"))
		a = appscript.app(pid=pid)
		self.assertEqual(appscript.reference.Application, a.__class__)
		self.assertEqual(appscript.reference.Reference, a.name.__class__)
		self.assertEqual("app(pid=%i)" % pid, str(a))
		self.assertEqual('Finder', a.name.get())
	
	
	def test_by_aem_app(self):
		a = appscript.app(aemapp=aem.Application('/Applications/TextEdit.app'))
		self.assertEqual(appscript.reference.Application, a.__class__)
		self.assertEqual(appscript.reference.Reference, a.name.__class__)
		self.assertEqual("app(aemapp=aem.Application('/Applications/TextEdit.app'))", str(a))
	



class TC_appscriptCommands(unittest.TestCase):

	def setUp(self):
		self.te = appscript.app('TextEdit')
		self.f = appscript.app('Finder')
	
	
	def test_commands_1(self):
		self.assertEqual('TextEdit', self.te.name.get())
		d = self.te.make(new=appscript.k.document, at=appscript.app.documents.end, 
				with_properties={appscript.k.text:'test test_commands'})
		self.assertEqual(appscript.reference.Reference, d.__class__)
		d.text.end.make(new=appscript.k.word, with_data=' test2')
		self.assertEqual('test test_commands test2', d.text.get())
		self.assertEqual(unicode, 
				type(d.text.get(ignore=[appscript.k.diacriticals, appscript.k.punctuation, 
						appscript.k.whitespace, appscript.k.expansion], timeout=10)))
		self.assertEqual(None, d.get(waitreply=False))
		
		d.text.set(u'\xa9 M. Lef\xe8vre')
		self.assertEqual(u'\xa9 M. Lef\xe8vre', d.text.get())
		
		d.close(saving=appscript.k.no)
	
	
	def test_commands_2(self):
		d = self.te.make(new=appscript.k.document, at=self.te.documents.end)
		
		self.te.set(d.text, to= 'test1')
		self.assertEqual('test1', d.text.get())
		
		self.te.set(d.text, to= 'test2')
		self.te.make(new=appscript.k.word, at=appscript.app.documents[1].paragraphs.end, with_data=' test3')
		self.assertEqual('test2 test3', d.text.get())
		
		d.close(saving=appscript.k.no)
		
		self.assertRaises(appscript.CommandError, self.te.documents[10000].get)
		
		self.assertEqual(int, type(self.te.documents.count()))
		self.assertEqual(self.te.documents.count(), self.te.count(each=appscript.k.document))
	
	
	def test_commands_3(self):
		self.assertEqual('Finder', self.f.name.get())
		val = self.f.home.folders['Desktop'].get(resulttype=appscript.k.alias)
		self.assertEqual(mactypes.Alias, val.__class__)
		self.assertEqual(val, self.f.desktop.get(resulttype=appscript.k.alias))
		self.assertEqual(list, type(self.f.disks.get()))
		
		r = self.f.home.get()
		f = r.get(resulttype=appscript.k.file_ref)
		self.assertEqual(r, self.f.items[f].get())
		
		self.assertEqual(self.f.home.items.get(), self.f.home.items.get())
		self.assertNotEqual(self.f.disks['non-existent'], self.f.disks[1].get())
	
	
	def test_command_error(self):
		try:
			self.f.items[10000].get()
		except appscript.CommandError, e:
			self.assertEqual(-1728, int(e))
			self.assertEqual("Command failed:\n\t\tOSERROR: -1728\n\t\tMESSAGE: Can't get reference.\n\t\tOFFENDING OBJECT: app(u'/System/Library/CoreServices/Finder.app').items[10000]\n\t\tCOMMAND: app(u'/System/Library/CoreServices/Finder.app').items[10000].get()", str(e))
			self.assertEqual(aem.EventError, e.realerror.__class__)




if __name__ == '__main__':
	unittest.main()

