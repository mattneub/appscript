/*
 * ICAEMConstants.h
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import <Foundation/Foundation.h>
#import "Appscript/Appscript.h"

/* Types, enumerators, properties */

enum {
    kICAccepted = 'E6ap',
    kICApplicationResponses = 'rmte',
    kICAsk = 'ask ',
    kICCancelled = 'E4ca',
    kICCase_ = 'case',
    kICConfirmed = 'E4cn',
    kICDayView = 'E5da',
    kICDeclined = 'E6dp',
    kICDetailed = 'lwdt',
    kICDiacriticals = 'diac',
    kICExpansion = 'expa',
    kICHighPriority = 'tdp1',
    kICHyphens = 'hyph',
    kICLowPriority = 'tdp9',
    kICMediumPriority = 'tdp5',
    kICMonthView = 'E5mo',
    kICNo = 'no  ',
    kICNoPriority = 'tdp0',
    kICNone = 'E4no',
    kICNumericStrings = 'nume',
    kICPunctuation = 'punc',
    kICStandard = 'lwst',
    kICTentative = 'E6tp',
    kICUnknown = 'E6na',
    kICWeekView = 'E5we',
    kICWhitespace = 'whit',
    kICYes = 'yes ',
    kICApril = 'apr ',
    kICAugust = 'aug ',
    kICDecember = 'dec ',
    kICEPSPicture = 'EPS ',
    kICFebruary = 'feb ',
    kICFriday = 'fri ',
    kICGIFPicture = 'GIFf',
    kICJPEGPicture = 'JPEG',
    kICJanuary = 'jan ',
    kICJuly = 'jul ',
    kICJune = 'jun ',
    kICMarch = 'mar ',
    kICMay = 'may ',
    kICMonday = 'mon ',
    kICNovember = 'nov ',
    kICOctober = 'oct ',
    kICPICTPicture = 'PICT',
    kICRGB16Color = 'tr16',
    kICRGB96Color = 'tr96',
    kICRGBColor = 'cRGB',
    kICSaturday = 'sat ',
    kICSeptember = 'sep ',
    kICSunday = 'sun ',
    kICTIFFPicture = 'TIFF',
    kICThursday = 'thu ',
    kICTuesday = 'tue ',
    kICWednesday = 'wed ',
    kICAlias = 'alis',
    kICAlldayEvent = 'wrad',
    kICAnything = '****',
    kICApplication = 'capp',
    kICApplicationBundleID = 'bund',
    kICApplicationSignature = 'sign',
    kICApplicationURL = 'aprl',
    kICAttachment = 'atts',
    kICAttendee = 'wrea',
    kICAttributeRun = 'catr',
    kICBest = 'best',
    kICBoolean = 'bool',
    kICBoundingRectangle = 'qdrt',
    kICBounds = 'pbnd',
    kICCalendar = 'wres',
    kICCentimeters = 'cmtr',
    kICCharacter = 'cha ',
    kICClassInfo = 'gcli',
    kICClass_ = 'pcls',
    kICCloseable = 'hclb',
    kICCollating = 'lwcl',
    kICColor = 'colr',
    kICColorTable = 'clrt',
    kICCompletionDate = 'wrt1',
    kICCopies = 'lwcp',
    kICCubicCentimeters = 'ccmt',
    kICCubicFeet = 'cfet',
    kICCubicInches = 'cuin',
    kICCubicMeters = 'cmet',
    kICCubicYards = 'cyrd',
    kICDashStyle = 'tdas',
    kICData = 'rdat',
    kICDate = 'ldt ',
    kICDecimalStruct = 'decm',
    kICDegreesCelsius = 'degc',
    kICDegreesFahrenheit = 'degf',
    kICDegreesKelvin = 'degk',
    kICDescription_ = 'wr12',
    kICDisplayAlarm = 'wal1',
    kICDisplayName = 'wra1',
    kICDocument = 'docu',
    kICDoubleInteger = 'comp',
    kICDueDate = 'wrt3',
    kICElementInfo = 'elin',
    kICEmail = 'wra2',
    kICEncodedString = 'encs',
    kICEndDate = 'wr5s',
    kICEndingPage = 'lwlp',
    kICEnumerator = 'enum',
    kICErrorHandling = 'lweh',
    kICEvent = 'wrev',
    kICEventInfo = 'evin',
    kICExcludedDates = 'wr2s',
    kICExtendedFloat = 'exte',
    kICFaxNumber = 'faxn',
    kICFeet = 'feet',
    kICFileName = 'atfn',
    kICFileRef = 'fsrf',
    kICFileSpecification = 'fss ',
    kICFileURL = 'furl',
    kICFilepath = 'walp',
    kICFixed = 'fixd',
    kICFixedPoint = 'fpnt',
    kICFixedRectangle = 'frct',
    kICFloat128bit = 'ldbl',
    kICFloat_ = 'doub',
    kICFloating = 'isfl',
    kICFont = 'font',
    kICFrontmost = 'pisf',
    kICGallons = 'galn',
    kICGrams = 'gram',
    kICGraphicText = 'cgtx',
    kICId_ = 'ID  ',
    kICInches = 'inch',
    kICIndex = 'pidx',
    kICInteger = 'long',
    kICInternationalText = 'itxt',
    kICInternationalWritingCode = 'intl',
    kICItem = 'cobj',
    kICKernelProcessID = 'kpid',
    kICKilograms = 'kgrm',
    kICKilometers = 'kmtr',
    kICList = 'list',
    kICLiters = 'litr',
    kICLocation = 'wr14',
    kICLocationReference = 'insl',
    kICLongFixed = 'lfxd',
    kICLongFixedPoint = 'lfpt',
    kICLongFixedRectangle = 'lfrc',
    kICLongPoint = 'lpnt',
    kICLongRectangle = 'lrct',
    kICMachPort = 'port',
    kICMachine = 'mach',
    kICMachineLocation = 'mLoc',
    kICMailAlarm = 'wal2',
    kICMeters = 'metr',
    kICMiles = 'mile',
    kICMiniaturizable = 'ismn',
    kICMiniaturized = 'pmnd',
    kICMissingValue = 'msng',
    kICModal = 'pmod',
    kICModified = 'imod',
    kICName = 'pnam',
    kICNull = 'null',
    kICOpenFileAlarm = 'wal3',
    kICOunces = 'ozs ',
    kICPagesAcross = 'lwla',
    kICPagesDown = 'lwld',
    kICParagraph = 'cpar',
    kICParameterInfo = 'pmin',
    kICParticipationStatus = 'wra3',
    kICPath = 'ppth',
    kICPixelMapRecord = 'tpmm',
    kICPoint = 'QDpt',
    kICPounds = 'lbs ',
    kICPrintSettings = 'pset',
    kICPriority = 'wrt5',
    kICProcessSerialNumber = 'psn ',
    kICProperties = 'pALL',
    kICProperty = 'prop',
    kICPropertyInfo = 'pinf',
    kICQuarts = 'qrts',
    kICRecord = 'reco',
    kICRecurrence = 'wr15',
    kICReference = 'obj ',
    kICRequestedPrintTime = 'lwqt',
    kICResizable = 'prsz',
    kICRotation = 'trot',
    kICScript = 'scpt',
    kICSequence = 'wr13',
    kICShortFloat = 'sing',
    kICShortInteger = 'shor',
    kICSize = 'ptsz',
    kICSoundAlarm = 'wal4',
    kICSoundFile = 'walf',
    kICSoundName = 'wals',
    kICSquareFeet = 'sqft',
    kICSquareKilometers = 'sqkm',
    kICSquareMeters = 'sqrm',
    kICSquareMiles = 'sqmi',
    kICSquareYards = 'sqyd',
    kICStampDate = 'wr4s',
    kICStartDate = 'wr1s',
    kICStartingPage = 'lwfp',
    kICStatus = 'wre4',
    kICString = 'TEXT',
    kICStyledClipboardText = 'styl',
    kICStyledText = 'STXT',
    kICSuiteInfo = 'suin',
    kICSummary = 'wr11',
    kICTargetPrinter = 'trpr',
    kICText = 'ctxt',
    kICTextStyleInfo = 'tsty',
    kICTitled = 'ptit',
    kICTodo = 'wret',
    kICTriggerDate = 'wale',
    kICTriggerInterval = 'wald',
    kICTypeClass = 'type',
    kICUid = 'ID  ',
    kICUnicodeText = 'utxt',
    kICUnsignedInteger = 'magn',
    kICUrl = 'wr16',
    kICUtf16Text = 'ut16',
    kICUtf8Text = 'utf8',
    kICVersion = 'vers',
    kICVersion_ = 'vers',
    kICVisible = 'pvis',
    kICWindow = 'cwin',
    kICWord = 'cwor',
    kICWritable = 'wr05',
    kICWritingCode = 'psct',
    kICYards = 'yard',
    kICZoomable = 'iszm',
    kICZoomed = 'pzum',
};

