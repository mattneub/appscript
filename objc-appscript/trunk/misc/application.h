//
//  application.h
//  Copyright (C) 2007 HAS
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "codecs.m"


/**********************************************************************/


typedef OSErr(*AEMCreateProcPtr)(AEEventClass theAEEventClass,
							     AEEventID theAEEventID,
							     const AEAddressDesc *target,
							     AEReturnID returnID,
							     AETransactionID transactionID,
							     AppleEvent *result);


typedef OSStatus(*AEMSendProcPtr)(const AppleEvent *event,
								  AppleEvent *reply,
								  AESendMode sendMode,
								  long timeOutInTicks);


typedef enum {
	kPath,
	kPID,
	kURL,
	kDesc,
	kCurrent
} AEMTargetType;


/**********************************************************************/

// TO DO: returnID support

@interface AEMEvent : NSObject {
	AEDesc *event;
	id codecs;
	AEMSendProcPtr sendProc;
}

- (id)initWithEvent:(AEDesc *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_;

// setAttributePtr:(void *)ptr forKeyword:(AEKeyword)key;

// setParameterPtr:(void *)ptr forKeyword:(AEKeyword)key;

- (id)setAttribute:(id)value forKeyword:(AEKeyword)key;

- (id)setParameter:(id)value forKeyword:(AEKeyword)key;

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks;

- (id)sendWithTimeout:(long)timeoutInTicks;

- (id)sendWithMode:(AESendMode)sendMode;

- (id)send;

@end


/**********************************************************************/


@interface AEMApplication : NSObject {
	AEMTargetType targetType;
	id targetData;
	
	AETransactionID transactionID;
	NSAppleEventDescriptor *addressDesc;
	
	AEMCreateProcPtr createProc;
	AEMSendProcPtr sendProc;
}

- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_;

- (id)initWithPath:(NSString *)path;

- (id)initWithURL:(NSString *)url;

- (id)initWithPID:(long)pid;

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;

- (void)setCreateProc:(AEMCreateProcPtr)createProc_;

- (void)setSendProc:(AEMSendProcPtr)sendProc_;

- (AEMEvent *)eventWithClass:(AEEventClass)classCode
						  id:(AEEventID)code;

- (AEMEvent *)eventWithClass:(AEEventClass)classCode
						  id:(AEEventID)code
					  codecs:(id)codecs;

- (void)startTransaction;

- (void)startTransactionWithSession:(id)session;

- (void)endTransaction;

- (void)abortTransaction;
@end
