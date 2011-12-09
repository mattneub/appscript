/*
 * ICCommandGlue.m
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import "ICCommandGlue.h"

@implementation ICCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData {
    return [ICReferenceRenderer formatObject: obj appData: appData];
}

@end


@implementation ICGetURLCommand
- (NSString *)AS_commandName {
    return @"GetURL";
}

@end


@implementation ICActivateCommand
- (NSString *)AS_commandName {
    return @"activate";
}

@end


@implementation ICCloseCommand
- (ICCloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;

}

- (ICCloseCommand *)savingIn:(id)value {
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


@implementation ICCountCommand
- (ICCountCommand *)each:(id)value {
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


@implementation ICCreateCalendarCommand
- (ICCreateCalendarCommand *)withName:(id)value {
    [AS_event setParameter: value forKeyword: 'wtnm'];
    return self;

}

- (NSString *)AS_commandName {
    return @"createCalendar";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'wtnm':
            return @"withName";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation ICDeleteCommand
- (NSString *)AS_commandName {
    return @"delete";
}

@end


@implementation ICDuplicateCommand
- (ICDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (ICDuplicateCommand *)withProperties:(id)value {
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


@implementation ICExistsCommand
- (NSString *)AS_commandName {
    return @"exists";
}

@end


@implementation ICGetCommand
- (NSString *)AS_commandName {
    return @"get";
}

@end


@implementation ICLaunchCommand
- (NSString *)AS_commandName {
    return @"launch";
}

@end


@implementation ICMakeCommand
- (ICMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;

}

- (ICMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;

}

- (ICMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;

}

- (ICMakeCommand *)withProperties:(id)value {
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


@implementation ICMoveCommand
- (ICMoveCommand *)to:(id)value {
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


@implementation ICOpenCommand
- (NSString *)AS_commandName {
    return @"open";
}

@end


@implementation ICOpenLocationCommand
- (ICOpenLocationCommand *)window:(id)value {
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


@implementation ICPrintCommand
- (ICPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;

}

- (ICPrintCommand *)withProperties:(id)value {
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


@implementation ICQuitCommand
- (ICQuitCommand *)saving:(id)value {
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


@implementation ICReloadCalendarsCommand
- (NSString *)AS_commandName {
    return @"reloadCalendars";
}

@end


@implementation ICReopenCommand
- (NSString *)AS_commandName {
    return @"reopen";
}

@end


@implementation ICRunCommand
- (NSString *)AS_commandName {
    return @"run";
}

@end


@implementation ICSaveCommand
- (ICSaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;

}

- (ICSaveCommand *)in:(id)value {
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


@implementation ICSetCommand
- (ICSetCommand *)to:(id)value {
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


@implementation ICShowCommand
- (NSString *)AS_commandName {
    return @"show";
}

@end


@implementation ICSwitchViewCommand
- (ICSwitchViewCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'wre5'];
    return self;

}

- (NSString *)AS_commandName {
    return @"switchView";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'wre5':
            return @"to";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation ICViewCalendarCommand
- (ICViewCalendarCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'wtdt'];
    return self;

}

- (NSString *)AS_commandName {
    return @"viewCalendar";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'wtdt':
            return @"at";
    }
    return [super AS_parameterNameForCode: code];
}

@end

