/*
 * ITConstantGlue.m
 *
 * /Applications/iTunes.app
 * osaglue 0.3.2
 *
 */

#import "ITConstantGlue.h"

@implementation ITConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'kSpA': return [self Audiobooks];
        case 'pEQp': return [self EQ];
        case 'pEQ ': return [self EQEnabled];
        case 'cEQP': return [self EQPreset];
        case 'cEQW': return [self EQWindow];
        case 'kMCD': return [self MP3CD];
        case 'kSpI': return [self Movies];
        case 'kSpZ': return [self Music];
        case 'kSpS': return [self PartyShuffle];
        case 'kSpP': return [self Podcasts];
        case 'kSpM': return [self PurchasedMusic];
        case 'kVdT': return [self TVShow];
        case 'kSpT': return [self TVShows];
        case 'cURT': return [self URLTrack];
        case 'kSpV': return [self Videos];
        case 'pURL': return [self address];
        case 'pAlb': return [self album];
        case 'pAlA': return [self albumArtist];
        case 'kAlb': return [self albumListing];
        case 'pAlR': return [self albumRating];
        case 'pARk': return [self albumRatingKind];
        case 'kSrL': return [self albums];
        case 'kRpA': return [self all];
        case 'kSrA': return [self all];
        case 'capp': return [self application];
        case 'pArt': return [self artist];
        case 'kSrR': return [self artists];
        case 'cArt': return [self artwork];
        case 'kACD': return [self audioCD];
        case 'cCDP': return [self audioCDPlaylist];
        case 'cCDT': return [self audioCDTrack];
        case 'pEQ1': return [self band1];
        case 'pEQ0': return [self band10];
        case 'pEQ2': return [self band2];
        case 'pEQ3': return [self band3];
        case 'pEQ4': return [self band4];
        case 'pEQ5': return [self band5];
        case 'pEQ6': return [self band6];
        case 'pEQ7': return [self band7];
        case 'pEQ8': return [self band8];
        case 'pEQ9': return [self band9];
        case 'pBRt': return [self bitRate];
        case 'pBkt': return [self bookmark];
        case 'pBkm': return [self bookmarkable];
        case 'pbnd': return [self bounds];
        case 'pBPM': return [self bpm];
        case 'cBrW': return [self browserWindow];
        case 'capa': return [self capacity];
        case 'pCat': return [self category];
        case 'kCDi': return [self cdInsert];
        case 'hclb': return [self closeable];
        case 'pWSh': return [self collapseable];
        case 'wshd': return [self collapsed];
        case 'lwcl': return [self collating];
        case 'pCmt': return [self comment];
        case 'pAnt': return [self compilation];
        case 'pCmp': return [self composer];
        case 'kSrC': return [self composers];
        case 'kRtC': return [self computed];
        case 'ctnr': return [self container];
        case 'lwcp': return [self copies];
        case 'pEQP': return [self currentEQPreset];
        case 'pEnc': return [self currentEncoder];
        case 'pPla': return [self currentPlaylist];
        case 'pStT': return [self currentStreamTitle];
        case 'pStU': return [self currentStreamURL];
        case 'pTrk': return [self currentTrack];
        case 'pVis': return [self currentVisual];
        case 'pPCT': return [self data];
        case 'pDID': return [self databaseID];
        case 'pAdd': return [self dateAdded];
        case 'pDes': return [self description_];
        case 'lwdt': return [self detailed];
        case 'kDev': return [self device];
        case 'cDvP': return [self devicePlaylist];
        case 'cDvT': return [self deviceTrack];
        case 'pDsC': return [self discCount];
        case 'pDsN': return [self discNumber];
        case 'kSrV': return [self displayed];
        case 'pDlA': return [self downloaded];
        case 'pDur': return [self duration];
        case 'enbl': return [self enabled];
        case 'cEnc': return [self encoder];
        case 'lwlp': return [self endingPage];
        case 'pEpD': return [self episodeID];
        case 'pEpN': return [self episodeNumber];
        case 'lweh': return [self errorHandling];
        case 'kPSF': return [self fastForwarding];
        case 'faxn': return [self faxNumber];
        case 'cFlT': return [self fileTrack];
        case 'pStp': return [self finish];
        case 'pFix': return [self fixedIndexing];
        case 'kSpF': return [self folder];
        case 'cFoP': return [self folderPlaylist];
        case 'pFmt': return [self format];
        case 'frsp': return [self freeSpace];
        case 'pisf': return [self frontmost];
        case 'pFSc': return [self fullScreen];
        case 'pGpl': return [self gapless];
        case 'pGen': return [self genre];
        case 'pGrp': return [self grouping];
        case 'kPod': return [self iPod];
        case 'ID  ': return [self id_];
        case 'pidx': return [self index];
        case 'cobj': return [self item];
        case 'pKnd': return [self kind];
        case 'kVSL': return [self large];
        case 'kLib': return [self library];
        case 'cLiP': return [self libraryPlaylist];
        case 'pLoc': return [self location];
        case 'pLds': return [self longDescription];
        case 'pLyr': return [self lyrics];
        case 'kVSM': return [self medium];
        case 'pMin': return [self minimized];
        case 'pMod': return [self modifiable];
        case 'asmo': return [self modificationDate];
        case 'kVdM': return [self movie];
        case 'kVdV': return [self musicVideo];
        case 'pMut': return [self mute];
        case 'pnam': return [self name];
        case 'kSpN': return [self none];
        case 'kVdN': return [self none];
        case 'kRpO': return [self off];
        case 'kRp1': return [self one];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'pPlP': return [self parent];
        case 'kPSp': return [self paused];
        case 'pPIS': return [self persistentID];
        case 'pPlC': return [self playedCount];
        case 'pPlD': return [self playedDate];
        case 'pPos': return [self playerPosition];
        case 'pPlS': return [self playerState];
        case 'kPSP': return [self playing];
        case 'cPly': return [self playlist];
        case 'cPlW': return [self playlistWindow];
        case 'pTPc': return [self podcast];
        case 'ppos': return [self position];
        case 'pEQA': return [self preamp];
        case 'pset': return [self printSettings];
        case 'lwpf': return [self printerFeatures];
        case 'kTun': return [self radioTuner];
        case 'cRTP': return [self radioTunerPlaylist];
        case 'pRte': return [self rating];
        case 'pRtk': return [self ratingKind];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'kPSR': return [self rewinding];
        case 'pSRt': return [self sampleRate];
        case 'pSeN': return [self seasonNumber];
        case 'sele': return [self selection];
        case 'pShr': return [self shared];
        case 'kShd': return [self sharedLibrary];
        case 'cShT': return [self sharedTrack];
        case 'pShw': return [self show];
        case 'pSfa': return [self shufflable];
        case 'pShf': return [self shuffle];
        case 'pSiz': return [self size];
        case 'pSkC': return [self skippedCount];
        case 'pSkD': return [self skippedDate];
        case 'kVSS': return [self small];
        case 'pSmt': return [self smart];
        case 'pRpt': return [self songRepeat];
        case 'kSrS': return [self songs];
        case 'pSAl': return [self sortAlbum];
        case 'pSAA': return [self sortAlbumArtist];
        case 'pSAr': return [self sortArtist];
        case 'pSCm': return [self sortComposer];
        case 'pSNm': return [self sortName];
        case 'pSSN': return [self sortShow];
        case 'pVol': return [self soundVolume];
        case 'cSrc': return [self source];
        case 'pSpK': return [self specialKind];
        case 'lwst': return [self standard];
        case 'pStr': return [self start];
        case 'lwfp': return [self startingPage];
        case 'kPSS': return [self stopped];
        case 'trpr': return [self targetPrinter];
        case 'pTim': return [self time];
        case 'cTrk': return [self track];
        case 'pTrC': return [self trackCount];
        case 'kTrk': return [self trackListing];
        case 'pTrN': return [self trackNumber];
        case 'kUnk': return [self unknown];
        case 'pUnp': return [self unplayed];
        case 'pUTC': return [self updateTracks];
        case 'kRtU': return [self user];
        case 'cUsP': return [self userPlaylist];
        case 'vers': return [self version_];
        case 'pVdK': return [self videoKind];
        case 'pPly': return [self view];
        case 'pvis': return [self visible];
        case 'cVis': return [self visual];
        case 'pVSz': return [self visualSize];
        case 'pVsE': return [self visualsEnabled];
        case 'pAdj': return [self volumeAdjustment];
        case 'cwin': return [self window];
        case 'pYr ': return [self year];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (ITConstant *)Audiobooks {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"Audiobooks" type: typeEnumerated code: 'kSpA'];
    return constantObj;
}

