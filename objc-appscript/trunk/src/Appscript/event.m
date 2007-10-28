//
//  event.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "event.h"


/**********************************************************************/


@implementation AEMEvent

/*
 * Note: new AEMEvent instances are constructed by AEMApplication objects; 
 * clients shouldn't instantiate this class directly.
 */
- (id)initWithEvent:(AppleEvent *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_ {
	self = [super init];
	if (!self) return self;
	event = event_; // take ownership of the Apple event AEDesc
	[codecs_ retain];
	codecs = codecs_;
	sendProc = sendProc_;
	requiredResultType = typeWildCard;
	return self;
}

- (void)dealloc {
	AEDisposeDesc(event);
	free(event);
	[codecs release];
	[errorString release];
	[super dealloc];
}

- (NSString *)description {
	OSStatus err;
	Handle h;
	NSString *result;
	
	err = AEPrintDescToHandle(event, &h);
	if (err) return [super description];
	result = [NSString stringWithFormat: @"<AEMEvent %s>", *h];
	DisposeHandle(h);
	return result;
}

// Access underlying AEDesc

- (const AppleEvent *)aeDesc {
	return event;
}


- (NSAppleEventDescriptor *)appleEventDescriptor {
	AppleEvent eventCopy;
	
	AEDuplicateDesc(event, &eventCopy);
	return [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &eventCopy] autorelease];
}

// Pack event's attributes and parameters, if any.

// TO DO: these methods may need to check for nil values to protect against crashes (need to investigate further)

- (AEMEvent *)setAttributePtr:(void *)dataPtr 
				 size:(Size)dataSize
	   descriptorType:(DescType)typeCode
		   forKeyword:(AEKeyword)key {
	OSErr err = AEPutAttributePtr(event, key, typeCode, dataPtr, dataSize);
	return err ? nil : self;
}

- (AEMEvent *)setParameterPtr:(void *)dataPtr 
				 size:(Size)dataSize
	   descriptorType:(DescType)typeCode
		   forKeyword:(AEKeyword)key {
	OSErr err = AEPutParamPtr(event, key, typeCode, dataPtr, dataSize);
	return err ? nil : self;
}

- (AEMEvent *)setAttribute:(id)value forKeyword:(AEKeyword)key {
	OSErr err = AEPutAttributeDesc(event, key, [[codecs pack: value] aeDesc]);
	return err ? nil : self;
}

- (AEMEvent *)setParameter:(id)value forKeyword:(AEKeyword)key {
	OSErr err = AEPutParamDesc(event, key, [[codecs pack: value] aeDesc]);
	return err ? nil : self;
}

- (AEMEvent *)setResultType:(DescType)type {
	requiredResultType = type;
	return self;
}

/*
 * Send event.
 *
 * (-send, -sendWithMode:, -sendWithTimeout: are convenience shortcuts for -sendWithMode:timeout:)
 *
 * (Note: a single event can be sent multiple times if desired.)
 *
 * (Note: if an Apple Event Manager/application error occurs, these methods will return nil.
 * Clients should test for this, then use the -errorNumber and -errorString methods to
 * retrieve the error description.
 */

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks {
	OSErr err;
	AEDesc replyDesc = {typeNull, NULL};
	AEDesc classDesc, idDesc;
	OSType classCode, idCode;
	NSAppleEventDescriptor *replyData, *errorNumberDesc, *errorStringDesc, *result;
	
	// clear any previous error info
	errorNumber = noErr;
	if (errorString) {
		[errorString release];
		errorString = nil;
	}
	// send event
	errorNumber = sendProc(event, &replyDesc, sendMode, timeoutInTicks);
	if (errorNumber) {
		// ignore errors caused by application quitting normally after being sent a quit event
		if (errorNumber == connectionInvalid) {
			err = AEGetAttributeDesc(event, keyEventClassAttr, typeType, &classDesc);
			if (!err) return nil;
			err = AEGetDescData(&classDesc, &classCode, sizeof(classCode));
			AEDisposeDesc(&classDesc);
			if (!err) return nil;
			err = AEGetAttributeDesc(event, keyEventIDAttr, typeType, &idDesc);
			if (!err) return nil;
			err = AEGetDescData(&idDesc, &idCode, sizeof(idCode));
			AEDisposeDesc(&idDesc);
			if (!err) return nil;
			if (classCode == kCoreEventClass && idCode == kAEQuitApplication) {
				errorNumber = noErr;
				return [NSNull null];
			}
		}
		// for any other Apple Event Manager errors, set error condition and return nil
		return nil; // note: clients should check if return value is nil to determine if event failed
	}
	// extract reply data, if any
	if (replyDesc.descriptorType != typeNull) {
		replyData = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &replyDesc];
		// if application returned an error, set error condition and return nil
		errorNumberDesc = [replyData paramDescriptorForKeyword: keyErrorNumber];
		errorStringDesc = [replyData paramDescriptorForKeyword: keyErrorString];
		if (errorNumberDesc || errorStringDesc) {
			if (errorNumberDesc)
				errorNumber = (OSErr)[errorNumberDesc int32Value];
			if (errorStringDesc)
				errorString = [[errorStringDesc stringValue] retain];
			if (errorNumber || errorString) { // Some apps (e.g. Finder) may return noErr on success, so ignore that
				// TO DO: get any other error info
				if (!errorNumber)
					errorNumber = errOSAGeneralError; // if only error string was given, set error number
				[replyData release];
				return nil; // note: clients should check if return value is nil to determine if event failed
			}
		}
		// if application returned a result, unpack and return it
		result = [replyData paramDescriptorForKeyword: keyAEResult];
		[replyData release];
		if (requiredResultType != typeWildCard && [result descriptorType] != requiredResultType) {
			result = [result coerceToDescriptorType: requiredResultType];
			if (!result) {
				errorNumber = errAECoercionFail;
				return nil; // note: clients should check if return value is nil to determine if event failed
			}
		}
		if (result) return [codecs unpack: result];
	}
	// application didn't return anything
	return [NSNull null];
}

- (id)sendWithTimeout:(long)timeoutInTicks {
	return [self sendWithMode: kAEWaitReply timeout: timeoutInTicks];
}

- (id)sendWithMode:(AESendMode)sendMode {
	return [self sendWithMode: sendMode timeout: kAEDefaultTimeout];
}

- (id)send {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout];
}

// Error reporting.

- (OSErr)errorNumber {
	return errorNumber;
}

- (NSString *)errorString {
	if (errorNumber)
		return errorString;
	else
		return nil;
}

- (void)raise {
	if (errorNumber)
		[NSException raise: @"AEMEventSendError"
					format: @"%@ (%i)", errorString, errorNumber];
}

@end
