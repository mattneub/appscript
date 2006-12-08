#!/usr/bin/env pythonw

##

# TO DO: synonyms

# TO DO: NotFoundError(KeyError) class for use in Nodes.byname(), etc.


# TO DO: currently hiding stuff like enums in tpnm suite that do need to be found

import sys

kAll = 'all'
kVisible = 'visible'
kHidden = 'hidden'

######################################################################
# PRIVATE
######################################################################

class _Vis(object):
	
	def visibility(self):
		return self._visibility[0]
	
	def setvisibility(self, state):
		prev = self.visibility()
		self._visibility[0] = state
		return prev


#######

class Nodes(_Vis): # TO DO: rename
	
	def __init__(self, visibility, items=[]):
		self._visibility = visibility
		self._all = items[:]
		self._visible = self._hidden = None
	
	def _real(self):
		if self._visibility == [kAll]:
			return self._all
		elif self._visibility == [kHidden]:
			if self._hidden is None:
				self._hidden = [o for o in self._all if not o.visible]
			return self._hidden
		else: # self._visibility == [kVisible]
			if self._visible is None:
				self._visible = [o for o in self._all if o.visible]
			return self._visible
	
	# reserved methods; users shouldn't call these
	
	def append(self, item): # TO DO: rename _append_
		self._visible = self._hidden = None
		return self._all.append(item)
	
	def insert(self, i, item): # TO DO: rename _insert_
		self._visible = self._hidden = None
		return self._all.insert(i, item)
	
	def extend(self, items): # TO DO: rename _extend_
		self._visible = self._hidden = None
		return self._all.extend(items)
	
	def remove(self, item): # TO DO: rename _remove_
		self._visible = self._hidden = None
		return self._all.remove(item)
	
	# list methods
	
	def __add__(self, item):
		return Nodes(self._visibility, self._all + item)
	
	def __nonzero__(self):
		return bool(self._real())
	
	def __repr__(self):
		return '<%s>' % repr(self._real())[1:-1]
	
	def __len__(self): 
		return len(self._real())
	
	def __getitem__(self, i):
		if isinstance(i, slice):
			return Nodes(self._visibility, self._all[i]) # TO DO: check this
		else:
			return self._real()[i]
	
	def __iter__(self):
		return iter(self._real())

	def __eq__(self, o):
		return self._real() == o
	
	def __ne__(self, o):
		return self._real() != o
	
	def __cmp__(self, o):
		return cmp(self._real(), o)

	def __contains__(self, o):
		return o in self._real()
	
	def index(self, o):
		return self._real().index(o)
	
	# custom methods
	
	def map(self, fn):
		for node in self._real():
			fn(node)

	def byname(self, name): 
		# TO DO: add optional 'all' parameter as well? Or add allbyname() method? Or leave users to do this themselves?
		d = dict([(o.name.lower(), o) for o in self._real()])
		return d[name.lower()]
		# TO DO: when getting commands by name, should really return first definition, not last, as that's the one that actually gets used by AS/appscript
	
	def bycode(self, code):
		d = dict([(o.code.lower(), o) for o in self._real()])
		return d[code.lower()]
	
	def names(self): # every name # TO DO: decide 'names' or 'name'
		return [o.name for o in self._real()]

#	TO DO: pluralnames()


##

class Types(Nodes): # represents a parameter/property's type(s) # TO DO: subclass Nodes (or something similar)

	
	def __repr__(self): return 'Types(%r)' % list(self)
	
	def realvalue(self): # TO DO
		return [o.realvalue() for o in self._all if o.realvalue().visible in self._visibility] # TO DO: return Nodes instance


#######

# just don't like this arrangement. needs to be strict about when something is a type vs a class/enum; this means we have a proxy class for representing property/element/parameter types, and this should work transparently (i.e. get rid of realvalue, etc.)

