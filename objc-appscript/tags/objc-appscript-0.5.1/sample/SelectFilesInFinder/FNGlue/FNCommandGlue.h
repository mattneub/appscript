/*
 * FNCommandGlue.h
 * /System/Library/CoreServices/Finder.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "FNReferenceRendererGlue.h"

@interface FNCommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface FNActivateCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNCleanUpCommand : FNCommand
- (FNCleanUpCommand *)by:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNCloseCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNCopy_Command : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNCountCommand : FNCommand
- (FNCountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNDataSizeCommand : FNCommand
- (FNDataSizeCommand *)as:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNDeleteCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNDuplicateCommand : FNCommand
- (FNDuplicateCommand *)replacing:(id)value;
- (FNDuplicateCommand *)routingSuppressed:(id)value;
- (FNDuplicateCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNEjectCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNEmptyCommand : FNCommand
- (FNEmptyCommand *)security:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNEraseCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNExistsCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNGetCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNLaunchCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNMakeCommand : FNCommand
- (FNMakeCommand *)at:(id)value;
- (FNMakeCommand *)new_:(id)value;
- (FNMakeCommand *)to:(id)value;
- (FNMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNMoveCommand : FNCommand
- (FNMoveCommand *)positionedAt:(id)value;
- (FNMoveCommand *)replacing:(id)value;
- (FNMoveCommand *)routingSuppressed:(id)value;
- (FNMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNOpenCommand : FNCommand
- (FNOpenCommand *)using:(id)value;
- (FNOpenCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNOpenLocationCommand : FNCommand
- (FNOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNPrintCommand : FNCommand
- (FNPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNQuitCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNReopenCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNRestartCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNRevealCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNRunCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNSelectCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNSetCommand : FNCommand
- (FNSetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNShutDownCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNSleepCommand : FNCommand
- (NSString *)AS_commandName;
@end


@interface FNSortCommand : FNCommand
- (FNSortCommand *)by:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface FNUpdateCommand : FNCommand
- (FNUpdateCommand *)necessity:(id)value;
- (FNUpdateCommand *)registeringApplications:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end

