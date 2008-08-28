//
//  specifier.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "specifier.h"


/**********************************************************************/
// initialise/dispose constants


#define ENUMERATOR(name) \
		descData = kAE##name; \
		kEnum##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeEnumerated \
														 bytes:&descData \
														length:sizeof(descData)];

#define ORDINAL(name) \
		descData = kAE##name; \
		kOrdinal##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeAbsoluteOrdinal \
														 bytes:&descData \
														length:sizeof(descData)];

#define KEY_FORM(name) \
		descData = form##name; \
		kForm##name = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeEnumerated \
														 bytes:&descData \
														length:sizeof(descData)];

// insertion locations
static NSAppleEventDescriptor *kEnumBeginning,
							  *kEnumEnd,
							  *kEnumBefore,
							  *kEnumAfter;

// relative positions
static NSAppleEventDescriptor *kEnumPrevious,
							  *kEnumNext;

// absolute ordinals
static NSAppleEventDescriptor *kOrdinalFirst,
							  *kOrdinalMiddle,
							  *kOrdinalLast,
							  *kOrdinalAny,
							  *kOrdinalAll;

// key forms
static NSAppleEventDescriptor *kFormPropertyID,
							  *kFormUserPropertyID,
							  *kFormName,
							  *kFormAbsolutePosition,
							  *kFormUniqueID,
							  *kFormRelativePosition,
							  *kFormRange,
							  *kFormTest;


// prepacked value for keyDesiredClass for use by -packWithCodecs: in property specifiers
static NSAppleEventDescriptor *kClassProperty;


// blank record used by -packWithCodecs: to construct object specifier descriptors
static NSAppleEventDescriptor *kEmptyRecord;


static BOOL specifierModulesAreInitialized = NO;


void initSpecifierModule(void) {
	OSType descData;
	
	initTestModule();
	// insertion locations
	ENUMERATOR(Beginning);
	ENUMERATOR(End);
	ENUMERATOR(Before);
	ENUMERATOR(After);
	// relative positions
	ENUMERATOR(Previous);
	ENUMERATOR(Next);
	// absolute ordinals
	ORDINAL(First);
	ORDINAL(Middle);
	ORDINAL(Last);
	ORDINAL(Any);
	ORDINAL(All);
	//key forms
	KEY_FORM(PropertyID);
	KEY_FORM(UserPropertyID);
	KEY_FORM(Name);
	KEY_FORM(AbsolutePosition);
	KEY_FORM(UniqueID);
	KEY_FORM(RelativePosition);
	KEY_FORM(Range);
	KEY_FORM(Test);
	// miscellaneous
	descData = cProperty;
	kClassProperty = [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeType
																	  bytes: &descData
																	 length: sizeof(descData)];
	kEmptyRecord = [[NSAppleEventDescriptor alloc] initRecordDescriptor];
	specifierModulesAreInitialized = YES;
}


void disposeSpecifierModule(void) {
	disposeTestModule();
	// insertion locations
	[kEnumBeginning release];
	[kEnumEnd release];
	[kEnumBefore release];
	[kEnumAfter release];
	// relative positions
	[kEnumPrevious release];
	[kEnumNext release];
	// absolute ordinals
	[kOrdinalFirst release];
	[kOrdinalMiddle release];
	[kOrdinalLast release];
	[kOrdinalAny release];
	[kOrdinalAll release];
	//key forms
	[kFormPropertyID release];
	[kFormUserPropertyID release];
	[kFormName release];
	[kFormAbsolutePosition release];
	[kFormUniqueID release];
	[kFormRelativePosition release];
	[kFormRange release];
	[kFormTest release];
	// miscellaneous
	[kClassProperty release];
	[kEmptyRecord release];
	specifierModulesAreInitialized = NO;
}


/**********************************************************************/
// Specifier base

/*
 * Abstract base class for all object specifier classes.
 */
@implementation AEMSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ {
	self = [super init];
	if (!self) return self;
	[container_ retain];
	container = container_;
	[key_ retain];
	key = key_;
	return self;
}

- (void)dealloc {
	[container release];
	[key release];
	[super dealloc];
}

// reserved methods

- (AEMReferenceRootBase *)root {
	return [container root];
}