+ (ITConstant *)MP3CD {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"MP3CD" type: typeEnumerated code: 'kMCD'];
    return constantObj;
}

+ (ITConstant *)Movies {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"Movies" type: typeEnumerated code: 'kSpI'];
    return constantObj;
}

+ (ITConstant *)Music {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"Music" type: typeEnumerated code: 'kSpZ'];
    return constantObj;
}

+ (ITConstant *)PartyShuffle {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"PartyShuffle" type: typeEnumerated code: 'kSpS'];
    return constantObj;
}

+ (ITConstant *)Podcasts {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"Podcasts" type: typeEnumerated code: 'kSpP'];
    return constantObj;
}

+ (ITConstant *)PurchasedMusic {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"PurchasedMusic" type: typeEnumerated code: 'kSpM'];
    return constantObj;
}

+ (ITConstant *)TVShow {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"TVShow" type: typeEnumerated code: 'kVdT'];
    return constantObj;
}

+ (ITConstant *)TVShows {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"TVShows" type: typeEnumerated code: 'kSpT'];
    return constantObj;
}

+ (ITConstant *)Videos {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"Videos" type: typeEnumerated code: 'kSpV'];
    return constantObj;
}

+ (ITConstant *)albumListing {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"albumListing" type: typeEnumerated code: 'kAlb'];
    return constantObj;
}

