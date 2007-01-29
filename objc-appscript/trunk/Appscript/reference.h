//
//  reference.h
//  appscript
//
//  Copyright (C) 2007 HAS
//

#import <Cocoa/Cocoa.h>
#import "application.h"
#import "specifier.h"
#import "terminology.h"

/*
 * 
 */
@interface ASAppData : AEMCodecs {
	id *terminology;
	AEMTargetType targetType;
	id targetData;
	AEMApplication *target;
}

- (id)initWithApplicationClass:(Class)appClass
					targetType:(AEMTargetType *)type
					targetData:(id)data
						 terms:(id)terms;

- (void)connect;

- (id)target; // returns AEMApplication instance or equivalent

- (id)terminology; // returns ASStringTerminology instance or equivalent

@end


/**********************************************************************/
//

/*
 * 
 */
@interface ASType : NSObject {
	NSString *name;
}

- (id)initWithName:(NSString *)name;

- (NSString *)name;

- (NSAppleEventDescriptor *)pack:(id)anObject;

// TO DO: override various pack..., unpack... methods

@end


/**********************************************************************/
// Reference base


@interface ASReferenceBase : NSObject {
	ASAppData *appData;
}

- (ASReference)property:(NSString *)name;
- (ASReference)element:(NSString *)name;

// ordinal selectors

- (ASReference)first;
- (ASReference)middle;
- (ASReference)last;
- (ASReference)any;

// by-index, by-name, by-id selectors
 
- (ASReference)at:(long)index;
- (ASReference)byIndex:(id)index; // normally NSNumber, but may occasionally be other types
- (ASReference)byName:(NSString *)name;
- (ASReference)byName:(NSString *)name;
- (ASReference)byID:(id)id_;

// by-relative-position selectors

- (ASReference)previous:(ASType *)class_;
- (ASReference)next:(ASType *)class_

// by-range selector

- (ASReference)at:(long)fromIndex :(long)toIndex;
- (ASReference)byRange:(id)fromObject :(id)toObject; // takes two con-based references, with other values being expanded as necessary

// by-test selector

- (ASReference)byTest:(ASReference)testReference;

// insertion location selectors

- (ASReference)beginning;
- (ASReference)end;
- (ASReference)before;
- (ASReference)after;


@end
