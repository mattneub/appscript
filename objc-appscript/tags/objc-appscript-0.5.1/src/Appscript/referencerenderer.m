//
//  referencerenderer.m
//  appscript
//

#import "referencerenderer.h"


/**********************************************************************/
// reference renderer base

@implementation ASReferenceRenderer

// clients should avoid calling this method directly; use +formatObject:appData: instead
- (id)initWithAppData:(id)appData_ {
	self = [super init];
	if (!self) return self;
	result = [NSMutableString string];
	appData = [appData_ retain];
	return self;
}

- (void)dealloc {
	[appData release];
	[super dealloc];
}



/*******/

// takes an AEM specifier/test object, ASAppData instance; returns string representation
+ (NSString *)formatObject:(id)object appData:(id)appData_ {
	ASReferenceRenderer *renderer;
	NSString *string;
	
	if ([object isKindOfClass: [AEMQuery class]]) {
		renderer = [[[self class] alloc] initWithAppData: appData_];
		[object resolveWithObject: renderer];
		string = [renderer result];
		if (!string)
			string = [NSString stringWithFormat: @"[%@ AS_referenceWithObject: %@]", [renderer app], object];
		[renderer release];
	} else {
		string = [AEMObjectRenderer formatObject: object];
	}
	return string;
}

- (NSString *)result {
	return result;
}

/*******/

// method stubs; application-specific subclasses should override to provide code->name translations
- (NSString *)propertyByCode:(OSType)code { 
	return nil;
}

- (NSString *)elementByCode:(OSType)code {
	return nil;
}

// method stub; application-specific subclasses should override to provide class name prefix

- (NSString *)prefix {
	return @"AS";
}

/*******/

- (NSString *)format:(id)object {
	if ([object isKindOfClass: [AEMQuery class]])
		return [[self class] formatObject: object appData: appData];
	else
		return [AEMObjectRenderer formatObject: object];
}

/*******/

- (ASReferenceRenderer *)property:(OSType)code {
	NSString *name;
	
	name = [self propertyByCode: code];
	if (!name)
		name = [self elementByCode: code];
	if (!name) { // no code->name translation available
		result = nil;
		return nil;
	}
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" %@]", name];
    return self;
}

- (ASReferenceRenderer *)elements:(OSType)code {
	NSString *name;
	
	name = [self elementByCode: code];
	if (!name)
		name = [self propertyByCode: code];
	if (!name) { // no code->name translation available
		result = nil;
		return nil;
	}
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" %@]", name];
    return self;
}


- (ASReferenceRenderer *)first {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" first]"];
    return self;
}

- (ASReferenceRenderer *)middle {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" middle]"];
    return self;
}

- (ASReferenceRenderer *)last {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" last]"];
    return self;
}

- (ASReferenceRenderer *)any {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" any]"];
    return self;
}

// by-index, by-name, by-id selectors

- (ASReferenceRenderer *)byIndex:(id)index {
	[result insertString: @"[" atIndex: 0];
	if ([index isKindOfClass: [NSNumber class]])
		[result appendFormat: @" at: %@]", index];
	else
		[result appendFormat: @" byIndex: %@]", [self format: index]];
    return self;
}

- (ASReferenceRenderer *)byName:(id)name {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" byName: %@]", [self format: name]];
    return self;
}

- (ASReferenceRenderer *)byID:(id)id_ {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" byID: %@]", [self format: id_]];
    return self;
}

// by-relative-position selectors

- (ASReferenceRenderer *)previous:(OSType)class_ {
	NSAppleEventDescriptor *desc = [NSAppleEventDescriptor descriptorWithTypeCode:class_];
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" previous: %@]", [appData unpack: desc]];
    return self;
}

- (ASReferenceRenderer *)next:(OSType)class_ {
	NSAppleEventDescriptor *desc = [NSAppleEventDescriptor descriptorWithTypeCode:class_];
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" next: %@]", [appData unpack: desc]];
    return self;
}

// by-range selector

- (ASReferenceRenderer *)byRange:(id)fromObject to:(id)toObject {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" byRange: %@ to: %@]",
						  [self format: fromObject],
						  [self format: toObject]];
    return self;
}

// by-test selector

- (ASReferenceRenderer *)byTest:(id)testReference {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" byTest: %@]", [self format: testReference]];
    return self;
}

// insertion location selectors

- (ASReferenceRenderer *)beginning {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" beginning]"];
    return self;
}

- (ASReferenceRenderer *)end {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" end]"];
    return self;
}

- (ASReferenceRenderer *)before {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" before]"];
    return self;
}

- (ASReferenceRenderer *)after {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" after]"];
    return self;
}

// test clause renderers

- (ASReferenceRenderer *)greaterThan:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" greaterThan: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)greaterOrEquals:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" greaterOrEquals: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)equals:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" equals: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)notEquals:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" notEquals: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)lessThan:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" lessThan: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)lessOrEquals:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" lessOrEquals: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)beginsWith:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" beginsWith: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)endsWith:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" endsWith: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)contains:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" contains: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)isIn:(id)object {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" isIn: %@]", [self format: object]];
    return self;
}

- (ASReferenceRenderer *)AND:(id)remainingOperands {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" AND: %@]", [self format: remainingOperands]];
    return self;
}

- (ASReferenceRenderer *)OR:(id)remainingOperands {
	[result insertString: @"[" atIndex: 0];
	[result appendFormat: @" OR: %@]", [self format: remainingOperands]];
    return self;
}

- (ASReferenceRenderer *)NOT {
	[result insertString: @"[" atIndex: 0];
	[result appendString: @" NOT]"];
    return self;
}


// reference roots

- (ASReferenceRenderer *)app {
	if (appData) {
		NSError *error;
		id target = [appData targetWithError: &error];
		if (target) {
			AEMTargetType targetType = [target targetType];
			id targetData = [target targetData];
			switch (targetType) {
				case kAEMTargetCurrent:
					[result appendFormat: @"[%@Application application]", [self prefix]];
					return self;
				case kAEMTargetFileURL:
					[result appendFormat: @"[%@Application applicationWithName: %@]", 
											[self prefix], [self format: [targetData path]]];
					return self;
				case kAEMTargetEppcURL:
					[result appendFormat: @"[%@Application applicationWithURL: %@]", 
											[self prefix], [self format: targetData]];
					return self;
				case kAEMTargetPID:
					[result appendFormat: @"[%@Application applicationWithPID: %@]", 
											[self prefix], [self format: targetData]];
					return self;
				case kAEMTargetDescriptor:
					[result appendFormat: @"[%@Application applicationWithDescriptor: %@]", 
											[self prefix], [self format: targetData]];
					return self;
			}
		}
		[result appendFormat: @"<%@Application invalid target (error=%i)>", [self prefix], [error code]];
		return self;
	}
	[result appendFormat: @"%@App", [self prefix]];
	return self;
}

- (ASReferenceRenderer *)con {
	[result appendFormat: @"%@Con", [self prefix]];
    return self;
}

- (ASReferenceRenderer *)its {
	[result appendFormat: @"%@Its", [self prefix]];
    return self;
}

- (ASReferenceRenderer *)customRoot:(id)rootObject {
	[result appendFormat: @"%@CustomRoot(%@)", [self prefix], rootObject];
    return self;
}

@end
