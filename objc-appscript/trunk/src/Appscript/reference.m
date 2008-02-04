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

- (unsigned)hash {
	return ([[AS_appData target] hash] + [AS_aemReference hash]);
}


//

- (NSAppleEventDescriptor *)AS_packSelf:(id)codecs {
	return [AS_aemReference packSelf: codecs];
}

- (id)AS_appData {
	return AS_appData;
}

// TO DO: AS_newReference, get+set shortcuts

- (id)AS_aemReference {
	return AS_aemReference;
}

- (BOOL)isRunning {
	return [AS_appData isRunning];
}

- (BOOL)launchApplication {
	return [self launchApplicationWithError: nil];
}

- (BOOL)launchApplicationWithError:(NSError **)error {
	return [AS_appData launchApplicationWithError: error];
}

// transaction support

- (BOOL)beginTransactionWithError:(NSError **)error {
	 return [[AS_appData target] beginTransactionWithError: error];
}

- (BOOL)beginTransactionWithSession:(id)session error:(NSError **)error {
	 return [[AS_appData target] beginTransactionWithSession: session error: error];
}

- (BOOL)endTransactionWithError:(NSError **)error {
	 return [[AS_appData target] endTransactionWithError: error];
}

- (BOOL)abortTransactionWithError:(NSError **)error {
	 return [[AS_appData target] abortTransactionWithError: error];
}

@end

