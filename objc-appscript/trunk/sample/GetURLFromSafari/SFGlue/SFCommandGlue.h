/*
 * SFCommandGlue.h
 *
 * /Applications/Safari.app
 * osaglue 0.4.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "SFReferenceRendererGlue.h"


@interface SFCommand : ASCommand
@end

@interface SFActivateCommand : SFCommand
@end


@interface SFCloseCommand : SFCommand
- (SFCloseCommand *)saving:(id)value;
- (SFCloseCommand *)savingIn:(id)value;
@end


@interface SFCountCommand : SFCommand
- (SFCountCommand *)each:(id)value;
@end


@interface SFDeleteCommand : SFCommand
@end


@interface SFDoJavaScriptCommand : SFCommand
- (SFDoJavaScriptCommand *)in:(id)value;
@end


@interface SFDuplicateCommand : SFCommand
- (SFDuplicateCommand *)to:(id)value;
- (SFDuplicateCommand *)withProperties:(id)value;
@end


@interface SFEmailContentsCommand : SFCommand
- (SFEmailContentsCommand *)of:(id)value;
@end


@interface SFExistsCommand : SFCommand
@end


@interface SFGetCommand : SFCommand
@end


@interface SFLaunchCommand : SFCommand
@end


@interface SFMakeCommand : SFCommand
- (SFMakeCommand *)at:(id)value;
- (SFMakeCommand *)new_:(id)value;
- (SFMakeCommand *)withData:(id)value;
- (SFMakeCommand *)withProperties:(id)value;
@end


@interface SFMoveCommand : SFCommand
- (SFMoveCommand *)to:(id)value;
@end


@interface SFOpenCommand : SFCommand
@end


@interface SFOpenLocationCommand : SFCommand
- (SFOpenLocationCommand *)window:(id)value;
@end


@interface SFPrintCommand : SFCommand
- (SFPrintCommand *)printDialog:(id)value;
- (SFPrintCommand *)withProperties:(id)value;
@end


@interface SFQuitCommand : SFCommand
- (SFQuitCommand *)saving:(id)value;
@end


@interface SFReopenCommand : SFCommand
@end


@interface SFRunCommand : SFCommand
@end


@interface SFSaveCommand : SFCommand
- (SFSaveCommand *)as:(id)value;
- (SFSaveCommand *)in:(id)value;
@end


@interface SFSetCommand : SFCommand
- (SFSetCommand *)to:(id)value;
@end


@interface SFShowBookmarksCommand : SFCommand
@end


