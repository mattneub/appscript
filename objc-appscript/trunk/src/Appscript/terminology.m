//
//  terminology.m
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "terminology.h"


/**********************************************************************/


@implementation ASNullConverter

- (NSString *)convert:(NSString *)name {
	return name;
}

@end


/**********************************************************************/


@implementation ASDefinition

- (id)initWithName:(NSString *)name_ code:(OSType)code_ {
	self = [super init];
	if (!self) return self;
	[name_ retain];
	name = name_;
	code = code_;
	return self;
}

- (void) dealloc {
	[name release];
	[super dealloc];
}

- (NSString *)name {
	return name;
}

- (OSType)code {
	return code;
}

@end


@implementation ASPropertyDef
@end


@implementation ASElementDef
@end


@implementation ASParameterDef
@end


@implementation ASCommandDef

- (id)initWithName:(NSString *)name_ classCode:(OSType)classCode_ idCode:(OSType)code_ {
	self = [super initWithName:(NSString *)name_ code:(OSType)code_];
	if (!self) return self;
	classCode = classCode_;
	parameters = [[NSMutableDictionary alloc] init];
	return self;
}

- (void)dealloc {
	[parameters release];
	[super dealloc];
}

- (void)addParameterName:(NSString *)name_ code:(OSType)code_ {
	ASParameterDef *parameter;
	
	parameter = [[ASParameterDef alloc] initWithName: name_ code: code_];
	[parameters setObject: parameter forKey: name_];
	[parameter release];
}

- (OSType)classCode {
	return classCode;
}

- (OSType)idCode {
	return code;
}

- (ASParameterDef *)parameterForName:(NSString *)name_ {
	return [parameters objectForKey: name_];
}

@end


/**********************************************************************/


@implementation ASTerminology

- (id)init {
	id converter_;
	
	converter_ = [[ASNullConverter alloc] init];
	self = [self initWithKeywordConverter: converter_];
	[converter_ release];
	return self; 
}

- (id)initWithKeywordConverter:(id)converter_ {
	self = [super init];
	if (!self) return self;
	[converter_ retain];
	converter = converter_;
	// TO DO: create following tables by copying default tables containing built-in definitions
	typeByName = [[NSMutableDictionary alloc] init];
	typeByCode = [[NSMutableDictionary alloc] init];
	propertyByName = [[NSMutableDictionary alloc] init];
	propertyByCode = [[NSMutableDictionary alloc] init];
	elementByName = [[NSMutableDictionary alloc] init];
	elementByCode = [[NSMutableDictionary alloc] init];
	commandByName = [[NSMutableDictionary alloc] init];
	return self;
}


/* TO DO:
 *	-(id)initWithDefaultTerminology:(ASStringTerminology *)terms; -- copies tables + converter from one ASStringTerminology object to another; default tables are then also used for collision checking
 *
 * OR:
 *
 *	-(id)setDefaultTerminology:(ASStringTerminology *)terms; -- copies tables from one ASStringTerminology object to another; default tables are then also used for collision checking
 *
 * OR:
 *
 * -(id)childTable; -- returns a new ASStringTerminology instance containing default table info
 *
 * -(id)copyWithZone:(NSZone *)zone -- allows a copy-and-extend approach
 */

