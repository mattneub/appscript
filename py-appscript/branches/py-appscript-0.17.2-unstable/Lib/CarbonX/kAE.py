# kAE.py
#
# Generated on Sat Nov 18 19:08:46 GMT 2006


# AEDataModel.h

typeBoolean = 'bool'
typeChar = 'TEXT'

typeStyledUnicodeText = 'sutx'
typeEncodedString = 'encs'
typeUnicodeText = 'utxt'
typeCString = 'cstr'
typePString = 'pstr'

typeUTF16ExternalRepresentation = 'ut16'
typeUTF8Text = 'utf8'

typeSInt16 = 'shor'
typeSInt32 = 'long'
typeUInt32 = 'magn'
typeSInt64 = 'comp'
typeIEEE32BitFloatingPoint = 'sing'
typeIEEE64BitFloatingPoint = 'doub'
type128BitFloatingPoint = 'ldbl'
typeDecimalStruct = 'decm'

typeSMInt = typeSInt16
typeShortInteger = typeSInt16
typeInteger = typeSInt32
typeLongInteger = typeSInt32
typeMagnitude = typeUInt32
typeComp = typeSInt64
typeSMFloat = typeIEEE32BitFloatingPoint
typeShortFloat = typeIEEE32BitFloatingPoint
typeFloat = typeIEEE64BitFloatingPoint
typeLongFloat = typeIEEE64BitFloatingPoint
typeExtended = 'exte'

typeAEList = 'list'
typeAERecord = 'reco'
typeAppleEvent = 'aevt'
typeEventRecord = 'evrc'
typeTrue = 'true'
typeFalse = 'fals'
typeAlias = 'alis'
typeEnumerated = 'enum'
typeType = 'type'
typeAppParameters = 'appa'
typeProperty = 'prop'
typeFSS = 'fss '
typeFSRef = 'fsrf'
typeFileURL = 'furl'
typeKeyword = 'keyw'
typeSectionH = 'sect'
typeWildCard = '****'
typeApplSignature = 'sign'
typeQDRectangle = 'qdrt'
typeFixed = 'fixd'
typeProcessSerialNumber = 'psn '
typeApplicationURL = 'aprl'
typeNull = 'null'

typeKernelProcessID = 'kpid'
typeMachPort = 'port'

typeApplicationBundleID = 'bund'

keyTransactionIDAttr = 'tran'
keyReturnIDAttr = 'rtid'
keyEventClassAttr = 'evcl'
keyEventIDAttr = 'evid'
keyAddressAttr = 'addr'
keyOptionalKeywordAttr = 'optk'
keyTimeoutAttr = 'timo'
keyInteractLevelAttr = 'inte'
keyEventSourceAttr = 'esrc'
keyMissedKeywordAttr = 'miss'
keyOriginalAddressAttr = 'from'
keyAcceptTimeoutAttr = 'actm'
keyReplyRequestedAttr = 'repq'

kAEDebugPOSTHeader = (1 << 0)
kAEDebugReplyHeader = (1 << 1)
kAEDebugXMLRequest = (1 << 2)
kAEDebugXMLResponse = (1 << 3)
kAEDebugXMLDebugAll = 0xFFFFFFFF

kSOAP1999Schema = 'ss99'
kSOAP2001Schema = 'ss01'

keyUserNameAttr = 'unam'
keyUserPasswordAttr = 'pass'
keyDisableAuthenticationAttr = 'auth'
keyXMLDebuggingAttr = 'xdbg'
kAERPCClass = 'rpc '
kAEXMLRPCScheme = 'RPC2'
kAESOAPScheme = 'SOAP'
kAESharedScriptHandler = 'wscp'
keyRPCMethodName = 'meth'
keyRPCMethodParam = 'parm'
keyRPCMethodParamOrder = '/ord'
keyAEPOSTHeaderData = 'phed'
keyAEReplyHeaderData = 'rhed'
keyAEXMLRequestData = 'xreq'
keyAEXMLReplyData = 'xrep'
keyAdditionalHTTPHeaders = 'ahed'
keySOAPAction = 'sact'
keySOAPMethodNameSpace = 'mspc'
keySOAPMethodNameSpaceURI = 'mspu'
keySOAPSchemaVersion = 'ssch'

keySOAPStructureMetaData = '/smd'
keySOAPSMDNamespace = 'ssns'
keySOAPSMDNamespaceURI = 'ssnu'
keySOAPSMDType = 'sstp'

kAEUseHTTPProxyAttr = 'xupr'
kAEHTTPProxyPortAttr = 'xhtp'
kAEHTTPProxyHostAttr = 'xhth'

kAESocks4Protocol = 4
kAESocks5Protocol = 5

kAEUseSocksAttr = 'xscs'
kAESocksProxyAttr = 'xsok'
kAESocksHostAttr = 'xshs'
kAESocksPortAttr = 'xshp'
kAESocksUserAttr = 'xshu'
kAESocksPasswordAttr = 'xshw'

kAEDescListFactorNone = 0
kAEDescListFactorType = 4
kAEDescListFactorTypeAndSize = 8

kAutoGenerateReturnID = -1
kAnyTransactionID = 0

kAEDataArray = 0
kAEPackedArray = 1
kAEDescArray = 3
kAEKeyDescArray = 4

