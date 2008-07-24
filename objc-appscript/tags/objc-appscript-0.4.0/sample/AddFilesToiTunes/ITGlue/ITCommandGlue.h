/*
 * ITCommandGlue.h
 *
 * /Applications/iTunes.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface ITActivateCommand : ASCommand
@end


@interface ITAddCommand : ASCommand
- (ITAddCommand *)to:(id)value;
@end


@interface ITBackTrackCommand : ASCommand
@end


@interface ITCloseCommand : ASCommand
@end


@interface ITConvertCommand : ASCommand
@end


@interface ITCountCommand : ASCommand
- (ITCountCommand *)each:(id)value;
@end


@interface ITDeleteCommand : ASCommand
@end


@interface ITDownloadCommand : ASCommand
@end


@interface ITDuplicateCommand : ASCommand
- (ITDuplicateCommand *)to:(id)value;
@end


@interface ITEjectCommand : ASCommand
@end


@interface ITExistsCommand : ASCommand
@end


@interface ITFastForwardCommand : ASCommand
@end


@interface ITGetCommand : ASCommand
@end


@interface ITLaunchCommand : ASCommand
@end


@interface ITMakeCommand : ASCommand
- (ITMakeCommand *)at:(id)value;
- (ITMakeCommand *)new_:(id)value;
- (ITMakeCommand *)withProperties:(id)value;
@end


@interface ITMoveCommand : ASCommand
- (ITMoveCommand *)to:(id)value;
@end


@interface ITNextTrackCommand : ASCommand
@end


@interface ITOpenCommand : ASCommand
@end


@interface ITOpenLocationCommand : ASCommand
@end


@interface ITPauseCommand : ASCommand
@end


@interface ITPlayCommand : ASCommand
- (ITPlayCommand *)once:(id)value;
@end


@interface ITPlaypauseCommand : ASCommand
@end


@interface ITPreviousTrackCommand : ASCommand
@end


@interface ITPrintCommand : ASCommand
- (ITPrintCommand *)kind:(id)value;
- (ITPrintCommand *)printDialog:(id)value;
- (ITPrintCommand *)theme:(id)value;
- (ITPrintCommand *)withProperties:(id)value;
@end


@interface ITQuitCommand : ASCommand
@end


@interface ITRefreshCommand : ASCommand
@end


@interface ITReopenCommand : ASCommand
@end


@interface ITResumeCommand : ASCommand
@end


@interface ITRevealCommand : ASCommand
@end


@interface ITRewindCommand : ASCommand
@end


@interface ITRunCommand : ASCommand
@end


@interface ITSearchCommand : ASCommand
- (ITSearchCommand *)for_:(id)value;
- (ITSearchCommand *)only:(id)value;
@end


@interface ITSetCommand : ASCommand
- (ITSetCommand *)to:(id)value;
@end


@interface ITStopCommand : ASCommand
@end


@interface ITSubscribeCommand : ASCommand
@end


@interface ITUpdateCommand : ASCommand
@end


@interface ITUpdateAllPodcastsCommand : ASCommand
@end


@interface ITUpdatePodcastCommand : ASCommand
@end


