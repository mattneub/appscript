/*
 * ITAEMConstants.h
 * 
 * /Applications/iTunes.app
 * osaglue 0.3.2
 *
 */
#import "Appscript/Appscript.h"

// Type/Enum Names
enum {
	kITAudiobooks = 'kSpA',
	kITMP3CD = 'kMCD',
	kITMovies = 'kSpI',
	kITMusic = 'kSpZ',
	kITPartyShuffle = 'kSpS',
	kITPodcasts = 'kSpP',
	kITPurchasedMusic = 'kSpM',
	kITTVShow = 'kVdT',
	kITTVShows = 'kSpT',
	kITVideos = 'kSpV',
	kITAlbumListing = 'kAlb',
	kITAlbums = 'kSrL',
	kITAll = 'kRpA',
	kITArtists = 'kSrR',
	kITAudioCD = 'kACD',
	kITCdInsert = 'kCDi',
	kITComposers = 'kSrC',
	kITComputed = 'kRtC',
	kITDetailed = 'lwdt',
	kITDevice = 'kDev',
	kITDisplayed = 'kSrV',
	kITFastForwarding = 'kPSF',
	kITFolder = 'kSpF',
	kITIPod = 'kPod',
	kITLarge = 'kVSL',
	kITLibrary = 'kLib',
	kITMedium = 'kVSM',
	kITMovie = 'kVdM',
	kITMusicVideo = 'kVdV',
	kITNone = 'kSpN',
	kITOff = 'kRpO',
	kITOne = 'kRp1',
	kITPaused = 'kPSp',
	kITPlaying = 'kPSP',
	kITRadioTuner = 'kTun',
	kITRewinding = 'kPSR',
	kITSharedLibrary = 'kShd',
	kITSmall = 'kVSS',
	kITSongs = 'kSrS',
	kITStandard = 'lwst',
	kITStopped = 'kPSS',
	kITTrackListing = 'kTrk',
	kITUnknown = 'kUnk',
	kITUser = 'kRtU',
	kITEQ = 'pEQp',
	kITEQEnabled = 'pEQ ',
	kITEQPreset = 'cEQP',
	kITEQWindow = 'cEQW',
	kITURLTrack = 'cURT',
	kITAddress = 'pURL',
	kITAlbum = 'pAlb',
	kITAlbumArtist = 'pAlA',
	kITAlbumRating = 'pAlR',
	kITAlbumRatingKind = 'pARk',
	kITApplication = 'capp',
	kITArtist = 'pArt',
	kITArtwork = 'cArt',
	kITAudioCDPlaylist = 'cCDP',
	kITAudioCDTrack = 'cCDT',
	kITBand1 = 'pEQ1',
	kITBand10 = 'pEQ0',
	kITBand2 = 'pEQ2',
	kITBand3 = 'pEQ3',
	kITBand4 = 'pEQ4',
	kITBand5 = 'pEQ5',
	kITBand6 = 'pEQ6',
	kITBand7 = 'pEQ7',
	kITBand8 = 'pEQ8',
	kITBand9 = 'pEQ9',
	kITBitRate = 'pBRt',
	kITBookmark = 'pBkt',
	kITBookmarkable = 'pBkm',
	kITBounds = 'pbnd',
	kITBpm = 'pBPM',
	kITBrowserWindow = 'cBrW',
	kITCapacity = 'capa',
	kITCategory = 'pCat',
	kITCloseable = 'hclb',
	kITCollapseable = 'pWSh',
	kITCollapsed = 'wshd',
	kITCollating = 'lwcl',
	kITComment = 'pCmt',
	kITCompilation = 'pAnt',
	kITComposer = 'pCmp',
	kITContainer = 'ctnr',
	kITCopies = 'lwcp',
	kITCurrentEQPreset = 'pEQP',
	kITCurrentEncoder = 'pEnc',
	kITCurrentPlaylist = 'pPla',
	kITCurrentStreamTitle = 'pStT',
	kITCurrentStreamURL = 'pStU',
	kITCurrentTrack = 'pTrk',
	kITCurrentVisual = 'pVis',
	kITData = 'pPCT',
	kITDatabaseID = 'pDID',
	kITDateAdded = 'pAdd',
	kITDescription_ = 'pDes',
	kITDevicePlaylist = 'cDvP',
	kITDeviceTrack = 'cDvT',
	kITDiscCount = 'pDsC',
	kITDiscNumber = 'pDsN',
	kITDownloaded = 'pDlA',
	kITDuration = 'pDur',
	kITEnabled = 'enbl',
	kITEncoder = 'cEnc',
	kITEndingPage = 'lwlp',
	kITEpisodeID = 'pEpD',
	kITEpisodeNumber = 'pEpN',
	kITErrorHandling = 'lweh',
	kITFaxNumber = 'faxn',
	kITFileTrack = 'cFlT',
	kITFinish = 'pStp',
	kITFixedIndexing = 'pFix',
	kITFolderPlaylist = 'cFoP',
	kITFormat = 'pFmt',
	kITFreeSpace = 'frsp',
	kITFrontmost = 'pisf',
	kITFullScreen = 'pFSc',
	kITGapless = 'pGpl',
	kITGenre = 'pGen',
	kITGrouping = 'pGrp',
	kITId_ = 'ID  ',
	kITIndex = 'pidx',
	kITItem = 'cobj',
	kITKind = 'pKnd',
	kITLibraryPlaylist = 'cLiP',
	kITLocation = 'pLoc',
	kITLongDescription = 'pLds',
	kITLyrics = 'pLyr',
	kITMinimized = 'pMin',
	kITModifiable = 'pMod',
	kITModificationDate = 'asmo',
	kITMute = 'pMut',
	kITName = 'pnam',
	kITPagesAcross = 'lwla',
	kITPagesDown = 'lwld',
	kITParent = 'pPlP',
	kITPersistentID = 'pPIS',
	kITPlayedCount = 'pPlC',
	kITPlayedDate = 'pPlD',
	kITPlayerPosition = 'pPos',
	kITPlayerState = 'pPlS',
	kITPlaylist = 'cPly',
	kITPlaylistWindow = 'cPlW',
	kITPodcast = 'pTPc',
	kITPosition = 'ppos',
	kITPreamp = 'pEQA',
	kITPrintSettings = 'pset',
	kITPrinterFeatures = 'lwpf',
	kITRadioTunerPlaylist = 'cRTP',
	kITRating = 'pRte',
	kITRatingKind = 'pRtk',
	kITRequestedPrintTime = 'lwqt',
	kITResizable = 'prsz',
	kITSampleRate = 'pSRt',
	kITSeasonNumber = 'pSeN',
	kITSelection = 'sele',
	kITShared = 'pShr',
	kITSharedTrack = 'cShT',
	kITShow = 'pShw',
	kITShufflable = 'pSfa',
	kITShuffle = 'pShf',
	kITSize = 'pSiz',
	kITSkippedCount = 'pSkC',
	kITSkippedDate = 'pSkD',
	kITSmart = 'pSmt',
	kITSongRepeat = 'pRpt',
	kITSortAlbum = 'pSAl',
	kITSortAlbumArtist = 'pSAA',
	kITSortArtist = 'pSAr',
	kITSortComposer = 'pSCm',
	kITSortName = 'pSNm',
	kITSortShow = 'pSSN',
	kITSoundVolume = 'pVol',
	kITSource = 'cSrc',
	kITSpecialKind = 'pSpK',
	kITStart = 'pStr',
	kITStartingPage = 'lwfp',
	kITTargetPrinter = 'trpr',
	kITTime = 'pTim',
	kITTrack = 'cTrk',
	kITTrackCount = 'pTrC',
	kITTrackNumber = 'pTrN',
	kITUnplayed = 'pUnp',
	kITUpdateTracks = 'pUTC',
	kITUserPlaylist = 'cUsP',
	kITVersion_ = 'vers',
	kITVideoKind = 'pVdK',
	kITView = 'pPly',
	kITVisible = 'pvis',
	kITVisual = 'cVis',
	kITVisualSize = 'pVSz',
	kITVisualsEnabled = 'pVsE',
	kITVolumeAdjustment = 'pAdj',
	kITWindow = 'cwin',
	kITYear = 'pYr ',
	kITZoomable = 'iszm',
	kITZoomed = 'pzum',
};

