/*
 * SFCommandGlue.m
 *
 * /Applications/Safari.app
 * osaglue 0.3.2
 *
 */

#import "SFCommandGlue.h"

@implementation SFActivateCommand

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

@end


@implementation SFCountCommand

- (SFCountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

@end


@implementation SFDeleteCommand

@end


@implementation SFDoJavaScriptCommand

- (SFDoJavaScriptCommand *)in:(id)value {
    [AS_event setParameter: value forKeyword: 'dcnm'];
    return self;
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

@end


@implementation SFEmailContentsCommand

- (SFEmailContentsCommand *)of:(id)value {
    [AS_event setParameter: value forKeyword: 'dcnm'];
    return self;
}

@end


@implementation SFExistsCommand

@end


@implementation SFGetCommand

@end


@implementation SFLaunchCommand

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

@end


@implementation SFMoveCommand

- (SFMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation SFOpenCommand

@end


@implementation SFOpenLocationCommand

- (SFOpenLocationCommand *)window:(id)value {
    [AS_event setParameter: value forKeyword: 'WIND'];
    return self;
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

@end


@implementation SFQuitCommand

- (SFQuitCommand *)saving:(id)value {
    [AS_event setParameter: value forKeyword: 'savo'];
    return self;
}

@end


@implementation SFReopenCommand

@end


@implementation SFRunCommand

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

@end


@implementation SFSetCommand

- (SFSetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


@implementation SFShowBookmarksCommand

@end


