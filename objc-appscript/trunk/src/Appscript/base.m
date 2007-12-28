//
//  base.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "base.h"


/**********************************************************************/
// AEM reference base (shared by specifiers and tests)

@implementation AEMQuery

/*
 * TO DO:
 *	- (unsigned)hash;
 *	- (BOOL)isEqual:(id)object;
 *	- (NSArray *)comparableData;
 */

- (id)init {
	self = [super init];
	if (!self) return self;
	cachedDesc = nil;
	return self;
}

- (void)dealloc {
	[cachedDesc release];
	[super dealloc];
}


- (void)setDesc:(NSAppleEventDescriptor *)desc {
	if (!cachedDesc)
		[cachedDesc release];
	cachedDesc = [desc retain];
}


- (NSAppleEventDescriptor *)packSelf:(id)codecs { // stub method; subclasses will override this
	return nil;
}


- (id)resolve:(id)object { // stub method; subclasses will override this
	return nil;
}
 
@end


/**********************************************************************/


@implementation AEMResolver

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