enum {
    eICApplications = 'capp',
    eICAttachment = 'atts',
    eICAttendees = 'wrea',
    eICAttributeRuns = 'catr',
    eICCalendars = 'wres',
    eICCharacters = 'cha ',
    eICColors = 'colr',
    eICDisplayAlarms = 'wal1',
    eICDocuments = 'docu',
    eICEvents = 'wrev',
    eICItems = 'cobj',
    eICMailAlarms = 'wal2',
    eICOpenFileAlarms = 'wal3',
    eICParagraphs = 'cpar',
    eICPrintSettings = 'pset',
    eICSoundAlarms = 'wal4',
    eICText = 'ctxt',
    eICTodos = 'wret',
    eICWindows = 'cwin',
    eICWords = 'cwor',
    pICAlldayEvent = 'wrad',
    pICBounds = 'pbnd',
    pICClass_ = 'pcls',
    pICCloseable = 'hclb',
    pICCollating = 'lwcl',
    pICColor = 'colr',
    pICCompletionDate = 'wrt1',
    pICCopies = 'lwcp',
    pICDescription_ = 'wr12',
    pICDisplayName = 'wra1',
    pICDocument = 'docu',
    pICDueDate = 'wrt3',
    pICEmail = 'wra2',
    pICEndDate = 'wr5s',
    pICEndingPage = 'lwlp',
    pICErrorHandling = 'lweh',
    pICExcludedDates = 'wr2s',
    pICFaxNumber = 'faxn',
    pICFileName = 'atfn',
    pICFilepath = 'walp',
    pICFloating = 'isfl',
    pICFont = 'font',
    pICFrontmost = 'pisf',
    pICId_ = 'ID  ',
    pICIndex = 'pidx',
    pICLocation = 'wr14',
    pICMiniaturizable = 'ismn',
    pICMiniaturized = 'pmnd',
    pICModal = 'pmod',
    pICModified = 'imod',
    pICName = 'pnam',
    pICPagesAcross = 'lwla',
    pICPagesDown = 'lwld',
    pICParticipationStatus = 'wra3',
    pICPath = 'ppth',
    pICPriority = 'wrt5',
    pICProperties = 'pALL',
    pICRecurrence = 'wr15',
    pICRequestedPrintTime = 'lwqt',
    pICResizable = 'prsz',
    pICSequence = 'wr13',
    pICSize = 'ptsz',
    pICSoundFile = 'walf',
    pICSoundName = 'wals',
    pICStampDate = 'wr4s',
    pICStartDate = 'wr1s',
    pICStartingPage = 'lwfp',
    pICStatus = 'wre4',
    pICSummary = 'wr11',
    pICTargetPrinter = 'trpr',
    pICTitled = 'ptit',
    pICTriggerDate = 'wale',
    pICTriggerInterval = 'wald',
    pICUid = 'ID  ',
    pICUrl = 'wr16',
    pICVersion_ = 'vers',
    pICVisible = 'pvis',
    pICWritable = 'wr05',
    pICZoomable = 'iszm',
    pICZoomed = 'pzum',
};


