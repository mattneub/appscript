/*
 * SECommandGlue.h
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface SEAbortTransaction_Command : ASCommand
@end


@interface SEActivateCommand : ASCommand
@end


@interface SEAttachActionToCommand : ASCommand
- (SEAttachActionToCommand *)using:(id)value;
@end


@interface SEAttachedScriptsCommand : ASCommand
@end


@interface SEBeginTransaction_Command : ASCommand
@end


@interface SECancelCommand : ASCommand
@end


@interface SEClickCommand : ASCommand
- (SEClickCommand *)at:(id)value;
@end


@interface SECloseCommand : ASCommand
- (SECloseCommand *)saving:(id)value;
- (SECloseCommand *)savingIn:(id)value;
@end


@interface SEConfirmCommand : ASCommand
@end


@interface SEConnectCommand : ASCommand
@end


@interface SECountCommand : ASCommand
- (SECountCommand *)each:(id)value;
@end


@interface SEDecrementCommand : ASCommand
@end


@interface SEDeleteCommand : ASCommand
@end


@interface SEDisconnectCommand : ASCommand
@end


@interface SEDoFolderActionCommand : ASCommand
- (SEDoFolderActionCommand *)folderActionCode:(id)value;
- (SEDoFolderActionCommand *)withItemList:(id)value;
- (SEDoFolderActionCommand *)withWindowSize:(id)value;
@end


@interface SEDoScriptCommand : ASCommand
@end


@interface SEDuplicateCommand : ASCommand
- (SEDuplicateCommand *)to:(id)value;
- (SEDuplicateCommand *)withProperties:(id)value;
@end


@interface SEEditActionOfCommand : ASCommand
- (SEEditActionOfCommand *)usingActionName:(id)value;
- (SEEditActionOfCommand *)usingActionNumber:(id)value;
@end


@interface SEEndTransaction_Command : ASCommand
@end


@interface SEExistsCommand : ASCommand
@end


@interface SEGetCommand : ASCommand
@end


@interface SEIncrementCommand : ASCommand
@end


@interface SEKeyCodeCommand : ASCommand
- (SEKeyCodeCommand *)using:(id)value;
@end


@interface SEKeyDownCommand : ASCommand
@end


@interface SEKeyUpCommand : ASCommand
@end


@interface SEKeystrokeCommand : ASCommand
- (SEKeystrokeCommand *)using:(id)value;
@end


@interface SELaunchCommand : ASCommand
@end


@interface SELogOutCommand : ASCommand
@end


@interface SEMakeCommand : ASCommand
- (SEMakeCommand *)at:(id)value;
- (SEMakeCommand *)new_:(id)value;
- (SEMakeCommand *)withData:(id)value;
- (SEMakeCommand *)withProperties:(id)value;
@end


@interface SEMoveCommand : ASCommand
- (SEMoveCommand *)to:(id)value;
@end


@interface SEOpenCommand : ASCommand
@end


@interface SEOpenLocationCommand : ASCommand
- (SEOpenLocationCommand *)window:(id)value;
@end


@interface SEPerformCommand : ASCommand
@end


@interface SEPickCommand : ASCommand
@end


@interface SEPrintCommand : ASCommand
- (SEPrintCommand *)printDialog:(id)value;
- (SEPrintCommand *)withProperties:(id)value;
@end


@interface SEQuitCommand : ASCommand
- (SEQuitCommand *)saving:(id)value;
@end


@interface SERemoveActionFromCommand : ASCommand
- (SERemoveActionFromCommand *)usingActionName:(id)value;
- (SERemoveActionFromCommand *)usingActionNumber:(id)value;
@end


@interface SEReopenCommand : ASCommand
@end


@interface SERestartCommand : ASCommand
@end


@interface SERunCommand : ASCommand
@end


@interface SESaveCommand : ASCommand
- (SESaveCommand *)as:(id)value;
- (SESaveCommand *)in:(id)value;
@end


@interface SESelectCommand : ASCommand
@end


@interface SESetCommand : ASCommand
- (SESetCommand *)to:(id)value;
@end


@interface SEShutDownCommand : ASCommand
@end


@interface SESleepCommand : ASCommand
@end


