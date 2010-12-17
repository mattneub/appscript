#
# rb-appscript
#
# aemreference -- an object-oriented API for constructing object specifier AEDescs
#

######################################################################
# Endianness support

module BigEndianPackers
	
	def pack_type(code)
		return AE::AEDesc.new(KAE::TypeType, code)
	end
	
	def pack_enum(code)
		return AE::AEDesc.new(KAE::TypeEnumeration, code)
	end
	
	def pack_absolute_ordinal(code)
		return AE::AEDesc.new(KAE::TypeAbsoluteOrdinal, code)
	end

end


module SmallEndianPackers
	
	def pack_type(code)
		return AE::AEDesc.new(KAE::TypeType, code.reverse)
	end
	
	def pack_enum(code)
		return AE::AEDesc.new(KAE::TypeEnumeration, code.reverse)
	end
	
	def pack_absolute_ordinal(code)
		return AE::AEDesc.new(KAE::TypeAbsoluteOrdinal, code.reverse)
	end

end


######################################################################

module AEMReference

	require "ae"
	require "kae"
	
	######################################################################
	# SUPPORT FUNCTIONS
	######################################################################
	
	extend([1].pack('s') == "\001\000" ? SmallEndianPackers : BigEndianPackers)
	
	def AEMReference.pack_list_as(type, lst)
		# used to pack object specifiers, etc.
		# pack key-value pairs into an AEListDesc, then coerce it to the desired type
		# (there are other AEM APIs for packing obj specs, but this way is easiest)
		desc = AE::AEDesc.new_list(true)
		lst.each { |key, value| desc.put_param(key, value) }
		return desc.coerce(type)
	end
	
	class CollectComparable
		# obtains the data needed to perform equality tests on references
		# uses AEM_resolve to walk a reference, building up a list of method call names and their arguments
		
		attr_reader :result
		
		def initialize
			@result = []
		end
		
		def send(name, *args)
			self.result.push([name] + args)
			return self
		end
	end
	
	######################################################################
	# BASE CLASS
	######################################################################
	
	class Query
	
		def initialize
			@_comparable = nil
		end
	
		def AEM_comparable
			# called by Query#==; returns the data needed to compare two aem references
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
	
	class Specifier < Query
		# Base class for insertion specifier and all object specifier classes.
		
		attr_reader :_key, :_container
		protected :_key, :_container
	
		def initialize(container, key)
			super()
			@_desc = nil
			@_container = container
			@_key = key
		end
		
		def AEM_root
			# Get reference's root node. Used by range and filter specifiers when determining type of reference
			# passed as argument(s): range specifiers require absolute (app-based) or container (con-based)
			# references; filter specifiers require an item (its-based) reference.
			return @_container.AEM_root
		end
		
		def AEM_true_self
			# Called by specifier classes when creating a reference to sub-element(s) of the current reference.
			# - An AllElements specifier (which contains 'want', 'form', 'seld' and 'from' values) will return an UnkeyedElements object (which contains 'want' and 'from' data only). The new specifier object  (ElementByIndex, ElementsByRange, etc.) wraps itself around this stub and supply its own choice of 'form' and 'seld' values.
			# - All other specifiers simply return themselves. 
			#
			#This sleight-of-hand allows foo.elements('bar ') to produce a legal reference to all elements, so users don't need to write foo.elements('bar ').all to achieve the same goal. This isn't a huge deal for aem, but makes a significant difference to the usability of user-friendly wrappers like appscript, and dealing with the mechanics of it here helps keep other layers simple.
			return self
		end
		
		def AEM_set_desc(desc)
			@_desc = desc
		end
		
		def AEM_pack_self(codecs)
			# Pack this Specifier; called by Codecs#pack, which passes itself so that specifiers in this reference can pack their selectors.
			if not @_desc
				@_desc = _pack_self(codecs) # once packed, cache this AEDesc for efficiency
			end
			return @_desc
		end
	end
	
	
	######################################################################
	# INSERTION POINT REFERENCE FORM
	######################################################################
	
	class InsertionSpecifier < Specifier
		# A reference to an element insertion point.
		
		# Syntax: all_elements_ref.beginning / all_elements_ref.end / element_ref.before / element_ref.after
		
		def initialize(container, key, keyname)
			super(container, key)
			@_keyname = keyname
		end
		
		def to_s
			return "#{@_container}.#{@_keyname}"
		end
		
		def _pack_self(codecs)
			return AEMReference.pack_list_as(KAE::TypeInsertionLoc, [
					[KAE::KeyAEObject, @_container.AEM_pack_self(codecs)],
					[KAE::KeyAEPosition, @_key],
					])
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(@_keyname)		end
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
	
		Beginning = AEMReference.pack_enum(KAE::KAEBeginning)
		End = AEMReference.pack_enum(KAE::KAEEnd)
		Before = AEMReference.pack_enum(KAE::KAEBefore)
		After = AEMReference.pack_enum(KAE::KAEAfter)
		Previous = AEMReference.pack_enum(KAE::KAEPrevious)
		Next = AEMReference.pack_enum(KAE::KAENext)
		
		attr_reader :AEM_want
	
		def initialize(wantcode, container, key)
			@AEM_want = wantcode
			super(container, key)
		end
		
		def to_s
			return "#{@_container}.#{self.class::By}(#{@_key.inspect})"
		end
		
		def _pack_self(codecs)
			return AEMReference.pack_list_as(KAE::TypeObjectSpecifier, [
					[KAE::KeyAEDesiredClass, AEMReference.pack_type(@AEM_want)],
					[KAE::KeyAEKeyForm, self.class::KeyForm],
					[KAE::KeyAEKeyData, _pack_key(codecs)],
					[KAE::KeyAEContainer, @_container.AEM_pack_self(codecs)],
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
		
		def begins_with(val)
			return BeginsWith.new(self, val)
		end
		
		def ends_with(val)
			return EndsWith.new(self, val)
		end
		
		def contains(val)
			return Contains.new(self, val)
		end
		
		def is_in(val)
			return IsIn.new(self, val)
		end
		
		# Insertion references:
		
		# Thes can be called on any kind of element reference, and also on property references where the 
		# property represents a one-to-one relationship, e.g. textedit.documents[1].text.end is valid
			
		def beginning
			return InsertionSpecifier.new(self, Beginning, :beginning)
		end
		
		def end
			return InsertionSpecifier.new(self, End, :end)
		end
		
		def before
			return InsertionSpecifier.new(self, Before, :before)
		end
		
		def after
			return InsertionSpecifier.new(self, After, :after)
		end
		
		# Property and element references can be used on any type of object reference:
		
		def property(code)
			return Property.new(KAE::CProperty, self, code)
		end
		
		def user_property(name)
			return UserProperty.new(KAE::CProperty, self, name)
		end
		
		def elements(code)
			return AllElements.new(code, self)
		end
	
		# Relative position references
		
		# these are unlikely to work on one-to-one relationships - but what the hey, putting them here
		# simplifies the class structure a bit. As with all reference forms, it's mostly left to the client to
		# ensure the references they construct can be understood by the target application.
		
		def previous(code)
			return ElementByRelativePosition.new(code, self, Previous, :previous)
		end
		
		def next(code)
			return ElementByRelativePosition.new(code, self, Next, :next)
		end
	end
	
	
	######################################################################
	# PROPERTY REFERENCE FORMS
	######################################################################
	
	class Property < PositionSpecifier
		# A reference to a user-defined property, where code is the code identifying the property.

		# Syntax: ref.property(code)
			
		By = :property
		KeyForm = AEMReference.pack_enum(KAE::FormPropertyID)
		
		def _pack_key(codecs)
			return AEMReference.pack_type(@_key)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(:property, @_key)
		end
	end
	
	
	class UserProperty < PositionSpecifier
		# A reference to a user-defined property, where name is a string representing the property's name. 
		
		# Scriptable applications shouldn't use this reference form, but OSA script applets can.
		# Note that OSA languages may have additional rules regarding case sensitivity/conversion.
	
		# Syntax: ref.user_property(name)
	
		By = :user_property
		KeyForm = AEMReference.pack_enum(KAE::FormUserPropertyID)
		
		def _pack_key(codecs)
			return codecs.pack(@_key).coerce(KAE::TypeChar)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(:user_property, @_key)
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
			super(wantcode, container.AEM_true_self, key)
		end
		
		def _pack_key(codecs)
			return codecs.pack(@_key)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(self.class::By, @_key)
		end
	end
	
	
	#######
	
	class ElementByName < SingleElement
		# A reference to a single element by its name, where name is a string.
		
		# Syntax: elements_ref.by_name(string)
		
		By = :by_name
		KeyForm = AEMReference.pack_enum(KAE::FormName)
	end
	
	
	class ElementByIndex < SingleElement
		# A reference to a single element by its index, where index is a non-zero whole number.
		
		# Syntax: elements_ref.by_index(integer)
		
		# Note that a few apps (e.g. Finder) may allow other values as well (e.g. Aliases/FSRefs)
		
		By = :by_index
		KeyForm = AEMReference.pack_enum(KAE::FormAbsolutePosition)
	end
	
	
	class ElementByID < SingleElement
		# A reference to a single element by its id.
		
		# Syntax: elements_ref.by_id(anything)
		
		By = :by_id
		KeyForm = AEMReference.pack_enum(KAE::FormUniqueID)
	end
	
	##
	
	class ElementByOrdinal < SingleElement
		# A reference to first/middle/last/any element.
		
		# Syntax: elements_ref.first / elements_ref.middle / elements_ref.last / elements_ref.any
	
		KeyForm = AEMReference.pack_enum(KAE::FormAbsolutePosition)
		
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
		# calls the container's AEM_true_self method, which breaks up 
		# AllElements specifiers - not what we want here.)
		
		KeyForm = AEMReference.pack_enum(KAE::FormRelativePosition)
		
		def initialize(wantcode, container, key, keyname)
			@_keyname = keyname
			super(wantcode, container, key)
		end
		
		def _pack_key(codecs)
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
		
		First = AEMReference.pack_absolute_ordinal(KAE::KAEFirst)
		Middle = AEMReference.pack_absolute_ordinal(KAE::KAEMiddle)
		Last = AEMReference.pack_absolute_ordinal(KAE::KAELast)
		Any = AEMReference.pack_absolute_ordinal(KAE::KAEAny)
		
		def first
			return ElementByOrdinal.new(@AEM_want, self, First, :first)
		end
		
		def middle
			return ElementByOrdinal.new(@AEM_want, self, Middle, :middle)
		end
		
		def last
			return ElementByOrdinal.new(@AEM_want, self, Last, :last)
		end
		
		def any
			return ElementByOrdinal.new(@AEM_want, self, Any, :any)
		end
		
		def by_name(name)
			return ElementByName.new(@AEM_want, self, name)
		end
		
		def by_index(index)
			return ElementByIndex.new(@AEM_want, self, index)
		end
		
		def by_id(id)
			return ElementByID.new(@AEM_want, self, id)
		end
		
		def by_range(start, stop)
			return ElementsByRange.new(@AEM_want, self, [start, stop])
		end
		
		def by_filter(test)
			return ElementsByFilter.new(@AEM_want, self, test)
		end
	end
	
	
	#######
	
	class ElementsByRange < MultipleElements
		# A reference to a range of elements
		
		# Syntax: elements_ref.by_range(start, stop)
		
		# The start and stop args are con-based relative references to the first and last elements in range.
		# Note that absolute (app-based) references are also acceptable.
	
		KeyForm = AEMReference.pack_enum(KAE::FormRange)
		
		def initialize(wantcode, container, key)
			super(wantcode, container.AEM_true_self, key)
		end
		
		def to_s
			return "#{@_container}.by_range(#{@_key[0].inspect}, #{@_key[1].inspect})"
		end
	
		def _pack_key(codecs)
			range_selectors = [
					[KAE::KeyAERangeStart, @_key[0]], 
					[KAE::KeyAERangeStop, @_key[1]]
			].collect do |key, selector|
				case selector
					when Specifier
						# use selector as-is (note: its-based roots aren't appropriate, but this isn't checked for)
					when String
						selector = AEMReference::Con.elements(@AEM_want).by_name(selector)
				else
					selector = AEMReference::Con.elements(@AEM_want).by_index(selector)
				end
				[key, codecs.pack(selector)]
			end
			return AEMReference.pack_list_as(KAE::TypeRangeDescriptor, range_selectors)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(:by_range, *@_key)
		end
	end
	
	
	class ElementsByFilter < MultipleElements
		# A reference to all elements that match a condition
		
		# Syntax: elements_ref.by_filter(test)
		
		# The test argument is a Test object constructed from an its-based reference.
	
		KeyForm = AEMReference.pack_enum(KAE::FormTest)
		
		def initialize(wantcode, container, key)
			if not key.is_a?(Test)
				raise TypeError, "Bad selector: not a test (its) based specifier: #{key.inspect}"
			end
			super(wantcode, container.AEM_true_self, key)
		end
		
		def to_s
			return "#{@_container}.by_filter(#{@_key.inspect})"
		end
	
		def _pack_key(codecs)
			return codecs.pack(@_key)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(:by_filter, @_key)
		end
	end
	
	
	class AllElements < MultipleElements
		# A reference to all elements of the container reference.
		
		# Syntax: ref.elements(code)
		
		# The 'code' argument is the four-character class code of the desired elements (e.g. 'docu').
				
		# Note that an AllElements object is a wrapper around an UnkeyedElements object. 
		# When sub-selecting these elements, e.g. ref.elements('docu').by_index(1), the AllElements
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
		# AEM.app.elements('docu').by_index(1) # document 1 of application
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
	
		KeyForm = AEMReference.pack_enum(KAE::FormAbsolutePosition)
		All = AEMReference.pack_absolute_ordinal(KAE::KAEAll)
		
		def initialize(wantcode, container)
			super(wantcode, UnkeyedElements.new(wantcode, container), All)
		end
		
		def to_s
			return @_container.to_s
		end
		
		def _pack_key(codecs)
			return All
		end
		
		def AEM_true_self
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
		
		def AEM_pack_self(codecs)
			return @_container.AEM_pack_self(codecs)
		end
		
		def AEM_resolve(obj)
			return @_container.AEM_resolve(obj).send(:elements, @AEM_want)
		end
	end
	
	
	###################################
	# Unresolved reference
	
	class DeferredSpecifier < Query
		def initialize(desc, codecs)
			@_ref = nil
			@_desc = desc
			@_codecs   = codecs
		end
		
		def _real_ref
			if not @_ref
				@_ref = @_codecs.fully_unpack_object_specifier(@_desc)
			end
			return @_ref
		end
		
		def AEM_true_self
			return self
		end
		
		def to_s
			return _real_ref.to_s
		end
		
		def AEM_root
			return _real_ref.AEM_root
		end
		
		def AEM_resolve(obj)
			return _real_ref.AEM_resolve(obj)
		end
	end
	
	
	######################################################################
	# TEST CLAUSES
	######################################################################
	
	###################################
	# Base class
	
	class Test < Query
	
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
			super()
			@_operand1 = operand1
			@_operand2 = operand2
		end
		
		def to_s
			return "#{@_operand1.inspect}.#{self.class::Name}(#{@_operand2.inspect})"
		end
	
		def AEM_resolve(obj)
			return @_operand1.AEM_resolve(obj).send(self.class::Name, @_operand2)
		end
	
		def AEM_pack_self(codecs)
			return AEMReference.pack_list_as(KAE::TypeCompDescriptor, [
					[KAE::KeyAEObject1, codecs.pack(@_operand1)], 
					[KAE::KeyAECompOperator, self.class::Operator],
					[KAE::KeyAEObject2, codecs.pack(@_operand2)]
					])
		end
	end
	
	##
	
	
	
	class GreaterThan < ComparisonTest
		Name = :gt
		Operator = AEMReference.pack_enum(KAE::KAEGreaterThan)
	end
	
	class GreaterOrEquals < ComparisonTest
		Name = :ge
		Operator = AEMReference.pack_enum(KAE::KAEGreaterThanEquals)
	end
	
	class Equals < ComparisonTest
		Name = :eq
		Operator = AEMReference.pack_enum(KAE::KAEEquals)
	end
	
	class NotEquals < Equals
		Name = :ne
		OperatorNOT = AEMReference.pack_enum(KAE::KAENOT)
		
		def AEM_pack_self(codecs)
			return @_operand1.eq(@_operand2).not.AEM_pack_self(codecs)
		end
	end
	
	class LessThan < ComparisonTest
		Name = :lt
		Operator = AEMReference.pack_enum(KAE::KAELessThan)
	end
	
	class LessOrEquals < ComparisonTest
		Name = :le
		Operator = AEMReference.pack_enum(KAE::KAELessThanEquals)
	end
	
	class BeginsWith < ComparisonTest
		Name = :begins_with
		Operator = AEMReference.pack_enum(KAE::KAEBeginsWith)
	end
	
	class EndsWith < ComparisonTest
		Name = :ends_with
		Operator = AEMReference.pack_enum(KAE::KAEEndsWith)
	end
	
	class Contains < ComparisonTest
		Name = :contains
		Operator = AEMReference.pack_enum(KAE::KAEContains)
	end
	
	class IsIn < Contains
		Name = :is_in
	
		def AEM_pack_self(codecs)
			return AEMReference.pack_list_as(KAE::TypeCompDescriptor, [
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
			super()
			@_operands = operands
		end
			
		def to_s
			op_str = (@_operands[1, @_operands.length].collect { |o| o.inspect }).join(', ')
			return "#{@_operands[0].inspect}.#{self.class::Name}(#{op_str})"
		end
		
		def AEM_resolve(obj)
			return @_operands[0].AEM_resolve(obj).send(self.class::Name, *@_operands[1, @_operands.length])
		end
		
		def AEM_pack_self(codecs)
			return AEMReference.pack_list_as(KAE::TypeLogicalDescriptor, [
					[KAE::KeyAELogicalOperator, self.class::Operator],
					[KAE::KeyAELogicalTerms, codecs.pack(@_operands)]
					])
		end
	end
	
	##
	
	class AND < LogicalTest
		Operator = AEMReference.pack_enum(KAE::KAEAND)
		Name = :and
	end
	
	class OR < LogicalTest
		Operator = AEMReference.pack_enum(KAE::KAEOR)
		Name = :or
	end
	
	class NOT < LogicalTest
		Operator = AEMReference.pack_enum(KAE::KAENOT)
		Name = :not
			
		def to_s
			return "#{@_operands[0].inspect}.not"
		end
		
		def AEM_resolve(obj)
			return @_operands[0].AEM_resolve(obj).send(:not)
		end
	end
	
	
	######################################################################
	# REFERENCE ROOTS
	######################################################################
	
	###################################
	# Base class
	
	class ReferenceRoot < PositionSpecifier
	
		def initialize
			super(nil, nil, nil)
		end
		
		def to_s
			return "AEM.#{self.class::Name}"
		end
		
		def _pack_self(codecs)
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
		
		# Syntax: AEM.app
		
		Name = :app
		Type = AE::AEDesc.new(KAE::TypeNull, '')
	end
	
	
	class CurrentContainer < ReferenceRoot
		# Reference base; represents elements' container object. Used to construct by-range references.
		
		# Syntax: AEM.con
		
		Name = :con
		Type = AE::AEDesc.new(KAE::TypeCurrentContainer, '')
	end
	
	
	class ObjectBeingExamined < ReferenceRoot
		# Reference base; represents an element to be tested. Used to construct by-filter references.
		
		# Syntax: AEM.its
		
		Name = :its
		Type = AE::AEDesc.new(KAE::TypeObjectBeingExamined, '')
	end
	
	
	class CustomRoot < ReferenceRoot
		# Reference base; represents an arbitrary root object, e.g. an AEAddressDesc in a fully qualified reference
		
		# Syntax: AEM.custom_root(value)
		
		def initialize(value)
			@value = value
			super()
		end
		
		def to_s
			return "AEM.custom_root(#{@value.inspect})"
		end
		
		def _pack_self(codecs)
			return codecs.pack(@value)
		end
		
		def AEM_resolve(obj)
			return obj.send(:custom_root, @value)
		end
	end
	
	
	###################################
	# Reference root objects; used to construct new specifiers, e.g. AEM.app.property('pnam')
	
	App = ApplicationRoot.new
	Con = CurrentContainer.new
	Its = ObjectBeingExamined.new
end

