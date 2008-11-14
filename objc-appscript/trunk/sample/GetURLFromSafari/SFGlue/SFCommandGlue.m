/*
 * SFCommandGlue.m
 * /Applications/Safari.app
 * osaglue 0.5.1
 *
 */

#import "SFCommandGlue.h"

@implementation SFCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData {
    return [SFReferenceRenderer formatObject: obj appData: appData];
}

@end


@implementation SFActivateCommand
- (NSString *)AS_commandName {
    return @"activate";
}

@end


@implementation SFCloseCommand
- (SFCloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;

}

- (SFCloseCommand *)savingIn:(id)value {
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


@implementation SFCountCommand
- (SFCountCommand *)each:(id)value {
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


@implementation SFDeleteCommand
- (NSString *)AS_commandName {
    return @"delete";
}

@end


@implementation SFDoJavaScriptCommand
- (SFDoJavaScriptCommand *)in:(id)value {
    [AS_event setParameter: value forKeyword: 'dcnm'];
    return self;

}

- (NSString *)AS_commandName {
    return @"doJavaScript";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'dcnm':
            return @"in";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SFDuplicateCommand
- (SFDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (SFDuplicateCommand *)withProperties:(id)value {
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


@implementation SFEmailContentsCommand
- (SFEmailContentsCommand *)of:(id)value {
    [AS_event setParameter: value forKeyword: 'dcnm'];
    return self;

}

- (NSString *)AS_commandName {
    return @"emailContents";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'dcnm':
            return @"of";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SFExistsCommand
- (NSString *)AS_commandName {
    return @"exists";
}

@end


@implementation SFGetCommand
- (NSString *)AS_commandName {
    return @"get";
}

@end


@implementation SFLaunchCommand
- (NSString *)AS_commandName {
    return @"launch";
}

@end


@implementation SFMakeCommand
- (SFMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (SFMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;

}

- (SFMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;

}

- (SFMakeCommand *)withProperties:(id)value {
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


@implementation SFMoveCommand
- (SFMoveCommand *)to:(id)value {
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


@implementation SFOpenCommand
- (NSString *)AS_commandName {
    return @"open";
}

@end


@implementation SFOpenLocationCommand
- (SFOpenLocationCommand *)window:(id)value {
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


@implementation SFPrintCommand
- (SFPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;

}

- (SFPrintCommand *)withProperties:(id)value {
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


@implementation SFQuitCommand
- (SFQuitCommand *)saving:(id)value {
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


@implementation SFReopenCommand
- (NSString *)AS_commandName {
    return @"reopen";
}

@end


@implementation SFRunCommand
- (NSString *)AS_commandName {
    return @"run";
}

@end


@implementation SFSaveCommand
- (SFSaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;

}

- (SFSaveCommand *)in:(id)value {
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


@implementation SFSetCommand
- (SFSetCommand *)to:(id)value {
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


@implementation SFShowBookmarksCommand
- (NSString *)AS_commandName {
    return @"showBookmarks";
}

@end