- (void)addParserData:(id)data { // adds raw data from ASAeteParser or equivalent
	NSEnumerator *commandEnumerator, *parameterEnumerator;
	ASParserCommandDef *parserCommandDef;
	ASCommandDef *commandDef;
	ASParserDef *parameterDef;

	// build type tables
	[self addTypeTableDefinitions: (NSArray *)[data properties] ofType: typeType];
	[self addTypeTableDefinitions: (NSArray *)[data enumerators] ofType: typeEnumerated];
	[self addTypeTableDefinitions: (NSArray *)[data classes] ofType: typeType];
	// build reference tables
	[self addReferenceTableDefinitions: (NSArray *)[data elements]
						   toNameTable: elementByName
						  andCodeTable: elementByCode];
	[self addReferenceTableDefinitions: (NSArray *)[data properties]
						   toNameTable: propertyByName
						  andCodeTable: propertyByCode];
	// TO DO: if property table contains a 'text' definition, move it to element table (AppleScript always packs 'text of...' as an all-elements specifier)
	// build command table
	commandEnumerator = [[data commands] objectEnumerator];
	while (parserCommandDef = [commandEnumerator nextObject]) {
		commandDef = [[ASCommandDef alloc] initWithName: [parserCommandDef name]
											 eventClass: [parserCommandDef classCode]
												eventID: [parserCommandDef code]];
		parameterEnumerator = [[parserCommandDef parameters] objectEnumerator];
		while (parameterDef = [parameterEnumerator nextObject])
			[commandDef addParameterName: [parameterDef name] code: [parameterDef code]];
		[commandByName setObject: commandDef
						  forKey: [converter convert: [parserCommandDef name]]];
		[commandDef release];
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
	[super dealloc];
}


//

- (void)addTypeTableDefinitions:(NSArray *)definitions ofType:(OSType)descType {
	ASParserDef *parserDef;
	NSString *name;
	OSType code;
	NSNumber *codeObj;
	NSAppleEventDescriptor *desc;
	unsigned len, i;
	
	len = [definitions count];
	for (i = 0; i < len; i++) {
		// add a definition to typeByCode table
		// to handle synonyms, if same code appears more than once then use name from last definition in list
		parserDef = [definitions objectAtIndex: i];
		name = [converter convert: [parserDef name]];
		code = [parserDef code];
		// TO DO: escape definitions that semi-overlap built-in definitions? or resolve in some other way?
		codeObj = [[NSNumber alloc] initWithLong: code];
		[typeByCode setObject: name forKey: codeObj];
		[codeObj release];
		// add a definition to typeByCode table
		// to handle synonyms, if same name appears more than once then use code from first definition in list
		parserDef = [definitions objectAtIndex: (len - 1 - i)];
		name = [converter convert: [parserDef name]];
		code = [parserDef code];
		// TO DO: escape definitions that semi-overlap built-in definitions? or resolve in some other way?
		desc = [[NSAppleEventDescriptor alloc] initWithDescriptorType: descType
																bytes: (void *)(&code)
															   length: sizeof(code)];
		[typeByName setObject: desc forKey: name];
		[desc release];
	}
}


- (void)addReferenceTableDefinitions:(NSArray *)definitions
						 toNameTable:(NSMutableDictionary *)nameTable
						andCodeTable:(NSMutableDictionary *)codeTable {
	ASParserDef *parserDef;
	NSString *name;
	NSNumber *codeObj;
	unsigned len, i;
	
	len = [definitions count];
	for (i = 0; i < len; i++) {
		// add a definition to the byCode table
		// to handle synonyms, if same code appears more than once then use name from last definition in list
		parserDef = [definitions objectAtIndex: i];
		name = [converter convert: [parserDef name]];
		codeObj = [[NSNumber alloc] initWithLong: [parserDef code]];
		[codeTable setObject: name forKey: codeObj];
		[codeObj release];
		// add a definition to the byName table
		// to handle synonyms, if same name appears more than once then use code from first definition in list
		parserDef = [definitions objectAtIndex: (len - 1 - i)];
		name = [converter convert: [parserDef name]];
		codeObj = [[NSNumber alloc] initWithLong: [parserDef code]];
		[nameTable setObject: codeObj forKey: name];
		[codeObj release];
	}
}


// Lookup methods return YES/NO to indicate if lookup was successful.

// Used to pack/unpack typeType, typeEnumerated, typeProperty:

- (NSAppleEventDescriptor *)typeForName:(NSString *)name {
	return [typeByName objectForKey: name];
}


- (NSString *)typeForCode:(OSType)descData {
	NSNumber *codeObj;
	NSString *name;
	
	codeObj = [[NSNumber alloc] initWithLong: descData];
	name = [typeByCode objectForKey: codeObj];
	[codeObj release];
	return name;
}

// Used to build AEM references:

- (ASDefinition *)referenceForName:(NSString *)name {
	ASDefinition *def;
	
	def = [propertyByName objectForKey: name];
	if (!def)
		def = [elementByName objectForKey: name];
	if (!def)
		def = [commandByName objectForKey: name];
	return def;
}

// Used by -description to render AEM references:

- (ASDefinition *)referenceForCode:(OSType)code 
						preferably:(ASPreferredDefinitionType)preferredType {
	NSNumber *codeObj;
	ASDefinition *def;
	
	codeObj = [[NSNumber alloc] initWithLong: code];
	if (preferredType == kASPropertyDef)
		def = [propertyByCode objectForKey: codeObj];
	else
		def = [elementByCode objectForKey: codeObj];
	if (!def)
		if (def == kASPropertyDef) {
			def = [elementByCode objectForKey: codeObj];
		} else {
			def = [propertyByCode objectForKey: codeObj];
		}
	[codeObj release];
	return def;
}


// Obtain copies of conversion tables directly, if needed:

- (NSDictionary *)propertyByNameTable {
	return [NSDictionary dictionaryWithDictionary: propertyByName];
}

- (NSDictionary *)propertyByCodeTable {
	return [NSDictionary dictionaryWithDictionary: propertyByCode];
}

- (NSDictionary *)elementByNameTable {
	return [NSDictionary dictionaryWithDictionary: elementByName];
}

- (NSDictionary *)elementByCodeTable {
	return [NSDictionary dictionaryWithDictionary: elementByCode];
}

- (NSDictionary *)commandByNameTable {
	return [NSDictionary dictionaryWithDictionary: commandByName];
}

@end


/**********************************************************************/
