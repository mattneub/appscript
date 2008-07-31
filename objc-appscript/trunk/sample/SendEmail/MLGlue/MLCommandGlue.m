/*
 * MLCommandGlue.m
 *
 * /Applications/Mail.app
 * osaglue 0.4.0
 *
 */

#import "MLCommandGlue.h"

@implementation MLCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData{
    return [MLReferenceRenderer formatObject: obj appData: appData];
}
@end

@implementation MLGetURLCommand

- (NSString *)AS_commandName {
    return @"GetURL";
}

@end


@implementation MLActivateCommand

- (NSString *)AS_commandName {
    return @"activate";
}

@end


@implementation MLBounceCommand

- (NSString *)AS_commandName {
    return @"bounce";
}

@end


@implementation MLCheckForNewMailCommand

- (MLCheckForNewMailCommand *)for_:(id)value {
    [AS_event setParameter: value forKeyword: 'acna'];
    return self;
}

- (NSString *)AS_commandName {
    return @"checkForNewMail";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'acna':
            return @"for_";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLCloseCommand

- (MLCloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

- (MLCloseCommand *)savingIn:(id)value {
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


@implementation MLCountCommand

- (MLCountCommand *)each:(id)value {
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


@implementation MLDeleteCommand

- (NSString *)AS_commandName {
    return @"delete";
}

@end


@implementation MLDuplicateCommand

- (MLDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (NSString *)AS_commandName {
    return @"duplicate";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'insh':
            return @"to";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLExistsCommand

- (NSString *)AS_commandName {
    return @"exists";
}

@end


@implementation MLExtractAddressFromCommand

- (NSString *)AS_commandName {
    return @"extractAddressFrom";
}

@end


@implementation MLExtractNameFromCommand

- (NSString *)AS_commandName {
    return @"extractNameFrom";
}

@end


@implementation MLForwardCommand

- (MLForwardCommand *)openingWindow:(id)value {
    [AS_event setParameter: value forKeyword: 'ropw'];
    return self;
}

- (NSString *)AS_commandName {
    return @"forward";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'ropw':
            return @"openingWindow";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLGetCommand

- (NSString *)AS_commandName {
    return @"get";
}

@end


@implementation MLImportMailMailboxCommand

- (MLImportMailMailboxCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'mbpt'];
    return self;
}

- (NSString *)AS_commandName {
    return @"importMailMailbox";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'mbpt':
            return @"at";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLLaunchCommand

- (NSString *)AS_commandName {
    return @"launch";
}

@end


@implementation MLMailtoCommand

- (NSString *)AS_commandName {
    return @"mailto";
}

@end


@implementation MLMakeCommand

- (MLMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (MLMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

- (MLMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

- (MLMakeCommand *)withProperties:(id)value {
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


@implementation MLMoveCommand

- (MLMoveCommand *)to:(id)value {
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


@implementation MLOpenCommand

- (NSString *)AS_commandName {
    return @"open";
}

@end


@implementation MLOpenLocationCommand

- (MLOpenLocationCommand *)window:(id)value {
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


@implementation MLPerformMailActionWithMessagesCommand

- (MLPerformMailActionWithMessagesCommand *)forRule:(id)value {
    [AS_event setParameter: value forKeyword: 'pmar'];
    return self;
}

- (MLPerformMailActionWithMessagesCommand *)inMailboxes:(id)value {
    [AS_event setParameter: value forKeyword: 'pmbx'];
    return self;
}

- (NSString *)AS_commandName {
    return @"performMailActionWithMessages";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'pmar':
            return @"forRule";
        case 'pmbx':
            return @"inMailboxes";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLPrintCommand

- (MLPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;
}

- (MLPrintCommand *)withProperties:(id)value {
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


@implementation MLQuitCommand

- (MLQuitCommand *)saving:(id)value {
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


@implementation MLRedirectCommand

- (MLRedirectCommand *)openingWindow:(id)value {
    [AS_event setParameter: value forKeyword: 'ropw'];
    return self;
}

- (NSString *)AS_commandName {
    return @"redirect";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'ropw':
            return @"openingWindow";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLReopenCommand

- (NSString *)AS_commandName {
    return @"reopen";
}

@end


@implementation MLReplyCommand

- (MLReplyCommand *)openingWindow:(id)value {
    [AS_event setParameter: value forKeyword: 'ropw'];
    return self;
}

- (MLReplyCommand *)replyToAll:(id)value {
    [AS_event setParameter: value forKeyword: 'rpal'];
    return self;
}

- (NSString *)AS_commandName {
    return @"reply";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'ropw':
            return @"openingWindow";
        case 'rpal':
            return @"replyToAll";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation MLRunCommand

- (NSString *)AS_commandName {
    return @"run";
}

@end


@implementation MLSaveCommand

- (MLSaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;
}

- (MLSaveCommand *)in:(id)value {
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


@implementation MLSend_Command

- (NSString *)AS_commandName {
    return @"send_";
}

@end


@implementation MLSetCommand

- (MLSetCommand *)to:(id)value {
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


@implementation MLSynchronizeCommand

- (MLSynchronizeCommand *)with:(id)value {
    [AS_event setParameter: value forKeyword: 'acna'];
    return self;
}

- (NSString *)AS_commandName {
    return @"synchronize";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'acna':
            return @"with";
    }
    return [super AS_parameterNameForCode: code];
}

@end


