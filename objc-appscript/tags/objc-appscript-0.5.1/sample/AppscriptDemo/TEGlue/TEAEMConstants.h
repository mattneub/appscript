/*
 * TEAEMConstants.h
 * /Applications/TextEdit.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"

/* Types, enumerators, properties */

enum {
    kTEApplicationResponses = 'rmte',
    kTEAsk = 'ask ',
    kTECase_ = 'case',
    kTEDetailed = 'lwdt',
    kTEDiacriticals = 'diac',
    kTEExpansion = 'expa',
    kTEHyphens = 'hyph',
    kTENo = 'no  ',
    kTENumericStrings = 'nume',
    kTEPunctuation = 'punc',
    kTEStandard = 'lwst',
    kTEWhitespace = 'whit',
    kTEYes = 'yes ',
    kTEApril = 'apr ',
    kTEAugust = 'aug ',
    kTEDecember = 'dec ',
    kTEEPSPicture = 'EPS ',
    kTEFebruary = 'feb ',
    kTEFriday = 'fri ',
    kTEGIFPicture = 'GIFf',
    kTEJPEGPicture = 'JPEG',
    kTEJanuary = 'jan ',
    kTEJuly = 'jul ',
    kTEJune = 'jun ',
    kTEMarch = 'mar ',
    kTEMay = 'may ',
    kTEMonday = 'mon ',
    kTENovember = 'nov ',
    kTEOctober = 'oct ',
    kTEPICTPicture = 'PICT',
    kTERGB16Color = 'tr16',
    kTERGB96Color = 'tr96',
    kTERGBColor = 'cRGB',
    kTESaturday = 'sat ',
    kTESeptember = 'sep ',
    kTESunday = 'sun ',
    kTETIFFPicture = 'TIFF',
    kTEThursday = 'thu ',
    kTETuesday = 'tue ',
    kTEWednesday = 'wed ',
    kTEAlias = 'alis',
    kTEAnything = '****',
    kTEApplication = 'capp',
    kTEApplicationBundleID = 'bund',
    kTEApplicationSignature = 'sign',
    kTEApplicationURL = 'aprl',
    kTEAttachment = 'atts',
    kTEAttributeRun = 'catr',
    kTEBest = 'best',
    kTEBoolean = 'bool',
    kTEBoundingRectangle = 'qdrt',
    kTEBounds = 'pbnd',
    kTECentimeters = 'cmtr',
    kTECharacter = 'cha ',
    kTEClassInfo = 'gcli',
    kTEClass_ = 'pcls',
    kTECloseable = 'hclb',
    kTECollating = 'lwcl',
    kTEColor = 'colr',
    kTEColorTable = 'clrt',
    kTECopies = 'lwcp',
    kTECubicCentimeters = 'ccmt',
    kTECubicFeet = 'cfet',
    kTECubicInches = 'cuin',
    kTECubicMeters = 'cmet',
    kTECubicYards = 'cyrd',
    kTEDashStyle = 'tdas',
    kTEData = 'rdat',
    kTEDate = 'ldt ',
    kTEDecimalStruct = 'decm',
    kTEDegreesCelsius = 'degc',
    kTEDegreesFahrenheit = 'degf',
    kTEDegreesKelvin = 'degk',
    kTEDocument = 'docu',
    kTEDoubleInteger = 'comp',
    kTEElementInfo = 'elin',
    kTEEncodedString = 'encs',
    kTEEndingPage = 'lwlp',
    kTEEnumerator = 'enum',
    kTEErrorHandling = 'lweh',
    kTEEventInfo = 'evin',
    kTEExtendedFloat = 'exte',
    kTEFaxNumber = 'faxn',
    kTEFeet = 'feet',
    kTEFileName = 'atfn',
    kTEFileRef = 'fsrf',
    kTEFileSpecification = 'fss ',
    kTEFileURL = 'furl',
    kTEFixed = 'fixd',
    kTEFixedPoint = 'fpnt',
    kTEFixedRectangle = 'frct',
    kTEFloat128bit = 'ldbl',
    kTEFloat_ = 'doub',
    kTEFloating = 'isfl',
    kTEFont = 'font',
    kTEFrontmost = 'pisf',
    kTEGallons = 'galn',
    kTEGrams = 'gram',
    kTEGraphicText = 'cgtx',
    kTEId_ = 'ID  ',
    kTEInches = 'inch',
    kTEIndex = 'pidx',
    kTEInteger = 'long',
    kTEInternationalText = 'itxt',
    kTEInternationalWritingCode = 'intl',
    kTEItem = 'cobj',
    kTEKernelProcessID = 'kpid',
    kTEKilograms = 'kgrm',
    kTEKilometers = 'kmtr',
    kTEList = 'list',
    kTELiters = 'litr',
    kTELocationReference = 'insl',
    kTELongFixed = 'lfxd',
    kTELongFixedPoint = 'lfpt',
    kTELongFixedRectangle = 'lfrc',
    kTELongPoint = 'lpnt',
    kTELongRectangle = 'lrct',
    kTEMachPort = 'port',
    kTEMachine = 'mach',
    kTEMachineLocation = 'mLoc',
    kTEMeters = 'metr',
    kTEMiles = 'mile',
    kTEMiniaturizable = 'ismn',
    kTEMiniaturized = 'pmnd',
    kTEMissingValue = 'msng',
    kTEModal = 'pmod',
    kTEModified = 'imod',
    kTEName = 'pnam',
    kTENull = 'null',
    kTEOunces = 'ozs ',
    kTEPagesAcross = 'lwla',
    kTEPagesDown = 'lwld',
    kTEParagraph = 'cpar',
    kTEParameterInfo = 'pmin',
    kTEPath = 'ppth',
    kTEPixelMapRecord = 'tpmm',
    kTEPoint = 'QDpt',
    kTEPounds = 'lbs ',
    kTEPrintSettings = 'pset',
    kTEProcessSerialNumber = 'psn ',
    kTEProperties = 'pALL',
    kTEProperty = 'prop',
    kTEPropertyInfo = 'pinf',
    kTEQuarts = 'qrts',
    kTERecord = 'reco',
    kTEReference = 'obj ',
    kTERequestedPrintTime = 'lwqt',
    kTEResizable = 'prsz',
    kTERotation = 'trot',
    kTEScript = 'scpt',
    kTEShortFloat = 'sing',
    kTEShortInteger = 'shor',
    kTESize = 'ptsz',
    kTESquareFeet = 'sqft',
    kTESquareKilometers = 'sqkm',
    kTESquareMeters = 'sqrm',
    kTESquareMiles = 'sqmi',
    kTESquareYards = 'sqyd',
    kTEStartingPage = 'lwfp',
    kTEString = 'TEXT',
    kTEStyledClipboardText = 'styl',
    kTEStyledText = 'STXT',
    kTESuiteInfo = 'suin',
    kTETargetPrinter = 'trpr',
    kTEText = 'ctxt',
    kTETextStyleInfo = 'tsty',
    kTETitled = 'ptit',
    kTETypeClass = 'type',
    kTEUnicodeText = 'utxt',
    kTEUnsignedInteger = 'magn',
    kTEUtf16Text = 'ut16',
    kTEUtf8Text = 'utf8',
    kTEVersion = 'vers',
    kTEVersion_ = 'vers',
    kTEVisible = 'pvis',
    kTEWindow = 'cwin',
    kTEWord = 'cwor',
    kTEWritingCode = 'psct',
    kTEYards = 'yard',
    kTEZoomable = 'iszm',
    kTEZoomed = 'pzum',
};

