/*
 * MLCommandGlue.h
 *
 * /Applications/Mail.app
 * osaglue 0.4.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "MLReferenceRendererGlue.h"


@interface MLCommand : ASCommand
@end

@interface MLGetURLCommand : MLCommand
@end


@interface MLActivateCommand : MLCommand
@end


@interface MLBounceCommand : MLCommand
@end


@interface MLCheckForNewMailCommand : MLCommand
- (MLCheckForNewMailCommand *)for_:(id)value;
@end


@interface MLCloseCommand : MLCommand
- (MLCloseCommand *)saving:(id)value;
- (MLCloseCommand *)savingIn:(id)value;
@end


@interface MLCountCommand : MLCommand
- (MLCountCommand *)each:(id)value;
@end


@interface MLDeleteCommand : MLCommand
@end


@interface MLDuplicateCommand : MLCommand
- (MLDuplicateCommand *)to:(id)value;
@end


@interface MLExistsCommand : MLCommand
@end


@interface MLExtractAddressFromCommand : MLCommand
@end


@interface MLExtractNameFromCommand : MLCommand
@end


@interface MLForwardCommand : MLCommand
- (MLForwardCommand *)openingWindow:(id)value;
@end


@interface MLGetCommand : MLCommand
@end


@interface MLImportMailMailboxCommand : MLCommand
- (MLImportMailMailboxCommand *)at:(id)value;
@end


@interface MLLaunchCommand : MLCommand
@end


@interface MLMailtoCommand : MLCommand
@end


@interface MLMakeCommand : MLCommand
- (MLMakeCommand *)at:(id)value;
- (MLMakeCommand *)new_:(id)value;
- (MLMakeCommand *)withData:(id)value;
- (MLMakeCommand *)withProperties:(id)value;
@end


@interface MLMoveCommand : MLCommand
- (MLMoveCommand *)to:(id)value;
@end


@interface MLOpenCommand : MLCommand
@end


@interface MLOpenLocationCommand : MLCommand
- (MLOpenLocationCommand *)window:(id)value;
@end


@interface MLPerformMailActionWithMessagesCommand : MLCommand
- (MLPerformMailActionWithMessagesCommand *)forRule:(id)value;
- (MLPerformMailActionWithMessagesCommand *)inMailboxes:(id)value;
@end


@interface MLPrintCommand : MLCommand
- (MLPrintCommand *)printDialog:(id)value;
- (MLPrintCommand *)withProperties:(id)value;
@end


@interface MLQuitCommand : MLCommand
- (MLQuitCommand *)saving:(id)value;
@end


@interface MLRedirectCommand : MLCommand
- (MLRedirectCommand *)openingWindow:(id)value;
@end


@interface MLReopenCommand : MLCommand
@end


@interface MLReplyCommand : MLCommand
- (MLReplyCommand *)openingWindow:(id)value;
- (MLReplyCommand *)replyToAll:(id)value;
@end


@interface MLRunCommand : MLCommand
@end


@interface MLSaveCommand : MLCommand
- (MLSaveCommand *)as:(id)value;
- (MLSaveCommand *)in:(id)value;
@end


@interface MLSend_Command : MLCommand
@end


@interface MLSetCommand : MLCommand
- (MLSetCommand *)to:(id)value;
@end


@interface MLSynchronizeCommand : MLCommand
- (MLSynchronizeCommand *)with:(id)value;
@end


