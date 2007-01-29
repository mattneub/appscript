//
//  codecs.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "codecs.h"

/*
 * NOTES:
 * - NSAppleEventDescriptors don't work as dictionary keys; use AEMType/AEMProperty instead
 */

/*
 * TO DO:
 * - unit types support
 * - AEMAlias, AEMFile (or map typeFileURL to NSURL/NSURL subclass?)
 * - improve NSNumber packing
 * - finish reference unpacking
 * - find out what classes can be used as dictionary keys (note that NSAppleEventDescriptor can't)
 */


/**********************************************************************/


@implementation AEMCodecs

/***********************************/
// main pack methods; subclasses can override to process some or all values themselves

// subclasses can override -packUnknown: to process any still-unconverted types
- (NSAppleEventDescriptor *)packUnknown:(id)data {
	if (data)
		[NSException raise: @"CodecsError"
					format: @"Can't pack data of class %@ (unsupported type): %@",
							[data class], data];
	else
		[NSException raise: @"CodecsError" format: @"Can't pack nil."];
	return nil;
}

- (NSAppleEventDescriptor *)pack:(id)anObject {
	UInt32 uint32;
	SInt64 sint64;
	double float64;
	CFAbsoluteTime cfTime;
	LongDateTime longDate;
		
	if ([anObject isKindOfClass: [AEMQuery class]])
		return [anObject packSelf: self];
	else if ([anObject isKindOfClass: [NSNumber class]]) {
		if ([anObject isKindOfClass: [AEMBoolean class]])
			if ([anObject boolValue])
				return [NSAppleEventDescriptor descriptorWithBoolean: YES];
			else
				return [NSAppleEventDescriptor descriptorWithBoolean: NO];
		switch (*[anObject objCType]) { // TO DO: for ILqQ, use SInt32 where possible; else use UInt32 where possible; else use SInt64 where possible; else use Float
			case 'b':
			case 'c':
			case 'C':
			case 's':
			case 'S':
			case 'i':
			case 'l':
				return [NSAppleEventDescriptor descriptorWithInt32: [anObject longValue]];
			case 'I':
			case 'L':
				uint32 = [anObject unsignedLongValue];
				return [NSAppleEventDescriptor descriptorWithDescriptorType: typeUInt32
																	  bytes: &uint32
																	 length: sizeof(uint32)];
			case 'q':
				sint64 = [anObject longLongValue];
				return [NSAppleEventDescriptor descriptorWithDescriptorType: typeSInt64
																	  bytes: &sint64
																	 length: sizeof(sint64)];
			default: // f, d, Q
				float64 = [anObject doubleValue];
				return [NSAppleEventDescriptor descriptorWithDescriptorType: typeIEEE64BitFloatingPoint
																	  bytes: &float64
																	 length: sizeof(float64)];
		}
	} else if ([anObject isKindOfClass: [NSString class]])
		return [NSAppleEventDescriptor descriptorWithString: anObject];
	else if ([anObject isKindOfClass: [NSDate class]]) {
		cfTime = [anObject timeIntervalSinceReferenceDate];
		if (UCConvertCFAbsoluteTimeToLongDateTime(cfTime, &longDate)) return nil;
		return [NSAppleEventDescriptor descriptorWithDescriptorType: typeLongDateTime
															  bytes: &longDate
															 length: sizeof(longDate)];
	} else if ([anObject isKindOfClass: [NSArray class]])
		return [self packArray: anObject];
	else if ([anObject isKindOfClass: [NSDictionary class]])
		return [self packDictionary: anObject];
	// TO DO: Alias, File types
	else if ([anObject isKindOfClass: [AEMTypeBase class]])
		return [anObject desc];
	else if ([anObject isKindOfClass: [NSAppleEventDescriptor class]])
		return anObject;
	else if ([anObject isKindOfClass: [NSNull class]])
		return [NSAppleEventDescriptor nullDescriptor];
	// TO DO: unit types
	return [self packUnknown: anObject];
}


