/*
 * ASDefaultReferenceRendererGlue.m
 * <default terminology>
 * osaglue 0.5.1
 *
 */

#import "ASDefaultReferenceRendererGlue.h"

@implementation ASDefaultReferenceRenderer
- (NSString *)propertyByCode:(OSType)code {
    switch (code) {
        case 'pcls': return @"class_";
        case 'ID  ': return @"id_";
        case 'pALL': return @"properties";
        default: return nil;
    }
}

- (NSString *)elementByCode:(OSType)code {
    switch (code) {
        case 'cobj': return @"items";
        default: return nil;
    }
}

- (NSString *)prefix {
    return @"ASDefault";
}

@end

