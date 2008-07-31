//
//  command.m
//  Appscript
//
//  Copyright (C) 2007-2008 HAS
//

#import "command.h"


/**********************************************************************/

static NSAppleEventDescriptor *defaultIgnore;

@implementation ASCommand

+ (id)commandWithAppData:(id)appData
			  eventClass:(AEEventClass)classCode
				 eventID:(AEEventID)code
		 directParameter:(id)directParameter
		 parentReference:(id)parentReference {
	return [[[[self class] alloc] initWithAppData: appData
									   eventClass: classCode
										  eventID: code
								  directParameter: directParameter
								  parentReference: parentReference] autorelease];
}

- (id)initWithAppData:(id)appData
		   eventClass:(AEEventClass)classCode
			  eventID:(AEEventID)code
	  directParameter:(id)directParameter
	  parentReference:(id)parentReference {
	self = [super init];
	if (!self) return self;
	sendMode = kAEWaitReply | kAECanSwitchLayer;
	timeout = kAEDefaultTimeout;
	considsAndIgnoresFlags = kAECaseIgnoreMask;
	// if -targetWithError: fails, store NSError and return it when -sendWithError: is invoked
	id target = [appData targetWithError: &cachedError];
	if (target) {
		AS_event = [[target eventWithEventClass: classCode eventID: code codecs: appData] retain];
		// set event's direct parameter and/or subject attribute
		// note: AEMEvent/AEMCodecs instance will raise exception if this fails
		if (directParameter != kASNoDirectParameter)
			[AS_event setParameter: directParameter forKeyword: keyDirectObject];
		if ([parentReference AS_aemReference] == AEMApp) 
			[AS_event setAttribute: [NSNull null] forKeyword: keySubjectAttr];
		else if (directParameter == kASNoDirectParameter)
			[AS_event setParameter: parentReference forKeyword: keyDirectObject];
		else
			[AS_event setAttribute: parentReference forKeyword: keySubjectAttr];
	} else
		[cachedError retain];
	return self;
}

- (void)dealloc {
	[AS_event release];
	[cachedError release];
	[super dealloc];
}

- (AEMEvent *)AS_aemEvent {
	return AS_event;
}

- (id)considering:(UInt32)considsAndIgnoresFlags_ {
	considsAndIgnoresFlags = considsAndIgnoresFlags_;
	return self;
}

- (id)sendMode:(AESendMode)flags {
	sendMode = flags;
	return self;
}

- (id)waitForReply {
	sendMode = sendMode & ~kAENoReply & ~kAEQueueReply | kAEWaitReply;
	return self;
}

- (id)ignoreReply {
	sendMode = sendMode & ~kAEWaitReply & ~kAEQueueReply | kAENoReply;
	return self;
}

- (id)queueReply {
	sendMode = sendMode & ~kAENoReply & ~kAEWaitReply | kAEQueueReply;
	return self;
}

- (id)timeout:(long)timeout_ {
	timeout = timeout_ * 60;
	return self;
}

- (id)requestedClass:(ASConstant *)classConstant {
	[AS_event setParameter: classConstant forKeyword: keyAERequestedType];
	return self;
}

- (id)requestedType:(DescType)type {
	[AS_event setParameter: [NSAppleEventDescriptor descriptorWithTypeCode: type]
				forKeyword: keyAERequestedType];
	return self;
}

- (id)returnClass:(ASConstant *)classConstant {
	return [self returnType: [classConstant AS_code]]; 
}

- (id)returnType:(DescType)type {
	[AS_event unpackResultAsType: type];
	return self;
}

- (id)returnList {
	[AS_event unpackResultAsListOfType: typeWildCard];
	return self;
}

- (id)returnListOfClass:(ASConstant *)classConstant {
	return [self returnListOfType: [classConstant AS_code]]; 
}

- (id)returnListOfType:(DescType)type {
	[AS_event unpackResultAsListOfType: type];
	return self;
}

- (id)returnDescriptor {
	[AS_event dontUnpackResult];
	return self;
}

