//
//  referencerenderer.h
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "reference.h"
#import "utils.h"

/**********************************************************************/
// reference renderer abstract base

@interface ASReferenceRenderer : AEMResolver {
	NSString *prefix;
	NSMutableString *result;
}

- (id)initWithPrefix:(NSString *)prefix_;

/*******/
// private

+ (NSString *)render:(id)object withPrefix:(NSString *)prefix_;
- (NSString *)format:(id)object;
- (NSString *)result;

/*******/
// public
// application-specific subclasses should override this method to provide their own prefix codes

+ (NSString *)render:(id)object; // TO DO: define formal protocol for this

/*******/
// method stubs; application-specific subclasses will override to provide code->name translations

- (NSString *)propertyByCode:(OSType)code;
- (NSString *)elementByCode:(OSType)code;

@end