enum {
    eTEApplications = 'capp',
    eTEAttachment = 'atts',
    eTEAttributeRuns = 'catr',
    eTECharacters = 'cha ',
    eTEColors = 'colr',
    eTEDocuments = 'docu',
    eTEItems = 'cobj',
    eTEParagraphs = 'cpar',
    eTEPrintSettings = 'pset',
    eTEText = 'ctxt',
    eTEWindows = 'cwin',
    eTEWords = 'cwor',
    pTEBounds = 'pbnd',
    pTEClass_ = 'pcls',
    pTECloseable = 'hclb',
    pTECollating = 'lwcl',
    pTEColor = 'colr',
    pTECopies = 'lwcp',
    pTEDocument = 'docu',
    pTEEndingPage = 'lwlp',
    pTEErrorHandling = 'lweh',
    pTEFaxNumber = 'faxn',
    pTEFileName = 'atfn',
    pTEFloating = 'isfl',
    pTEFont = 'font',
    pTEFrontmost = 'pisf',
    pTEId_ = 'ID  ',
    pTEIndex = 'pidx',
    pTEMiniaturizable = 'ismn',
    pTEMiniaturized = 'pmnd',
    pTEModal = 'pmod',
    pTEModified = 'imod',
    pTEName = 'pnam',
    pTEPagesAcross = 'lwla',
    pTEPagesDown = 'lwld',
    pTEPath = 'ppth',
    pTEProperties = 'pALL',
    pTERequestedPrintTime = 'lwqt',
    pTEResizable = 'prsz',
    pTESize = 'ptsz',
    pTEStartingPage = 'lwfp',
    pTETargetPrinter = 'trpr',
    pTETitled = 'ptit',
    pTEVersion_ = 'vers',
    pTEVisible = 'pvis',
    pTEZoomable = 'iszm',
    pTEZoomed = 'pzum',
};


