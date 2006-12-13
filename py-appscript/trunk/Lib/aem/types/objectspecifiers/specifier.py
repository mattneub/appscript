"""specifier -- Used to construct object specifiers.

(C) 2005 HAS
"""

from CarbonX import AE, kAE

import base, testclause



######################################################################
# UNRESOLVED REFERENCE
######################################################################

class DeferredSpecifier(base.BASE):	
	"""Deferred specifier; used to represent unresolved container references that may need to be resolved later. A performance optimisation.
	
	When unpacking specifier AEDescs of typeObjectSpecifier, if the topmost AEDesc is of formPropertyID, formAbsolutePosition, formName and formUniqueID (the simplest and most commonly used forms), its container AEDesc isn't unpacked immediately; instead, it's placed in a DeferredSpecifier instance and is only unpacked if actually needed (e.g. when __repr__ or AEM_resolve is called). 
	
	This makes the implementation a little more complex, but gives an approximately 2x speed up when unpacking references. Repacking these references is also faster as the original AEDesc is retained instead of being repacked from scratch.
	"""

	def __init__(self, desc, codecs):
		self._desc = desc
		self._codecs = codecs
	
	def _realRef(self):
		ref = self._codecs.unpack(self._desc) or self._codecs.app
		self._realRef = lambda:ref
		return ref
	
	def AEM_trueSelf(self):
		return self
		
	def __repr__(self):
		return repr(self._realRef())
	
	def __eq__(self, v):
		return self._realRef() == v
	
	def AEM_root(self):
		return self._realRef().AEM_root()
	
	def AEM_resolve(self, obj):
		return self._realRef().AEM_resolve(obj)
		

######################################################################
# BASE CLASS FOR ALL REFERENCE FORMS
######################################################################

class Specifier(base.BASE):
	"""Base class for all object specifier classes."""
	
	def __init__(self, container, key):
		self._container = container
		self._key = key
		
	def AEM_root(self):
		# Get reference's root node. Used by range and filter specifiers when determining type of reference
		# passed as argument(s): range specifiers take absolute (app-based) and container (con-based)
		# references; filter specifiers require an item (its-based) reference.
		return self._container.AEM_root()
	
	def AEM_trueSelf(self):
		# Called by specifier classes when creating a reference to sub-element(s) of the current reference.
		# - An AllElements specifier (which contains 'want', 'form', 'seld' and 'from' values) will return an UnkeyedElements object (which contains 'want' and 'from' data only). The new specifier object  (ElementByIndex, ElementsByRange, etc.) wraps itself around this stub and supply its own choice of 'form' and 'seld' values.
		# - All other specifiers simply return themselves. 
		#
		#This sleight-of-hand allows foo.elements('bar ') to produce a legal reference to all elements, so users don't need to write foo.elements('bar ').all to achieve the same goal. This isn't a huge deal for aem, but makes a significant difference to the usability of user-friendly wrappers like appscript.
		return self
	
	def AEM_packSelf(self, codecs):
		# Pack this Specifier; called by codecs.
		desc = self._packSelf(codecs)
		self.AEM_packSelf = lambda codecs: desc # once packed, reuse this AEDesc for efficiency
		return desc


######################################################################
# INSERTION POINT REFERENCE FORM
######################################################################

class InsertionSpecifier(Specifier):
	"""Form: allelementsref.start/end, elementsref.before/after
		A reference to an element insertion point.
	"""
	def __init__(self, container, key, keyname):
		Specifier.__init__(self, container, key)
		self._keyname = keyname
	
	def __repr__(self):
		return '%r.%s' % (self._container, self._keyname)
	
	def _packSelf(self, codecs):
		return base.packListAs(kAE.typeInsertionLoc, [
				(kAE.keyAEObject, self._container.AEM_packSelf(codecs)), 
				(kAE.keyAEPosition, self._key),
				])
	
	def AEM_resolve(self, obj):
		return getattr(self._container.AEM_resolve(obj), self._keyname)


######################################################################
# BASE CLASS FOR ALL OBJECT REFERENCE FORMS
######################################################################

