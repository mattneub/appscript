//
//  codecs.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "codecs.h"

/*
 * NOTES:
 * - NSAppleEventDescriptors don't work as dictionary keys; use AEMType/AEMProperty instead (or NSString for user-defined property names)
 */


/**********************************************************************/


@implementation AEMCodecs

+ (id)defaultCodecs {
	static AEMCodecs *defaultCodecs;

	if (!defaultCodecs)
		defaultCodecs = [[self alloc] init];
	return defaultCodecs;
}


- (id)init {
	self = [super init];
	if (!self) return self;
	applicationRootDescriptor = [[NSAppleEventDescriptor nullDescriptor] retain];
	AEMGetDefaultUnitTypeDefinitions(&unitTypeDefinitionByName, &unitTypeDefinitionByCode);
	disableCache = NO;
	disableUnicode = NO;
	return self;
}


- (void)dealloc {
	[applicationRootDescriptor release];
	[super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
	AEMCodecs *obj = (AEMCodecs *)NSCopyObject(self, 0, zone);
	if (!obj) return obj;
	[obj->applicationRootDescriptor retain];
	return obj;
}



+ (NSString *)displayObject:(NSObject *)obj {
	return AEMObjectToDisplayString(obj);
}


/**********************************************************************/
// compatibility options

- (void)addUnitTypeDefinition:(AEMUnitTypeDefinition *)definition {
	[unitTypeDefinitionByName setObject: definition forKey: [definition name]];
	[unitTypeDefinitionByCode setObject: definition forKey: [NSNumber numberWithUnsignedInt: [definition code]]];
}

- (void)dontCacheUnpackedSpecifiers {
	disableCache = YES;
}

- (void)packStringsAsType:(DescType)type {
	disableUnicode = YES;
	textType = type;
}

/***********************************/
// main pack methods; subclasses can override to process some or all values themselves

- (NSAppleEventDescriptor *)pack:(id)anObject {
	UInt32 uint32;
	SInt64 sint64;
	UInt64 uint64;
	double float64;
	CFAbsoluteTime cfTime;
	LongDateTime longDate;
	NSData *data;
	AEMUnitTypeDefinition *unitTypeDefinition;
	NSAppleEventDescriptor *result = nil;
		
	if ([anObject conformsToProtocol: @protocol(AEMSelfPackingProtocol)]) // AEM application, Boolean, file, type, specifier objects
		result = [anObject packWithCodecs: self];
	else if ([anObject isKindOfClass: [NSNumber class]]) {
		switch (*[anObject objCType]) {
			/*
			 * note: for better compatibility with less well-designed applications that don't like
			 * less common integer types (typeSInt64, typeUInt32, etc.), try to use typeSInt32
			 * and typeFloat (double) whenever possible
			 */
			case 'b':
			case 'c':
			case 'C':
			case 's':
			case 'S':
			case 'i':
			case 'l':
				packAsSInt32:
					result = [NSAppleEventDescriptor descriptorWithInt32: [anObject intValue]];
					break;
			case 'I':
			case 'L':
				uint32 = [anObject unsignedIntValue];
				if (uint32 < 0x7FFFFFFF)
					goto packAsSInt32;
				result = [NSAppleEventDescriptor descriptorWithDescriptorType: typeUInt32
																		bytes: &uint32
																	   length: sizeof(uint32)];
				break;
			case 'q':
				packAsSInt64:
					sint64 = [anObject longLongValue];
					if (sint64 >= 0x80000000 && sint64 < 0x7FFFFFFF)
						goto packAsSInt32;
					result = [NSAppleEventDescriptor descriptorWithDescriptorType: typeSInt64
																			bytes: &sint64
																		   length: sizeof(sint64)];
					break;
			case 'Q':
				uint64 = [anObject unsignedLongLongValue];
				if (uint64 < 0x7FFFFFFF)
					goto packAsSInt32;
				else if (uint64 < pow(2, 63))
					goto packAsSInt64;
				// else pack as double for compatibility's sake
			default: // f, d
				packAsDouble:
					float64 = [anObject doubleValue];
					result = [NSAppleEventDescriptor descriptorWithDescriptorType: typeIEEE64BitFloatingPoint
																			bytes: &float64
																		   length: sizeof(float64)];
		}
	} else if ([anObject isKindOfClass: [NSString class]]) {
		result = [NSAppleEventDescriptor descriptorWithString: anObject];
		if (disableUnicode)
			result = [result coerceToDescriptorType: textType];
	} else if ([anObject isKindOfClass: [NSDate class]]) {
		cfTime = [anObject timeIntervalSinceReferenceDate];
		if (!UCConvertCFAbsoluteTimeToLongDateTime(cfTime, &longDate))
			result = [NSAppleEventDescriptor descriptorWithDescriptorType: typeLongDateTime
																	bytes: &longDate
																   length: sizeof(longDate)];
	} else if ([anObject isKindOfClass: [NSArray class]])
		result = [self packArray: anObject];
	else if ([anObject isKindOfClass: [NSDictionary class]])
		result = [self packDictionary: anObject];
	else if ([anObject isKindOfClass: [NSURL class]]) {
		if ([anObject isFileURL]) {
			data = [[anObject absoluteString] dataUsingEncoding: NSUTF8StringEncoding];
			return [NSAppleEventDescriptor descriptorWithDescriptorType: typeFileURL
																   data: data];
		} else
			return [self packUnknown: anObject];
	} else if ([anObject isKindOfClass: [NSAppleEventDescriptor class]])
		result = anObject;
	else if ([anObject isKindOfClass: [NSNull class]])
		result = [NSAppleEventDescriptor nullDescriptor];
	else if ([anObject isKindOfClass: [ASUnits class]]) {
		unitTypeDefinition = [unitTypeDefinitionByName objectForKey: [anObject units]];
		if (!unitTypeDefinition)
			[NSException raise: @"CodecsError"
						format: @"Can't pack ASUnits object (unknown unit type): %@", anObject];
		result = [unitTypeDefinition pack: anObject];
	} else
		result = [self packUnknown: anObject];
	if (!result)
		[NSException raise: @"CodecsError"
					format: @"An unexpected error occurred while packing the following %@ object: %@",
							[anObject class], anObject];
	return result;
}

// subclasses can override -packUnknown: to process any still-unconverted types
- (NSAppleEventDescriptor *)packUnknown:(id)anObject {
	if (anObject)
		[NSException raise: @"CodecsError"
					format: @"Can't pack object of class %@ (unsupported type): %@",
							[anObject class], anObject];
	else
		[NSException raise: @"CodecsError" format: @"Can't pack nil."];
	return nil;
}


// methods called by -pack:; may be overridden by subclasses to modify how values are packed

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
	NSAppleEventDescriptor *result, *coercedDesc, *keyDesc, *valueDesc, *userProperties = nil;
	id key, value;
	OSType keyCode;
	
	enumerator = [anObject keyEnumerator];
	result = [NSAppleEventDescriptor recordDescriptor];
	while (key = [enumerator nextObject]) {
		value = [anObject objectForKey: key];
		if (!value) [NSException raise: @"BadDictionaryKey"
								format: @"Not an acceptable dictionary key: %@", key];
		keyDesc = [self pack: key];
		valueDesc = [self pack: value];
		keyCode = [keyDesc descriptorType];
		if (keyCode == typeType || keyCode == typeProperty) {
			keyCode = [keyDesc typeCodeValue];
			if (keyCode == pClass && [valueDesc descriptorType] == typeType) {
				// AS packs records that contain a 'class' property by coercing the record to that type
				coercedDesc = [result coerceToDescriptorType: [valueDesc typeCodeValue]];
				if (coercedDesc)
					result = coercedDesc;
				else // coercion failed, so pack it as a regular record item instead
					[result setDescriptor: valueDesc forKeyword: keyCode];
			} else
				[result setDescriptor: valueDesc forKeyword: keyCode];
		} else {
			if (!userProperties)
				userProperties = [NSAppleEventDescriptor listDescriptor];
			[userProperties insertDescriptor: keyDesc atIndex: 0]; // i.e. with 1-indexed AEDescs, index 0 = 'append'
			[userProperties insertDescriptor: valueDesc atIndex: 0];
		}
	}
	if (userProperties)
		[result setDescriptor: userProperties forKeyword: keyASUserRecordFields];
	return result;
}


