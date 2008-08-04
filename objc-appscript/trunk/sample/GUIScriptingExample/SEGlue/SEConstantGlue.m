/*
 * SEConstantGlue.m
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.4.0
 *
 */

#import "SEConstantGlue.h"

@implementation SEConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'dfph': return [self ApplePhotoFormat];
        case 'dfas': return [self AppleShareFormat];
        case 'apr ': return [self April];
        case 'aug ': return [self August];
        case 'dhao': return [self CDAndDVDPreferencesObject];
        case 'clsc': return [self Classic];
        case 'fldc': return [self ClassicDomain];
        case 'domc': return [self ClassicDomainObject];
        case 'dec ': return [self December];
        case 'EPS ': return [self EPSPicture];
        case 'F1ky': return [self F1];
        case 'F10k': return [self F10];
        case 'F11k': return [self F11];
        case 'F12k': return [self F12];
        case 'F13k': return [self F13];
        case 'F2ky': return [self F2];
        case 'F3ky': return [self F3];
        case 'F4ky': return [self F4];
        case 'F5ky': return [self F5];
        case 'F6ky': return [self F6];
        case 'F7ky': return [self F7];
        case 'F8ky': return [self F8];
        case 'F9ky': return [self F9];
        case 'feb ': return [self February];
        case 'fasf': return [self FolderActionScriptsFolder];
        case 'fri ': return [self Friday];
        case 'GIFf': return [self GIFPicture];
        case 'dfhs': return [self HighSierraFormat];
        case 'df96': return [self ISO9660Format];
        case 'JPEG': return [self JPEGPicture];
        case 'jan ': return [self January];
        case 'jul ': return [self July];
        case 'jun ': return [self June];
        case 'maca': return [self MACAddress];
        case 'dfms': return [self MSDOSFormat];
        case 'dfh+': return [self MacOSExtendedFormat];
        case 'dfhf': return [self MacOSFormat];
        case 'mar ': return [self March];
        case 'may ': return [self May];
        case 'mon ': return [self Monday];
        case 'dfnf': return [self NFSFormat];
        case 'nov ': return [self November];
        case 'oct ': return [self October];
        case 'PICT': return [self PICTPicture];
        case 'posx': return [self POSIXPath];
        case 'dfpr': return [self ProDOSFormat];
        case 'dfqt': return [self QuickTakeFormat];
        case 'qtfd': return [self QuickTimeData];
        case 'qtff': return [self QuickTimeFile];
        case 'tr16': return [self RGB16Color];
        case 'tr96': return [self RGB96Color];
        case 'cRGB': return [self RGBColor];
        case 'sat ': return [self Saturday];
        case 'sep ': return [self September];
        case 'sun ': return [self Sunday];
        case 'TIFF': return [self TIFFPicture];
        case 'thu ': return [self Thursday];
        case 'tue ': return [self Tuesday];
        case 'dfud': return [self UDFFormat];
        case 'dfuf': return [self UFSFormat];
        case 'uiel': return [self UIElement];
        case 'uien': return [self UIElementsEnabled];
        case 'url ': return [self URL];
        case 'dfwd': return [self WebDAVFormat];
        case 'wed ': return [self Wednesday];
        case 'xmla': return [self XMLAttribute];
        case 'xmld': return [self XMLData];
        case 'xmle': return [self XMLElement];
        case 'xmlf': return [self XMLFile];
        case 'isab': return [self acceptsHighLevelEvents];
        case 'revt': return [self acceptsRemoteEvents];
        case 'user': return [self accountName];
        case 'actT': return [self action];
        case 'acti': return [self active];
        case 'epsa': return [self activity];
        case 'alis': return [self alias];
        case 'allw': return [self allWindows];
        case 'epaw': return [self allWindowsShortcut];
        case 'dani': return [self animate];
        case 'anno': return [self annotation];
        case '****': return [self anything];
        case 'appe': return [self appearance];
        case 'aprp': return [self appearancePreferences];
        case 'apro': return [self appearancePreferencesObject];
        case 'amnu': return [self appleMenuFolder];
        case 'capp': return [self application];
        case 'bund': return [self applicationBundleID];
        case 'appf': return [self applicationFile];
        case 'pcap': return [self applicationProcess];
        case 'rmte': return [self applicationResponses];
        case 'sign': return [self applicationSignature];
        case 'asup': return [self applicationSupportFolder];
        case 'aprl': return [self applicationURL];
        case 'appw': return [self applicationWindows];
        case 'eppw': return [self applicationWindowsShortcut];
        case 'apps': return [self applicationsFolder];
        case 'arch': return [self architecture];
        case 'spam': return [self arrowKeyModifiers];
        case 'ask ': return [self ask];
        case 'dhas': return [self askWhatToDo];
        case 'atts': return [self attachment];
        case 'attr': return [self attribute];
        case 'catr': return [self attributeRun];
        case 'acha': return [self audioChannelCount];
        case 'audi': return [self audioCharacteristic];
        case 'audd': return [self audioData];
        case 'audf': return [self audioFile];
        case 'dfau': return [self audioFormat];
        case 'asra': return [self audioSampleRate];
        case 'assz': return [self audioSampleSize];
        case 'autp': return [self autoPlay];
        case 'apre': return [self autoPresent];
        case 'aqui': return [self autoQuitWhenDone];
        case 'dahd': return [self autohide];
        case 'autm': return [self automatic];
        case 'auto': return [self automatic];
        case 'aulg': return [self automaticLogin];
        case 'bkgo': return [self backgroundOnly];
        case 'best': return [self best];
        case 'dhbc': return [self blankCD];
        case 'dhbd': return [self blankDVD];
        case 'blue': return [self blue];
        case 'bool': return [self boolean];
        case 'bott': return [self bottom];
        case 'epbl': return [self bottomLeftScreenCorner];
        case 'epbr': return [self bottomRightScreenCorner];
        case 'qdrt': return [self boundingRectangle];
        case 'pbnd': return [self bounds];
        case 'broW': return [self browser];
        case 'bnid': return [self bundleIdentifier];
        case 'busi': return [self busyIndicator];
        case 'busy': return [self busyStatus];
        case 'butT': return [self button];
        case 'capa': return [self capacity];
        case 'case': return [self case_];
        case 'cmtr': return [self centimeters];
        case 'cinT': return [self changeInterval];
        case 'cha ': return [self character];
        case 'chbx': return [self checkbox];
        case 'gcli': return [self classInfo];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'clrt': return [self colorTable];
        case 'colW': return [self colorWell];
        case 'ccol': return [self column];
        case 'comB': return [self comboBox];
        case 'cmdm': return [self command];
        case 'eCmd': return [self command];
        case 'Kcmd': return [self commandDown];
        case 'conF': return [self configuration];
        case 'conn': return [self connected];
        case 'ctnr': return [self container];
        case 'pcnt': return [self contents];
        case 'eCnt': return [self control];
        case 'ctlm': return [self control];
        case 'Kctl': return [self controlDown];
        case 'ctrl': return [self controlPanelsFolder];
        case 'sdev': return [self controlStripModulesFolder];
        case 'lwcp': return [self copies];
        case 'ascd': return [self creationDate];
        case 'mdcr': return [self creationTime];
        case 'fcrt': return [self creatorType];
        case 'ccmt': return [self cubicCentimeters];
        case 'cfet': return [self cubicFeet];
        case 'cuin': return [self cubicInches];
        case 'cmet': return [self cubicMeters];
        case 'cyrd': return [self cubicYards];
        case 'cust': return [self current];
        case 'cnfg': return [self currentConfiguration];
        case 'curd': return [self currentDesktop];
        case 'locc': return [self currentLocation];
        case 'curu': return [self currentUser];
        case 'dhca': return [self customApplication];
        case 'dhcs': return [self customScript];
        case 'tdas': return [self dashStyle];
        case 'dash': return [self dashboard];
        case 'epdb': return [self dashboardShortcut];
        case 'rdat': return [self data];
        case 'tdfr': return [self dataFormat];
        case 'ddra': return [self dataRate];
        case 'dsiz': return [self dataSize];
        case 'ldt ': return [self date];
        case 'decm': return [self decimalStruct];
        case 'asda': return [self defaultApplication];
        case 'degc': return [self degreesCelsius];
        case 'degf': return [self degreesFahrenheit];
        case 'degk': return [self degreesKelvin];
        case 'desc': return [self description_];
        case 'dafi': return [self deskAccessoryFile];
        case 'pcda': return [self deskAccessoryProcess];
        case 'dskp': return [self desktop];
        case 'dtp$': return [self desktopPicturesFolder];
        case 'lwdt': return [self detailed];
        case 'diac': return [self diacriticals];
        case 'pdim': return [self dimensions];
        case 'disc': return [self disableScreenSaver];
        case 'cdis': return [self disk];
        case 'ditm': return [self diskItem];
        case 'dnaM': return [self displayName];
        case 'dnam': return [self displayedName];
        case 'dpas': return [self dockPreferences];
        case 'dpao': return [self dockPreferencesObject];
        case 'dsze': return [self dockSize];
        case 'docu': return [self document];
        case 'docs': return [self documentsFolder];
        case 'doma': return [self domain];
        case 'mndc': return [self doubleClickMinimizes];
        case 'comp': return [self doubleInteger];
        case 'doub': return [self double_];
        case 'down': return [self downloadsFolder];
        case 'draA': return [self drawer];
        case 'dupl': return [self duplex];
        case 'durn': return [self duration];
        case 'isej': return [self ejectable];
        case 'elin': return [self elementInfo];
        case 'enaB': return [self enabled];
        case 'encs': return [self encodedString];
        case 'lwlp': return [self endingPage];
        case 'ects': return [self entireContents];
        case 'enum': return [self enumerator];
        case 'lweh': return [self errorHandling];
        case 'evin': return [self eventInfo];
        case 'expa': return [self expansion];
        case 'epas': return [self exposePreferences];
        case 'epao': return [self exposePreferencesObject];
        case 'exte': return [self extendedFloat];
        case 'extz': return [self extensionsFolder];
        case 'favs': return [self favoritesFolder];
        case 'faxn': return [self faxNumber];
        case 'feet': return [self feet];
        case 'file': return [self file];
        case 'atfn': return [self fileName];
        case 'cpkg': return [self filePackage];
        case 'fsrf': return [self fileRef];
        case 'fss ': return [self fileSpecification];
        case 'asty': return [self fileType];
        case 'furl': return [self fileURL];
        case 'fixd': return [self fixed];
        case 'fpnt': return [self fixedPoint];
        case 'frct': return [self fixedRectangle];
        case 'ldbl': return [self float128bit];
        case 'isfl': return [self floating];
        case 'focu': return [self focused];
        case 'cfol': return [self folder];
        case 'foac': return [self folderAction];
        case 'faen': return [self folderActionsEnabled];
        case 'ftsm': return [self fontSmoothingLimit];
        case 'ftss': return [self fontSmoothingStyle];
        case 'font': return [self fontsFolder];
        case 'dfmt': return [self format];
        case 'frsp': return [self freeSpace];
        case 'pisf': return [self frontmost];
        case 'fnam': return [self fullName];
        case 'anot': return [self fullText];
        case 'epsk': return [self functionKey];
        case 'epsy': return [self functionKeyModifiers];
        case 'galn': return [self gallons];
        case 'geni': return [self genie];
        case 'gold': return [self gold];
        case 'gram': return [self grams];
        case 'cgtx': return [self graphicText];
        case 'grft': return [self graphite];
        case 'gren': return [self green];
        case 'sgrp': return [self group];
        case 'grow': return [self growArea];
        case 'half': return [self half];
        case 'hscr': return [self hasScriptingTerminology];
        case 'help': return [self help_];
        case 'hidn': return [self hidden];
        case 'hqua': return [self highQuality];
        case 'hico': return [self highlightColor];
        case 'home': return [self homeDirectory];
        case 'cusr': return [self homeFolder];
        case 'href': return [self href];
        case 'hyph': return [self hyphens];
        case 'ID  ': return [self id_];
        case 'dhig': return [self ignore];
        case 'igpr': return [self ignorePrivileges];
        case 'imaA': return [self image];
        case 'inch': return [self inches];
        case 'incr': return [self incrementor];
        case 'pidx': return [self index];
        case 'dhat': return [self insertionAction];
        case 'dhip': return [self insertionPreference];
        case 'long': return [self integer];
        case 'intf': return [self interface];
        case 'itxt': return [self internationalText];
        case 'intl': return [self internationalWritingCode];
        case 'cobj': return [self item];
        case 'fget': return [self itemsAdded];
        case 'flos': return [self itemsRemoved];
        case 'tohr': return [self jumpToHere];
        case 'nxpg': return [self jumpToNextPage];
        case 'kpid': return [self kernelProcessID];
        case 'spky': return [self keyModifiers];
        case 'kgrm': return [self kilograms];
        case 'kmtr': return [self kilometers];
        case 'kind': return [self kind];
        case 'laun': return [self launcherItemsFolder];
        case 'left': return [self left];
        case 'Lcmd': return [self leftCommand];
        case 'Lctl': return [self leftControl];
        case 'Lopt': return [self leftOption];
        case 'Lsht': return [self leftShift];
        case 'dlib': return [self libraryFolder];
        case 'lite': return [self light];
        case 'list': return [self list];
        case 'litr': return [self liters];
        case 'fldl': return [self localDomain];
        case 'doml': return [self localDomainObject];
        case 'isrv': return [self localVolume];
        case 'loca': return [self location];
        case 'dplo': return [self location];
        case 'insl': return [self locationReference];
        case 'aclk': return [self logOutWhenInactive];
        case 'acto': return [self logOutWhenInactiveInterval];
        case 'logi': return [self loginItem];
        case 'lfxd': return [self longFixed];
        case 'lfpt': return [self longFixedPoint];
        case 'lfrc': return [self longFixedRectangle];
        case 'lpnt': return [self longPoint];
        case 'lrct': return [self longRectangle];
        case 'loop': return [self looping];
        case 'port': return [self machPort];
        case 'mach': return [self machine];
        case 'mLoc': return [self machineLocation];
        case 'dmag': return [self magnification];
        case 'dmsz': return [self magnificationSize];
        case 'maxV': return [self maximumValue];
        case 'medi': return [self medium];
        case 'menE': return [self menu];
        case 'mbar': return [self menuBar];
        case 'mbri': return [self menuBarItem];
        case 'menB': return [self menuButton];
        case 'menI': return [self menuItem];
        case 'metr': return [self meters];
        case 'mile': return [self miles];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'deff': return [self minimizeEffect];
        case 'minW': return [self minimumValue];
        case 'msng': return [self missingValue];
        case 'pmod': return [self modal];
        case 'asmo': return [self modificationDate];
        case 'mdtm': return [self modificationTime];
        case 'imod': return [self modified];
        case 'epso': return [self modifiers];
        case 'epsb': return [self mouseButton];
        case 'epsm': return [self mouseButtonModifiers];
        case 'movd': return [self movieData];
        case 'movf': return [self movieFile];
        case 'mdoc': return [self moviesFolder];
        case 'mtu ': return [self mtu];
        case 'dhmc': return [self musicCD];
        case '%doc': return [self musicFolder];
        case 'pnam': return [self name];
        case 'extn': return [self nameExtension];
        case 'ndim': return [self naturalDimensions];
        case 'fldn': return [self networkDomain];
        case 'domn': return [self networkDomainObject];
        case 'netp': return [self networkPreferences];
        case 'neto': return [self networkPreferencesObject];
        case 'no  ': return [self no];
        case 'none': return [self none];
        case 'norm': return [self normal];
        case 'null': return [self null];
        case 'spnm': return [self numbersKeyModifiers];
        case 'nume': return [self numericStrings];
        case 'dhap': return [self openApplication];
        case 'optm': return [self option];
        case 'eOpt': return [self option];
        case 'Kopt': return [self optionDown];
        case 'orng': return [self orange];
        case 'orie': return [self orientation];
        case 'ozs ': return [self ounces];
        case 'outl': return [self outline];
        case 'pkgf': return [self packageFolder];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'pmin': return [self parameterInfo];
        case 'pusd': return [self partitionSpaceUsed];
        case 'ppth': return [self path];
        case 'phys': return [self physicalSize];
        case 'picP': return [self picture];
        case 'dhpc': return [self pictureCD];
        case 'picp': return [self picturePath];
        case 'chnG': return [self pictureRotation];
        case 'pdoc': return [self picturesFolder];
        case 'tpmm': return [self pixelMapRecord];
        case 'QDpt': return [self point];
        case 'popB': return [self popUpButton];
        case 'posn': return [self position];
        case 'lbs ': return [self pounds];
        case 'pref': return [self preferencesFolder];
        case 'prfr': return [self preferredRate];
        case 'prfv': return [self preferredVolume];
        case 'prmd': return [self presentationMode];
        case 'prsz': return [self presentationSize];
        case 'pvwd': return [self previewDuration];
        case 'pvwt': return [self previewTime];
        case 'pset': return [self printSettings];
        case 'prcs': return [self process];
        case 'psn ': return [self processSerialNumber];
        case 'ver2': return [self productVersion];
        case 'proI': return [self progressIndicator];
        case 'pALL': return [self properties];
        case 'prop': return [self property];
        case 'pinf': return [self propertyInfo];
        case 'plif': return [self propertyListFile];
        case 'plii': return [self propertyListItem];
        case 'pubb': return [self publicFolder];
        case 'punc': return [self punctuation];
        case 'prpl': return [self purple];
        case 'qrts': return [self quarts];
        case 'qdel': return [self quitDelay];
        case 'radB': return [self radioButton];
        case 'rgrp': return [self radioGroup];
        case 'ranD': return [self randomOrder];
        case 'rapl': return [self recentApplicationsLimit];
        case 'rdcl': return [self recentDocumentsLimit];
        case 'rsvl': return [self recentServersLimit];
        case 'reco': return [self record];
        case 'red ': return [self red];
        case 'obj ': return [self reference];
        case 'reli': return [self relevanceIndicator];
        case 'lwqt': return [self requestedPrintTime];
        case 'pwul': return [self requirePasswordToUnlock];
        case 'pwwk': return [self requirePasswordToWake];
        case 'righ': return [self right];
        case 'Rcmd': return [self rightCommand];
        case 'Rctl': return [self rightControl];
        case 'Ropt': return [self rightOption];
        case 'Rsht': return [self rightShift];
        case 'role': return [self role];
        case 'trot': return [self rotation];
        case 'crow': return [self row];
        case 'dhrs': return [self runAScript];
        case 'scal': return [self scale];
        case 'fits': return [self screen];
        case 'epsc': return [self screenCorner];
        case 'scpt': return [self script];
        case 'scmn': return [self scriptMenuEnabled];
        case '$scr': return [self scriptingAdditionsFolder];
        case 'scr$': return [self scriptsFolder];
        case 'scra': return [self scrollArea];
        case 'sclp': return [self scrollArrowPlacement];
        case 'scrb': return [self scrollBar];
        case 'sclb': return [self scrollBarAction];
        case 'SFky': return [self secondaryFunctionKey];
        case 'scvm': return [self secureVirtualMemory];
        case 'secp': return [self securityPreferences];
        case 'seco': return [self securityPreferencesObject];
        case 'selE': return [self selected];
        case 'srvr': return [self server];
        case 'svce': return [self service];
        case 'stbl': return [self settable];
        case 'sdat': return [self sharedDocumentsFolder];
        case 'sheE': return [self sheet];
        case 'shtm': return [self shift];
        case 'eSft': return [self shift];
        case 'Ksft': return [self shiftDown];
        case 'sing': return [self shortFloat];
        case 'shor': return [self shortInteger];
        case 'cfbn': return [self shortName];
        case 'assv': return [self shortVersion];
        case 'epst': return [self shortcut];
        case 'desk': return [self showDesktop];
        case 'epde': return [self showDesktopShortcut];
        case 'spcs': return [self showSpaces];
        case 'shdf': return [self shutdownFolder];
        case 'slvr': return [self silver];
        case 'site': return [self sitesFolder];
        case 'ptsz': return [self size];
        case 'diss': return [self sleepDisplay];
        case 'pmss': return [self slideShow];
        case 'sliI': return [self slider];
        case 'scls': return [self smoothScrolling];
        case 'spcl': return [self spacesColumns];
        case 'spen': return [self spacesEnabled];
        case 'essp': return [self spacesPreferences];
        case 'spsp': return [self spacesPreferencesObject];
        case 'sprw': return [self spacesRows];
        case 'spst': return [self spacesShortcut];
        case 'spki': return [self speakableItemsFolder];
        case 'sped': return [self speed];
        case 'splr': return [self splitter];
        case 'splg': return [self splitterGroup];
        case 'sqft': return [self squareFeet];
        case 'sqkm': return [self squareKilometers];
        case 'sqrm': return [self squareMeters];
        case 'sqmi': return [self squareMiles];
        case 'sqyd': return [self squareYards];
        case 'lwst': return [self standard];
        case 'stnd': return [self standard];
        case 'star': return [self startScreenSaver];
        case 'offs': return [self startTime];
        case 'lwfp': return [self startingPage];
        case 'istd': return [self startup];
        case 'sdsk': return [self startupDisk];
        case 'empz': return [self startupItemsFolder];
        case 'sttx': return [self staticText];
        case 'pspd': return [self stationery];
        case 'isss': return [self storedStream];
        case 'TEXT': return [self string];
        case 'strg': return [self strong];
        case 'styl': return [self styledClipboardText];
        case 'STXT': return [self styledText];
        case 'sbrl': return [self subrole];
        case 'suin': return [self suiteInfo];
        case 'flds': return [self systemDomain];
        case 'doms': return [self systemDomainObject];
        case 'macs': return [self systemFolder];
        case 'tabg': return [self tabGroup];
        case 'tabB': return [self table];
        case 'trpr': return [self targetPrinter];
        case 'temp': return [self temporaryItemsFolder];
        case 'ctxt': return [self text];
        case 'txta': return [self textArea];
        case 'txtf': return [self textField];
        case 'tsty': return [self textStyleInfo];
        case 'tmsc': return [self timeScale];
        case 'titl': return [self title];
        case 'ptit': return [self titled];
        case 'tgth': return [self together];
        case 'tgtb': return [self togetherAtTopAndBottom];
        case 'tbar': return [self toolBar];
        case 'tpbt': return [self topAndBottom];
        case 'eptl': return [self topLeftScreenCorner];
        case 'eptr': return [self topRightScreenCorner];
        case 'appt': return [self totalPartitionSize];
        case 'trak': return [self track];
        case 'trsh': return [self trash];
        case 'ptyp': return [self type];
        case 'type': return [self typeClass];
        case 'utid': return [self typeIdentifier];
        case 'utxt': return [self unicodeText];
        case 'idux': return [self unixId];
        case 'df$$': return [self unknownFormat];
        case 'magn': return [self unsignedInteger];
        case 'uacc': return [self user];
        case 'fldu': return [self userDomain];
        case 'domu': return [self userDomainObject];
        case 'ut16': return [self utf16Text];
        case 'utf8': return [self utf8Text];
        case 'uti$': return [self utilitiesFolder];
        case 'valL': return [self value];
        case 'vali': return [self valueIndicator];
        case 'vers': return [self version_];
        case 'dhvd': return [self videoDVD];
        case 'vcdp': return [self videoDepth];
        case 'pvis': return [self visible];
        case 'visu': return [self visualCharacteristic];
        case 'volu': return [self volume];
        case 'whit': return [self whitespace];
        case 'cwin': return [self window];
        case 'fclo': return [self windowClosed];
        case 'fsiz': return [self windowMoved];
        case 'fopn': return [self windowOpened];
        case 'cwor': return [self word];
        case 'flow': return [self workflowsFolder];
        case 'psct': return [self writingCode];
        case 'yard': return [self yards];
        case 'yes ': return [self yes];
        case 'zone': return [self zone];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (SEConstant *)ApplePhotoFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ApplePhotoFormat" type: typeEnumerated code: 'dfph'];
    return constantObj;
}

