//
//  terminology.m
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "terminology.h"


// TO DO: cache converted names here


/**********************************************************************/


@implementation ASNullConverter

- (NSString *)convert:(NSString *)name {
	return name;
}

- (NSString *)escape:(NSString *)name {
	return name;

}

@end


/**********************************************************************/


@implementation ASCommandDef

- (id)initWithName:(NSString *)name_ eventClass:(OSType)eventClass_ eventID:(OSType)eventID_ {
	self = [super init];
	if (!self) return self;
	name = [name_ retain];
	eventClass = eventClass_;
	eventID = eventID_;
	parameters = [[NSMutableDictionary alloc] init];
	return self;
}

- (void)dealloc {
	[name release];
	[parameters release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat: @"<ASCommandDef \"%@\" '%@'/'%@' %@>", 
			[self name], [AEMObjectRenderer formatOSType: eventClass], 
			[AEMObjectRenderer formatOSType: eventID], parameters];
}

- (void)addParameterWithName:(NSString *)name_ code:(OSType)code_ {
	[parameters setObject: [AEMType typeWithCode: code_] forKey: name_];
}

- (NSString *)name {
	return name;
}

- (OSType)eventClass {
	return eventClass;
}

- (OSType)eventID {
	return eventID;
}

- (OSType)parameterForName:(NSString *)name_ {
	return [[parameters objectForKey: name_] fourCharCode];
}

- (NSString *)parameterForCode:(OSType)code_ {
	return nil; // TO DO
}

@end


/**********************************************************************/


@implementation ASTerminology

- (id)init {
	return [self initWithKeywordConverter: nil defaultTerminology: nil];
}

- (id)initWithKeywordConverter:(id)converter_
			defaultTerminology:(ASTerminology *)defaultTerms_ {
	self = [super init];
	if (!self) return self;
	keywordCache = [[NSMutableDictionary alloc] init];
	if (converter_)
		converter = [converter_ retain];
	else
		converter = [[ASNullConverter alloc] init];
	defaultTerms = [defaultTerms_ retain];
	if (defaultTerms_) {
		typeByName = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ typeByNameTable]];
		typeByCode = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ typeByCodeTable]];
		propertyByName = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ propertyByNameTable]];
		propertyByCode = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ propertyByCodeTable]];
		elementByName = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ elementByNameTable]];
		elementByCode = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ elementByCodeTable]];
		commandByName = [[NSMutableDictionary alloc] initWithDictionary: [defaultTerms_ commandByNameTable]];
	} else {
		typeByName = [[NSMutableDictionary alloc] init];
		typeByCode = [[NSMutableDictionary alloc] init];
		propertyByName = [[NSMutableDictionary alloc] init];
		propertyByCode = [[NSMutableDictionary alloc] init];
		elementByName = [[NSMutableDictionary alloc] init];
		elementByCode = [[NSMutableDictionary alloc] init];
		commandByName = [[NSMutableDictionary alloc] init];
	}
	return self;
}


/*
 * Add ASParser output
 */

- (void)addClasses:(NSArray *)classes
	   enumerators:(NSArray *)enumerators
		properties:(NSArray *)properties
		  elements:(NSArray *)elements
		  commands:(NSArray *)commands {

	// build type tables
	[self addTypeTableDefinitions: properties ofType: typeType];
	[self addTypeTableDefinitions: enumerators ofType: typeEnumerated];
	[self addTypeTableDefinitions: classes ofType: typeType];
	// build reference tables
	[self addReferenceTableDefinitions: elements
						   toNameTable: elementByName
							 codeTable: elementByCode];
	[self addReferenceTableDefinitions: properties
						   toNameTable: propertyByName
							 codeTable: propertyByCode];
	// build command table
	[self addCommandTableDefinitions: commands];
	// special case: if property table contains a 'text' definition, move it to element table
	// (AppleScript always packs 'text of...' as an all-elements specifier, not a property specifier)
	AEMType *codeObj = [propertyByName objectForKey: @"text"];
	if (codeObj) {
		[elementByName setObject: codeObj forKey: @"text"];
		[propertyByName removeObjectForKey: @"text"];
	}
}

- (void)dealloc {
	[typeByName release];
	[typeByCode release];
	[propertyByName release];
	[propertyByCode release];
	[elementByName release];
	[elementByCode release];
	[commandByName release];
	[converter release];
	[defaultTerms release];
	[keywordCache release];
	[super dealloc];
}


//

- (void)addTypeTableDefinitions:(NSArray *)definitions ofType:(OSType)descType {
	ASParserDef *parserDef;
	NSString *name, *convertedName;
	OSType code;
	AEMType *codeObj;
	NSAppleEventDescriptor *desc;
	NSDictionary *defaultTypeByName;
	unsigned len, i;
	
	defaultTypeByName = [defaultTerms typeByNameTable];
	len = [definitions count];
	for (i = 0; i < len; i++) {
		// add a definition to typeByCode table
		// to handle synonyms, if same code appears more than once then use name from last definition in list
		parserDef = [definitions objectAtIndex: i];
		name = [parserDef name];
		convertedName = [keywordCache objectForKey: name];
		if (!convertedName) {
			convertedName = [converter convert: name];
			[keywordCache setObject: convertedName forKey: name];
		}
		name = convertedName;
		code = [parserDef fourCharCode];
		// escape definitions that semi-overlap built-in definitions
		desc = [defaultTypeByName objectForKey: name];
		if (desc && [desc typeCodeValue] != code)
			name = [converter escape: name];
		// add item
		codeObj = [AEMType typeWithCode: code]; // OSType is UInt32
		[typeByCode setObject: name forKey: codeObj];
		[codeObj release];
		// add a definition to typeByCode table
		// to handle synonyms, if same name appears more than once then use code from first definition in list
		parserDef = [definitions objectAtIndex: (len - 1 - i)];
		name = [parserDef name];
		convertedName = [keywordCache objectForKey: name];
		if (!convertedName) {
			convertedName = [converter convert: name];
			[keywordCache setObject: convertedName forKey: name];
		}
		name = convertedName;
		code = [parserDef fourCharCode];
		// escape definitions that semi-overlap built-in definitions
		desc = [defaultTypeByName objectForKey: name];
		if (desc && [desc typeCodeValue] != code)
			name = [converter escape: name];
		// add item
		desc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: descType
																bytes: (void *)(&code)
															   length: sizeof(code)];
		[typeByName setObject: desc forKey: name];
		[desc release];
	}
}


