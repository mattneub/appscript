//
//  appdata.m
//  Appscript
//
//  Copyright (C) 2008 HAS
//

#import "appdata.h"


/**********************************************************************/


@implementation ASAppDataBase

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data {
	self = [super init];
	if (!self) return self;
	aemApplicationClass = appClass;
	targetType = type;
	targetData = [data retain];
	target = nil;
	[self setRelaunchMode: kASRelaunchSpecial];
	return self;
}

- (void)dealloc {
	[targetData release];
	[target release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	ASAppDataBase *obj = [super copyWithZone: zone];
	if (!obj) return obj;
	[obj->targetData retain];
	[obj->target retain];
	return obj;
}

- (BOOL)connectWithError:(out NSError **)error {
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

- (id)targetWithError:(out NSError **)error { // returns AEMApplication instance or equivalent
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

- (BOOL)launchApplicationWithError:(out NSError **)error {
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

- (void)setRelaunchMode:(ASRelaunchMode)relaunchMode_ {
	relaunchMode = relaunchMode_;
}

- (ASRelaunchMode)relaunchMode {
	return relaunchMode;
}

@end


/**********************************************************************/


@implementation ASAppData

- (id)initWithApplicationClass:(Class)appClass
				 constantClass:(Class)constClass
				referenceClass:(Class)refClass
					targetType:(ASTargetType)type
					targetData:(id)data {
	self = [super initWithApplicationClass: appClass targetType: type targetData: data];
	if (!self) return self;
	constantClass = constClass;
	referenceClass = refClass;
	return self;
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