+ (SEConstant *)AppleShareFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"AppleShareFormat" type: typeEnumerated code: 'dfas'];
    return constantObj;
}

+ (SEConstant *)F1 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F1" type: typeEnumerated code: 'F1ky'];
    return constantObj;
}

+ (SEConstant *)F10 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F10" type: typeEnumerated code: 'F10k'];
    return constantObj;
}

+ (SEConstant *)F11 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F11" type: typeEnumerated code: 'F11k'];
    return constantObj;
}

+ (SEConstant *)F12 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F12" type: typeEnumerated code: 'F12k'];
    return constantObj;
}

+ (SEConstant *)F13 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F13" type: typeEnumerated code: 'F13k'];
    return constantObj;
}

+ (SEConstant *)F2 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F2" type: typeEnumerated code: 'F2ky'];
    return constantObj;
}

+ (SEConstant *)F3 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F3" type: typeEnumerated code: 'F3ky'];
    return constantObj;
}

+ (SEConstant *)F4 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F4" type: typeEnumerated code: 'F4ky'];
    return constantObj;
}

+ (SEConstant *)F5 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F5" type: typeEnumerated code: 'F5ky'];
    return constantObj;
}

+ (SEConstant *)F6 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F6" type: typeEnumerated code: 'F6ky'];
    return constantObj;
}

