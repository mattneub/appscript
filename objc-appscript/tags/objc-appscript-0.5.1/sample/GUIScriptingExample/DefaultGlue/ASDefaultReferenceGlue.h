/*
 * ASDefaultReferenceGlue.h
 * <default terminology>
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"
#import "ASDefaultCommandGlue.h"
#import "ASDefaultReferenceRendererGlue.h"
#define ASDefaultApp ((ASDefaultReference *)[ASDefaultReference referenceWithAppData: nil aemReference: AEMApp])
#define ASDefaultCon ((ASDefaultReference *)[ASDefaultReference referenceWithAppData: nil aemReference: AEMCon])
#define ASDefaultIts ((ASDefaultReference *)[ASDefaultReference referenceWithAppData: nil aemReference: AEMIts])

@interface ASDefaultReference : ASReference

/* +app, +con, +its methods can be used in place of ASDefaultApp, ASDefaultCon, ASDefaultIts macros */

+ (ASDefaultReference *)app;
+ (ASDefaultReference *)con;
+ (ASDefaultReference *)its;

/* ********************************* */

- (NSString *)description;

/* Commands */

- (ASDefaultActivateCommand *)activate;
- (ASDefaultActivateCommand *)activate:(id)directParameter;
- (ASDefaultGetCommand *)get;
- (ASDefaultGetCommand *)get:(id)directParameter;
- (ASDefaultLaunchCommand *)launch;
- (ASDefaultLaunchCommand *)launch:(id)directParameter;
- (ASDefaultOpenCommand *)open;
- (ASDefaultOpenCommand *)open:(id)directParameter;
- (ASDefaultOpenLocationCommand *)openLocation;
- (ASDefaultOpenLocationCommand *)openLocation:(id)directParameter;
- (ASDefaultPrintCommand *)print;
- (ASDefaultPrintCommand *)print:(id)directParameter;
- (ASDefaultQuitCommand *)quit;
- (ASDefaultQuitCommand *)quit:(id)directParameter;
- (ASDefaultReopenCommand *)reopen;
- (ASDefaultReopenCommand *)reopen:(id)directParameter;
- (ASDefaultRunCommand *)run;
- (ASDefaultRunCommand *)run:(id)directParameter;
- (ASDefaultSetCommand *)set;
- (ASDefaultSetCommand *)set:(id)directParameter;

/* Elements */

- (ASDefaultReference *)items;

/* Properties */

- (ASDefaultReference *)class_;
- (ASDefaultReference *)id_;
- (ASDefaultReference *)properties;

/* ********************************* */


/* ordinal selectors */

- (ASDefaultReference *)first;
- (ASDefaultReference *)middle;
- (ASDefaultReference *)last;
- (ASDefaultReference *)any;

/* by-index, by-name, by-id selectors */

- (ASDefaultReference *)at:(long)index;
- (ASDefaultReference *)byIndex:(id)index;
- (ASDefaultReference *)byName:(id)name;
- (ASDefaultReference *)byID:(id)id_;

/* by-relative-position selectors */

- (ASDefaultReference *)previous:(ASConstant *)class_;
- (ASDefaultReference *)next:(ASConstant *)class_;

/* by-range selector */

- (ASDefaultReference *)at:(long)fromIndex to:(long)toIndex;
- (ASDefaultReference *)byRange:(id)fromObject to:(id)toObject;

/* by-test selector */

- (ASDefaultReference *)byTest:(ASDefaultReference *)testReference;

/* insertion location selectors */

- (ASDefaultReference *)beginning;
- (ASDefaultReference *)end;
- (ASDefaultReference *)before;
- (ASDefaultReference *)after;

/* Comparison and logic tests */

- (ASDefaultReference *)greaterThan:(id)object;
- (ASDefaultReference *)greaterOrEquals:(id)object;
- (ASDefaultReference *)equals:(id)object;
- (ASDefaultReference *)notEquals:(id)object;
- (ASDefaultReference *)lessThan:(id)object;
- (ASDefaultReference *)lessOrEquals:(id)object;
- (ASDefaultReference *)beginsWith:(id)object;
- (ASDefaultReference *)endsWith:(id)object;
- (ASDefaultReference *)contains:(id)object;
- (ASDefaultReference *)isIn:(id)object;
- (ASDefaultReference *)AND:(id)remainingOperands;
- (ASDefaultReference *)OR:(id)remainingOperands;
- (ASDefaultReference *)NOT;
@end

