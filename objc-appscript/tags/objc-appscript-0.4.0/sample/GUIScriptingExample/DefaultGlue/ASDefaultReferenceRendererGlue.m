/*
 * ASDefaultReferenceRendererGlue.m
 *
 * <default terminology>
 * osaglue 0.3.2
 *
 */

#import "ASDefaultReferenceRendererGlue.h"

@implementation ASDefaultReferenceRenderer

- (NSString *)propertyByCode:(OSType)code {
    switch (code) {
        case 'pcls': return @"class_";
        case 'ID  ': return @"id_";

        default: return nil;
    }
}

- (NSString *)elementByCode:(OSType)code {
    switch (code) {

        default: return nil;
    }
}

+ (NSString *)render:(id)object {
    return [ASDefaultReferenceRenderer render: object withPrefix: @"ASDefault"];
}

@end