+ (SEConstant *)F7 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F7" type: typeEnumerated code: 'F7ky'];
    return constantObj;
}

+ (SEConstant *)F8 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F8" type: typeEnumerated code: 'F8ky'];
    return constantObj;
}

+ (SEConstant *)F9 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F9" type: typeEnumerated code: 'F9ky'];
    return constantObj;
}

+ (SEConstant *)HighSierraFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"HighSierraFormat" type: typeEnumerated code: 'dfhs'];
    return constantObj;
}

+ (SEConstant *)ISO9660Format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ISO9660Format" type: typeEnumerated code: 'df96'];
    return constantObj;
}

+ (SEConstant *)MSDOSFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"MSDOSFormat" type: typeEnumerated code: 'dfms'];
    return constantObj;
}

+ (SEConstant *)MacOSExtendedFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"MacOSExtendedFormat" type: typeEnumerated code: 'dfh+'];
    return constantObj;
}

+ (SEConstant *)MacOSFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"MacOSFormat" type: typeEnumerated code: 'dfhf'];
    return constantObj;
}

+ (SEConstant *)NFSFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"NFSFormat" type: typeEnumerated code: 'dfnf'];
    return constantObj;
}

+ (SEConstant *)ProDOSFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ProDOSFormat" type: typeEnumerated code: 'dfpr'];
    return constantObj;
}

+ (SEConstant *)QuickTakeFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"QuickTakeFormat" type: typeEnumerated code: 'dfqt'];
    return constantObj;
}

+ (SEConstant *)UDFFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UDFFormat" type: typeEnumerated code: 'dfud'];
    return constantObj;
}

+ (SEConstant *)UFSFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UFSFormat" type: typeEnumerated code: 'dfuf'];
    return constantObj;
}

+ (SEConstant *)WebDAVFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"WebDAVFormat" type: typeEnumerated code: 'dfwd'];
    return constantObj;
}

+ (SEConstant *)allWindows {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"allWindows" type: typeEnumerated code: 'allw'];
    return constantObj;
}

+ (SEConstant *)applicationResponses {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationResponses" type: typeEnumerated code: 'rmte'];
    return constantObj;
}

+ (SEConstant *)applicationWindows {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationWindows" type: typeEnumerated code: 'appw'];
    return constantObj;
}

+ (SEConstant *)ask {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (SEConstant *)askWhatToDo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"askWhatToDo" type: typeEnumerated code: 'dhas'];
    return constantObj;
}

+ (SEConstant *)audioFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioFormat" type: typeEnumerated code: 'dfau'];
    return constantObj;
}

+ (SEConstant *)automatic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"automatic" type: typeEnumerated code: 'autm'];
    return constantObj;
}

+ (SEConstant *)blue {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"blue" type: typeEnumerated code: 'blue'];
    return constantObj;
}

+ (SEConstant *)bottom {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bottom" type: typeEnumerated code: 'bott'];
    return constantObj;
}

+ (SEConstant *)case_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"case_" type: typeEnumerated code: 'case'];
    return constantObj;
}

+ (SEConstant *)command {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"command" type: typeEnumerated code: 'eCmd'];
    return constantObj;
}

+ (SEConstant *)commandDown {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"commandDown" type: typeEnumerated code: 'Kcmd'];
    return constantObj;
}

+ (SEConstant *)control {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"control" type: typeEnumerated code: 'eCnt'];
    return constantObj;
}

+ (SEConstant *)controlDown {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"controlDown" type: typeEnumerated code: 'Kctl'];
    return constantObj;
}

+ (SEConstant *)current {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"current" type: typeEnumerated code: 'cust'];
    return constantObj;
}

+ (SEConstant *)dashboard {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dashboard" type: typeEnumerated code: 'dash'];
    return constantObj;
}

+ (SEConstant *)detailed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (SEConstant *)diacriticals {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"diacriticals" type: typeEnumerated code: 'diac'];
    return constantObj;
}

+ (SEConstant *)disableScreenSaver {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"disableScreenSaver" type: typeEnumerated code: 'disc'];
    return constantObj;
}

+ (SEConstant *)double_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"double_" type: typeEnumerated code: 'doub'];
    return constantObj;
}

+ (SEConstant *)expansion {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"expansion" type: typeEnumerated code: 'expa'];
    return constantObj;
}

+ (SEConstant *)genie {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"genie" type: typeEnumerated code: 'geni'];
    return constantObj;
}

+ (SEConstant *)gold {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"gold" type: typeEnumerated code: 'gold'];
    return constantObj;
}

+ (SEConstant *)graphite {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"graphite" type: typeEnumerated code: 'grft'];
    return constantObj;
}

+ (SEConstant *)green {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"green" type: typeEnumerated code: 'gren'];
    return constantObj;
}

+ (SEConstant *)half {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"half" type: typeEnumerated code: 'half'];
    return constantObj;
}

+ (SEConstant *)hyphens {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"hyphens" type: typeEnumerated code: 'hyph'];
    return constantObj;
}

+ (SEConstant *)ignore {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ignore" type: typeEnumerated code: 'dhig'];
    return constantObj;
}

+ (SEConstant *)itemsAdded {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"itemsAdded" type: typeEnumerated code: 'fget'];
    return constantObj;
}

+ (SEConstant *)itemsRemoved {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"itemsRemoved" type: typeEnumerated code: 'flos'];
    return constantObj;
}

+ (SEConstant *)jumpToHere {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"jumpToHere" type: typeEnumerated code: 'tohr'];
    return constantObj;
}

+ (SEConstant *)jumpToNextPage {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"jumpToNextPage" type: typeEnumerated code: 'nxpg'];
    return constantObj;
}

+ (SEConstant *)left {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"left" type: typeEnumerated code: 'left'];
    return constantObj;
}

+ (SEConstant *)leftCommand {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"leftCommand" type: typeEnumerated code: 'Lcmd'];
    return constantObj;
}

+ (SEConstant *)leftControl {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"leftControl" type: typeEnumerated code: 'Lctl'];
    return constantObj;
}

+ (SEConstant *)leftOption {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"leftOption" type: typeEnumerated code: 'Lopt'];
    return constantObj;
}

+ (SEConstant *)leftShift {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"leftShift" type: typeEnumerated code: 'Lsht'];
    return constantObj;
}

+ (SEConstant *)light {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"light" type: typeEnumerated code: 'lite'];
    return constantObj;
}

+ (SEConstant *)medium {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"medium" type: typeEnumerated code: 'medi'];
    return constantObj;
}

+ (SEConstant *)no {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (SEConstant *)none {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"none" type: typeEnumerated code: 'none'];
    return constantObj;
}

+ (SEConstant *)normal {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"normal" type: typeEnumerated code: 'norm'];
    return constantObj;
}

+ (SEConstant *)numericStrings {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"numericStrings" type: typeEnumerated code: 'nume'];
    return constantObj;
}

+ (SEConstant *)openApplication {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"openApplication" type: typeEnumerated code: 'dhap'];
    return constantObj;
}

+ (SEConstant *)option {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"option" type: typeEnumerated code: 'eOpt'];
    return constantObj;
}

