//
//  PlaylistInfo.m
//  itunes-controller
//
//  Created by Hamish Sanderson on 05/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PlaylistInfo.h"


@implementation PlaylistInfo


-(id)initWithName:(NSString *)name_ reference:(ITReference *)reference_ {
	self = [super init];
	if (!self) return self;
	name = [name_ retain];
	reference = [reference_ retain];
	return self;
}

- (void)dealloc {
	[name release];
	[reference release];
	[super dealloc];
}

-(NSString *)name {
	return name;
}

-(ITReference *)reference {
	return reference;
}

@end
