//
//  reference.h
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "application.h"
#import "constant.h"
#import "specifier.h"
#import "command.h"
#import "utils.h"


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

// is target application running?
- (BOOL)isRunning;

// launch the target application without sending it the usual 'run' event;
// equivalent to 'launch' command in AppleScript.
- (BOOL)launchApplicationWithError:(NSError **)error; // may be nil

- (BOOL)launchApplication; // convenience shortcut for the above


// restart local application and/or update AEAddressDesc if needed
// (typically used after application has quit; refreshes existing
// application object without the need to recreate it)
// note: only works for apps specified by name/path/bundle ID

- (BOOL)reconnectApplicationWithError:(NSError **)error;

- (BOOL)reconnectApplication;


// transaction support

- (BOOL)beginTransactionWithError:(NSError **)error;

- (BOOL)beginTransactionWithSession:(id)session error:(NSError **)error;

- (BOOL)endTransactionWithError:(NSError **)error;

- (BOOL)abortTransactionWithError:(NSError **)error;

// get/set shortcuts

// shortcut for [[[ref set] to: value] send]
- (id)setItem:(id)data;
- (id)setItem:(id)data error:(NSError **)error;

// shortcut for [[ref get] send]
- (id)getItem; 
- (id)getItemWithError:(NSError **)error;

// shortcut for [[[ref get] returnList] send]
- (id)getList;
- (id)getListWithError:(NSError **)error;

// shortcut for [[[[ref get] requestedType: typeClass] returnType: descType] send]
- (id)getItemOfType:(DescType)type;
- (id)getItemOfType:(DescType)type error:(NSError **)error;

// shortcut for [[[[ref get] requestedType: typeClass] returnListOfType: descType] send]
- (id)getListOfType:(DescType)type;
- (id)getListOfType:(DescType)type error:(NSError **)error;

@end