class Type(_Vis): # A property/parameter type description
	# AEM type/enumeration, or application class/valuetype/recordtype/enumeration
	kind = 'type'
	visible = True
	islist = False # TO DO: rename 'list'
	
	def __init__(self, visibility, name='', code=''):
		self._visibility = visibility
		self.name = name
		self.code = code
		self.special = Nodes(self._visibility) # class(es)/enumeration(s)/recordtype(s)/valuetype(s); parser is reponsible for calling _add_ to add these
	
	def _add_(self, item):
		self.special.append(item) # TO FIX: weakref item
	
	def __repr__(self):
		if self.name:
			return 'Type(%r)' % self.name
		else:
			return 'Type(code=%r)' % self.code
	
	def realvalue(self): # TO DO: delete; use realvalues() instead?
	#	print 're', self.special, self.special and self.special[-1] or self
	#	return self.special and self.special[-1] or self # TO DO: this is where hidden items go missing; probably where 
		if self.special: # prefer to return value with current visibility setting
			result = self.special[-1]
		else: # try to return a value with any visibilty setting, else return self (i.e. type)
			oldvis = self.setvisibility(kAll)
			if self.special:
				result = self.special[-1]
			else:
				result = self
			self.setvisibility(oldvis)
		return result
	
	def realvalues(self, kind=None): # TO DO: rename 'real'
		if kind:
			return Nodes(self._visibility, [n for n in self.special if n.kind == kind])
		else:
			return self.special or Nodes(self._visibility, [self])
		


class ListOfType(_Vis): # A property/parameter type description modifier
	kind = 'type'
	islist = True
	
	def __init__(self, visibility, type):
		self._visibility = visibility
		self.type = type
	
	name = property(lambda self:self.type.name)
	code = property(lambda self:self.type.code)
	visible = property(lambda self:self.type.visible)
	
	def __repr__(self):
		return 'ListOfType(%r)' % self.type
	
	def realvalue(self): # TO DO
		return self.type.realvalue()
	
	def realvalues(self, kind=None):
		return self.type.realvalues(kind)


#######


class _Base(_Vis):
	def __init__(self, visibility, name, code, description, visible):
		self._visibility = visibility
		self.name = name
		self.code = code
		self.description = description
		self.visible = visible
		self.documentation = ''
	
	islist = False
	
	def __repr__(self):
		return '%s(%s)' % (self.__class__.__name__, self.name and `self.name` or 'code=%r' % self.code)
	
	def realvalue(self):
		return self



######################################################################
# PUBLIC
######################################################################

class Dictionary(_Base):
	kind = 'dictionary'

	def __init__(self, visibility, name, path):
		_Base.__init__(self, visibility, name, None, None, None)
		self.path = path
		self._suites = Nodes(visibility)
		self._visibility = visibility # either [True], [False] or [True, False]
	
	def _add_(self, item):
		{'suite':self._suites}[item.kind].append(item)
	
	def suites(self):
		return self._suites

	def classes(self):
		res = Nodes(self._visibility)
		for suite in self._suites:
			res.extend(suite._classes)
		self.allclasses = lambda:res
		return res
		
	def commands(self):
		res = Nodes(self._visibility)
		for suite in self._suites:
			res.extend(suite._commands)
		self.allcommands = lambda:res
		return res


class Suite(_Base):
	kind = 'suite'
	
	def __init__(self, visibility, name, code, description, visible):
		_Base.__init__(self, visibility, name, code, description, visible)
		self._classes = Nodes(visibility)
		self._commands = Nodes(visibility)
		self._events = Nodes(visibility)
		self._enumerations = Nodes(visibility)
		self._recordtypes = Nodes(visibility)
		self._valuetypes = Nodes(visibility)
	
	def _add_(self, item):
		{'class':self._classes, 'command':self._commands, 'event':self._events, 
			'enumeration':self._enumerations, 'record-type':self._recordtypes, 
			'value-type':self._valuetypes}[item.kind].append(item)
		
	def classes(self):
		return self._classes
	
	def commands(self):
		return self._commands
	
	def events(self):
		return self._events
	
	def enumerations(self):
		return self._enumerations
	
	def recordtypes(self):
		return self._recordtypes
	
	def valuetypes(self):
		return self._valuetypes


##

# TO DECIDE: when rendering earlier full classes, should superclasses defined in later suites be counted?

# TO DO: add isoverlapped() method

