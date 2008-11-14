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
	id target = [appData targetWithError: &targetError];
	if (!target) goto fail;
	// if an application specified by path has quit/restart, its AEAddressDesc is no longer valid;
	// this code will automatically restart it (or not) according to client-specified auto-relaunch policy
	ASRelaunchMode relaunchPolicy = [appData relaunchMode];
	if (relaunchPolicy != kASRelaunchNever && [target targetType] == kAEMTargetFileURL
			&& ![AEMApplication processExistsForPID: [[target descriptor] int32Value]]) {
		// TO DO: what, if any, other events should be allowed to relaunch app when kASRelaunchSpecial is used?
		if (relaunchPolicy == kASRelaunchAlways || classCode == kCoreEventClass && code == kAEOpenApplication) {
			BOOL success = [target reconnectWithError: &targetError];
			if (!success) goto fail;
		}
	}
	// create new AEMEvent instance
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
	return self;
fail:
	[targetError retain];
	return self;
}

- (void)dealloc {
	[AS_event release];
	[targetError release];
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
	[AS_event setUnpackFormat: kAEMUnpackAsItem type: type];
	return self;
}

- (id)returnList {
	[AS_event setUnpackFormat: kAEMUnpackAsList type: typeWildCard];
	return self;
}

- (id)returnListOfClass:(ASConstant *)classConstant {
	return [self returnListOfType: [classConstant AS_code]]; 
}

- (id)returnListOfType:(DescType)type {
	[AS_event setUnpackFormat: kAEMUnpackAsList type: type];
	return self;
}

- (id)returnDescriptor {
	[AS_event setUnpackFormat: kAEMDontUnpack type: typeWildCard];
	return self;
}

- (id)sendWithError:(out NSError **)error {
	NSAppleEventDescriptor *considerAndIgnoreDesc, *ignoreListDesc;
	NSMutableDictionary *userInfo;
	id result;
	NSError *eventError = nil;
	// TO DO: if error occurs, return new NSError containing original NSError and description of this command
	// along with any other error info suitably formatted
	
	if (error)
		*error = nil;
	if (targetError && error) {
		userInfo = [NSMutableDictionary dictionaryWithDictionary: [targetError userInfo]];
		[userInfo setObject: self forKey: kASErrorFailedEvent];
		*error = [NSError errorWithDomain: [targetError domain]
									 code: [targetError code]
								 userInfo: userInfo];
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
	result = [AS_event sendWithMode: sendMode timeout: timeout error: &eventError];
	if (eventError && error) {
		userInfo = [NSMutableDictionary dictionaryWithDictionary: [eventError userInfo]];
		[userInfo setObject: self forKey: kASErrorFailedEvent];
		*error = [NSError errorWithDomain: [eventError domain]
									 code: [eventError code]
								 userInfo: userInfo];
	}
	return result;
}

- (id)send {
	return [self sendWithError: nil];
}

// display formatting

- (NSString *)AS_commandName {
	return [NSString stringWithFormat: @"<%@%@>", 
			[AEMObjectRenderer formatOSType: [[AS_event attributeForKeyword: keyEventClassAttr] fourCharCode]],
			[AEMObjectRenderer formatOSType: [[AS_event attributeForKeyword: keyEventIDAttr] fourCharCode]]];
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
	return [NSString stringWithFormat: @"<%@>", [AEMObjectRenderer formatOSType: code]];
}

- (NSString *)AS_formatObject:(id)obj appData:(id)appData {
	return [AEMObjectRenderer formatObject: obj];
}


- (NSString *)description {
	NSAppleEventDescriptor *desc;
	NSString *result;
	DescType code;
	id value;
	int i;
	NSString *indent = @" ";
	AEMUnpackFormat format;
	DescType type;
	
	// format command target and direct parameter, if any
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
	// format keyword parameters
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
	// format attributes
	if (timeout != kAEDefaultTimeout)
		result = [NSString stringWithFormat: @"[%@ timeout: %i]", result, timeout / 60];
	if (sendMode != (kAEWaitReply | kAECanSwitchLayer)) {
		if (sendMode & ~(kAEWaitReply | kAEQueueReply | kAENoReply) == kAECanSwitchLayer) {
			if (sendMode & kAENoReply)
				result = [NSString stringWithFormat: @"[%@ ignoreReply]", result];
			if (sendMode & kAEQueueReply)
				result = [NSString stringWithFormat: @"[%@ queueReply]", result];
		} else
			result = [NSString stringWithFormat: @"[%@ sendMode: %#08x]", result, sendMode];
	}
	if (considsAndIgnoresFlags != kAECaseIgnoreMask)
		result = [NSString stringWithFormat: @"[%@ considering: %#08x]", result, considsAndIgnoresFlags];
	// format unpacking options
	[AS_event getUnpackFormat: &format type: &type];
	if (format == kAEMUnpackAsItem && type != typeWildCard)
			result = [NSString stringWithFormat: @"[%@ returnType: '%@']", 
												 result, [AEMObjectRenderer formatOSType: type]];
	if (format == kAEMUnpackAsList) {
			if (type == typeWildCard)
				result = [NSString stringWithFormat: @"[%@ returnList]", result];
			else
				result = [NSString stringWithFormat: @"[%@ returnListOfType: '%@']", 
													 result, [AEMObjectRenderer formatOSType: type]];
	} else if (format == kAEMDontUnpack)
			result = [NSString stringWithFormat: @"[%@ returnDescriptor]", result];
	
	return result;
}

@end


/**********************************************************************/


/*
 * improves formatting for getItem.../getList.../setItem...
 */
@implementation ASGetSetItemCommand

- (NSString *)AS_commandName {
    return ([[AS_event attributeForKeyword: keyEventIDAttr] fourCharCode] == kAEGetData) ? @"get" : @"set";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    return (code == keyAEData) ? @"to" : [super AS_parameterNameForCode: code];
}


@end
