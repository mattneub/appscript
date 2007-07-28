# kOSA.py
#
# Generated on Sat Nov 18 19:08:46 GMT 2006


from kAE import *



# AppleScript.h

typeAppleScript = 'ascr'
kAppleScriptSubtype = typeAppleScript
typeASStorage = typeAppleScript

kASSelectInit = 0x1001
kASSelectSetSourceStyles = 0x1002
kASSelectGetSourceStyles = 0x1003
kASSelectGetSourceStyleNames = 0x1004

kASHasOpenHandler = 'hsod'

kASDefaultMinStackSize = 4
kASDefaultPreferredStackSize = 16
kASDefaultMaxStackSize = 16
kASDefaultMinHeapSize = 4
kASDefaultPreferredHeapSize = 16
kASDefaultMaxHeapSize = 32L

kASSourceStyleUncompiledText = 0
kASSourceStyleNormalText = 1
kASSourceStyleLanguageKeyword = 2
kASSourceStyleApplicationKeyword = 3
kASSourceStyleComment = 4
kASSourceStyleLiteral = 5
kASSourceStyleUserSymbol = 6
kASSourceStyleObjectSpecifier = 7
kASNumberOfSourceStyles = 8



# ASDebugging.h

kOSAModeDontDefine = 0x0001

kASSelectSetPropertyObsolete = 0x1101
kASSelectGetPropertyObsolete = 0x1102
kASSelectSetHandlerObsolete = 0x1103
kASSelectGetHandlerObsolete = 0x1104
kASSelectGetAppTerminologyObsolete = 0x1105
kASSelectSetProperty = 0x1106
kASSelectGetProperty = 0x1107
kASSelectSetHandler = 0x1108
kASSelectGetHandler = 0x1109
kASSelectGetAppTerminology = 0x110A
kASSelectGetSysTerminology = 0x110B
kASSelectGetPropertyNames = 0x110C
kASSelectGetHandlerNames = 0x110D



# ASRegistry.h

keyAETarget = 'targ'
keySubjectAttr = 'subj'
keyASReturning = 'Krtn'
kASAppleScriptSuite = 'ascr'
kASScriptEditorSuite = 'ToyS'
kASTypeNamesSuite = 'tpnm'
typeAETE = 'aete'
typeAEUT = 'aeut'
kGetAETE = 'gdte'
kGetAEUT = 'gdut'
kUpdateAEUT = 'udut'
kUpdateAETE = 'udte'
kCleanUpAEUT = 'cdut'
kASComment = 'cmnt'
kASLaunchEvent = 'noop'
keyScszResource = 'scsz'
typeScszResource = 'scsz'
kASSubroutineEvent = 'psbr'
keyASSubroutineName = 'snam'
kASPrepositionalSubroutine = 'psbr'
keyASPositionalArgs = 'parg'

keyAppHandledCoercion = 'idas'

kASStartLogEvent = 'log1'
kASStopLogEvent = 'log0'
kASCommentEvent = 'cmnt'

kASAdd = '+   '
kASSubtract = '-   '
kASMultiply = '*   '
kASDivide = '/   '
kASQuotient = 'div '
kASRemainder = 'mod '
kASPower = '^   '
kASEqual = kAEEquals
kASNotEqual = 0xAD202020
kASGreaterThan = kAEGreaterThan
kASGreaterThanOrEqual = kAEGreaterThanEquals
kASLessThan = kAELessThan
kASLessThanOrEqual = kAELessThanEquals
kASComesBefore = 'cbfr'
kASComesAfter = 'cafr'
kASConcatenate = 'ccat'
kASStartsWith = kAEBeginsWith
kASEndsWith = kAEEndsWith
kASContains = kAEContains

kASAnd = kAEAND
kASOr = kAEOR
kASNot = kAENOT
kASNegate = 'neg '
keyASArg = 'arg '

kASErrorEventCode = 'err '
kOSAErrorArgs = 'erra'
keyAEErrorObject = 'erob'
pLength = 'leng'
pReverse = 'rvse'
pRest = 'rest'
pInherits = 'c@#^'
pProperties = 'pALL'
keyASUserRecordFields = 'usrf'
typeUserRecordFields = typeAEList