- (AEMSpecifier *)trueSelf {
	return self;
}

- (BOOL)isEqual:(id)object {
	id key2;
	
	if (self == object) return YES;
	if (!object || ![object isMemberOfClass: [self class]]) return NO;
	key2 = [object key];
	if ([key isKindOfClass: [NSAppleEventDescriptor class]]) {
		// NSAppleEventDescriptors compare for object identity only, so do a more thorough comparison here
		if (!AEMIsDescriptorEqualToObject(key, key2)) 
			return NO;
	} else if (!([key isEqual: key2] || (key == nil && key2 == nil))) 
		return NO;
	return ([container isEqual: [object container]]);
}

- (id)key { // used by -isEqual:
	return key;
}

- (id)container { // used by -isEqual:
	return container;
}

@end


/**********************************************************************/
// Performance optimisation used by -[AEMCodecs unpackObjectSpecifier:]


@implementation AEMDeferredSpecifier

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc_ codecs:(id)codecs_ {
	self = [super initWithContainer: nil key: nil];
	if (!self) return self;
	reference = nil;
	desc = [desc_ retain];
	codecs = [codecs_ retain];
	return self;
}

- (void)dealloc {
	[reference release];
	[desc release];
	[codecs release];
	[super dealloc];
}

- (id)realReference { // used internally
	if (!reference)
		reference = [[codecs fullyUnpackObjectSpecifier: desc] retain];
	return reference;
}

- (NSString *)description {
	return [[self realReference] description];
}

- (AEMReferenceRootBase *)root {
	return [[self realReference] root];
}

- (id)resolveWithObject:(id)object {
	return [[self realReference] resolveWithObject: object];
}

- (BOOL)isEqual:(id)object {
	return [[self realReference] isEqual: object];
}

@end


/**********************************************************************/
// Insertion location specifier

/*
 * A reference to an element insertion point.
 *
 * key : NSAppleEventDescriptor of typeEnumerated, value:
 *			 kEnumBeginning/kEnumEnd/kEnumBefore/kEnumAfter
 *
 */
@implementation AEMInsertionSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEBeginning:
			return [NSString stringWithFormat: @"[%@ beginning]", container];
		case kAEEnd:
			return [NSString stringWithFormat: @"[%@ end]", container];
		case kAEBefore:
			return [NSString stringWithFormat: @"[%@ before]", container];
		case kAEAfter:
			return [NSString stringWithFormat: @"[%@ after]", container];
		default:
			return nil;
	}
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeInsertionLoc];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEObject];
	[desc setDescriptor: key forKeyword: keyAEPosition];
	return desc;	
}

-(id)resolveWithObject:(id)object { 
	id result;
	
	result = [container resolveWithObject: object];
	switch ([key enumCodeValue]) {
		case kAEBeginning:
			return [result beginning];
		case kAEEnd:
			return [result end];
		case kAEBefore:
			return [result before];
		case kAEAfter:
			return [result after];
		default:
			return nil;
	}
}

@end


/**********************************************************************/
// Position specifier base

/*
 * All property and element reference forms inherit from this abstract class.
 */
@implementation AEMObjectSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_; {
	self = [super initWithContainer:(AEMSpecifier *)container_ key:(id)key_];
	if (!self) return self;
	wantCode = wantCode_;
	return self;
}

- (BOOL)isEqual:(id)object {
	return ([super isEqual: object] && wantCode == [object wantCode]);
}

- (OSType)wantCode { // used by isEqual
	return wantCode;
}

// Comparison and logic tests