- (NSAppleEventDescriptor *)packArray:(NSArray *)anObject {
	NSEnumerator *enumerator;
	NSAppleEventDescriptor *desc;
	id item;
	
	enumerator = [anObject objectEnumerator];
	desc = [NSAppleEventDescriptor listDescriptor];
	while (item = [enumerator nextObject])
		[desc insertDescriptor: [self pack: item] atIndex: 0];
	return desc;
}


- (NSAppleEventDescriptor *)packDictionary:(NSDictionary *)anObject {
	NSEnumerator *enumerator;
	NSAppleEventDescriptor *result, *value, *userProperties;
	id key, valueObj;
	OSType keyCode;
	
	enumerator = [anObject keyEnumerator];
	result = [NSAppleEventDescriptor recordDescriptor];
	while (key = [enumerator nextObject]) {
		valueObj = [anObject objectForKey: key];
		if (!valueObj) [NSException raise: @"BadDictionaryKey"
								   format: @"Not an acceptable dictionary key: %@", key];
		value = [self pack: valueObj];
		if ([key isKindOfClass: [AEMTypeBase class]]) {
			keyCode = [key code];
			if (keyCode == pClass)
				// AS packs records that contain a 'class' property by coercing the record to that type
				result = [result coerceToDescriptorType: [value typeCodeValue]];
			else
				[result setDescriptor: value forKeyword: keyCode];
		} else {
			if (!userProperties)
				userProperties = [NSAppleEventDescriptor listDescriptor];
			[userProperties insertDescriptor: [self pack: key] atIndex: 0];
			[userProperties insertDescriptor: value atIndex: 0];
		}
	}
	if (userProperties)
		[result setDescriptor: userProperties forKeyword: keyASUserRecordFields];
	return result;
}


/***********************************/
// main unpack methods; subclasses can override to process some or all descs themselves

- (id)unpackUnknown:(NSAppleEventDescriptor *)desc {
	NSAppleEventDescriptor *record, *descType;
	if (AECheckIsRecord([desc aeDesc])) { 
		/*
		 * if it's a record-like structure with an unknown/unsupported type then unpack 
		 * it as a hash, including the original type info as a 'class' property
		 */
		record = [desc coerceToDescriptorType: typeAERecord];
		descType = [NSAppleEventDescriptor descriptorWithTypeCode: [desc descriptorType]];
		[record setDescriptor: descType forKeyword: pClass];
		return [self unpack: record];
	} else
		return desc;
}