class Class(_Base):
	kind = 'class'
	
	def __init__(self, visibility, name, code, description, visible, pluralname, suitename, type): # TO DO: use weakref'd suite, not suitename?
		_Base.__init__(self, visibility, name, code, description, visible)
		self.pluralname = pluralname
		self.suitename = suitename
		self._contents = Nodes(visibility)
		self._superclasses = Nodes(visibility)
		self._properties = Nodes(visibility)
		self._elements = Nodes(visibility)
		self._respondsto = Nodes(visibility)
		self._type = type # TO DO: make public?
		
	
	def _add_(self, item):
		{'contents':self._contents, 'property':self._properties, 
				'element':self._elements, 'responds-to':self._respondsto, 
				'type':self._superclasses}[item.kind].append(item)
	
	def _clean(self, alreadycleaned): # TO DO: also needs to clean 'respondsto' and 'contents'
		# Eliminates property and element definitions in this class that are duplicates of existing definitions in superclasses. Any superclasses are cleaned recursively.
		#
		# Note: cleaning is fairly expensive when performed on an entire dictionary (e.g. 5 secs cleaning time compared to 3secs parsing time for InDesign CS2), so invocation is best deferred until/unless it's actually needed. Therefore, all properties/methods that use self._property and self._element are responsible for ensuring that _clean is invoked before doing anything with them.
		# (BTW, in a multithreaded app, it should be possible for a background thread to do cleaning while the user is looking at the just-opened dictionary in its basic state and deciding what part to view first. That should improve responsiveness when they pick an option that requires additional cleaning before use, as by then it's probably been cleaned anyway.)
		#
		# Note: overlapping class definitions are treated as subclasses of the previous definition, even if their aete/sdef definition doesn't explicitly list it as such (e.g. Automator's 'application' class is defined 3 times, inheriting 'item', 'responder' (itself a subclass of 'item') and 'application')
		#
		# A useful side-effect of this method is that it returns ALL properties and elements for this class, both inherited and defined in this class. These can be used by other methods such as allproperties and allelements. 
		#
		parents = []
		self._actualparents(parents)
		# need to avoid infinite recursion if app defines circular inheritance between classes (e.g. Word X), so maintain a list of classes that have previously been cleaned
		alreadycleaned.append(self)
		parents = [o for o in parents if o not in alreadycleaned]
		if parents:
			inheritedproperties, inheritedelements = [lst[:] for lst in parents[-1]._clean(alreadycleaned)] # TO DO: why only last parent? think this is wrong
		else:
			inheritedproperties, inheritedelements = [], []
		# remove duplicates
		for thislist, inheritedlist in [(self._properties, inheritedproperties), (self._elements, inheritedelements)]:
			removal = []
			for item in thislist:
				if item in inheritedlist:
					removal.append(item)
				else:
					inheritedlist.append(item)
			for item in removal:
				thislist.remove(item)
		self._clean = lambda alreadycleaned:(inheritedproperties, inheritedelements)
		return inheritedproperties, inheritedelements
	
	def _reclean(self):
		# clean semi-duplicate properties and elements in this collapsed/full class
		res = Nodes(self._visibility)
		found = []
		# eliminate any overlapped properties with same name and visibility, ignoring type, description, etc.
		for item in self._properties[::-1]:
			if (item.name, item.visible) not in found:
				res.insert(0, item)
				found.append((item.name, item.visible))
		self._properties = res
		# clean semi-duplicate elements
		res = Nodes(self._visibility)
		found = []
		# eliminate any overlapped elements with same type and visibility, ignoring accessors, etc.
		for item in self._elements[::-1]:
			if (item.type, item.visible) not in found:
				res.insert(0, item)
				found.append((item.type, item.visible))
		self._elements = res
		# clean semi-duplicate responds-to
		# TO DO
	
	def _actualparents(self, parents):
		for klass in self._superclasses:
			# if there's multiple class definition with same name as this class, get the one that comes before this one
			for item in klass.special[::-1]: # usually one, possibly more (if there's multiple definitions with same class name), Class instances
				if item.kind == 'class' and item not in parents and item != self:
					parents.insert(0, item) # TO DO: weakref item
					item._actualparents(parents)
					break
		parents = Nodes(self._visibility, parents)
