//
//  specifier.h
//  aem
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "base.h"
#import "test.h"

/* TO DO:
 *
 * - provide an abstract AEMResolverBase class that third-party clients can subclass
 *   in order to create resolver objects to pass to AEM specifiers' -resolve: method.
 *   This base class should provide default implementations of all known specifier and
 *   test methods; these should in turn call a common -selector:args: method that does
 *   nothing by default. Subclasses can then override any of the specific specifier/
 *   test methods and/or the -selector:args: method according to their needs.
 *
 * - declare protocol/base class for reference resolver objects
 *
 * - implement AEMCustomRoot
 *
 * - since frameworks are never unloaded, do we really need disposeSpecifierModule()?
 */

/**********************************************************************/


#define AEMApp [AEMApplicationRoot applicationRoot]
#define AEMCon [AEMCurrentContainerRoot currentContainerRoot]
#define AEMIts [AEMObjectBeingExaminedRoot objectBeingExaminedRoot]


/**********************************************************************/
// Forward declarations

@class AEMPropertySpecifier;
@class AEMUserPropertySpecifier;
@class AEMElementByNameSpecifier;
@class AEMElementByIndexSpecifier;
@class AEMElementByIDSpecifier;
@class AEMElementByOrdinalSpecifier;
@class AEMElementByRelativePositionSpecifier;
@class AEMElementsByRangeSpecifier;
@class AEMElementsByTestSpecifier;
@class AEMAllElementsSpecifier;

@class AEMGreaterThanTest;
@class AEMGreaterOrEqualsTest;
@class AEMEqualsTest;
@class AEMNotEqualsTest;
@class AEMLessThanTest;
@class AEMLessOrEqualsTest;
@class AEMBeginsWithTest;
@class AEMEndsWithTest;
@class AEMContainsTest;
@class AEMIsInTest;

@class AEMSpecifier;
@class AEMReferenceRootBase;
@class AEMApplicationRoot;
@class AEMCurrentContainerRoot;
@class AEMObjectBeingExaminedRoot;

@class AEMTest;


/**********************************************************************/
// initialise constants

void initSpecifierModule(void); // called automatically

void disposeSpecifierModule(void);


/**********************************************************************/
// Specifier base

/*
 * Abstract base class for all object specifier classes.
 */
@interface AEMSpecifier : AEMQuery {
	AEMSpecifier *container;
	id key;
}

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_;

// reserved methods

- (AEMReferenceRootBase *)root;
- (AEMSpecifier *)trueSelf;

@end


/**********************************************************************/
// Insertion location specifier

/*
 * A reference to an element insertion point.
 */
@interface AEMInsertionSpecifier : AEMSpecifier
@end


/**********************************************************************/
// Position specifier base

/*
 * All property and element reference forms inherit from this abstract class.
 */
@interface AEMObjectSpecifier : AEMSpecifier {
	OSType wantCode;
}

- (id)initWithContainer:(AEMSpecifier *)container_ key:(id)key_ wantCode:(OSType)wantCode_;

// Comparison and logic tests

- (AEMGreaterThanTest		*)greaterThan:(id)object;
- (AEMGreaterOrEqualsTest	*)greaterOrEquals:(id)object;
- (AEMEqualsTest			*)equals:(id)object;
- (AEMNotEqualsTest			*)notEquals:(id)object;
- (AEMLessThanTest			*)lessThan:(id)object;
- (AEMLessOrEqualsTest		*)lessOrEquals:(id)object;
- (AEMBeginsWithTest		*)beginsWith:(id)object;
- (AEMEndsWithTest			*)endsWith:(id)object;
- (AEMContainsTest			*)contains:(id)object;
- (AEMIsInTest				*)isIn:(id)object;

// Insertion location selectors

- (AEMInsertionSpecifier *)beginning;
- (AEMInsertionSpecifier *)end;
- (AEMInsertionSpecifier *)before;
- (AEMInsertionSpecifier *)after;