keyASPrepositionAt = 'at  '
keyASPrepositionIn = 'in  '
keyASPrepositionFrom = 'from'
keyASPrepositionFor = 'for '
keyASPrepositionTo = 'to  '
keyASPrepositionThru = 'thru'
keyASPrepositionThrough = 'thgh'
keyASPrepositionBy = 'by  '
keyASPrepositionOn = 'on  '
keyASPrepositionInto = 'into'
keyASPrepositionOnto = 'onto'
keyASPrepositionBetween = 'btwn'
keyASPrepositionAgainst = 'agst'
keyASPrepositionOutOf = 'outo'
keyASPrepositionInsteadOf = 'isto'
keyASPrepositionAsideFrom = 'asdf'
keyASPrepositionAround = 'arnd'
keyASPrepositionBeside = 'bsid'
keyASPrepositionBeneath = 'bnth'
keyASPrepositionUnder = 'undr'

keyASPrepositionOver = 'over'
keyASPrepositionAbove = 'abve'
keyASPrepositionBelow = 'belw'
keyASPrepositionApartFrom = 'aprt'
keyASPrepositionGiven = 'givn'
keyASPrepositionWith = 'with'
keyASPrepositionWithout = 'wout'
keyASPrepositionAbout = 'abou'
keyASPrepositionSince = 'snce'
keyASPrepositionUntil = 'till'

kDialectBundleResType = 'Dbdl'
cConstant = typeEnumerated
cClassIdentifier = pClass
cObjectBeingExamined = typeObjectBeingExamined
cList = typeAEList
cSmallReal = typeSMFloat
cReal = typeFloat
cRecord = typeAERecord
cReference = cObjectSpecifier
cUndefined = 'undf'
cMissingValue = 'msng'
cSymbol = 'symb'
cLinkedList = 'llst'
cVector = 'vect'
cEventIdentifier = 'evnt'
cKeyIdentifier = 'kyid'
cUserIdentifier = 'uid '
cPreposition = 'prep'
cKeyForm = enumKeyForm
cScript = 'scpt'
cHandler = 'hand'
cProcedure = 'proc'

cHandleBreakpoint = 'brak'

cClosure = 'clsr'
cRawData = 'rdat'
cStringClass = typeChar
cNumber = 'nmbr'
cListElement = 'celm'
cListOrRecord = 'lr  '
cListOrString = 'ls  '
cListRecordOrString = 'lrs '
cNumberOrString = 'ns  '
cNumberOrDateTime = 'nd  '
cNumberDateTimeOrString = 'nds '
cAliasOrString = 'sf  '
cSeconds = 'scnd'
typeSound = 'snd '
enumBooleanValues = 'boov'
kAETrue = typeTrue
kAEFalse = typeFalse
enumMiscValues = 'misc'
kASCurrentApplication = 'cura'
formUserPropertyID = 'usrp'

cString = cStringClass

pASIt = 'it  '
pASMe = 'me  '
pASResult = 'rslt'
pASSpace = 'spac'
pASReturn = 'ret '
pASTab = 'tab '
pASPi = 'pi  '
pASParent = 'pare'
kASInitializeEventCode = 'init'
pASPrintLength = 'prln'
pASPrintDepth = 'prdp'
pASTopLevelScript = 'ascr'

kAECase = 'case'
kAEDiacritic = 'diac'
kAEWhiteSpace = 'whit'
kAEHyphens = 'hyph'
kAEExpansion = 'expa'
kAEPunctuation = 'punc'
kAEZenkakuHankaku = 'zkhk'
kAESmallKana = 'skna'
kAEKataHiragana = 'hika'
kASConsiderReplies = 'rmte'
kASNumericStrings = 'nume'
enumConsiderations = 'cons'

kAECaseConsiderMask = 0x00000001
kAEDiacriticConsiderMask = 0x00000002
kAEWhiteSpaceConsiderMask = 0x00000004
kAEHyphensConsiderMask = 0x00000008
kAEExpansionConsiderMask = 0x00000010
kAEPunctuationConsiderMask = 0x00000020
kASConsiderRepliesConsiderMask = 0x00000040
kASNumericStringsConsiderMask = 0x00000080
kAECaseIgnoreMask = 0x00010000
kAEDiacriticIgnoreMask = 0x00020000
kAEWhiteSpaceIgnoreMask = 0x00040000
kAEHyphensIgnoreMask = 0x00080000
kAEExpansionIgnoreMask = 0x00100000
kAEPunctuationIgnoreMask = 0x00200000
kASConsiderRepliesIgnoreMask = 0x00400000
kASNumericStringsIgnoreMask = 0x00800000
enumConsidsAndIgnores = 'csig'

