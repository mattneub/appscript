/*
 * MLApplicationGlue.h
 *
 * /Applications/Mail.app
 * osaglue 0.3.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "MLConstantGlue.h"
#import "MLReferenceGlue.h"


@interface MLApplication : MLReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
@end

