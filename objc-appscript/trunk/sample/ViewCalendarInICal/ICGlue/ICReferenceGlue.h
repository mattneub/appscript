/*
 * ICReferenceGlue.h
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "ICCommandGlue.h"
#import "ICReferenceRendererGlue.h"
#define ICApp ((ICReference *)[ICReference referenceWithAppData: nil aemReference: AEMApp])
#define ICCon ((ICReference *)[ICReference referenceWithAppData: nil aemReference: AEMCon])
#define ICIts ((ICReference *)[ICReference referenceWithAppData: nil aemReference: AEMIts])

@interface ICReference : ASReference

/* +app, +con, +its methods can be used in place of ICApp, ICCon, ICIts macros */

+ (ICReference *)app;
+ (ICReference *)con;
+ (ICReference *)its;

/* ********************************* */

- (NSString *)description;

/* Commands */

- (ICGetURLCommand *)GetURL;
- (ICGetURLCommand *)GetURL:(id)directParameter;
- (ICActivateCommand *)activate;
- (ICActivateCommand *)activate:(id)directParameter;
- (ICCloseCommand *)close;
- (ICCloseCommand *)close:(id)directParameter;
- (ICCountCommand *)count;
- (ICCountCommand *)count:(id)directParameter;
- (ICCreateCalendarCommand *)createCalendar;
- (ICCreateCalendarCommand *)createCalendar:(id)directParameter;
- (ICDeleteCommand *)delete;
- (ICDeleteCommand *)delete:(id)directParameter;
- (ICDuplicateCommand *)duplicate;
- (ICDuplicateCommand *)duplicate:(id)directParameter;
- (ICExistsCommand *)exists;
- (ICExistsCommand *)exists:(id)directParameter;
- (ICGetCommand *)get;
- (ICGetCommand *)get:(id)directParameter;
- (ICLaunchCommand *)launch;
- (ICLaunchCommand *)launch:(id)directParameter;
- (ICMakeCommand *)make;
- (ICMakeCommand *)make:(id)directParameter;
- (ICMoveCommand *)move;
- (ICMoveCommand *)move:(id)directParameter;
- (ICOpenCommand *)open;
- (ICOpenCommand *)open:(id)directParameter;
- (ICOpenLocationCommand *)openLocation;
- (ICOpenLocationCommand *)openLocation:(id)directParameter;
- (ICPrintCommand *)print;
- (ICPrintCommand *)print:(id)directParameter;
- (ICQuitCommand *)quit;
- (ICQuitCommand *)quit:(id)directParameter;
- (ICReloadCalendarsCommand *)reloadCalendars;
- (ICReloadCalendarsCommand *)reloadCalendars:(id)directParameter;
- (ICReopenCommand *)reopen;
- (ICReopenCommand *)reopen:(id)directParameter;
- (ICRunCommand *)run;
- (ICRunCommand *)run:(id)directParameter;
- (ICSaveCommand *)save;
- (ICSaveCommand *)save:(id)directParameter;
- (ICSetCommand *)set;
- (ICSetCommand *)set:(id)directParameter;
- (ICShowCommand *)show;
- (ICShowCommand *)show:(id)directParameter;
- (ICSwitchViewCommand *)switchView;
- (ICSwitchViewCommand *)switchView:(id)directParameter;
- (ICViewCalendarCommand *)viewCalendar;
- (ICViewCalendarCommand *)viewCalendar:(id)directParameter;

/* Elements */

- (ICReference *)applications;
- (ICReference *)attachment;
- (ICReference *)attendees;
- (ICReference *)attributeRuns;
- (ICReference *)calendars;
- (ICReference *)characters;
- (ICReference *)colors;
- (ICReference *)displayAlarms;
- (ICReference *)documents;
- (ICReference *)events;
- (ICReference *)items;
- (ICReference *)mailAlarms;
- (ICReference *)openFileAlarms;
- (ICReference *)paragraphs;
- (ICReference *)printSettings;
- (ICReference *)soundAlarms;
- (ICReference *)text;
- (ICReference *)todos;
- (ICReference *)windows;
- (ICReference *)words;

/* Properties */

- (ICReference *)alldayEvent;
- (ICReference *)bounds;
- (ICReference *)class_;
- (ICReference *)closeable;
- (ICReference *)collating;
- (ICReference *)color;
- (ICReference *)completionDate;
- (ICReference *)copies;
- (ICReference *)description_;
- (ICReference *)displayName;
- (ICReference *)document;
- (ICReference *)dueDate;
- (ICReference *)email;
- (ICReference *)endDate;
- (ICReference *)endingPage;
- (ICReference *)errorHandling;
- (ICReference *)excludedDates;
- (ICReference *)faxNumber;
- (ICReference *)fileName;
- (ICReference *)filepath;
- (ICReference *)floating;
- (ICReference *)font;
- (ICReference *)frontmost;
- (ICReference *)id_;
- (ICReference *)index;
- (ICReference *)location;
- (ICReference *)miniaturizable;
- (ICReference *)miniaturized;
- (ICReference *)modal;
- (ICReference *)modified;
- (ICReference *)name;
- (ICReference *)pagesAcross;
- (ICReference *)pagesDown;
- (ICReference *)participationStatus;
- (ICReference *)path;
- (ICReference *)priority;
- (ICReference *)properties;
- (ICReference *)recurrence;
- (ICReference *)requestedPrintTime;
- (ICReference *)resizable;
- (ICReference *)sequence;
- (ICReference *)size;
- (ICReference *)soundFile;
- (ICReference *)soundName;
- (ICReference *)stampDate;
- (ICReference *)startDate;
- (ICReference *)startingPage;
- (ICReference *)status;
- (ICReference *)summary;
- (ICReference *)targetPrinter;
- (ICReference *)titled;
- (ICReference *)triggerDate;
- (ICReference *)triggerInterval;
- (ICReference *)uid;
- (ICReference *)url;
- (ICReference *)version_;
- (ICReference *)visible;
- (ICReference *)writable;
- (ICReference *)zoomable;
- (ICReference *)zoomed;

/* ********************************* */


/* ordinal selectors */

- (ICReference *)first;
- (ICReference *)middle;
- (ICReference *)last;
- (ICReference *)any;

/* by-index, by-name, by-id selectors */

- (ICReference *)at:(long)index;
- (ICReference *)byIndex:(id)index;
- (ICReference *)byName:(id)name;
- (ICReference *)byID:(id)id_;

/* by-relative-position selectors */

- (ICReference *)previous:(ASConstant *)class_;
- (ICReference *)next:(ASConstant *)class_;

/* by-range selector */

- (ICReference *)at:(long)fromIndex to:(long)toIndex;
- (ICReference *)byRange:(id)fromObject to:(id)toObject;

/* by-test selector */

- (ICReference *)byTest:(ICReference *)testReference;

/* insertion location selectors */

- (ICReference *)beginning;
- (ICReference *)end;
- (ICReference *)before;
- (ICReference *)after;

/* Comparison and logic tests */

- (ICReference *)greaterThan:(id)object;
- (ICReference *)greaterOrEquals:(id)object;
- (ICReference *)equals:(id)object;
- (ICReference *)notEquals:(id)object;
- (ICReference *)lessThan:(id)object;
- (ICReference *)lessOrEquals:(id)object;
- (ICReference *)beginsWith:(id)object;
- (ICReference *)endsWith:(id)object;
- (ICReference *)contains:(id)object;
- (ICReference *)isIn:(id)object;
- (ICReference *)AND:(id)remainingOperands;
- (ICReference *)OR:(id)remainingOperands;
- (ICReference *)NOT;
@end

