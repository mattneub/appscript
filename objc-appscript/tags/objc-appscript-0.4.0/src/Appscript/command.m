//
//  command.m
//  Appscript
//
//  Copyright (C) 2007-2008 HAS
//

#import "command.h"


/**********************************************************************/


@implementation ASCommand

// note: current design doesn't support returnID; not sure how best to implement this

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
	// TO DO: better error reporting when getting target fails
	// e.g. could stow NSError and return it when -sendWithError: is invoked
	AS_event = [[appData targetWithError: nil] eventWithEventClass: classCode
														   eventID: code
															codecs: appData];
	if (!AS_event) return nil;
	[AS_event retain];
	if (directParameter)
		if (![AS_event setParameter: directParameter forKeyword: keyDirectObject]) return nil;
	if (parentReference)
		if (directParameter) {
			if (![AS_event setAttribute: parentReference forKeyword: keySubjectAttr]) return nil;
		} else {
			if (![AS_event setParameter: parentReference forKeyword: keyDirectObject]) return nil;
		}
	return self;
}

- (void)dealloc {
	[AS_event release];
	[super dealloc];
}

- (AEMEvent *)AS_aemEvent {
	return AS_event;
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

- (id)requestedType:(ASConstant *)type {
	if (![AS_event setParameter: type forKeyword: keyAERequestedType]) return nil;
	return self;
}

- (id)returnType:(DescType)type {
	[AS_event unpackResultAsType: type];
	return self;
}

- (id)returnList {
	[AS_event unpackResultAsType: typeAEList];
	return self;
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
	return [AS_event sendWithMode: sendMode timeout: timeout error: error];
}

- (id)send {
	return [self sendWithError: nil];
}

// TO DO: attribute methods

@end

