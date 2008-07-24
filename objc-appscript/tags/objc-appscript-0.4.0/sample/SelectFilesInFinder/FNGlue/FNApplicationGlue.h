/*
 * FNApplicationGlue.h
 *
 * /System/Library/CoreServices/Finder.app
 * osaglue 0.3.1
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "FNConstantGlue.h"
#import "FNReferenceGlue.h"


@interface FNApplication : FNReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
- (FNReference *)AS_newReferenceWithObject:(id)object;
@end

