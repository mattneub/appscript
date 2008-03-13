/*
 * SECommandGlue.m
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.3.2
 *
 */

#import "SECommandGlue.h"

@implementation SEAbortTransaction_Command

@end


@implementation SEActivateCommand

@end


@implementation SEAttachActionToCommand

- (SEAttachActionToCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

@end


@implementation SEAttachedScriptsCommand

@end


@implementation SEBeginTransaction_Command

@end


@implementation SECancelCommand

@end


@implementation SEClickCommand

- (SEClickCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
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

@end


@implementation SEConfirmCommand

@end


@implementation SEConnectCommand

@end


@implementation SECountCommand

- (SECountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

@end


@implementation SEDecrementCommand

@end


@implementation SEDeleteCommand

@end


@implementation SEDisconnectCommand

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

@end


@implementation SEDoScriptCommand

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

@end


@implementation SEEndTransaction_Command

@end


@implementation SEExistsCommand

@end


@implementation SEGetCommand

@end


@implementation SEIncrementCommand

@end


@implementation SEKeyCodeCommand

- (SEKeyCodeCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

@end


@implementation SEKeyDownCommand

@end


@implementation SEKeyUpCommand

@end


@implementation SEKeystrokeCommand

- (SEKeystrokeCommand *)using:(id)value {
    [AS_event setParameter: value forKeyword: 'faal'];
    return self;
}

@end


@implementation SELaunchCommand

@end


@implementation SELogOutCommand

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

@end


@implementation SEMoveCommand

- (SEMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation SEOpenCommand

@end


@implementation SEOpenLocationCommand

- (SEOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;
}

@end


@implementation SEPerformCommand

@end


@implementation SEPickCommand

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

@end


@implementation SEQuitCommand

- (SEQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
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

@end


@implementation SEReopenCommand

@end


@implementation SERestartCommand

@end


@implementation SERunCommand

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

@end


@implementation SESelectCommand

@end


@implementation SESetCommand

- (SESetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


@implementation SEShutDownCommand

@end


@implementation SESleepCommand

@end


