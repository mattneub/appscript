//
//  terminology.m
//  AppscriptTEST
//
//  Created by Hamish Sanderson on 21/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "terminology.h"


/**********************************************************************/


@implementation ASNullConverter

- (NSString *)convert:(NSString *)name {
	return name; // if returning a new name, autorelease it
}

- (NSString *)escape:(NSString *)name {
	return name; // if returning a new name, autorelease it
}

@end


/**********************************************************************/



@implementation ASCommandDef

- (id)init {
	return nil;
}

- (id)initWithEventClass:(OSType)classCode_
				 eventID:(OSType)code_
			  parameters:(NSArray *)parameters_
		keywordConverter:(id)converter {
	NSEnumerator *enumerator;
	ASParserDef *parameter;
	NSNumber *codeObj;
	
	self = [super self];
	if (!self) return self;
	classCode = classCode_;
	code = code_;
	parameters = [[NSMutableDictionary alloc] init];
	enumerator = [parameters_ objectEnumerator];
	while (parameter = [enumerator nextObject]) {
		codeObj = [[NSNumber alloc] initWithLong: [parameter code]];
		[parameters setObject: codeObj forKey: [converter convert: [parameter name]]];
		[codeObj release];
	}
	return self;
}

- (void)dealloc {
	[parameters release];
	[super dealloc];
}


- (OSType)classCode {
	return classCode;
}

- (OSType)code {
	return code;
}

- (BOOL)parameterByName:(NSString *)name code:(OSType *)code_ {
	NSNumber *codeObj;
	
	codeObj = [parameters objectForKey: name];
	if (!codeObj) return NO;
	*code_ = [codeObj longValue];
	return YES;
}

@end


/**********************************************************************/


@implementation ASStringTerminology

- (id)init {
	return nil; // TO DO: build table containing default terminology only
}

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
															   length: 4];
		[typeByName setObject: desc forKey: name];
		[desc release];
	}
}


- (void)addReferenceTableDefinitions:(NSArray *)definitions
						 toNameTable:(NSMutableDictionary *)nameTable
						   codeTable:(NSMutableDictionary *)codeTable {
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

- (id)initWithData:(id)data keywordConverter:(id)converter_ {
	NSEnumerator *enumerator;
	ASParserCommandDef *parserCommandDef;
	ASCommandDef *commandDef;
	
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
	// build type tables
	[self addTypeTableDefinitions: (NSArray *)[data properties] ofType: typeType];
	[self addTypeTableDefinitions: (NSArray *)[data enumerators] ofType: typeEnumerated];
	[self addTypeTableDefinitions: (NSArray *)[data classes] ofType: typeType];
	// build reference tables
	[self addReferenceTableDefinitions: (NSArray *)[data elements]
						   toNameTable: elementByName
							 codeTable: elementByCode];
	[self addReferenceTableDefinitions: (NSArray *)[data properties]
						   toNameTable: propertyByName
						     codeTable: propertyByCode];
	// TO DO: if property table contains a 'text' definition, move it to element table (AppleScript always packs 'text of...' as an all-elements specifier)
	// build command table
	enumerator = [[data commands] objectEnumerator];
	while (parserCommandDef = [enumerator nextObject]) {
		commandDef = [[ASCommandDef alloc] initWithEventClass: [parserCommandDef classCode]
													  eventID: [parserCommandDef code]
												   parameters: [parserCommandDef parameters]
											 keywordConverter: converter];
		[commandByName setObject: commandDef
						  forKey: [converter convert: [parserCommandDef name]]];
		[commandDef release];
	}
	return self;
}

- (id)initWithData:(id)data {
	id converter_;
	
	converter_ = [[ASNullConverter alloc] init];
	self = [self initWithData: data keywordConverter: converter_];
	return self;
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


// Lookup methods return YES/NO to indicate if lookup was successful.

// Used to pack/unpack typeType, typeEnumerated, typeProperty:

- (BOOL)typeByName:(NSString *)name
				  desc:(NSAppleEventDescriptor **)desc {
	*desc = [typeByName objectForKey: name];
	return (*desc != nil);
}


- (BOOL)typeByCode:(OSType)descData
				  name:(NSString **)name {
	NSNumber *codeObj;
	
	codeObj = [[NSNumber alloc] initWithLong: descData];
	*name = [typeByCode objectForKey: codeObj];
	[codeObj release];
	return (*name != nil);
}

// Used to build AEM references:

- (BOOL)referenceByName:(NSString *)name
				   code:(OSType *)code
				   type:(ASReferenceType *)type {
	NSNumber *codeObj;
	
	codeObj = [propertyByName objectForKey: name];
	if (codeObj)
		*type = kPropertyDef;
	else {
		codeObj = [elementByName objectForKey: name];
		if (codeObj)
			*type = kElementDef;
		else
			return NO;
	}
	return YES;
}

// Used by -description to render AEM references:

- (BOOL)referenceByCode:(OSType)code
				   name:(NSString **)name
				   type:(ASReferenceType *)type {
	NSNumber *codeObj;
	
	codeObj = [[NSNumber alloc] initWithLong: code];
	if (*type == kPropertyDef)
		*name = [propertyByCode objectForKey: codeObj];
	else
		*name = [elementByCode objectForKey: codeObj];
	if (!*name)
		if (*type == kPropertyDef) {
			*name = [elementByCode objectForKey: codeObj];
			*type = kElementDef;
		} else {
			*name = [propertyByCode objectForKey: codeObj];
			*type = kPropertyDef;
		}
	[codeObj release];
	return (*name != nil);
}

// Used to pack Apple events:

- (BOOL)commandByName:(NSString *)name
			  definition:(ASCommandDef **)definition {
	
	*definition = [commandByName objectForKey: name];
	return (*definition != nil);
}

@end


/**********************************************************************/
