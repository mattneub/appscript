//
//  test.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "test.h"


/**********************************************************************/
// initialise constants


#define ENUMERATOR(name) \
		descData = kAE##name; \
		kEnum##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeEnumerated \
														 bytes:&descData \
														length:sizeof(descData)];


// comparison tests
static NSAppleEventDescriptor *kEnumGreaterThan,
							  *kEnumGreaterThanEquals,
							  *kEnumEquals,
							  *kEnumLessThan,
							  *kEnumLessThanEquals,
							  *kEnumBeginsWith,
							  *kEnumEndsWith,
							  *kEnumContains;

// logical tests
static NSAppleEventDescriptor *kEnumAND,
							  *kEnumOR,
							  *kEnumNOT;


// blank record used by -packWithCodecs: to construct test descriptors
static NSAppleEventDescriptor *kEmptyRecord;


void initTestModule(void) { // called automatically
	// comparison tests
	OSType descData;
	
	ENUMERATOR(GreaterThan);
	ENUMERATOR(GreaterThanEquals);
	ENUMERATOR(Equals);
	ENUMERATOR(LessThan);
	ENUMERATOR(LessThanEquals);
	ENUMERATOR(BeginsWith);
	ENUMERATOR(EndsWith);
	ENUMERATOR(Contains);
	// logical tests
	ENUMERATOR(AND);
	ENUMERATOR(OR);
	ENUMERATOR(NOT);
	// miscellaneous
	kEmptyRecord = [[NSAppleEventDescriptor alloc] initRecordDescriptor];
}

void disposeTestModule(void) {
	// comparison tests
	[kEnumGreaterThan release];
	[kEnumGreaterThanEquals release];
	[kEnumEquals release];
	[kEnumLessThan release];
	[kEnumLessThanEquals release];
	[kEnumBeginsWith release];
	[kEnumEndsWith release];
	[kEnumContains release];
	// logical tests
	[kEnumAND release];
	[kEnumOR release];
	[kEnumNOT release];
	// miscellaneous
	[kEmptyRecord release];
}


/**********************************************************************/
// Abstract base class for all comparison and logic test classes

@implementation AEMTest : AEMQuery

// takes a single test clause or an array of test clauses
// note: currently performs no runtime type checks to ensure arg is/contains
// AEMTest instances only
- (AEMANDTest *)AND:(id)remainingOperands { 
	NSMutableArray *allOperands;
	
	allOperands = [NSMutableArray arrayWithObject: self];
	if ([remainingOperands isKindOfClass: [NSArray class]])
		[allOperands addObjectsFromArray: remainingOperands];
	else
		[allOperands addObject: remainingOperands];
	return [[[AEMANDTest alloc] initWithOperands: allOperands] autorelease];
}

// takes a single test clause or an array of test clauses
// note: currently performs no runtime type checks to ensure arg is/contains
// AEMTest instances only
- (AEMORTest *)OR:(id)remainingOperands {
	NSMutableArray *allOperands;
	
	allOperands = [NSMutableArray arrayWithObject: self];
	if ([remainingOperands isKindOfClass: [NSArray class]])
		[allOperands addObjectsFromArray: remainingOperands];
	else
		[allOperands addObject: remainingOperands];
	return [[[AEMORTest alloc] initWithOperands: allOperands] autorelease];
}

- (AEMNOTTest *)NOT {
	return [[[AEMNOTTest alloc] initWithOperands: [NSArray arrayWithObject: self]] autorelease];
}

- (NSString *)formatString { // stub method; subclasses will override
	return nil;
}

- (NSAppleEventDescriptor *)operator { // stub method; subclasses will override
	return nil;
}

@end


/**********************************************************************/
// Comparison tests

// Abstract base class for all comparison test classes
@implementation AEMComparisonTest

- (id)initWithOperand1:(id)operand1_ operand2:(id)operand2_ {
	self = [super init];
	if (!self) return self;
	[operand1_ retain];
	[operand2_ retain];
	operand1 = operand1_;
	operand2 = operand2_;
	return self;
}

- (void)dealloc {
	[operand1 release];
	[operand2 release];
	[super dealloc];
}

- (BOOL)isEqual:(id)object {
	if (self == object) return YES;
	if (!object || ![object isMemberOfClass: [self class]]) return NO;
	if ([operand1 isKindOfClass: [NSAppleEventDescriptor class]]) {
		if (!AEMIsDescriptorEqualToObject(operand1, [object operand1])) return NO;
	} else
		if (![operand1 isEqual: [object operand1]]) return NO;
	if ([operand2 isKindOfClass: [NSAppleEventDescriptor class]]) {
		if (!AEMIsDescriptorEqualToObject(operand2, [object operand2])) return NO;
	} else
		if (![operand2 isEqual: [object operand2]]) return NO;
	return YES;
}

- (id)operand1 { // used by isEqual:
	return operand1;
}

- (id)operand2 { // used by isEqual:
	return operand2;
}

- (NSString *)description {
	return [NSString stringWithFormat: [self formatString], operand1, operand2];
}