enum {
	eITEQPresets = 'cEQP',
	eITEQWindows = 'cEQW',
	eITURLTracks = 'cURT',
	eITApplication = 'capp',
	eITArtworks = 'cArt',
	eITAudioCDPlaylists = 'cCDP',
	eITAudioCDTracks = 'cCDT',
	eITBrowserWindows = 'cBrW',
	eITDevicePlaylists = 'cDvP',
	eITDeviceTracks = 'cDvT',
	eITEncoders = 'cEnc',
	eITFileTracks = 'cFlT',
	eITFolderPlaylists = 'cFoP',
	eITItems = 'cobj',
	eITLibraryPlaylists = 'cLiP',
	eITPlaylistWindows = 'cPlW',
	eITPlaylists = 'cPly',
	eITPrintSettings = 'pset',
	eITRadioTunerPlaylists = 'cRTP',
	eITSharedTracks = 'cShT',
	eITSources = 'cSrc',
	eITTracks = 'cTrk',
	eITUserPlaylists = 'cUsP',
	eITVisuals = 'cVis',
	eITWindows = 'cwin',
	pITEQ = 'pEQp',
	pITEQEnabled = 'pEQ ',
	pITAddress = 'pURL',
	pITAlbum = 'pAlb',
	pITAlbumArtist = 'pAlA',
	pITAlbumRating = 'pAlR',
	pITAlbumRatingKind = 'pARk',
	pITArtist = 'pArt',
	pITBand1 = 'pEQ1',
	pITBand10 = 'pEQ0',
	pITBand2 = 'pEQ2',
	pITBand3 = 'pEQ3',
	pITBand4 = 'pEQ4',
	pITBand5 = 'pEQ5',
	pITBand6 = 'pEQ6',
	pITBand7 = 'pEQ7',
	pITBand8 = 'pEQ8',
	pITBand9 = 'pEQ9',
	pITBitRate = 'pBRt',
	pITBookmark = 'pBkt',
	pITBookmarkable = 'pBkm',
	pITBounds = 'pbnd',
	pITBpm = 'pBPM',
	pITCapacity = 'capa',
	pITCategory = 'pCat',
	pITClass_ = 'pcls',
	pITCloseable = 'hclb',
	pITCollapseable = 'pWSh',
	pITCollapsed = 'wshd',
	pITCollating = 'lwcl',
	pITComment = 'pCmt',
	pITCompilation = 'pAnt',
	pITComposer = 'pCmp',
	pITContainer = 'ctnr',
	pITCopies = 'lwcp',
	pITCurrentEQPreset = 'pEQP',
	pITCurrentEncoder = 'pEnc',
	pITCurrentPlaylist = 'pPla',
	pITCurrentStreamTitle = 'pStT',
	pITCurrentStreamURL = 'pStU',
	pITCurrentTrack = 'pTrk',
	pITCurrentVisual = 'pVis',
	pITData = 'pPCT',
	pITDatabaseID = 'pDID',
	pITDateAdded = 'pAdd',
	pITDescription_ = 'pDes',
	pITDiscCount = 'pDsC',
	pITDiscNumber = 'pDsN',
	pITDownloaded = 'pDlA',
	pITDuration = 'pDur',
	pITEnabled = 'enbl',
	pITEndingPage = 'lwlp',
	pITEpisodeID = 'pEpD',
	pITEpisodeNumber = 'pEpN',
	pITErrorHandling = 'lweh',
	pITFaxNumber = 'faxn',
	pITFinish = 'pStp',
	pITFixedIndexing = 'pFix',
	pITFormat = 'pFmt',
	pITFreeSpace = 'frsp',
	pITFrontmost = 'pisf',
	pITFullScreen = 'pFSc',
	pITGapless = 'pGpl',
	pITGenre = 'pGen',
	pITGrouping = 'pGrp',
	pITId_ = 'ID  ',
	pITIndex = 'pidx',
	pITKind = 'pKnd',
	pITLocation = 'pLoc',
	pITLongDescription = 'pLds',
	pITLyrics = 'pLyr',
	pITMinimized = 'pMin',
	pITModifiable = 'pMod',
	pITModificationDate = 'asmo',
	pITMute = 'pMut',
	pITName = 'pnam',
	pITPagesAcross = 'lwla',
	pITPagesDown = 'lwld',
	pITParent = 'pPlP',
	pITPersistentID = 'pPIS',
	pITPlayedCount = 'pPlC',
	pITPlayedDate = 'pPlD',
	pITPlayerPosition = 'pPos',
	pITPlayerState = 'pPlS',
	pITPodcast = 'pTPc',
	pITPosition = 'ppos',
	pITPreamp = 'pEQA',
	pITPrinterFeatures = 'lwpf',
	pITRating = 'pRte',
	pITRatingKind = 'pRtk',
	pITRequestedPrintTime = 'lwqt',
	pITResizable = 'prsz',
	pITSampleRate = 'pSRt',
	pITSeasonNumber = 'pSeN',
	pITSelection = 'sele',
	pITShared = 'pShr',
	pITShow = 'pShw',
	pITShufflable = 'pSfa',
	pITShuffle = 'pShf',
	pITSize = 'pSiz',
	pITSkippedCount = 'pSkC',
	pITSkippedDate = 'pSkD',
	pITSmart = 'pSmt',
	pITSongRepeat = 'pRpt',
	pITSortAlbum = 'pSAl',
	pITSortAlbumArtist = 'pSAA',
	pITSortArtist = 'pSAr',
	pITSortComposer = 'pSCm',
	pITSortName = 'pSNm',
	pITSortShow = 'pSSN',
	pITSoundVolume = 'pVol',
	pITSpecialKind = 'pSpK',
	pITStart = 'pStr',
	pITStartingPage = 'lwfp',
	pITTargetPrinter = 'trpr',
	pITTime = 'pTim',
	pITTrackCount = 'pTrC',
	pITTrackNumber = 'pTrN',
	pITUnplayed = 'pUnp',
	pITUpdateTracks = 'pUTC',
	pITVersion_ = 'vers',
	pITVideoKind = 'pVdK',
	pITView = 'pPly',
	pITVisible = 'pvis',
	pITVisualSize = 'pVSz',
	pITVisualsEnabled = 'pVsE',
	pITVolumeAdjustment = 'pAdj',
	pITYear = 'pYr ',
	pITZoomable = 'iszm',
	pITZoomed = 'pzum',
};

