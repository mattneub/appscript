//
//  TrackInfo.m
//  itunes-controller
//
//  Created by Hamish Sanderson on 05/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TrackInfo.h"


@implementation TrackInfo

- (id)initWithName:(NSString *)name_ artist:(NSString *)artist_ album:(NSString *)album_ {
	self = [super init];
	if (!self) return self;
	name = [name_ retain];
	artist = [artist_ retain];
	album = [album_ retain];
	return self;
}

- (void)dealloc {
	[name release];
	[artist release];
	[album release];
	[super dealloc];
}

- (NSString *)name {
	return name;
}

- (NSString *)artist {
	return artist;
}

- (NSString *)album {
	return album;
}

@end
