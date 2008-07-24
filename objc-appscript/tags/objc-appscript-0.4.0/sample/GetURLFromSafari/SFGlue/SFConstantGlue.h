/*
 * SFConstantGlue.h
 *
 * /Applications/Safari.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface SFConstant : ASConstant
+ (id)constantWithCode:(OSType)code_;

/* Enumerators */

+ (SFConstant *)ask;
+ (SFConstant *)detailed;
+ (SFConstant *)no;
+ (SFConstant *)standard;
+ (SFConstant *)yes;

/* Types and properties */

+ (SFConstant *)URL;
+ (SFConstant *)application;
+ (SFConstant *)attachment;
+ (SFConstant *)attributeRun;
+ (SFConstant *)bounds;
+ (SFConstant *)character;
+ (SFConstant *)class_;
+ (SFConstant *)closeable;
+ (SFConstant *)collating;
+ (SFConstant *)color;
+ (SFConstant *)copies;
+ (SFConstant *)currentTab;
+ (SFConstant *)document;
+ (SFConstant *)endingPage;
+ (SFConstant *)errorHandling;
+ (SFConstant *)faxNumber;
+ (SFConstant *)fileName;
+ (SFConstant *)floating;
+ (SFConstant *)font;
+ (SFConstant *)frontmost;
+ (SFConstant *)id_;
+ (SFConstant *)index;
+ (SFConstant *)item;
+ (SFConstant *)miniaturizable;
+ (SFConstant *)miniaturized;
+ (SFConstant *)modal;
+ (SFConstant *)modified;
+ (SFConstant *)name;
+ (SFConstant *)pagesAcross;
+ (SFConstant *)pagesDown;
+ (SFConstant *)paragraph;
+ (SFConstant *)path;
+ (SFConstant *)printSettings;
+ (SFConstant *)properties;
+ (SFConstant *)requestedPrintTime;
+ (SFConstant *)resizable;
+ (SFConstant *)size;
+ (SFConstant *)source;
+ (SFConstant *)startingPage;
+ (SFConstant *)tab;
+ (SFConstant *)targetPrinter;
+ (SFConstant *)text;
+ (SFConstant *)titled;
+ (SFConstant *)version_;
+ (SFConstant *)visible;
+ (SFConstant *)window;
+ (SFConstant *)word;
+ (SFConstant *)zoomable;
+ (SFConstant *)zoomed;
@end