class _PositionSpecifier(Specifier):
	"""All property and element reference forms inherit from this class.
	
	Note that comparison and logic 'operator' methods are implemented on this class - these are only for use in constructing its-based references and shouldn't be used on app- and con-based references. Aem doesn't enforce this rule itself so as to minimise runtime overhead (the target application will raise an error if the user does something foolish).
	"""
	
	_kBeginning = base.packEnum(kAE.kAEBeginning)
	_kEnd = base.packEnum(kAE.kAEEnd)
	_kBefore = base.packEnum(kAE.kAEBefore)
	_kAfter = base.packEnum(kAE.kAEAfter)
	_kPrevious = base.packEnum(kAE.kAEPrevious)
	_kNext = base.packEnum(kAE.kAENext)
	
	def __init__(self, wantcode, container, key):
		self.AEM_want = wantcode
		Specifier.__init__(self, container, key)
	
	def __repr__(self):
		return '%r.%s(%r)' % (self._container, self._by, self._key)
	
	def _packSelf(self, codecs):
		return base.packListAs(kAE.typeObjectSpecifier, [
				(kAE.keyAEDesiredClass, base.packType(self.AEM_want)),
				(kAE.keyAEKeyForm, self._keyForm),
				(kAE.keyAEKeyData, self._packKey(codecs)),
				(kAE.keyAEContainer, self._container.AEM_packSelf(codecs)),
				])
	
	# Comparison tests; these should only be used on its-based references:
	
	def gt(self, val):
		"""gt(anything) --> is greater than test"""
		return testclause.GreaterThan(self, val)
		
	def ge(self, val):
		"""ge(anything) --> is greater than or equals test"""
		return testclause.GreaterOrEquals(self, val)
	
	def eq(self, val):
		"""eq(anything) --> equals test"""
		return testclause.Equals(self, val)
	
	def ne(self, val):
		"""ne(anything) --> does not equal test"""
		return testclause.NotEquals(self, val)
	
	def lt(self, val):
		"""lt(anything) --> is less than test"""
		return testclause.LessThan(self, val)
	
	def le(self, val):
		"""le(anything) --> is less than or equals test"""
		return testclause.LessOrEquals(self, val)
	
	def startswith(self, val):
		"""startswith(anything) --> starts with test"""
		return testclause.StartsWith(self, val)
	
	def endswith(self, val):
		"""endswith(anything) --> ends with test"""
		return testclause.EndsWith(self, val)
	
	def contains(self, val):
		"""contains(anything) --> contains test"""
		return testclause.Contains(self, val)
	
	def isin(self, val):
		"""isin(anything) --> isin test"""
		return testclause.IsIn(self, val)
	
	# Logic tests; these should only be used on its-based references:
	
	# Note: these three methods allow boolean tests to be written in shorthand form;
	# e.g. 'its.foo.AND(...)' will automatically expand to 'its.foo.eq(True).AND(...)'
	
	def AND(self, *operands):
		"""AND(test, ...) --> logical AND test"""
		return testclause.Equals(self, True).AND(*operands)
		
	def OR(self, * operands):
		"""OR(test, ...) --> logical OR test"""
		return testclause.Equals(self, True).OR(*operands)
	
	NOT = property(lambda self: testclause.Equals(self, True).NOT, doc="NOT --> logical NOT test")
	
	# Insertion references can be used on any kind of element reference, and also on property references where the property represents a one-to-one relationship, e.g. textedit.documents[1].text.end is valid:
		
	start = property(lambda self: InsertionSpecifier(self, self._kBeginning, 'start'), doc="start --> insertion location")
	end = property(lambda self: InsertionSpecifier(self, self._kEnd, 'end'), doc="end --> insertion location")
	before = property(lambda self: InsertionSpecifier(self, self._kBefore, 'before'), doc="before --> insertion location")
	after = property(lambda self: InsertionSpecifier(self, self._kAfter, 'after'), doc="after --> insertion location")
	
	# Property and element references can be used on any type of object reference:
	
	def property(self, propertycode):
		"""property(propertycode) --> property"""
		return Property(kAE.cProperty, self, propertycode)
	
	def userproperty(self, name):
		"""property(name) --> property"""
		return UserProperty(kAE.cProperty, self, name)
	
	def elements(self, elementcode):
		"""elements(elementcode) --> all elements"""
		return AllElements(elementcode, self)
	
	# Relative position references are unlikely to work on one-to-one relationships - but what the hey, it simplifies the class structure a bit.
	
	def previous(self, elementcode):
		"""previous(elementcode) --> element"""
		return ElementByRelativePosition(elementcode, self, self._kPrevious, 'previous')
	
	def next(self, elementcode):
		"""next(elementcode) --> element"""
		return ElementByRelativePosition(elementcode, self, self._kNext, 'next')