- (AEMGreaterThanTest *)greaterThan:(id)object {
	return [[[AEMGreaterThanTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMGreaterOrEqualsTest *)greaterOrEquals:(id)object {
	return [[[AEMGreaterOrEqualsTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMEqualsTest *)equals:(id)object {
	return [[[AEMEqualsTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMNotEqualsTest *)notEquals:(id)object {
	return [[[AEMNotEqualsTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMLessThanTest *)lessThan:(id)object {
	return [[[AEMLessThanTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMLessOrEqualsTest *)lessOrEquals:(id)object {
	return [[[AEMLessOrEqualsTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMBeginsWithTest *)beginsWith:(id)object {
	return [[[AEMBeginsWithTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMEndsWithTest *)endsWith:(id)object {
	return [[[AEMEndsWithTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMContainsTest *)contains:(id)object {
	return [[[AEMContainsTest alloc] initWithOperand1: self operand2: object] autorelease];
}

- (AEMIsInTest *)isIn:(id)object {
	return [[[AEMIsInTest alloc] initWithOperand1: self operand2: object] autorelease];
}


// Insertion location selectors

- (AEMInsertionSpecifier *)beginning {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumBeginning] autorelease];
}

- (AEMInsertionSpecifier *)end {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumEnd] autorelease];
}

- (AEMInsertionSpecifier *)before {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumBefore] autorelease];
}

- (AEMInsertionSpecifier *)after {
	return [[[AEMInsertionSpecifier alloc] initWithContainer: self key: kEnumAfter] autorelease];
}


// property and all-element specifiers

- (AEMPropertySpecifier *)property:(OSType)propertyCode {
	return [[[AEMPropertySpecifier alloc]
					   initWithContainer: self
									 key: [NSAppleEventDescriptor descriptorWithTypeCode: propertyCode]
								wantCode: cProperty] autorelease];
}

- (AEMUserPropertySpecifier *)userProperty:(NSString *)propertyName {
	return [[[AEMUserPropertySpecifier alloc]
						   initWithContainer: self
										 key: propertyName
									wantCode: cProperty] autorelease];
}

- (AEMAllElementsSpecifier *)elements:(OSType)classCode {
	return [[[AEMAllElementsSpecifier alloc]
						  initWithContainer: self
								   wantCode: classCode] autorelease];
}


// by-relative-position selectors

- (AEMElementByRelativePositionSpecifier *)previous:(OSType)classCode {
	return [[[AEMElementByRelativePositionSpecifier alloc]
										initWithContainer: self
													  key: kEnumPrevious
												 wantCode: classCode] autorelease];
}

- (AEMElementByRelativePositionSpecifier *)next:(OSType)classCode {
	return [[[AEMElementByRelativePositionSpecifier alloc]
										initWithContainer: self
													  key: kEnumNext
												 wantCode: classCode] autorelease];
}

@end


/**********************************************************************/
// Properties

/*
 * A reference to a user-defined property specifier
 */
@implementation AEMPropertySpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ property: '%@']", container, [AEMObjectRenderer formatOSType: [key typeCodeValue]]];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: kClassProperty forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormPropertyID forKeyword: keyAEKeyForm];
	[desc setDescriptor: key forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] property: [key typeCodeValue]];
}

@end


@implementation AEMUserPropertySpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ userProperty: '%@']", container, [AEMObjectRenderer formatObject: key]];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: kClassProperty forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormUserPropertyID forKeyword: keyAEKeyForm];
	[desc setDescriptor: [[NSAppleEventDescriptor descriptorWithString: key] coerceToDescriptorType: typeChar]
				   forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] userProperty: key];
}

@end


/**********************************************************************/
// Single elements

/*
 * Abstract base class for all single element specifiers
 * (except AEMElementByRelativePositionSpecifier, which
 * needs the original container reference as-is while
 * the rest call its -trueSelf method to get rid of any
 * all-elements specifiers)
 */
@implementation AEMSingleElementSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_; {
	return [super initWithContainer: [container_ trueSelf] key: key_ wantCode: wantCode_];
}

@end


@implementation AEMElementByNameSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byName: %@]", container, [AEMObjectRenderer formatObject: key]];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormName forKeyword: keyAEKeyForm];
	[desc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] byName: key];
}

@end


@implementation AEMElementByIndexSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byIndex: %@]", container, [AEMObjectRenderer formatObject: key]];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
	[desc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] byIndex: key];
}

@end


@implementation AEMElementByIDSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byID: %@]", container, [AEMObjectRenderer formatObject: key]];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormUniqueID forKeyword: keyAEKeyForm];
	[desc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] byID: key];
}

@end


@implementation AEMElementByOrdinalSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEFirst:
			return [NSString stringWithFormat: @"[%@ first]", container];
		case kAEMiddle:
			return [NSString stringWithFormat: @"[%@ middle]", container];
		case kAELast:
			return [NSString stringWithFormat: @"[%@ last]", container];
		case kAEAny:
			return [NSString stringWithFormat: @"[%@ any]", container];
		default:
			return nil;
	}
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
	[desc setDescriptor: key forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	id result;
	
	result = [container resolveWithObject: object];
	switch ([key enumCodeValue]) {
		case kAEFirst:
			return [result first];
		case kAEMiddle:
			return [result middle];
		case kAELast:
			return [result last];
		case kAEAny:
			return [result any];
		default:
			return nil;
	}
}

@end



@implementation AEMElementByRelativePositionSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEPrevious:
			return [NSString stringWithFormat: @"[%@ previous: '%@']", container,
					[AEMObjectRenderer formatOSType: wantCode]];
		case kAENext:
			return [NSString stringWithFormat: @"[%@ next: '%@']", container,
					[AEMObjectRenderer formatOSType: wantCode]];
		default:
			return nil;
	}
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormRelativePosition forKeyword: keyAEKeyForm];
	[desc setDescriptor: key forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}