kAEHandleArray = 2

kAENormalPriority = 0x00000000
kAEHighPriority = 0x00000001

kAENoReply = 0x00000001
kAEQueueReply = 0x00000002
kAEWaitReply = 0x00000003
kAEDontReconnect = 0x00000080
kAEWantReceipt = 0x00000200
kAENeverInteract = 0x00000010
kAECanInteract = 0x00000020
kAEAlwaysInteract = 0x00000030
kAECanSwitchLayer = 0x00000040
kAEDontRecord = 0x00001000
kAEDontExecute = 0x00002000
kAEProcessNonReplyEvents = 0x00008000

kAEDefaultTimeout = -1
kNoTimeOut = -2



# AEHelpers.h

aeBuildSyntaxNoErr = 0
aeBuildSyntaxBadToken = 1
aeBuildSyntaxBadEOF = 2
aeBuildSyntaxNoEOF = 3
aeBuildSyntaxBadNegative = 4
aeBuildSyntaxMissingQuote = 5
aeBuildSyntaxBadHex = 6
aeBuildSyntaxOddHex = 7
aeBuildSyntaxNoCloseHex = 8
aeBuildSyntaxUncoercedHex = 9
aeBuildSyntaxNoCloseString = 10
aeBuildSyntaxBadDesc = 11
aeBuildSyntaxBadData = 12
aeBuildSyntaxNoCloseParen = 13
aeBuildSyntaxNoCloseBracket = 14
aeBuildSyntaxNoCloseBrace = 15
aeBuildSyntaxNoKey = 16
aeBuildSyntaxNoColon = 17
aeBuildSyntaxCoercedList = 18
aeBuildSyntaxUncoercedDoubleAt = 19



# AEMach.h

keyReplyPortAttr = 'repp'

typeReplyPortAttr = keyReplyPortAttr



# AEObjects.h

kAEAND = 'AND '
kAEOR = 'OR  '
kAENOT = 'NOT '
kAEFirst = 'firs'
kAELast = 'last'
kAEMiddle = 'midd'
kAEAny = 'any '
kAEAll = 'all '
kAENext = 'next'
kAEPrevious = 'prev'
keyAECompOperator = 'relo'
keyAELogicalTerms = 'term'
keyAELogicalOperator = 'logc'
keyAEObject1 = 'obj1'
keyAEObject2 = 'obj2'
keyAEDesiredClass = 'want'
keyAEContainer = 'from'
keyAEKeyForm = 'form'
keyAEKeyData = 'seld'

keyAERangeStart = 'star'
keyAERangeStop = 'stop'
keyDisposeTokenProc = 'xtok'
keyAECompareProc = 'cmpr'
keyAECountProc = 'cont'
keyAEMarkTokenProc = 'mkid'
keyAEMarkProc = 'mark'
keyAEAdjustMarksProc = 'adjm'
keyAEGetErrDescProc = 'indc'

formAbsolutePosition = 'indx'
formRelativePosition = 'rele'
formTest = 'test'
formRange = 'rang'
formPropertyID = 'prop'
formName = 'name'
formUniqueID = 'ID  '
typeObjectSpecifier = 'obj '
typeObjectBeingExamined = 'exmn'
typeCurrentContainer = 'ccnt'
typeToken = 'toke'
typeRelativeDescriptor = 'rel '
typeAbsoluteOrdinal = 'abso'
typeIndexDescriptor = 'inde'
typeRangeDescriptor = 'rang'
typeLogicalDescriptor = 'logi'
typeCompDescriptor = 'cmpd'
typeOSLTokenList = 'ostl'

kAEIDoMinimum = 0x0000
kAEIDoWhose = 0x0001
kAEIDoMarking = 0x0004
kAEPassSubDescs = 0x0008
kAEResolveNestedLists = 0x0010
kAEHandleSimpleRanges = 0x0020
kAEUseRelativeIterators = 0x0040

typeWhoseDescriptor = 'whos'
formWhose = 'whos'
typeWhoseRange = 'wrng'
keyAEWhoseRangeStart = 'wstr'
keyAEWhoseRangeStop = 'wstp'
keyAEIndex = 'kidx'
keyAETest = 'ktst'



# AEPackObject.h



# AERegistry.h

cAEList = 'list'
cApplication = 'capp'
cArc = 'carc'
cBoolean = 'bool'
cCell = 'ccel'
cChar = 'cha '
cColorTable = 'clrt'
cColumn = 'ccol'
cDocument = 'docu'
cDrawingArea = 'cdrw'
cEnumeration = 'enum'
cFile = 'file'
cFixed = 'fixd'
cFixedPoint = 'fpnt'
cFixedRectangle = 'frct'
cGraphicLine = 'glin'
cGraphicObject = 'cgob'
cGraphicShape = 'cgsh'
cGraphicText = 'cgtx'
cGroupedGraphic = 'cpic'

cInsertionLoc = 'insl'
cInsertionPoint = 'cins'
cIntlText = 'itxt'
cIntlWritingCode = 'intl'
cItem = 'citm'
cLine = 'clin'
cLongDateTime = 'ldt '
cLongFixed = 'lfxd'
cLongFixedPoint = 'lfpt'
cLongFixedRectangle = 'lfrc'
cLongInteger = 'long'
cLongPoint = 'lpnt'
cLongRectangle = 'lrct'
cMachineLoc = 'mLoc'
cMenu = 'cmnu'
cMenuItem = 'cmen'
cObject = 'cobj'
cObjectSpecifier = 'obj '
cOpenableObject = 'coob'
cOval = 'covl'

