//
//  event.h
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "codecs.h"
#import "sendthreadsafe.h"
#import "utils.h"


/**********************************************************************/
// NSError constants

NSString *kAEMErrorDomain; // @"net.sourceforge.appscript.objc-appscript.ErrorDomain"; domain name for NSErrors returned by appscript

/*
 * -sendWithError: will return an NSError containing error code, localized description, and a userInfo dictionary
 * containing kAEMErrorNumberKey (this has the same value as -[NSError code]) and zero or more other keys:
 */

NSString *kAEMErrorNumberKey;			// @"ErrorNumber"; error number returned by Apple Event Manager or application
NSString *kAEMErrorStringKey;			// @"ErrorString"; error string returned by application, if given
NSString *kAEMErrorBriefMessageKey;		// @"ErrorBriefMessage"; brief error string returned by application, if given
NSString *kAEMErrorExpectedTypeKey;		// @"ErrorExpectedType"; AE type responsible for a coercion error (-1700), if given
NSString *kAEMErrorOffendingObjectKey;	// @"ErrorOffendingObject"; value or object specifer responsible for error, if given
NSString *kAEMErrorFailedEvent;			// @"ErrorFailedEvent"; the AEMEvent object that returned the error


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


/**********************************************************************/
// Forward declarations

@class AEMEvent;


/**********************************************************************/
// Event class
/*
 * Note: clients shouldn't instantiate AEMEvent directly; instead use AEMApplication -eventWith... methods.
 */

@interface AEMEvent : NSObject {
	AppleEvent *event;
	id codecs;
	AEMSendProcPtr sendProc;
	// type to coerce returned value to before unpacking it
	DescType resultType;
	BOOL isResultList, shouldUnpackResult;
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

- (AEMEvent *)setAttribute:(id)value forKeyword:(AEKeyword)key;

- (AEMEvent *)setParameter:(id)value forKeyword:(AEKeyword)key;

// Get/remove event's attributes and parameters.

- (id)attributeForKeyword:(AEKeyword)key;

- (id)parameterForKeyword:(AEKeyword)key;

- (AEMEvent *)removeParameterForKeyword:(AEKeyword)key;

// Specify an AE type to coerce the reply descriptor to before unpacking it.
// (Default = unpack as typeWildCard)

- (AEMEvent *)unpackResultAsType:(DescType)type;

- (AEMEvent *)unpackResultAsListOfType:(DescType)type;

- (AEMEvent *)dontUnpackResult;

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

// shortcuts for -sendWithMode:timeout:error:

- (id)sendWithError:(NSError **)error;

- (id)send;

@end

