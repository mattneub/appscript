/*
 * ITCommandGlue.m
 *
 * /Applications/iTunes.app
 * osaglue 0.3.2
 *
 */

#import "ITCommandGlue.h"

@implementation ITActivateCommand

@end


@implementation ITAddCommand

- (ITAddCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation ITBackTrackCommand

@end


@implementation ITCloseCommand

@end


@implementation ITConvertCommand

@end


@implementation ITCountCommand

- (ITCountCommand *)each:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

@end


@implementation ITDeleteCommand

@end


@implementation ITDownloadCommand

@end


@implementation ITDuplicateCommand

- (ITDuplicateCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation ITEjectCommand

@end


@implementation ITExistsCommand

@end


@implementation ITFastForwardCommand

@end


@implementation ITGetCommand

@end


@implementation ITLaunchCommand

@end


@implementation ITMakeCommand

- (ITMakeCommand *)at:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

- (ITMakeCommand *)new_:(id)value {
    [AS_event setParameter: value forKeyword: 'kocl'];
    return self;
}

- (ITMakeCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation ITMoveCommand

- (ITMoveCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'insh'];
    return self;
}

@end


@implementation ITNextTrackCommand

@end


@implementation ITOpenCommand

@end


@implementation ITOpenLocationCommand

@end


@implementation ITPauseCommand

@end


@implementation ITPlayCommand

- (ITPlayCommand *)once:(id)value {
    [AS_event setParameter: value forKeyword: 'POne'];
    return self;
}

@end


@implementation ITPlaypauseCommand

@end


@implementation ITPreviousTrackCommand

@end


@implementation ITPrintCommand

- (ITPrintCommand *)kind:(id)value {
    [AS_event setParameter: value forKeyword: 'pKnd'];
    return self;
}

- (ITPrintCommand *)printDialog:(id)value {
    [AS_event setParameter: value forKeyword: 'pdlg'];
    return self;
}

- (ITPrintCommand *)theme:(id)value {
    [AS_event setParameter: value forKeyword: 'pThm'];
    return self;
}

- (ITPrintCommand *)withProperties:(id)value {
    [AS_event setParameter: value forKeyword: 'prdt'];
    return self;
}

@end


@implementation ITQuitCommand

@end


@implementation ITRefreshCommand

@end


@implementation ITReopenCommand

@end


@implementation ITResumeCommand

@end


@implementation ITRevealCommand

@end


@implementation ITRewindCommand

@end


@implementation ITRunCommand

@end


@implementation ITSearchCommand

- (ITSearchCommand *)for_:(id)value {
    [AS_event setParameter: value forKeyword: 'pTrm'];
    return self;
}

- (ITSearchCommand *)only:(id)value {
    [AS_event setParameter: value forKeyword: 'pAre'];
    return self;
}

@end


@implementation ITSetCommand

- (ITSetCommand *)to:(id)value {
    [AS_event setParameter: value forKeyword: 'data'];
    return self;
}

@end


@implementation ITStopCommand

@end


@implementation ITSubscribeCommand

@end


@implementation ITUpdateCommand

@end


@implementation ITUpdateAllPodcastsCommand

@end


@implementation ITUpdatePodcastCommand

@end