cParagraph = 'cpar'
cPICT = 'PICT'
cPixel = 'cpxl'
cPixelMap = 'cpix'
cPolygon = 'cpgn'
cProperty = 'prop'
cQDPoint = 'QDpt'
cQDRectangle = 'qdrt'
cRectangle = 'crec'
cRGBColor = 'cRGB'
cRotation = 'trot'
cRoundedRectangle = 'crrc'
cRow = 'crow'
cSelection = 'csel'
cShortInteger = 'shor'
cTable = 'ctbl'
cText = 'ctxt'
cTextFlow = 'cflo'
cTextStyles = 'tsty'
cType = 'type'

cVersion = 'vers'
cWindow = 'cwin'
cWord = 'cwor'
enumArrows = 'arro'
enumJustification = 'just'
enumKeyForm = 'kfrm'
enumPosition = 'posi'
enumProtection = 'prtn'
enumQuality = 'qual'
enumSaveOptions = 'savo'
enumStyle = 'styl'
enumTransferMode = 'tran'
kAEAbout = 'abou'
kAEAfter = 'afte'
kAEAliasSelection = 'sali'
kAEAllCaps = 'alcp'
kAEArrowAtEnd = 'aren'
kAEArrowAtStart = 'arst'
kAEArrowBothEnds = 'arbo'

kAEAsk = 'ask '
kAEBefore = 'befo'
kAEBeginning = 'bgng'
kAEBeginsWith = 'bgwt'
kAEBeginTransaction = 'begi'
kAEBold = 'bold'
kAECaseSensEquals = 'cseq'
kAECentered = 'cent'
kAEChangeView = 'view'
kAEClone = 'clon'
kAEClose = 'clos'
kAECondensed = 'cond'
kAEContains = 'cont'
kAECopy = 'copy'
kAECoreSuite = 'core'
kAECountElements = 'cnte'
kAECreateElement = 'crel'
kAECreatePublisher = 'cpub'
kAECut = 'cut '
kAEDelete = 'delo'

kAEDoObjectsExist = 'doex'
kAEDoScript = 'dosc'
kAEDrag = 'drag'
kAEDuplicateSelection = 'sdup'
kAEEditGraphic = 'edit'
kAEEmptyTrash = 'empt'
kAEEnd = 'end '
kAEEndsWith = 'ends'
kAEEndTransaction = 'endt'
kAEEquals = '=   '
kAEExpanded = 'pexp'
kAEFast = 'fast'
kAEFinderEvents = 'FNDR'
kAEFormulaProtect = 'fpro'
kAEFullyJustified = 'full'
kAEGetClassInfo = 'qobj'
kAEGetData = 'getd'
kAEGetDataSize = 'dsiz'
kAEGetEventInfo = 'gtei'
kAEGetInfoSelection = 'sinf'

kAEGetPrivilegeSelection = 'sprv'
kAEGetSuiteInfo = 'gtsi'
kAEGreaterThan = '>   '
kAEGreaterThanEquals = '>=  '
kAEGrow = 'grow'
kAEHidden = 'hidn'
kAEHiQuality = 'hiqu'
kAEImageGraphic = 'imgr'
kAEIsUniform = 'isun'
kAEItalic = 'ital'
kAELeftJustified = 'left'
kAELessThan = '<   '
kAELessThanEquals = '<=  '
kAELowercase = 'lowc'
kAEMakeObjectsVisible = 'mvis'
kAEMiscStandards = 'misc'
kAEModifiable = 'modf'
kAEMove = 'move'
kAENo = 'no  '
kAENoArrow = 'arno'

kAENonmodifiable = 'nmod'
kAEOpen = 'odoc'
kAEOpenSelection = 'sope'
kAEOutline = 'outl'
kAEPageSetup = 'pgsu'
kAEPaste = 'past'
kAEPlain = 'plan'
kAEPrint = 'pdoc'
kAEPrintSelection = 'spri'
kAEPrintWindow = 'pwin'
kAEPutAwaySelection = 'sput'
kAEQDAddOver = 'addo'
kAEQDAddPin = 'addp'
kAEQDAdMax = 'admx'
kAEQDAdMin = 'admn'
kAEQDBic = 'bic '
kAEQDBlend = 'blnd'
kAEQDCopy = 'cpy '
kAEQDNotBic = 'nbic'
kAEQDNotCopy = 'ncpy'

kAEQDNotOr = 'ntor'
kAEQDNotXor = 'nxor'
kAEQDOr = 'or  '
kAEQDSubOver = 'subo'
kAEQDSubPin = 'subp'
kAEQDSupplementalSuite = 'qdsp'
kAEQDXor = 'xor '
kAEQuickdrawSuite = 'qdrw'
kAEQuitAll = 'quia'
kAERedo = 'redo'
kAERegular = 'regl'
kAEReopenApplication = 'rapp'
kAEReplace = 'rplc'
kAERequiredSuite = 'reqd'
kAERestart = 'rest'
kAERevealSelection = 'srev'
kAERevert = 'rvrt'
kAERightJustified = 'rght'
kAESave = 'save'
kAESelect = 'slct'
kAESetData = 'setd'

