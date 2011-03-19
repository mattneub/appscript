/*
 * FNCommandGlue.m
 * /System/Library/CoreServices/Finder.app
 * osaglue 0.5.1
 *
 */

#import "FNCommandGlue.h"

@implementation FNCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData {
    return [FNReferenceRenderer formatObject: obj appData: appData];
}

@end


@implementation FNActivateCommand
- (NSString *)AS_commandName {
    return @"activate";
}

@end


@implementation FNCleanUpCommand
- (FNCleanUpCommand *)by:(id)value {
    [AS_event setParameter: value forKeyword: 'by  '];
    return self;

}

- (NSString *)AS_commandName {
    return @"cleanUp";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'by  ':
            return @"by";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNCloseCommand
- (NSString *)AS_commandName {
    return @"close";
}

@end


@implementation FNCopy_Command
- (NSString *)AS_commandName {
    return @"copy_";
}

@end


@implementation FNCountCommand
- (FNCountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;

}

- (NSString *)AS_commandName {
    return @"count";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'kocl':
            return @"each";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNDataSizeCommand
- (FNDataSizeCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'rtyp'];
    return self;

}

- (NSString *)AS_commandName {
    return @"dataSize";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'rtyp':
            return @"as";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNDeleteCommand
- (NSString *)AS_commandName {
    return @"delete";
}

@end


@implementation FNDuplicateCommand
- (FNDuplicateCommand *)replacing:(id)value {
    [AS_event setParameter: value forKeyword: 'alrp'];
    return self;

}

- (FNDuplicateCommand *)routingSuppressed:(id)value {
    [AS_event setParameter: value forKeyword: 'rout'];
    return self;

}

- (FNDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (NSString *)AS_commandName {
    return @"duplicate";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'alrp':
            return @"replacing";
        case 'rout':
            return @"routingSuppressed";
        case 'insh':
            return @"to";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNEjectCommand
- (NSString *)AS_commandName {
    return @"eject";
}

@end


@implementation FNEmptyCommand
- (FNEmptyCommand *)security:(id)value {
    [AS_event setParameter: value forKeyword: 'sec?'];
    return self;

}

- (NSString *)AS_commandName {
    return @"empty";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'sec?':
            return @"security";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNEraseCommand
- (NSString *)AS_commandName {
    return @"erase";
}

@end


@implementation FNExistsCommand
- (NSString *)AS_commandName {
    return @"exists";
}

@end


@implementation FNGetCommand
- (NSString *)AS_commandName {
    return @"get";
}

@end


@implementation FNLaunchCommand
- (NSString *)AS_commandName {
    return @"launch";
}

@end


@implementation FNMakeCommand
- (FNMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (FNMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;

}

- (FNMakeCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'to  '];
    return self;

}

- (FNMakeCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;

}

- (NSString *)AS_commandName {
    return @"make";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'insh':
            return @"at";
        case 'kocl':
            return @"new_";
        case 'to  ':
            return @"to";
        case 'prdt':
            return @"withProperties";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNMoveCommand
- (FNMoveCommand *)positionedAt:(id)value {
    [AS_event setParameter: value forKeyword: 'mvpl'];
    return self;

}

- (FNMoveCommand *)replacing:(id)value {
    [AS_event setParameter: value forKeyword: 'alrp'];
    return self;

}

- (FNMoveCommand *)routingSuppressed:(id)value {
    [AS_event setParameter: value forKeyword: 'rout'];
    return self;

}

- (FNMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (NSString *)AS_commandName {
    return @"move";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'mvpl':
            return @"positionedAt";
        case 'alrp':
            return @"replacing";
        case 'rout':
            return @"routingSuppressed";
        case 'insh':
            return @"to";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNOpenCommand
- (FNOpenCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'usin'];
    return self;

}

- (FNOpenCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;

}

- (NSString *)AS_commandName {
    return @"open";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'usin':
            return @"using";
        case 'prdt':
            return @"withProperties";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNOpenLocationCommand
- (FNOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;

}

- (NSString *)AS_commandName {
    return @"openLocation";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'WIND':
            return @"window";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNPrintCommand
- (FNPrintCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;

}

- (NSString *)AS_commandName {
    return @"print";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'prdt':
            return @"withProperties";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNQuitCommand
- (NSString *)AS_commandName {
    return @"quit";
}

@end


@implementation FNReopenCommand
- (NSString *)AS_commandName {
    return @"reopen";
}

@end


@implementation FNRestartCommand
- (NSString *)AS_commandName {
    return @"restart";
}

@end


@implementation FNRevealCommand
- (NSString *)AS_commandName {
    return @"reveal";
}

@end


@implementation FNRunCommand
- (NSString *)AS_commandName {
    return @"run";
}

@end


@implementation FNSelectCommand
- (NSString *)AS_commandName {
    return @"select";
}

@end


@implementation FNSetCommand
- (FNSetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;

}

- (NSString *)AS_commandName {
    return @"set";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'data':
            return @"to";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNShutDownCommand
- (NSString *)AS_commandName {
    return @"shutDown";
}

@end


@implementation FNSleepCommand
- (NSString *)AS_commandName {
    return @"sleep";
}

@end


@implementation FNSortCommand
- (FNSortCommand *)by:(id)value {
    [AS_event setParameter: value forKeyword: 'by  '];
    return self;

}

- (NSString *)AS_commandName {
    return @"sort";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'by  ':
            return @"by";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation FNUpdateCommand
- (FNUpdateCommand *)necessity:(id)value {
    [AS_event setParameter: value forKeyword: 'nec?'];
    return self;

}

- (FNUpdateCommand *)registeringApplications:(id)value {
    [AS_event setParameter: value forKeyword: 'reg?'];
    return self;

}

- (NSString *)AS_commandName {
    return @"update";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'nec?':
            return @"necessity";
        case 'reg?':
            return @"registeringApplications";
    }
    return [super AS_parameterNameForCode: code];
}

@end

