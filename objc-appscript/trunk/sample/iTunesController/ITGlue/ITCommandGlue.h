/*
 * ITCommandGlue.h
 * /Applications/iTunes.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "ITReferenceRendererGlue.h"

@interface ITCommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface ITActivateCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITAddCommand : ITCommand
- (ITAddCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITBackTrackCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITCloseCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITConvertCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITCountCommand : ITCommand
- (ITCountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITDeleteCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITDownloadCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITDuplicateCommand : ITCommand
- (ITDuplicateCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITEjectCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITExistsCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITFastForwardCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITGetCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITLaunchCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITMakeCommand : ITCommand
- (ITMakeCommand *)at:(id)value;
- (ITMakeCommand *)new_:(id)value;
- (ITMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITMoveCommand : ITCommand
- (ITMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITNextTrackCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITOpenCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITOpenLocationCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITPauseCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITPlayCommand : ITCommand
- (ITPlayCommand *)once:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITPlaypauseCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITPreviousTrackCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITPrintCommand : ITCommand
- (ITPrintCommand *)kind:(id)value;
- (ITPrintCommand *)printDialog:(id)value;
- (ITPrintCommand *)theme:(id)value;
- (ITPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITQuitCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITRefreshCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITReopenCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITResumeCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITRevealCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITRewindCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITRunCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITSearchCommand : ITCommand
- (ITSearchCommand *)for_:(id)value;
- (ITSearchCommand *)only:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITSetCommand : ITCommand
- (ITSetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ITStopCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITSubscribeCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITUpdateCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITUpdateAllPodcastsCommand : ITCommand
- (NSString *)AS_commandName;
@end


@interface ITUpdatePodcastCommand : ITCommand
- (NSString *)AS_commandName;
@end

