/*
 * SFAEMConstants.h
 * /Applications/Safari.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"

/* Types, enumerators, properties */

enum {
    kSFApplicationResponses = 'rmte',
    kSFAsk = 'ask ',
    kSFCase_ = 'case',
    kSFDetailed = 'lwdt',
    kSFDiacriticals = 'diac',
    kSFExpansion = 'expa',
    kSFHyphens = 'hyph',
    kSFNo = 'no  ',
    kSFNumericStrings = 'nume',
    kSFPunctuation = 'punc',
    kSFStandard = 'lwst',
    kSFWhitespace = 'whit',
    kSFYes = 'yes ',
    kSFApril = 'apr ',
    kSFAugust = 'aug ',
    kSFDecember = 'dec ',
    kSFEPSPicture = 'EPS ',
    kSFFebruary = 'feb ',
    kSFFriday = 'fri ',
    kSFGIFPicture = 'GIFf',
    kSFJPEGPicture = 'JPEG',
    kSFJanuary = 'jan ',
    kSFJuly = 'jul ',
    kSFJune = 'jun ',
    kSFMarch = 'mar ',
    kSFMay = 'may ',
    kSFMonday = 'mon ',
    kSFNovember = 'nov ',
    kSFOctober = 'oct ',
    kSFPICTPicture = 'PICT',
    kSFRGB16Color = 'tr16',
    kSFRGB96Color = 'tr96',
    kSFRGBColor = 'cRGB',
    kSFSaturday = 'sat ',
    kSFSeptember = 'sep ',
    kSFSunday = 'sun ',
    kSFTIFFPicture = 'TIFF',
    kSFThursday = 'thu ',
    kSFTuesday = 'tue ',
    kSFURL = 'pURL',
    kSFWednesday = 'wed ',
    kSFAlias = 'alis',
    kSFAnything = '****',
    kSFApplication = 'capp',
    kSFApplicationBundleID = 'bund',
    kSFApplicationSignature = 'sign',
    kSFApplicationURL = 'aprl',
    kSFAttachment = 'atts',
    kSFAttributeRun = 'catr',
    kSFBest = 'best',
    kSFBoolean = 'bool',
    kSFBoundingRectangle = 'qdrt',
    kSFBounds = 'pbnd',
    kSFCentimeters = 'cmtr',
    kSFCharacter = 'cha ',
    kSFClassInfo = 'gcli',
    kSFClass_ = 'pcls',
    kSFCloseable = 'hclb',
    kSFCollating = 'lwcl',
    kSFColor = 'colr',
    kSFColorTable = 'clrt',
    kSFCopies = 'lwcp',
    kSFCubicCentimeters = 'ccmt',
    kSFCubicFeet = 'cfet',
    kSFCubicInches = 'cuin',
    kSFCubicMeters = 'cmet',
    kSFCubicYards = 'cyrd',
    kSFCurrentTab = 'cTab',
    kSFDashStyle = 'tdas',
    kSFData = 'rdat',
    kSFDate = 'ldt ',
    kSFDecimalStruct = 'decm',
    kSFDegreesCelsius = 'degc',
    kSFDegreesFahrenheit = 'degf',
    kSFDegreesKelvin = 'degk',
    kSFDocument = 'docu',
    kSFDoubleInteger = 'comp',
    kSFElementInfo = 'elin',
    kSFEncodedString = 'encs',
    kSFEndingPage = 'lwlp',
    kSFEnumerator = 'enum',
    kSFErrorHandling = 'lweh',
    kSFEventInfo = 'evin',
    kSFExtendedFloat = 'exte',
    kSFFaxNumber = 'faxn',
    kSFFeet = 'feet',
    kSFFileName = 'atfn',
    kSFFileRef = 'fsrf',
    kSFFileSpecification = 'fss ',
    kSFFileURL = 'furl',
    kSFFixed = 'fixd',
    kSFFixedPoint = 'fpnt',
    kSFFixedRectangle = 'frct',
    kSFFloat128bit = 'ldbl',
    kSFFloat_ = 'doub',
    kSFFloating = 'isfl',
    kSFFont = 'font',
    kSFFrontmost = 'pisf',
    kSFGallons = 'galn',
    kSFGrams = 'gram',
    kSFGraphicText = 'cgtx',
    kSFId_ = 'ID  ',
    kSFInches = 'inch',
    kSFIndex = 'pidx',
    kSFInteger = 'long',
    kSFInternationalText = 'itxt',
    kSFInternationalWritingCode = 'intl',
    kSFItem = 'cobj',
    kSFKernelProcessID = 'kpid',
    kSFKilograms = 'kgrm',
    kSFKilometers = 'kmtr',
    kSFList = 'list',
    kSFLiters = 'litr',
    kSFLocationReference = 'insl',
    kSFLongFixed = 'lfxd',
    kSFLongFixedPoint = 'lfpt',
    kSFLongFixedRectangle = 'lfrc',
    kSFLongPoint = 'lpnt',
    kSFLongRectangle = 'lrct',
    kSFMachPort = 'port',
    kSFMachine = 'mach',
    kSFMachineLocation = 'mLoc',
    kSFMeters = 'metr',
    kSFMiles = 'mile',
    kSFMiniaturizable = 'ismn',
    kSFMiniaturized = 'pmnd',
    kSFMissingValue = 'msng',
    kSFModal = 'pmod',
    kSFModified = 'imod',
    kSFName = 'pnam',
    kSFNull = 'null',
    kSFOunces = 'ozs ',
    kSFPagesAcross = 'lwla',
    kSFPagesDown = 'lwld',
    kSFParagraph = 'cpar',
    kSFParameterInfo = 'pmin',
    kSFPath = 'ppth',
    kSFPixelMapRecord = 'tpmm',
    kSFPoint = 'QDpt',
    kSFPounds = 'lbs ',
    kSFPrintSettings = 'pset',
    kSFProcessSerialNumber = 'psn ',
    kSFProperties = 'pALL',
    kSFProperty = 'prop',
    kSFPropertyInfo = 'pinf',
    kSFQuarts = 'qrts',
    kSFRecord = 'reco',
    kSFReference = 'obj ',
    kSFRequestedPrintTime = 'lwqt',
    kSFResizable = 'prsz',
    kSFRotation = 'trot',
    kSFScript = 'scpt',
    kSFShortFloat = 'sing',
    kSFShortInteger = 'shor',
    kSFSize = 'ptsz',
    kSFSource = 'conT',
    kSFSquareFeet = 'sqft',
    kSFSquareKilometers = 'sqkm',
    kSFSquareMeters = 'sqrm',
    kSFSquareMiles = 'sqmi',
    kSFSquareYards = 'sqyd',
    kSFStartingPage = 'lwfp',
    kSFString = 'TEXT',
    kSFStyledClipboardText = 'styl',
    kSFStyledText = 'STXT',
    kSFSuiteInfo = 'suin',
    kSFTab = 'bTab',
    kSFTargetPrinter = 'trpr',
    kSFText = 'ctxt',
    kSFTextStyleInfo = 'tsty',
    kSFTitled = 'ptit',
    kSFTypeClass = 'type',
    kSFUnicodeText = 'utxt',
    kSFUnsignedInteger = 'magn',
    kSFUtf16Text = 'ut16',
    kSFUtf8Text = 'utf8',
    kSFVersion = 'vers',
    kSFVersion_ = 'vers',
    kSFVisible = 'pvis',
    kSFWindow = 'cwin',
    kSFWord = 'cwor',
    kSFWritingCode = 'psct',
    kSFYards = 'yard',
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


/* Events */

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
//  epSFWithProperties = 'prdt',
};

enum {
    ecSFMove = 'core',
    eiSFMove = 'move',
//  epSFTo = 'insh',
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
//  epSFWithProperties = 'prdt',
};

enum {
    ecSFQuit = 'aevt',
    eiSFQuit = 'quit',
//  epSFSaving = 'savo',
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
//  epSFIn = 'kfil',
};

enum {
    ecSFSet = 'core',
    eiSFSet = 'setd',
//  epSFTo = 'data',
};

enum {
    ecSFShowBookmarks = 'sfri',
    eiSFShowBookmarks = 'opbk',
};

