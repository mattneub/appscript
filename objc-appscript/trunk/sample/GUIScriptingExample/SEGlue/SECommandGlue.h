/*
 * SECommandGlue.h
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "SEReferenceRendererGlue.h"

@interface SECommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface SEAbortTransaction_Command : SECommand
- (NSString *)AS_commandName;
@end


@interface SEActivateCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEAttachActionToCommand : SECommand
- (SEAttachActionToCommand *)using:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEAttachedScriptsCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEBeginTransaction_Command : SECommand
- (NSString *)AS_commandName;
@end


@interface SECancelCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEClickCommand : SECommand
- (SEClickCommand *)at:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SECloseCommand : SECommand
- (SECloseCommand *)saving:(id)value;
- (SECloseCommand *)savingIn:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEConfirmCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEConnectCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SECountCommand : SECommand
- (SECountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEDecrementCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEDeleteCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEDisconnectCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEDoFolderActionCommand : SECommand
- (SEDoFolderActionCommand *)folderActionCode:(id)value;
- (SEDoFolderActionCommand *)withItemList:(id)value;
- (SEDoFolderActionCommand *)withWindowSize:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEDoScriptCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEDuplicateCommand : SECommand
- (SEDuplicateCommand *)to:(id)value;
- (SEDuplicateCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEEditActionOfCommand : SECommand
- (SEEditActionOfCommand *)usingActionName:(id)value;
- (SEEditActionOfCommand *)usingActionNumber:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEEndTransaction_Command : SECommand
- (NSString *)AS_commandName;
@end


@interface SEExistsCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEGetCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEIncrementCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEKeyCodeCommand : SECommand
- (SEKeyCodeCommand *)using:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEKeyDownCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEKeyUpCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEKeystrokeCommand : SECommand
- (SEKeystrokeCommand *)using:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SELaunchCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SELogOutCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEMakeCommand : SECommand
- (SEMakeCommand *)at:(id)value;
- (SEMakeCommand *)new_:(id)value;
- (SEMakeCommand *)withData:(id)value;
- (SEMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEMoveCommand : SECommand
- (SEMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEOpenCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEOpenLocationCommand : SECommand
- (SEOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEPerformCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEPickCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SEPrintCommand : SECommand
- (SEPrintCommand *)printDialog:(id)value;
- (SEPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEQuitCommand : SECommand
- (SEQuitCommand *)saving:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SERemoveActionFromCommand : SECommand
- (SERemoveActionFromCommand *)usingActionName:(id)value;
- (SERemoveActionFromCommand *)usingActionNumber:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEReopenCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SERestartCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SERunCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SESaveCommand : SECommand
- (SESaveCommand *)as:(id)value;
- (SESaveCommand *)in:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SESelectCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SESetCommand : SECommand
- (SESetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface SEShutDownCommand : SECommand
- (NSString *)AS_commandName;
@end


@interface SESleepCommand : SECommand
- (NSString *)AS_commandName;
@end