+ (ITConstant *)albums {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"albums" type: typeEnumerated code: 'kSrL'];
    return constantObj;
}

+ (ITConstant *)all {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"all" type: typeEnumerated code: 'kRpA'];
    return constantObj;
}

+ (ITConstant *)artists {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"artists" type: typeEnumerated code: 'kSrR'];
    return constantObj;
}

+ (ITConstant *)audioCD {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"audioCD" type: typeEnumerated code: 'kACD'];
    return constantObj;
}

+ (ITConstant *)cdInsert {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"cdInsert" type: typeEnumerated code: 'kCDi'];
    return constantObj;
}

+ (ITConstant *)composers {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"composers" type: typeEnumerated code: 'kSrC'];
    return constantObj;
}

+ (ITConstant *)computed {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"computed" type: typeEnumerated code: 'kRtC'];
    return constantObj;
}

+ (ITConstant *)detailed {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (ITConstant *)device {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"device" type: typeEnumerated code: 'kDev'];
    return constantObj;
}

+ (ITConstant *)displayed {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"displayed" type: typeEnumerated code: 'kSrV'];
    return constantObj;
}

+ (ITConstant *)fastForwarding {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"fastForwarding" type: typeEnumerated code: 'kPSF'];
    return constantObj;
}

+ (ITConstant *)folder {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"folder" type: typeEnumerated code: 'kSpF'];
    return constantObj;
}

+ (ITConstant *)iPod {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"iPod" type: typeEnumerated code: 'kPod'];
    return constantObj;
}

+ (ITConstant *)large {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"large" type: typeEnumerated code: 'kVSL'];
    return constantObj;
}

+ (ITConstant *)library {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"library" type: typeEnumerated code: 'kLib'];
    return constantObj;
}

+ (ITConstant *)medium {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"medium" type: typeEnumerated code: 'kVSM'];
    return constantObj;
}

+ (ITConstant *)movie {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"movie" type: typeEnumerated code: 'kVdM'];
    return constantObj;
}

+ (ITConstant *)musicVideo {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"musicVideo" type: typeEnumerated code: 'kVdV'];
    return constantObj;
}

+ (ITConstant *)none {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"none" type: typeEnumerated code: 'kSpN'];
    return constantObj;
}

+ (ITConstant *)off {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"off" type: typeEnumerated code: 'kRpO'];
    return constantObj;
}

+ (ITConstant *)one {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"one" type: typeEnumerated code: 'kRp1'];
    return constantObj;
}

+ (ITConstant *)paused {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"paused" type: typeEnumerated code: 'kPSp'];
    return constantObj;
}

+ (ITConstant *)playing {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playing" type: typeEnumerated code: 'kPSP'];
    return constantObj;
}

+ (ITConstant *)radioTuner {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"radioTuner" type: typeEnumerated code: 'kTun'];
    return constantObj;
}

