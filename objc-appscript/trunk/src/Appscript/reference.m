//
//  reference.m
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "reference.h"


/**********************************************************************/


@implementation ASReference

+ (id)referenceWithAppData:(id)appData aemReference:(id)aemReference {
	return [[[self alloc] initWithAppData: appData aemReference: aemReference] autorelease];
}

- (id)initWithAppData:(id)appData aemReference:(id)aemReference {
	self = [super init];
	if (!self) return self;
	AS_appData = [appData retain];
	AS_aemReference = [aemReference retain];
	return self;
}

- (void)dealloc {
	[AS_appData release];
	[AS_aemReference release];
	[super dealloc];
}


// comparison, hash support

- (BOOL)isEqual:(id)object {
	if (self == object) return YES;
	if (!object || ![object isMemberOfClass: [self class]]) return NO;
	return ([[AS_appData target] isEqual: [[object AS_appData] target]]
			&& [AS_aemReference isEqual: [object AS_aemReference]]); 
}

- (NSUInteger)hash {
	return ([[AS_appData target] hash] + [AS_aemReference hash]);
}


//

- (NSAppleEventDescriptor *)AS_packSelf:(id)codecs {
	return [AS_aemReference packWithCodecs: codecs];
}

- (id)AS_appData {
	return AS_appData;
}

- (id)AS_aemReference {
	return AS_aemReference;
}

- (void)AS_setRelaunchMode:(ASRelaunchMode)relaunchMode_ {
	[AS_appData setRelaunchMode: relaunchMode_];
}

- (ASRelaunchMode)AS_relaunchMode {
	return [AS_appData relaunchMode];
}


- (BOOL)isRunning {
	return [AS_appData isRunning];
}

- (BOOL)launchApplication {
	return [self launchApplicationWithError: nil];
}

- (BOOL)launchApplicationWithError:(out NSError **)error {
	return [AS_appData launchApplicationWithError: error];
}

- (BOOL)reconnectApplication {
	return [[AS_appData targetWithError: nil] reconnect];
}

- (BOOL)reconnectApplicationWithError:(out NSError **)error {
	return [[AS_appData targetWithError: error] reconnectWithError: error];
}

// transaction support

- (BOOL)beginTransactionWithError:(out NSError **)error {
	 return [[AS_appData target] beginTransactionWithError: error];
}

- (BOOL)beginTransactionWithSession:(id)session error:(out NSError **)error {
	 return [[AS_appData target] beginTransactionWithSession: session error: error];
}

- (BOOL)endTransactionWithError:(out NSError **)error {
	 return [[AS_appData target] endTransactionWithError: error];
}

- (BOOL)abortTransactionWithError:(out NSError **)error {
	 return [[AS_appData target] abortTransactionWithError: error];
}


// get/set shortcuts

- (id)setItem:(id)data {
	return [self setItem: data error: nil];
}

- (id)setItem:(id)data error:(out NSError **)error {
	ASGetSetItemCommand *cmd = [ASGetSetItemCommand commandWithAppData: AS_appData
															eventClass: kAECoreSuite
															   eventID: kAESetData
													   directParameter: kASNoDirectParameter
													   parentReference: self];
	[[cmd AS_aemEvent] setParameter: data forKeyword: keyAEData];
	return [cmd sendWithError: error];
}

- (id)getItem {
	return [self getItemWithError: nil];
}

- (id)getItemWithError:(out NSError **)error {
	return [[ASGetSetItemCommand commandWithAppData: AS_appData
									     eventClass: kAECoreSuite
										    eventID: kAEGetData
								    directParameter: kASNoDirectParameter
								    parentReference: self] sendWithError: error];
}

- (id)getList {
	return [self getListWithError: nil];
}

- (id)getListWithError:(out NSError **)error {
	return [[[ASGetSetItemCommand commandWithAppData: AS_appData
										  eventClass: kAECoreSuite
										     eventID: kAEGetData
									 directParameter: kASNoDirectParameter
								     parentReference: self] returnList] sendWithError: error];
}

- (id)getItemOfType:(DescType)type {
	return [self getItemOfType: type error: nil];
}

- (id)getItemOfType:(DescType)type error:(out NSError **)error {
	ASGetSetItemCommand *cmd = [ASGetSetItemCommand commandWithAppData: AS_appData
															eventClass: kAECoreSuite
															   eventID: kAEGetData
													   directParameter: kASNoDirectParameter
													   parentReference: self];
	[[cmd AS_aemEvent] setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: type]
						 forKeyword: keyAERequestedType];
	[cmd returnType: type];
	return [cmd sendWithError: error];
}

- (id)getListOfType:(DescType)type {
	return [self getListOfType: type error: nil];
}

- (id)getListOfType:(DescType)type error:(out NSError **)error {
	ASGetSetItemCommand *cmd = [ASGetSetItemCommand commandWithAppData: AS_appData
															eventClass: kAECoreSuite
															   eventID: kAEGetData
													   directParameter: kASNoDirectParameter
													   parentReference: self];
	[[cmd AS_aemEvent] setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: type]
						 forKeyword: keyAERequestedType];
	[cmd returnListOfType: type];
	return [cmd sendWithError: error];
}

- (int)getIntWithError:(out NSError **)error {
	ASGetSetItemCommand *cmd = [ASGetSetItemCommand commandWithAppData: AS_appData
															eventClass: kAECoreSuite
															   eventID: kAEGetData
													   directParameter: kASNoDirectParameter
													   parentReference: self];
	[[cmd AS_aemEvent] setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: typeSInt32]
						 forKeyword: keyAERequestedType];
	[cmd returnType: typeSInt32];
	return [[cmd sendWithError: error] intValue];
}

- (long)getLongWithError:(out NSError **)error {
	ASGetSetItemCommand *cmd = [ASGetSetItemCommand commandWithAppData: AS_appData
															eventClass: kAECoreSuite
															   eventID: kAEGetData
													   directParameter: kASNoDirectParameter
													   parentReference: self];
#ifdef __LP64__
	[[cmd AS_aemEvent] setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: typeSInt64]
						 forKeyword: keyAERequestedType];
	[cmd returnType: typeSInt64];
	return [[cmd sendWithError: error] longValue];
#else
	[[cmd AS_aemEvent] setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: typeSInt32]
						 forKeyword: keyAERequestedType];
	[cmd returnType: typeSInt32];
	return [[cmd sendWithError: error] intValue];
#endif
}

- (double)getDoubleWithError:(out NSError **)error {
	ASGetSetItemCommand *cmd = [ASGetSetItemCommand commandWithAppData: AS_appData
															eventClass: kAECoreSuite
															   eventID: kAEGetData
													   directParameter: kASNoDirectParameter
													   parentReference: self];
	[[cmd AS_aemEvent] setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: typeIEEE64BitFloatingPoint]
						 forKeyword: keyAERequestedType];
	[cmd returnType: typeIEEE64BitFloatingPoint];
	return [[cmd sendWithError: error] doubleValue];
}

@end

