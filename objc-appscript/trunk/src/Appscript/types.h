//
//  types.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


/**********************************************************************/
// convenience macros

#define ASTrue [ASBoolean True]
#define ASFalse [ASBoolean False]


/**********************************************************************/
// Boolean class represents AEDescs of typeTrue and typeFalse


@interface ASBoolean : NSObject {
	BOOL boolValue;
	NSAppleEventDescriptor *cachedDesc;
}

+ (id)True;

+ (id)False;

// client's shouldn't call -initWithBool: directly; use +True/+False (or ASTrue/ASFalse macros) instead
- (id)initWithBool:(BOOL)boolValue_;

- (BOOL)boolValue;

- (NSAppleEventDescriptor *)desc;

@end


/**********************************************************************/
// file object classes represent AEDescs of typeAlias, typeFSRef, typeFSSpec

//abstract base class
@interface ASFileBase : NSObject {
	NSAppleEventDescriptor *desc;
}

+ (NSURL *)HFSPathToURL:(NSString *)path;

+ (NSString *)URLToHFSPath:(NSURL *)url;

- (id)initWithPath:(NSString *)path;

- (id)initWithFileURL:(NSURL *)url;

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc_;

- (NSString *)path;

- (NSURL *)url;

- (NSAppleEventDescriptor *)desc;

- (DescType)descriptorType;

@end


/***********************************/
// concrete classes

@interface ASAlias : ASFileBase

+ (id)aliasWithPath:(NSString *)path;

+ (id)aliasWithFileURL:(NSURL *)url;

+ (id)aliasWithDescriptor:(NSAppleEventDescriptor *)desc_;

@end


@interface ASFileRef : ASFileBase

+ (id)fileRefWithPath:(NSString *)path;

+ (id)fileRefWithFileURL:(NSURL *)url;

+ (id)fileRefWithDescriptor:(NSAppleEventDescriptor *)desc_;

@end


@interface ASFileSpec : ASFileBase

+ (id)fileSpecWithPath:(NSString *)path;

+ (id)fileSpecWithFileURL:(NSURL *)url;

+ (id)fileSpecWithDescriptor:(NSAppleEventDescriptor *)desc_;

@end


/**********************************************************************/

// abstract base class for AEMType, AEMEnum, AEMProperty, AEMKeyword
@interface AEMTypeBase : NSObject {
	DescType type;
	OSType code;
	NSAppleEventDescriptor *cachedDesc;
}

// clients shouldn't call this next method directly; use subclasses' class/instance initialisers instead
- (id)initWithDescriptorType:(DescType)type_
						code:(OSType)code_
						desc:(NSAppleEventDescriptor *)desc;

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc; // normally called by AEMCodecs -unpack:, though clients could also use it to wrap any loose NSAppleEventDescriptor instances they might have. Note: doesn't verify descriptor's type before use; clients are responsible for providing an appropriate value.

- (id)initWithCode:(OSType)code_; // stub method; subclasses will override this to provide concrete implementations 

- (OSType)code;

- (NSAppleEventDescriptor *)desc;

@end


/***********************************/
// concrete classes representing AEDescs of typeType, typeEnumerator, typeProperty, typeKeyword
// note: unlike NSAppleEventDescriptor instances, instances of these classes are fully hashable
// and comparable, so suitable for use as NSDictionary keys.

@interface AEMType : AEMTypeBase

+ (id)typeWithCode:(OSType)code_;

@end


@interface AEMEnum : AEMTypeBase

+ (id)enumWithCode:(OSType)code_;

@end


@interface AEMProperty : AEMTypeBase

+ (id)propertyWithCode:(OSType)code_;

@end


@interface AEMKeyword : AEMTypeBase

+ (id)keywordWithCode:(OSType)code_;

@end

