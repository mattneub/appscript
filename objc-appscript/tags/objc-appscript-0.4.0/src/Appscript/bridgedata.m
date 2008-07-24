//
//  bridgedata.m
//  Appscript
//
//  Copyright (C) 2008 HAS
//

#import "bridgedata.h"

// TO DO: help agent support

@implementation ASBridgeData

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data
				   terminology:(id)terms_
				  defaultTerms:(ASTerminology *)defaultTerms_
			  keywordConverter:(id)converter_ {
	self = [super initWithApplicationClass: appClass targetType: type targetData: data];
	if (!self) return self;
	terms = [terms_ retain];
	defaultTerms = [defaultTerms_ retain];
	converter = [converter_ retain];
	return self;
}

- (void)dealloc {
	[terms release];
	[defaultTerms release];
	[converter release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	ASBridgeData *obj = [super copyWithZone: zone];
	if (!obj) return obj;
	[obj->terms retain];
	[obj->defaultTerms retain];
	[obj->converter retain];
	return obj;
}

- (id)aetesWithError:(NSError **)error {
	AEMApplication *targetApp;
	AEMEvent *event;
	
	targetApp = [self targetWithError: error];
	if (!targetApp) return nil;
	event = [targetApp eventWithEventClass: kASAppleScriptSuite eventID: kGetAETE];
	[event setParameter: [NSNumber numberWithInt: 0] forKeyword: keyDirectObject];
	return [event sendWithError: error];
}

- (BOOL)connectWithError:(NSError **)error {
	ASTerminology *tmp;
	ASAETEParser *parser;
	id aetes;
	
	if (![super connectWithError: error]) return NO;
	if ([terms isEqual: ASTrue]) { // obtain terminology from application
		[terms release];
		aetes = [self aetesWithError: error];
		if (!aetes) return NO;
		parser = [[ASAETEParser alloc] init];
		[parser parse: aetes];
		terms = [[ASTerminology alloc] initWithKeywordConverter: converter defaultTerminology: defaultTerms];
		[terms addClasses: [parser classes]
			  enumerators: [parser enumerators]
			   properties: [parser properties]
				 elements: [parser elements]
				 commands: [parser commands]];
		[parser release];
	} else if ([terms isEqual: ASFalse]) { // use built-in terminology only (e.g. use this when running AppleScript applets)
		[terms release];
		terms = [defaultTerms retain];
	} else { // terms is [assumed to be] an ASAETEParser instance or equivalent object containing raw (dumped) terminology
		tmp = [[ASTerminology alloc] initWithKeywordConverter: converter defaultTerminology: defaultTerms];
		[tmp addClasses: [(ASAETEParser *)terms classes] 
			enumerators: [(ASAETEParser *)terms enumerators] 
			 properties: [(ASAETEParser *)terms properties] 
			   elements: [(ASAETEParser *)terms elements] 
			   commands: [(ASAETEParser *)terms commands]]; // TO DO: cast appropriately
		[terms release];
		terms = tmp;
	}
	return YES;
}

- (ASTargetType)targetType {
	return targetType;
}

- (id)targetData {
	return targetData;
}

- (ASTerminology *)terminology {
	if (!target) return nil;
	return terms;
}

@end