######################################################################
# PROPERTY REFERENCE FORMS
######################################################################

class Property(_PositionSpecifier):
	"""Form: ref.property(code)
		A reference to a user-defined property, where code is the code identifying the property.
	"""
	_by = 'property'
	_keyForm = base.packEnum(kAE.formPropertyID)
	
	def _packKey(self, codecs):
		return base.packType(self._key)
	
	def AEM_resolve(self, obj):
		return self._container.AEM_resolve(obj).property(self._key)


class UserProperty(_PositionSpecifier):
	"""Form: ref.userproperty(name)
		A reference to a user-defined property, where name is a string representing the property's name. 
		
		Scriptable applications shouldn't use this reference form, but OSA script applets can.
		Note that OSA languages may have additional rules regarding case sensitivity/conversion.
	"""
	_by = 'userproperty'
	_keyForm = base.packEnum('usrp')
	
	def _packKey(self, codecs):
		return codecs.pack(self._key).AECoerceDesc(kAE.typeChar)
	
	def AEM_resolve(self, obj):
		return self._container.AEM_resolve(obj).userproperty(self._key)


######################################################################
# ELEMENT REFERENCE FORMS
######################################################################

###################################
# Single elements

class _SingleElement(_PositionSpecifier):
	"""Base class for all single element specifiers."""
	
	def __init__(self, wantcode, container, key):
		# Notes: when byindex, byname, byid, first, middle, last or any is called on an AllElements object, we want to 'strip' the AllElements object away and use the underlying UnkeyedElements object as our 'container' instead. AEM_trueSelf returns the UnkeyedElements object when called on an AllElements object; in all other cases it returns the same object it was called on.
		_PositionSpecifier.__init__(self, wantcode, container.AEM_trueSelf(), key)
	
	def _packKey(self, codecs):
		return codecs.pack(self._key)
	
	def AEM_resolve(self, obj):
		return getattr(self._container.AEM_resolve(obj), self._by)(self._key)


#######

class ElementByName(_SingleElement):
	"""Form: elementsref.byname(text)
		A reference to a single element by its name, where text is string or unicode.
	"""
	_by = 'byname'
	_keyForm = base.packEnum(kAE.formName)


class ElementByIndex(_SingleElement):
	"""Form: elementsref.byindex(i)
		A reference to a single element by its index, where i is a non-zero whole number.
	"""
	_by = 'byindex'
	_keyForm = base.packEnum(kAE.formAbsolutePosition)


class ElementByID(_SingleElement):
	"""Form: elementsref.byid(anything)
		A reference to a single element by its id.
	"""
	_by = 'byid'
	_keyForm = base.packEnum(kAE.formUniqueID)

##

class ElementByOrdinal(_SingleElement):
	"""Form: elementsref.first/middle/last/any
		A reference to first/middle/last/any element.
	"""
	_keyForm = base.packEnum(kAE.formAbsolutePosition)
	
	def __init__(self, wantcode, container, key, keyname):
		self._keyname = keyname
		_SingleElement.__init__(self, wantcode, container, key)
	
	def __repr__(self):
		return '%r.%s' % (self._container, self._keyname)
	
	def AEM_resolve(self, obj):
		return getattr(self._container.AEM_resolve(obj), self._keyname)


class ElementByRelativePosition(_SingleElement):
	"""Form: elementsref.previous/next(code)
		A relative reference to previous/next element, where code
		is the class code of element to get.
	"""
	_keyForm = base.packEnum(kAE.formRelativePosition)
	
	def __init__(self, wantcode, container, key, keyname):
		# Note: this method overrides _SingleElement.__init__() since we want to keep any AllElements container references as-is, not sub-select them.
		self._keyname = keyname
		_PositionSpecifier.__init__(self, wantcode, container, key)
	
	def __repr__(self):
		return '%r.%s(%r)' % (self._container, self._keyname, self.AEM_want)
	
	def AEM_resolve(self, obj):
		return getattr(self._container.AEM_resolve(obj), self._keyname)(self.AEM_want)


