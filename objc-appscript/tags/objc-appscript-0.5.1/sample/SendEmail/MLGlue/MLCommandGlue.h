/*
 * MLCommandGlue.h
 * /Applications/Mail.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "MLReferenceRendererGlue.h"

@interface MLCommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface MLGetURLCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLActivateCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLBounceCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLCheckForNewMailCommand : MLCommand
- (MLCheckForNewMailCommand *)for_:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLCloseCommand : MLCommand
- (MLCloseCommand *)saving:(id)value;
- (MLCloseCommand *)savingIn:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLCountCommand : MLCommand
- (MLCountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLDeleteCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLDuplicateCommand : MLCommand
- (MLDuplicateCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLExistsCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLExtractAddressFromCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLExtractNameFromCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLForwardCommand : MLCommand
- (MLForwardCommand *)openingWindow:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLGetCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLImportMailMailboxCommand : MLCommand
- (MLImportMailMailboxCommand *)at:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLLaunchCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLMailtoCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLMakeCommand : MLCommand
- (MLMakeCommand *)at:(id)value;
- (MLMakeCommand *)new_:(id)value;
- (MLMakeCommand *)withData:(id)value;
- (MLMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLMoveCommand : MLCommand
- (MLMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLOpenCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLOpenLocationCommand : MLCommand
- (MLOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLPerformMailActionWithMessagesCommand : MLCommand
- (MLPerformMailActionWithMessagesCommand *)forRule:(id)value;
- (MLPerformMailActionWithMessagesCommand *)inMailboxes:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLPrintCommand : MLCommand
- (MLPrintCommand *)printDialog:(id)value;
- (MLPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLQuitCommand : MLCommand
- (MLQuitCommand *)saving:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLRedirectCommand : MLCommand
- (MLRedirectCommand *)openingWindow:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLReopenCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLReplyCommand : MLCommand
- (MLReplyCommand *)openingWindow:(id)value;
- (MLReplyCommand *)replyToAll:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLRunCommand : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLSaveCommand : MLCommand
- (MLSaveCommand *)as:(id)value;
- (MLSaveCommand *)in:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLSend_Command : MLCommand
- (NSString *)AS_commandName;
@end


@interface MLSetCommand : MLCommand
- (MLSetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface MLSynchronizeCommand : MLCommand
- (MLSynchronizeCommand *)with:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end