+ (ITConstant *)rewinding {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"rewinding" type: typeEnumerated code: 'kPSR'];
    return constantObj;
}

+ (ITConstant *)sharedLibrary {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sharedLibrary" type: typeEnumerated code: 'kShd'];
    return constantObj;
}

+ (ITConstant *)small {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"small" type: typeEnumerated code: 'kVSS'];
    return constantObj;
}

+ (ITConstant *)songs {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"songs" type: typeEnumerated code: 'kSrS'];
    return constantObj;
}

+ (ITConstant *)standard {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (ITConstant *)stopped {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"stopped" type: typeEnumerated code: 'kPSS'];
    return constantObj;
}

+ (ITConstant *)trackListing {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"trackListing" type: typeEnumerated code: 'kTrk'];
    return constantObj;
}

+ (ITConstant *)unknown {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"unknown" type: typeEnumerated code: 'kUnk'];
    return constantObj;
}

+ (ITConstant *)user {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"user" type: typeEnumerated code: 'kRtU'];
    return constantObj;
}


/* Types and properties */

+ (ITConstant *)EQ {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"EQ" type: typeType code: 'pEQp'];
    return constantObj;
}

+ (ITConstant *)EQEnabled {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"EQEnabled" type: typeType code: 'pEQ '];
    return constantObj;
}

+ (ITConstant *)EQPreset {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"EQPreset" type: typeType code: 'cEQP'];
    return constantObj;
}

+ (ITConstant *)EQWindow {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"EQWindow" type: typeType code: 'cEQW'];
    return constantObj;
}

+ (ITConstant *)URLTrack {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"URLTrack" type: typeType code: 'cURT'];
    return constantObj;
}

+ (ITConstant *)address {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"address" type: typeType code: 'pURL'];
    return constantObj;
}

+ (ITConstant *)album {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"album" type: typeType code: 'pAlb'];
    return constantObj;
}

+ (ITConstant *)albumArtist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"albumArtist" type: typeType code: 'pAlA'];
    return constantObj;
}

+ (ITConstant *)albumRating {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"albumRating" type: typeType code: 'pAlR'];
    return constantObj;
}

+ (ITConstant *)albumRatingKind {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"albumRatingKind" type: typeType code: 'pARk'];
    return constantObj;
}

+ (ITConstant *)application {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (ITConstant *)artist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"artist" type: typeType code: 'pArt'];
    return constantObj;
}

+ (ITConstant *)artwork {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"artwork" type: typeType code: 'cArt'];
    return constantObj;
}

+ (ITConstant *)audioCDPlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"audioCDPlaylist" type: typeType code: 'cCDP'];
    return constantObj;
}

+ (ITConstant *)audioCDTrack {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"audioCDTrack" type: typeType code: 'cCDT'];
    return constantObj;
}

+ (ITConstant *)band1 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band1" type: typeType code: 'pEQ1'];
    return constantObj;
}

+ (ITConstant *)band10 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band10" type: typeType code: 'pEQ0'];
    return constantObj;
}

+ (ITConstant *)band2 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band2" type: typeType code: 'pEQ2'];
    return constantObj;
}

+ (ITConstant *)band3 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band3" type: typeType code: 'pEQ3'];
    return constantObj;
}

+ (ITConstant *)band4 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band4" type: typeType code: 'pEQ4'];
    return constantObj;
}

+ (ITConstant *)band5 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band5" type: typeType code: 'pEQ5'];
    return constantObj;
}

+ (ITConstant *)band6 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band6" type: typeType code: 'pEQ6'];
    return constantObj;
}

+ (ITConstant *)band7 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band7" type: typeType code: 'pEQ7'];
    return constantObj;
}

+ (ITConstant *)band8 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band8" type: typeType code: 'pEQ8'];
    return constantObj;
}

+ (ITConstant *)band9 {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"band9" type: typeType code: 'pEQ9'];
    return constantObj;
}

+ (ITConstant *)bitRate {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"bitRate" type: typeType code: 'pBRt'];
    return constantObj;
}

+ (ITConstant *)bookmark {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"bookmark" type: typeType code: 'pBkt'];
    return constantObj;
}

+ (ITConstant *)bookmarkable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"bookmarkable" type: typeType code: 'pBkm'];
    return constantObj;
}

