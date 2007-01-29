//
//  types.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "types.h"


/**********************************************************************/
// Booleans


@implementation AEMBoolean

+ (id)True {
	static AEMBoolean *trueValue;
	
	if (!trueValue)
		trueValue = [[AEMBoolean alloc] initWithBool: YES];
	return trueValue;
}

+ (id)False {
	static AEMBoolean *falseValue;
	
	if (!falseValue)
		falseValue = [[AEMBoolean alloc] initWithBool: NO];
	return falseValue;
}

- (NSString *)description {
	return [self boolValue] ? @"True" : @"False";
}

@end


/**********************************************************************/
// types, enums, etc.


@implementation AEMTypeBase

- (id)init {
	return nil;
}

// clients shouldn't call this initialiser directly; use subclasses' initialisers instead
- (id)initWithDescriptorType:(DescType)type_
						code:(OSType)code_
						desc:(NSAppleEventDescriptor *)desc {
	self = [super init];
	if (!self) return self;
	type = type_;
	code = code_;
	[desc retain];
	cachedDesc = desc;
	return self;
}

- (id)initWithCode:(OSType)code_ { // subclasses should override this method
	return nil;
}

- (void)dealloc {
	[cachedDesc release];
	[super dealloc];
}

- (unsigned)hash {
	return (unsigned)[self code];
}

- (BOOL)isEqual:(id)anObject {
	if (anObject == self) 
		return YES;
	if (!anObject || ![anObject isKindOfClass: [self class]]) 
		return NO;
	return [self code] == [anObject code];
}

- (NSString *)description {
	switch (type) {
		case typeType:
			return [NSString stringWithFormat: @"<AEMType %@>", [[self desc] stringValue]];
		case typeEnumerated:
			return [NSString stringWithFormat: @"<AEMEnumerated %@>", [[self desc] stringValue]];
		case typeProperty:
			return [NSString stringWithFormat: @"<AEMProperty %@>", [[self desc] stringValue]];
		case typeKeyword:
			return [NSString stringWithFormat: @"<AEMKeyword %@>", [[self desc] stringValue]];
		default:
			return nil;
	}
}

- (OSType)code {
	if (!code)
		code = [cachedDesc typeCodeValue]; // TO DO: check this works for enums, properties, keywords; if not, extract code via -data + -getBytes:length:
	return code;
}

- (NSAppleEventDescriptor *)desc {
	if (!cachedDesc)
		cachedDesc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: type
																	  bytes: &code
																	 length: sizeof(code)];
	return cachedDesc;
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain]; // TO DO: check this is right
}

@end


/***********************************/


@implementation AEMType

+ (id)typeWithCode:(OSType)code_ {
	return [[[AEMType alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeType code: code_ desc: nil];
}

@end


@implementation AEMEnumerator

+ (id)enumeratorWithCode:(OSType)code_ {
	return [[[AEMEnumerator alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeEnumerated code: code_ desc: nil];
}

@end


@implementation AEMProperty

+ (id)propertyWithCode:(OSType)code_ {
	return [[[AEMProperty alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeProperty code: code_ desc: nil];
}

@end


@implementation AEMKeyword

+ (id)keywordWithCode:(OSType)code_ {
	return [[[AEMKeyword alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeKeyword code: code_ desc: nil];
}

@end

