//
//  event.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "codecs.h"
#import "connect.h"
#import "SendThreadSafe.h"


/**********************************************************************/
// typedefs

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
	kAEMTargetCurrent,
	kAEMTargetFileURL,
	kAEMTargetEppcURL,
	kAEMTargetPID,
	kAEMTargetDescriptor,
} AEMTargetType;


/**********************************************************************/
// Forward declarations

@class AEMEvent;


/**********************************************************************/
// Event class
/*
 * Note: clients shouldn't instantiate this directly; instead use AEMApplication methods.
 */

@interface AEMEvent : NSObject {
	AEDesc *event;
	id codecs;
	AEMSendProcPtr sendProc;
	// type to coerce returned value to before unpacking it
	DescType requiredResultType;
	// error info
	OSErr errorNumber;
	NSString *errorString;
}

/*
 * Note: new AEMEvent instances are constructed by AEMApplication objects; 
 * clients shouldn't instantiate this class directly.
 */

- (id)initWithEvent:(AppleEvent *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_;

/*
 * Get a pointer to the AEDesc contained by this AEMEvent instance
 */
- (const AppleEvent *)aeDesc;

/*
 * Get an NSAppleEventDescriptor instance containing a copy of this event
 */
- (NSAppleEventDescriptor *)appleEventDescriptor;

// Pack event's attributes and parameters, if any.

- (AEMEvent *)setAttributePtr:(void *)dataPtr 
						 size:(Size)dataSize
			   descriptorType:(DescType)typeCode
				   forKeyword:(AEKeyword)key;

- (AEMEvent *)setParameterPtr:(void *)dataPtr 
						 size:(Size)dataSize
			   descriptorType:(DescType)typeCode
				   forKeyword:(AEKeyword)key;

- (AEMEvent *)setAttribute:(id)value forKeyword:(AEKeyword)key;

- (AEMEvent *)setParameter:(id)value forKeyword:(AEKeyword)key;

// Specify an AE type to coerce the reply descriptor to before unpacking it.

- (AEMEvent *)setResultType:(DescType)type;

/*
 * Send event.
 *
 * (Note: a single event can be sent multiple times if desired.)
 *
 * (Note: if an Apple Event Manager/application error occurs, these methods will return nil.
 * Clients should test for this, then use the -errorNumber and -errorString methods to
 * retrieve the error description.
 */

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks;

- (id)sendWithTimeout:(long)timeoutInTicks;

- (id)sendWithMode:(AESendMode)sendMode;

- (id)send;

/*
 * Get error information for last event sent, assuming it failed.
 */ 

- (OSErr)errorNumber;

- (NSString *)errorString;

/*
 * Convenience method for raising an exception containing error information
 * for last event sent, assuming it failed.
 */

- (void)raise;

@end