-(id)resolveWithObject:(id)object { 
	id result;
	
	result = [container resolveWithObject: object];
	switch ([key enumCodeValue]) {
		case kAEPrevious:
			return [result previous: wantCode];
		case kAENext:
			return [result next: wantCode];
		default:
			return nil;
	}
}

@end



/**********************************************************************/
// Multiple elements

/*
 * Base class for all multiple element specifiers.
 */
@implementation AEMMultipleElementsSpecifier 

// ordinal selectors

- (AEMElementByOrdinalSpecifier *)first {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalFirst
										wantCode: wantCode] autorelease];
}

- (AEMElementByOrdinalSpecifier *)middle {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalMiddle
										wantCode: wantCode] autorelease];
}

- (AEMElementByOrdinalSpecifier *)last {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalLast
										wantCode: wantCode] autorelease];
}

- (AEMElementByOrdinalSpecifier *)any {
	return [[[AEMElementByOrdinalSpecifier alloc]
							   initWithContainer: self
											 key: kOrdinalAny
										wantCode: wantCode] autorelease];
}


// by-index, by-name, by-id selectors
 
- (AEMElementByIndexSpecifier *)at:(int)index {
	return [[[AEMElementByIndexSpecifier alloc]
							 initWithContainer: self
										   key: [NSNumber numberWithInt: index]
									  wantCode: wantCode] autorelease];
}

- (AEMElementByIndexSpecifier *)byIndex:(id)index { // index is normally NSNumber, but may occasionally be other types where target application accepts it (e.g. Finder also accepts typeAlias)
	return [[[AEMElementByIndexSpecifier alloc]
							 initWithContainer: self
										   key: index
									  wantCode: wantCode] autorelease];
}

- (AEMElementByNameSpecifier *)byName:(id)name {
	return [[[AEMElementByNameSpecifier alloc]
							initWithContainer: self
										  key: name
									 wantCode: wantCode] autorelease];
}

- (AEMElementByIDSpecifier *)byID:(id)id_ {
	return [[[AEMElementByIDSpecifier alloc]
						  initWithContainer: self
										key: id_
								   wantCode: wantCode] autorelease];
}

// by-range selector

- (AEMElementsByRangeSpecifier *)at:(int)startIndex to:(int)stopIndex {
	return [[[AEMElementsByRangeSpecifier alloc]
							  initWithContainer: self
										  start: [[AEMCon elements: wantCode] at: startIndex]
										   stop: [[AEMCon elements: wantCode] at: stopIndex]
									   wantCode: wantCode] autorelease];
}

// takes two app- or con-based references, expanding any other values as necessary
- (AEMElementsByRangeSpecifier *)byRange:(id)startReference to:(id)stopReference { 
	return [[[AEMElementsByRangeSpecifier alloc]
							  initWithContainer: self
										  start: startReference
										   stop: stopReference
									   wantCode: wantCode] autorelease];
}


// by-test selector

- (AEMElementsByTestSpecifier *)byTest:(AEMTest *)testReference {
	return [[[AEMElementsByTestSpecifier alloc]
							 initWithContainer: self
										   key: testReference
									  wantCode: wantCode] autorelease];
}

@end


