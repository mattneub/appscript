//
//  PlaylistInfo.h
//  itunes-controller
//
//  Created by Hamish Sanderson on 05/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ITGlue/ITGlue.h"


@interface PlaylistInfo : NSObject {
	NSString *name;
	ITReference *reference;
}

-(id)initWithName:(NSString *)name reference:(ITReference *)reference;

-(NSString *)name;
-(ITReference *)reference;

@end
