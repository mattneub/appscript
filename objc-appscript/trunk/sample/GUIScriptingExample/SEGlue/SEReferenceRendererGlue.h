/*
 * SEReferenceRendererGlue.h
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"

@interface SEReferenceRenderer : ASReferenceRenderer
- (NSString *)propertyByCode:(OSType)code;
- (NSString *)elementByCode:(OSType)code;
- (NSString *)prefix;
@end

