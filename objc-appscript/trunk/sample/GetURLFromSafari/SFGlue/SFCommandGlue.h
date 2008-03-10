/*
 * SFCommandGlue.h
 *
 * /Applications/Safari.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface SFActivateCommand : ASCommand
@end


@interface SFCloseCommand : ASCommand
- (SFCloseCommand *)saving:(id)value;
- (SFCloseCommand *)savingIn:(id)value;
@end


@interface SFCountCommand : ASCommand
- (SFCountCommand *)each:(id)value;
@end


@interface SFDeleteCommand : ASCommand
@end


@interface SFDoJavaScriptCommand : ASCommand
- (SFDoJavaScriptCommand *)in:(id)value;
@end


@interface SFDuplicateCommand : ASCommand
- (SFDuplicateCommand *)to:(id)value;
- (SFDuplicateCommand *)withProperties:(id)value;
@end


@interface SFEmailContentsCommand : ASCommand
- (SFEmailContentsCommand *)of:(id)value;
@end


@interface SFExistsCommand : ASCommand
@end


@interface SFGetCommand : ASCommand
@end


@interface SFLaunchCommand : ASCommand
@end


@interface SFMakeCommand : ASCommand
- (SFMakeCommand *)at:(id)value;
- (SFMakeCommand *)new_:(id)value;
- (SFMakeCommand *)withData:(id)value;
- (SFMakeCommand *)withProperties:(id)value;
@end


@interface SFMoveCommand : ASCommand
- (SFMoveCommand *)to:(id)value;
@end


@interface SFOpenCommand : ASCommand
@end


@interface SFOpenLocationCommand : ASCommand
- (SFOpenLocationCommand *)window:(id)value;
@end


@interface SFPrintCommand : ASCommand
- (SFPrintCommand *)printDialog:(id)value;
- (SFPrintCommand *)withProperties:(id)value;
@end


@interface SFQuitCommand : ASCommand
- (SFQuitCommand *)saving:(id)value;
@end


@interface SFReopenCommand : ASCommand
@end


@interface SFRunCommand : ASCommand
@end


@interface SFSaveCommand : ASCommand
- (SFSaveCommand *)as:(id)value;
- (SFSaveCommand *)in:(id)value;
@end


@interface SFSetCommand : ASCommand
- (SFSetCommand *)to:(id)value;
@end


@interface SFShowBookmarksCommand : ASCommand
@end


