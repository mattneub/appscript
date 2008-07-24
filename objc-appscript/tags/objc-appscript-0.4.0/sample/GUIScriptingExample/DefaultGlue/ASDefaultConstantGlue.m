/*
 * ASDefaultConstantGlue.m
 *
 * <default terminology>
 * osaglue 0.3.2
 *
 */

#import "ASDefaultConstantGlue.h"

@implementation ASDefaultConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        default: return [[self superclass] constantWithCode: code_];
    }
}

@end