#		self._actualparents = lambda:parents
	
	##

	def classes(self): # return all class definitions sharing the same name
		return Nodes(self._visibility, self._type.realvalues('class'))
	
	def isunique(self):
		return len(self._type.realvalues('class')) == 1
		
	def isoverlapped(self):
		defs = self._type.realvalues('class')
		if defs:
			return not (self is defs[-1])
		else:
			return False

	def suitenames(self):
		return [o.suitename for o in self.classes()]
	
	##
	
	def collapse(self): # collapse all class definitions with the same name
		oldclasses = self._type.realvalues('class')
		lastdef = oldclasses and oldclasses[-1] or self._type.realvalue() # TO DO: note: 'or self.get _type.realvalue()' is a kludge (Mail's OLD message editor elements causes this line to barf otherwise)
		newclass = Class(self._visibility, lastdef.name, lastdef.code, lastdef.description, 
				lastdef.visible, lastdef.pluralname, lastdef.suitename, lastdef._type)
		for oldclass in oldclasses:
			# add superclasses (not including any that are being collapsed)
			for parent in oldclass._superclasses:
				if parent.name != newclass.name:
					newclass._add_(parent)
			# add contents
			for group in [oldclass.contents(), oldclass.properties(), oldclass.elements(), oldclass.respondsto()]:
				for item in group:
					newclass._add_(item) 
		# clean semi-identical entries (e.g. Automator application name)
		newclass._reclean()
	#	self.collapse = lambda:newclass # unsafe
		return newclass
	
	
	def full(self):
		oldclass = self.collapse()
		newclass = Class(self._visibility, oldclass.name, oldclass.code, oldclass.description, 
				oldclass.visible, oldclass.pluralname, oldclass.suitename, oldclass._type)
		newclass. _superclasses = oldclass. _superclasses
		inheritedproperties, inheritedelements = oldclass._clean([])
#		newclass._contents = Nodes(self._visibility) # TO DO: _contents, respondsto
		newclass._properties = Nodes(self._visibility, inheritedproperties)
		newclass._elements = Nodes(self._visibility, inheritedelements)
		newclass._clean = lambda alreadycleaned:(inheritedproperties, inheritedelements)
		# clean semi-identical entries (e.g. Automator application name)
		newclass._reclean()
	#	self.full = lambda:newclass # unsafe
		return newclass
	
	##
	
	def contents(self):
		self._clean([]) # deferred cleanup; makes sure any duplicate properties/elements/respondstos already defined in superclasses are removed before returning a list of them
		return self._contents
	
	def parents(self):
		res = Nodes(self._visibility)
		for o in self._superclasses:
			classes = o.realvalues('class')
			if classes and classes[-1].name == self.name:
				res.append(classes[classes.index(self) - 1]) # TO DO: breaks on OmniGraffle 2.0.8 due to 'application' class having >1 code
			else:
				res.append(o.realvalue()) # remember, bad dictionaries may declare AE types as parents, e.g. Tiger iCal
		return res
	
	def properties(self):
		self._clean([]) # deferred cleanup; makes sure any duplicate properties/elements/respondstos already defined in superclasses are removed before returning a list of them
		return self._properties
	
	def elements(self):
		self._clean([]) # deferred cleanup; makes sure any duplicate properties/elements/respondstos already defined in superclasses are removed before returning a list of them
		return self._elements
	
	def respondsto(self):
		self._clean([]) # deferred cleanup; makes sure any duplicate properties/elements/respondstos already defined in superclasses are removed before returning a list of them
		return self._respondsto



class Property(_Base):
	kind = 'property'
	
	type = property(lambda self:self.types[-1]) # TO DO: kludgy; provides API compatibility with Element, but is not ideal
	
	def __init__(self, visibility, name, code, description, visible, access): # inproperties?
		_Base.__init__(self, visibility, name, code, description, visible)
		self.access = access
		self.types = Types(visibility)
	
	def __eq__(self, val):
		return (self.__class__, self.name, self.code, self.description, self.visible, self.access, self.types) ==\
				(val.__class__, val.name, val.code, val.description, val.visible, val.access, val.types)
	
	def _add_(self, item):
		{'type':self.types}[item.kind].append(item)
	
#	def isrelationship(self):
#		return bool(self.type.realvalue().kind == 'class') # TO DO


class Contents(Property):
	kind = 'contents'


