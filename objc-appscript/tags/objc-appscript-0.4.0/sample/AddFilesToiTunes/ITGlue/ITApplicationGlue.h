/*
 * ITApplicationGlue.h
 *
 * /Applications/iTunes.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "ITConstantGlue.h"
#import "ITReferenceGlue.h"


@interface ITApplication : ITReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
- (ITReference *)AS_newReferenceWithObject:(id)object;
@end

