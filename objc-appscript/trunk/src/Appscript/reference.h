//
//  reference.h
//  appscript
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import "application.h"
#import "constant.h"
#import "specifier.h"

typedef enum {
	kASTargetCurrent,
	kASTargetName,
	kASTargetPath,
	kASTargetURL,
	kASTargetPID,
	kASTargetDescriptor,
} ASTargetType;

/*
 * 
 */
@interface ASAppData : AEMCodecs {
	Class aemApplicationClass, constantClass, referenceClass;
	ASTargetType targetType;
	id targetData;
	AEMApplication *target;
}

- (id)initWithApplicationClass:(Class)appClass
				 constantClass:(Class)constClass
				referenceClass:(Class)refClass
					targetType:(ASTargetType)type
					targetData:(id)data;

- (BOOL)connect;

- (id)target; // returns AEMApplication instance or equivalent

@end


/**********************************************************************/
// Command base

// TO DO: transactionID, returnID support

@interface ASCommand : NSObject {
	id AS_appData;
	AEMEvent *AS_event;
	AESendMode sendMode;
	long timeout;
}

+ (id)commandWithAppData:(id)appData
			  eventClass:(AEEventClass)classCode
				 eventID:(AEEventID)code
		 directParameter:(id)directParameter
		 parentReference:(id)parentReference;

- (id)initWithAppData:(id)appData
		   eventClass:(AEEventClass)classCode
			  eventID:(AEEventID)code
	  directParameter:(id)directParameter
	  parentReference:(id)parentReference;

// get underlying AEMEvent instance

- (AEMEvent *)AS_aemEvent;

// set attributes

// TO DO: method for setting considering/ignoring attributes
/*
kAECase = 'case'
kAEDiacritic = 'diac'
kAEWhiteSpace = 'whit'
kAEHyphens = 'hyph'
kAEExpansion = 'expa'
kAEPunctuation = 'punc'
kAEZenkakuHankaku = 'zkhk'
kAESmallKana = 'skna'
kAEKataHiragana = 'hika'
kASConsiderReplies = 'rmte'
kASNumericStrings = 'nume'
enumConsiderations = 'cons' // obsolete, but may want to support for backwards compatibility


kAECaseConsiderMask = 0x00000001
kAEDiacriticConsiderMask = 0x00000002
kAEWhiteSpaceConsiderMask = 0x00000004
kAEHyphensConsiderMask = 0x00000008
kAEExpansionConsiderMask = 0x00000010
kAEPunctuationConsiderMask = 0x00000020
kASConsiderRepliesConsiderMask = 0x00000040
kASNumericStringsConsiderMask = 0x00000080
kAECaseIgnoreMask = 0x00010000
kAEDiacriticIgnoreMask = 0x00020000
kAEWhiteSpaceIgnoreMask = 0x00040000
kAEHyphensIgnoreMask = 0x00080000
kAEExpansionIgnoreMask = 0x00100000
kAEPunctuationIgnoreMask = 0x00200000
kASConsiderRepliesIgnoreMask = 0x00400000
kASNumericStringsIgnoreMask = 0x00800000
enumConsidsAndIgnores = 'csig'
*/


/* Set send mode flags.
 *	kAENoReply = 0x00000001,
 *	kAEQueueReply = 0x00000002,
 *	kAEWaitReply = 0x00000003,
 *	kAEDontReconnect = 0x00000080,
 *	kAEWantReceipt = 0x00000200,
 *	kAENeverInteract = 0x00000010,
 *	kAECanInteract = 0x00000020,
 *	kAEAlwaysInteract = 0x00000030,
 *	kAECanSwitchLayer = 0x00000040,
 *	kAEDontRecord = 0x00001000,
 *	kAEDontExecute = 0x00002000,
 *	kAEProcessNonReplyEvents = 0x00008000
 *
 * Default is kAEWaitReply | kAECanSwitchLayer
 */
- (id)sendMode:(AESendMode)flags;

/*
 * Specify timeout in seconds (or kAEDefaultTimeout/kAENoTimeOut).
 *
 * Default is kAEDefaultTimeout (2 minutes)
 */
- (id)timeout:(long)timeout_;

/*
 * Specify a Mach port to receive the reply event.
 *
 * By default, the Apple Event Manager receives reply events on the main thread
 * via the process's registered Mach port. When sending events on a non-main thread
 * with kAEWaitReply, the thread should create its own Mach port to receive the
 * reply events.
 *
 * Example usage:
 *
 * mach_port_t rp;
 * mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &rp);
 * ...
 * [commandObj replyPort: rp];
 * reply = [commandObj send];
 * ...
 * mach_port_destroy(mach_task_self(), rp);
 */
- (id)replyPort:(mach_port_t)machPort;

/*
 * Specify the desired type for the return value. Where the application's event
 * handler supports this, it will attempt to coerce the event's result to this
 * type before returning it. May be a standard AE type (e.g. [ASConstant alias])
 * or, occasionally, an application-defined type.
 */
- (id)requestType:(ASConstant *)type;

/*
 * Specify the AE type that the returned AEDesc must be coerced to before unpacking.
 * Whereas the -resultType: method adds a kAERequestedType parameter to the outgoing
 * event, this coercion is performed locally by the -send: method using a built-in/
 * user-installed AE coercion handler if one is available. Note that if the coercion
 * fails, -send: will return nil and set the command object's error number to -1700
 * (errAECoercionFail).
 */
- (id)resultType:(DescType)type;
 
// send events

/*
 * Send the event. If an error occurs, returns NULL; clients can then use
 * errorNumber, errorString methods to extract error info.
 *
 * Note that it's possible to invoke -send more than once, if wished. This will
 * clear any previous error state and re-send the same AppleEvent instance.
 */
- (id)send;

/*
 * Get error number for the last event that was sent. Returns 0 if no error occurred.
 */
- (OSErr)errorNumber;

/*
 * Get error string for the last event that was sent. Returns nil if no error occurred.
 */
- (NSString *)errorString;

// TO DO: methods for getting OSA error info

/*
 * Convenience method for raising an "AEMEventSendError" NSException based on
 * the current error state.
 */
- (void)raise;

@end


/**********************************************************************/
// Reference base


@interface ASReference : NSObject {
	id AS_appData;
	id AS_aemReference;
}

+ (id)referenceWithAppData:(id)appData aemReference:(id)aemReference;

- (id)initWithAppData:(id)appData aemReference:(id)aemReference;

- (NSAppleEventDescriptor *)AS_packSelf:(id)codecs;

- (id)AS_appData;

- (id)AS_aemReference;

@end


