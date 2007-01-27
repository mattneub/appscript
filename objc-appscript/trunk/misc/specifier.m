//
//  specifier.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "specifier.h"

/* TO DO:
 *
 * - how best to implement -resolve:? e.g. Better to invoke a '-(id)call:(SEL)name, ...' method (or similar) on a generic visitor object (i.e. smaller API is better for simpler tasks)? Or stick with current approach (i.e. larger API is arguably better for more complex tasks)? Note: could provide an abstract AEMResolverBase class that adapts from larger API to smaller API; that'd also allow subclasses to override individual methods they're interested in.
 */


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
														 bytes:&(descData) \
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


// prepacked value for keyDesiredClass for use by -packSelf: in property specifiers
static NSAppleEventDescriptor *kClassProperty;

// blank record used by -packSelf: to construct object specifiers
static NSAppleEventDescriptor *kNullRecord;


static BOOL specifierModuleIsInitialized = NO;

void initSpecifierModule() {
	OSType descData;
	
//	NSLog(@"initialising specifier module\n");
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
	// reference roots // TO DO
	// AEMApp
	// AEMCon
	// AEMIts
	// miscellaneous
	descData = cProperty;
	kClassProperty = [[NSAppleEventDescriptor alloc] initWithDescriptorType:typeType
																	  bytes:&descData
																	 length:sizeof(descData)];
	kNullRecord = [[NSAppleEventDescriptor alloc] initRecordDescriptor];
	specifierModuleIsInitialized = YES;
}


void disposeSpecifierModule() {
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
	// reference roots // TO DO
	// [AEMApp release];
	// [AEMCon release];
	// [AEMIts release];
	// miscellaneous
	[kClassProperty release];
	[kNullRecord release];
	specifierModuleIsInitialized = NO;
}


/**********************************************************************/


@implementation AEMResolver // TO DO

- (id)app {
	return self;
}
- (id)pack:(id)obj {
	return nil;
}
@end


/**********************************************************************/
// AEM reference base (shared by specifiers and tests)

@implementation AEMBase

/*
 * TO DO:
 *	- (unsigned)hash;
 *	- (BOOL)isEqual:(id)object;
 *	- (NSArray *)comparableData;
 */
 
@end


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
//	NSLog(@"<INIT AEMSpecifier (%@) %@, %@>\n", [self class], container, key);
	return self; // TO DO: autorelease here? or individually? (only thing about autoreleasing is need to make sure AEMApp, etc. don't get dealloced by pool)
}

- (void)dealloc {
	[container release];
	[key release];
	[super dealloc];
}

// reserved methods

- (id)root {
	return [container root];
}

- (id)trueSelf {
	return self;
}

- (id)packSelf:(id)codecs { // subclasses should override this
	return nil;
}

- (id)resolve:(id)object { // subclasses should override this
	return nil;
}


@end


/**********************************************************************/
// Insertion location specifier

/*
 * A reference to an element insertion point.
 *
 * key : NSAppleEventDescriptor of typeEnumerated
 *
 */
@implementation AEMInsertionSpecifier

- (NSString *)description {
	switch ([key enumCodeValue]) {
		case kAEBeginning:
			return [NSString stringWithFormat: @"[%@ start]", container];
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

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeInsertionLoc];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEObject];
		[cachedDesc setDescriptor: key forKeyword: keyAEPosition];
	}
	return cachedDesc;	
}

-(id)resolve:(id)object { 
	id result;
	
	result = [container resolve: object];
	switch ([key enumCodeValue]) {
		case kAEBeginning:
			return [result start];
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
@implementation AEMPositionSpecifierBase

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_; {
	self = [super initWithContainer:(AEMSpecifier *)container_ key:(id)key_];
	if (!self) return self;
	wantCode = wantCode_;
//	NSLog(@"AEMPositionSpecifierBase init: %x\n", wantCode);
	return self;
}

// TO DO: methods for constructing comparison and logic tests

// Insertion location selectors

- (AEMInsertionSpecifier *)start {
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

- (id)property:(OSType)propertyCode {
	return [[[AEMPropertySpecifier alloc]
					   initWithContainer: self
									 key: [NSAppleEventDescriptor descriptorWithTypeCode: propertyCode]
								wantCode: cProperty] autorelease];
}

- (id)userProperty:(NSString *)propertyName {
	return [[[AEMUserPropertySpecifier alloc]
						   initWithContainer: self
										 key: propertyName
									wantCode: cProperty] autorelease];
}

- (id)elements:(OSType)classCode {
	return [[[AEMAllElementsSpecifier alloc]
						  initWithContainer: self
								   wantCode: classCode] autorelease];
}


// by-relative-position selectors

- (id)previous:(OSType)classCode {
	return nil; // TO DO
}

- (id)next:(OSType)classCode {
	return nil; // TO DO
}

@end


/**********************************************************************/
// Properties

/*
 * A reference to a user-defined property specifier
 */
@implementation AEMPropertySpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ property: '%@']", container, [key stringValue]];
}

// reserved methods

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: kClassProperty forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormPropertyID forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: key forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] property: [key typeCodeValue]];
}

@end


