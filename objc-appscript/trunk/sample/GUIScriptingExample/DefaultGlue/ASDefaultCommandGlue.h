/*
 * ASDefaultCommandGlue.h
 *
 * <default terminology>
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface ASDefaultActivateCommand : ASCommand
@end


@interface ASDefaultGetCommand : ASCommand
@end


@interface ASDefaultLaunchCommand : ASCommand
@end


@interface ASDefaultOpenCommand : ASCommand
@end


@interface ASDefaultOpenLocationCommand : ASCommand
- (ASDefaultOpenLocationCommand *)window:(id)value;
@end


@interface ASDefaultPrintCommand : ASCommand
@end


@interface ASDefaultQuitCommand : ASCommand
- (ASDefaultQuitCommand *)saving:(id)value;
@end


@interface ASDefaultReopenCommand : ASCommand
@end


@interface ASDefaultRunCommand : ASCommand
@end


@interface ASDefaultSetCommand : ASCommand
- (ASDefaultSetCommand *)to:(id)value;
@end


