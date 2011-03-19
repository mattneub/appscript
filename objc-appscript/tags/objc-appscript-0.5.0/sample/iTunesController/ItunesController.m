//
//  ItunesController.m
//  itunes-controller
//
//  Created by Hamish Sanderson on 21/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ItunesController.h"


@implementation ItunesController

-(void)awakeFromNib {
	itunes = [[ITApplication alloc] initWithBundleID: @"com.apple.itunes"];
	[self refreshPlaylistsTable];
	[self refreshTracksTable];
	[self updateCurrentTrackInfo];
}

-(void)dealloc {
	[itunes release];
	[super dealloc];
}

-(void)refreshPlaylistsTable {
	NSArray *refs, *names;
	ITReference *playlists;
	PlaylistInfo *info;
	NSMutableArray *infoArray;
	int i;
	
	playlists = [itunes playlists];
	names = [[playlists name] getList];
	refs = [playlists getList];
	
	infoArray = [NSMutableArray array];
	for (i = 0; i < [names count]; i++) {
		info = [[PlaylistInfo alloc] initWithName: [names objectAtIndex: i]
										reference: [refs objectAtIndex: i]];
		[infoArray addObject: info];
		[info release];
	}
	[playlistsController setContent: infoArray];
}

-(void)refreshTracksTable {
	NSArray *names, *artists, *albums;
	ITReference *tracks;
	TrackInfo *info;
	NSMutableArray *infoArray;
	int i;
	
	tracks = [[itunes currentPlaylist] tracks];
	names = [[tracks name] getItem];
	artists = [[tracks artist] getItem];
	albums = [[tracks album] getItem];
	
	infoArray = [NSMutableArray array];
	for (i = 0; i < [names count]; i++) {
		info = [[TrackInfo alloc] initWithName: [names objectAtIndex: i]
										artist: [artists objectAtIndex: i]
										 album: [albums objectAtIndex: i]];
		[infoArray addObject: info];
		[info release];
	}
	[tracksController setContent: infoArray];
}


-(void)updateCurrentTrackInfo {
	ITReference *track;
	TrackInfo *info;
	
	track = [itunes currentTrack];
	info = [[TrackInfo alloc] initWithName: [[track name] getItem]
									artist: [[track artist] getItem]
									 album: [[track album] getItem]];
	[self setCurrentTrackInfo: info];
	[info release];
}


-(void)setCurrentTrackInfo:(TrackInfo *)trackInfo {
	[trackInfo retain];
	[currentTrackInfo release];
	currentTrackInfo = trackInfo;
}

-(TrackInfo *)currentTrackInfo {
	return currentTrackInfo;
}


-(IBAction)playpause:(id)sender {
	[[itunes playpause] send];
	[self refreshPlaylistsTable];
	[self refreshTracksTable];
	[self updateCurrentTrackInfo];
}

-(IBAction)next:(id)sender {
	[[itunes nextTrack] send];
	[self updateCurrentTrackInfo];
}

-(IBAction)previous:(id)sender {
	[[itunes previousTrack] send];
	[self updateCurrentTrackInfo];
}

@end