- (id)unpack:(NSAppleEventDescriptor *)desc {
	LongDateTime longTime;
	CFAbsoluteTime cfTime;
	Boolean boolean;
	SInt16 sint16;
	UInt32 uint32;
	SInt64 sint64;
	float float32;
	double float64;
	NSArray *array;
	
	switch ([desc descriptorType]) {
		case typeObjectSpecifier:
			return [self unpackObjectSpecifier: desc];
		case typeSInt32:
			return [NSNumber numberWithLong: [desc int32Value]];
		case typeIEEE64BitFloatingPoint:
			[[desc data] getBytes: &float64 length: sizeof(float64)];
			return [NSNumber numberWithDouble: float64];
		case typeChar: 
		case typeIntlText:
		case typeUTF8Text:
		case typeUTF16ExternalRepresentation:
		case typeStyledText:
		case typeUnicodeText:
			return [desc stringValue];
		case typeFalse:
			return AEMFalse;
		case typeTrue:
			return AEMTrue;
		case typeLongDateTime:
			[[desc data] getBytes: &longTime length: sizeof(longTime)];
			if (UCConvertLongDateTimeToCFAbsoluteTime(longTime, &cfTime)) return nil;
			return [NSDate dateWithTimeIntervalSinceReferenceDate: cfTime];
		case typeAEList:
			return [self unpackAEList: desc];
		case typeAERecord:
			return [self unpackAERecord: desc];
		case typeAlias: 
		case typeFileURL:
		case typeFSRef:
		case typeFSS:
			return nil; // TO DO
		case typeType:
			return [[[AEMType alloc] initWithDescriptorType: '\000\000\000\000'
													   code: '\000\000\000\000'
													   desc: desc] autorelease];
		case typeEnumerated:
			return [[[AEMEnumerator alloc] initWithDescriptorType: '\000\000\000\000'
															 code: '\000\000\000\000'
															 desc: desc] autorelease];
		case typeProperty:
			return [[[AEMProperty alloc] initWithDescriptorType: '\000\000\000\000'
														   code: '\000\000\000\000'
														   desc: desc] autorelease];
		case typeKeyword:
			return [[[AEMKeyword alloc] initWithDescriptorType: '\000\000\000\000'
														  code: '\000\000\000\000'
														  desc: desc] autorelease];
		case typeSInt16:
			[[desc data] getBytes: &sint16 length: sizeof(sint16)];
			return [NSNumber numberWithShort: sint16];
		case typeUInt32:
			[[desc data] getBytes: &uint32 length: sizeof(uint32)];
			return [NSNumber numberWithUnsignedLong: uint32];
		case typeSInt64:
			[[desc data] getBytes: &sint64 length: sizeof(sint64)];
			return [NSNumber numberWithLongLong: sint64];
		case typeNull:
			return [NSNull null];
		case typeInsertionLoc:
			return [self unpackInsertionLoc: desc];
		case typeCurrentContainer:
			return [self con];
		case typeObjectBeingExamined:
			return [self its];
		case typeCompDescriptor:
			return [self unpackCompDescriptor: desc];
		case typeLogicalDescriptor:
			return [self unpackLogicalDescriptor: desc];
		case typeIEEE32BitFloatingPoint:
			[[desc data] getBytes: &float32 length: sizeof(float32)];
			return [NSNumber numberWithDouble: float32];
		case type128BitFloatingPoint:
			[[[desc coerceToDescriptorType: typeIEEE64BitFloatingPoint] data] getBytes: &float64 
																				length: sizeof(float64)];
			return [NSNumber numberWithDouble: float64];
		case typeQDPoint:
			array = [self unpackAEList: [desc coerceToDescriptorType: typeAEList]];
			return [NSArray arrayWithObjects: [array objectAtIndex: 1],
											  [array objectAtIndex: 0]];
		case typeQDRectangle:
			array = [self unpackAEList: [desc coerceToDescriptorType: typeAEList]];
			return [NSArray arrayWithObjects: [array objectAtIndex: 1],
											  [array objectAtIndex: 0],
											  [array objectAtIndex: 3],
											  [array objectAtIndex: 2]];
		case typeRGBColor:
			return [self unpackAEList: [desc coerceToDescriptorType: typeAEList]];
		case typeVersion:
		case typeBoolean:
			[[desc data] getBytes: &boolean length: sizeof(boolean)];
			return boolean ? AEMTrue : AEMFalse;
	}
	// TO DO: unit types
	return [self unpackUnknown: desc];
}

// methods called by -unpack:; may be overridden by subclasses to modify how values are unpacked

- (id)unpackAEList:(NSAppleEventDescriptor *)desc {
	NSMutableArray *result;
	int i, length;
	
	result = [NSMutableArray array];
	length = [desc numberOfItems];
	for (i = 1; i <= length; i++)
		[result addObject: [self unpack: [desc descriptorAtIndex: i]]];
	return result;
}

- (id)unpackAERecord:(NSAppleEventDescriptor *)desc {
	OSErr err = noErr;
	NSMutableDictionary *result;
	NSAppleEventDescriptor *keyDesc, *valueDesc;
	NSArray *userProperties;
	AEKeyword key;
	const AEDesc *record;
	AEDesc value;
	int i, j, length, length2;
	
	result = [NSMutableDictionary dictionary];
	length = [desc numberOfItems];
	record = [desc aeDesc];
	for (i = 1; i <= length; i++) {
		err = AEGetNthDesc(record,
						   i,
						   typeWildCard,
						   &key,
						   &value);
		if (err != noErr) return nil; // don't think this will ever happen
		keyDesc = [NSAppleEventDescriptor descriptorWithTypeCode: key];
		valueDesc = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &value];
		if (key == keyASUserRecordFields) {
			userProperties = [self unpackAEList: valueDesc];
			length2 = [userProperties count]; 
			for (j = 0; j < length2; j += 2)
				[result setObject: [userProperties objectAtIndex: j]
						   forKey: [userProperties objectAtIndex: j + 1]];
		} else
			[result setObject: valueDesc forKey: [self unpackAERecordKey: keyDesc]]; 
		[valueDesc release];
	}
	return result;
}