- (void)addReferenceTableDefinitions:(NSArray *)definitions
						 toNameTable:(NSMutableDictionary *)nameTable
						   codeTable:(NSMutableDictionary *)codeTable {
	ASParserDef *parserDef;
	NSString *name, *convertedName;
	AEMType *codeObj;
	unsigned len, i;
	
	len = [definitions count];
	for (i = 0; i < len; i++) {
		// add a definition to the byCode table
		// to handle synonyms, if same code appears more than once then use name from last definition in list
		parserDef = [definitions objectAtIndex: i];
		name = [parserDef name];
		convertedName = [keywordCache objectForKey: name];
		if (!convertedName) {
			convertedName = [converter convert: name];
			[keywordCache setObject: convertedName forKey: name];
		}
		name = convertedName;
		codeObj = [AEMType typeWithCode: [parserDef fourCharCode]];
		[codeTable setObject: name forKey: codeObj];
		[codeObj release];
		// add a definition to the byName table
		// to handle synonyms, if same name appears more than once then use code from first definition in list
		parserDef = [definitions objectAtIndex: (len - 1 - i)];
		name = [parserDef name];
		convertedName = [keywordCache objectForKey: name];
		if (!convertedName) {
			convertedName = [converter convert: name];
			[keywordCache setObject: convertedName forKey: name];
		}
		name = convertedName;
		codeObj = [AEMType typeWithCode: [parserDef fourCharCode]];
		[nameTable setObject: codeObj forKey: name];
		[codeObj release];
	}
}


- (void)addCommandTableDefinitions:(NSArray *)commands {
	NSEnumerator *parameterEnumerator;
	ASParserCommandDef *parserCommandDef;
	ASCommandDef *commandDef, *existingCommandDef;
	ASParserDef *parameterDef;
	NSString *name, *convertedName, *parameterName;
	NSDictionary *defaultCommandByName;
	OSType eventClass, eventID;
	unsigned len, i;

	defaultCommandByName = [defaultTerms commandByNameTable];
	// To handle synonyms, if two commands have same name but different codes, only the first
	// definition should be used (iterating array in reverse ensures this)
	len = [commands count];
	for (i = 0; i < len; i++) {
		parserCommandDef = [commands objectAtIndex: (len - 1 - i)];
		name = [parserCommandDef name];
		convertedName = [keywordCache objectForKey: name];
		if (!convertedName) {
			convertedName = [converter convert: name];
			[keywordCache setObject: convertedName forKey: name];
		}
		name = convertedName;
		eventClass = [parserCommandDef eventClass];
		eventID = [parserCommandDef eventID];
		// Avoid collisions between default commands and application-defined commands with same name
		// but different code (e.g. 'get' and 'set' in InDesign CS2):
		existingCommandDef = [defaultCommandByName objectForKey: name];
		if (existingCommandDef
				&& ([existingCommandDef eventClass] != eventClass || [existingCommandDef eventID] != eventID))
			name = [converter escape: name];
		// add item
		commandDef = [[ASCommandDef alloc] initWithName: [parserCommandDef name]
											 eventClass: eventClass
												eventID: eventID];
		parameterEnumerator = [[parserCommandDef parameters] objectEnumerator];
		while (parameterDef = [parameterEnumerator nextObject]) {
			parameterName = [parameterDef name];
			convertedName = [keywordCache objectForKey: parameterName];
			if (!convertedName) {
				convertedName = [converter convert: parameterName];
				[keywordCache setObject: convertedName forKey: parameterName];
			}
			parameterName = convertedName;
			[commandDef addParameterWithName: parameterName code: [parameterDef fourCharCode]];
		}
		[commandByName setObject: commandDef forKey: name];
		[commandDef release];
	}
}

// Get conversion tables

- (NSMutableDictionary *)typeByNameTable {
	return typeByName;
}

- (NSMutableDictionary *)typeByCodeTable {
	return typeByCode;
}

- (NSMutableDictionary *)propertyByNameTable {
	return propertyByName;
}

- (NSMutableDictionary *)propertyByCodeTable {
	return propertyByCode;
}

- (NSMutableDictionary *)elementByNameTable {
	return elementByName;
}

- (NSMutableDictionary *)elementByCodeTable {
	return elementByCode;
}

- (NSMutableDictionary *)commandByNameTable {
	return commandByName;
}

- (NSMutableDictionary *)commandByCodeTable {
	return nil; // TO DO
}

@end


/**********************************************************************/