cCoercion = 'coec'
cCoerceUpperCase = 'txup'
cCoerceLowerCase = 'txlo'
cCoerceRemoveDiacriticals = 'txdc'
cCoerceRemovePunctuation = 'txpc'
cCoerceRemoveHyphens = 'txhy'
cCoerceOneByteToTwoByte = 'txex'
cCoerceRemoveWhiteSpace = 'txws'
cCoerceSmallKana = 'txsk'
cCoerceZenkakuhankaku = 'txze'
cCoerceKataHiragana = 'txkh'
cZone = 'zone'
cMachine = 'mach'
cAddress = 'addr'
cRunningAddress = 'radd'
cStorage = 'stor'

pASWeekday = 'wkdy'
pASMonth = 'mnth'
pASDay = 'day '
pASYear = 'year'
pASTime = 'time'
pASDateString = 'dstr'
pASTimeString = 'tstr'
cMonth = pASMonth
cJanuary = 'jan '
cFebruary = 'feb '
cMarch = 'mar '
cApril = 'apr '
cMay = 'may '
cJune = 'jun '
cJuly = 'jul '
cAugust = 'aug '
cSeptember = 'sep '
cOctober = 'oct '
cNovember = 'nov '
cDecember = 'dec '

cWeekday = pASWeekday
cSunday = 'sun '
cMonday = 'mon '
cTuesday = 'tue '
cWednesday = 'wed '
cThursday = 'thu '
cFriday = 'fri '
cSaturday = 'sat '
pASQuote = 'quot'
pASSeconds = 'secs'
pASMinutes = 'min '
pASHours = 'hour'
pASDays = 'days'
pASWeeks = 'week'
cWritingCodeInfo = 'citl'
pScriptCode = 'pscd'
pLangCode = 'plcd'
kASMagicTellEvent = 'tell'
kASMagicEndTellEvent = 'tend'



# DigitalHubRegistry.h

kDigiHubEventClass = 'dhub'

kDigiHubMusicCD = 'aucd'
kDigiHubPictureCD = 'picd'
kDigiHubVideoDVD = 'vdvd'
kDigiHubBlankCD = 'bcd '
kDigiHubBlankDVD = 'bdvd'



# OSA.h

kOSAComponentType = 'osa '

kOSAGenericScriptingComponentSubtype = 'scpt'

kOSAFileType = 'osas'

kOSASuite = 'ascr'

kOSARecordedText = 'recd'

kOSAScriptIsModified = 'modi'

kOSAScriptIsTypeCompiledScript = 'cscr'

kOSAScriptIsTypeScriptValue = 'valu'

kOSAScriptIsTypeScriptContext = 'cntx'

kOSAScriptBestType = 'best'

kOSACanGetSource = 'gsrc'

typeOSADialectInfo = 'difo'
keyOSADialectName = 'dnam'
keyOSADialectCode = 'dcod'
keyOSADialectLangCode = 'dlcd'
keyOSADialectScriptCode = 'dscd'

kOSANullScript = 0L

kOSANullMode = 0
kOSAModeNull = 0

kOSASupportsCompiling = 0x0002
kOSASupportsGetSource = 0x0004
kOSASupportsAECoercion = 0x0008
kOSASupportsAESending = 0x0010
kOSASupportsRecording = 0x0020
kOSASupportsConvenience = 0x0040
kOSASupportsDialects = 0x0080
kOSASupportsEventHandling = 0x0100

kOSASelectLoad = 0x0001
kOSASelectStore = 0x0002
kOSASelectExecute = 0x0003
kOSASelectDisplay = 0x0004
kOSASelectScriptError = 0x0005
kOSASelectDispose = 0x0006
kOSASelectSetScriptInfo = 0x0007
kOSASelectGetScriptInfo = 0x0008
kOSASelectSetActiveProc = 0x0009
kOSASelectGetActiveProc = 0x000A

kOSASelectScriptingComponentName = 0x0102
kOSASelectCompile = 0x0103
kOSASelectCopyID = 0x0104

kOSASelectCopyScript = 0x0105

kOSASelectGetSource = 0x0201

kOSASelectCoerceFromDesc = 0x0301
kOSASelectCoerceToDesc = 0x0302