/* Events */

enum {
    ecTEActivate = 'misc',
    eiTEActivate = 'actv',
};

enum {
    ecTEClose = 'core',
    eiTEClose = 'clos',
    epTESaving = 'savo',
    epTESavingIn = 'kfil',
};

enum {
    ecTECount = 'core',
    eiTECount = 'cnte',
    epTEEach = 'kocl',
};

enum {
    ecTEDelete = 'core',
    eiTEDelete = 'delo',
};

enum {
    ecTEDuplicate = 'core',
    eiTEDuplicate = 'clon',
    epTETo = 'insh',
    epTEWithProperties = 'prdt',
};

enum {
    ecTEExists = 'core',
    eiTEExists = 'doex',
};

enum {
    ecTEGet = 'core',
    eiTEGet = 'getd',
};

enum {
    ecTELaunch = 'ascr',
    eiTELaunch = 'noop',
};

enum {
    ecTEMake = 'core',
    eiTEMake = 'crel',
    epTEAt = 'insh',
    epTENew_ = 'kocl',
    epTEWithData = 'data',
//  epTEWithProperties = 'prdt',
};

enum {
    ecTEMove = 'core',
    eiTEMove = 'move',
//  epTETo = 'insh',
};

enum {
    ecTEOpen = 'aevt',
    eiTEOpen = 'odoc',
};

enum {
    ecTEOpenLocation = 'GURL',
    eiTEOpenLocation = 'GURL',
    epTEWindow = 'WIND',
};

enum {
    ecTEPrint = 'aevt',
    eiTEPrint = 'pdoc',
    epTEPrintDialog = 'pdlg',
//  epTEWithProperties = 'prdt',
};

enum {
    ecTEQuit = 'aevt',
    eiTEQuit = 'quit',
//  epTESaving = 'savo',
};

enum {
    ecTEReopen = 'aevt',
    eiTEReopen = 'rapp',
};

enum {
    ecTERun = 'aevt',
    eiTERun = 'oapp',
};

enum {
    ecTESave = 'core',
    eiTESave = 'save',
    epTEAs = 'fltp',
    epTEIn = 'kfil',
};

enum {
    ecTESet = 'core',
    eiTESet = 'setd',
//  epTETo = 'data',
};

