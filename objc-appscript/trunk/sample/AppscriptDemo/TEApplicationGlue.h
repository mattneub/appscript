/*
 * TEApplicationGlue.h
 *
 * /Applications/TextEdit.app
 * 2007-02-04 12:49:58 (GMT)
 *
 */

#import <Appscript/Appscript.h>


#import "Appscript/Appscript.h"
#import "TEConstantGlue.h"
#import "TEReferenceGlue.h"


@interface TEApplication : TEReference
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_;
- (id)init;
- (id)initWithName:(NSString *)name;
- (id)initWithPath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;
- (id)initWithPID:(pid_t)pid;
- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc;
@end

