/*
 * SECommandGlue.m
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.4.0
 *
 */

#import "SECommandGlue.h"

@implementation SECommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData{
    return [SEReferenceRenderer formatObject: obj appData: appData];
}
@end

@implementation SEAbortTransaction_Command

- (NSString *)AS_commandName {
    return @"abortTransaction_";
}

@end


@implementation SEActivateCommand

- (NSString *)AS_commandName {
    return @"activate";
}

@end


@implementation SEAttachActionToCommand

- (SEAttachActionToCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

- (NSString *)AS_commandName {
    return @"attachActionTo";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'faal':
            return @"using";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SEAttachedScriptsCommand

- (NSString *)AS_commandName {
    return @"attachedScripts";
}

@end


@implementation SEBeginTransaction_Command

- (NSString *)AS_commandName {
    return @"beginTransaction_";
}

@end


@implementation SECancelCommand

- (NSString *)AS_commandName {
    return @"cancel";
}

@end


@implementation SEClickCommand

- (SEClickCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (NSString *)AS_commandName {
    return @"click";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'insh':
            return @"at";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SECloseCommand

- (SECloseCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

- (SECloseCommand *)savingIn:(id)value {
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


@implementation SEConfirmCommand

- (NSString *)AS_commandName {
    return @"confirm";
}

@end


@implementation SEConnectCommand

- (NSString *)AS_commandName {
    return @"connect";
}

@end


@implementation SECountCommand

- (SECountCommand *)each:(id)value {
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


@implementation SEDecrementCommand

- (NSString *)AS_commandName {
    return @"decrement";
}

@end


@implementation SEDeleteCommand

- (NSString *)AS_commandName {
    return @"delete";
}

@end


@implementation SEDisconnectCommand

- (NSString *)AS_commandName {
    return @"disconnect";
}

@end


@implementation SEDoFolderActionCommand

- (SEDoFolderActionCommand *)folderActionCode:(id)value {
    [AS_event setParameter: value forKeyword: 'actn'];
    return self;
}

- (SEDoFolderActionCommand *)withItemList:(id)value {
    [AS_event setParameter: value forKeyword: 'flst'];
    return self;
}

- (SEDoFolderActionCommand *)withWindowSize:(id)value {
    [AS_event setParameter: value forKeyword: 'fnsz'];
    return self;
}

- (NSString *)AS_commandName {
    return @"doFolderAction";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'actn':
            return @"folderActionCode";
        case 'flst':
            return @"withItemList";
        case 'fnsz':
            return @"withWindowSize";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SEDoScriptCommand

- (NSString *)AS_commandName {
    return @"doScript";
}

@end


@implementation SEDuplicateCommand

- (SEDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (SEDuplicateCommand *)withProperties:(id)value {
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


@implementation SEEditActionOfCommand

- (SEEditActionOfCommand *)usingActionName:(id)value {
    [AS_event setParameter: value forKeyword: 'snam'];
    return self;
}

- (SEEditActionOfCommand *)usingActionNumber:(id)value {
    [AS_event setParameter: value forKeyword: 'indx'];
    return self;
}

- (NSString *)AS_commandName {
    return @"editActionOf";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'snam':
            return @"usingActionName";
        case 'indx':
            return @"usingActionNumber";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SEEndTransaction_Command

- (NSString *)AS_commandName {
    return @"endTransaction_";
}

@end


@implementation SEExistsCommand

- (NSString *)AS_commandName {
    return @"exists";
}

@end


@implementation SEGetCommand

- (NSString *)AS_commandName {
    return @"get";
}

@end


@implementation SEIncrementCommand

- (NSString *)AS_commandName {
    return @"increment";
}

@end


@implementation SEKeyCodeCommand

- (SEKeyCodeCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

- (NSString *)AS_commandName {
    return @"keyCode";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'faal':
            return @"using";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SEKeyDownCommand

- (NSString *)AS_commandName {
    return @"keyDown";
}

@end


@implementation SEKeyUpCommand

- (NSString *)AS_commandName {
    return @"keyUp";
}

@end


@implementation SEKeystrokeCommand

- (SEKeystrokeCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

- (NSString *)AS_commandName {
    return @"keystroke";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'faal':
            return @"using";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SELaunchCommand

- (NSString *)AS_commandName {
    return @"launch";
}

@end


@implementation SELogOutCommand

- (NSString *)AS_commandName {
    return @"logOut";
}

@end


@implementation SEMakeCommand

- (SEMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (SEMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

- (SEMakeCommand *)withData:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

- (SEMakeCommand *)withProperties:(id)value {
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


@implementation SEMoveCommand

- (SEMoveCommand *)to:(id)value {
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


@implementation SEOpenCommand

- (NSString *)AS_commandName {
    return @"open";
}

@end


@implementation SEOpenLocationCommand

- (SEOpenLocationCommand *)window:(id)value {
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


@implementation SEPerformCommand

- (NSString *)AS_commandName {
    return @"perform";
}

@end


@implementation SEPickCommand

- (NSString *)AS_commandName {
    return @"pick";
}

@end


@implementation SEPrintCommand

- (SEPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;
}

- (SEPrintCommand *)withProperties:(id)value {
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


@implementation SEQuitCommand

- (SEQuitCommand *)saving:(id)value {
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


@implementation SERemoveActionFromCommand

- (SERemoveActionFromCommand *)usingActionName:(id)value {
    [AS_event setParameter: value forKeyword: 'snam'];
    return self;
}

- (SERemoveActionFromCommand *)usingActionNumber:(id)value {
    [AS_event setParameter: value forKeyword: 'indx'];
    return self;
}

- (NSString *)AS_commandName {
    return @"removeActionFrom";
}

- (NSString *)AS_parameterNameForCode:(DescType)code {
    switch (code) {
        case 'snam':
            return @"usingActionName";
        case 'indx':
            return @"usingActionNumber";
    }
    return [super AS_parameterNameForCode: code];
}

@end


@implementation SEReopenCommand

- (NSString *)AS_commandName {
    return @"reopen";
}

@end


@implementation SERestartCommand

- (NSString *)AS_commandName {
    return @"restart";
}

@end


@implementation SERunCommand

- (NSString *)AS_commandName {
    return @"run";
}

@end


@implementation SESaveCommand

- (SESaveCommand *)as:(id)value {
    [AS_event setParameter: value forKeyword: 'fltp'];
    return self;
}

- (SESaveCommand *)in:(id)value {
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


@implementation SESelectCommand

- (NSString *)AS_commandName {
    return @"select";
}

@end


@implementation SESetCommand

- (SESetCommand *)to:(id)value {
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


@implementation SEShutDownCommand

- (NSString *)AS_commandName {
    return @"shutDown";
}

@end


@implementation SESleepCommand

- (NSString *)AS_commandName {
    return @"sleep";
}

@end