kOSASelectSetSendProc = 0x0401
kOSASelectGetSendProc = 0x0402
kOSASelectSetCreateProc = 0x0403
kOSASelectGetCreateProc = 0x0404
kOSASelectSetDefaultTarget = 0x0405

kOSASelectStartRecording = 0x0501
kOSASelectStopRecording = 0x0502

kOSASelectLoadExecute = 0x0601
kOSASelectCompileExecute = 0x0602
kOSASelectDoScript = 0x0603

kOSASelectSetCurrentDialect = 0x0701
kOSASelectGetCurrentDialect = 0x0702
kOSASelectAvailableDialects = 0x0703
kOSASelectGetDialectInfo = 0x0704
kOSASelectAvailableDialectCodeList = 0x0705

kOSASelectSetResumeDispatchProc = 0x0801
kOSASelectGetResumeDispatchProc = 0x0802
kOSASelectExecuteEvent = 0x0803
kOSASelectDoEvent = 0x0804
kOSASelectMakeContext = 0x0805

kOSADebuggerCreateSession = 0x0901
kOSADebuggerGetSessionState = 0x0902
kOSADebuggerSessionStep = 0x0903
kOSADebuggerDisposeSession = 0x0904
kOSADebuggerGetStatementRanges = 0x0905
kOSADebuggerGetBreakpoint = 0x0910
kOSADebuggerSetBreakpoint = 0x0911
kOSADebuggerGetDefaultBreakpoint = 0x0912
kOSADebuggerGetCurrentCallFrame = 0x0906
kOSADebuggerGetCallFrameState = 0x0907
kOSADebuggerGetVariable = 0x0908
kOSADebuggerSetVariable = 0x0909
kOSADebuggerGetPreviousCallFrame = 0x090A
kOSADebuggerDisposeCallFrame = 0x090B

kOSASelectComponentSpecificStart = 0x1001

kOSAModePreventGetSource = 0x00000001

kOSAModeNeverInteract = kAENeverInteract
kOSAModeCanInteract = kAECanInteract
kOSAModeAlwaysInteract = kAEAlwaysInteract
kOSAModeDontReconnect = kAEDontReconnect

kOSAModeCantSwitchLayer = 0x00000040

kOSAModeDoRecord = 0x00001000

kOSAModeCompileIntoContext = 0x00000002

kOSAModeAugmentContext = 0x00000004

kOSAModeDisplayForHumans = 0x00000008

kOSAModeDontStoreParent = 0x00010000

kOSAModeDispatchToDirectObject = 0x00020000

kOSAModeDontGetDataForArguments = 0x00040000

kOSAModeFullyQualifyDescriptors = 0x00080000

kOSAScriptResourceType = kOSAGenericScriptingComponentSubtype

typeOSAGenericStorage = kOSAScriptResourceType

kOSAErrorNumber = keyErrorNumber

kOSAErrorMessage = keyErrorString

kOSAErrorBriefMessage = 'errb'

kOSAErrorApp = 'erap'

kOSAErrorPartialResult = 'ptlr'

kOSAErrorOffendingObject = 'erob'

kOSAErrorExpectedType = 'errt'

kOSAErrorRange = 'erng'

typeOSAErrorRange = 'erng'

keyOSASourceStart = 'srcs'

keyOSASourceEnd = 'srce'

kOSAUseStandardDispatch = kAEUseStandardDispatch

kOSANoDispatch = kAENoDispatch

kOSADontUsePhac = 0x0001

eNotStarted = 0
eRunnable = 1
eRunning = 2
eStopped = 3
eTerminated = 4

eStepOver = 0
eStepIn = 1
eStepOut = 2
eRun = 3

keyProgramState = 'dsps'

typeStatementRange = 'srng'

keyProcedureName = 'dfnm'
keyStatementRange = 'dfsr'
keyLocalsNames = 'dfln'
keyGlobalsNames = 'dfgn'
keyParamsNames = 'dfpn'



# OSAComp.h



# OSAGeneric.h

kGenericComponentVersion = 0x0100

kGSSSelectGetDefaultScriptingComponent = 0x1001
kGSSSelectSetDefaultScriptingComponent = 0x1002
kGSSSelectGetScriptingComponent = 0x1003
kGSSSelectGetScriptingComponentFromStored = 0x1004
kGSSSelectGenericToRealID = 0x1005
kGSSSelectRealToGenericID = 0x1006
kGSSSelectOutOfRange = 0x1007

