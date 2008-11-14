/*
 * TECommandGlue.h
 * /Applications/TextEdit.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "TEReferenceRendererGlue.h"

@interface TECommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface TEActivateCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TECloseCommand : TECommand
- (TECloseCommand *)saving:(id)value;
- (TECloseCommand *)savingIn:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TECountCommand : TECommand
- (TECountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEDeleteCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TEDuplicateCommand : TECommand
- (TEDuplicateCommand *)to:(id)value;
- (TEDuplicateCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEExistsCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TEGetCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TELaunchCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TEMakeCommand : TECommand
- (TEMakeCommand *)at:(id)value;
- (TEMakeCommand *)new_:(id)value;
- (TEMakeCommand *)withData:(id)value;
- (TEMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEMoveCommand : TECommand
- (TEMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEOpenCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TEOpenLocationCommand : TECommand
- (TEOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEPrintCommand : TECommand
- (TEPrintCommand *)printDialog:(id)value;
- (TEPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEQuitCommand : TECommand
- (TEQuitCommand *)saving:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TEReopenCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TERunCommand : TECommand
- (NSString *)AS_commandName;
@end


@interface TESaveCommand : TECommand
- (TESaveCommand *)as:(id)value;
- (TESaveCommand *)in:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface TESetCommand : TECommand
- (TESetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end

