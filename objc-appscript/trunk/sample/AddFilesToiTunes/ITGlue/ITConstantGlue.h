/*
 * ITConstantGlue.h
 *
 * /Applications/iTunes.app
 * osaglue 0.3.2
 *
 */

#import <Foundation/Foundation.h>


#import "Appscript/Appscript.h"


@interface ITConstant : ASConstant
+ (id)constantWithCode:(OSType)code_;

/* Enumerators */

+ (ITConstant *)Audiobooks;
+ (ITConstant *)MP3CD;
+ (ITConstant *)Movies;
+ (ITConstant *)Music;
+ (ITConstant *)PartyShuffle;
+ (ITConstant *)Podcasts;
+ (ITConstant *)PurchasedMusic;
+ (ITConstant *)TVShow;
+ (ITConstant *)TVShows;
+ (ITConstant *)Videos;
+ (ITConstant *)albumListing;
+ (ITConstant *)albums;
+ (ITConstant *)all;
+ (ITConstant *)artists;
+ (ITConstant *)audioCD;
+ (ITConstant *)cdInsert;
+ (ITConstant *)composers;
+ (ITConstant *)computed;
+ (ITConstant *)detailed;
+ (ITConstant *)device;
+ (ITConstant *)displayed;
+ (ITConstant *)fastForwarding;
+ (ITConstant *)folder;
+ (ITConstant *)iPod;
+ (ITConstant *)large;
+ (ITConstant *)library;
+ (ITConstant *)medium;
+ (ITConstant *)movie;
+ (ITConstant *)musicVideo;
+ (ITConstant *)none;
+ (ITConstant *)off;
+ (ITConstant *)one;
+ (ITConstant *)paused;
+ (ITConstant *)playing;
+ (ITConstant *)radioTuner;
+ (ITConstant *)rewinding;
+ (ITConstant *)sharedLibrary;
+ (ITConstant *)small;
+ (ITConstant *)songs;
+ (ITConstant *)standard;
+ (ITConstant *)stopped;
+ (ITConstant *)trackListing;
+ (ITConstant *)unknown;
+ (ITConstant *)user;

/* Types and properties */