kAESetPosition = 'posn'
kAEShadow = 'shad'
kAEShowClipboard = 'shcl'
kAEShutDown = 'shut'
kAESleep = 'slep'
kAESmallCaps = 'smcp'
kAESpecialClassProperties = 'c@#!'
kAEStrikethrough = 'strk'
kAESubscript = 'sbsc'
kAESuperscript = 'spsc'
kAETableSuite = 'tbls'
kAETextSuite = 'TEXT'
kAETransactionTerminated = 'ttrm'
kAEUnderline = 'undl'
kAEUndo = 'undo'
kAEWholeWordEquals = 'wweq'
kAEYes = 'yes '
kAEZoom = 'zoom'

kAELogOut = 'logo'
kAEReallyLogOut = 'rlgo'
kAEShowRestartDialog = 'rrst'
kAEShowShutdownDialog = 'rsdn'

kAEMouseClass = 'mous'
kAEDown = 'down'
kAEUp = 'up  '
kAEMoved = 'move'
kAEStoppedMoving = 'stop'
kAEWindowClass = 'wind'
kAEUpdate = 'updt'
kAEActivate = 'actv'
kAEDeactivate = 'dact'
kAECommandClass = 'cmnd'
kAEKeyClass = 'keyc'
kAERawKey = 'rkey'
kAEVirtualKey = 'keyc'
kAENavigationKey = 'nave'
kAEAutoDown = 'auto'
kAEApplicationClass = 'appl'
kAESuspend = 'susp'
kAEResume = 'rsme'
kAEDiskEvent = 'disk'
kAENullEvent = 'null'
kAEWakeUpEvent = 'wake'
kAEScrapEvent = 'scrp'
kAEHighLevel = 'high'

keyAEAngle = 'kang'
keyAEArcAngle = 'parc'

keyAEBaseAddr = 'badd'
keyAEBestType = 'pbst'
keyAEBgndColor = 'kbcl'
keyAEBgndPattern = 'kbpt'
keyAEBounds = 'pbnd'
keyAECellList = 'kclt'
keyAEClassID = 'clID'
keyAEColor = 'colr'
keyAEColorTable = 'cltb'
keyAECurveHeight = 'kchd'
keyAECurveWidth = 'kcwd'
keyAEDashStyle = 'pdst'
keyAEData = 'data'
keyAEDefaultType = 'deft'
keyAEDefinitionRect = 'pdrt'
keyAEDescType = 'dstp'
keyAEDestination = 'dest'
keyAEDoAntiAlias = 'anta'
keyAEDoDithered = 'gdit'
keyAEDoRotate = 'kdrt'

keyAEDoScale = 'ksca'
keyAEDoTranslate = 'ktra'
keyAEEditionFileLoc = 'eloc'
keyAEElements = 'elms'
keyAEEndPoint = 'pend'
keyAEEventClass = 'evcl'
keyAEEventID = 'evti'
keyAEFile = 'kfil'
keyAEFileType = 'fltp'
keyAEFillColor = 'flcl'
keyAEFillPattern = 'flpt'
keyAEFlipHorizontal = 'kfho'
keyAEFlipVertical = 'kfvt'
keyAEFont = 'font'
keyAEFormula = 'pfor'
keyAEGraphicObjects = 'gobs'
keyAEID = 'ID  '
keyAEImageQuality = 'gqua'
keyAEInsertHere = 'insh'
keyAEKeyForms = 'keyf'

keyAEKeyword = 'kywd'
keyAELevel = 'levl'
keyAELineArrow = 'arro'
keyAEName = 'pnam'
keyAENewElementLoc = 'pnel'
keyAEObject = 'kobj'
keyAEObjectClass = 'kocl'
keyAEOffStyles = 'ofst'
keyAEOnStyles = 'onst'
keyAEParameters = 'prms'
keyAEParamFlags = 'pmfg'
keyAEPenColor = 'ppcl'
keyAEPenPattern = 'pppa'
keyAEPenWidth = 'ppwd'
keyAEPixelDepth = 'pdpt'
keyAEPixMapMinus = 'kpmm'
keyAEPMTable = 'kpmt'
keyAEPointList = 'ptlt'
keyAEPointSize = 'ptsz'
keyAEPosition = 'kpos'

keyAEPropData = 'prdt'
keyAEProperties = 'qpro'
keyAEProperty = 'kprp'
keyAEPropFlags = 'prfg'
keyAEPropID = 'prop'
keyAEProtection = 'ppro'
keyAERenderAs = 'kren'
keyAERequestedType = 'rtyp'
keyAEResult = '----'
keyAEResultInfo = 'rsin'
keyAERotation = 'prot'
keyAERotPoint = 'krtp'
keyAERowList = 'krls'
keyAESaveOptions = 'savo'
keyAEScale = 'pscl'
keyAEScriptTag = 'psct'
keyAESearchText = 'stxt'
keyAEShowWhere = 'show'
keyAEStartAngle = 'pang'
keyAEStartPoint = 'pstp'
keyAEStyles = 'ksty'

