/*
 * SEApplicationGlue.h
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "SEConstantGlue.h"
#import "SEReferenceGlue.h"


@interface SEApplication : SEReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
- (SEReference *)AS_newReferenceWithObject:(id)object;
@end

