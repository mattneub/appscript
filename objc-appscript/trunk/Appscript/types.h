//
//  types.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


/**********************************************************************/
// convenience macros

#define AEMTrue [AEMBoolean True]
#define AEMFalse [AEMBoolean False]


/**********************************************************************/


@interface AEMBoolean : NSNumber

+ (id)True;

+ (id)False;

@end


/**********************************************************************/


@interface AEMTypeBase : NSObject {
	DescType type;
	OSType code;
	NSAppleEventDescriptor *cachedDesc;
}

// clients shouldn't call this initialiser directly; use subclasses' initialisers instead
- (id)initWithDescriptorType:(DescType)type_
						code:(OSType)code_
						desc:(NSAppleEventDescriptor *)desc;

- (id)initWithCode:(OSType)code_;

- (OSType)code;

- (NSAppleEventDescriptor *)desc;

@end


/***********************************/


@interface AEMType : AEMTypeBase

+ (id)typeWithCode:(OSType)code_;

@end


@interface AEMEnumerator : AEMTypeBase

+ (id)enumeratorWithCode:(OSType)code_;

@end


@interface AEMProperty : AEMTypeBase

+ (id)propertyWithCode:(OSType)code_;

@end


@interface AEMKeyword : AEMTypeBase

+ (id)keywordWithCode:(OSType)code_;

@end

