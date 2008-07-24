/*
 * SFAEMConstants.h
 * 
 * /Applications/Safari.app
 * osaglue 0.3.2
 *
 */
#import "Appscript/Appscript.h"

// Type/Enum Names
enum {
	kSFAsk = 'ask ',
	kSFDetailed = 'lwdt',
	kSFNo = 'no  ',
	kSFStandard = 'lwst',
	kSFYes = 'yes ',
	kSFURL = 'pURL',
	kSFApplication = 'capp',
	kSFAttachment = 'atts',
	kSFAttributeRun = 'catr',
	kSFBounds = 'pbnd',
	kSFCharacter = 'cha ',
	kSFClass_ = 'pcls',
	kSFCloseable = 'hclb',
	kSFCollating = 'lwcl',
	kSFColor = 'colr',
	kSFCopies = 'lwcp',
	kSFCurrentTab = 'cTab',
	kSFDocument = 'docu',
	kSFEndingPage = 'lwlp',
	kSFErrorHandling = 'lweh',
	kSFFaxNumber = 'faxn',
	kSFFileName = 'atfn',
	kSFFloating = 'isfl',
	kSFFont = 'font',
	kSFFrontmost = 'pisf',
	kSFId_ = 'ID  ',
	kSFIndex = 'pidx',
	kSFItem = 'cobj',
	kSFMiniaturizable = 'ismn',
	kSFMiniaturized = 'pmnd',
	kSFModal = 'pmod',
	kSFModified = 'imod',
	kSFName = 'pnam',
	kSFPagesAcross = 'lwla',
	kSFPagesDown = 'lwld',
	kSFParagraph = 'cpar',
	kSFPath = 'ppth',
	kSFPrintSettings = 'pset',
	kSFProperties = 'pALL',
	kSFRequestedPrintTime = 'lwqt',
	kSFResizable = 'prsz',
	kSFSize = 'ptsz',
	kSFSource = 'conT',
	kSFStartingPage = 'lwfp',
	kSFTab = 'bTab',
	kSFTargetPrinter = 'trpr',
	kSFText = 'ctxt',
	kSFTitled = 'ptit',
	kSFVersion_ = 'vers',
	kSFVisible = 'pvis',
	kSFWindow = 'cwin',
	kSFWord = 'cwor',
	kSFZoomable = 'iszm',
	kSFZoomed = 'pzum',
};

enum {
	eSFApplications = 'capp',
	eSFAttachment = 'atts',
	eSFAttributeRuns = 'catr',
	eSFCharacters = 'cha ',
	eSFColors = 'colr',
	eSFDocuments = 'docu',
	eSFItems = 'cobj',
	eSFParagraphs = 'cpar',
	eSFPrintSettings = 'pset',
	eSFTabs = 'bTab',
	eSFText = 'ctxt',
	eSFWindows = 'cwin',
	eSFWords = 'cwor',
	pSFURL = 'pURL',
	pSFBounds = 'pbnd',
	pSFClass_ = 'pcls',
	pSFCloseable = 'hclb',
	pSFCollating = 'lwcl',
	pSFColor = 'colr',
	pSFCopies = 'lwcp',
	pSFCurrentTab = 'cTab',
	pSFDocument = 'docu',
	pSFEndingPage = 'lwlp',
	pSFErrorHandling = 'lweh',
	pSFFaxNumber = 'faxn',
	pSFFileName = 'atfn',
	pSFFloating = 'isfl',
	pSFFont = 'font',
	pSFFrontmost = 'pisf',
	pSFId_ = 'ID  ',
	pSFIndex = 'pidx',
	pSFMiniaturizable = 'ismn',
	pSFMiniaturized = 'pmnd',
	pSFModal = 'pmod',
	pSFModified = 'imod',
	pSFName = 'pnam',
	pSFPagesAcross = 'lwla',
	pSFPagesDown = 'lwld',
	pSFPath = 'ppth',
	pSFProperties = 'pALL',
	pSFRequestedPrintTime = 'lwqt',
	pSFResizable = 'prsz',
	pSFSize = 'ptsz',
	pSFSource = 'conT',
	pSFStartingPage = 'lwfp',
	pSFTargetPrinter = 'trpr',
	pSFTitled = 'ptit',
	pSFVersion_ = 'vers',
	pSFVisible = 'pvis',
	pSFZoomable = 'iszm',
	pSFZoomed = 'pzum',
};

enum {
	ecSFActivate = 'misc',
	eiSFActivate = 'actv',
};

enum {
	ecSFClose = 'core',
	eiSFClose = 'clos',
	epSFSaving = 'savo',
	epSFSavingIn = 'kfil',
};

enum {
	ecSFCount = 'core',
	eiSFCount = 'cnte',
	epSFEach = 'kocl',
};

enum {
	ecSFDelete = 'core',
	eiSFDelete = 'delo',
};

enum {
	ecSFDoJavaScript = 'sfri',
	eiSFDoJavaScript = 'dojs',
	epSFIn = 'dcnm',
};

enum {
	ecSFDuplicate = 'core',
	eiSFDuplicate = 'clon',
	epSFTo = 'insh',
	epSFWithProperties = 'prdt',
};

enum {
	ecSFEmailContents = 'sfri',
	eiSFEmailContents = 'mlct',
	epSFOf = 'dcnm',
};

enum {
	ecSFExists = 'core',
	eiSFExists = 'doex',
};

enum {
	ecSFGet = 'core',
	eiSFGet = 'getd',
};

enum {
	ecSFLaunch = 'ascr',
	eiSFLaunch = 'noop',
};

enum {
	ecSFMake = 'core',
	eiSFMake = 'crel',
	epSFAt = 'insh',
	epSFNew_ = 'kocl',
	epSFWithData = 'data',
// 	epSFWithProperties = 'prdt',
};

enum {
	ecSFMove = 'core',
	eiSFMove = 'move',
// 	epSFTo = 'insh',
};

enum {
	ecSFOpen = 'aevt',
	eiSFOpen = 'odoc',
};

enum {
	ecSFOpenLocation = 'GURL',
	eiSFOpenLocation = 'GURL',
	epSFWindow = 'WIND',
};

enum {
	ecSFPrint = 'aevt',
	eiSFPrint = 'pdoc',
	epSFPrintDialog = 'pdlg',
// 	epSFWithProperties = 'prdt',
};

enum {
	ecSFQuit = 'aevt',
	eiSFQuit = 'quit',
// 	epSFSaving = 'savo',
};

enum {
	ecSFReopen = 'aevt',
	eiSFReopen = 'rapp',
};

enum {
	ecSFRun = 'aevt',
	eiSFRun = 'oapp',
};

enum {
	ecSFSave = 'core',
	eiSFSave = 'save',
	epSFAs = 'fltp',
// 	epSFIn = 'kfil',
};

enum {
	ecSFSet = 'core',
	eiSFSet = 'setd',
// 	epSFTo = 'data',
};

enum {
	ecSFShowBookmarks = 'sfri',
	eiSFShowBookmarks = 'opbk',
};

