//
//  application.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "application.h"

// TO DO: default error message strings?
// TO DO: convenience wrappers for AEMLaunchApplication:
//				AEMLaunchApp, AEMRunApp, AEMOpenFilesWithApp


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

- (id)setAttributePtr:(void *)dataPtr 
				 size:(Size)dataSize
	   descriptorType:(DescType)typeCode
		   forKeyword:(AEKeyword)key {
	OSErr err = AEPutAttributePtr(event, key, typeCode, dataPtr, dataSize);
	return err ? nil : self;
}

- (id)setParameterPtr:(void *)dataPtr 
				 size:(Size)dataSize
	   descriptorType:(DescType)typeCode
		   forKeyword:(AEKeyword)key {
	OSErr err = AEPutParamPtr(event, key, typeCode, dataPtr, dataSize);
	return err ? nil : self;
}

- (id)setAttribute:(id)value forKeyword:(AEKeyword)key {
	OSErr err = AEPutAttributeDesc(event, key, [[codecs pack: value] aeDesc]);
	return err ? nil : self;
}

- (id)setParameter:(id)value forKeyword:(AEKeyword)key {
	OSErr err = AEPutParamDesc(event, key, [[codecs pack: value] aeDesc]);
	return err ? nil : self;
}

- (id)setResultType:(DescType)type {
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


/**********************************************************************/

// TO DO: -reconnect

@implementation AEMApplication

// clients shouldn't call this initializer directly; use one of the methods below
- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_ {
	if (!targetData_) return nil;
	self = [super init];
	if (!self) return self;
	// hooks
	createProc = AECreateAppleEvent;
	sendProc = AESendMessage;
	eventClass = [AEMEvent class];
	// description
	targetType = targetType_;
	targetData = targetData_;
	// address desc
	switch (targetType) {
		case kAEMTargetFileURL:
			addressDesc = AEMAddressDescForLocalApplication(targetData);
			break;
		case kAEMTargetEppcURL:
			addressDesc = AEMAddressDescForRemoteProcess(targetData);
			break;
		case kAEMTargetCurrent:
			addressDesc = AEMAddressDescForCurrentProcess();
			break;
		default:
			addressDesc = targetData;
	}
	if (!addressDesc) return nil;
	[targetData_ retain];
	[addressDesc retain];
	// misc
	defaultCodecs = [[AEMCodecs alloc] init];
	transactionID = kAnyTransactionID;
	return self;
}

// initializers

- (id)init {
	return [self initWithTargetType: kAEMTargetCurrent data: [NSNull null]];
}

- (id)initWithName:(NSString *)name {
	return [self initWithTargetType: kAEMTargetFileURL data: AEMFindAppWithName(name)];
}

- (id)initWithPath:(NSString *)path {
	return [self initWithTargetType: kAEMTargetFileURL data: [NSURL fileURLWithPath: path]];	
}

- (id)initWithURL:(NSURL *)url {
	if ([url isFileURL])
		return [self initWithTargetType: kAEMTargetFileURL data: url];
	else
		return [self initWithTargetType: kAEMTargetEppcURL data: url];
}

- (id)initWithPID:(pid_t)pid {
	return [self initWithTargetType: kAEMTargetPID data: AEMAddressDescForLocalProcess(pid)];
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	return [self initWithTargetType: kAEMTargetDescriptor data: desc];
}

// dealloc

- (void)dealloc {
	[targetData release];
	[addressDesc release];
	[defaultCodecs release];
	[super dealloc];
}

// display

- (NSString *)description {
	pid_t pid;
	switch (targetType) {
		case kAEMTargetFileURL:
		case kAEMTargetEppcURL:
			return [NSString stringWithFormat: @"<AEMApplication url=%@>", targetData];
		case kAEMTargetPID:
			[[addressDesc data] getBytes: &pid length: sizeof(pid_t)];
			return [NSString stringWithFormat: @"<AEMApplication pid=%i>", pid];
		case kAEMTargetCurrent:
			return @"<AEMApplication current>";
		default:
			return [NSString stringWithFormat: @"<AEMApplication desc=%@>", addressDesc];
	}
}

// clients can call following methods to modify standard create/send behaviours

- (void)setCreateProc:(AEMCreateProcPtr)createProc_ {
	createProc = createProc_;
}

- (void)setSendProc:(AEMSendProcPtr)sendProc_ {
	sendProc = sendProc_;
}

- (void)setEventClass:(Class)eventClass_ {
	eventClass = eventClass_;
}

// create new AEMEvent object

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID
						   codecs:(id)codecs {
	OSErr err;
	AppleEvent *appleEvent;
	
	appleEvent = malloc(sizeof(AEDesc));
	if (!appleEvent) return nil;
	err = createProc(classCode, code, [addressDesc aeDesc], returnID, transactionID, appleEvent);
	if (err) return nil;
	return [[[eventClass alloc] initWithEvent: appleEvent
									 codecs: codecs 
								   sendProc: sendProc] autorelease];
}

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: returnID
							  codecs: defaultCodecs];
}

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						   codecs:(id)codecs {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: codecs];
}

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: defaultCodecs];
}


//

- (BOOL)reconnect {
	return NO; // TO DO
}

// transaction support // TO DO

- (void)startTransaction {
}

- (void)startTransactionWithSession:(id)session {
}

- (void)endTransaction {
}

- (void)abortTransaction {
}

@end
