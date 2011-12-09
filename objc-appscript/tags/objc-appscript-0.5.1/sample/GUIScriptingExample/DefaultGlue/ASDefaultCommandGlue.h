/*
 * ASDefaultCommandGlue.h
 * <default terminology>
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "ASDefaultReferenceRendererGlue.h"

@interface ASDefaultCommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface ASDefaultActivateCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultGetCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultLaunchCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultOpenCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultOpenLocationCommand : ASDefaultCommand
- (ASDefaultOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ASDefaultPrintCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultQuitCommand : ASDefaultCommand
- (ASDefaultQuitCommand *)saving:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ASDefaultReopenCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultRunCommand : ASDefaultCommand
- (NSString *)AS_commandName;
@end


@interface ASDefaultSetCommand : ASDefaultCommand
- (ASDefaultSetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end

