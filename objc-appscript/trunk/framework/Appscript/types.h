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
// Alias, FSRef, FSSpec wrappers


@interface AEMFileObject : NSObject {
	NSAppleEventDescriptor *desc;
}

- (id)initWithPath:(NSString *)path;

- (id)initWithFileURL:(NSURL *)url;

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc_;

- (NSString *)path;

- (NSURL *)url;

- (NSAppleEventDescriptor *)desc;

- (DescType)descriptorType;

@end


@interface AEMAlias : AEMFileObject

+ (id)aliasWithPath:(NSString *)path;

+ (id)aliasWithFileURL:(NSURL *)url;

+ (id)aliasWithDescriptor:(NSAppleEventDescriptor *)desc_;

@end


@interface AEMFSRef : AEMFileObject

+ (id)fsrefWithPath:(NSString *)path;

+ (id)fsrefWithFileURL:(NSURL *)url;

+ (id)fsrefWithDescriptor:(NSAppleEventDescriptor *)desc_;

@end


@interface AEMFSSpec : AEMFileObject

+ (id)fsspecWithPath:(NSString *)path;

+ (id)fsspecWithFileURL:(NSURL *)url;

+ (id)fsspecWithDescriptor:(NSAppleEventDescriptor *)desc_;

@end


/**********************************************************************/


@interface AEMTypeBase : NSObject {
	DescType type;
	OSType code;
	NSAppleEventDescriptor *cachedDesc;
}

// clients shouldn't call this next method directly; use subclasses' class/instance initialisers instead
- (id)initWithDescriptorType:(DescType)type_
						code:(OSType)code_
						desc:(NSAppleEventDescriptor *)desc;

- (id)initWithCode:(OSType)code_; // stub method; subclasses will override this to provide concrete implementations 

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