@implementation AEMElementsByRangeSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_
				  start:(id)startReference_
				   stop:(id)stopReference_
			   wantCode:(OSType)wantCode_ {
	self = [super initWithContainer: [container_ trueSelf] key: nil wantCode: wantCode_];
	if (!self) return self;
	startReference = [startReference_ retain];
	stopReference = [stopReference_ retain];
	return self;
}

- (BOOL)isEqual:(id)object {
	return ([super isEqual: object] && [startReference isEqual: [object startReference]]
									&& [stopReference isEqual: [object stopReference]]); 
}

- (id)startReference { // used by isEqual:
	return startReference;
}

- (id)stopReference { // used by isEqual:
	return stopReference;
}


- (void)dealloc {
	[startReference release];
	[stopReference release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byRange: %@ to: %@]",
									   container,
									   [AEMObjectRenderer formatObject: startReference],
									   [AEMObjectRenderer formatObject: stopReference]];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *keyDesc, *desc;
	id startReference_, stopReference_;
	
	// expand non-reference values to con-based references
	// (note: doesn't bother to check if references are app- or con-based;
	//	will assume users are smart enough not to try passing its-based references)
	if ([startReference isKindOfClass: [AEMSpecifier class]] 
			|| [startReference isKindOfClass: [NSAppleEventDescriptor class]] 
			&& [startReference descriptorType] == typeObjectSpecifier)
		startReference_ = startReference;
	if ([startReference isKindOfClass: [NSString class]])
		startReference_ = [[AEMCon elements: wantCode] byName: startReference];
	else
		startReference_ = [[AEMCon elements: wantCode] byIndex: startReference];
	if ([stopReference isKindOfClass: [AEMSpecifier class]] 
			|| [stopReference isKindOfClass: [NSAppleEventDescriptor class]] 
			&& [stopReference descriptorType] == typeObjectSpecifier)
		stopReference_ = stopReference;
	if ([stopReference isKindOfClass: [NSString class]])
		stopReference_ = [[AEMCon elements: wantCode] byName: stopReference];
	else
		stopReference_ = [[AEMCon elements: wantCode] byIndex: stopReference];
	// pack descriptor
	keyDesc = [kEmptyRecord coerceToDescriptorType: typeRangeDescriptor];
	[keyDesc setDescriptor: [codecs pack: startReference_] forKeyword: keyAERangeStart];
	[keyDesc setDescriptor: [codecs pack: stopReference_] forKeyword: keyAERangeStop];
	desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormRange forKeyword: keyAEKeyForm];
	[desc setDescriptor: keyDesc forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}


-(id)resolveWithObject:(id)object {
	return [[container resolveWithObject: object] byRange: startReference to: stopReference];
}

@end


@implementation AEMElementsByTestSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ key:(AEMTest *)key_ wantCode:(OSType)wantCode_; {
	return [super initWithContainer: [container_ trueSelf] key: key_ wantCode: wantCode_];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byTest: %@]", container, key];
}

// reserved methods

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormTest forKeyword: keyAEKeyForm];
	[desc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}


-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] byTest: key];
}

@end


@implementation AEMAllElementsSpecifier

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_ {
	AEMUnkeyedElementsShim *shim;
	
	shim = [[AEMUnkeyedElementsShim alloc] initWithContainer: container_ wantCode: wantCode_];
	self = [super initWithContainer: shim key: kOrdinalAll wantCode: wantCode_];
	[shim release];
	return self;
}

- (NSString *)description {
	return [container description]; // forward to shim
}

// reserved methods

- (AEMSpecifier *)trueSelf {
	// Overrides default implementation to return the UnkeyedElements object
	// stored inside of this AllElements instance.
	return container; 
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	NSAppleEventDescriptor *desc = [kEmptyRecord coerceToDescriptorType: typeObjectSpecifier];
	[desc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
			 forKeyword: keyAEDesiredClass];
	[desc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
	[desc setDescriptor: kOrdinalAll forKeyword: keyAEKeyData];
	[desc setDescriptor: [container packWithCodecs: codecs] forKeyword: keyAEContainer];
	return desc;
}

-(id)resolveWithObject:(id)object { 
	return [container resolveWithObject: object]; // forward to shim
}

@end


/**********************************************************************/
// Multiple element shim

@implementation AEMUnkeyedElementsShim

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_ {
	self = [super initWithContainer: container_ key: nil];
	if (!self) return self;
	wantCode = wantCode_;
	return self;
}

- (BOOL)isEqual:(id)object {
	return ([super isEqual: object] && wantCode == [object wantCode]);
}

- (OSType)wantCode { // used by isEqual
	return wantCode;
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ elements: '%@']", container, 
			[AEMObjectRenderer formatOSType: wantCode]];
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	return [container packWithCodecs: codecs]; // forward to next container
}

