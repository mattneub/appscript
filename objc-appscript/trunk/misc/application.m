//
//  application.m
//  Copyright (C) 2007 HAS
//

#import "application.h"


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
	[super dealloc];
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
	OSStatus err;
	AEDesc replyDesc;
	NSAppleEventDescriptor *replyData, *result;
	
	err = sendProc(event, &replyDesc, sendMode, timeoutInTicks);
	if (err) {
		// TO DO: better error handling/reporting system
		return nil;
	} else {
		replyData = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &replyDesc];
		result = [replyData paramDescriptorForKeyword: keyErrorNumber];
		if (result) {
			// TO DO: get any other error info
			[replyData release];
			// TO DO: better error handling/reporting system
			return nil;
		} else {
			result = [replyData paramDescriptorForKeyword: keyDirectObject];
			[replyData release];
			if (result) return [codecs unpack: result];
		}
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

@end


/**********************************************************************/

// TO DO: +launch:, +isRunning:, -reconnect

@implementation AEMApplication

- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_ {
	self = [super init];
	if (!self) return self;
	targetType = targetType_;
	[targetData_ retain];
	targetData = targetData_;
	createProc = AECreateAppleEvent;
	sendProc = AESendMessage;
	return self;
}

- (id)init {
	return nil;
}

- (id)initWithPath:(NSString *)path {
	return nil;
}

- (id)initWithURL:(NSString *)url {
	return nil;
}

- (id)initWithPID:(long)pid {
	return nil;
}

- (void)setCreateProc:(AEMCreateProcPtr)createProc_ {

}

- (void)setSendProc:(AEMSendProcPtr)sendProc_ {
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	return nil;
}

- (AEMEvent *)eventWithClass:(AEEventClass)classCode
						  id:(AEEventID)code {
	return nil;
}

- (AEMEvent *)eventWithClass:(AEEventClass)classCode
						  id:(AEEventID)code
					  codecs:(id)codecs {
	return nil;
}

- (void)startTransaction {
}

- (void)startTransactionWithSession:(id)session {
}

- (void)endTransaction {
}

- (void)abortTransaction {
}
@end
