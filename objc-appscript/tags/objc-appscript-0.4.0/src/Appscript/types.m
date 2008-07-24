//
//  types.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "types.h"


/**********************************************************************/
// Booleans

static ASBoolean *trueValue;
static ASBoolean *falseValue;


@implementation ASBoolean

+ (id)True {
	if (!trueValue)
		trueValue = [[ASBoolean alloc] initWithBool: YES];
	return trueValue;
}

+ (id)False {
	if (!falseValue)
		falseValue = [[ASBoolean	alloc] initWithBool: NO];
	return falseValue;
}

- (id)initWithBool:(BOOL)value {
	self = [super init];
	if (!self) return self;
	boolValue = value;
	cachedDesc = [[NSAppleEventDescriptor alloc]
						 initWithDescriptorType: (value ? typeTrue : typeFalse)
										  bytes: NULL
										 length: 0];
	return self;
}

- (NSString *)description {
	return boolValue ? @"ASTrue" : @"ASFalse";
}

- (BOOL)boolValue {
	return boolValue;
}

- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs {
	return cachedDesc;
}

- (NSAppleEventDescriptor *)desc {
	return cachedDesc;
}

@end


/**********************************************************************/
// Alias, FSRef, FSSpec wrappers


@implementation ASFileBase

+ (NSURL *)HFSPathToURL:(NSString *)path {
	NSURL *url;
	
	url = (NSURL *)CFURLCreateWithFileSystemPath(NULL,
												 (CFStringRef)path,
												 kCFURLHFSPathStyle,
												 0);
	return [url autorelease];
}

+ (NSString *)URLToHFSPath:(NSURL *)url {
	NSString *path;
	
	path = (NSString *)CFURLCopyFileSystemPath((CFURLRef)url, kCFURLHFSPathStyle);
	return [path autorelease];
}

- (id)initWithPath:(NSString *)path {
	return [self initWithFileURL: [NSURL fileURLWithPath: path]];
}

- (id)initWithFileURL:(NSURL *)url {
	NSData *data;
	NSAppleEventDescriptor *furl;
	id result;
	
	if (![url isFileURL]) return nil;
	data = [[url absoluteString] dataUsingEncoding: NSUTF8StringEncoding];
	furl = [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeFileURL
															 data: data];
	result = [self initWithDescriptor: furl];
	[furl release];
	return result;
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc_ {
	self = [super init];
	if (!self) return self;
	desc = [[desc_ coerceToDescriptorType: [self descriptorType]] retain];
	if (!desc) return nil; // failed coercion, e.g. due to creating an ASAlias with a typeFileURL descriptor for a non-existent file
	return self;
}

- (NSString *)path {
	return [[self url] path];
}

- (NSURL *)url {
	NSData *data;
	NSString *string;
	NSURL *url;
	
	data = [[desc coerceToDescriptorType: typeFileURL] data];
	string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	url = [NSURL URLWithString: string];
	[string release];
	return url;
}

- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs {
	return desc;
}

- (NSAppleEventDescriptor *)desc {
	return desc;
}

- (DescType)descriptorType { // stub method; subclasses will override
	return '????';
}

@end


@implementation ASAlias

+ (id)aliasWithPath:(NSString *)path {
	return [[[ASAlias alloc] initWithPath: path] autorelease];
}

+ (id)aliasWithFileURL:(NSURL *)url {
	return [[[ASAlias alloc] initWithFileURL: url] autorelease];
}

+ (id)aliasWithDescriptor:(NSAppleEventDescriptor *)desc_ {
	return [[[ASAlias alloc] initWithDescriptor: desc_] autorelease];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[ASAlias aliasWithPath: %@]", AEMObjectToDisplayString([self path])];
}

- (DescType)descriptorType {
	return typeAlias;
}

@end


@implementation ASFileRef

+ (id)fileRefWithPath:(NSString *)path {
	return [[[ASFileRef alloc] initWithPath: path] autorelease];
}

+ (id)fileRefWithFileURL:(NSURL *)url {
	return [[[ASFileRef alloc] initWithFileURL: url] autorelease];
}

+ (id)fileRefWithDescriptor:(NSAppleEventDescriptor *)desc_ {
	return [[[ASFileRef alloc] initWithDescriptor: desc_] autorelease];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[ASFileRef fileRefWithPath: %@]", AEMObjectToDisplayString([self path])];
}

- (DescType)descriptorType {
	return typeFSRef;
}

@end


@implementation ASFileSpec

+ (id)fileSpecWithPath:(NSString *)path {
	return [[[ASFileSpec alloc] initWithPath: path] autorelease];
}

+ (id)fileSpecWithFileURL:(NSURL *)url {
	return [[[ASFileSpec alloc] initWithFileURL: url] autorelease];
}

+ (id)fileSpecWithDescriptor:(NSAppleEventDescriptor *)desc_ {
	return [[[ASFileSpec alloc] initWithDescriptor: desc_] autorelease];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[ASFileSpec fileSpecWithPath: %@]", AEMObjectToDisplayString([self path])];
}

- (DescType)descriptorType {
	return typeFSS;
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

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	return [self initWithDescriptorType: '\000\000\000\000'
								   code: '\000\000\000\000'
								   desc: desc];
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
	if (anObject == self) return YES;
	if (!anObject || ![anObject isKindOfClass: [self class]]) return NO;
	return [self code] == [anObject code];
}

- (OSType)code {
	if (!code)
		code = [cachedDesc typeCodeValue]; // (-typeCodeValue works for descriptors of typeType, typeEnumerated, typeProperty, typeKeyword)
	return code;
}

- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs {
	if (!cachedDesc)
		cachedDesc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: type
																	  bytes: &code
																	 length: sizeof(code)];
	return cachedDesc;
}