-(id)resolveWithObject:(id)object { 
	return [[container resolveWithObject: object] elements: wantCode];
}

@end


/**********************************************************************/
// Reference roots

@implementation AEMReferenceRootBase

- (BOOL)isEqual:(id)object {
	if (self == object) return YES;
	if (!object || ![object isMemberOfClass: [self class]]) return NO;
	return YES;
}

- (AEMReferenceRootBase *)root {
	return self;
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	return cachedDesc;
}

@end


@implementation AEMApplicationRoot

+ (AEMApplicationRoot *)applicationRoot {
	static AEMApplicationRoot *root;
	
	if (!root) {
		if (!specifierModulesAreInitialized) initSpecifierModule();
		root = [[AEMApplicationRoot alloc] initWithContainer: nil key: nil wantCode: '????'];
	}
	return root;
}

- (NSString *)description {
	return @"AEMApp";
}

- (id)resolveWithObject:(id)object {
	return [object app];
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	return [codecs applicationRootDescriptor];
}

@end


@implementation AEMCurrentContainerRoot

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMCurrentContainerRoot *)currentContainerRoot {
	static AEMCurrentContainerRoot *root;
	
	if (!root) {
		if (!specifierModulesAreInitialized) initSpecifierModule();
		root = [[AEMCurrentContainerRoot alloc] initWithContainer: nil key: nil wantCode: '????'];
		[root setCachedDesc: [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeCurrentContainer
																			  bytes: NULL
																			 length: 0]];
	}
	return root;
}

- (NSString *)description {
	return @"AEMCon";
}

- (id)resolveWithObject:(id)object {
	return [object con];
}

@end


@implementation AEMObjectBeingExaminedRoot

+ (AEMObjectBeingExaminedRoot *)objectBeingExaminedRoot {
	static AEMObjectBeingExaminedRoot *root;
	
	if (!root) {
		if (!specifierModulesAreInitialized) initSpecifierModule();
		root = [[AEMObjectBeingExaminedRoot alloc] initWithContainer: nil key: nil wantCode: '????'];
		[root setCachedDesc: [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeObjectBeingExamined
																			  bytes: NULL
																			 length: 0]];
	}
	return root;
}

- (NSString *)description {
	return @"AEMIts";
}

- (id)resolveWithObject:(id)object {
	return [object its];
}

@end


@implementation AEMCustomRoot

+ (AEMCustomRoot *)customRootWithObject:(id)rootObject_ {
	if (!specifierModulesAreInitialized) initSpecifierModule();
	return [[self alloc] initWithObject: rootObject_];
}

- (id)initWithObject:(id)rootObject_ {
	self = [super initWithContainer: nil key: nil wantCode: '????'];
	if (!self) return self;
	rootObject = [rootObject_ retain];
	return self;
}

- (BOOL)isEqual:(id)object {
	id rootObject2;
	
	if (![super isEqual: object]) return NO;
	rootObject2 = [object rootObject];
	if ([rootObject isKindOfClass: [NSAppleEventDescriptor class]])
		// NSAppleEventDescriptors compare for object identity only, so do a more thorough comparison here
		return AEMIsDescriptorEqualToObject(rootObject, rootObject2);
	else
		return ([rootObject isEqual: rootObject2]);
}

- (id)rootObject { // used by isEqual
	return rootObject;
}

- (void)dealloc {
	[rootObject release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"AEMRoot(%@)", [AEMObjectRenderer formatObject: rootObject]];
}

- (id)resolveWithObject:(id)object {
	return [object customRoot: rootObject];
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs {
	return [codecs pack: rootObject];
}

@end
