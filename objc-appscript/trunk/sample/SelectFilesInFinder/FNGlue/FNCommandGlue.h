/*
 * FNCommandGlue.h
 *
 * /System/Library/CoreServices/Finder.app
 * osaglue 0.4.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "FNReferenceRendererGlue.h"


@interface FNCommand : ASCommand
@end

@interface FNActivateCommand : FNCommand
@end


@interface FNCleanUpCommand : FNCommand
- (FNCleanUpCommand *)by:(id)value;
@end


@interface FNCloseCommand : FNCommand
@end


@interface FNCopy_Command : FNCommand
@end


@interface FNCountCommand : FNCommand
- (FNCountCommand *)each:(id)value;
@end


@interface FNDataSizeCommand : FNCommand
- (FNDataSizeCommand *)as:(id)value;
@end


@interface FNDeleteCommand : FNCommand
@end


@interface FNDuplicateCommand : FNCommand
- (FNDuplicateCommand *)replacing:(id)value;
- (FNDuplicateCommand *)routingSuppressed:(id)value;
- (FNDuplicateCommand *)to:(id)value;
@end


@interface FNEjectCommand : FNCommand
@end


@interface FNEmptyCommand : FNCommand
- (FNEmptyCommand *)security:(id)value;
@end


@interface FNEraseCommand : FNCommand
@end


@interface FNExistsCommand : FNCommand
@end


@interface FNGetCommand : FNCommand
@end


@interface FNLaunchCommand : FNCommand
@end


@interface FNMakeCommand : FNCommand
- (FNMakeCommand *)at:(id)value;
- (FNMakeCommand *)new_:(id)value;
- (FNMakeCommand *)to:(id)value;
- (FNMakeCommand *)withProperties:(id)value;
@end


@interface FNMoveCommand : FNCommand
- (FNMoveCommand *)positionedAt:(id)value;
- (FNMoveCommand *)replacing:(id)value;
- (FNMoveCommand *)routingSuppressed:(id)value;
- (FNMoveCommand *)to:(id)value;
@end


@interface FNOpenCommand : FNCommand
- (FNOpenCommand *)using:(id)value;
- (FNOpenCommand *)withProperties:(id)value;
@end


@interface FNOpenLocationCommand : FNCommand
- (FNOpenLocationCommand *)window:(id)value;
@end


@interface FNPrintCommand : FNCommand
- (FNPrintCommand *)withProperties:(id)value;
@end


@interface FNQuitCommand : FNCommand
@end


@interface FNReopenCommand : FNCommand
@end


@interface FNRestartCommand : FNCommand
@end


@interface FNRevealCommand : FNCommand
@end


@interface FNRunCommand : FNCommand
@end


@interface FNSelectCommand : FNCommand
@end


@interface FNSetCommand : FNCommand
- (FNSetCommand *)to:(id)value;
@end


@interface FNShutDownCommand : FNCommand
@end


@interface FNSleepCommand : FNCommand
@end


@interface FNSortCommand : FNCommand
- (FNSortCommand *)by:(id)value;
@end


@interface FNUpdateCommand : FNCommand
- (FNUpdateCommand *)necessity:(id)value;
- (FNUpdateCommand *)registeringApplications:(id)value;
@end