class Element(_Base):
	kind = 'element'
	
	def __init__(self, visibility, type, description, visible, access, isnameplural):
		# Note: don't call Base.__init__ as this will cause an error due to the name and code properties in this class
		self._visibility = visibility
		self.description = description
		self.visible = visible
		self.documentation = ''
		self.type = type # Type instance
		self.access = access
		self._accessors = [] # 'index', 'name', 'id', 'range', 'relative', 'test'
		if isnameplural:
			self._name = lambda: type.realvalue().pluralname or type.name
		else:
			self._name = lambda: type.name
			
	
	# Note: can't assign name and code attributes at __init__ time as Type object may not yet contain both values, so have to use properties to let users get these values
	name = property(lambda self:self._name())
	code = property(lambda self:self.type.code)
	
	def __eq__(self, val):
		# used by Class._clean(); compares private _accessors, since public accessors property causes problems with circular calls to _clean when inferring reference forms
		return (self.__class__, self.type, self.access, self._accessors) == (val.__class__, val.type, val.access, val._accessors)
	
	def accessors(self):
		if not self._accessors: # some (Cocoa Scripting) dictionaries don't list reference forms, leaving them to be inferred according to element class, so fill these (hoping that it's correct, since these assumptions aren't safe non-CS apps - which is a problem when using OSACopyScriptingDefinition, as that will stupidly strip any existing accessor info when converting aetes->sdefs)
			self._accessors = ['index']
			klass = self.type.realvalue()
			if klass.kind == 'class': # bug workaround; OSACopyScriptingDefinition loses hidden classes when converting aetes to sdefs (e.g. Tiger Mail), so skip if there's a problem # TO DO: find better way of implementing realvalue(), e.g. allowing user to specify kind as optional argument to realvalue() # TO DO: check for similar problem conditions
				propertynames = klass.full().properties().names()
				if 'name' in propertynames:
					self._accessors += ['name']
				if 'id' in propertynames:
					self._accessors += ['id']
			self._accessors += ['range', 'relative', 'test']
		return self._accessors
	
	def _add_(self, item):
		if item.kind == 'accessor':
			self._accessors.append(item.style)
	
	def __repr__(self):
		return '%s(%r)' % (self.__class__.__name__, self.type.name) # TO DO


class Accessor: # not retained
	kind = 'accessor'
	
	def __init__(self, visibility, style):
		self.style = style


class RespondsTo(_Base):
	kind = 'responds-to'
	
	def __init__(self, visibility, name, visible):
		_Base.__init__(self, visibility, name, None, None, visible)


##

class Command(_Base):
	kind = 'command'
	
	def __init__(self, visibility, name, code, description, visible, suitename): 
		_Base.__init__(self, visibility, name, code, description, visible)
		self.suitename = suitename
		self.directparameter = None # TO DO: visibility (make this a property)
		self.parameters = Nodes(self._visibility)
		self.result = None # TO DO: visibility (make this a property)
	
	def _add_(self, item):
		if item.kind == 'direct-parameter':
			self.directparameter = item
		elif item.kind == 'result':
			self.result = item
		else:
			{'parameter':self.parameters}[item.kind].append(item)


class Parameter(_Base):
	kind = 'parameter'
	
	def __init__(self, visibility, name, code, description, visible, optional): 
		_Base.__init__(self, visibility, name, code, description, visible)
		self.types = Types(visibility)
		self.optional = optional
	
	def _add_(self, item):
		{'type':self.types}[item.kind].append(item)


class DirectParameter(Parameter):
	kind = 'direct-parameter'
	
	def __init__(self, visibility, description, visible, optional): 
		Parameter.__init__(self, visibility, '', '', description, visible, optional)


class Result(Parameter):
	kind = 'result'
	
	def __init__(self, visibility, description): 
		Parameter.__init__(self, visibility, '', '', description, False, False)


class Event(Command):
	kind = 'event'


##

class Enumeration(_Base):
	kind = 'enumeration'
	
	def __init__(self, visibility, name, code, description, visible, inline, suitename): 
		_Base.__init__(self, visibility, name, code, description, visible)
		self.inline = inline # None/int
		self.suitename = suitename
		self._enumerators = Nodes(self._visibility)
	
	def _add_(self, item):
		{'enumerator':self._enumerators}[item.kind].append(item)
	
	def enumerators(self):
		return self._enumerators
		


class Enumerator(_Base):
	kind = 'enumerator'


class RecordType(_Base):
	kind = 'record-type'
	
	def __init__(self, visibility, name, code, description, visible, suitename): 
		_Base.__init__(self, visibility, name, code, description, visible)
		self.suitename = suitename
		self.types = Types(visibility)
		self.properties = Nodes(self._visibility)
	
	def _add_(self, item):
		{'property':self.properties, 'type':self.types}[item.kind].append(item)


class ValueType(_Base): # TO DO: suitename
	kind = 'value-type'



