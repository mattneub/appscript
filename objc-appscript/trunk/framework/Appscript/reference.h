//
//  reference.h
//  appscript
//
//  Copyright (C) 2007 HAS
//

#import <Cocoa/Cocoa.h>
#import "application.h"
#import "specifier.h"
// #import "terminology.h"

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
	Class aemApplicationClass;
	ASTargetType targetType;
	id targetData;
	AEMApplication *target;
}

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data;

- (void)connect;

- (id)target; // returns AEMApplication instance or equivalent

@end


/**********************************************************************/
//

/*
 * 
 */
@interface ASConstant : NSObject {
	NSString *name;
	NSAppleEventDescriptor *desc;
}

- (id)initWithName: (NSString *)name_ descriptor:(NSAppleEventDescriptor *)desc_;

- (NSString *)name;

- (OSType)code;

- (NSAppleEventDescriptor *)desc;

@end


/**********************************************************************/
// Command base


@interface ASCommand : NSObject {
	id AS_appData;
	AEMEvent *AS_event;
	AESendMode sendMode;
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

// TO DO: attribute methods

- (id)send;

- (id)sendWithTimeout:(int)timeout;

- (OSErr)errorNumber;

- (NSString *)errorString;

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

- (id)AS_appData;

- (id)AS_aemReference;

@end

