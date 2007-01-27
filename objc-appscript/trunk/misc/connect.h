//
//  connect.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>


/**********************************************************************/
// find/launch/get PIDs for local applications

#define AEMFindAppWithCreator(code) AEMFindApplication(code, nil, nil)
#define AEMFindAppWithBundleID(bundleID) AEMFindApplication('????', bundleID, nil)
#define AEMFindAppWithName(name) AEMFindApplication('????', nil, name)


extern NSURL* AEMFindApplication(OSType creator, NSString *bundleID, NSString *name);

OSStatus AEMFindPIDForApplication(NSURL *fileURL, pid_t *pid);

extern OSStatus AEMLaunchApplication(NSURL *fileURL, 
									 NSAppleEventDescriptor *firstEvent, 
									 LaunchFlags launchFlags,
									 pid_t *pid);

// TO DO: (BOOL)AEMApplicationIsRunning(NSURL *fileURL); ?


/**********************************************************************/
// create AEAddressDescs

NSAppleEventDescriptor* AEMAddressDescForLocalApplication(NSURL *fileURL);

NSAppleEventDescriptor* AEMAddressDescForLocalProcess(pid_t pid);

NSAppleEventDescriptor* AEMAddressDescForRemoteProcess(NSURL *eppcURL);

NSAppleEventDescriptor* AEMAddressDescForCurrentProcess(void);

