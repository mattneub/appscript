/*
 * ASDefaultCommandGlue.m
 *
 * <default terminology>
 * osaglue 0.3.2
 *
 */

#import "ASDefaultCommandGlue.h"

@implementation ASDefaultActivateCommand

@end


@implementation ASDefaultGetCommand

@end


@implementation ASDefaultLaunchCommand

@end


@implementation ASDefaultOpenCommand

@end


@implementation ASDefaultOpenLocationCommand

- (ASDefaultOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;
}

@end


@implementation ASDefaultPrintCommand

@end


@implementation ASDefaultQuitCommand

- (ASDefaultQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

@end


@implementation ASDefaultReopenCommand

@end


@implementation ASDefaultRunCommand

@end


@implementation ASDefaultSetCommand

- (ASDefaultSetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


