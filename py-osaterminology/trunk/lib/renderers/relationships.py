#!/usr/bin/env pythonw

from sys import stdout

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
		self.relationshipcache = {}
	
	def _relationships(self, klass):
		if not self.relationshipcache.has_key(klass.name):
			klass = klass.full()
			properties = [o for o in klass.properties() if o.type.realvalue().kind == 'class'] # TO DO: add isrelationship method to osadictionary.Property?
			elements = list(klass.elements())
			self.relationshipcache[klass.name] = (properties, elements)
		return self.relationshipcache[klass.name]
	
	def _hasrelationships(self, klass):
		p, e = self._relationships(klass)
		return bool(p or e)
		
	
	def draw(self, classname='application', maxdepth=3):
		def render(klass, visitedproperties, visitedelements, maxdepth):
			properties, elements = self._relationships(klass)
			if properties or elements:
				# a recurring relationship is shown in full at the shallowest level, and deeper repetitions of the same relationship are marked 'tbc' (e.g. in Finder, folders contain folders) to avoid duplication, so next two lines are used to keep track of repetitions
				allvisitedproperties= visitedproperties + [o.type for o in properties]
				allvisitedelements = visitedelements + [o.type for o in elements]
				self.renderer.down()
				for i, prop in enumerate(properties):
					propclass = prop.type.realvalue() # TO DO: asking for realvalue is dodgy; need to ensure we get a class definition
					iscontinued = (prop.type in visitedproperties or prop.type in allvisitedelements \
							or maxdepth < 2) and self._hasrelationships(propclass)
					self.renderer.add(prop.name, propclass.name, False,
							i == len(properties) and not elements, iscontinued)
					if not iscontinued:
						render(propclass, allvisitedproperties, allvisitedelements, maxdepth - 1)
				for i, elem in enumerate(elements):
					elemclass = elem.type.realvalue() # TO DO: asking for realvalue is dodgy; need to ensure we get a class definition
					iscontinued = (elem.type in visitedelements or maxdepth < 2) \
							and self._hasrelationships(elemclass)
					self.renderer.add(elem.name, None, True, 
							i == len(elements), iscontinued)
					if not iscontinued:
						render(elemclass, allvisitedproperties, allvisitedelements, maxdepth - 1)
				self.renderer.up()
		klass = self.terms.classes().byname(classname)
		self.renderer.add(classname, None, False, False)
		render(klass, [], [], maxdepth)

