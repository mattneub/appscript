/*
 * SFCommandGlue.h
 * /Applications/Safari.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "SFReferenceRendererGlue.h"

@interface SFCommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface SFActivateCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFCloseCommand : SFCommand
- (SFCloseCommand *)saving:(id)value;
- (SFCloseCommand *)savingIn:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFCountCommand : SFCommand
- (SFCountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFDeleteCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFDoJavaScriptCommand : SFCommand
- (SFDoJavaScriptCommand *)in:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFDuplicateCommand : SFCommand
- (SFDuplicateCommand *)to:(id)value;
- (SFDuplicateCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFEmailContentsCommand : SFCommand
- (SFEmailContentsCommand *)of:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFExistsCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFGetCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFLaunchCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFMakeCommand : SFCommand
- (SFMakeCommand *)at:(id)value;
- (SFMakeCommand *)new_:(id)value;
- (SFMakeCommand *)withData:(id)value;
- (SFMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFMoveCommand : SFCommand
- (SFMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFOpenCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFOpenLocationCommand : SFCommand
- (SFOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFPrintCommand : SFCommand
- (SFPrintCommand *)printDialog:(id)value;
- (SFPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFQuitCommand : SFCommand
- (SFQuitCommand *)saving:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFReopenCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFRunCommand : SFCommand
- (NSString *)AS_commandName;
@end


@interface SFSaveCommand : SFCommand
- (SFSaveCommand *)as:(id)value;
- (SFSaveCommand *)in:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFSetCommand : SFCommand
- (SFSetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SFShowBookmarksCommand : SFCommand
- (NSString *)AS_commandName;
@end

