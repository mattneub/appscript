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
		self._output = out
		self._indent = ''
		self._pad = False
	
	def add(self, name, islast, hilite=False, tbc=False):
		if self._pad:
			print >> self._output, '    ' + self._indent # insert a line of extra padding after a subtree
			self._pad = False
		print >> self._output, ' %s %s-%s%s' % (hilite and '->' or '  ', self._indent, name, tbc and ' ->' or '')
		if islast and self._indent:
			self._indent = self._indent[:-4] + '    '
	
	def down(self):
		self._indent += '   |'
	
	def up(self):
		self._indent = self._indent[:-4]
		self._pad = True


##

class InheritanceGrapher:
	# Provides help for the specified application
	
	def __init__(self, terms, renderer):
		self.terms = terms
		self.renderer = renderer
		self.childrenByClassName = self._findChildren()
	
	
	def _findChildren(self):
		# returns a dict; keys = class names, values = subclass names for each class
		classes = self.terms.classes()
		childrenByClassName = dict([(name, []) for name in classes.names()])
		for klass in classes:
			for superclass in klass.parents():
				try:
					lst = childrenByClassName[superclass.name]
				except KeyError: # ignore bad superclasses (e.g. Mail 2.0.7, iCal 2.0.3 wrongly specify AEM types, not application classes)
					continue
				if klass.name not in lst and klass.name != superclass.name:
					lst.append(klass.name)
		return childrenByClassName
			
	def _findParents(self, klass, children, result):
		# get list(s) of superclass names for given class
		# (some classes may have multiple parents, hence the result is a list of zero or more lists)
		# (note: last item in each sublist is name of the given class)
		if klass.parents():
			for parentClass in klass.parents():
				lst = children[:]
				if parentClass.name not in lst:
					lst.insert(0, parentClass.name)
				self._findParents(parentClass, lst, result)
		else:
			result.append(children)
	
	
	def _renderSubclasses(self, names, visited):
		# render specified class's subclasses
		# (remembers already-visited classes to avoid infinite recursion caused by 
		# circular inheritance in some apps' dictionaries, e.g. MS Word X)
		for i, name in enumerate(names):
			islast = i+1 == len(names)
			self.renderer.add(name, islast, tbc=name in visited and self.childrenByClassName[name])
			if name not in visited:
				visited.append(name)
				if self.childrenByClassName.get(name):
					self.renderer.down()
					self._renderSubclasses(self.childrenByClassName[name], visited)
					self.renderer.up()
	
	##
	
	def draw(self, classname=None):
		# draw the inheritance tree(s) for a given class, or else for the entire application
		# note: this is complicated by the need to represent multiple inheritance
		# (mi is shown by rendering all except one tree in truncated form, avoiding duplication)
		# note that multiple classes of the same name are collapsed into one for neatness
		if classname:					
			thisClass = self.terms.classes().byname(classname).collapse()
			parentLists = []
			self._findParents(thisClass, [thisClass.name], parentLists)
			for i, lst in enumerate(parentLists):
				# render all superclass trees
				for name in lst[:-1]: # render all parents in a single superclass tree
					self.renderer.add(name, True)
					self.renderer.down()
				# TO DO: decide if should just show all trees in full
				if not i: # first superclass tree, so render subclasses as well
					self.renderer.add(thisClass.name, True, True) # render classname
					self.renderer.down()
					self._renderSubclasses(self.childrenByClassName[classname], [])
					self.renderer.up()
				else: # for remaining trees, don't bother showing subclasses for space
					self.renderer.add(thisClass.name, True, False, True) # render classname, marking it as 'to be continued'
				for _ in lst[:-1]:
					self.renderer.up()
		else: # print full tree
			for klass in self.terms.classes():
				if not [o for o in klass.parents() if o.kind == 'class']: # is it a root class? (ignores invalid superclasses, e.g. Mail 2.0.7)
					self._renderSubclasses([klass.name], [])


######################################################################
# TEST
######################################################################

if __name__ == '__main__':
#	p = '/Applications/TextEdit.app'
#	p = '/System/Library/CoreServices/Finder.app'
#	p = '/Applications/Automator.app'
	#p = '/Applications/Microsoft Office X/Microsoft Word'
	p = '/Applications/ical.app'
	
	terms = aeteparser.parseapp(p)
	o = InheritanceGrapher(terms, TextRenderer())
	
	from time import time as t
	#tt=t()
	o.draw()
	print '\n\n\n'
	o.draw('window') #
	#print t()-tt

