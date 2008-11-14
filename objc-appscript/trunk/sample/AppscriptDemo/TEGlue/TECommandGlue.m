/*
 * TECommandGlue.m
 * /Applications/TextEdit.app
 * osaglue 0.5.1
 *
 */

#import "TECommandGlue.h"

@implementation TECommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData {
    return [TEReferenceRenderer formatObject: obj appData: appData];
}

@end


@implementation TEActivateCommand
- (NSString *)AS_commandName {
    return @"activate";
}

@end


@implementation TECloseCommand
- (TECloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;

}

- (TECloseCommand *)savingIn:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;

}

- (NSString *)AS_commandName {
    return @"close";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'savo':
            return @"saving";
        case 'kfil':
            return @"savingIn";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TECountCommand
- (TECountCommand *)each:(id)value {
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


@implementation TEDeleteCommand
- (NSString *)AS_commandName {
    return @"delete";
}

@end


@implementation TEDuplicateCommand
- (TEDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (TEDuplicateCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;

}

- (NSString *)AS_commandName {
    return @"duplicate";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'insh':
            return @"to";
        case 'prdt':
            return @"withProperties";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TEExistsCommand
- (NSString *)AS_commandName {
    return @"exists";
}

@end


@implementation TEGetCommand
- (NSString *)AS_commandName {
    return @"get";
}

@end


@implementation TELaunchCommand
- (NSString *)AS_commandName {
    return @"launch";
}

@end


@implementation TEMakeCommand
- (TEMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (TEMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;

}

- (TEMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;

}

- (TEMakeCommand *)withProperties:(id)value {
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
        case 'data':
            return @"withData";
        case 'prdt':
            return @"withProperties";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TEMoveCommand
- (TEMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (NSString *)AS_commandName {
    return @"move";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'insh':
            return @"to";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TEOpenCommand
- (NSString *)AS_commandName {
    return @"open";
}

@end


@implementation TEOpenLocationCommand
- (TEOpenLocationCommand *)window:(id)value {
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


@implementation TEPrintCommand
- (TEPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;

}

- (TEPrintCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;

}

- (NSString *)AS_commandName {
    return @"print";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'pdlg':
            return @"printDialog";
        case 'prdt':
            return @"withProperties";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TEQuitCommand
- (TEQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;

}

- (NSString *)AS_commandName {
    return @"quit";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'savo':
            return @"saving";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TEReopenCommand
- (NSString *)AS_commandName {
    return @"reopen";
}

@end


@implementation TERunCommand
- (NSString *)AS_commandName {
    return @"run";
}

@end


@implementation TESaveCommand
- (TESaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;

}

- (TESaveCommand *)in:(id)value {
    [AS_event setParameter: value forKeyword: 'kfil'];
    return self;

}

- (NSString *)AS_commandName {
    return @"save";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'fltp':
            return @"as";
        case 'kfil':
            return @"in";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation TESetCommand
- (TESetCommand *)to:(id)value {
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

