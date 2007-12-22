//
//  application.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "codecs.h"
#import "SendThreadSafe.h"
#import "event.h"


/**********************************************************************/
// Application class

@interface AEMApplication : NSObject {
	AEMTargetType targetType;
	id targetData;
	NSAppleEventDescriptor *addressDesc;
	id defaultCodecs;
	AETransactionID transactionID;
	
	AEMCreateProcPtr createProc;
	AEMSendProcPtr sendProc;
	Class eventClass;
}

// Utility class methods

// Find application by creator code, bundle ID and/or file name

+ (NSURL *)findApplicationForCreator:(OSType)creator		// use kLSUnknownCreator if none
							bundleID:(NSString *)bundleID	// use nil if none
								name:(NSString *)name		// use nil if none
							   error:(NSError **)error;


// Get Unix process ID of first process launched from specified application

+ (pid_t)findProcessIDForApplication:(NSURL *)fileURL error:(NSError **)error;


// Check if specified application is running

+ (BOOL)isApplicationRunning:(NSURL *)fileURL;


// Launch an application

+ (pid_t)launchApplication:(NSURL *)fileURL
					 event:(NSAppleEventDescriptor *)firstEvent
					 flags:(LaunchFlags)launchFlags
					 error:(NSError **)error;

/*
 * make AEAddressDescs
 *
 * Note: addressDescForLocalApplication:error: will start application if not already running
 */

+ (NSAppleEventDescriptor*)addressDescForLocalApplication:(NSURL *)fileURL error:(NSError **)error;

+ (NSAppleEventDescriptor *)addressDescForLocalProcess:(pid_t)pid;

+ (NSAppleEventDescriptor *)addressDescForRemoteProcess:(NSURL *)eppcURL;

+ (NSAppleEventDescriptor *)addressDescForCurrentProcess;


/*******/

// designated initialiser; clients shouldn't call this directly but use one of the following methods

- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_ error:(NSError **)error;


/*
 * clients should call one of the following methods to initialize AEMApplication object
 *
 * Note: if an error occurs when finding/launching an application by name/bundle ID/file URL, additional
 * error information may be returned via the error argument.
 */

- (id)initWithName:(NSString *)name error:(NSError **)error;

- (id)initWithBundleID:(NSString *)bundleID error:(NSError **)error;

- (id)initWithURL:(NSURL *)url error:(NSError **)error;

- (id)initWithPID:(pid_t)pid;

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;

// shortcuts for above

- (id)initWithName:(NSString *)name;

- (id)initWithBundleID:(NSString *)bundleID;

- (id)initWithURL:(NSURL *)url;


// clients can call following methods to modify standard create/send behaviours

- (void)setCreateProc:(AEMCreateProcPtr)createProc_;

- (void)setSendProc:(AEMSendProcPtr)sendProc_;

- (void)setEventClass:(Class)eventClass_;


// create new AEMEvent object

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code
				 returnID:(AEReturnID)returnID
				   codecs:(id)codecs;

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code
				 returnID:(AEReturnID)returnID;

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code
				   codecs:(id)codecs;

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code;


// transaction support

- (void)beginTransaction;

- (void)beginTransactionWithSession:(id)session;

- (void)endTransaction;

- (void)abortTransaction;
@end
