//
//  TrackInfo.h
//  itunes-controller
//
//  Created by Hamish Sanderson on 05/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TrackInfo : NSObject {
	NSString *name, *artist, *album;
}

- (id)initWithName:(NSString *)name artist:(NSString *)artist album:(NSString *)album;

- (NSString *)name;
- (NSString *)artist;
- (NSString *)album;

@end
