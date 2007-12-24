//
//  terminology.h
//  appscript
//
//  Copyright (C) 2007 HAS
//

#import <Foundation/Foundation.h>
#import "parser.h"



typedef enum {
	kASPropertyDef = 0,
	kASElementDef  = 1
} ASPreferredDefinitionType; // used in -referenceForCode:preferably:


/**********************************************************************/


@interface ASNullConverter : NSObject

- (NSString *)convert:(NSString *)name;

@end


/**********************************************************************/


@interface ASDefinition : NSObject {
	NSString *name;
	OSType code;
}

- (id)initWithName:(NSString *)name_ code:(OSType)code_;

- (NSString *)name;

- (OSType)code;

@end


@interface ASPropertyDef : ASDefinition
@end


@interface ASElementDef : ASDefinition
@end


@interface ASParameterDef : ASDefinition
@end


@interface ASCommandDef : ASDefinition {
	OSType classCode;
	NSMutableDictionary *parameters;
}

- (id)initWithName:(NSString *)name_ classCode:(OSType)classCode_ idCode:(OSType)code_;

- (void)addParameterName:(NSString *)name_ code:(OSType)code_; // for internal use only

- (OSType)classCode;

- (OSType)idCode; // synonymous to -code

- (ASParameterDef *)parameterForName:(NSString *)name_;

@end


/**********************************************************************/


@interface ASTerminology : NSObject {
	NSMutableDictionary *typeByName;
	NSMutableDictionary *typeByCode;
	
	NSMutableDictionary *propertyByName;
	NSMutableDictionary *propertyByCode;
	NSMutableDictionary *elementByName;
	NSMutableDictionary *elementByCode;
	
	NSMutableDictionary *commandByName;
	
	id converter;
}

// PUBLIC

/*
 * converter : AS keyword string to C identifer string converter; should implement:
 *		-(NSString *)convert:(NSString *)name
 */
- (id)initWithKeywordConverter:(id)converter_;

/*
 * data : ASParser or equivalent;
 *		should implement the following accessors:
 *				-classes, -enumerators, -properties, -elements, -commands
 */
- (void)addParserData:(id)data;

// PRIVATE; used by -addParserData:

- (void)addTypeTableDefinitions:(NSArray *)definitions ofType:(OSType)descType;

- (void)addReferenceTableDefinitions:(NSArray *)definitions
						 toNameTable:(NSMutableDictionary *)nameTable
						andCodeTable:(NSMutableDictionary *)codeTable;

// PUBLIC 

// Used to pack/unpack typeType, typeEnumerated, typeProperty:

- (NSAppleEventDescriptor *)typeForName:(NSString *)name;

- (NSString *)typeForCode:(OSType)descData;

// Used to build AEM references:

- (ASDefinition *)referenceForName:(NSString *)name;

// Used by -description to render AEM references:

- (ASDefinition *)referenceForCode:(OSType)code preferably:(ASPreferredDefinitionType)preferredType;

// Obtain copies of conversion tables directly, if needed:

- (NSDictionary *)propertyByNameTable;
- (NSDictionary *)propertyByCodeTable;
- (NSDictionary *)elementByNameTable;
- (NSDictionary *)elementByCodeTable;
- (NSDictionary *)commandByNameTable;

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