/* Events */

enum {
    ecICGetURL = 'GURL',
    eiICGetURL = 'GURL',
};

enum {
    ecICActivate = 'misc',
    eiICActivate = 'actv',
};

enum {
    ecICClose = 'core',
    eiICClose = 'clos',
    epICSaving = 'savo',
    epICSavingIn = 'kfil',
};

enum {
    ecICCount = 'core',
    eiICCount = 'cnte',
    epICEach = 'kocl',
};

enum {
    ecICCreateCalendar = 'wrbt',
    eiICCreateCalendar = 'aec2',
    epICWithName = 'wtnm',
};

enum {
    ecICDelete = 'core',
    eiICDelete = 'delo',
};

enum {
    ecICDuplicate = 'core',
    eiICDuplicate = 'clon',
    epICTo = 'insh',
    epICWithProperties = 'prdt',
};

enum {
    ecICExists = 'core',
    eiICExists = 'doex',
};

enum {
    ecICGet = 'core',
    eiICGet = 'getd',
};

enum {
    ecICLaunch = 'ascr',
    eiICLaunch = 'noop',
};

enum {
    ecICMake = 'core',
    eiICMake = 'crel',
    epICAt = 'insh',
    epICNew_ = 'kocl',
    epICWithData = 'data',
//  epICWithProperties = 'prdt',
};

enum {
    ecICMove = 'core',
    eiICMove = 'move',
//  epICTo = 'insh',
};

enum {
    ecICOpen = 'aevt',
    eiICOpen = 'odoc',
};

enum {
    ecICOpenLocation = 'GURL',
    eiICOpenLocation = 'GURL',
    epICWindow = 'WIND',
};

enum {
    ecICPrint = 'aevt',
    eiICPrint = 'pdoc',
    epICPrintDialog = 'pdlg',
//  epICWithProperties = 'prdt',
};

enum {
    ecICQuit = 'aevt',
    eiICQuit = 'quit',
//  epICSaving = 'savo',
};

enum {
    ecICReloadCalendars = 'wrbt',
    eiICReloadCalendars = 'aec8',
};

enum {
    ecICReopen = 'aevt',
    eiICReopen = 'rapp',
};

enum {
    ecICRun = 'aevt',
    eiICRun = 'oapp',
};

enum {
    ecICSave = 'core',
    eiICSave = 'save',
    epICAs = 'fltp',
    epICIn = 'kfil',
};

enum {
    ecICSet = 'core',
    eiICSet = 'setd',
//  epICTo = 'data',
};

enum {
    ecICShow = 'wrbt',
    eiICShow = 'aec3',
};

enum {
    ecICSwitchView = 'wrbt',
    eiICSwitchView = 'aeca',
//  epICTo = 'wre5',
};

enum {
    ecICViewCalendar = 'wrbt',
    eiICViewCalendar = 'aec9',
//  epICAt = 'wtdt',
};