enum {
	ecITActivate = 'misc',
	edITActivate = 'misc',
};

enum {
	ecITAdd = 'hook',
	edITAdd = 'hook',
	epITTo = 'insh',
};

enum {
	ecITBackTrack = 'hook',
	edITBackTrack = 'hook',
};

enum {
	ecITClose = 'core',
	edITClose = 'core',
};

enum {
	ecITConvert = 'hook',
	edITConvert = 'hook',
};

enum {
	ecITCount = 'core',
	edITCount = 'core',
	epITEach = 'kocl',
};

enum {
	ecITDelete = 'core',
	edITDelete = 'core',
};

enum {
	ecITDownload = 'hook',
	edITDownload = 'hook',
};

enum {
	ecITDuplicate = 'core',
	edITDuplicate = 'core',
// 	epITTo = 'insh',
};

enum {
	ecITEject = 'hook',
	edITEject = 'hook',
};

enum {
	ecITExists = 'core',
	edITExists = 'core',
};

enum {
	ecITFastForward = 'hook',
	edITFastForward = 'hook',
};

enum {
	ecITGet = 'core',
	edITGet = 'core',
};

enum {
	ecITLaunch = 'ascr',
	edITLaunch = 'ascr',
};

enum {
	ecITMake = 'core',
	edITMake = 'core',
	epITAt = 'insh',
	epITNew_ = 'kocl',
	epITWithProperties = 'prdt',
};