+ (ITConstant *)bounds {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (ITConstant *)bpm {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"bpm" type: typeType code: 'pBPM'];
    return constantObj;
}

+ (ITConstant *)browserWindow {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"browserWindow" type: typeType code: 'cBrW'];
    return constantObj;
}

+ (ITConstant *)capacity {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"capacity" type: typeType code: 'capa'];
    return constantObj;
}

+ (ITConstant *)category {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"category" type: typeType code: 'pCat'];
    return constantObj;
}

+ (ITConstant *)closeable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (ITConstant *)collapseable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"collapseable" type: typeType code: 'pWSh'];
    return constantObj;
}

+ (ITConstant *)collapsed {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"collapsed" type: typeType code: 'wshd'];
    return constantObj;
}

+ (ITConstant *)collating {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (ITConstant *)comment {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"comment" type: typeType code: 'pCmt'];
    return constantObj;
}

+ (ITConstant *)compilation {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"compilation" type: typeType code: 'pAnt'];
    return constantObj;
}

+ (ITConstant *)composer {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"composer" type: typeType code: 'pCmp'];
    return constantObj;
}

+ (ITConstant *)container {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"container" type: typeType code: 'ctnr'];
    return constantObj;
}

+ (ITConstant *)copies {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (ITConstant *)currentEQPreset {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentEQPreset" type: typeType code: 'pEQP'];
    return constantObj;
}

+ (ITConstant *)currentEncoder {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentEncoder" type: typeType code: 'pEnc'];
    return constantObj;
}

+ (ITConstant *)currentPlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentPlaylist" type: typeType code: 'pPla'];
    return constantObj;
}

+ (ITConstant *)currentStreamTitle {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentStreamTitle" type: typeType code: 'pStT'];
    return constantObj;
}

+ (ITConstant *)currentStreamURL {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentStreamURL" type: typeType code: 'pStU'];
    return constantObj;
}

+ (ITConstant *)currentTrack {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentTrack" type: typeType code: 'pTrk'];
    return constantObj;
}

+ (ITConstant *)currentVisual {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"currentVisual" type: typeType code: 'pVis'];
    return constantObj;
}

+ (ITConstant *)data {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"data" type: typeType code: 'pPCT'];
    return constantObj;
}

+ (ITConstant *)databaseID {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"databaseID" type: typeType code: 'pDID'];
    return constantObj;
}

+ (ITConstant *)dateAdded {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"dateAdded" type: typeType code: 'pAdd'];
    return constantObj;
}

+ (ITConstant *)description_ {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"description_" type: typeType code: 'pDes'];
    return constantObj;
}

+ (ITConstant *)devicePlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"devicePlaylist" type: typeType code: 'cDvP'];
    return constantObj;
}

+ (ITConstant *)deviceTrack {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"deviceTrack" type: typeType code: 'cDvT'];
    return constantObj;
}

+ (ITConstant *)discCount {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"discCount" type: typeType code: 'pDsC'];
    return constantObj;
}

+ (ITConstant *)discNumber {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"discNumber" type: typeType code: 'pDsN'];
    return constantObj;
}

+ (ITConstant *)downloaded {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"downloaded" type: typeType code: 'pDlA'];
    return constantObj;
}

+ (ITConstant *)duration {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"duration" type: typeType code: 'pDur'];
    return constantObj;
}

+ (ITConstant *)enabled {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"enabled" type: typeType code: 'enbl'];
    return constantObj;
}

+ (ITConstant *)encoder {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"encoder" type: typeType code: 'cEnc'];
    return constantObj;
}

+ (ITConstant *)endingPage {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (ITConstant *)episodeID {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"episodeID" type: typeType code: 'pEpD'];
    return constantObj;
}

+ (ITConstant *)episodeNumber {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"episodeNumber" type: typeType code: 'pEpN'];
    return constantObj;
}

+ (ITConstant *)errorHandling {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (ITConstant *)faxNumber {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (ITConstant *)fileTrack {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"fileTrack" type: typeType code: 'cFlT'];
    return constantObj;
}

+ (ITConstant *)finish {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"finish" type: typeType code: 'pStp'];
    return constantObj;
}

+ (ITConstant *)fixedIndexing {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"fixedIndexing" type: typeType code: 'pFix'];
    return constantObj;
}

+ (ITConstant *)folderPlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"folderPlaylist" type: typeType code: 'cFoP'];
    return constantObj;
}

