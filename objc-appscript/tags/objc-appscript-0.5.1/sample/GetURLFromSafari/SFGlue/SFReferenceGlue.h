/*
 * SFReferenceGlue.h
 * /Applications/Safari.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "SFCommandGlue.h"
#import "SFReferenceRendererGlue.h"
#define SFApp ((SFReference *)[SFReference referenceWithAppData: nil aemReference: AEMApp])
#define SFCon ((SFReference *)[SFReference referenceWithAppData: nil aemReference: AEMCon])
#define SFIts ((SFReference *)[SFReference referenceWithAppData: nil aemReference: AEMIts])

@interface SFReference : ASReference

/* +app, +con, +its methods can be used in place of SFApp, SFCon, SFIts macros */

+ (SFReference *)app;
+ (SFReference *)con;
+ (SFReference *)its;

/* ********************************* */

- (NSString *)description;

/* Commands */

- (SFActivateCommand *)activate;
- (SFActivateCommand *)activate:(id)directParameter;
- (SFCloseCommand *)close;
- (SFCloseCommand *)close:(id)directParameter;
- (SFCountCommand *)count;
- (SFCountCommand *)count:(id)directParameter;
- (SFDeleteCommand *)delete;
- (SFDeleteCommand *)delete:(id)directParameter;
- (SFDoJavaScriptCommand *)doJavaScript;
- (SFDoJavaScriptCommand *)doJavaScript:(id)directParameter;
- (SFDuplicateCommand *)duplicate;
- (SFDuplicateCommand *)duplicate:(id)directParameter;
- (SFEmailContentsCommand *)emailContents;
- (SFEmailContentsCommand *)emailContents:(id)directParameter;
- (SFExistsCommand *)exists;
- (SFExistsCommand *)exists:(id)directParameter;
- (SFGetCommand *)get;
- (SFGetCommand *)get:(id)directParameter;
- (SFLaunchCommand *)launch;
- (SFLaunchCommand *)launch:(id)directParameter;
- (SFMakeCommand *)make;
- (SFMakeCommand *)make:(id)directParameter;
- (SFMoveCommand *)move;
- (SFMoveCommand *)move:(id)directParameter;
- (SFOpenCommand *)open;
- (SFOpenCommand *)open:(id)directParameter;
- (SFOpenLocationCommand *)openLocation;
- (SFOpenLocationCommand *)openLocation:(id)directParameter;
- (SFPrintCommand *)print;
- (SFPrintCommand *)print:(id)directParameter;
- (SFQuitCommand *)quit;
- (SFQuitCommand *)quit:(id)directParameter;
- (SFReopenCommand *)reopen;
- (SFReopenCommand *)reopen:(id)directParameter;
- (SFRunCommand *)run;
- (SFRunCommand *)run:(id)directParameter;
- (SFSaveCommand *)save;
- (SFSaveCommand *)save:(id)directParameter;
- (SFSetCommand *)set;
- (SFSetCommand *)set:(id)directParameter;
- (SFShowBookmarksCommand *)showBookmarks;
- (SFShowBookmarksCommand *)showBookmarks:(id)directParameter;

/* Elements */

- (SFReference *)applications;
- (SFReference *)attachment;
- (SFReference *)attributeRuns;
- (SFReference *)characters;
- (SFReference *)colors;
- (SFReference *)documents;
- (SFReference *)items;
- (SFReference *)paragraphs;
- (SFReference *)printSettings;
- (SFReference *)tabs;
- (SFReference *)text;
- (SFReference *)windows;
- (SFReference *)words;

/* Properties */

- (SFReference *)URL;
- (SFReference *)bounds;
- (SFReference *)class_;
- (SFReference *)closeable;
- (SFReference *)collating;
- (SFReference *)color;
- (SFReference *)copies;
- (SFReference *)currentTab;
- (SFReference *)document;
- (SFReference *)endingPage;
- (SFReference *)errorHandling;
- (SFReference *)faxNumber;
- (SFReference *)fileName;
- (SFReference *)floating;
- (SFReference *)font;
- (SFReference *)frontmost;
- (SFReference *)id_;
- (SFReference *)index;
- (SFReference *)miniaturizable;
- (SFReference *)miniaturized;
- (SFReference *)modal;
- (SFReference *)modified;
- (SFReference *)name;
- (SFReference *)pagesAcross;
- (SFReference *)pagesDown;
- (SFReference *)path;
- (SFReference *)properties;
- (SFReference *)requestedPrintTime;
- (SFReference *)resizable;
- (SFReference *)size;
- (SFReference *)source;
- (SFReference *)startingPage;
- (SFReference *)targetPrinter;
- (SFReference *)titled;
- (SFReference *)version_;
- (SFReference *)visible;
- (SFReference *)zoomable;
- (SFReference *)zoomed;

/* ********************************* */


/* ordinal selectors */

- (SFReference *)first;
- (SFReference *)middle;
- (SFReference *)last;
- (SFReference *)any;

/* by-index, by-name, by-id selectors */

- (SFReference *)at:(long)index;
- (SFReference *)byIndex:(id)index;
- (SFReference *)byName:(id)name;
- (SFReference *)byID:(id)id_;

/* by-relative-position selectors */

- (SFReference *)previous:(ASConstant *)class_;
- (SFReference *)next:(ASConstant *)class_;

/* by-range selector */

- (SFReference *)at:(long)fromIndex to:(long)toIndex;
- (SFReference *)byRange:(id)fromObject to:(id)toObject;

/* by-test selector */

- (SFReference *)byTest:(SFReference *)testReference;

/* insertion location selectors */

- (SFReference *)beginning;
- (SFReference *)end;
- (SFReference *)before;
- (SFReference *)after;

/* Comparison and logic tests */

- (SFReference *)greaterThan:(id)object;
- (SFReference *)greaterOrEquals:(id)object;
- (SFReference *)equals:(id)object;
- (SFReference *)notEquals:(id)object;
- (SFReference *)lessThan:(id)object;
- (SFReference *)lessOrEquals:(id)object;
- (SFReference *)beginsWith:(id)object;
- (SFReference *)endsWith:(id)object;
- (SFReference *)contains:(id)object;
- (SFReference *)isIn:(id)object;
- (SFReference *)AND:(id)remainingOperands;
- (SFReference *)OR:(id)remainingOperands;
- (SFReference *)NOT;
@end

