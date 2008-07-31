/*
 * TECommandGlue.h
 *
 * /Applications/TextEdit.app
 * osaglue 0.4.0
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"
#import "TEReferenceRendererGlue.h"


@interface TECommand : ASCommand
@end

@interface TEActivateCommand : TECommand
@end


@interface TECloseCommand : TECommand
- (TECloseCommand *)saving:(id)value;
- (TECloseCommand *)savingIn:(id)value;
@end


@interface TECountCommand : TECommand
- (TECountCommand *)each:(id)value;
@end


@interface TEDeleteCommand : TECommand
@end


@interface TEDuplicateCommand : TECommand
- (TEDuplicateCommand *)to:(id)value;
- (TEDuplicateCommand *)withProperties:(id)value;
@end


@interface TEExistsCommand : TECommand
@end


@interface TEGetCommand : TECommand
@end


@interface TELaunchCommand : TECommand
@end


@interface TEMakeCommand : TECommand
- (TEMakeCommand *)at:(id)value;
- (TEMakeCommand *)new_:(id)value;
- (TEMakeCommand *)withData:(id)value;
- (TEMakeCommand *)withProperties:(id)value;
@end


@interface TEMoveCommand : TECommand
- (TEMoveCommand *)to:(id)value;
@end


@interface TEOpenCommand : TECommand
@end


@interface TEOpenLocationCommand : TECommand
- (TEOpenLocationCommand *)window:(id)value;
@end


@interface TEPrintCommand : TECommand
- (TEPrintCommand *)printDialog:(id)value;
- (TEPrintCommand *)withProperties:(id)value;
@end


@interface TEQuitCommand : TECommand
- (TEQuitCommand *)saving:(id)value;
@end


@interface TEReopenCommand : TECommand
@end


@interface TERunCommand : TECommand
@end


@interface TESaveCommand : TECommand
- (TESaveCommand *)as:(id)value;
- (TESaveCommand *)in:(id)value;
@end


@interface TESetCommand : TECommand
- (TESetCommand *)to:(id)value;
@end


