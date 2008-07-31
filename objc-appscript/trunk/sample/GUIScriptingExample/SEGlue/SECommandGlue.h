/*
 * SECommandGlue.h
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.4.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "SEReferenceRendererGlue.h"


@interface SECommand : ASCommand
@end

@interface SEAbortTransaction_Command : SECommand
@end


@interface SEActivateCommand : SECommand
@end


@interface SEAttachActionToCommand : SECommand
- (SEAttachActionToCommand *)using:(id)value;
@end


@interface SEAttachedScriptsCommand : SECommand
@end


@interface SEBeginTransaction_Command : SECommand
@end


@interface SECancelCommand : SECommand
@end


@interface SEClickCommand : SECommand
- (SEClickCommand *)at:(id)value;
@end


@interface SECloseCommand : SECommand
- (SECloseCommand *)saving:(id)value;
- (SECloseCommand *)savingIn:(id)value;
@end


@interface SEConfirmCommand : SECommand
@end


@interface SEConnectCommand : SECommand
@end


@interface SECountCommand : SECommand
- (SECountCommand *)each:(id)value;
@end


@interface SEDecrementCommand : SECommand
@end


@interface SEDeleteCommand : SECommand
@end


@interface SEDisconnectCommand : SECommand
@end


@interface SEDoFolderActionCommand : SECommand
- (SEDoFolderActionCommand *)folderActionCode:(id)value;
- (SEDoFolderActionCommand *)withItemList:(id)value;
- (SEDoFolderActionCommand *)withWindowSize:(id)value;
@end


@interface SEDoScriptCommand : SECommand
@end


@interface SEDuplicateCommand : SECommand
- (SEDuplicateCommand *)to:(id)value;
- (SEDuplicateCommand *)withProperties:(id)value;
@end


@interface SEEditActionOfCommand : SECommand
- (SEEditActionOfCommand *)usingActionName:(id)value;
- (SEEditActionOfCommand *)usingActionNumber:(id)value;
@end


@interface SEEndTransaction_Command : SECommand
@end


@interface SEExistsCommand : SECommand
@end


@interface SEGetCommand : SECommand
@end


@interface SEIncrementCommand : SECommand
@end


@interface SEKeyCodeCommand : SECommand
- (SEKeyCodeCommand *)using:(id)value;
@end


@interface SEKeyDownCommand : SECommand
@end


@interface SEKeyUpCommand : SECommand
@end


@interface SEKeystrokeCommand : SECommand
- (SEKeystrokeCommand *)using:(id)value;
@end


@interface SELaunchCommand : SECommand
@end


@interface SELogOutCommand : SECommand
@end


@interface SEMakeCommand : SECommand
- (SEMakeCommand *)at:(id)value;
- (SEMakeCommand *)new_:(id)value;
- (SEMakeCommand *)withData:(id)value;
- (SEMakeCommand *)withProperties:(id)value;
@end


@interface SEMoveCommand : SECommand
- (SEMoveCommand *)to:(id)value;
@end


@interface SEOpenCommand : SECommand
@end


@interface SEOpenLocationCommand : SECommand
- (SEOpenLocationCommand *)window:(id)value;
@end


@interface SEPerformCommand : SECommand
@end


@interface SEPickCommand : SECommand
@end


@interface SEPrintCommand : SECommand
- (SEPrintCommand *)printDialog:(id)value;
- (SEPrintCommand *)withProperties:(id)value;
@end


@interface SEQuitCommand : SECommand
- (SEQuitCommand *)saving:(id)value;
@end


@interface SERemoveActionFromCommand : SECommand
- (SERemoveActionFromCommand *)usingActionName:(id)value;
- (SERemoveActionFromCommand *)usingActionNumber:(id)value;
@end


@interface SEReopenCommand : SECommand
@end


@interface SERestartCommand : SECommand
@end


@interface SERunCommand : SECommand
@end


@interface SESaveCommand : SECommand
- (SESaveCommand *)as:(id)value;
- (SESaveCommand *)in:(id)value;
@end


@interface SESelectCommand : SECommand
@end


@interface SESetCommand : SECommand
- (SESetCommand *)to:(id)value;
@end


@interface SEShutDownCommand : SECommand
@end


@interface SESleepCommand : SECommand
@end


