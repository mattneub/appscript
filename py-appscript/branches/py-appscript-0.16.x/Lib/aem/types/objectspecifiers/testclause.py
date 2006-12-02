"""testclause -- Used to construct test expressions for use in by-filter references.

(C) 2005 HAS
"""

from CarbonX import kAE

import base

###################################
# Base classes

class Test(base.BASE):
	"""Base class for all comparison and logic test classes (Equals, NotEquals, AND, OR, etc.)."""

	# Logical tests.
	def AND(self, operand2, *operands):
		"""AND(test,...) --> logical AND test"""
		return AND((self, operand2) + operands)
		
	def OR(self, operand2, * operands):
		"""OR(test,...) --> logical OR test"""
		return OR((self, operand2) + operands)
	
	NOT = property(lambda self: NOT((self,)), doc="NOT --> logical NOT test")


###################################
# Comparison tests

class _ComparisonTest(Test):
	"""Subclassed by comparison test classes."""
	def __init__(self, operand1, operand2):
		self._operand1 = operand1
		self._operand2 = operand2
	
	def __eq__(self, v):
		return (self.__class__ == v.__class__) and (self._operand1 == v._operand1) and (self._operand2 == v._operand2)
	
	def __repr__(self):
		return '%r.%s(%r)' % (self._operand1, self._name, self._operand2)

	def AEM_resolve(self, obj):
		return getattr(self._operand1.AEM_resolve(obj), self._name)(self._operand2)

	def AEM_packSelf(self, codecs):
		return base.packListAs(kAE.typeCompDescriptor, [
				(kAE.keyAEObject1, codecs.pack(self._operand1)), 
				(kAE.keyAECompOperator, self._operator), 
				(kAE.keyAEObject2, codecs.pack(self._operand2))
				])

##

class GreaterThan(_ComparisonTest):
	_name = 'gt'
	_operator = base.packEnum(kAE.kAEGreaterThan)

class GreaterOrEquals(_ComparisonTest):
	_name = 'ge'
	_operator = base.packEnum(kAE.kAEGreaterThanEquals)

class Equals(_ComparisonTest):
	_name = 'eq'
	_operator = base.packEnum(kAE.kAEEquals)

class NotEquals(Equals):
	_name = 'ne'
	_operatorNOT = base.packEnum(kAE.kAENOT)
	
	def AEM_packSelf(self, codecs):
		return self._operand1.eq(self._operand2).NOT.AEM_packSelf(codecs)

class LessThan(_ComparisonTest):
	_name = 'lt'
	_operator = base.packEnum(kAE.kAELessThan)

class LessOrEquals(_ComparisonTest):
	_name = 'le'
	_operator = base.packEnum(kAE.kAELessThanEquals)

class StartsWith(_ComparisonTest):
	_name = 'startswith'
	_operator = base.packEnum(kAE.kAEBeginsWith)

class EndsWith(_ComparisonTest):
	_name = 'endswith'
	_operator = base.packEnum(kAE.kAEEndsWith)

class Contains(_ComparisonTest):
	_name = 'contains'
	_operator = base.packEnum(kAE.kAEContains)

class IsIn(Contains):
	_name = 'isin'

	def AEM_packSelf(self, codecs):
		return base.packListAs(kAE.typeCompDescriptor, [
				(kAE.keyAEObject1, codecs.pack(self._operand2)), 
				(kAE.keyAECompOperator, self._operator), 
				(kAE.keyAEObject2, codecs.pack(self._operand1))
				])


###################################
# Logical tests


class _LogicalTest(Test):
	"""Subclassed by logical test classes."""
	def __init__(self, operands):
		self._operands = operands
	
	def __eq__(self, v):
		return (self.__class__ == v.__class__) and (self._operands == v._operands)
		
	def __repr__(self):
		return '%r.%s(%s)' % (self._operands[0], self._name, repr(list(self._operands[1:]))[1:-1])
	
	def AEM_resolve(self, obj):
		return getattr(self._operands[0].AEM_resolve(obj), self._name)(*self._operands[1:])
	
	def AEM_packSelf(self, codecs):
		return base.packListAs(kAE.typeLogicalDescriptor, [
				(kAE.keyAELogicalOperator, self._operator), 
				(kAE.keyAELogicalTerms, codecs.pack(self._operands)),
				])

##

class AND(_LogicalTest):
	_operator = base.packEnum(kAE.kAEAND)
	_name = 'AND'


class OR(_LogicalTest):
	_operator = base.packEnum(kAE.kAEOR)
	_name = 'OR'


class NOT(_LogicalTest):
	_operator = base.packEnum(kAE.kAENOT)
	_name = 'NOT'
		
	def __repr__(self):
		return '%r.NOT' % self._operands[0]
	
	def AEM_resolve(self, obj):
		return self._operands[0].AEM_resolve(obj).NOT