###################################
# Multiple elements

class _MultipleElements(_PositionSpecifier):
	"""Base class for all multiple element specifiers."""
	
	_kFirst = base.packAbsoluteOrdinal(kAE.kAEFirst)
	_kMiddle = base.packAbsoluteOrdinal(kAE.kAEMiddle)
	_kLast = base.packAbsoluteOrdinal(kAE.kAELast)
	_kAny = base.packAbsoluteOrdinal(kAE.kAEAny)
	
	first = property(lambda self: ElementByOrdinal(self.AEM_want, self, self._kFirst, 'first'), doc="first --> element")
	middle = property(lambda self: ElementByOrdinal(self.AEM_want, self, self._kMiddle, 'middle'), doc="middle --> element")
	last = property(lambda self: ElementByOrdinal(self.AEM_want, self, self._kLast, 'last'), doc="last --> element")
	any = property(lambda self: ElementByOrdinal(self.AEM_want, self, self._kAny, 'any'), doc="any --> element")
	
	def byname(self, name):
		"""byname(name) --> element"""
		return ElementByName(self.AEM_want, self, name)
	
	def byindex(self, index):
		"""byindex(index) --> element"""
		return ElementByIndex(self.AEM_want, self, index)
	
	def byid(self, id):
		"""byid(id) --> element"""
		return ElementByID(self.AEM_want, self, id)
	
	def byrange(self, start, stop):
		"""byrange(start, stop) --> elements"""
		return ElementsByRange(self.AEM_want, self, (start, stop))
	
	def byfilter(self, expression):
		"""byfilter(start, expression) --> elements"""
		return ElementsByFilter(self.AEM_want, self, expression)


#######

class ElementsByRange(_MultipleElements):
	"""Form: elementsref.range(start, stop)
		A reference to a range of elements, where start and stop are relative references 
		to the first and last elements in range (see also 'con').
	"""
	_keyForm = base.packEnum(kAE.formRange)
	
	def __init__(self, wantcode, container, key):
		for item in key:
			if not isinstance(item, Specifier): # quick sanity check; normally relative 'con'-based refs, but absolute 'app'-based refs are legal (note: won't catch its-based references, as that'd take more code to check, but we'll just have to trust user isn't that careless)
				raise TypeError, 'Bad argument in byrange(): %r' % item
		_PositionSpecifier.__init__(self, wantcode, container.AEM_trueSelf(), key)
	
	def __repr__(self):
		return '%r.byrange(%r, %r)' % ((self._container,) + self._key)

	def _packKey(self, codecs):
		return base.packListAs(kAE.typeRangeDescriptor, [
				(kAE.keyAERangeStart, codecs.pack(self._key[0])), 
				(kAE.keyAERangeStop, codecs.pack(self._key[1])),
				])
	
	def AEM_resolve(self, obj):
		return self._container.AEM_resolve(obj).byrange(*self._key)


class ElementsByFilter(_MultipleElements):
	"""Form: elementsref.filter(expr)
		A reference to all elements that match a condition, where expr 
		is a relative reference to the object being tested (see also 'its').
	"""
	_keyForm = base.packEnum(kAE.formTest)
	
	def __init__(self, wantcode, container, key):
		if not isinstance(key, testclause.Test):
			if isinstance(key, Specifier) and key.AEM_root() == its:
				key = key.eq(True)
			else:
				raise TypeError, 'Not a test specifier: %r' % key
		_PositionSpecifier.__init__(self, wantcode, container.AEM_trueSelf(), key)
	
	def __repr__(self):
		return '%r.byfilter(%r)' % (self._container, self._key)

	def _packKey(self, codecs):
		return codecs.pack(self._key)
	
	def AEM_resolve(self, obj):
		return self._container.AEM_resolve(obj).byfilter(self._key)


