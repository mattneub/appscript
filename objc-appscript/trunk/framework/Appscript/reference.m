//
//  reference.m
//  appscript
//
//  Copyright (C) 2007 HAS
//

#import "reference.h"


/**********************************************************************/


@implementation ASAppData

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data {
	self = [super init];
	if (!self) return self;
	aemApplicationClass = appClass;
	targetType = type;
	targetData = [data retain];
	return self;
}

- (void)dealloc {
	[targetData release];
	[target release];
	[super dealloc];
}

- (void)connect {
	switch (targetType) {
		case kASTargetCurrent:
			target = [[aemApplicationClass alloc] init];
		case kASTargetName:
			target = [[aemApplicationClass alloc] initWithURL: AEMFindAppWithName(targetData)];
		case kASTargetPath:
			target = [[aemApplicationClass alloc] initWithPath: targetData];
		case kASTargetURL:
			target = [[aemApplicationClass alloc] initWithURL: targetData];
		case kASTargetPID:
			target = [[aemApplicationClass alloc] initWithPID: [targetData unsignedLongValue]];
		case kASTargetDescriptor:
			target = [[aemApplicationClass alloc] initWithDescriptor: targetData];
	}
}

- (id)target { // returns AEMApplication instance or equivalent
	if (!target)
		[self connect];
	return target;
}

// TO DO: override various pack..., unpack... methods

- (NSAppleEventDescriptor *)pack:(id)object {
	if ([object isKindOfClass: [ASReference class]])
		return [[object AS_aemReference] packSelf: self]; // TO DO: this won't work for dynamic
	else if ([object isKindOfClass: [ASConstant class]])
		return [object desc]; // TO DO: this won't work for dynamic
	else
		return [super pack: object];
}

- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc {
	return desc; // TO DO: return TEReference
}

@end


/**********************************************************************/


@implementation ASConstant

- (id)initWithName:(NSString *)name_ descriptor:(NSAppleEventDescriptor *)desc_ {
	self = [super init];
	if (!self) return self;
	name = [name_ retain];
	desc = [desc_ retain];
	return self;
}

- (void)dealloc {
	[name release];
	[desc release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"[%@ %@]", [self class], name];
}

// TO DO: hash, isEqual

- (NSString *)name {
	return name;
}

- (OSType)code {
	return [desc typeCodeValue];
}

- (NSAppleEventDescriptor *)desc {
	return desc;
}

@end


/**********************************************************************/


@implementation ASCommand

// note: current design doesn't support returnID (TO DO: see if returnID attribute can be set later)

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
	  
	sendMode = kAEWaitReply + kAECanSwitchLayer;
	AS_event = [[appData target] eventWithEventClass: classCode
											 eventID: code
											  codecs: appData];
	if (directParameter)
		[AS_event setParameter: directParameter forKeyword: keyDirectObject];
	// TO DO: any additional special cases?
	if (parentReference) {
		if (directParameter)
			[AS_event setAttribute: parentReference forKeyword: keySubjectAttr];
		else
			[AS_event setParameter: parentReference forKeyword: keyDirectObject];
	}
	return self;
}

- (id)send {
	return [self sendWithTimeout: kAEDefaultTimeout];
}

- (id)sendWithTimeout:(int)timeout {
	return [AS_event sendWithMode: sendMode timeout: timeout];
}

- (OSErr)errorNumber {
	return [AS_event errorNumber];
}

- (NSString *)errorString {
	return [AS_event errorString];
}

- (void)raise {
	[AS_event raise];
}

// TO DO: attribute methods

@end


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

// TO DO: hash, isEqual

- (id)AS_appData {
	return AS_appData;
}

- (id)AS_aemReference {
	return AS_aemReference;
}

- (NSString *)description {
	return [NSString stringWithFormat: @"<ASReference %@>", AS_aemReference]; // TO DO: finish
}

@end