enum {
	ecITMove = 'core',
	edITMove = 'core',
// 	epITTo = 'insh',
};

enum {
	ecITNextTrack = 'hook',
	edITNextTrack = 'hook',
};

enum {
	ecITOpen = 'aevt',
	edITOpen = 'aevt',
};

enum {
	ecITOpenLocation = 'GURL',
	edITOpenLocation = 'GURL',
};

enum {
	ecITPause = 'hook',
	edITPause = 'hook',
};

enum {
	ecITPlay = 'hook',
	edITPlay = 'hook',
	epITOnce = 'POne',
};

enum {
	ecITPlaypause = 'hook',
	edITPlaypause = 'hook',
};

enum {
	ecITPreviousTrack = 'hook',
	edITPreviousTrack = 'hook',
};

enum {
	ecITPrint = 'aevt',
	edITPrint = 'aevt',
	epITKind = 'pKnd',
	epITPrintDialog = 'pdlg',
	epITTheme = 'pThm',
// 	epITWithProperties = 'prdt',
};

enum {
	ecITQuit = 'aevt',
	edITQuit = 'aevt',
};

enum {
	ecITRefresh = 'hook',
	edITRefresh = 'hook',
};

enum {
	ecITReopen = 'aevt',
	edITReopen = 'aevt',
};

enum {
	ecITResume = 'hook',
	edITResume = 'hook',
};

enum {
	ecITReveal = 'hook',
	edITReveal = 'hook',
};

enum {
	ecITRewind = 'hook',
	edITRewind = 'hook',
};

enum {
	ecITRun = 'aevt',
	edITRun = 'aevt',
};

enum {
	ecITSearch = 'hook',
	edITSearch = 'hook',
	epITFor_ = 'pTrm',
	epITOnly = 'pAre',
};

enum {
	ecITSet = 'core',
	edITSet = 'core',
// 	epITTo = 'data',
};

enum {
	ecITStop = 'hook',
	edITStop = 'hook',
};

enum {
	ecITSubscribe = 'hook',
	edITSubscribe = 'hook',
};

enum {
	ecITUpdate = 'hook',
	edITUpdate = 'hook',
};

enum {
	ecITUpdateAllPodcasts = 'hook',
	edITUpdateAllPodcasts = 'hook',
};

enum {
	ecITUpdatePodcast = 'hook',
	edITUpdatePodcast = 'hook',
};