- (NSAppleEventDescriptor *)desc {
	return [self packWithCodecs: nil];
}

- (id)copyWithZone:(NSZone *)zone {
	return [self retain];
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

- (NSString *)description {
	return [NSString stringWithFormat: @"[AEMType typeWithCode: '%@']", AEMDescTypeToDisplayString([self code])];
}

@end


@implementation AEMEnum

+ (id)enumWithCode:(OSType)code_ {
	return [[[AEMEnum alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeEnumerated code: code_ desc: nil];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[AEMEnum enumWithCode: '%@']", AEMDescTypeToDisplayString([self code])];
}

@end


@implementation AEMProperty

+ (id)propertyWithCode:(OSType)code_ {
	return [[[AEMProperty alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeProperty code: code_ desc: nil];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[AEMProperty propertyWithCode: '%@']", AEMDescTypeToDisplayString([self code])];
}

@end


@implementation AEMKeyword

+ (id)keywordWithCode:(OSType)code_ {
	return [[[AEMKeyword alloc] initWithCode: code_] autorelease];
}

- (id)initWithCode:(OSType)code_ {
	return [super initWithDescriptorType: typeKeyword code: code_ desc: nil];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[AEMKeyword keywordWithCode: '%@']", AEMDescTypeToDisplayString([self code])];
}

@end


/**********************************************************************/
// Unit types

@implementation ASUnits

+ (id)unitsWithNumber:(NSNumber *)value_ type:(NSString *)units_ {
	return [[[ASUnits alloc] initWithNumber: value_ type: units_] autorelease];
}

+ (id)unitsWithInt:(int)value_ type:(NSString *)units_ {
	return [[[ASUnits alloc] initWithNumber: [NSNumber numberWithInt: value_] type: units_] autorelease];
}

+ (id)unitsWithDouble:(double)value_ type:(NSString *)units_ {
	return [[[ASUnits alloc] initWithNumber: [NSNumber numberWithDouble: value_] type: units_] autorelease];
}

- (id)initWithNumber:(NSNumber *)value_ type:(NSString *)units_ {
	self = [super init];
	if (!self) return self;
	value = [value_ retain];
	units = [units_ retain];
	return self;
}

- (void)dealloc {
	[value release];
	[units release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[ASUnits unitsWithNumber: %@ type: %@]", 
			AEMObjectToDisplayString(value), AEMObjectToDisplayString(units)];
}

- (unsigned)hash {
	return (unsigned)([value hash] + [units hash]);
}

- (BOOL)isEqual:(id)anObject {
	if (anObject == self) return YES;
	if (!anObject || ![anObject isKindOfClass: [self class]]) return NO;
	return ([value isEqual: [anObject numberValue]] && [units isEqual: [anObject units]]);
}

- (NSNumber *)numberValue {
	return value;
}

- (int)intValue {
	return [value intValue];
}

- (double)doubleValue {
	return [value doubleValue];
}

- (NSString *)units {
	return units;
}

@end