+ (SEConstant *)optionDown {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"optionDown" type: typeEnumerated code: 'Kopt'];
    return constantObj;
}

+ (SEConstant *)orange {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"orange" type: typeEnumerated code: 'orng'];
    return constantObj;
}

+ (SEConstant *)punctuation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"punctuation" type: typeEnumerated code: 'punc'];
    return constantObj;
}

+ (SEConstant *)purple {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"purple" type: typeEnumerated code: 'prpl'];
    return constantObj;
}

+ (SEConstant *)red {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"red" type: typeEnumerated code: 'red '];
    return constantObj;
}

+ (SEConstant *)right {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"right" type: typeEnumerated code: 'righ'];
    return constantObj;
}

+ (SEConstant *)rightCommand {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"rightCommand" type: typeEnumerated code: 'Rcmd'];
    return constantObj;
}

+ (SEConstant *)rightControl {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"rightControl" type: typeEnumerated code: 'Rctl'];
    return constantObj;
}

+ (SEConstant *)rightOption {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"rightOption" type: typeEnumerated code: 'Ropt'];
    return constantObj;
}

+ (SEConstant *)rightShift {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"rightShift" type: typeEnumerated code: 'Rsht'];
    return constantObj;
}

+ (SEConstant *)runAScript {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"runAScript" type: typeEnumerated code: 'dhrs'];
    return constantObj;
}

+ (SEConstant *)scale {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scale" type: typeEnumerated code: 'scal'];
    return constantObj;
}

+ (SEConstant *)screen {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"screen" type: typeEnumerated code: 'fits'];
    return constantObj;
}

+ (SEConstant *)secondaryFunctionKey {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"secondaryFunctionKey" type: typeEnumerated code: 'SFky'];
    return constantObj;
}

+ (SEConstant *)shift {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shift" type: typeEnumerated code: 'eSft'];
    return constantObj;
}

+ (SEConstant *)shiftDown {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shiftDown" type: typeEnumerated code: 'Ksft'];
    return constantObj;
}

+ (SEConstant *)showDesktop {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"showDesktop" type: typeEnumerated code: 'desk'];
    return constantObj;
}

+ (SEConstant *)showSpaces {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"showSpaces" type: typeEnumerated code: 'spcs'];
    return constantObj;
}

+ (SEConstant *)silver {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"silver" type: typeEnumerated code: 'slvr'];
    return constantObj;
}

+ (SEConstant *)sleepDisplay {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sleepDisplay" type: typeEnumerated code: 'diss'];
    return constantObj;
}

+ (SEConstant *)slideShow {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"slideShow" type: typeEnumerated code: 'pmss'];
    return constantObj;
}

+ (SEConstant *)standard {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"standard" type: typeEnumerated code: 'stnd'];
    return constantObj;
}

+ (SEConstant *)startScreenSaver {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startScreenSaver" type: typeEnumerated code: 'star'];
    return constantObj;
}

+ (SEConstant *)strong {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"strong" type: typeEnumerated code: 'strg'];
    return constantObj;
}

+ (SEConstant *)together {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"together" type: typeEnumerated code: 'tgth'];
    return constantObj;
}

+ (SEConstant *)togetherAtTopAndBottom {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"togetherAtTopAndBottom" type: typeEnumerated code: 'tgtb'];
    return constantObj;
}

+ (SEConstant *)topAndBottom {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"topAndBottom" type: typeEnumerated code: 'tpbt'];
    return constantObj;
}

+ (SEConstant *)unknownFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"unknownFormat" type: typeEnumerated code: 'df$$'];
    return constantObj;
}

+ (SEConstant *)whitespace {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"whitespace" type: typeEnumerated code: 'whit'];
    return constantObj;
}

+ (SEConstant *)windowClosed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"windowClosed" type: typeEnumerated code: 'fclo'];
    return constantObj;
}

+ (SEConstant *)windowMoved {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"windowMoved" type: typeEnumerated code: 'fsiz'];
    return constantObj;
}

+ (SEConstant *)windowOpened {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"windowOpened" type: typeEnumerated code: 'fopn'];
    return constantObj;
}

+ (SEConstant *)yes {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (SEConstant *)April {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"April" type: typeType code: 'apr '];
    return constantObj;
}

+ (SEConstant *)August {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"August" type: typeType code: 'aug '];
    return constantObj;
}

+ (SEConstant *)CDAndDVDPreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"CDAndDVDPreferences" type: typeType code: 'dhas'];
    return constantObj;
}

+ (SEConstant *)CDAndDVDPreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"CDAndDVDPreferencesObject" type: typeType code: 'dhao'];
    return constantObj;
}

+ (SEConstant *)Classic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Classic" type: typeType code: 'clsc'];
    return constantObj;
}

+ (SEConstant *)ClassicDomain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ClassicDomain" type: typeType code: 'fldc'];
    return constantObj;
}

+ (SEConstant *)ClassicDomainObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ClassicDomainObject" type: typeType code: 'domc'];
    return constantObj;
}

+ (SEConstant *)December {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"December" type: typeType code: 'dec '];
    return constantObj;
}

+ (SEConstant *)EPSPicture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"EPSPicture" type: typeType code: 'EPS '];
    return constantObj;
}

+ (SEConstant *)February {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"February" type: typeType code: 'feb '];
    return constantObj;
}

+ (SEConstant *)FolderActionScriptsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"FolderActionScriptsFolder" type: typeType code: 'fasf'];
    return constantObj;
}

+ (SEConstant *)Friday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Friday" type: typeType code: 'fri '];
    return constantObj;
}

+ (SEConstant *)GIFPicture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"GIFPicture" type: typeType code: 'GIFf'];
    return constantObj;
}

+ (SEConstant *)JPEGPicture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"JPEGPicture" type: typeType code: 'JPEG'];
    return constantObj;
}

+ (SEConstant *)January {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"January" type: typeType code: 'jan '];
    return constantObj;
}

+ (SEConstant *)July {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"July" type: typeType code: 'jul '];
    return constantObj;
}

+ (SEConstant *)June {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"June" type: typeType code: 'jun '];
    return constantObj;
}

+ (SEConstant *)MACAddress {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"MACAddress" type: typeType code: 'maca'];
    return constantObj;
}

+ (SEConstant *)March {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"March" type: typeType code: 'mar '];
    return constantObj;
}

+ (SEConstant *)May {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"May" type: typeType code: 'may '];
    return constantObj;
}

+ (SEConstant *)Monday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Monday" type: typeType code: 'mon '];
    return constantObj;
}

+ (SEConstant *)November {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"November" type: typeType code: 'nov '];
    return constantObj;
}

+ (SEConstant *)October {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"October" type: typeType code: 'oct '];
    return constantObj;
}

+ (SEConstant *)PICTPicture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"PICTPicture" type: typeType code: 'PICT'];
    return constantObj;
}

+ (SEConstant *)POSIXPath {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"POSIXPath" type: typeType code: 'posx'];
    return constantObj;
}

+ (SEConstant *)QuickTimeData {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"QuickTimeData" type: typeType code: 'qtfd'];
    return constantObj;
}

+ (SEConstant *)QuickTimeFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"QuickTimeFile" type: typeType code: 'qtff'];
    return constantObj;
}

+ (SEConstant *)RGB16Color {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"RGB16Color" type: typeType code: 'tr16'];
    return constantObj;
}

+ (SEConstant *)RGB96Color {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"RGB96Color" type: typeType code: 'tr96'];
    return constantObj;
}

+ (SEConstant *)RGBColor {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"RGBColor" type: typeType code: 'cRGB'];
    return constantObj;
}

+ (SEConstant *)Saturday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Saturday" type: typeType code: 'sat '];
    return constantObj;
}

+ (SEConstant *)September {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"September" type: typeType code: 'sep '];
    return constantObj;
}

+ (SEConstant *)Sunday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Sunday" type: typeType code: 'sun '];
    return constantObj;
}

+ (SEConstant *)TIFFPicture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"TIFFPicture" type: typeType code: 'TIFF'];
    return constantObj;
}

+ (SEConstant *)Thursday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Thursday" type: typeType code: 'thu '];
    return constantObj;
}

+ (SEConstant *)Tuesday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Tuesday" type: typeType code: 'tue '];
    return constantObj;
}

+ (SEConstant *)UIElement {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UIElement" type: typeType code: 'uiel'];
    return constantObj;
}

+ (SEConstant *)UIElementsEnabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UIElementsEnabled" type: typeType code: 'uien'];
    return constantObj;
}

+ (SEConstant *)URL {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"URL" type: typeType code: 'url '];
    return constantObj;
}

+ (SEConstant *)Wednesday {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Wednesday" type: typeType code: 'wed '];
    return constantObj;
}

+ (SEConstant *)XMLAttribute {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XMLAttribute" type: typeType code: 'xmla'];
    return constantObj;
}

+ (SEConstant *)XMLData {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XMLData" type: typeType code: 'xmld'];
    return constantObj;
}

+ (SEConstant *)XMLElement {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XMLElement" type: typeType code: 'xmle'];
    return constantObj;
}

+ (SEConstant *)XMLFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XMLFile" type: typeType code: 'xmlf'];
    return constantObj;
}

+ (SEConstant *)acceptsHighLevelEvents {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"acceptsHighLevelEvents" type: typeType code: 'isab'];
    return constantObj;
}

+ (SEConstant *)acceptsRemoteEvents {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"acceptsRemoteEvents" type: typeType code: 'revt'];
    return constantObj;
}

+ (SEConstant *)accountName {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"accountName" type: typeType code: 'user'];
    return constantObj;
}

+ (SEConstant *)action {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"action" type: typeType code: 'actT'];
    return constantObj;
}

+ (SEConstant *)active {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"active" type: typeType code: 'acti'];
    return constantObj;
}

+ (SEConstant *)activity {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"activity" type: typeType code: 'epsa'];
    return constantObj;
}

+ (SEConstant *)alias {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (SEConstant *)allWindowsShortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"allWindowsShortcut" type: typeType code: 'epaw'];
    return constantObj;
}

+ (SEConstant *)animate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"animate" type: typeType code: 'dani'];
    return constantObj;
}

+ (SEConstant *)annotation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"annotation" type: typeType code: 'anno'];
    return constantObj;
}

+ (SEConstant *)anything {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"anything" type: typeType code: '****'];
    return constantObj;
}

+ (SEConstant *)appearance {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appearance" type: typeType code: 'appe'];
    return constantObj;
}

+ (SEConstant *)appearancePreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appearancePreferences" type: typeType code: 'aprp'];
    return constantObj;
}

+ (SEConstant *)appearancePreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appearancePreferencesObject" type: typeType code: 'apro'];
    return constantObj;
}

+ (SEConstant *)appleMenuFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appleMenuFolder" type: typeType code: 'amnu'];
    return constantObj;
}