- (void)setApplicationRootDescriptor:(NSAppleEventDescriptor *)desc {
	[applicationRootDescriptor release];
	applicationRootDescriptor = [desc retain];
}

- (NSAppleEventDescriptor *)applicationRootDescriptor {
	return applicationRootDescriptor;
}


/***********************************/
// main unpack methods; subclasses can override to process some or all descs themselves

- (id)unpack:(NSAppleEventDescriptor *)desc {
	LongDateTime longTime;
	CFAbsoluteTime cfTime;
	Boolean boolean;
	unsigned short uint16;
	SInt16 sint16;
	UInt32 uint32;
	SInt64 sint64;
	unsigned long long uint64;
	float float32;
	double float64;
	NSString *string;
	NSURL *url;
	short qdPoint[2];
	short qdRect[4];
	unsigned short rgbColor[3];
	AEMUnitTypeDefinition *unitTypeDefinition;
	id result = nil;
	
	switch ([desc descriptorType]) {
		case typeObjectSpecifier:
			result = [self unpackObjectSpecifier: desc];
			break;
		case typeSInt32:
			result = [NSNumber numberWithLong: [desc int32Value]];
			break;
		case typeIEEE64BitFloatingPoint:
			[[desc data] getBytes: &float64 length: sizeof(float64)];
			result = [NSNumber numberWithDouble: float64];
			break;
		case typeChar: 
		case typeIntlText:
		case typeUTF8Text:
		case AS_typeUTF16ExternalRepresentation:
		case typeStyledText:
		case typeUnicodeText:
			result = [desc stringValue];
			break;
		case typeFalse:
			result = ASFalse;
			break;
		case typeTrue:
			result = ASTrue;
			break;
		case typeLongDateTime:
			[[desc data] getBytes: &longTime length: sizeof(longTime)];
			if (UCConvertLongDateTimeToCFAbsoluteTime(longTime, &cfTime) == noErr)
				result = [NSDate dateWithTimeIntervalSinceReferenceDate: cfTime];
			break;
		case typeAEList:
			result = [self unpackAEList: desc];
			break;
		case typeAERecord:
			result = [self unpackAERecord: desc];
			break;
		case typeAlias: 
			result = [ASAlias aliasWithDescriptor: desc];
			break;
		case typeFileURL:
			string = [[NSString alloc] initWithData: [desc data] encoding: NSUTF8StringEncoding];
			url = [NSURL URLWithString: string];
			[string release];
			result = url;
			break;
		case typeFSRef:
			result = [ASFileRef fileRefWithDescriptor: desc];
			break;
		case typeFSS:
			result = [ASFileSpec fileSpecWithDescriptor: desc];
			break;
		case typeType:
			result = [self unpackType: desc];
			break;
		case typeEnumerated:
			result = [self unpackEnum: desc];
			break;
		case typeProperty:
			result = [self unpackProperty: desc];
			break;
		case typeKeyword:
			result = [self unpackKeyword: desc];
			break;
		case typeSInt16:
			[[desc data] getBytes: &sint16 length: sizeof(sint16)];
			result = [NSNumber numberWithShort: sint16];
			break;
		case AS_typeUInt16:
			[[desc data] getBytes: &uint16 length: sizeof(uint16)];
			result = [NSNumber numberWithUnsignedShort: uint16];
			break;
		case typeUInt32:
			[[desc data] getBytes: &uint32 length: sizeof(uint32)];
			result = [NSNumber numberWithUnsignedLong: uint32];
			break;
		case typeSInt64:
			[[desc data] getBytes: &sint64 length: sizeof(sint64)];
			result = [NSNumber numberWithLongLong: sint64];
			break;
		case AS_typeUInt64:
			[[desc data] getBytes: &uint64 length: sizeof(uint64)];
			result = [NSNumber numberWithUnsignedLongLong: uint64];
			break;
		case typeNull:
			result = [NSNull null];
			break;
		case typeInsertionLoc:
			result = [self unpackInsertionLoc: desc];
			break;
		case typeCurrentContainer:
			result = [self con];
			break;
		case typeObjectBeingExamined:
			result = [self its];
			break;
		case typeCompDescriptor:
			result = [self unpackCompDescriptor: desc];
			break;
		case typeLogicalDescriptor:
			result = [self unpackLogicalDescriptor: desc];
			break;
		case typeIEEE32BitFloatingPoint:
			[[desc data] getBytes: &float32 length: sizeof(float32)];
			result = [NSNumber numberWithDouble: float32];
			break;
		case type128BitFloatingPoint:
			[[[desc coerceToDescriptorType: typeIEEE64BitFloatingPoint] data] getBytes: &float64 
																				length: sizeof(float64)];
			result = [NSNumber numberWithDouble: float64];
			break;
		case typeQDPoint:
			[[desc data] getBytes: &qdPoint length: sizeof(qdPoint)];
			result = [NSArray arrayWithObjects: [NSNumber numberWithShort: qdPoint[1]],
												[NSNumber numberWithShort: qdPoint[0]], nil];
			break;
		case typeQDRectangle:
			[[desc data] getBytes: &qdRect length: sizeof(qdRect)];
			result = [NSArray arrayWithObjects: [NSNumber numberWithShort: qdRect[1]],
												[NSNumber numberWithShort: qdRect[0]],
												[NSNumber numberWithShort: qdRect[3]],
												[NSNumber numberWithShort: qdRect[2]], nil];
			break;
		case typeRGBColor:
			[[desc data] getBytes: &rgbColor length: sizeof(rgbColor)];
			result = [NSArray arrayWithObjects: [NSNumber numberWithUnsignedShort: rgbColor[0]],
												[NSNumber numberWithUnsignedShort: rgbColor[1]],
												[NSNumber numberWithUnsignedShort: rgbColor[2]], nil];
			break;
		case typeVersion:
			result = [[desc coerceToDescriptorType: typeUnicodeText] stringValue];
			if (!result) { // typeVersion -> typeUnicodeText coercion isn't supported in 10.3.9 or earlier
				[[desc data] getBytes: &uint16 length: sizeof(uint16)];
				uint16 = CFSwapInt16HostToBig(uint16);
				result = [NSString stringWithFormat: @"%i.%i.%i", 
													 uint16 >> 8, 
													 uint16 % 256 >> 4, 
													 uint16 % 16];
			}
			break;
		case typeBoolean:
			[[desc data] getBytes: &boolean length: sizeof(boolean)];
			result = boolean ? ASTrue : ASFalse;
			break;
		default:
			unitTypeDefinition = [unitTypeDefinitionByName objectForKey: [NSNumber numberWithUnsignedInt: [desc descriptorType]]];
			if (unitTypeDefinition)
				result = [unitTypeDefinition unpack: desc];
			else
				result = [self unpackUnknown: desc];
	}
	if (!result)
		[NSException raise: @"CodecsError"
					format: @"An unexpected error occurred while unpacking the following NSAppleEventDescriptor: %@", desc];
	return result;
}

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
	NSAppleEventDescriptor *valueDesc;
	AEKeyword key;
	const AEDesc *record;
	AEDesc valueAEDesc;
	int i, j, length, length2;
	id value;
	
	result = [NSMutableDictionary dictionary];
	length = [desc numberOfItems];
	record = [desc aeDesc];
	for (i = 1; i <= length; i++) {
		err = AEGetNthDesc(record,
						   i,
						   typeWildCard,
						   &key,
						   &valueAEDesc);
		if (err != noErr) return nil; // don't think this will ever happen
		valueDesc = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &valueAEDesc];
		value = [self unpack: valueDesc];
		if (key == keyASUserRecordFields) {
			length2 = [value count]; 
			for (j = 0; j < length2; j += 2)
				[result setObject: [value objectAtIndex: j + 1]
						   forKey: [value objectAtIndex: j]];
		} else
			[result setObject: value forKey: [self unpackAERecordKey: key]]; 
		[valueDesc release];
	}
	return result;
}

