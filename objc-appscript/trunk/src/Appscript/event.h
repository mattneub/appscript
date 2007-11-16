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
 
 * Parameters
 *
 * sendMode
 *    kAEWaitReply
 *
 * timeoutInTicks
 *    kAEDefaultTimeout
 *
 * error
 *    On return, an NSError object that describes an Apple Event Manager or application
 *    error if one has occurred, otherwise nil. Pass nil if not required.
 *
 * Return value
 *
 *    The value returned by the application, or an NSNull instance if no value was returned,
 *    or nil if an error occurred.
 *
 * Notes
 *
 *    A single event can be sent more than once if desired.
 *
 */

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks error:(NSError **)error;

- (id)sendWithError:(NSError **)error;

- (id)send; // TO DO: delete?

@end