+ (SEConstant *)application {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (SEConstant *)applicationBindings {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationBindings" type: typeType code: 'spcs'];
    return constantObj;
}

+ (SEConstant *)applicationBundleID {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationBundleID" type: typeType code: 'bund'];
    return constantObj;
}

+ (SEConstant *)applicationFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationFile" type: typeType code: 'appf'];
    return constantObj;
}

+ (SEConstant *)applicationProcess {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationProcess" type: typeType code: 'pcap'];
    return constantObj;
}

+ (SEConstant *)applicationSignature {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationSignature" type: typeType code: 'sign'];
    return constantObj;
}

+ (SEConstant *)applicationSupportFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationSupportFolder" type: typeType code: 'asup'];
    return constantObj;
}

+ (SEConstant *)applicationURL {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationURL" type: typeType code: 'aprl'];
    return constantObj;
}

+ (SEConstant *)applicationWindowsShortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationWindowsShortcut" type: typeType code: 'eppw'];
    return constantObj;
}

+ (SEConstant *)applicationsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applicationsFolder" type: typeType code: 'apps'];
    return constantObj;
}

+ (SEConstant *)architecture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"architecture" type: typeType code: 'arch'];
    return constantObj;
}

+ (SEConstant *)arrowKeyModifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"arrowKeyModifiers" type: typeType code: 'spam'];
    return constantObj;
}

+ (SEConstant *)attachment {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (SEConstant *)attribute {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"attribute" type: typeType code: 'attr'];
    return constantObj;
}

+ (SEConstant *)attributeRun {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (SEConstant *)audioChannelCount {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioChannelCount" type: typeType code: 'acha'];
    return constantObj;
}

+ (SEConstant *)audioCharacteristic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioCharacteristic" type: typeType code: 'audi'];
    return constantObj;
}

+ (SEConstant *)audioData {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioData" type: typeType code: 'audd'];
    return constantObj;
}

+ (SEConstant *)audioFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioFile" type: typeType code: 'audf'];
    return constantObj;
}

+ (SEConstant *)audioSampleRate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioSampleRate" type: typeType code: 'asra'];
    return constantObj;
}

+ (SEConstant *)audioSampleSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audioSampleSize" type: typeType code: 'assz'];
    return constantObj;
}

+ (SEConstant *)autoPlay {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"autoPlay" type: typeType code: 'autp'];
    return constantObj;
}

+ (SEConstant *)autoPresent {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"autoPresent" type: typeType code: 'apre'];
    return constantObj;
}

+ (SEConstant *)autoQuitWhenDone {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"autoQuitWhenDone" type: typeType code: 'aqui'];
    return constantObj;
}

+ (SEConstant *)autohide {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"autohide" type: typeType code: 'dahd'];
    return constantObj;
}

+ (SEConstant *)automaticLogin {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"automaticLogin" type: typeType code: 'aulg'];
    return constantObj;
}

+ (SEConstant *)backgroundOnly {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"backgroundOnly" type: typeType code: 'bkgo'];
    return constantObj;
}

+ (SEConstant *)best {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"best" type: typeType code: 'best'];
    return constantObj;
}

+ (SEConstant *)blankCD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"blankCD" type: typeType code: 'dhbc'];
    return constantObj;
}

+ (SEConstant *)blankDVD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"blankDVD" type: typeType code: 'dhbd'];
    return constantObj;
}

+ (SEConstant *)boolean {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"boolean" type: typeType code: 'bool'];
    return constantObj;
}

+ (SEConstant *)bottomLeftScreenCorner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bottomLeftScreenCorner" type: typeType code: 'epbl'];
    return constantObj;
}

+ (SEConstant *)bottomRightScreenCorner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bottomRightScreenCorner" type: typeType code: 'epbr'];
    return constantObj;
}

+ (SEConstant *)boundingRectangle {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"boundingRectangle" type: typeType code: 'qdrt'];
    return constantObj;
}

+ (SEConstant *)bounds {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (SEConstant *)browser {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"browser" type: typeType code: 'broW'];
    return constantObj;
}

+ (SEConstant *)bundleIdentifier {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bundleIdentifier" type: typeType code: 'bnid'];
    return constantObj;
}

+ (SEConstant *)busyIndicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"busyIndicator" type: typeType code: 'busi'];
    return constantObj;
}

+ (SEConstant *)busyStatus {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"busyStatus" type: typeType code: 'busy'];
    return constantObj;
}

+ (SEConstant *)button {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"button" type: typeType code: 'butT'];
    return constantObj;
}

+ (SEConstant *)capacity {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"capacity" type: typeType code: 'capa'];
    return constantObj;
}

+ (SEConstant *)centimeters {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"centimeters" type: typeType code: 'cmtr'];
    return constantObj;
}

+ (SEConstant *)changeInterval {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"changeInterval" type: typeType code: 'cinT'];
    return constantObj;
}

+ (SEConstant *)character {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (SEConstant *)checkbox {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"checkbox" type: typeType code: 'chbx'];
    return constantObj;
}

+ (SEConstant *)classInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"classInfo" type: typeType code: 'gcli'];
    return constantObj;
}

+ (SEConstant *)class_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (SEConstant *)closeable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (SEConstant *)collating {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (SEConstant *)color {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (SEConstant *)colorTable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"colorTable" type: typeType code: 'clrt'];
    return constantObj;
}

+ (SEConstant *)colorWell {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"colorWell" type: typeType code: 'colW'];
    return constantObj;
}

+ (SEConstant *)column {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"column" type: typeType code: 'ccol'];
    return constantObj;
}

+ (SEConstant *)comboBox {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"comboBox" type: typeType code: 'comB'];
    return constantObj;
}

+ (SEConstant *)configuration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"configuration" type: typeType code: 'conF'];
    return constantObj;
}

+ (SEConstant *)connected {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"connected" type: typeType code: 'conn'];
    return constantObj;
}

+ (SEConstant *)container {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"container" type: typeType code: 'ctnr'];
    return constantObj;
}

+ (SEConstant *)contents {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"contents" type: typeType code: 'pcnt'];
    return constantObj;
}

+ (SEConstant *)controlPanelsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"controlPanelsFolder" type: typeType code: 'ctrl'];
    return constantObj;
}

+ (SEConstant *)controlStripModulesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"controlStripModulesFolder" type: typeType code: 'sdev'];
    return constantObj;
}

+ (SEConstant *)copies {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (SEConstant *)creationDate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"creationDate" type: typeType code: 'ascd'];
    return constantObj;
}

+ (SEConstant *)creationTime {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"creationTime" type: typeType code: 'mdcr'];
    return constantObj;
}

+ (SEConstant *)creatorType {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"creatorType" type: typeType code: 'fcrt'];
    return constantObj;
}

+ (SEConstant *)cubicCentimeters {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"cubicCentimeters" type: typeType code: 'ccmt'];
    return constantObj;
}

+ (SEConstant *)cubicFeet {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"cubicFeet" type: typeType code: 'cfet'];
    return constantObj;
}

+ (SEConstant *)cubicInches {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"cubicInches" type: typeType code: 'cuin'];
    return constantObj;
}

+ (SEConstant *)cubicMeters {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"cubicMeters" type: typeType code: 'cmet'];
    return constantObj;
}

+ (SEConstant *)cubicYards {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"cubicYards" type: typeType code: 'cyrd'];
    return constantObj;
}

+ (SEConstant *)currentConfiguration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"currentConfiguration" type: typeType code: 'cnfg'];
    return constantObj;
}

+ (SEConstant *)currentDesktop {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"currentDesktop" type: typeType code: 'curd'];
    return constantObj;
}

+ (SEConstant *)currentLocation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"currentLocation" type: typeType code: 'locc'];
    return constantObj;
}

+ (SEConstant *)currentUser {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"currentUser" type: typeType code: 'curu'];
    return constantObj;
}

+ (SEConstant *)customApplication {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"customApplication" type: typeType code: 'dhca'];
    return constantObj;
}

+ (SEConstant *)customScript {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"customScript" type: typeType code: 'dhcs'];
    return constantObj;
}

+ (SEConstant *)dashStyle {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dashStyle" type: typeType code: 'tdas'];
    return constantObj;
}

+ (SEConstant *)dashboardShortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dashboardShortcut" type: typeType code: 'epdb'];
    return constantObj;
}

+ (SEConstant *)data {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"data" type: typeType code: 'rdat'];
    return constantObj;
}

+ (SEConstant *)dataFormat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dataFormat" type: typeType code: 'tdfr'];
    return constantObj;
}

+ (SEConstant *)dataRate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dataRate" type: typeType code: 'ddra'];
    return constantObj;
}

+ (SEConstant *)dataSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dataSize" type: typeType code: 'dsiz'];
    return constantObj;
}

+ (SEConstant *)date {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"date" type: typeType code: 'ldt '];
    return constantObj;
}

+ (SEConstant *)decimalStruct {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"decimalStruct" type: typeType code: 'decm'];
    return constantObj;
}

+ (SEConstant *)defaultApplication {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"defaultApplication" type: typeType code: 'asda'];
    return constantObj;
}

+ (SEConstant *)degreesCelsius {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"degreesCelsius" type: typeType code: 'degc'];
    return constantObj;
}

+ (SEConstant *)degreesFahrenheit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"degreesFahrenheit" type: typeType code: 'degf'];
    return constantObj;
}

+ (SEConstant *)degreesKelvin {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"degreesKelvin" type: typeType code: 'degk'];
    return constantObj;
}

+ (SEConstant *)description_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"description_" type: typeType code: 'desc'];
    return constantObj;
}

+ (SEConstant *)deskAccessoryFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"deskAccessoryFile" type: typeType code: 'dafi'];
    return constantObj;
}

+ (SEConstant *)deskAccessoryProcess {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"deskAccessoryProcess" type: typeType code: 'pcda'];
    return constantObj;
}

+ (SEConstant *)desktop {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desktop" type: typeType code: 'dskp'];
    return constantObj;
}

+ (SEConstant *)desktopFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desktopFolder" type: typeType code: 'desk'];
    return constantObj;
}

+ (SEConstant *)desktopPicturesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desktopPicturesFolder" type: typeType code: 'dtp$'];
    return constantObj;
}

+ (SEConstant *)dimensions {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dimensions" type: typeType code: 'pdim'];
    return constantObj;
}

+ (SEConstant *)disk {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"disk" type: typeType code: 'cdis'];
    return constantObj;
}

+ (SEConstant *)diskItem {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"diskItem" type: typeType code: 'ditm'];
    return constantObj;
}

+ (SEConstant *)displayName {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"displayName" type: typeType code: 'dnaM'];
    return constantObj;
}

+ (SEConstant *)displayedName {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"displayedName" type: typeType code: 'dnam'];
    return constantObj;
}

+ (SEConstant *)dockPreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dockPreferences" type: typeType code: 'dpas'];
    return constantObj;
}

+ (SEConstant *)dockPreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dockPreferencesObject" type: typeType code: 'dpao'];
    return constantObj;
}