@implementation AEMUserPropertySpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ userProperty: '%@']", container, key];
}

// reserved methods

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: kClassProperty forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormUserPropertyID forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [[NSAppleEventDescriptor descriptorWithString: key] coerceToDescriptorType: typeChar]
					   forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] userProperty: key];
}

@end


/**********************************************************************/
// Single elements

/*
 * Abstract base class for all single element specifiers
 */
@implementation AEMSingleElementSpecifierBase

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_; {
	return [super initWithContainer: [container_ trueSelf] key: key_ wantCode: wantCode_];
}

@end


@implementation AEMElementByNameSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byName: %@]", container, key];
}

// reserved methods

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormName forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] byName: key];
}

@end


@implementation AEMElementByIndexSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byIndex: %@]", container, key];
}

// reserved methods

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
	cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
	[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
				   forKeyword: keyAEDesiredClass];
	[cachedDesc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
	[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
	[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] byIndex: key];
}

@end


@implementation AEMElementByIDSpecifier

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ byID: %@]", container, key];
}

// reserved methods

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormUniqueID forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: [codecs pack: key] forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [[container resolve: object] byID: key];
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

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: key forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	id result;
	
	result = [container resolve: object];
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


/*
 * note: AEMElementByRelativePositionSpecifier inherits from AEMPositionSpecifierBase,
 * not AEMSingleElementSpecifierBase
 */
@implementation AEMElementByRelativePositionSpecifier

// TO DO

@end



/**********************************************************************/
// Multiple elements

/*
 * Base class for all multiple element specifiers.
 */
@implementation AEMMultipleElementsSpecifierBase 

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
 
- (AEMElementByIndexSpecifier *)at:(long)index {
	return [[[AEMElementByIndexSpecifier alloc]
							 initWithContainer: self
										   key: [NSNumber numberWithLong: index]
									  wantCode: wantCode] autorelease];
}

- (AEMElementByIndexSpecifier *)byIndex:(id)index { // normally NSNumber, but may occasionally be other types
	return [[[AEMElementByIndexSpecifier alloc]
							 initWithContainer: self
										   key: index
									  wantCode: wantCode] autorelease];
}

- (AEMElementByNameSpecifier *)byName:(NSString *)name {
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

- (id)at:(long)fromIndex to:(long)toIndex {
	return nil;
}

- (id)byRange:(id)fromObject to:(id)toObject { // takes two con-based references, with other values being expanded as necessary
	return nil;
}


// by-test selector

- (id)byTest:(id)testReference {
	return nil;
}

@end


@implementation AEMElementsByRangeSpecifier
@end


@implementation AEMElementsByTestSpecifier
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

- (id)trueSelf {
	return container; // override default implementation to return the UnkeyedElements object stored inside of this AllElements instance
}

- (id)packSelf:(id)codecs {
	if (!cachedDesc) {
		cachedDesc = [kNullRecord coerceToDescriptorType: typeObjectSpecifier];
		[cachedDesc setDescriptor: [NSAppleEventDescriptor descriptorWithTypeCode: wantCode]
					   forKeyword: keyAEDesiredClass];
		[cachedDesc setDescriptor: kFormAbsolutePosition forKeyword: keyAEKeyForm];
		[cachedDesc setDescriptor: kOrdinalAll forKeyword: keyAEKeyData];
		[cachedDesc setDescriptor: [container packSelf: codecs] forKeyword: keyAEContainer];
	}
	return cachedDesc;
}

-(id)resolve:(id)object { 
	return [container resolve: object]; // forward to shim
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

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ elements: '%@']", container, 
			[[[NSAppleEventDescriptor descriptorWithTypeCode: wantCode] 
					coerceToDescriptorType: typeUnicodeText] stringValue]];
}

- (id)packSelf:(id)codecs {
	return [container packSelf: codecs]; // forward to next container
}

-(id)resolve:(id)object { 
	return [[container resolve: object] elements: wantCode];
}

@end


/**********************************************************************/
// Reference roots

@implementation AEMReferenceRootBase

+ (id)reference {
	return nil;
}

- (id)init {
	return nil;
}

- (id)initWithDescType:(DescType)descType {
	self = [super initWithContainer: nil key: nil wantCode: '????'];
	if (!self) return self;
	cachedDesc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: descType
																  bytes: NULL
																 length: 0];
	return self;
}


- (id)root {
	return self;
}

- (id)packSelf:(id)codecs {
	return cachedDesc;
}
@end


@implementation AEMApplicationRoot

- (id)init {
	return nil;
}

+ (id)reference {
	static AEMApplicationRoot *root;
	
	if (!root) {
//		NSLog(@"initialising AEMApplicationRoot\n");
		if (!specifierModuleIsInitialized)
			initSpecifierModule();
		root = [[AEMApplicationRoot alloc] initWithDescType: typeNull];
	}
	return root;
}

- (NSString *)description {
	return @"AEMApp";
}

- (id)resolve:(id)object {
	return [object app];
}

@end


@implementation AEMCurrentContainerRoot // TO DO
@end


@implementation AEMObjectBeingExaminedRoot // TO DO
@end

