/*
 * ICCommandGlue.h
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "ICReferenceRendererGlue.h"

@interface ICCommand : ASCommand
- (NSString *)AS_formatObject:(id)obj appData:(id)appData;
@end


@interface ICGetURLCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICActivateCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICCloseCommand : ICCommand
- (ICCloseCommand *)saving:(id)value;
- (ICCloseCommand *)savingIn:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICCountCommand : ICCommand
- (ICCountCommand *)each:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICCreateCalendarCommand : ICCommand
- (ICCreateCalendarCommand *)withName:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICDeleteCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICDuplicateCommand : ICCommand
- (ICDuplicateCommand *)to:(id)value;
- (ICDuplicateCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICExistsCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICGetCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICLaunchCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICMakeCommand : ICCommand
- (ICMakeCommand *)at:(id)value;
- (ICMakeCommand *)new_:(id)value;
- (ICMakeCommand *)withData:(id)value;
- (ICMakeCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICMoveCommand : ICCommand
- (ICMoveCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICOpenCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICOpenLocationCommand : ICCommand
- (ICOpenLocationCommand *)window:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICPrintCommand : ICCommand
- (ICPrintCommand *)printDialog:(id)value;
- (ICPrintCommand *)withProperties:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICQuitCommand : ICCommand
- (ICQuitCommand *)saving:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICReloadCalendarsCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICReopenCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICRunCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICSaveCommand : ICCommand
- (ICSaveCommand *)as:(id)value;
- (ICSaveCommand *)in:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICSetCommand : ICCommand
- (ICSetCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICShowCommand : ICCommand
- (NSString *)AS_commandName;
@end


@interface ICSwitchViewCommand : ICCommand
- (ICSwitchViewCommand *)to:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end


@interface ICViewCalendarCommand : ICCommand
- (ICViewCalendarCommand *)at:(id)value;
- (NSString *)AS_commandName;
- (NSString *)AS_parameterNameForCode:(DescType)code;
@end