keyAESuiteID = 'suit'
keyAEText = 'ktxt'
keyAETextColor = 'ptxc'
keyAETextFont = 'ptxf'
keyAETextPointSize = 'ptps'
keyAETextStyles = 'txst'
keyAETextLineHeight = 'ktlh'
keyAETextLineAscent = 'ktas'
keyAETheText = 'thtx'
keyAETransferMode = 'pptm'
keyAETranslation = 'ptrs'
keyAETryAsStructGraf = 'toog'
keyAEUniformStyles = 'ustl'
keyAEUpdateOn = 'pupd'
keyAEUserTerm = 'utrm'
keyAEWindow = 'wndw'
keyAEWritingCode = 'wrcd'

keyMiscellaneous = 'fmsc'
keySelection = 'fsel'
keyWindow = 'kwnd'
keyWhen = 'when'
keyWhere = 'wher'
keyModifiers = 'mods'
keyKey = 'key '
keyKeyCode = 'code'
keyKeyboard = 'keyb'
keyDriveNumber = 'drv#'
keyErrorCode = 'err#'
keyHighLevelClass = 'hcls'
keyHighLevelID = 'hid '

pArcAngle = 'parc'
pBackgroundColor = 'pbcl'
pBackgroundPattern = 'pbpt'
pBestType = 'pbst'
pBounds = 'pbnd'
pClass = 'pcls'
pClipboard = 'pcli'
pColor = 'colr'
pColorTable = 'cltb'
pContents = 'pcnt'
pCornerCurveHeight = 'pchd'
pCornerCurveWidth = 'pcwd'
pDashStyle = 'pdst'
pDefaultType = 'deft'
pDefinitionRect = 'pdrt'
pEnabled = 'enbl'
pEndPoint = 'pend'
pFillColor = 'flcl'
pFillPattern = 'flpt'
pFont = 'font'

pFormula = 'pfor'
pGraphicObjects = 'gobs'
pHasCloseBox = 'hclb'
pHasTitleBar = 'ptit'
pID = 'ID  '
pIndex = 'pidx'
pInsertionLoc = 'pins'
pIsFloating = 'isfl'
pIsFrontProcess = 'pisf'
pIsModal = 'pmod'
pIsModified = 'imod'
pIsResizable = 'prsz'
pIsStationeryPad = 'pspd'
pIsZoomable = 'iszm'
pIsZoomed = 'pzum'
pItemNumber = 'itmn'
pJustification = 'pjst'
pLineArrow = 'arro'
pMenuID = 'mnid'
pName = 'pnam'

pNewElementLoc = 'pnel'
pPenColor = 'ppcl'
pPenPattern = 'pppa'
pPenWidth = 'ppwd'
pPixelDepth = 'pdpt'
pPointList = 'ptlt'
pPointSize = 'ptsz'
pProtection = 'ppro'
pRotation = 'prot'
pScale = 'pscl'
pScript = 'scpt'
pScriptTag = 'psct'
pSelected = 'selc'
pSelection = 'sele'
pStartAngle = 'pang'
pStartPoint = 'pstp'
pTextColor = 'ptxc'
pTextFont = 'ptxf'
pTextItemDelimiters = 'txdl'
pTextPointSize = 'ptps'

pTextStyles = 'txst'
pTransferMode = 'pptm'
pTranslation = 'ptrs'
pUniformStyles = 'ustl'
pUpdateOn = 'pupd'
pUserSelection = 'pusl'
pVersion = 'vers'
pVisible = 'pvis'

typeAEText = 'tTXT'
typeArc = 'carc'
typeBest = 'best'
typeCell = 'ccel'
typeClassInfo = 'gcli'
typeColorTable = 'clrt'
typeColumn = 'ccol'
typeDashStyle = 'tdas'
typeData = 'tdta'
typeDrawingArea = 'cdrw'
typeElemInfo = 'elin'
typeEnumeration = 'enum'
typeEPS = 'EPS '
typeEventInfo = 'evin'

typeFinderWindow = 'fwin'
typeFixedPoint = 'fpnt'
typeFixedRectangle = 'frct'
typeGraphicLine = 'glin'
typeGraphicText = 'cgtx'
typeGroupedGraphic = 'cpic'
typeInsertionLoc = 'insl'
typeIntlText = 'itxt'
typeIntlWritingCode = 'intl'
typeLongDateTime = 'ldt '
typeISO8601DateTime = 'isot'
typeLongFixed = 'lfxd'
typeLongFixedPoint = 'lfpt'
typeLongFixedRectangle = 'lfrc'
typeLongPoint = 'lpnt'
typeLongRectangle = 'lrct'
typeMachineLoc = 'mLoc'
typeOval = 'covl'
typeParamInfo = 'pmin'
typePict = 'PICT'

typePixelMap = 'cpix'
typePixMapMinus = 'tpmm'
typePolygon = 'cpgn'
typePropInfo = 'pinf'
typePtr = 'ptr '
typeQDPoint = 'QDpt'
typeQDRegion = 'Qrgn'
typeRectangle = 'crec'
typeRGB16 = 'tr16'
typeRGB96 = 'tr96'
typeRGBColor = 'cRGB'
typeRotation = 'trot'
typeRoundedRectangle = 'crrc'
typeRow = 'crow'
typeScrapStyles = 'styl'
typeScript = 'scpt'
typeStyledText = 'STXT'
typeSuiteInfo = 'suin'
typeTable = 'ctbl'
typeTextStyles = 'tsty'