+ (ITConstant *)format {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"format" type: typeType code: 'pFmt'];
    return constantObj;
}

+ (ITConstant *)freeSpace {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"freeSpace" type: typeType code: 'frsp'];
    return constantObj;
}

+ (ITConstant *)frontmost {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (ITConstant *)fullScreen {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"fullScreen" type: typeType code: 'pFSc'];
    return constantObj;
}

+ (ITConstant *)gapless {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"gapless" type: typeType code: 'pGpl'];
    return constantObj;
}

+ (ITConstant *)genre {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"genre" type: typeType code: 'pGen'];
    return constantObj;
}

+ (ITConstant *)grouping {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"grouping" type: typeType code: 'pGrp'];
    return constantObj;
}

+ (ITConstant *)id_ {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (ITConstant *)index {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (ITConstant *)item {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (ITConstant *)kind {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"kind" type: typeType code: 'pKnd'];
    return constantObj;
}

+ (ITConstant *)libraryPlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"libraryPlaylist" type: typeType code: 'cLiP'];
    return constantObj;
}

+ (ITConstant *)location {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"location" type: typeType code: 'pLoc'];
    return constantObj;
}

+ (ITConstant *)longDescription {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"longDescription" type: typeType code: 'pLds'];
    return constantObj;
}

+ (ITConstant *)lyrics {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"lyrics" type: typeType code: 'pLyr'];
    return constantObj;
}

+ (ITConstant *)minimized {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"minimized" type: typeType code: 'pMin'];
    return constantObj;
}

+ (ITConstant *)modifiable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"modifiable" type: typeType code: 'pMod'];
    return constantObj;
}

+ (ITConstant *)modificationDate {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"modificationDate" type: typeType code: 'asmo'];
    return constantObj;
}

+ (ITConstant *)mute {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"mute" type: typeType code: 'pMut'];
    return constantObj;
}

+ (ITConstant *)name {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (ITConstant *)pagesAcross {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (ITConstant *)pagesDown {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (ITConstant *)parent {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"parent" type: typeType code: 'pPlP'];
    return constantObj;
}

+ (ITConstant *)persistentID {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"persistentID" type: typeType code: 'pPIS'];
    return constantObj;
}

+ (ITConstant *)playedCount {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playedCount" type: typeType code: 'pPlC'];
    return constantObj;
}

+ (ITConstant *)playedDate {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playedDate" type: typeType code: 'pPlD'];
    return constantObj;
}

+ (ITConstant *)playerPosition {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playerPosition" type: typeType code: 'pPos'];
    return constantObj;
}

+ (ITConstant *)playerState {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playerState" type: typeType code: 'pPlS'];
    return constantObj;
}

+ (ITConstant *)playlist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playlist" type: typeType code: 'cPly'];
    return constantObj;
}

+ (ITConstant *)playlistWindow {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"playlistWindow" type: typeType code: 'cPlW'];
    return constantObj;
}

+ (ITConstant *)podcast {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"podcast" type: typeType code: 'pTPc'];
    return constantObj;
}

+ (ITConstant *)position {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"position" type: typeType code: 'ppos'];
    return constantObj;
}

+ (ITConstant *)preamp {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"preamp" type: typeType code: 'pEQA'];
    return constantObj;
}

+ (ITConstant *)printSettings {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (ITConstant *)printerFeatures {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"printerFeatures" type: typeType code: 'lwpf'];
    return constantObj;
}

+ (ITConstant *)radioTunerPlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"radioTunerPlaylist" type: typeType code: 'cRTP'];
    return constantObj;
}

+ (ITConstant *)rating {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"rating" type: typeType code: 'pRte'];
    return constantObj;
}

+ (ITConstant *)ratingKind {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"ratingKind" type: typeType code: 'pRtk'];
    return constantObj;
}

+ (ITConstant *)requestedPrintTime {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (ITConstant *)resizable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (ITConstant *)sampleRate {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sampleRate" type: typeType code: 'pSRt'];
    return constantObj;
}

+ (ITConstant *)seasonNumber {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"seasonNumber" type: typeType code: 'pSeN'];
    return constantObj;
}

+ (ITConstant *)selection {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"selection" type: typeType code: 'sele'];
    return constantObj;
}

+ (ITConstant *)shared {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"shared" type: typeType code: 'pShr'];
    return constantObj;
}

