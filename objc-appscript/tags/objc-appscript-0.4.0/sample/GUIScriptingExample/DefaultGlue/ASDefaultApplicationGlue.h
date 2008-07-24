/*
 * ASDefaultApplicationGlue.h
 *
 * <default terminology>
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "ASDefaultConstantGlue.h"
#import "ASDefaultReferenceGlue.h"


@interface ASDefaultApplication : ASDefaultReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithBundleID:(NSString *)bundleID;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
- (ASDefaultReference *)AS_newReferenceWithObject:(id)object;
@end

