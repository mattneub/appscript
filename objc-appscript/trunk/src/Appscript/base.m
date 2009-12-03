//
//  base.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "base.h"


/**********************************************************************/
// AEM query base (shared by specifiers and tests)

@implementation AEMQuery

- (id)init {
	self = [super init];
	if (!self) return self;
	cachedDesc = nil;
	cachedHash = 0;
	return self;
}

- (void)dealloc {
	[cachedDesc release];
	[super dealloc];
}


- (NSUInteger)hash {
	if (!cachedHash)
		cachedHash = [[self description] hash];
	return cachedHash;
}


- (void)setCachedDesc:(NSAppleEventDescriptor *)desc {
	@synchronized(self) {
		if (!cachedDesc)
			[cachedDesc release];
		cachedDesc = [desc retain];
	}
}


- (id)resolveWithObject:(id)object { // stub method; subclasses will override this
	return nil;
}

- (NSAppleEventDescriptor *)packWithCodecsNoCache:(id)codecs { // stub method; subclasses will override this
	return nil;
}

- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs {
	@synchronized(self) {
		if (!cachedDesc)
			cachedDesc = [[self packWithCodecsNoCache: codecs] retain];
	}
	return cachedDesc;
}

@end


/**********************************************************************/


@implementation AEMResolver

- (id)property:(OSType)code {
	return self;
}

- (id)elements:(OSType)code {
	return self;
}


- (id)first {
	return self;
}

- (id)middle {
	return self;
}

- (id)last {
	return self;
}

- (id)any {
	return self;
}


- (id)byIndex:(id)index {
	return self;
}

- (id)byName:(id)name {
	return self;
}

- (id)byID:(id)id_ {
	return self;
}


- (id)previous:(OSType)class_ {
	return self;
}

- (id)next:(OSType)class_ {
	return self;
}


- (id)byRange:(id)fromObject to:(id)toObject {
	return self;
}

- (id)byTest:(id)testReference {
	return self;
}


- (id)beginning {
	return self;
}

- (id)end {
	return self;
}

- (id)before {
	return self;
}

- (id)after {
	return self;
}


- (id)greaterThan:(id)object {
	return self;
}

- (id)greaterOrEquals:(id)object {
	return self;
}

- (id)equals:(id)object {
	return self;
}

- (id)notEquals:(id)object {
	return self;
}

- (id)lessThan:(id)object {
	return self;
}

- (id)lessOrEquals:(id)object {
	return self;
}

- (id)beginsWith:(id)object {
	return self;
}

- (id)endsWith:(id)object {
	return self;
}

- (id)contains:(id)object {
	return self;
}

- (id)isIn:(id)object {
	return self;
}

- (id)AND:(id)remainingOperands {
	return self;
}

- (id)OR:(id)remainingOperands {
	return self;
}

- (id)NOT {
	return self;
}


- (id)app {
	return self;
}

- (id)con {
	return self;
}

- (id)its {
	return self;
}

- (id)customRoot:(id)rootObject {
	return self;
}

@end

