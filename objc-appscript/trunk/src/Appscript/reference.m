//
//  reference.m
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "reference.h"


/**********************************************************************/


@implementation ASAppData

- (id)initWithApplicationClass:(Class)appClass
				 constantClass:(Class)constClass
				referenceClass:(Class)refClass
					targetType:(ASTargetType)type
					targetData:(id)data {
	self = [super init];
	if (!self) return self;
	aemApplicationClass = appClass;
	constantClass = constClass;
	referenceClass = refClass;
	targetType = type;
	targetData = [data retain];
	target = nil;
	return self;
}

- (void)dealloc {
	[targetData release];
	[target release];
	[super dealloc];
}

- (BOOL)connectWithError:(NSError **)error {
	if (target) {
		[target release];
		target = nil;
	}
	switch (targetType) {
		case kASTargetCurrent:
			target = [[aemApplicationClass alloc] init];
			break;
		case kASTargetName:
			target = [[aemApplicationClass alloc] initWithName: targetData error: error];
			break;
		case kASTargetBundleID:
			target = [[aemApplicationClass alloc] initWithBundleID: targetData error: error];
			break;
		case kASTargetURL:
			target = [[aemApplicationClass alloc] initWithURL: targetData error: error];
			break;
		case kASTargetPID:
			target = [[aemApplicationClass alloc] initWithPID: [targetData unsignedLongValue]];
			break;
		case kASTargetDescriptor:
			target = [[aemApplicationClass alloc] initWithDescriptor: targetData];
	}
	return target != nil;
}

- (id)targetWithError:(NSError **)error { // returns AEMApplication instance or equivalent
	if (!target && ![self connectWithError: error]) return nil;
	return target;
}

- (BOOL)isRunning {
	NSURL *url;
	BOOL result;
	
	switch (targetType) {
		case kASTargetName:
			url = [AEMApplication findApplicationForName: targetData error: nil];
			result = [AEMApplication processExistsForFileURL: url];
			break;
		case kASTargetBundleID:
			url = [AEMApplication findApplicationForCreator: kLSUnknownCreator bundleID: targetData name: nil error: nil];
			result = [AEMApplication processExistsForFileURL: url];
			break;
		case kASTargetURL:
			if ([targetData isFileURL])
				result = [AEMApplication processExistsForFileURL: targetData];
			 else
				result = [AEMApplication processExistsForEppcURL: targetData];
			break;
		case kASTargetPID:
			result = [AEMApplication processExistsForPID: [targetData unsignedLongValue]];
			break;
		case kASTargetDescriptor:
			result = [AEMApplication processExistsForDescriptor: targetData];
			break;
		default: // kASTargetCurrent
			result = YES;
	}
	return result;
}

- (BOOL)launchApplicationWithError:(NSError **)error {
	NSURL *fileURL = nil;
	AEMApplication *app;
	NSError *err;
	
	if (!error) error = &err;
	*error = nil;
	switch (targetType) {
		case kASTargetName:
			fileURL = [AEMApplication findApplicationForName: targetData error: nil];
			break;
		case kASTargetBundleID:
			fileURL = [AEMApplication findApplicationForCreator: kLSUnknownCreator bundleID: targetData name: nil error: nil];
			break;
		case kASTargetURL:
			if ([targetData isFileURL])
				fileURL = targetData;
	}
	if (fileURL) {
		[AEMApplication launchApplication: fileURL error: error];
		if (!*error) {
			app = [self targetWithError: error];
			[app reconnectWithError: error];
			return (!*error);
		}	
	} else { // will send 'launch' event to app; if app is not already running, an error will occur
		app = [self targetWithError: error];
		if (!app) return NO;
		[[app eventWithEventClass: 'ascr' eventID: 'noop'] sendWithError: error];
		if ([*error code] == -1708) { // 'event not handled' error is normal for 'launch' events, so ignore it
			*error = nil;
			return YES;
		}
	}
	return NO;
}


// override pack, various unpack methods

- (NSAppleEventDescriptor *)pack:(id)object {
	if ([object isKindOfClass: [ASReference class]])
		return [object AS_packSelf: self];
	else if ([object isKindOfClass: [ASConstant class]])
		return [object AS_packSelf: self];
	else
		return [super pack: object];
}

- (id)unpackAERecordKey:(AEKeyword)key {
	return [constantClass constantWithCode: key];
}

- (id)unpackType:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc typeCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackEnum:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc enumCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackProperty:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc typeCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackKeyword:(NSAppleEventDescriptor *)desc {
	id result;
	
	result = [constantClass constantWithCode: [desc typeCodeValue]];
	if (!result)
		result = [super unpackType: desc];
	return result;
}

- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc {
	return [referenceClass referenceWithAppData: self
								aemReference: [super unpackObjectSpecifier: desc]];
}

- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc {
	return [referenceClass referenceWithAppData: self
								aemReference: [super unpackInsertionLoc: desc]];
}

- (id)unpackContainsCompDescriptorWithOperand1:(id)op1 operand2:(id)op2 {
	if ([op1 isKindOfClass: [ASReference class]] && [[[op1 AS_aemReference] root] isEqual: AEMIts])
		return [op1 contains: op2];
	else
		return [super unpackContainsCompDescriptorWithOperand1: op1 operand2: op2];
}

@end


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

