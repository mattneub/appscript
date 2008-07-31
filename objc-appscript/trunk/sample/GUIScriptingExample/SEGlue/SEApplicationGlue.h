/*
 * SEApplicationGlue.h
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.4.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "SEConstantGlue.h"
#import "SEReferenceGlue.h"


@interface SEApplication : SEReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
+ (id)application;
+ (id)applicationWithName:(NSString *)name;
+ (id)applicationWithBundleID:(NSString *)bundleID ;
+ (id)applicationWithURL:(NSURL *)url;
+ (id)applicationWithPID:(pid_t)pid;
+ (id)applicationWithDescriptor:(NSAppleEventDescriptor *)desc;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
- (SEReference *)AS_referenceWithObject:(id)object;
@end