typeTIFF = 'TIFF'
typeJPEG = 'JPEG'
typeGIF = 'GIFf'
typeVersion = 'vers'

kAEMenuClass = 'menu'
kAEMenuSelect = 'mhit'
kAEMouseDown = 'mdwn'
kAEMouseDownInBack = 'mdbk'
kAEKeyDown = 'kdwn'
kAEResized = 'rsiz'
kAEPromise = 'prom'

keyMenuID = 'mid '
keyMenuItem = 'mitm'
keyCloseAllWindows = 'caw '
keyOriginalBounds = 'obnd'
keyNewBounds = 'nbnd'
keyLocalWhere = 'lwhr'

typeHIMenu = 'mobj'
typeHIWindow = 'wobj'

kBySmallIcon = 0
kByIconView = 1
kByNameView = 2
kByDateView = 3
kBySizeView = 4
kByKindView = 5
kByCommentView = 6
kByLabelView = 7
kByVersionView = 8

kAEInfo = 11
kAEMain = 0
kAESharing = 13

kAEZoomIn = 7
kAEZoomOut = 8

kTextServiceClass = 'tsvc'
kUpdateActiveInputArea = 'updt'
kShowHideInputWindow = 'shiw'
kPos2Offset = 'p2st'
kOffset2Pos = 'st2p'
kUnicodeNotFromInputMethod = 'unim'
kGetSelectedText = 'gtxt'
keyAETSMDocumentRefcon = 'refc'
keyAEServerInstance = 'srvi'
keyAETheData = 'kdat'
keyAEFixLength = 'fixl'
keyAEUpdateRange = 'udng'
keyAECurrentPoint = 'cpos'
keyAEBufferSize = 'buff'
keyAEMoveView = 'mvvw'
keyAENextBody = 'nxbd'
keyAETSMScriptTag = 'sclg'
keyAETSMTextFont = 'ktxf'
keyAETSMTextFMFont = 'ktxm'
keyAETSMTextPointSize = 'ktps'
keyAETSMEventRecord = 'tevt'
keyAETSMEventRef = 'tevr'
keyAETextServiceEncoding = 'tsen'
keyAETextServiceMacEncoding = 'tmen'
keyAETSMGlyphInfoArray = 'tgia'
typeTextRange = 'txrn'
typeComponentInstance = 'cmpi'
typeOffsetArray = 'ofay'
typeTextRangeArray = 'tray'
typeLowLevelEventRecord = 'evtr'
typeGlyphInfoArray = 'glia'
typeEventRef = 'evrf'
typeText = typeChar

kTSMOutsideOfBody = 1
kTSMInsideOfBody = 2
kTSMInsideOfActiveInputArea = 3

kNextBody = 1
kPreviousBody = 2

kTSMHiliteCaretPosition = 1
kTSMHiliteRawText = 2
kTSMHiliteSelectedRawText = 3
kTSMHiliteConvertedText = 4
kTSMHiliteSelectedConvertedText = 5
kTSMHiliteBlockFillText = 6
kTSMHiliteOutlineText = 7
kTSMHiliteSelectedText = 8
kTSMHiliteNoHilite = 9

kCaretPosition = kTSMHiliteCaretPosition
kRawText = kTSMHiliteRawText
kSelectedRawText = kTSMHiliteSelectedRawText
kConvertedText = kTSMHiliteConvertedText
kSelectedConvertedText = kTSMHiliteSelectedConvertedText
kBlockFillText = kTSMHiliteBlockFillText
kOutlineText = kTSMHiliteOutlineText
kSelectedText = kTSMHiliteSelectedText

keyAEHiliteRange = 'hrng'
keyAEPinRange = 'pnrg'
keyAEClauseOffsets = 'clau'
keyAEOffset = 'ofst'
keyAEPoint = 'gpos'
keyAELeftSide = 'klef'
keyAERegionClass = 'rgnc'
keyAEDragging = 'bool'

keyAELeadingEdge = keyAELeftSide

typeMeters = 'metr'
typeInches = 'inch'
typeFeet = 'feet'
typeYards = 'yard'
typeMiles = 'mile'
typeKilometers = 'kmtr'
typeCentimeters = 'cmtr'
typeSquareMeters = 'sqrm'
typeSquareFeet = 'sqft'
typeSquareYards = 'sqyd'
typeSquareMiles = 'sqmi'
typeSquareKilometers = 'sqkm'
typeLiters = 'litr'
typeQuarts = 'qrts'
typeGallons = 'galn'
typeCubicMeters = 'cmet'
typeCubicFeet = 'cfet'
typeCubicInches = 'cuin'
typeCubicCentimeter = 'ccmt'
typeCubicYards = 'cyrd'
typeKilograms = 'kgrm'
typeGrams = 'gram'
typeOunces = 'ozs '
typePounds = 'lbs '
typeDegreesC = 'degc'
typeDegreesF = 'degf'
typeDegreesK = 'degk'