- (id)unpackAERecordKey:(NSAppleEventDescriptor *)key {
	// subclasses may override this to modify how record keys are unpacked
	return key;
}


- (id)fullyUnpackObjectSpecifier:(NSAppleEventDescriptor *)desc {
	OSType wantCode, keyForm;
	NSAppleEventDescriptor *key;
	id ref;
	
	switch ([desc descriptorType]) {
		case typeObjectSpecifier:
			wantCode = [[desc descriptorForKeyword: keyAEDesiredClass] typeCodeValue];
			keyForm = [[desc descriptorForKeyword: keyAEKeyForm] enumCodeValue];
			key = [desc descriptorForKeyword: keyAEKeyData];
			ref = [self fullyUnpackObjectSpecifier: [desc descriptorForKeyword: keyAEContainer]];
			switch (keyForm) {
				case formPropertyID:
					return [ref property: [key typeCodeValue]];
				case formUserPropertyID:
					return [ref userProperty: [self unpack: key]];
				case formRelativePosition:
					switch ([key typeCodeValue]) {
						case kAEPrevious:
							return [ref previous: wantCode];
						case kAENext:
							return [ref next: wantCode];
						default: // unknown key (should never happen unless object specifier is malformed)
							return nil;
					}
			}
			ref = [ref elements: wantCode];
			switch (keyForm) {
				case formAbsolutePosition:
					if ([key descriptorType] == typeAbsoluteOrdinal)
						switch ([key typeCodeValue]) {
							case kAEAll:
								return ref;
							case kAEFirst:
								return [ref first];
							case kAEMiddle:
								return [ref middle];
							case kAELast:
								return [ref last];
							case kAEAny:
								return [ref any];
							default: // unknown key (should never happen unless object specifier is malformed)
								return nil;
						}
					else
						return [ref byIndex: [self unpack: key]];
				case formName:
					return [ref byName: [self unpack: key]];
				case formUniqueID:
					return [ref byID: [self unpack: key]];
				case formRange:
					return [ref byRange: [self unpack: [key descriptorForKeyword: keyAERangeStart]]
									 to: [self unpack: [key descriptorForKeyword: keyAERangeStop]]];
				case formTest:
					return [ref byTest: [self unpack: key]];
			}
		case typeNull:
			return [self app];
		case typeCurrentContainer:
			return [self con];
		case typeObjectBeingExamined:
			return [self its];
		default:
			return [self unpack: desc];
	}
}

- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc {
	return [self fullyUnpackObjectSpecifier: desc]; // TO DO: implement deferred unpack
}

- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc {
	id ref;
	
	ref = [self unpack: [desc descriptorForKeyword: keyAEObject]];
	switch ([[desc descriptorForKeyword: keyAEPosition] enumCodeValue]) {
		case kAEBeginning:
			return [ref start];
		case kAEEnd:
			return [ref end];
		case kAEBefore:
			return [ref before];
		case kAEAfter:
			return [ref after];
		default: // unknown key (should never happen unless object specifier is malformed)
			return nil;
	}
}

- (id)app {
	return AEMApp;
}

- (id)con {
	return AEMCon;
}

- (id)its {
	return AEMIts;
}

- (id)unpackCompDescriptor:(NSAppleEventDescriptor *)desc {
	return nil; // TO DO
}

- (id)unpackLogicalDescriptor:(NSAppleEventDescriptor *)desc {
	return nil; // TO DO
}

@end


/**********************************************************************/