// subclasses can override this method to change how record keys are unpacked:
- (id)unpackAERecordKey:(AEKeyword)key {
	return [AEMType typeWithCode: key];
}


- (id)unpackType:(NSAppleEventDescriptor *)desc {
	return [[[AEMType alloc] initWithDescriptor: desc] autorelease];
}

- (id)unpackEnum:(NSAppleEventDescriptor *)desc {
	return [[[AEMEnum alloc] initWithDescriptor: desc] autorelease];
}

- (id)unpackProperty:(NSAppleEventDescriptor *)desc {
	return [[[AEMProperty alloc] initWithDescriptor: desc] autorelease];
}

- (id)unpackKeyword:(NSAppleEventDescriptor *)desc {
	return [[[AEMKeyword alloc] initWithDescriptor: desc] autorelease];
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
			return [self customRoot: desc];
	}
}

// Shallow-unpack an object specifier, retaining the container AEDesc as-is.
// (i.e. Defers full unpacking of [most] object specifiers for efficiency.)
- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc {
	OSType wantCode, keyForm;
	NSAppleEventDescriptor *key;
	AEMDeferredSpecifier *container;
	AEMUnkeyedElementsShim *shim;
	id ref;
	
	if (disableCache)
		return [self fullyUnpackObjectSpecifier: desc];
		
	keyForm = [[desc descriptorForKeyword: keyAEKeyForm] enumCodeValue];
	switch (keyForm) {
		case formPropertyID:
		case formAbsolutePosition:
		case formName:
		case formUniqueID:
			wantCode = [[desc descriptorForKeyword: keyAEDesiredClass] typeCodeValue];
			key = [desc descriptorForKeyword: keyAEKeyData];
			container = [[[AEMDeferredSpecifier alloc] initWithDescriptor: [desc descriptorForKeyword: keyAEContainer]
																   codecs: self] autorelease];
			switch (keyForm) {
				case formPropertyID:
					ref = [[[AEMPropertySpecifier alloc] initWithContainer: container
																	   key: key
																  wantCode: wantCode] autorelease];
					break;
				case formAbsolutePosition:
					if ([key descriptorType] == typeAbsoluteOrdinal) {
						if ([key typeCodeValue] == kAEAll)
							ref = [[[AEMAllElementsSpecifier alloc] initWithContainer: container
																			 wantCode: wantCode] autorelease];
						else
							ref = [self fullyUnpackObjectSpecifier: desc]; // do a full unpack of rarely returned reference forms
					} else {
						shim = [[[AEMUnkeyedElementsShim alloc] initWithContainer: container wantCode: wantCode] autorelease];
						ref = [[[AEMElementByIndexSpecifier alloc] initWithContainer: shim
																				 key: [self unpack: key]
																			wantCode: wantCode] autorelease];
					}
					break;
				case formName:
					shim = [[[AEMUnkeyedElementsShim alloc] initWithContainer: container wantCode: wantCode] autorelease];
					ref = [[[AEMElementByNameSpecifier alloc] initWithContainer: shim
																			key: [self unpack: key]
																	   wantCode: wantCode] autorelease];
					break;
				case formUniqueID:
					shim = [[[AEMUnkeyedElementsShim alloc] initWithContainer: container wantCode: wantCode] autorelease];
					ref = [[[AEMElementByIDSpecifier alloc] initWithContainer: shim
																		  key: [self unpack: key]
																	 wantCode: wantCode] autorelease];
					break;
			}
			break;
		default: // do a full unpack of more complex, rarely returned reference forms
			ref = [self fullyUnpackObjectSpecifier: desc];
	}
	/*
	 * Have the newly created specifier object cache the existing descriptor for efficiency:
	 *
	 * (Note: AppleScript doesn't cached object specifier descriptors returned by applications,
	 * so application compatibility issues may very occasionally arise, although to-date there's
	 * only one known application that has this problem. The solution is to subclass the default
	 * codecs and override this method to call -fullyUnpackObjectSpecifier: directly, thereby
	 * bypassing this optimisation.)
	 */
	[ref setCachedDesc: desc];
	return ref;
}


- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc {
	id ref;
	
	ref = [self unpack: [desc descriptorForKeyword: keyAEObject]];
	switch ([[desc descriptorForKeyword: keyAEPosition] enumCodeValue]) {
		case kAEBeginning:
			return [ref beginning];
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

- (id)customRoot:(NSAppleEventDescriptor *)desc {
	return AEMRoot([self unpack: desc]);
}

- (id)unpackCompDescriptor:(NSAppleEventDescriptor *)desc {
	DescType operator;
	id op1, op2;
	id ref = nil;
	
	operator = [[desc descriptorForKeyword: keyAECompOperator] enumCodeValue];
	op1 = [self unpack: [desc descriptorForKeyword: keyAEObject1]];
	op2 = [self unpack: [desc descriptorForKeyword: keyAEObject2]];
	switch (operator) {
		case kAEGreaterThan:
			ref = [op1 greaterThan: op2];
			break;
		case kAEGreaterThanEquals:
			ref = [op1 greaterOrEquals: op2];
			break;
		case kAEEquals:
			ref = [op1 equals: op2];
			break;
		case kAELessThan:
			ref = [op1 lessThan: op2];
			break;
		case kAELessThanEquals:
			ref = [op1 lessOrEquals: op2];
			break;
		case kAEBeginsWith:
			ref = [op1 beginsWith: op2];
			break;
		case kAEEndsWith:
			ref = [op1 endsWith: op2];
			break;
		case kAEContains:
			ref = [self unpackContainsCompDescriptorWithOperand1: op1 operand2: op2];
			break;
	}
	return ref;
}

- (id)unpackLogicalDescriptor:(NSAppleEventDescriptor *)desc {
	DescType operator;
	NSAppleEventDescriptor *listDesc;
	id op1;
	id ref = nil;
	
	operator = [[desc descriptorForKeyword: keyAELogicalOperator] enumCodeValue];
	listDesc = [[desc descriptorForKeyword: keyAELogicalTerms] coerceToDescriptorType: typeAEList];
	op1 = [self unpack: [listDesc descriptorAtIndex: 1]];
	switch (operator) {
		case kAEAND:
			[listDesc removeDescriptorAtIndex: 1];
			ref = [op1 AND: [self unpack: listDesc]];
			break;
		case kAEOR:
			[listDesc removeDescriptorAtIndex: 1];
			ref = [op1 AND: [self unpack: listDesc]];
			break;
		case kAENOT:
			ref = [op1 NOT];
			break;
	}
	return ref;
}

- (id)unpackContainsCompDescriptorWithOperand1:(id)op1 operand2:(id)op2 {
	if ([op1 isKindOfClass: [AEMQuery class]] && [[op1 root] isEqualTo: AEMIts])
		return [op1 contains: op2];
	else
		return [op2 isIn: op1];
}


// optional

- (NSString *)unpackApplicationBundleID:(NSAppleEventDescriptor *)desc {
	return [[[NSString alloc] initWithData: [desc data] encoding: NSUTF8StringEncoding] autorelease];
}

- (NSURL *)unpackApplicationURL:(NSAppleEventDescriptor *)desc {
	NSString *str; 
	NSURL *url;
	
	str = [[NSString alloc] initWithData: [desc data] encoding: NSUTF8StringEncoding];
	url = [NSURL URLWithString: str];
	[str release];
	return url;
}

- (OSType)unpackApplicationSignature:(NSAppleEventDescriptor *)desc {
	OSType sig;
	
	[[desc data] getBytes: &sig length: sizeof(sig)];
	return sig;
}

- (pid_t)unpackProcessID:(NSAppleEventDescriptor *)desc {
	pid_t pid;
	
	[[desc data] getBytes: &pid length: sizeof(pid)];
	return pid;
}

- (pid_t)unpackProcessSerialNumber:(NSAppleEventDescriptor *)desc {
	ProcessSerialNumber psn = {0, 0};
	pid_t pid;
	
	[[desc data] getBytes: &psn length: sizeof(psn)];
	if (!GetProcessPID(&psn, &pid)) return 0;
	return pid;
}

@end


/**********************************************************************/
