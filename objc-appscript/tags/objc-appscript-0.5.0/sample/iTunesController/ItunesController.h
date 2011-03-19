//
//  ItunesController.h
//  itunes-controller
//
//  Created by Hamish Sanderson on 21/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ITGlue/ITGlue.h"
#import "PlaylistInfo.h"
#import "TrackInfo.h"


@interface ItunesController : NSObject {
	ITApplication *itunes;
	IBOutlet NSArrayController *playlistsController, *tracksController;
	TrackInfo *currentTrackInfo;
}
-(IBAction)playpause:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)previous:(id)sender;

-(void)refreshPlaylistsTable;
-(void)refreshTracksTable;

-(void)updateCurrentTrackInfo;

-(void)setCurrentTrackInfo:(TrackInfo *)trackInfo;
-(TrackInfo *)currentTrackInfo;

@end
