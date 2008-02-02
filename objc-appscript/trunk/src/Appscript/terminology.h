//
//  terminology.h
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import <Foundation/Foundation.h>
#import "parser.h"


/**********************************************************************/


@interface ASNullConverter : NSObject

- (NSString *)convert:(NSString *)name;

- (NSString *)escape:(NSString *)name;

@end


/**********************************************************************/


@interface ASCommandDef : NSObject {
	NSString *name;
	OSType classCode, code;
	NSMutableDictionary *parameters;
}

- (id)initWithName:(NSString *)name_ eventClass:(OSType)classCode_ eventID:(OSType)code_; // TO DO: fix names

- (void)addParameterWithName:(NSString *)name_ code:(OSType)code_; // for internal use only

- (NSString *)name;

- (OSType)eventClass;

- (OSType)eventID;

- (OSType)parameterForName:(NSString *)name_;

- (NSString *)parameterForCode:(OSType)code_;

@end


/**********************************************************************/


@interface ASTerminology : NSObject {
	NSMutableDictionary *typeByName,
						*typeByCode,
						*propertyByName,
						*propertyByCode,
						*elementByName, 
						*elementByCode,
						*commandByName;
	id converter;
	NSMutableDictionary *keywordCache;
	ASTerminology *defaultTerms;
}

// PUBLIC

/*
 * converter : AS keyword string to C identifer string converter; should implement:
 *		-(NSString *)convert:(NSString *)name
 *		-(NSString *)escape:(NSString *)name
 *
 * defaultTerms may be nil
 */
- (id)initWithKeywordConverter:(id)converter_
			defaultTerminology:(ASTerminology *)defaultTerms_;

/*
 * add data from ASParser or equivalent
 */
- (void)addClasses:(NSArray *)classes
	   enumerators:(NSArray *)enumerators
		properties:(NSArray *)properties
		  elements:(NSArray *)elements
		  commands:(NSArray *)commands;

// PRIVATE; used by addClasses:...commands: method

- (void)addTypeTableDefinitions:(NSArray *)definitions ofType:(OSType)descType;

- (void)addReferenceTableDefinitions:(NSArray *)definitions
						 toNameTable:(NSMutableDictionary *)nameTable
						   codeTable:(NSMutableDictionary *)codeTable;

- (void)addCommandTableDefinitions:(NSArray *)commands;

// PUBLIC
// Get conversion tables

- (NSMutableDictionary *)typeByNameTable;
- (NSMutableDictionary *)typeByCodeTable;
- (NSMutableDictionary *)propertyByNameTable;
- (NSMutableDictionary *)propertyByCodeTable;
- (NSMutableDictionary *)elementByNameTable;
- (NSMutableDictionary *)elementByCodeTable;
- (NSMutableDictionary *)commandByNameTable;
- (NSMutableDictionary *)commandByCodeTable;

@end


/**********************************************************************/

/*
@interface ASAppData : NSObject {
	ASAddressType addressType;
	id addressData;
	id terminology;
	AEAddressDesc *target;
}
// TO DO
@end
*/