class AllElements(_MultipleElements):
	"""Form: ref.elements(code)
		A reference to all elements of container, where code is elements' class code.
	"""
	_keyForm = base.packEnum(kAE.formAbsolutePosition)
	_kAll = base.packAbsoluteOrdinal(kAE.kAEAll)
	
	def __init__(self, wantcode, container):
		# An AllElements object is a wrapper around an UnkeyedElements object; when selecting one or more of these elements, the AllElements wrapper is skipped and the UnkeyedElements object is used as the 'container' for the new specifier.
		_PositionSpecifier.__init__(self, wantcode, UnkeyedElements(wantcode, container), self._kAll)
	
	def __repr__(self):
		return repr(self._container)
	
	def _packKey(self, codecs):
		return self._kAll
	
	def AEM_trueSelf(self): # override default implementation to return the UnkeyedElements object stored inside of this AllElements instance
		return self._container
	
	def AEM_resolve(self, obj):
		return self._container.AEM_resolve(obj) # forward to UnkeyedElements


######################################################################
# MULTIPLE ELEMENT SHIM
######################################################################

class UnkeyedElements(Specifier):
	"""
		A partial elements reference, containing element code but no keyform/keydata. A shim.
		User is never exposed to this class directly. 
		
		The goal here is simple: to allow users to write 'x.elements(code)' to refer to all elements, 
		instead of the clumsier 'x.elements(code).all', as well as stuff like x.elements.first,
		x.elements.byindex(i), x.elements(code).elements(code), x.elements(code).byfilter(f).first, 
		and so on.
		
		Here's how it behaves:
		
		- Calling a reference's element() method initially returns an UnkeyedElements instance
		wrapped inside an AllElements instance, e.g. app.elements('docu'). 
		
		- Calling an element selection method on the AllElements instance, 
		e.g. app.elements('docu').byindex(1), strips away the AllElements instance to obtain the
		UnkeyedElements instance which is then used as the foundation for this new specifier.
		
		(There is one exception: ElementByRelativePosition. This keeps the AllElements reference
		intact, since it identifies a sibling of the currently specified elements.)
		
		- Calling property() and element() methods on any reference does no stripping, nor does calling
		element selection methods on other multi-item specifiers (ElementsByRange, ElementsByFilter).
		In both cases, we're stepping down a level in the object model so want the AllElements reference
		to objects at this level intact.
		
		This extra work also makes the higher-level appscript wrapper simpler to implement, since
		the behaviour here is the same as there. While one could implement separate allelements,
		firstelement, elementbyindex, elementbyrange, etc. methods in the aem layer and then do the 
		shimming in the appscript layer, this way is more consistent.
	"""
	
	def __init__(self, wantcode, container):
		self.AEM_want = wantcode
		self._container = container
	
	def __repr__(self):
		return '%r.elements(%r)' % (self._container, self.AEM_want)
	
	def AEM_packSelf(self, codecs):
		return self._container.AEM_packSelf(codecs) # forward to container specifier
	
	def AEM_resolve(self, obj):
		return self._container.AEM_resolve(obj).elements(self.AEM_want)


######################################################################
# REFERENCE ROOTS
######################################################################

###################################
# Base class

class ReferenceRoot(_PositionSpecifier):
	def __init__(self):
		pass
	
	def __repr__(self):
		return self._kName
	
	def _packSelf(self, codecs):
		return self._kType
	
	def AEM_root(self):
		return self
	
	def AEM_resolve(self, obj):
		return getattr(obj, self._kName)


###################################
# Concrete classes

class ApplicationRoot(ReferenceRoot):
	"""Form: app
		Reference base; represents an application's application object. Used to construct full references.
	"""
	_kName = 'app'
	_kType = AE.AECreateDesc(kAE.typeNull, '')


class CurrentContainer(ReferenceRoot):
	"""Form: con
		Reference base; represents elements' container object. Used to construct by-range references.
	"""
	_kName = 'con'
	_kType = AE.AECreateDesc(kAE.typeCurrentContainer, '')


class ObjectBeingExamined(ReferenceRoot):
	"""Form: its
		Reference base; represents an element to be tested. Used to construct by-filter references.
	"""
	_kName = 'its'
	_kType = AE.AECreateDesc(kAE.typeObjectBeingExamined, '')


###################################
# Reference root objects; use these constants to construct new specifiers, e.g. app.property('pnam')

app = ApplicationRoot()
con = CurrentContainer()
its = ObjectBeingExamined()