+ (ITConstant *)EQ;
+ (ITConstant *)EQEnabled;
+ (ITConstant *)EQPreset;
+ (ITConstant *)EQWindow;
+ (ITConstant *)URLTrack;
+ (ITConstant *)address;
+ (ITConstant *)album;
+ (ITConstant *)albumArtist;
+ (ITConstant *)albumRating;
+ (ITConstant *)albumRatingKind;
+ (ITConstant *)application;
+ (ITConstant *)artist;
+ (ITConstant *)artwork;
+ (ITConstant *)audioCDPlaylist;
+ (ITConstant *)audioCDTrack;
+ (ITConstant *)band1;
+ (ITConstant *)band10;
+ (ITConstant *)band2;
+ (ITConstant *)band3;
+ (ITConstant *)band4;
+ (ITConstant *)band5;
+ (ITConstant *)band6;
+ (ITConstant *)band7;
+ (ITConstant *)band8;
+ (ITConstant *)band9;
+ (ITConstant *)bitRate;
+ (ITConstant *)bookmark;
+ (ITConstant *)bookmarkable;
+ (ITConstant *)bounds;
+ (ITConstant *)bpm;
+ (ITConstant *)browserWindow;
+ (ITConstant *)capacity;
+ (ITConstant *)category;
+ (ITConstant *)closeable;
+ (ITConstant *)collapseable;
+ (ITConstant *)collapsed;
+ (ITConstant *)collating;
+ (ITConstant *)comment;
+ (ITConstant *)compilation;
+ (ITConstant *)composer;
+ (ITConstant *)container;
+ (ITConstant *)copies;
+ (ITConstant *)currentEQPreset;
+ (ITConstant *)currentEncoder;
+ (ITConstant *)currentPlaylist;
+ (ITConstant *)currentStreamTitle;
+ (ITConstant *)currentStreamURL;
+ (ITConstant *)currentTrack;
+ (ITConstant *)currentVisual;
+ (ITConstant *)data;
+ (ITConstant *)databaseID;
+ (ITConstant *)dateAdded;
+ (ITConstant *)description_;
+ (ITConstant *)devicePlaylist;
+ (ITConstant *)deviceTrack;
+ (ITConstant *)discCount;
+ (ITConstant *)discNumber;
+ (ITConstant *)downloaded;
+ (ITConstant *)duration;
+ (ITConstant *)enabled;
+ (ITConstant *)encoder;
+ (ITConstant *)endingPage;
+ (ITConstant *)episodeID;
+ (ITConstant *)episodeNumber;
+ (ITConstant *)errorHandling;
+ (ITConstant *)faxNumber;
+ (ITConstant *)fileTrack;
+ (ITConstant *)finish;
+ (ITConstant *)fixedIndexing;
+ (ITConstant *)folderPlaylist;
+ (ITConstant *)format;
+ (ITConstant *)freeSpace;
+ (ITConstant *)frontmost;
+ (ITConstant *)fullScreen;
+ (ITConstant *)gapless;
+ (ITConstant *)genre;
+ (ITConstant *)grouping;
+ (ITConstant *)id_;
+ (ITConstant *)index;
+ (ITConstant *)item;
+ (ITConstant *)kind;
+ (ITConstant *)libraryPlaylist;
+ (ITConstant *)location;
+ (ITConstant *)longDescription;
+ (ITConstant *)lyrics;
+ (ITConstant *)minimized;
+ (ITConstant *)modifiable;
+ (ITConstant *)modificationDate;
+ (ITConstant *)mute;
+ (ITConstant *)name;
+ (ITConstant *)pagesAcross;
+ (ITConstant *)pagesDown;
+ (ITConstant *)parent;
+ (ITConstant *)persistentID;
+ (ITConstant *)playedCount;
+ (ITConstant *)playedDate;
+ (ITConstant *)playerPosition;
+ (ITConstant *)playerState;
+ (ITConstant *)playlist;
+ (ITConstant *)playlistWindow;
+ (ITConstant *)podcast;
+ (ITConstant *)position;
+ (ITConstant *)preamp;
+ (ITConstant *)printSettings;
+ (ITConstant *)printerFeatures;
+ (ITConstant *)radioTunerPlaylist;
+ (ITConstant *)rating;
+ (ITConstant *)ratingKind;
+ (ITConstant *)requestedPrintTime;
+ (ITConstant *)resizable;
+ (ITConstant *)sampleRate;
+ (ITConstant *)seasonNumber;
+ (ITConstant *)selection;
+ (ITConstant *)shared;
+ (ITConstant *)sharedTrack;
+ (ITConstant *)show;
+ (ITConstant *)shufflable;
+ (ITConstant *)shuffle;
+ (ITConstant *)size;
+ (ITConstant *)skippedCount;
+ (ITConstant *)skippedDate;
+ (ITConstant *)smart;
+ (ITConstant *)songRepeat;
+ (ITConstant *)sortAlbum;
+ (ITConstant *)sortAlbumArtist;
+ (ITConstant *)sortArtist;
+ (ITConstant *)sortComposer;
+ (ITConstant *)sortName;
+ (ITConstant *)sortShow;
+ (ITConstant *)soundVolume;
+ (ITConstant *)source;
+ (ITConstant *)specialKind;
+ (ITConstant *)start;
+ (ITConstant *)startingPage;
+ (ITConstant *)targetPrinter;
+ (ITConstant *)time;
+ (ITConstant *)track;
+ (ITConstant *)trackCount;
+ (ITConstant *)trackNumber;
+ (ITConstant *)unplayed;
+ (ITConstant *)updateTracks;
+ (ITConstant *)userPlaylist;
+ (ITConstant *)version_;
+ (ITConstant *)videoKind;
+ (ITConstant *)view;
+ (ITConstant *)visible;
+ (ITConstant *)visual;
+ (ITConstant *)visualSize;
+ (ITConstant *)visualsEnabled;
+ (ITConstant *)volumeAdjustment;
+ (ITConstant *)window;
+ (ITConstant *)year;
+ (ITConstant *)zoomable;
+ (ITConstant *)zoomed;
@end