+ (SEConstant *)dockSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dockSize" type: typeType code: 'dsze'];
    return constantObj;
}

+ (SEConstant *)document {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (SEConstant *)documentsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"documentsFolder" type: typeType code: 'docs'];
    return constantObj;
}

+ (SEConstant *)domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"domain" type: typeType code: 'doma'];
    return constantObj;
}

+ (SEConstant *)doubleClickMinimizes {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"doubleClickMinimizes" type: typeType code: 'mndc'];
    return constantObj;
}

+ (SEConstant *)doubleInteger {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"doubleInteger" type: typeType code: 'comp'];
    return constantObj;
}

+ (SEConstant *)downloadsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"downloadsFolder" type: typeType code: 'down'];
    return constantObj;
}

+ (SEConstant *)drawer {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"drawer" type: typeType code: 'draA'];
    return constantObj;
}

+ (SEConstant *)duplex {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"duplex" type: typeType code: 'dupl'];
    return constantObj;
}

+ (SEConstant *)duration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"duration" type: typeType code: 'durn'];
    return constantObj;
}

+ (SEConstant *)ejectable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ejectable" type: typeType code: 'isej'];
    return constantObj;
}

+ (SEConstant *)elementInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"elementInfo" type: typeType code: 'elin'];
    return constantObj;
}

+ (SEConstant *)enabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"enabled" type: typeType code: 'enaB'];
    return constantObj;
}

+ (SEConstant *)encodedString {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"encodedString" type: typeType code: 'encs'];
    return constantObj;
}

+ (SEConstant *)endingPage {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (SEConstant *)entireContents {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"entireContents" type: typeType code: 'ects'];
    return constantObj;
}

+ (SEConstant *)enumerator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"enumerator" type: typeType code: 'enum'];
    return constantObj;
}

+ (SEConstant *)errorHandling {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (SEConstant *)eventInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"eventInfo" type: typeType code: 'evin'];
    return constantObj;
}

+ (SEConstant *)exposePreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"exposePreferences" type: typeType code: 'epas'];
    return constantObj;
}

+ (SEConstant *)exposePreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"exposePreferencesObject" type: typeType code: 'epao'];
    return constantObj;
}

+ (SEConstant *)extendedFloat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"extendedFloat" type: typeType code: 'exte'];
    return constantObj;
}

+ (SEConstant *)extensionsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"extensionsFolder" type: typeType code: 'extz'];
    return constantObj;
}

+ (SEConstant *)favoritesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"favoritesFolder" type: typeType code: 'favs'];
    return constantObj;
}

+ (SEConstant *)faxNumber {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (SEConstant *)feet {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"feet" type: typeType code: 'feet'];
    return constantObj;
}

+ (SEConstant *)file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"file" type: typeType code: 'file'];
    return constantObj;
}

+ (SEConstant *)fileName {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (SEConstant *)filePackage {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"filePackage" type: typeType code: 'cpkg'];
    return constantObj;
}

+ (SEConstant *)fileRef {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fileRef" type: typeType code: 'fsrf'];
    return constantObj;
}

+ (SEConstant *)fileSpecification {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fileSpecification" type: typeType code: 'fss '];
    return constantObj;
}

+ (SEConstant *)fileType {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fileType" type: typeType code: 'asty'];
    return constantObj;
}

+ (SEConstant *)fileURL {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fileURL" type: typeType code: 'furl'];
    return constantObj;
}

+ (SEConstant *)fixed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fixed" type: typeType code: 'fixd'];
    return constantObj;
}

+ (SEConstant *)fixedPoint {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fixedPoint" type: typeType code: 'fpnt'];
    return constantObj;
}

+ (SEConstant *)fixedRectangle {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fixedRectangle" type: typeType code: 'frct'];
    return constantObj;
}

+ (SEConstant *)float128bit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"float128bit" type: typeType code: 'ldbl'];
    return constantObj;
}

+ (SEConstant *)float_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"float_" type: typeType code: 'doub'];
    return constantObj;
}

+ (SEConstant *)floating {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (SEConstant *)focused {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"focused" type: typeType code: 'focu'];
    return constantObj;
}

+ (SEConstant *)folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"folder" type: typeType code: 'cfol'];
    return constantObj;
}

+ (SEConstant *)folderAction {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"folderAction" type: typeType code: 'foac'];
    return constantObj;
}

+ (SEConstant *)folderActionsEnabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"folderActionsEnabled" type: typeType code: 'faen'];
    return constantObj;
}

+ (SEConstant *)font {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (SEConstant *)fontSmoothingLimit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fontSmoothingLimit" type: typeType code: 'ftsm'];
    return constantObj;
}

+ (SEConstant *)fontSmoothingStyle {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fontSmoothingStyle" type: typeType code: 'ftss'];
    return constantObj;
}

+ (SEConstant *)fontsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fontsFolder" type: typeType code: 'font'];
    return constantObj;
}

+ (SEConstant *)format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"format" type: typeType code: 'dfmt'];
    return constantObj;
}

+ (SEConstant *)freeSpace {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"freeSpace" type: typeType code: 'frsp'];
    return constantObj;
}

+ (SEConstant *)frontmost {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (SEConstant *)fullName {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fullName" type: typeType code: 'fnam'];
    return constantObj;
}

+ (SEConstant *)fullText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fullText" type: typeType code: 'anot'];
    return constantObj;
}

+ (SEConstant *)functionKey {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"functionKey" type: typeType code: 'epsk'];
    return constantObj;
}

+ (SEConstant *)functionKeyModifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"functionKeyModifiers" type: typeType code: 'epsy'];
    return constantObj;
}

+ (SEConstant *)gallons {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"gallons" type: typeType code: 'galn'];
    return constantObj;
}

+ (SEConstant *)grams {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"grams" type: typeType code: 'gram'];
    return constantObj;
}

+ (SEConstant *)graphicText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"graphicText" type: typeType code: 'cgtx'];
    return constantObj;
}

+ (SEConstant *)group {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"group" type: typeType code: 'sgrp'];
    return constantObj;
}

+ (SEConstant *)growArea {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"growArea" type: typeType code: 'grow'];
    return constantObj;
}

+ (SEConstant *)hasScriptingTerminology {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"hasScriptingTerminology" type: typeType code: 'hscr'];
    return constantObj;
}

+ (SEConstant *)help_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"help_" type: typeType code: 'help'];
    return constantObj;
}

+ (SEConstant *)hidden {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"hidden" type: typeType code: 'hidn'];
    return constantObj;
}

+ (SEConstant *)highQuality {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"highQuality" type: typeType code: 'hqua'];
    return constantObj;
}

+ (SEConstant *)highlightColor {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"highlightColor" type: typeType code: 'hico'];
    return constantObj;
}

+ (SEConstant *)homeDirectory {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"homeDirectory" type: typeType code: 'home'];
    return constantObj;
}

+ (SEConstant *)homeFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"homeFolder" type: typeType code: 'cusr'];
    return constantObj;
}

+ (SEConstant *)href {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"href" type: typeType code: 'href'];
    return constantObj;
}

+ (SEConstant *)id_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (SEConstant *)ignorePrivileges {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ignorePrivileges" type: typeType code: 'igpr'];
    return constantObj;
}

+ (SEConstant *)image {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"image" type: typeType code: 'imaA'];
    return constantObj;
}

+ (SEConstant *)inches {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"inches" type: typeType code: 'inch'];
    return constantObj;
}

+ (SEConstant *)incrementor {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"incrementor" type: typeType code: 'incr'];
    return constantObj;
}

+ (SEConstant *)index {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (SEConstant *)insertionAction {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"insertionAction" type: typeType code: 'dhat'];
    return constantObj;
}

+ (SEConstant *)insertionPreference {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"insertionPreference" type: typeType code: 'dhip'];
    return constantObj;
}

+ (SEConstant *)integer {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"integer" type: typeType code: 'long'];
    return constantObj;
}

+ (SEConstant *)interface {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"interface" type: typeType code: 'intf'];
    return constantObj;
}

+ (SEConstant *)internationalText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"internationalText" type: typeType code: 'itxt'];
    return constantObj;
}

+ (SEConstant *)internationalWritingCode {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"internationalWritingCode" type: typeType code: 'intl'];
    return constantObj;
}

+ (SEConstant *)item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (SEConstant *)kernelProcessID {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"kernelProcessID" type: typeType code: 'kpid'];
    return constantObj;
}

+ (SEConstant *)keyModifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"keyModifiers" type: typeType code: 'spky'];
    return constantObj;
}

+ (SEConstant *)kilograms {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"kilograms" type: typeType code: 'kgrm'];
    return constantObj;
}

+ (SEConstant *)kilometers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"kilometers" type: typeType code: 'kmtr'];
    return constantObj;
}

+ (SEConstant *)kind {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"kind" type: typeType code: 'kind'];
    return constantObj;
}

+ (SEConstant *)launcherItemsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"launcherItemsFolder" type: typeType code: 'laun'];
    return constantObj;
}

+ (SEConstant *)libraryFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"libraryFolder" type: typeType code: 'dlib'];
    return constantObj;
}

+ (SEConstant *)list {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (SEConstant *)liters {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"liters" type: typeType code: 'litr'];
    return constantObj;
}

+ (SEConstant *)localDomain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"localDomain" type: typeType code: 'fldl'];
    return constantObj;
}

+ (SEConstant *)localDomainObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"localDomainObject" type: typeType code: 'doml'];
    return constantObj;
}

+ (SEConstant *)localVolume {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"localVolume" type: typeType code: 'isrv'];
    return constantObj;
}

+ (SEConstant *)location {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"location" type: typeType code: 'loca'];
    return constantObj;
}

+ (SEConstant *)locationReference {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"locationReference" type: typeType code: 'insl'];
    return constantObj;
}

+ (SEConstant *)logOutWhenInactive {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"logOutWhenInactive" type: typeType code: 'aclk'];
    return constantObj;
}

+ (SEConstant *)logOutWhenInactiveInterval {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"logOutWhenInactiveInterval" type: typeType code: 'acto'];
    return constantObj;
}

+ (SEConstant *)loginItem {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"loginItem" type: typeType code: 'logi'];
    return constantObj;
}

+ (SEConstant *)longFixed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"longFixed" type: typeType code: 'lfxd'];
    return constantObj;
}

+ (SEConstant *)longFixedPoint {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"longFixedPoint" type: typeType code: 'lfpt'];
    return constantObj;
}

+ (SEConstant *)longFixedRectangle {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"longFixedRectangle" type: typeType code: 'lfrc'];
    return constantObj;
}

+ (SEConstant *)longPoint {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"longPoint" type: typeType code: 'lpnt'];
    return constantObj;
}

+ (SEConstant *)longRectangle {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"longRectangle" type: typeType code: 'lrct'];
    return constantObj;
}