kFAServerApp = 'ssrv'
kDoFolderActionEvent = 'fola'
kFolderActionCode = 'actn'
kFolderOpenedEvent = 'fopn'
kFolderClosedEvent = 'fclo'
kFolderWindowMovedEvent = 'fsiz'
kFolderItemsAddedEvent = 'fget'
kFolderItemsRemovedEvent = 'flos'
kItemList = 'flst'
kNewSizeParameter = 'fnsz'
kFASuiteCode = 'faco'
kFAAttachCommand = 'atfa'
kFARemoveCommand = 'rmfa'
kFAEditCommand = 'edfa'
kFAFileParam = 'faal'
kFAIndexParam = 'indx'

kAEInternetSuite = 'gurl'
kAEISWebStarSuite = 'WWW\xBD'

kAEISGetURL = 'gurl'
KAEISHandleCGI = 'sdoc'

cURL = 'url '
cInternetAddress = 'IPAD'
cHTML = 'html'
cFTPItem = 'ftp '

kAEISHTTPSearchArgs = 'kfor'
kAEISPostArgs = 'post'
kAEISMethod = 'meth'
kAEISClientAddress = 'addr'
kAEISUserName = 'user'
kAEISPassword = 'pass'
kAEISFromUser = 'frmu'
kAEISServerName = 'svnm'
kAEISServerPort = 'svpt'
kAEISScriptName = 'scnm'
kAEISContentType = 'ctyp'
kAEISReferrer = 'refr'
kAEISUserAgent = 'Agnt'
kAEISAction = 'Kact'
kAEISActionPath = 'Kapt'
kAEISClientIP = 'Kcip'
kAEISFullRequest = 'Kfrq'

pScheme = 'pusc'
pHost = 'HOST'
pPath = 'FTPc'
pUserName = 'RAun'
pUserPassword = 'RApw'
pDNSForm = 'pDNS'
pURL = 'pURL'
pTextEncoding = 'ptxe'
pFTPKind = 'kind'

eScheme = 'esch'
eurlHTTP = 'http'
eurlHTTPS = 'htps'
eurlFTP = 'ftp '
eurlMail = 'mail'
eurlFile = 'file'
eurlGopher = 'gphr'
eurlTelnet = 'tlnt'
eurlNews = 'news'
eurlSNews = 'snws'
eurlNNTP = 'nntp'
eurlMessage = 'mess'
eurlMailbox = 'mbox'
eurlMulti = 'mult'
eurlLaunch = 'laun'
eurlAFP = 'afp '
eurlAT = 'at  '
eurlEPPC = 'eppc'
eurlRTSP = 'rtsp'
eurlIMAP = 'imap'
eurlNFS = 'unfs'
eurlPOP = 'upop'
eurlLDAP = 'uldp'
eurlUnknown = 'url?'

kConnSuite = 'macc'
cDevSpec = 'cdev'
cAddressSpec = 'cadr'
cADBAddress = 'cadb'
cAppleTalkAddress = 'cat '
cBusAddress = 'cbus'
cEthernetAddress = 'cen '
cFireWireAddress = 'cfw '
cIPAddress = 'cip '
cLocalTalkAddress = 'clt '
cSCSIAddress = 'cscs'
cTokenRingAddress = 'ctok'
cUSBAddress = 'cusb'
pDeviceType = 'pdvt'
pDeviceAddress = 'pdva'
pConduit = 'pcon'
pProtocol = 'pprt'
pATMachine = 'patm'
pATZone = 'patz'
pATType = 'patt'
pDottedDecimal = 'pipd'
pDNS = 'pdns'
pPort = 'ppor'
pNetwork = 'pnet'
pNode = 'pnod'
pSocket = 'psoc'
pSCSIBus = 'pscb'
pSCSILUN = 'pslu'
eDeviceType = 'edvt'
eAddressSpec = 'eads'
eConduit = 'econ'
eProtocol = 'epro'
eADB = 'eadb'
eAnalogAudio = 'epau'
eAppleTalk = 'epat'
eAudioLineIn = 'ecai'
eAudioLineOut = 'ecal'
eAudioOut = 'ecao'
eBus = 'ebus'
eCDROM = 'ecd '
eCommSlot = 'eccm'
eDigitalAudio = 'epda'
eDisplay = 'edds'
eDVD = 'edvd'
eEthernet = 'ecen'
eFireWire = 'ecfw'
eFloppy = 'efd '
eHD = 'ehd '
eInfrared = 'ecir'
eIP = 'epip'
eIrDA = 'epir'
eIRTalk = 'epit'
eKeyboard = 'ekbd'
eLCD = 'edlc'
eLocalTalk = 'eclt'
eMacIP = 'epmi'
eMacVideo = 'epmv'
eMicrophone = 'ecmi'
eModemPort = 'ecmp'
eModemPrinterPort = 'empp'
eModem = 'edmm'
eMonitorOut = 'ecmn'
eMouse = 'emou'
eNuBusCard = 'ednb'
eNuBus = 'enub'
ePCcard = 'ecpc'
ePCIbus = 'ecpi'
ePCIcard = 'edpi'
ePDSslot = 'ecpd'
ePDScard = 'epds'
ePointingDevice = 'edpd'
ePostScript = 'epps'
ePPP = 'eppp'
ePrinterPort = 'ecpp'
ePrinter = 'edpr'
eSvideo = 'epsv'
eSCSI = 'ecsc'
eSerial = 'epsr'
eSpeakers = 'edsp'
eStorageDevice = 'edst'
eSVGA = 'epsg'
eTokenRing = 'etok'
eTrackball = 'etrk'
eTrackpad = 'edtp'
eUSB = 'ecus'
eVideoIn = 'ecvi'
eVideoMonitor = 'edvm'
eVideoOut = 'ecvo'