// property and all-element specifiers

- (AEMPropertySpecifier		*)property:(OSType)propertyCode;
- (AEMUserPropertySpecifier	*)userProperty:(NSString *)propertyName;
- (AEMAllElementsSpecifier	*)elements:(OSType)classCode;

// by-relative-position selectors

- (AEMElementByRelativePositionSpecifier *)previous:(OSType)classCode;
- (AEMElementByRelativePositionSpecifier *)next:(OSType)classCode;

@end


/**********************************************************************/
// Properties

/*
 * Specifier identifying an application-defined property
 */
@interface AEMPropertySpecifier : AEMObjectSpecifier
@end


@interface AEMUserPropertySpecifier : AEMObjectSpecifier
@end


/**********************************************************************/
// Single elements

/*
 * Abstract base class for all single element specifiers
 */
@interface AEMSingleElementSpecifier : AEMObjectSpecifier
@end

/*
 * Specifiers identifying a single element by name, index, id or named ordinal
 */
@interface AEMElementByNameSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByIndexSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByIDSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByOrdinalSpecifier : AEMSingleElementSpecifier
@end

@interface AEMElementByRelativePositionSpecifier : AEMObjectSpecifier
@end


/**********************************************************************/
// Multiple elements

/*
 * Base class for all multiple element specifiers.
 */
@interface AEMMultipleElementsSpecifier : AEMObjectSpecifier 

// ordinal selectors

- (AEMElementByOrdinalSpecifier *)first;
- (AEMElementByOrdinalSpecifier *)middle;
- (AEMElementByOrdinalSpecifier *)last;
- (AEMElementByOrdinalSpecifier *)any;

// by-index, by-name, by-id selectors
 
- (AEMElementByIndexSpecifier	*)at:(int)index;
- (AEMElementByIndexSpecifier	*)byIndex:(id)index; // normally NSNumber, but may occasionally be other types
- (AEMElementByNameSpecifier	*)byName:(NSString *)name;
- (AEMElementByIDSpecifier		*)byID:(id)id_;

// by-range selector

- (AEMElementsByRangeSpecifier *)at:(int)startIndex to:(int)stopIndex;
- (AEMElementsByRangeSpecifier *)byRange:(id)startReference to:(id)stopReference; // takes two con-based references, with other values being expanded as necessary

// by-test selector

- (AEMElementsByTestSpecifier *)byTest:(AEMTest *)testReference;

@end


@interface AEMElementsByRangeSpecifier : AEMMultipleElementsSpecifier {
	id startReference, stopReference;
}

- (id)initWithContainer:(AEMSpecifier *)container_
				  start:(id)startReference_
				   stop:(id)stopReference_
			   wantCode:(OSType)wantCode_;

@end


@interface AEMElementsByTestSpecifier : AEMMultipleElementsSpecifier
@end


@interface AEMAllElementsSpecifier : AEMMultipleElementsSpecifier
@end


/**********************************************************************/
// Multiple element shim

@interface AEMUnkeyedElementsShim : AEMSpecifier {
	OSType wantCode;
}

- (id)initWithContainer:(AEMSpecifier *)container_ wantCode:(OSType)wantCode_;

@end


/**********************************************************************/
// Reference roots

@interface AEMReferenceRootBase : AEMObjectSpecifier

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
- (id)initWithDescType:(DescType)descType;

@end

@interface AEMApplicationRoot : AEMReferenceRootBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMApplicationRoot *)applicationRoot;

@end

@interface AEMCurrentContainerRoot : AEMReferenceRootBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMCurrentContainerRoot *)currentContainerRoot;

@end

@interface AEMObjectBeingExaminedRoot : AEMReferenceRootBase

// note: clients should avoid calling this initialiser directly; 
// use AEMApp, AEMCon, AEMIts macros instead.
+ (AEMObjectBeingExaminedRoot *)objectBeingExaminedRoot;

@end

