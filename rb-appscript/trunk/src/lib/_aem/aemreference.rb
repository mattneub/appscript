#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module AEMReference

	require "ae"
	require "kae"
	
	######################################################################
	# SUPPORT FUNCTIONS
	######################################################################
	
	# TO DO: optimise type packers a-la codecs.rb
	
	def AEMReference.packType(code)
		return AE::AEDesc.new(KAE::TypeType, code.unpack('N').pack('L'))
	end
	
	def AEMReference.packEnum(code)
		return AE::AEDesc.new(KAE::TypeEnumeration, code.unpack('N').pack('L'))
	end
	
	def AEMReference.packAbsoluteOrdinal(code)
		return AE::AEDesc.new(KAE::TypeAbsoluteOrdinal, code.unpack('N').pack('L'))
	end
	
	def AEMReference.packListAs(type, lst)
		# used to pack object specifiers, etc.
		# pack key-value pairs into an AEListDesc, then coerce it to the desired type
		# (there are other AEM APIs for packing obj specs, but this way is easiest)
		desc = AE::AEDesc.newList(true)
		lst.each { |key, value| desc.putParam(key, value) }
		return desc.coerce(type)
	end
	
	class CollectComparable
		# obtains the data needed to perform equality tests on references
		# uses AEM_resolve to walk a reference, building up a list of method call names and their arguments
		
		attr_reader :result
		
		def initialize
			@result = []
		end
		
		def method_missing(name, *args)
			self.result.push([name] + args)
			return self
		end
	end
	
	######################################################################
	# BASE CLASS
	######################################################################
	
	class Base
	
		def AEM_comparable
			# called by Base#==; returns the data needed to compare two aem references
			if not @_comparable
				collector = AEMReference::CollectComparable.new
				AEM_resolve(collector)
				@_comparable = collector.result
			end
			return @_comparable
		end
		
		def ==(val)
			return (self.equal?(val) or (
					self.class == val.class and 
					self.AEM_comparable == val.AEM_comparable))
		end
		
		alias_method :eql?, :==
		
		def hash
			return to_s.hash
		end
		
		def inspect
			return to_s
		end
	end
	
		
	######################################################################
	# BASE CLASS FOR ALL REFERENCE FORMS
	######################################################################
	
	class Specifier < Base
		# Base class for insertion specifier and all object specifier classes.
		
		attr_reader :_key, :_container
		protected :_key, :_container
	
		def initialize(container, key)
			@_container = container
			@_key = key
		end
		
		def AEM_root
			# Get reference's root node. Used by range and filter specifiers when determining type of reference
			# passed as argument(s): range specifiers require absolute (app-based) or container (con-based)
			# references; filter specifiers require an item (its-based) reference.
			return @_container.AEM_root
		end
		
		def AEM_trueSelf
			# Called by specifier classes when creating a reference to sub-element(s) of the current reference.
			# - An AllElements specifier (which contains 'want', 'form', 'seld' and 'from' values) will return an UnkeyedElements object (which contains 'want' and 'from' data only). The new specifier object  (ElementByIndex, ElementsByRange, etc.) wraps itself around this stub and supply its own choice of 'form' and 'seld' values.
			# - All other specifiers simply return themselves. 
			#
			#This sleight-of-hand allows foo.elements('bar ') to produce a legal reference to all elements, so users don't need to write foo.elements('bar ').all to achieve the same goal. This isn't a huge deal for aem, but makes a significant difference to the usability of user-friendly wrappers like appscript, and dealing with the mechanics of it here helps keep other layers simple.
			return self
		end
		
		def AEM_setDesc(desc)
			@_desc = desc
		end
		
		def AEM_packSelf(codecs)
			# Pack this Specifier; called by Codecs#pack, which passes itself so that specifiers in this reference can pack their selectors.
			if not @_desc
				@_desc = _packSelf(codecs) # once packed, cache this AEDesc for efficiency
			end
			return @_desc
		end
	end
	
	
	######################################################################
	# INSERTION POINT REFERENCE FORM
	######################################################################
	
	class InsertionSpecifier < Specifier
		# A reference to an element insertion point.
		
		# Syntax: all_elements_ref.start / all_elements_ref.end / element_ref.before / element_ref.after
		
		def initialize(container, key, keyname)
			super(container, key)
			@_keyname = keyname
		end
		
		def to_s
			return "#{@_container}.#{@_keyname}"
		end
		
		def _packSelf(codecs)
			return AEMReference.packListAs(KAE::TypeInsertionLoc, [
					[KAE::KeyAEObject, @_container.AEM_packSelf(codecs)],
					[KAE::KeyAEPosition, @_key],
					])
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(@_keyname)
		end
	end
	
	
	######################################################################
	# BASE CLASS FOR ALL OBJECT REFERENCE FORMS
	######################################################################
	
	class PositionSpecifier < Specifier
		# All property and element reference forms inherit from this class. It provides most
		# of the reference building methods; the rest are supplied by MultipleElements to
		# those reference forms for which they're valid.
	
		# Note that comparison and logic 'operator' methods are implemented on this class
		# - these are only for use in constructing its-based references and shouldn't be used 
		# on app- and con-based references. Aem doesn't enforce this rule itself so as to 
		# minimise runtime overhead (the target application will raise an error if the user 
		# does something foolish).
	
		Beginning = AEMReference.packEnum(KAE::KAEBeginning)
		End = AEMReference.packEnum(KAE::KAEEnd)
		Before = AEMReference.packEnum(KAE::KAEBefore)
		After = AEMReference.packEnum(KAE::KAEAfter)
		Previous = AEMReference.packEnum(KAE::KAEPrevious)
		Next = AEMReference.packEnum(KAE::KAENext)
		
		attr_reader :AEM_want
	
		def initialize(wantcode, container, key)
			@AEM_want = wantcode
			super(container, key)
		end
		
		def to_s
			return "#{@_container}.#{self.class::By}(#{@_key.inspect})"
		end
		
		def _packSelf(codecs)
			return AEMReference.packListAs(KAE::TypeObjectSpecifier, [
					[KAE::KeyAEDesiredClass, AEMReference.packType(@AEM_want)],
					[KAE::KeyAEKeyForm, self.class::KeyForm],
					[KAE::KeyAEKeyData, _packKey(codecs)],
					[KAE::KeyAEContainer, @_container.AEM_packSelf(codecs)],
					])
		end
		
		# Comparison tests; these should only be used on its-based references:
		
		# Each of these methods returns a ComparisonTest subclass
		
		def gt(val)
			return GreaterThan.new(self, val)
		end
			
		def ge(val)
			return GreaterOrEquals.new(self, val)
		end
		
		def eq(val)
			return Equals.new(self, val)
		end
		
		def ne(val)
			return NotEquals.new(self, val)
		end
		
		def lt(val)
			return LessThan.new(self, val)
		end
		
		def le(val)
			return LessOrEquals.new(self, val)
		end
		
		def startswith(val)
			return StartsWith.new(self, val)
		end
		
		def endswith(val)
			return EndsWith.new(self, val)
		end
		
		def contains(val)
			return Contains.new(self, val)
		end
		
		def isin(val)
			return IsIn.new(self, val)
		end
	
		# Logic tests; these should only be used on its-based references:
		
		# Note: these are convenience methods allowing boolean tests to be written in shorthand form;
		# e.g. AEM.its.visible.and(...) will automatically expand to AEM.its.visible.eq(true).and(...)
		# The Test class implements the actual logic test methods
		
		def and(*operands)
			return Equals.new(self, true).and(*operands)
		end
			
		def or(*operands)
			return Equals.new(self, true).or(*operands)
		end
		
		def not
			return Equals.new(self, true).not
		end
		
		
		# Insertion references:
		
		# Thes can be called on any kind of element reference, and also on property references where the 
		# property represents a one-to-one relationship, e.g. textedit.documents[1].text.end is valid
			
		def start
			return InsertionSpecifier.new(self, Beginning, 'start')
		end
		
		def end
			return InsertionSpecifier.new(self, End, 'end')
		end
		
		def before
			return InsertionSpecifier.new(self, Before, 'before')
		end
		
		def after
			return InsertionSpecifier.new(self, After, 'after')
		end
		
		# Property and element references can be used on any type of object reference:
		
		def property(propertycode)
			return Property.new(KAE::CProperty, self, propertycode)
		end
		
		def userproperty(name)
			return UserProperty.new(KAE::CProperty, self, name)
		end
		
		def elements(elementcode)
			return AllElements.new(elementcode, self)
		end
	
		# Relative position references
		
		# these are unlikely to work on one-to-one relationships - but what the hey, putting them here
		# simplifies the class structure a bit. As with all reference forms, it's mostly left to the client to
		# ensure the references they construct can be understood by the target application.
		
		def previous(elementcode)
			return ElementByRelativePosition.new(elementcode, self, Previous, 'previous')
		end
		
		def next(elementcode)
			return ElementByRelativePosition.new(elementcode, self, Next, 'next')
		end
	end
	
	
	######################################################################
	# PROPERTY REFERENCE FORMS
	######################################################################
	
	class Property < PositionSpecifier
		# A reference to a user-defined property, where code is the code identifying the property.

		# Syntax: ref.property(code)
			
		By = 'property'
		KeyForm = AEMReference.packEnum(KAE::FormPropertyID)
		
		def _packKey(codecs)
			return AEMReference.packType(@_key)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).property(@_key)
		end
	end
	
	
	class UserProperty < PositionSpecifier
		# A reference to a user-defined property, where name is a string representing the property's name. 
		
		# Scriptable applications shouldn't use this reference form, but OSA script applets can.
		# Note that OSA languages may have additional rules regarding case sensitivity/conversion.
	
		# Syntax: ref.userproperty(name)
	
		By = 'userproperty'
		KeyForm = AEMReference.packEnum('usrp')
		
		def _packKey(codecs)
			return codecs.pack(@_key).coerceDesc(KAE::TypeChar)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).userproperty(@_key)
		end
	end
	
	
	######################################################################
	# ELEMENT REFERENCE FORMS
	######################################################################
	
	###################################
	# Single elements
	
	class SingleElement < PositionSpecifier
		# Base class for all single element specifiers.
		
		def initialize(wantcode, container, key)
			super(wantcode, container.AEM_trueSelf, key)
		end
		
		def _packKey(codecs)
			return codecs.pack(@_key)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(self.class::By, @_key)
		end
	end
	
	
	#######
	
	class ElementByName < SingleElement
		# A reference to a single element by its name, where name is a string.
		
		# Syntax: elements_ref..byname(string)
		
		By = 'byname'
		KeyForm = AEMReference.packEnum(KAE::FormName)
	end
	
	
	class ElementByIndex < SingleElement
		# A reference to a single element by its index, where index is a non-zero whole number.
		
		# Syntax: elements_ref.byindex(integer)
		
		# Note that a few apps (e.g. Finder) may allow other values as well (e.g. Aliases/FSRefs)
		
		By = 'byindex'
		KeyForm = AEMReference.packEnum(KAE::FormAbsolutePosition)
	end
	
	
	class ElementByID < SingleElement
		# A reference to a single element by its id.
		
		# Syntax: elements_ref.byid(anything)
		
		By = 'byid'
		KeyForm = AEMReference.packEnum(KAE::FormUniqueID)
	end
	
	##
	
	class ElementByOrdinal < SingleElement
		# A reference to first/middle/last/any element.
		
		# Syntax: elements_ref.first / elements_ref.middle / elements_ref.last / elements_ref.any
	
		KeyForm = AEMReference.packEnum(KAE::FormAbsolutePosition)
		
		def initialize(wantcode, container, key, keyname)
			@_keyname = keyname
			super(wantcode, container, key)
		end
		
		def to_s
			return "#{@_container}.#{@_keyname}"
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(@_keyname)
		end
	end
	
	
	class ElementByRelativePosition < PositionSpecifier
		# A relative reference to previous/next element, where code
		# is the class code of element to get (e.g. 'docu').
		
		# Syntax: elements_ref.previous(code) / elements_ref.next(code)
		
		# Note: this class subclasses PositionSpecifier, not SingleElement,
		# as it needs the container reference intact. (SingleElement#initialize
		# calls the container's AEM_trueSelf method, which breaks up 
		# AllElements specifiers - not what we want here.)
		
		KeyForm = AEMReference.packEnum(KAE::FormRelativePosition)
		
		def initialize(wantcode, container, key, keyname)
			@_keyname = keyname
			super(wantcode, container, key)
		end
		
		def _packKey(codecs)
			return codecs.pack(@_key)
		end
		
		def to_s
			return "#{@_container}.#{@_keyname}(#{@AEM_want.inspect})"
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(@_keyname, @AEM_want)
		end
	end
	
	
	###################################
	# Multiple elements
	
	class MultipleElements < PositionSpecifier
		# Base class for all multiple element specifiers.
		
		First = AEMReference.packAbsoluteOrdinal(KAE::KAEFirst)
		Middle = AEMReference.packAbsoluteOrdinal(KAE::KAEMiddle)
		Last = AEMReference.packAbsoluteOrdinal(KAE::KAELast)
		Any = AEMReference.packAbsoluteOrdinal(KAE::KAEAny)
		
		def first
			return ElementByOrdinal.new(@AEM_want, self, First, 'first')
		end
		
		def middle
			return ElementByOrdinal.new(@AEM_want, self, Middle, 'middle')
		end
		
		def last
			return ElementByOrdinal.new(@AEM_want, self, Last, 'last')
		end
		
		def any
			return ElementByOrdinal.new(@AEM_want, self, Any, 'any')
		end
		
		def byname(name)
			return ElementByName.new(@AEM_want, self, name)
		end
		
		def byindex(index)
			return ElementByIndex.new(@AEM_want, self, index)
		end
		
		def byid(id)
			return ElementByID.new(@AEM_want, self, id)
		end
		
		def byrange(start, stop)
			return ElementsByRange.new(@AEM_want, self, [start, stop])
		end
		
		def byfilter(expression)
			return ElementsByFilter.new(@AEM_want, self, expression)
		end
	end
	
	
	#######
	
	class ElementsByRange < MultipleElements
		# A reference to a range of elements
		
		# Syntax: elements_ref.byrange(start, stop)
		
		# The start and stop args are con-based relative references to the first and last elements in range.
		# Note that absolute (app-based) references are also acceptable.
	
		KeyForm = AEMReference.packEnum(KAE::FormRange)
		
		def initialize(wantcode, container, key)
			key.each do |item|
				if not (item.is_a?(Specifier) and item.AEM_root != Its)
					raise TypeError, "Bad selector: not an application (app) or container (con) based reference: #{item.inspect}"
				end
			end
			super(wantcode, container.AEM_trueSelf, key)
		end
		
		def to_s
			return "#{@_container}.byrange(#{@_key[0].inspect}, #{@_key[1].inspect})"
		end
	
		def _packKey(codecs)
			return AEMReference.packListAs(KAE::TypeRangeDescriptor, [
					[KAE::KeyAERangeStart, codecs.pack(@_key[0])], 
					[KAE::KeyAERangeStop, codecs.pack(@_key[1])]
					])
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).byrange(*@_key)
		end
	end
	
	
	class ElementsByFilter < MultipleElements
		# A reference to all elements that match a condition
		
		# Syntax: elements_ref.byfilter(test)
		
		# The test argument is a Test object constructed from an its-based reference.
		# For convenience, an its-based reference can also be passed directly - this will
		# be expanded to a Boolean equality test, e.g. AEM.its.visible -> AEM.its.visible.eq(true)
	
		KeyForm = AEMReference.packEnum(KAE::FormTest)
		
		def initialize(wantcode, container, key)
			if not key.is_a?(Test)
				if key.is_a?(Specifier) and key.AEM_root == Its
					key = key.eq(true)
				else
					raise TypeError, "Bad selector: not a test (its) based specifier: #{key.inspect}"
				end
			end
			super(wantcode, container.AEM_trueSelf, key)
		end
		
		def to_s
			return "#{@_container}.byfilter(#{@_key.inspect})"
		end
	
		def _packKey(codecs)
			return codecs.pack(@_key)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).byfilter(@_key)
		end
	end
	
	
	class AllElements < MultipleElements
		# A reference to all elements of the container reference.
		
		# Syntax: ref.elements(code)
		
		# The 'code' argument is the four-character class code of the desired elements (e.g. 'docu').
				
		# Note that an AllElements object is a wrapper around an UnkeyedElements object. 
		# When sub-selecting these elements, e.g. ref.elements('docu').byindex(1), the AllElements
		# wrapper is ignored and the UnkeyedElements object is used as the basis for the
		# new specifier. e.g. 
		#
		# AEM.app.elements('docu') # every document of application
		#
		# produces the following chain:
		#
		# ApplicationRoot -> UnkeyedElements -> AllElements
		#
		# Subselecting these elements, e.g. 
		#
		# AEM.app.elements('docu').byindex(1) # document 1 of application
		#
		# produces the following chain:
		#
		# ApplicationRoot -> UnkeyedElements -> ElementByIndex
		#
		# As you can see, the previous UnkeyedElements object is retained, but the AllElements
		# object isn't.
		#
		# The result of all this is that users can legally write a reference to all elements as (e.g.):
		#
		# AEM.app.elements('docu')
		# AS.app.documents
		# 
		# instead of:
		#
		# AEM.app.elements('docu').all
		# AS.app.documents.all
		#
		# Compare with some other bridges (e.g. Frontier), where (e.g.) 'ref.documents' is not
		# a legitimate reference in itself, and users must remember to add '.all' in order to specify
		# all elements, or else it won't work correctly. This maps directly onto the underlying AEM
		# API, which is easy to implement but isn't so good for usability. Whereas aem trades
		# a bit of increased internal complexity for a simpler, more intuitive and foolproof external API.
	
		KeyForm = AEMReference.packEnum(KAE::FormAbsolutePosition)
		All = AEMReference.packAbsoluteOrdinal(KAE::KAEAll)
		
		def initialize(wantcode, container)
			super(wantcode, UnkeyedElements.new(wantcode, container), All)
		end
		
		def to_s
			return @_container.to_s
		end
		
		def _packKey(codecs)
			return All
		end
		
		def AEM_trueSelf
			 # override default implementation to return the UnkeyedElements object stored inside of this AllElements instance
			return @_container
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj) # forward to UnkeyedElements
		end
	end
	
	
	######################################################################
	# SHIMS
	######################################################################
	
	###################################
	# Multiple element shim
	
	class UnkeyedElements < Specifier
		# A partial elements reference, containing element code but no keyform/keydata. A shim.
		# User is never exposed to this class directly. See comments in AllElements class.
		
		attr_reader :AEM_want, :_container
		protected :AEM_want, :_container
		
		def initialize(wantcode, container)
			@AEM_want = wantcode
			@_container = container
		end
		
		def to_s
			return "#{@_container}.elements(#{@AEM_want.inspect})"
		end
		
		def AEM_packSelf(codecs)
			return @_container.AEM_packSelf(codecs)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).elements(@AEM_want)
		end
	end
	
	
	###################################
	# Unresolved reference
	
	class DeferredSpecifier < Base
		def initialize(desc, codecs)
			@_desc = desc
			@_codecs   = codecs
		end
		
		def _realRef
			if not @_ref
				@_ref = @_codecs.fullyUnpackObjectSpecifier(@_desc)
			end
			return @_ref
		end
		
		def AEM_trueSelf
			return self
		end
		
		def to_s
			return _realRef.to_s
		end
		
		def AEM_root
			return _realRef.AEM_root
		end
		
		def AEM_resolve(obj)
			return _realRef.AEM_resolve(obj)
		end
	end
	
	
	######################################################################
	# TEST CLAUSES
	######################################################################
	
	###################################
	# Base class
	
	class Test < Base
	
		# Logical tests
		
		def and(operand2, *operands)
			return AND.new([self, operand2] + operands)
		end
			
		def or(operand2, * operands)
			return OR.new([self, operand2] + operands)
		end
		
		def not
			return NOT.new([self])
		end
	end
	
	
	###################################
	# Comparison tests
	
	class ComparisonTest < Test
		attr_reader :_operand1, :_operand2
		protected :_operand1, :_operand2
	
		def initialize(operand1, operand2)
			@_operand1 = operand1
			@_operand2 = operand2
		end
		
		def to_s
			return "#{@_operand1.inspect}.#{self.class::Name}(#{@_operand2.inspect})"
		end
	
		def AEM_resolve(obj)
			return @_operand1.AEM_resolve(obj).send(self.class::Name, @_operand2)
		end
	
		def AEM_packSelf(codecs)
			return AEMReference.packListAs(KAE::TypeCompDescriptor, [
					[KAE::KeyAEObject1, codecs.pack(@_operand1)], 
					[KAE::KeyAECompOperator, self.class::Operator],
					[KAE::KeyAEObject2, codecs.pack(@_operand2)]
					])
		end
	end
	
	##
	
	
	
	class GreaterThan < ComparisonTest
		Name = 'gt'
		Operator = AEMReference.packEnum(KAE::KAEGreaterThan)
	end
	
	class GreaterOrEquals < ComparisonTest
		Name = 'ge'
		Operator = AEMReference.packEnum(KAE::KAEGreaterThanEquals)
	end
	
	class Equals < ComparisonTest
		Name = 'eq'
		Operator = AEMReference.packEnum(KAE::KAEEquals)
	end
	
	class NotEquals < Equals
		Name = 'ne'
		OperatorNOT = AEMReference.packEnum(KAE::KAENOT)
		
		def AEM_packSelf(codecs)
			return @_operand1.eq(@_operand2).not.AEM_packSelf(codecs)
		end
	end
	
	class LessThan < ComparisonTest
		Name = 'lt'
		Operator = AEMReference.packEnum(KAE::KAELessThan)
	end
	
	class LessOrEquals < ComparisonTest
		Name = 'le'
		Operator = AEMReference.packEnum(KAE::KAELessThanEquals)
	end
	
	class StartsWith < ComparisonTest
		Name = 'startswith'
		Operator = AEMReference.packEnum(KAE::KAEBeginsWith)
	end
	
	class EndsWith < ComparisonTest
		Name = 'endswith'
		Operator = AEMReference.packEnum(KAE::KAEEndsWith)
	end
	
	class Contains < ComparisonTest
		Name = 'contains'
		Operator = AEMReference.packEnum(KAE::KAEContains)
	end
	
	class IsIn < Contains
		Name = 'isin'
	
		def AEM_packSelf(codecs)
			return AEMReference.packListAs(KAE::TypeCompDescriptor, [
					[KAE::KeyAEObject1, codecs.pack(@_operand2)],
					[KAE::KeyAECompOperator, self.class::Operator],
					[KAE::KeyAEObject2, codecs.pack(@_operand1)]
					])
		end
	end
	
	###################################
	# Logical tests
	
	class LogicalTest < Test
		attr_reader :_operands
		protected :_operands
	
		def initialize(operands)
			@_operands = operands
		end
			
		def to_s
			opStr = (@_operands[1, @_operands.length].collect { |o| o.inspect }).join(', ')
			return "#{@_operands[0].inspect}.#{self.class::Name}(#{opStr})"
		end
		
		def AEM_resolve(obj)
			return @_operands[0].AEM_resolve(obj).send(self.class::Name, *@_operands[1, @_operands.length])
		end
		
		def AEM_packSelf(codecs)
			return AEMReference.packListAs(KAE::TypeLogicalDescriptor, [
					[KAE::KeyAELogicalOperator, self.class::Operator],
					[KAE::KeyAELogicalTerms, codecs.pack(@_operands)]
					])
		end
	end
	
	##
	
	class AND < LogicalTest
		Operator = AEMReference.packEnum(KAE::KAEAND)
		Name = 'and'
	end
	
	class OR < LogicalTest
		Operator = AEMReference.packEnum(KAE::KAEOR)
		Name = 'or'
	end
	
	class NOT < LogicalTest
		Operator = AEMReference.packEnum(KAE::KAENOT)
		Name = 'not'
			
		def to_s
			return "#{@_operands[0].inspect}.not"
		end
		
		def AEM_resolve(obj)
			return @_operands[0].AEM_resolve(obj).not
		end
	end
	
	
	######################################################################
	# REFERENCE ROOTS
	######################################################################
	
	###################################
	# Base class
	
	class ReferenceRoot < PositionSpecifier
	
		def initialize
		end
		
		def to_s
			return "AEM.#{self.class::Name}"
		end
		
		def _packSelf(codecs)
			return self.class::Type
		end
		
		def AEM_root
			return self
		end
		
		def AEM_resolve(obj)
			return obj.send(self.class::Name)
		end
	end
	
	
	###################################
	# Concrete classes
	
	class ApplicationRoot < ReferenceRoot
		# Reference base; represents an application's application object. Used to construct full references.
		
		# Syntax: app
		
		Name = 'app'
		Type = AE::AEDesc.new(KAE::TypeNull, '')
	end
	
	
	class CurrentContainer < ReferenceRoot
		# Reference base; represents elements' container object. Used to construct by-range references.
		
		# Syntax: con
		
		Name = 'con'
		Type = AE::AEDesc.new(KAE::TypeCurrentContainer, '')
	end
	
	
	class ObjectBeingExamined < ReferenceRoot
		# Reference base; represents an element to be tested. Used to construct by-filter references.
		
		# Syntax: its
		
		Name = 'its'
		Type = AE::AEDesc.new(KAE::TypeObjectBeingExamined, '')
	end
	
	
	###################################
	# Reference root objects; used to construct new specifiers, e.g. AEM.app.property('pnam')
	
	App = ApplicationRoot.new
	Con = CurrentContainer.new
	Its = ObjectBeingExamined.new
end

