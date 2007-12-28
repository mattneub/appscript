//
//  types.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "types.h"


#define typeDescToString(desc) [[desc coerceToDescriptorType: typeUnicodeText] stringValue]



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
	return boolValue ? @"True" : @"False";
}

- (BOOL)boolValue {
	return boolValue;
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

- (NSString *)description {
	return [NSString stringWithFormat: @"<%@ %@>", [self class], [self path]];
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
	if (anObject == self) 
		return YES;
	if (!anObject || ![anObject isKindOfClass: [self class]]) 
		return NO;
	return [self code] == [anObject code];
}

- (NSString *)description {
	if (!type)
		type = [cachedDesc descriptorType];
	switch (type) {
		case typeType:
			return [NSString stringWithFormat: @"<AEMType %@>", typeDescToString([self desc])];
		case typeEnumerated:
			return [NSString stringWithFormat: @"<AEMEnumerated %@>", typeDescToString([self desc])];
		case typeProperty:
			return [NSString stringWithFormat: @"<AEMProperty %@>", typeDescToString([self desc])];
		case typeKeyword:
			return [NSString stringWithFormat: @"<AEMKeyword %@>", typeDescToString([self desc])];
		default:
			return nil;
	}
}

- (OSType)code {
	if (!code)
		code = [cachedDesc typeCodeValue]; // (-typeCodeValue works for descriptors of typeType, typeEnumerated, typeProperty, typeKeyword)
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


@implementation AEMEnum

+ (id)enumWithCode:(OSType)code_ {
	return [[[AEMEnum alloc] initWithCode: code_] autorelease];
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