+ (ITConstant *)sharedTrack {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sharedTrack" type: typeType code: 'cShT'];
    return constantObj;
}

+ (ITConstant *)show {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"show" type: typeType code: 'pShw'];
    return constantObj;
}

+ (ITConstant *)shufflable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"shufflable" type: typeType code: 'pSfa'];
    return constantObj;
}

+ (ITConstant *)shuffle {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"shuffle" type: typeType code: 'pShf'];
    return constantObj;
}

+ (ITConstant *)size {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"size" type: typeType code: 'pSiz'];
    return constantObj;
}

+ (ITConstant *)skippedCount {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"skippedCount" type: typeType code: 'pSkC'];
    return constantObj;
}

+ (ITConstant *)skippedDate {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"skippedDate" type: typeType code: 'pSkD'];
    return constantObj;
}

+ (ITConstant *)smart {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"smart" type: typeType code: 'pSmt'];
    return constantObj;
}

+ (ITConstant *)songRepeat {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"songRepeat" type: typeType code: 'pRpt'];
    return constantObj;
}

+ (ITConstant *)sortAlbum {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sortAlbum" type: typeType code: 'pSAl'];
    return constantObj;
}

+ (ITConstant *)sortAlbumArtist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sortAlbumArtist" type: typeType code: 'pSAA'];
    return constantObj;
}

+ (ITConstant *)sortArtist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sortArtist" type: typeType code: 'pSAr'];
    return constantObj;
}

+ (ITConstant *)sortComposer {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sortComposer" type: typeType code: 'pSCm'];
    return constantObj;
}

+ (ITConstant *)sortName {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sortName" type: typeType code: 'pSNm'];
    return constantObj;
}

+ (ITConstant *)sortShow {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"sortShow" type: typeType code: 'pSSN'];
    return constantObj;
}

+ (ITConstant *)soundVolume {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"soundVolume" type: typeType code: 'pVol'];
    return constantObj;
}

+ (ITConstant *)source {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"source" type: typeType code: 'cSrc'];
    return constantObj;
}

+ (ITConstant *)specialKind {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"specialKind" type: typeType code: 'pSpK'];
    return constantObj;
}

+ (ITConstant *)start {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"start" type: typeType code: 'pStr'];
    return constantObj;
}

+ (ITConstant *)startingPage {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (ITConstant *)targetPrinter {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (ITConstant *)time {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"time" type: typeType code: 'pTim'];
    return constantObj;
}

+ (ITConstant *)track {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"track" type: typeType code: 'cTrk'];
    return constantObj;
}

+ (ITConstant *)trackCount {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"trackCount" type: typeType code: 'pTrC'];
    return constantObj;
}

+ (ITConstant *)trackNumber {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"trackNumber" type: typeType code: 'pTrN'];
    return constantObj;
}

+ (ITConstant *)unplayed {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"unplayed" type: typeType code: 'pUnp'];
    return constantObj;
}

+ (ITConstant *)updateTracks {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"updateTracks" type: typeType code: 'pUTC'];
    return constantObj;
}

+ (ITConstant *)userPlaylist {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"userPlaylist" type: typeType code: 'cUsP'];
    return constantObj;
}

+ (ITConstant *)version_ {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (ITConstant *)videoKind {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"videoKind" type: typeType code: 'pVdK'];
    return constantObj;
}

+ (ITConstant *)view {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"view" type: typeType code: 'pPly'];
    return constantObj;
}

+ (ITConstant *)visible {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (ITConstant *)visual {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"visual" type: typeType code: 'cVis'];
    return constantObj;
}

+ (ITConstant *)visualSize {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"visualSize" type: typeType code: 'pVSz'];
    return constantObj;
}

+ (ITConstant *)visualsEnabled {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"visualsEnabled" type: typeType code: 'pVsE'];
    return constantObj;
}

+ (ITConstant *)volumeAdjustment {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"volumeAdjustment" type: typeType code: 'pAdj'];
    return constantObj;
}

+ (ITConstant *)window {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (ITConstant *)year {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"year" type: typeType code: 'pYr '];
    return constantObj;
}

+ (ITConstant *)zoomable {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (ITConstant *)zoomed {
    static ITConstant *constantObj;
    if (!constantObj)
        constantObj = [ITConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end


