/*
 * ASDefaultReferenceRendererGlue.h
 * <default terminology>
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"

@interface ASDefaultReferenceRenderer : ASReferenceRenderer
- (NSString *)propertyByCode:(OSType)code;
- (NSString *)elementByCode:(OSType)code;
- (NSString *)prefix;
@end

