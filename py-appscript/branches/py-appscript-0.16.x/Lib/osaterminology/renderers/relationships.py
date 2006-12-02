#!/usr/bin/env pythonw

from sys import stdout
from osaterminology.dom import aeteparser

######################################################################
# PRIVATE
######################################################################

class _Out:
	# Default target for writing help text; prints to stdout.
	def write(self, s):
		stdout.write( s.encode('utf8', 'replace'))


######################################################################
# PUBLIC
######################################################################

class TextRenderer:
	def __init__(self, out=_Out()):
		self.output = out
		self.indent = ''
		self._pad = False
	
	def add(self, name, type, ismany, islast, tbc=False):
		if self._pad:
			print >> self.output, '    ' + self.indent # insert a line of extra padding after a subtree
			self._pad = False
		print >> self.output, '    %s%s%s%s%s' % (self.indent,
				ismany and '=' or '-', name, type and ' <%s>' % type or '', tbc and ' ->' or '')
		if islast and self.indent:
			self.indent = self.indent[:-4] + '    '
	
	def down(self):
		self.indent += '   |'
	
	def up(self):
		self.indent = self.indent[:-4]
		self._pad = True


##

class RelationshipGrapher:
	def __init__(self, terms, renderer):
		self.terms = terms
		self.renderer = renderer
	
	def _relationships(self, klass):
			klass = klass.full()
			properties = [o for o in klass.properties() if o.type.realvalue().kind == 'class'] # TO DO: add isrelationship method to osadictionary.Property?
			elements = list(klass.elements())
			return properties, elements
		
	
	def draw(self, classname='application', maxdepth=3):
		def render(klass, visited, maxdepth): # TO DO: maxdepth support
			properties, elements = self._relationships(klass)
			if properties or elements:
				allvisited = visited + [o.type for o in properties + elements] # a recurring relationship is shown in full at the shallowest level, and deeper repetitions of the same relationship are marked 'tbc' (e.g. in Finder, folders contain folders)
				self.renderer.down()
				for i, prop in enumerate(properties):
					propclass = prop.type.realvalue() # TO DO: asking for realvalue is dodgy; need to ensure we get a class definition
					iscontinued = prop.type in visited
					if maxdepth < 2:
						p, e = self._relationships(propclass)
						iscontinued = iscontinued or p or e
					self.renderer.add(prop.name, propclass.name, False,
							i == len(properties) and not elements, iscontinued)
					if not prop.type in visited and maxdepth > 1:
						render(propclass, allvisited, maxdepth - 1)
				for i, elem in enumerate(elements):
					elemclass = elem.type.realvalue() # TO DO: asking for realvalue is dodgy; need to ensure we get a class definition
					iscontinued = elem.type in visited
					if maxdepth < 2:
						p, e = self._relationships(elemclass)
						iscontinued = iscontinued or p or e
					self.renderer.add(elem.name, None, True, 
							i == len(elements), iscontinued)
					if not elem.type in visited and maxdepth > 1:
						render(elemclass, allvisited, maxdepth - 1)
				self.renderer.up()
		klass = self.terms.classes().byname(classname)
		self.renderer.add(classname, None, False, False)
		render(klass, [], maxdepth)


######################################################################
# TEST
######################################################################

if __name__ == '__main__':
	#p = '/Applications/TextEdit.app'
	p = '/System/Library/CoreServices/Finder.app'
#	p = '/System/Library/CoreServices/System Events.app'
	#p = '/Applications/Automator.app'
	#p = '/Applications/Microsoft Office X/Microsoft Word'
	
	terms = aeteparser.parseapp(p, style='applescript')
	o = RelationshipGrapher(terms, TextRenderer())
	o.draw(maxdepth=5) # 'folder'