- (id)resolveWithObject:(id)object {
	return nil;
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeCompDescriptor];
	[desc setDescriptor: [codecs pack: operand1] forKeyword: keyAEObject1];
	[desc setDescriptor: [self operator] forKeyword: keyAECompOperator];
	[desc setDescriptor: [codecs pack: operand2] forKeyword: keyAEObject2];
	return desc;
}

@end

// comparison tests
// Note: clients should not instantiate these classes directly;
// instead, call the appropriate methods on specifier objects
// of AEMIts-based references

@implementation AEMGreaterThanTest

- (NSString *)formatString {
	return @"[%@ greaterThan: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumGreaterThan;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] greaterThan: operand2];
}

@end


@implementation AEMGreaterOrEqualsTest

- (NSString *)formatString {
	return @"[%@ greaterOrEquals: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumGreaterThanEquals;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] greaterOrEquals: operand2];
}

@end


@implementation AEMEqualsTest

- (NSString *)formatString {
	return @"[%@ equals: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumEquals;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] equals: operand2];
}

@end


@implementation AEMNotEqualsTest

- (NSString *)formatString {
	return @"[%@ notEquals: %@]";
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	return [[[operand1 equals: operand2] NOT] packWithCodecs: codecs];
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] notEquals: operand2];
}

@end


@implementation AEMLessThanTest

- (NSString *)formatString {
	return @"[%@ lessThan: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumLessThan;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] lessThan: operand2];
}

@end


@implementation AEMLessOrEqualsTest

- (NSString *)formatString {
	return @"[%@ lessOrEquals: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumLessThanEquals;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] lessOrEquals: operand2];
}

@end


@implementation AEMBeginsWithTest

- (NSString *)formatString {
	return @"[%@ beginsWith: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumBeginsWith;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] beginsWith: operand2];
}

@end


@implementation AEMEndsWithTest

- (NSString *)formatString {
	return @"[%@ endsWith: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumEndsWith;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] endsWith: operand2];
}

@end


@implementation AEMContainsTest

- (NSString *)formatString {
	return @"[%@ contains: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumContains;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] contains: operand2];
}

@end


@implementation AEMIsInTest

- (NSString *)formatString {
	return @"[%@ isIn: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumContains;
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeCompDescriptor];
	[desc setDescriptor: [codecs pack: operand2] forKeyword: keyAEObject1];
	[desc setDescriptor: [self operator] forKeyword: keyAECompOperator];
	[desc setDescriptor: [codecs pack: operand1] forKeyword: keyAEObject2];
	return desc;
}

- (id)resolveWithObject:(id)object {
	return [[operand1 resolveWithObject: object] isIn: operand2];
}

@end


/**********************************************************************/
// Logical tests

// Abstract base class for all logical test classes
@implementation AEMLogicalTest

- (id)initWithOperands:(NSArray *)operands_ {
	self = [super init];
	if (!self) return self;
	[operands_ retain];
	operands = operands_;
	return self;
}

- (void)dealloc {
	[operands release];
	[super dealloc];
}

- (BOOL)isEqual:(id)object {
	if (self == object) return YES;
	if (!object || ![object isMemberOfClass: [self class]]) return NO;
	// note: this doesn't check for NSAppleEventDescriptor operands on the
	// [reasonable] assumption that all operands are test instances anyway
	return ([operands isEqual: [object operands]]);
}

- (id)operands {
	return operands;
}

- (NSString *)description {
	id operand1, otherOperands;
	NSString *result;
	NSRange range = {1, [operands count] - 1};
	
	operand1 = [operands objectAtIndex: 0];
	if ([operands count] == 2) 
		otherOperands = [operands objectAtIndex: 1];
	else
		otherOperands = [operands subarrayWithRange: range];
	result = [NSString stringWithFormat: [self formatString], operand1, otherOperands];
	return result;
}

- (id)resolveWithObject:(id)object {
	id operand1, result;
	NSArray *otherOperands;
	NSRange range = {1, [operands count] - 1};
	
	operand1 = [[operands objectAtIndex: 0] resolveWithObject: object];
	otherOperands = [operands subarrayWithRange: range];
	if ([self operator] == kEnumAND)
		result = [operand1 AND: otherOperands];
	else
		result = [operand1 OR: otherOperands];
	return result;
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeLogicalDescriptor];
	[desc setDescriptor: [self operator] forKeyword: keyAELogicalOperator];
	[desc setDescriptor: [codecs pack: operands] forKeyword: keyAELogicalTerms];
	return desc;	
}

@end

// logical tests
// Note: clients should not instantiate these classes directly

@implementation AEMANDTest

- (NSString *)formatString {
	return @"[%@ AND: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumAND;
}

@end


@implementation AEMORTest

- (NSString *)formatString {
	return @"[%@ OR: %@]";
}

- (NSAppleEventDescriptor *)operator {
	return kEnumOR;
}

@end


@implementation AEMNOTTest

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ NOT]", [operands objectAtIndex: 0]];
}

- (NSAppleEventDescriptor *)operator {
	return kEnumNOT;
}

- (id)resolveWithObject:(id)object {
	return [[[operands objectAtIndex: 0] resolveWithObject: object] NOT];
}

@end

