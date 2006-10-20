#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

module AEMReference

	require "ae"
	require "kae"
	
	######################################################################
	# SUPPORT FUNCTIONS
	######################################################################
	
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
		desc = AE::AEDesc.newList(true)
		lst.each do |key, value|
			desc.putParam(key, value)
		end
		return desc.coerce(type)
	end
	
	
	######################################################################
	# BASE CLASS
	######################################################################
	
	class Base
		
		def eql?(val)
			return self == val
		end
		
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
		attr_reader :_key, :_container
		protected :_key, :_container
	
		def initialize(container, key)
			@_container = container
			@_key = key
		end
		
		def ==(v)
			return (self.class == v.class and @_key == v._key)
		end
		
		def AEM_root
			return @_container.AEM_root
		end
		
		def AEM_trueSelf
			return self
		end
		
		def AEM_setDesc(desc)
			@_desc = desc
		end
		
		def AEM_packSelf(codecs)
			if not @_desc
				@_desc = _packSelf(codecs)
			end
			return @_desc
		end
	end
	
	
	######################################################################
	# INSERTION POINT REFERENCE FORM
	######################################################################
	
	class InsertionSpecifier < Specifier
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
		
		def ==(v)
			return (super and @AEM_want == v.AEM_want)
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
		
		def and(*operands)
			return Equals.new(self, true).and(*operands)
		end
			
		def or(*operands)
			return Equals.new(self, true).or(*operands)
		end
		
		def not
			return Equals.new(self, true).not
		end
		
		
		# Insertion references
			
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
		By = 'byname'
		KeyForm = AEMReference.packEnum(KAE::FormName)
	end
	
	
	class ElementByIndex < SingleElement
		By = 'byindex'
		KeyForm = AEMReference.packEnum(KAE::FormAbsolutePosition)
	end
	
	
	class ElementByID < SingleElement
		By = 'byid'
		KeyForm = AEMReference.packEnum(KAE::FormUniqueID)
	end
	
	##
	
	class ElementByOrdinal < SingleElement # first/middle/last/any
	
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
	
		KeyForm = AEMReference.packEnum(KAE::FormRange)
		
		def initialize(wantcode, container, key)
			key.each do |item|
				if not item.is_a?(Specifier)
					raise TypeError, "Not a container (con-based) specifier: #{item.inspect}"
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
	
		KeyForm = AEMReference.packEnum(KAE::FormTest)
		
		def initialize(wantcode, container, key)
			if not key.is_a?(Test)
				if key.is_a?(Specifier) and key.AEM_root == Its
					key = key.eq(true)
				else
					raise TypeError, "Not a test (its-based) specifier: #{key.inspect}"
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
			return @_container
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj)
		end
	end
	
	
	######################################################################
	# SHIMS
	######################################################################
	
	###################################
	# Multiple element shim
	
	class UnkeyedElements < Specifier
		attr_reader :AEM_want, :_container
		protected :AEM_want, :_container
		
		def initialize(wantcode, container)
			@AEM_want = wantcode
			@_container = container
		end
		
		def ==(v)
			return (self.class == v.class and @AEM_want == v.AEM_want and @_container == v._container)
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
		
		def ==(v)
			return (_realRef == v)
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
		
		def ==(v)
			return (self.class == v.class and @_operand1 == v._operand1 and @_operand2 == v._operand2)
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
		
		def ==(v)
			return (self.class == v.class and @_operands == v._operands)
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
		
		def ==(v)
			return self.class == v.class
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
		Name = 'app'
		Type = AE::AEDesc.new(KAE::TypeNull, '')
	end
	
	
	class CurrentContainer < ReferenceRoot
		Name = 'con'
		Type = AE::AEDesc.new(KAE::TypeCurrentContainer, '')
	end
	
	
	class ObjectBeingExamined < ReferenceRoot
		Name = 'its'
		Type = AE::AEDesc.new(KAE::TypeObjectBeingExamined, '')
	end
	
	
	###################################
	# Reference root objects; used to construct new specifiers, e.g. AEM.app.property('pnam')
	
	App = ApplicationRoot.new
	Con = CurrentContainer.new
	Its = ObjectBeingExamined.new
end