+ (SEConstant *)looping {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"looping" type: typeType code: 'loop'];
    return constantObj;
}

+ (SEConstant *)machPort {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"machPort" type: typeType code: 'port'];
    return constantObj;
}

+ (SEConstant *)machine {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"machine" type: typeType code: 'mach'];
    return constantObj;
}

+ (SEConstant *)machineLocation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"machineLocation" type: typeType code: 'mLoc'];
    return constantObj;
}

+ (SEConstant *)magnification {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"magnification" type: typeType code: 'dmag'];
    return constantObj;
}

+ (SEConstant *)magnificationSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"magnificationSize" type: typeType code: 'dmsz'];
    return constantObj;
}

+ (SEConstant *)maximumValue {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"maximumValue" type: typeType code: 'maxV'];
    return constantObj;
}

+ (SEConstant *)menu {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menu" type: typeType code: 'menE'];
    return constantObj;
}

+ (SEConstant *)menuBar {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menuBar" type: typeType code: 'mbar'];
    return constantObj;
}

+ (SEConstant *)menuBarItem {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menuBarItem" type: typeType code: 'mbri'];
    return constantObj;
}

+ (SEConstant *)menuButton {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menuButton" type: typeType code: 'menB'];
    return constantObj;
}

+ (SEConstant *)menuItem {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menuItem" type: typeType code: 'menI'];
    return constantObj;
}

+ (SEConstant *)meters {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"meters" type: typeType code: 'metr'];
    return constantObj;
}

+ (SEConstant *)miles {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"miles" type: typeType code: 'mile'];
    return constantObj;
}

+ (SEConstant *)miniaturizable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (SEConstant *)miniaturized {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (SEConstant *)minimizeEffect {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"minimizeEffect" type: typeType code: 'deff'];
    return constantObj;
}

+ (SEConstant *)minimumValue {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"minimumValue" type: typeType code: 'minW'];
    return constantObj;
}

+ (SEConstant *)missingValue {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"missingValue" type: typeType code: 'msng'];
    return constantObj;
}

+ (SEConstant *)modal {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (SEConstant *)modificationDate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modificationDate" type: typeType code: 'asmo'];
    return constantObj;
}

+ (SEConstant *)modificationTime {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modificationTime" type: typeType code: 'mdtm'];
    return constantObj;
}

+ (SEConstant *)modified {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (SEConstant *)modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modifiers" type: typeType code: 'epso'];
    return constantObj;
}

+ (SEConstant *)mouseButton {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"mouseButton" type: typeType code: 'epsb'];
    return constantObj;
}

+ (SEConstant *)mouseButtonModifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"mouseButtonModifiers" type: typeType code: 'epsm'];
    return constantObj;
}

+ (SEConstant *)movieData {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"movieData" type: typeType code: 'movd'];
    return constantObj;
}

+ (SEConstant *)movieFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"movieFile" type: typeType code: 'movf'];
    return constantObj;
}

+ (SEConstant *)moviesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"moviesFolder" type: typeType code: 'mdoc'];
    return constantObj;
}

+ (SEConstant *)mtu {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"mtu" type: typeType code: 'mtu '];
    return constantObj;
}

+ (SEConstant *)musicCD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"musicCD" type: typeType code: 'dhmc'];
    return constantObj;
}

+ (SEConstant *)musicFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"musicFolder" type: typeType code: '%doc'];
    return constantObj;
}

+ (SEConstant *)name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (SEConstant *)nameExtension {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"nameExtension" type: typeType code: 'extn'];
    return constantObj;
}

+ (SEConstant *)naturalDimensions {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"naturalDimensions" type: typeType code: 'ndim'];
    return constantObj;
}

+ (SEConstant *)networkDomain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"networkDomain" type: typeType code: 'fldn'];
    return constantObj;
}

+ (SEConstant *)networkDomainObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"networkDomainObject" type: typeType code: 'domn'];
    return constantObj;
}

+ (SEConstant *)networkPreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"networkPreferences" type: typeType code: 'netp'];
    return constantObj;
}

+ (SEConstant *)networkPreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"networkPreferencesObject" type: typeType code: 'neto'];
    return constantObj;
}

+ (SEConstant *)null {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"null" type: typeType code: 'null'];
    return constantObj;
}

+ (SEConstant *)numbersKeyModifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"numbersKeyModifiers" type: typeType code: 'spnm'];
    return constantObj;
}

+ (SEConstant *)orientation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"orientation" type: typeType code: 'orie'];
    return constantObj;
}

+ (SEConstant *)ounces {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ounces" type: typeType code: 'ozs '];
    return constantObj;
}

+ (SEConstant *)outline {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"outline" type: typeType code: 'outl'];
    return constantObj;
}

+ (SEConstant *)packageFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"packageFolder" type: typeType code: 'pkgf'];
    return constantObj;
}

+ (SEConstant *)pagesAcross {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (SEConstant *)pagesDown {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (SEConstant *)paragraph {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (SEConstant *)parameterInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"parameterInfo" type: typeType code: 'pmin'];
    return constantObj;
}

+ (SEConstant *)partitionSpaceUsed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"partitionSpaceUsed" type: typeType code: 'pusd'];
    return constantObj;
}

+ (SEConstant *)path {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (SEConstant *)physicalSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"physicalSize" type: typeType code: 'phys'];
    return constantObj;
}

+ (SEConstant *)picture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picture" type: typeType code: 'picP'];
    return constantObj;
}

+ (SEConstant *)pictureCD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pictureCD" type: typeType code: 'dhpc'];
    return constantObj;
}

+ (SEConstant *)picturePath {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picturePath" type: typeType code: 'picp'];
    return constantObj;
}

+ (SEConstant *)pictureRotation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pictureRotation" type: typeType code: 'chnG'];
    return constantObj;
}

+ (SEConstant *)picturesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picturesFolder" type: typeType code: 'pdoc'];
    return constantObj;
}

+ (SEConstant *)pixelMapRecord {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pixelMapRecord" type: typeType code: 'tpmm'];
    return constantObj;
}

+ (SEConstant *)point {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"point" type: typeType code: 'QDpt'];
    return constantObj;
}

+ (SEConstant *)popUpButton {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"popUpButton" type: typeType code: 'popB'];
    return constantObj;
}

+ (SEConstant *)position {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"position" type: typeType code: 'posn'];
    return constantObj;
}

+ (SEConstant *)pounds {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pounds" type: typeType code: 'lbs '];
    return constantObj;
}

+ (SEConstant *)preferencesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preferencesFolder" type: typeType code: 'pref'];
    return constantObj;
}

+ (SEConstant *)preferredRate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preferredRate" type: typeType code: 'prfr'];
    return constantObj;
}

+ (SEConstant *)preferredVolume {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preferredVolume" type: typeType code: 'prfv'];
    return constantObj;
}

+ (SEConstant *)presentationMode {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"presentationMode" type: typeType code: 'prmd'];
    return constantObj;
}

+ (SEConstant *)presentationSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"presentationSize" type: typeType code: 'prsz'];
    return constantObj;
}

+ (SEConstant *)previewDuration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"previewDuration" type: typeType code: 'pvwd'];
    return constantObj;
}

+ (SEConstant *)previewTime {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"previewTime" type: typeType code: 'pvwt'];
    return constantObj;
}

+ (SEConstant *)printSettings {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (SEConstant *)process {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"process" type: typeType code: 'prcs'];
    return constantObj;
}

+ (SEConstant *)processSerialNumber {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"processSerialNumber" type: typeType code: 'psn '];
    return constantObj;
}

+ (SEConstant *)productVersion {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"productVersion" type: typeType code: 'ver2'];
    return constantObj;
}

+ (SEConstant *)progressIndicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"progressIndicator" type: typeType code: 'proI'];
    return constantObj;
}

+ (SEConstant *)properties {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (SEConstant *)property {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"property" type: typeType code: 'prop'];
    return constantObj;
}

+ (SEConstant *)propertyInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"propertyInfo" type: typeType code: 'pinf'];
    return constantObj;
}

+ (SEConstant *)propertyListFile {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"propertyListFile" type: typeType code: 'plif'];
    return constantObj;
}

+ (SEConstant *)propertyListItem {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"propertyListItem" type: typeType code: 'plii'];
    return constantObj;
}

+ (SEConstant *)publicFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"publicFolder" type: typeType code: 'pubb'];
    return constantObj;
}

+ (SEConstant *)quarts {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"quarts" type: typeType code: 'qrts'];
    return constantObj;
}

+ (SEConstant *)quitDelay {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"quitDelay" type: typeType code: 'qdel'];
    return constantObj;
}

+ (SEConstant *)radioButton {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"radioButton" type: typeType code: 'radB'];
    return constantObj;
}

+ (SEConstant *)radioGroup {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"radioGroup" type: typeType code: 'rgrp'];
    return constantObj;
}

+ (SEConstant *)randomOrder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"randomOrder" type: typeType code: 'ranD'];
    return constantObj;
}

+ (SEConstant *)recentApplicationsLimit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"recentApplicationsLimit" type: typeType code: 'rapl'];
    return constantObj;
}

+ (SEConstant *)recentDocumentsLimit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"recentDocumentsLimit" type: typeType code: 'rdcl'];
    return constantObj;
}

+ (SEConstant *)recentServersLimit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"recentServersLimit" type: typeType code: 'rsvl'];
    return constantObj;
}

+ (SEConstant *)record {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"record" type: typeType code: 'reco'];
    return constantObj;
}

+ (SEConstant *)reference {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"reference" type: typeType code: 'obj '];
    return constantObj;
}

+ (SEConstant *)relevanceIndicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"relevanceIndicator" type: typeType code: 'reli'];
    return constantObj;
}

+ (SEConstant *)requestedPrintTime {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (SEConstant *)requirePasswordToUnlock {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"requirePasswordToUnlock" type: typeType code: 'pwul'];
    return constantObj;
}

+ (SEConstant *)requirePasswordToWake {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"requirePasswordToWake" type: typeType code: 'pwwk'];
    return constantObj;
}

+ (SEConstant *)resizable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (SEConstant *)role {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"role" type: typeType code: 'role'];
    return constantObj;
}

+ (SEConstant *)rotation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"rotation" type: typeType code: 'trot'];
    return constantObj;
}

+ (SEConstant *)row {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"row" type: typeType code: 'crow'];
    return constantObj;
}

+ (SEConstant *)screenCorner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"screenCorner" type: typeType code: 'epsc'];
    return constantObj;
}

+ (SEConstant *)script {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (SEConstant *)scriptMenuEnabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scriptMenuEnabled" type: typeType code: 'scmn'];
    return constantObj;
}

+ (SEConstant *)scriptingAdditionsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scriptingAdditionsFolder" type: typeType code: '$scr'];
    return constantObj;
}

+ (SEConstant *)scriptsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scriptsFolder" type: typeType code: 'scr$'];
    return constantObj;
}

