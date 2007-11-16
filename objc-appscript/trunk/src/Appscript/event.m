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

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks error:(NSError **)error {
	OSErr err, errorNumber;
	NSString *errorString;
	NSDictionary *errorInfo;
	AEDesc replyDesc = {typeNull, NULL};
	AEDesc classDesc, idDesc;
	OSType classCode, idCode;
	NSAppleEventDescriptor *replyData, *result;

	if (error)
		*error = nil;
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
			if (classCode == kCoreEventClass && idCode == kAEQuitApplication)
				return [NSNull null];
		}
		// for any other Apple Event Manager errors, set error condition and return nil
		if (error) {
			// TO DO: include a nicely-formatted representation of this Apple event
			errorString = [NSString stringWithFormat: @"Apple Event Manager error (%i)", errorNumber];
			errorInfo = [NSDictionary dictionaryWithObject: errorString forKey: NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain: @"NSOSStatusErrorDomain" code: errorNumber userInfo: errorInfo];
		}
		return nil; // note: clients should check if return value is nil to determine if event failed
	}
	// extract reply data, if any
	if (replyDesc.descriptorType != typeNull) {
		replyData = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &replyDesc];
		// if application returned an error, set error condition if required and return nil
		/*
			note: Apple spec says that both errn and errs parameters should be checked to determine if an error
			 occurred; however, AppleScript only checks for a errn so we copy its behaviour for compatibility.
			
			Note: some apps (e.g. Finder) may return noErr on success, so ignore that too.
		*/
		errorNumber = (OSErr)[[replyData paramDescriptorForKeyword: keyErrorNumber] int32Value];
		if (errorNumber) {
			if (error) {
				// TO DO: get any other error info
				// TO DO: include a nicely-formatted representation of this Apple event
				errorString = [[replyData paramDescriptorForKeyword: keyErrorString] stringValue];
				if (!errorString)
					errorString = [NSString stringWithFormat: @"Application error (%i)", errorNumber];
				errorInfo = [NSDictionary dictionaryWithObject: errorString forKey: NSLocalizedDescriptionKey];
				*error = [NSError errorWithDomain: @"NSOSStatusErrorDomain" code: errorNumber userInfo: errorInfo];
			}
			[replyData release];
			return nil; // note: clients should check if return value is nil to determine if event failed
		}
		// if application returned a result, unpack and return it
		result = [replyData paramDescriptorForKeyword: keyAEResult];
		[replyData release];
		if (requiredResultType != typeWildCard && [result descriptorType] != requiredResultType) {
			result = [result coerceToDescriptorType: requiredResultType];
			if (!result) {
				// TO DO: include a nicely-formatted representation of this Apple event
				errorNumber = errAECoercionFail;
				errorString = [NSString stringWithFormat: @"Result coercion error (%i)", errorNumber];
				errorInfo = [NSDictionary dictionaryWithObject: errorString forKey: NSLocalizedDescriptionKey];
				*error = [NSError errorWithDomain: @"NSOSStatusErrorDomain" code: errorNumber userInfo: errorInfo];
				return nil; // note: clients should check if return value is nil to determine if event failed
			}
		}
		if (result) return [codecs unpack: result];
	}
	// application didn't return anything
	return [NSNull null];
}

- (id)sendWithError:(NSError **)error {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout error: error];
}

- (id)send {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout error: nil];
}

@end