- (id)sendWithError:(NSError **)error {
	NSAppleEventDescriptor *considerAndIgnoreDesc, *ignoreListDesc;
	// TO DO: if error occurs, return new NSError containing original NSError and description of this command
	// along with any other error info suitably formatted

	if (cachedError) {
		*error = cachedError;
		return nil;
	}
	// pack considering/ignoring attributes
	considerAndIgnoreDesc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: typeUInt32
																			 bytes: &considsAndIgnoresFlags
																			length: sizeof(considsAndIgnoresFlags)];
	[AS_event setAttribute: considerAndIgnoreDesc forKeyword: enumConsidsAndIgnores];
	[considerAndIgnoreDesc release];
	if (!defaultIgnore) {
		defaultIgnore = [[NSAppleEventDescriptor listDescriptor] retain];
		[defaultIgnore insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAECase] 
								atIndex: 0];
	}
	if (considsAndIgnoresFlags == kAECaseIgnoreMask) {
		[AS_event setAttribute: defaultIgnore forKeyword: enumConsiderations];
	} else {
		ignoreListDesc = [NSAppleEventDescriptor listDescriptor];
		if (!(considsAndIgnoresFlags && kAECaseConsiderMask))
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAECase] 
									 atIndex: 0];
		if (considsAndIgnoresFlags && kAEDiacriticIgnoreMask)
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAEDiacritic] 
									 atIndex: 0];
		if (considsAndIgnoresFlags && kAEWhiteSpaceIgnoreMask)
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAEWhiteSpace] 
									 atIndex: 0];
		if (considsAndIgnoresFlags && kAEHyphensIgnoreMask)
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAEHyphens] 
									 atIndex: 0];
		if (considsAndIgnoresFlags && kAEExpansionIgnoreMask)
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAEExpansion] 
									 atIndex: 0];
		if (considsAndIgnoresFlags && kAEPunctuationIgnoreMask)
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kAEPunctuation] 
									 atIndex: 0];
		if (considsAndIgnoresFlags && kASNumericStringsIgnoreMask)
			[ignoreListDesc insertDescriptor: [NSAppleEventDescriptor descriptorWithEnumCode: kASNumericStrings] 
									 atIndex: 0];
		[AS_event setAttribute: ignoreListDesc forKeyword: enumConsiderations];
	}
	// send event
	return [AS_event sendWithMode: sendMode timeout: timeout error: error];
}

- (id)send {
	return [self sendWithError: nil];
}

// display formatting

- (NSString *)AS_commandName {
	return [NSString stringWithFormat: @"<%@>", self];
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
	return [NSString stringWithFormat: @"<%@>", [AEMObjectRenderer formatOSType: code]];
}

- (NSString *)AS_formatObject:(id)obj appData:(id)appData {
	return [NSString stringWithFormat: @"<%@>", obj];
}

- (NSString *)description {
	NSAppleEventDescriptor *desc;
	NSString *result;
	DescType code;
	id value;
	int i;
	NSString *indent = @" ";
	
	id subjectAttr = [AS_event attributeForKeyword: keySubjectAttr];
	id directParam = [AS_event parameterForKeyword: keyDirectObject];
	if (subjectAttr && ![subjectAttr isEqual: [NSNull null]]) {
		result = [NSString stringWithFormat: @"[%@\n        %@: %@]", 
											subjectAttr, 
											[self AS_commandName], 
											[self AS_formatObject: directParam appData: [AS_event codecs]]];
		indent = @"\n                ";
	} else if ([directParam isKindOfClass: [ASReference class]])
		result = [NSString stringWithFormat: @"[%@\n        %@]", directParam, [self AS_commandName]];
	else if (directParam) {
		result = [NSString stringWithFormat: @"[%@\n        %@: %@]", 
											[self AS_formatObject: AEMApp appData: [AS_event codecs]], 
											[self AS_commandName], 
											[self AS_formatObject: directParam appData: [AS_event codecs]]];
		indent = @"\n                ";
	} else
		result = [NSString stringWithFormat: @"[%@\n        %@]", 
											[self AS_formatObject: AEMApp appData: [AS_event codecs]], 
											[self AS_commandName]];
	
	desc = [AS_event descriptor];	
	for (i = 1; i <= [desc numberOfItems]; i++) {
		code = [desc keywordForDescriptorAtIndex: i];
		value = [AS_event parameterForKeyword: code];
		switch (code) {
			case keyDirectObject:
				continue;
			case keyAERequestedType:
				result = [NSString stringWithFormat: @"[%@%@requestedClass: %@]", result, indent,
													[self AS_formatObject: value appData: [AS_event codecs]]];
				break;
			default:
				result = [NSString stringWithFormat: @"[%@%@%@: %@]", result, indent,
													[self AS_parameterNameForCode: code], 
													[self AS_formatObject: value appData: [AS_event codecs]]];
		}
		indent = @"\n                ";
	}
	
	// TO DO: format attributes
	return result;
}

@end

