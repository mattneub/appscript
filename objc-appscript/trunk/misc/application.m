//
//  application.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "application.h"

// TO DO: default error strings?


/**********************************************************************/


@implementation AEMEvent

- (id)initWithEvent:(AEDesc *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_ {
	self = [super init];
	if (!self) return self;
	event = event_;
	[codecs_ retain];
	codecs = codecs_;
	return self;
}

- (void)dealloc {
	AEDisposeDesc(event);
	[codecs release];
	[errorString release];
	[super dealloc];
}

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

// TO DO: if sending event fails, -send should return nil and error info should be available from AEMEvent instance via -errorNumber, -errorString, etc.; also provide -raise convenience method that will raise an NSException describing the error 

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks {
	AEDesc replyDesc;
	NSAppleEventDescriptor *replyData, *result;
	
	errorNumber = sendProc(event, &replyDesc, sendMode, timeoutInTicks);
	if (errorNumber) {
		[errorString release];
		errorString = nil;
		return nil; // clients should check return value to determine if event failed
	} else if (replyDesc.descriptorType != typeNull) {
		replyData = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &replyDesc];
		result = [replyData paramDescriptorForKeyword: keyErrorNumber];
		if (result) {
			errorNumber = (OSErr)[result int32Value];
			if (errorNumber) { // Some apps (e.g. Finder) may return noErr on success, so ignore that.
				[errorString release];
				errorString = [[replyData paramDescriptorForKeyword: keyErrorString] stringValue];
				[errorString retain];
				// TO DO: get any other error info
				[replyData release];
				return nil; // clients should check return value to determine if event failed
			}
		}
		result = [replyData paramDescriptorForKeyword: keyDirectObject];
		[replyData release];
		if (result) return [codecs unpack: result];
	}
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

// TO DO: +launch:, +isRunning:, -reconnect

@implementation AEMApplication

- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_ {
	self = [super init];
	if (!self) return self;
	// hooks
	createProc = AECreateAppleEvent;
	sendProc = AESendMessage;
	eventClass = [AEMEvent class];
	// description
	targetType = targetType_;
	[targetData_ retain];
	targetData = targetData_;
	// address desc
	switch (targetType) {
		case kAEMTargetFile:
			addressDesc = AEMAddressDescForLocalApplication(targetData);
			break;
		case kAEMTargetURL:
			addressDesc = AEMAddressDescForRemoteProcess(targetData);
			break;
		case kAEMTargetCurrent:
			addressDesc = AEMAddressDescForCurrentProcess();
			break;
		default:
			addressDesc = targetData;
	}
	[addressDesc retain];
	// misc
	defaultCodecs = [[AEMCodecs alloc] init];
	transactionID = kAnyTransactionID;
	return self;
}

- (id)init {
	return [self initWithTargetType: kAEMTargetCurrent data: nil];
}


- (id)initWithPath:(NSString *)path {
	return [self initWithURL: [NSURL fileURLWithPath: path]];	
}


- (id)initWithURL:(NSURL *)url {
	if ([url isFileURL])
		return [self initWithTargetType: kAEMTargetFile data: url];
	else
		return [self initWithTargetType: kAEMTargetURL data: url];
}


- (id)initWithPID:(pid_t)pid {
	return [self initWithTargetType: kAEMTargetPID data: AEMAddressDescForLocalProcess(pid)];
}


- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	return [self initWithTargetType: kAEMTargetDescriptor data: desc];
}


- (void)dealloc {
	[targetData release];
	[addressDesc release];
	[defaultCodecs release];
	[super dealloc];
}

// display

- (NSString *)description {
	return @"AEMApplication"; // TO DO
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

- (AEMEvent *)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID
						   codecs:(id)codecs {
	OSErr err;
	AEDesc event;
	
	err = createProc(classCode, code, [addressDesc aeDesc], returnID, transactionID, &event);
	if (err) return nil;
	return [[[AEMEvent alloc] initWithEvent: &event codecs: codecs sendProc: sendProc] autorelease];
}

- (AEMEvent *)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: returnID
							  codecs: defaultCodecs];
}

- (AEMEvent *)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						   codecs:(id)codecs {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: codecs];
}

- (AEMEvent *)eventWithEventClass:(AEEventClass)classCode
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