+ (SEConstant *)scrollArea {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scrollArea" type: typeType code: 'scra'];
    return constantObj;
}

+ (SEConstant *)scrollArrowPlacement {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scrollArrowPlacement" type: typeType code: 'sclp'];
    return constantObj;
}

+ (SEConstant *)scrollBar {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scrollBar" type: typeType code: 'scrb'];
    return constantObj;
}

+ (SEConstant *)scrollBarAction {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scrollBarAction" type: typeType code: 'sclb'];
    return constantObj;
}

+ (SEConstant *)secureVirtualMemory {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"secureVirtualMemory" type: typeType code: 'scvm'];
    return constantObj;
}

+ (SEConstant *)securityPreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"securityPreferences" type: typeType code: 'secp'];
    return constantObj;
}

+ (SEConstant *)securityPreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"securityPreferencesObject" type: typeType code: 'seco'];
    return constantObj;
}

+ (SEConstant *)selected {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"selected" type: typeType code: 'selE'];
    return constantObj;
}

+ (SEConstant *)server {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"server" type: typeType code: 'srvr'];
    return constantObj;
}

+ (SEConstant *)service {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"service" type: typeType code: 'svce'];
    return constantObj;
}

+ (SEConstant *)settable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"settable" type: typeType code: 'stbl'];
    return constantObj;
}

+ (SEConstant *)sharedDocumentsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sharedDocumentsFolder" type: typeType code: 'sdat'];
    return constantObj;
}

+ (SEConstant *)sheet {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sheet" type: typeType code: 'sheE'];
    return constantObj;
}

+ (SEConstant *)shortFloat {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shortFloat" type: typeType code: 'sing'];
    return constantObj;
}

+ (SEConstant *)shortInteger {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shortInteger" type: typeType code: 'shor'];
    return constantObj;
}

+ (SEConstant *)shortName {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shortName" type: typeType code: 'cfbn'];
    return constantObj;
}

+ (SEConstant *)shortVersion {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shortVersion" type: typeType code: 'assv'];
    return constantObj;
}

+ (SEConstant *)shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shortcut" type: typeType code: 'epst'];
    return constantObj;
}

+ (SEConstant *)showDesktopShortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"showDesktopShortcut" type: typeType code: 'epde'];
    return constantObj;
}

+ (SEConstant *)showSpacesShortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"showSpacesShortcut" type: typeType code: 'spcs'];
    return constantObj;
}

+ (SEConstant *)shutdownFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shutdownFolder" type: typeType code: 'shdf'];
    return constantObj;
}

+ (SEConstant *)sitesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sitesFolder" type: typeType code: 'site'];
    return constantObj;
}

+ (SEConstant *)size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (SEConstant *)slider {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"slider" type: typeType code: 'sliI'];
    return constantObj;
}

+ (SEConstant *)smoothScrolling {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"smoothScrolling" type: typeType code: 'scls'];
    return constantObj;
}

+ (SEConstant *)spacesColumns {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spacesColumns" type: typeType code: 'spcl'];
    return constantObj;
}

+ (SEConstant *)spacesEnabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spacesEnabled" type: typeType code: 'spen'];
    return constantObj;
}

+ (SEConstant *)spacesPreferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spacesPreferences" type: typeType code: 'essp'];
    return constantObj;
}

+ (SEConstant *)spacesPreferencesObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spacesPreferencesObject" type: typeType code: 'spsp'];
    return constantObj;
}

+ (SEConstant *)spacesRows {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spacesRows" type: typeType code: 'sprw'];
    return constantObj;
}

+ (SEConstant *)spacesShortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spacesShortcut" type: typeType code: 'spst'];
    return constantObj;
}

+ (SEConstant *)speakableItemsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"speakableItemsFolder" type: typeType code: 'spki'];
    return constantObj;
}

+ (SEConstant *)speed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"speed" type: typeType code: 'sped'];
    return constantObj;
}

+ (SEConstant *)splitter {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"splitter" type: typeType code: 'splr'];
    return constantObj;
}

+ (SEConstant *)splitterGroup {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"splitterGroup" type: typeType code: 'splg'];
    return constantObj;
}

+ (SEConstant *)squareFeet {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"squareFeet" type: typeType code: 'sqft'];
    return constantObj;
}

+ (SEConstant *)squareKilometers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"squareKilometers" type: typeType code: 'sqkm'];
    return constantObj;
}

+ (SEConstant *)squareMeters {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"squareMeters" type: typeType code: 'sqrm'];
    return constantObj;
}

+ (SEConstant *)squareMiles {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"squareMiles" type: typeType code: 'sqmi'];
    return constantObj;
}

+ (SEConstant *)squareYards {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"squareYards" type: typeType code: 'sqyd'];
    return constantObj;
}

+ (SEConstant *)startTime {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startTime" type: typeType code: 'offs'];
    return constantObj;
}

+ (SEConstant *)startingPage {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (SEConstant *)startup {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startup" type: typeType code: 'istd'];
    return constantObj;
}

+ (SEConstant *)startupDisk {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startupDisk" type: typeType code: 'sdsk'];
    return constantObj;
}

+ (SEConstant *)startupItemsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startupItemsFolder" type: typeType code: 'empz'];
    return constantObj;
}

+ (SEConstant *)staticText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"staticText" type: typeType code: 'sttx'];
    return constantObj;
}

+ (SEConstant *)stationery {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"stationery" type: typeType code: 'pspd'];
    return constantObj;
}

+ (SEConstant *)storedStream {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"storedStream" type: typeType code: 'isss'];
    return constantObj;
}

+ (SEConstant *)string {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"string" type: typeType code: 'TEXT'];
    return constantObj;
}

+ (SEConstant *)styledClipboardText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"styledClipboardText" type: typeType code: 'styl'];
    return constantObj;
}

+ (SEConstant *)styledText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"styledText" type: typeType code: 'STXT'];
    return constantObj;
}

+ (SEConstant *)subrole {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"subrole" type: typeType code: 'sbrl'];
    return constantObj;
}

+ (SEConstant *)suiteInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"suiteInfo" type: typeType code: 'suin'];
    return constantObj;
}

+ (SEConstant *)systemDomain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"systemDomain" type: typeType code: 'flds'];
    return constantObj;
}

+ (SEConstant *)systemDomainObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"systemDomainObject" type: typeType code: 'doms'];
    return constantObj;
}

+ (SEConstant *)systemFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"systemFolder" type: typeType code: 'macs'];
    return constantObj;
}

+ (SEConstant *)tabGroup {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"tabGroup" type: typeType code: 'tabg'];
    return constantObj;
}

+ (SEConstant *)table {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"table" type: typeType code: 'tabB'];
    return constantObj;
}

+ (SEConstant *)targetPrinter {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (SEConstant *)temporaryItemsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"temporaryItemsFolder" type: typeType code: 'temp'];
    return constantObj;
}

+ (SEConstant *)text {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (SEConstant *)textArea {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"textArea" type: typeType code: 'txta'];
    return constantObj;
}

+ (SEConstant *)textField {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"textField" type: typeType code: 'txtf'];
    return constantObj;
}

+ (SEConstant *)textStyleInfo {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"textStyleInfo" type: typeType code: 'tsty'];
    return constantObj;
}

+ (SEConstant *)timeScale {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"timeScale" type: typeType code: 'tmsc'];
    return constantObj;
}

+ (SEConstant *)title {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"title" type: typeType code: 'titl'];
    return constantObj;
}

+ (SEConstant *)titled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (SEConstant *)toolBar {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"toolBar" type: typeType code: 'tbar'];
    return constantObj;
}

+ (SEConstant *)topLeftScreenCorner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"topLeftScreenCorner" type: typeType code: 'eptl'];
    return constantObj;
}

+ (SEConstant *)topRightScreenCorner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"topRightScreenCorner" type: typeType code: 'eptr'];
    return constantObj;
}

+ (SEConstant *)totalPartitionSize {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"totalPartitionSize" type: typeType code: 'appt'];
    return constantObj;
}

+ (SEConstant *)track {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"track" type: typeType code: 'trak'];
    return constantObj;
}

+ (SEConstant *)trash {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"trash" type: typeType code: 'trsh'];
    return constantObj;
}

+ (SEConstant *)type {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"type" type: typeType code: 'ptyp'];
    return constantObj;
}

+ (SEConstant *)typeClass {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"typeClass" type: typeType code: 'type'];
    return constantObj;
}

+ (SEConstant *)typeIdentifier {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"typeIdentifier" type: typeType code: 'utid'];
    return constantObj;
}

+ (SEConstant *)unicodeText {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"unicodeText" type: typeType code: 'utxt'];
    return constantObj;
}

+ (SEConstant *)unixId {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"unixId" type: typeType code: 'idux'];
    return constantObj;
}

+ (SEConstant *)unsignedInteger {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"unsignedInteger" type: typeType code: 'magn'];
    return constantObj;
}

+ (SEConstant *)user {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"user" type: typeType code: 'uacc'];
    return constantObj;
}

+ (SEConstant *)userDomain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"userDomain" type: typeType code: 'fldu'];
    return constantObj;
}

+ (SEConstant *)userDomainObject {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"userDomainObject" type: typeType code: 'domu'];
    return constantObj;
}

+ (SEConstant *)utf16Text {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"utf16Text" type: typeType code: 'ut16'];
    return constantObj;
}

+ (SEConstant *)utf8Text {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"utf8Text" type: typeType code: 'utf8'];
    return constantObj;
}

+ (SEConstant *)utilitiesFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"utilitiesFolder" type: typeType code: 'uti$'];
    return constantObj;
}

+ (SEConstant *)value {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"value" type: typeType code: 'valL'];
    return constantObj;
}

+ (SEConstant *)valueIndicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"valueIndicator" type: typeType code: 'vali'];
    return constantObj;
}

+ (SEConstant *)version {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (SEConstant *)version_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (SEConstant *)videoDVD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"videoDVD" type: typeType code: 'dhvd'];
    return constantObj;
}

+ (SEConstant *)videoDepth {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"videoDepth" type: typeType code: 'vcdp'];
    return constantObj;
}

+ (SEConstant *)visible {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (SEConstant *)visualCharacteristic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"visualCharacteristic" type: typeType code: 'visu'];
    return constantObj;
}

+ (SEConstant *)volume {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"volume" type: typeType code: 'volu'];
    return constantObj;
}

+ (SEConstant *)window {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (SEConstant *)word {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (SEConstant *)workflowsFolder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"workflowsFolder" type: typeType code: 'flow'];
    return constantObj;
}

+ (SEConstant *)writingCode {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"writingCode" type: typeType code: 'psct'];
    return constantObj;
}

+ (SEConstant *)yards {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"yards" type: typeType code: 'yard'];
    return constantObj;
}

+ (SEConstant *)zone {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"zone" type: typeType code: 'zone'];
    return constantObj;
}

+ (SEConstant *)zoomable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (SEConstant *)zoomed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end