cKeystroke = 'kprs'
pKeystrokeKey = 'kMsg'
pModifiers = 'kMod'
pKeyKind = 'kknd'
eModifiers = 'eMds'
eOptionDown = 'Kopt'
eCommandDown = 'Kcmd'
eControlDown = 'Kctl'
eShiftDown = 'Ksft'
eCapsLockDown = 'Kclk'
eKeyKind = 'ekst'
eEscapeKey = 'ks5\x00'
eDeleteKey = 'ks3\x00'
eTabKey = 'ks0\x00'
eReturnKey = 'ks\x24\x00'
eClearKey = 'ksG\x00'
eEnterKey = 'ksL\x00'
eUpArrowKey = 'ks\x7E\x00'
eDownArrowKey = 'ks\x7D\x00'
eLeftArrowKey = 'ks\x7B\x00'
eRightArrowKey = 'ks\x7C\x00'
eHelpKey = 'ksr\x00'
eHomeKey = 'kss\x00'
ePageUpKey = 'kst\x00'
ePageDownKey = 'ksy\x00'
eForwardDelKey = 'ksu\x00'
eEndKey = 'ksw\x00'
eF1Key = 'ksz\x00'
eF2Key = 'ksx\x00'
eF3Key = 'ksc\x00'
eF4Key = 'ksv\x00'
eF5Key = 'ks\x60\x00'
eF6Key = 'ksa\x00'
eF7Key = 'ksb\x00'
eF8Key = 'ksd\x00'
eF9Key = 'kse\x00'
eF10Key = 'ksm\x00'
eF11Key = 'ksg\x00'
eF12Key = 'kso\x00'
eF13Key = 'ksi\x00'
eF14Key = 'ksk\x00'
eF15Key = 'ksq\x00'

keyAEQuitWithoutUI = 'noui'



# AEUserTermTypes.h

kAEUserTerminology = 'aeut'
kAETerminologyExtension = 'aete'
kAEScriptingSizeResource = 'scsz'
kAEOSAXSizeResource = 'osiz'

kAEUTHasReturningParam = 31
kAEUTOptional = 15
kAEUTlistOfItems = 14
kAEUTEnumerated = 13
kAEUTReadWrite = 12
kAEUTChangesState = 12
kAEUTTightBindingFunction = 12
kAEUTEnumsAreTypes = 11
kAEUTEnumListIsExclusive = 10
kAEUTReplyIsReference = 9
kAEUTDirectParamIsReference = 9
kAEUTParamIsReference = 9
kAEUTPropertyIsReference = 9
kAEUTNotDirectParamIsTarget = 8
kAEUTParamIsTarget = 8
kAEUTApostrophe = 3
kAEUTFeminine = 2
kAEUTMasculine = 1
kAEUTPlural = 0

kLaunchToGetTerminology = (1 << 15)
kDontFindAppBySignature = (1 << 14)
kAlwaysSendSubject = (1 << 13)

kReadExtensionTermsMask = (1 << 15)

kOSIZDontOpenResourceFile = 15
kOSIZdontAcceptRemoteEvents = 14
kOSIZOpenWithReadPermission = 13
kOSIZCodeInSharedLibraries = 11



# AppleEvents.h

keyDirectObject = '----'
keyErrorNumber = 'errn'
keyErrorString = 'errs'
keyProcessSerialNumber = 'psn '
keyPreDispatch = 'phac'
keySelectProc = 'selh'
keyAERecorderCount = 'recr'
keyAEVersion = 'vers'

kCoreEventClass = 'aevt'

kAEOpenApplication = 'oapp'
kAEOpenDocuments = 'odoc'
kAEPrintDocuments = 'pdoc'
kAEOpenContents = 'ocon'
kAEQuitApplication = 'quit'
kAEAnswer = 'ansr'
kAEApplicationDied = 'obit'
kAEShowPreferences = 'pref'
kAEAutosaveNow = 'asav'

kAEStartRecording = 'reca'
kAEStopRecording = 'recc'
kAENotifyStartRecording = 'rec1'
kAENotifyStopRecording = 'rec0'
kAENotifyRecording = 'recr'

kAEUnknownSource = 0
kAEDirectCall = 1
kAESameProcess = 2
kAELocalProcess = 3
kAERemoteProcess = 4



# AEInteraction.h

kAEInteractWithSelf = 0
kAEInteractWithLocal = 1
kAEInteractWithAll = 2

kAEDoNotIgnoreHandler = 0x00000000
kAEIgnoreAppPhacHandler = 0x00000001
kAEIgnoreAppEventHandler = 0x00000002
kAEIgnoreSysPhacHandler = 0x00000004
kAEIgnoreSysEventHandler = 0x00000008
kAEIngoreBuiltInEventHandler = 0x00000010
kAEDontDisposeOnResume = 0x80000000

kAENoDispatch = 0
kAEUseStandardDispatch = 0xFFFFFFFF

