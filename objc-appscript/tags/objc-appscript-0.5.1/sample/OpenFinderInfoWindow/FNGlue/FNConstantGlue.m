/*
 * FNConstantGlue.m
 * /System/Library/CoreServices/Finder.app
 * osaglue 0.5.1
 *
 */

#import "FNConstantGlue.h"

@implementation FNConstant
+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'padv': return [self AdvancedPreferencesPanel];
        case 'dfph': return [self ApplePhotoFormat];
        case 'dfas': return [self AppleShareFormat];
        case 'apnl': return [self ApplicationPanel];
        case 'apr ': return [self April];
        case 'aug ': return [self August];
        case 'cpnl': return [self CommentsPanel];
        case 'cinl': return [self ContentIndexPanel];
        case 'dec ': return [self December];
        case 'EPS ': return [self EPSPicture];
        case 'dfft': return [self FTPFormat];
        case 'feb ': return [self February];
        case 'pfrp': return [self FinderPreferences];
        case 'brow': return [self FinderWindow];
        case 'fri ': return [self Friday];
        case 'GIFf': return [self GIFPicture];
        case 'gpnl': return [self GeneralInformationPanel];
        case 'pgnp': return [self GeneralPreferencesPanel];
        case 'dfhs': return [self HighSierraFormat];
        case 'df96': return [self ISO9660Format];
        case 'JPEG': return [self JPEGPicture];
        case 'jan ': return [self January];
        case 'jul ': return [self July];
        case 'jun ': return [self June];
        case 'plbp': return [self LabelPreferencesPanel];
        case 'pklg': return [self LanguagesPanel];
        case 'dfms': return [self MSDOSFormat];
        case 'dfh+': return [self MacOSExtendedFormat];
        case 'dfhf': return [self MacOSFormat];
        case 'mar ': return [self March];
        case 'may ': return [self May];
        case 'mpnl': return [self MemoryPanel];
        case 'mon ': return [self Monday];
        case 'dfnf': return [self NFSFormat];
        case 'dfnt': return [self NTFSFormat];
        case 'npnl': return [self NameAndExtensionPanel];
        case 'nov ': return [self November];
        case 'oct ': return [self October];
        case 'PICT': return [self PICTPicture];
        case 'dfpu': return [self PacketWrittenUDFFormat];
        case 'pkpg': return [self PluginsPanel];
        case 'vpnl': return [self PreviewPanel];
        case 'dfpr': return [self ProDOSFormat];
        case 'dfqt': return [self QuickTakeFormat];
        case 'tr16': return [self RGB16Color];
        case 'tr96': return [self RGB96Color];
        case 'cRGB': return [self RGBColor];
        case 'sat ': return [self Saturday];
        case 'sep ': return [self September];
        case 'spnl': return [self SharingPanel];
        case 'psid': return [self SidebarPreferencesPanel];
        case 'sun ': return [self Sunday];
        case 'TIFF': return [self TIFFPicture];
        case 'thu ': return [self Thursday];
        case 'tue ': return [self Tuesday];
        case 'dfud': return [self UDFFormat];
        case 'dfuf': return [self UFSFormat];
        case 'pURL': return [self URL];
        case 'dfwd': return [self WebDAVFormat];
        case 'wed ': return [self Wednesday];
        case 'dfac': return [self XsanFormat];
        case 'isab': return [self acceptsHighLevelEvents];
        case 'revt': return [self acceptsRemoteEvents];
        case 'alis': return [self alias];
        case 'alia': return [self aliasFile];
        case 'alst': return [self aliasList];
        case 'psnx': return [self allNameExtensionsShowing];
        case '****': return [self anything];
        case 'capp': return [self application];
        case 'bund': return [self applicationBundleID];
        case 'appf': return [self applicationFile];
        case 'pcap': return [self applicationProcess];
        case 'rmte': return [self applicationResponses];
        case 'sign': return [self applicationSignature];
        case 'aprl': return [self applicationURL];
        case 'cdta': return [self arrangedByCreationDate];
        case 'kina': return [self arrangedByKind];
        case 'laba': return [self arrangedByLabel];
        case 'mdta': return [self arrangedByModificationDate];
        case 'nama': return [self arrangedByName];
        case 'siza': return [self arrangedBySize];
        case 'iarr': return [self arrangement];
        case 'ask ': return [self ask];
        case 'dfau': return [self audioFormat];
        case 'colr': return [self backgroundColor];
        case 'ibkg': return [self backgroundPicture];
        case 'best': return [self best];
        case 'bool': return [self boolean];
        case 'lbot': return [self bottom];
        case 'qdrt': return [self boundingRectangle];
        case 'pbnd': return [self bounds];
        case 'sfsz': return [self calculatesFolderSizes];
        case 'capa': return [self capacity];
        case 'case': return [self case_];
        case 'cmtr': return [self centimeters];
        case 'gcli': return [self classInfo];
        case 'pcls': return [self class_];
        case 'pcli': return [self clipboard];
        case 'clpf': return [self clipping];
        case 'lwnd': return [self clippingWindow];
        case 'hclb': return [self closeable];
        case 'wshd': return [self collapsed];
        case 'clrt': return [self colorTable];
        case 'lvcl': return [self column];
        case 'clvw': return [self columnView];
        case 'cvop': return [self columnViewOptions];
        case 'comt': return [self comment];
        case 'elsC': return [self commentColumn];
        case 'pexc': return [self completelyExpanded];
        case 'pcmp': return [self computerContainer];
        case 'ccmp': return [self computerObject];
        case 'ctnr': return [self container];
        case 'cwnd': return [self containerWindow];
        case 'ascd': return [self creationDate];
        case 'elsc': return [self creationDateColumn];
        case 'fcrt': return [self creatorType];
        case 'ccmt': return [self cubicCentimeters];
        case 'cfet': return [self cubicFeet];
        case 'cuin': return [self cubicInches];
        case 'cmet': return [self cubicMeters];
        case 'cyrd': return [self cubicYards];
        case 'panl': return [self currentPanel];
        case 'pvew': return [self currentView];
        case 'tdas': return [self dashStyle];
        case 'rdat': return [self data];
        case 'ldt ': return [self date];
        case 'decm': return [self decimalStruct];
        case 'degc': return [self degreesCelsius];
        case 'degf': return [self degreesFahrenheit];
        case 'degk': return [self degreesKelvin];
        case 'dela': return [self delayBeforeSpringing];
        case 'dscr': return [self description_];
        case 'dafi': return [self deskAccessoryFile];
        case 'pcda': return [self deskAccessoryProcess];
        case 'desk': return [self desktop];
        case 'cdsk': return [self desktopObject];
        case 'dpic': return [self desktopPicture];
        case 'dpos': return [self desktopPosition];
        case 'pdsv': return [self desktopShowsConnectedServers];
        case 'pehd': return [self desktopShowsExternalHardDisks];
        case 'pdhd': return [self desktopShowsHardDisks];
        case 'pdrm': return [self desktopShowsRemovableMedia];
        case 'dktw': return [self desktopWindow];
        case 'diac': return [self diacriticals];
        case 'dspr': return [self disclosesPreviewPane];
        case 'cdis': return [self disk];
        case 'dnam': return [self displayedName];
        case 'docf': return [self documentFile];
        case 'comp': return [self doubleInteger];
        case 'isej': return [self ejectable];
        case 'elin': return [self elementInfo];
        case 'encs': return [self encodedString];
        case 'ects': return [self entireContents];
        case 'enum': return [self enumerator];
        case 'evin': return [self eventInfo];
        case 'gstp': return [self everyonesPrivileges];
        case 'pexa': return [self expandable];
        case 'pexp': return [self expanded];
        case 'expa': return [self expansion];
        case 'exte': return [self extendedFloat];
        case 'hidx': return [self extensionHidden];
        case 'feet': return [self feet];
        case 'file': return [self file];
        case 'fsrf': return [self fileRef];
        case 'fss ': return [self fileSpecification];
        case 'asty': return [self fileType];
        case 'furl': return [self fileURL];
        case 'fixd': return [self fixed];
        case 'fpnt': return [self fixedPoint];
        case 'frct': return [self fixedRectangle];
        case 'ldbl': return [self float128bit];
        case 'doub': return [self float_];
        case 'isfl': return [self floating];
        case 'flvw': return [self flowView];
        case 'cfol': return [self folder];
        case 'ponw': return [self foldersOpenInNewWindows];
        case 'sprg': return [self foldersSpringOpen];
        case 'dfmt': return [self format];
        case 'frsp': return [self freeSpace];
        case 'pisf': return [self frontmost];
        case 'galn': return [self gallons];
        case 'gram': return [self grams];
        case 'cgtx': return [self graphicText];
        case 'sgrp': return [self group];
        case 'gppr': return [self groupPrivileges];
        case 'grvw': return [self groupView];
        case 'hscr': return [self hasScriptingTerminology];
        case 'home': return [self home];
        case 'hyph': return [self hyphens];
        case 'iimg': return [self icon];
        case 'ifam': return [self iconFamily];
        case 'lvis': return [self iconSize];
        case 'icnv': return [self iconView];
        case 'icop': return [self iconViewOptions];
        case 'ID  ': return [self id_];
        case 'igpr': return [self ignorePrivileges];
        case 'inch': return [self inches];
        case 'pidx': return [self index];
        case 'iwnd': return [self informationWindow];
        case 'pins': return [self insertionLocation];
        case 'long': return [self integer];
        case 'itxt': return [self internationalText];
        case 'intl': return [self internationalWritingCode];
        case 'inlf': return [self internetLocationFile];
        case 'cobj': return [self item];
        case 'Jrnl': return [self journalingEnabled];
        case 'kpid': return [self kernelProcessID];
        case 'kgrm': return [self kilograms];
        case 'kmtr': return [self kilometers];
        case 'kind': return [self kind];
        case 'elsk': return [self kindColumn];
        case 'clbl': return [self label];
        case 'elsl': return [self labelColumn];
        case 'labi': return [self labelIndex];
        case 'lpos': return [self labelPosition];
        case 'il32': return [self large32BitIcon];
        case 'icl4': return [self large4BitIcon];
        case 'icl8': return [self large8BitIcon];
        case 'l8mk': return [self large8BitMask];
        case 'lgic': return [self largeIcon];
        case 'ICN#': return [self largeMonochromeIconAndMask];
        case 'list': return [self list];
        case 'lsvw': return [self listView];
        case 'lvop': return [self listViewOptions];
        case 'litr': return [self liters];
        case 'isrv': return [self localVolume];
        case 'iloc': return [self location];
        case 'insl': return [self locationReference];
        case 'aslk': return [self locked];
        case 'lfxd': return [self longFixed];
        case 'lfpt': return [self longFixedPoint];
        case 'lfrc': return [self longFixedRectangle];
        case 'lpnt': return [self longPoint];
        case 'lrct': return [self longRectangle];
        case 'port': return [self machPort];
        case 'mach': return [self machine];
        case 'mLoc': return [self machineLocation];
        case 'clwm': return [self maximumWidth];
        case 'metr': return [self meters];
        case 'mile': return [self miles];
        case 'miic': return [self mini];
        case 'mprt': return [self minimumSize];
        case 'clwn': return [self minimumWidth];
        case 'msng': return [self missingValue];
        case 'pmod': return [self modal];
        case 'asmo': return [self modificationDate];
        case 'elsm': return [self modificationDateColumn];
        case 'pnam': return [self name];
        case 'elsn': return [self nameColumn];
        case 'nmxt': return [self nameExtension];
        case 'pnwt': return [self newWindowTarget];
        case 'pocv': return [self newWindowsOpenInColumnView];
        case 'no  ': return [self no];
        case 'none': return [self none];
        case 'snrm': return [self normal];
        case 'narr': return [self notArranged];
        case 'null': return [self null];
        case 'nume': return [self numericStrings];
        case 'Clsc': return [self opensInClassic];
        case 'orig': return [self originalItem];
        case 'ozs ': return [self ounces];
        case 'sown': return [self owner];
        case 'ownr': return [self ownerPrivileges];
        case 'pack': return [self package];
        case 'pmin': return [self parameterInfo];
        case 'pusd': return [self partitionSpaceUsed];
        case 'tpmm': return [self pixelMapRecord];
        case 'QDpt': return [self point];
        case 'posn': return [self position];
        case 'lbs ': return [self pounds];
        case 'cprf': return [self preferences];
        case 'pwnd': return [self preferencesWindow];
        case 'prcs': return [self process];
        case 'psn ': return [self processSerialNumber];
        case 'ver2': return [self productVersion];
        case 'pALL': return [self properties];
        case 'prop': return [self property];
        case 'pinf': return [self propertyInfo];
        case 'punc': return [self punctuation];
        case 'qrts': return [self quarts];
        case 'read': return [self readOnly];
        case 'rdwr': return [self readWrite];
        case 'reco': return [self record];
        case 'obj ': return [self reference];
        case 'prsz': return [self resizable];
        case 'srvs': return [self reversed];
        case 'lrgt': return [self right];
        case 'trot': return [self rotation];
        case 'scpt': return [self script];
        case 'sele': return [self selection];
        case 'sing': return [self shortFloat];
        case 'shor': return [self shortInteger];
        case 'shic': return [self showsIcon];
        case 'prvw': return [self showsIconPreview];
        case 'mnfo': return [self showsItemInfo];
        case 'shpr': return [self showsPreviewColumn];
        case 'sbwi': return [self sidebarWidth];
        case 'ptsz': return [self size];
        case 'phys': return [self size];
        case 'elss': return [self sizeColumn];
        case 'is32': return [self small32BitIcon];
        case 'ics4': return [self small4BitIcon];
        case 'ics8': return [self small8BitIcon];
        case 'smic': return [self smallIcon];
        case 'ics#': return [self smallMonochromeIconAndMask];
        case 'grda': return [self snapToGrid];
        case 'srtc': return [self sortColumn];
        case 'sord': return [self sortDirection];
        case 'sqft': return [self squareFeet];
        case 'sqkm': return [self squareKilometers];
        case 'sqrm': return [self squareMeters];
        case 'sqmi': return [self squareMiles];
        case 'sqyd': return [self squareYards];
        case 'istd': return [self startup];
        case 'sdsk': return [self startupDisk];
        case 'pspd': return [self stationery];
        case 'stvi': return [self statusbarVisible];
        case 'TEXT': return [self string];
        case 'styl': return [self styledClipboardText];
        case 'STXT': return [self styledText];
        case 'sprt': return [self suggestedSize];
        case 'suin': return [self suiteInfo];
        case 'fvtg': return [self target];
        case 'fsiz': return [self textSize];
        case 'tsty': return [self textStyleInfo];
        case 'ptit': return [self titled];
        case 'tbvi': return [self toolbarVisible];
        case 'appt': return [self totalPartitionSize];
        case 'trsh': return [self trash];
        case 'ctrs': return [self trashObject];
        case 'type': return [self typeClass];
        case 'utxt': return [self unicodeText];
        case 'df??': return [self unknownFormat];
        case 'magn': return [self unsignedInteger];
        case 'urdt': return [self usesRelativeDates];
        case 'ut16': return [self utf16Text];
        case 'utf8': return [self utf8Text];
        case 'elsv': return [self versionColumn];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'warn': return [self warnsBeforeEmptying];
        case 'whit': return [self whitespace];
        case 'clwd': return [self width];
        case 'cwin': return [self window];
        case 'writ': return [self writeOnly];
        case 'psct': return [self writingCode];
        case 'yard': return [self yards];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (FNConstant *)AdvancedPreferencesPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"AdvancedPreferencesPanel" type: typeEnumerated code: 'padv'];
    return constantObj;
}

+ (FNConstant *)ApplePhotoFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ApplePhotoFormat" type: typeEnumerated code: 'dfph'];
    return constantObj;
}

+ (FNConstant *)AppleShareFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"AppleShareFormat" type: typeEnumerated code: 'dfas'];
    return constantObj;
}

+ (FNConstant *)ApplicationPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ApplicationPanel" type: typeEnumerated code: 'apnl'];
    return constantObj;
}

+ (FNConstant *)CommentsPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"CommentsPanel" type: typeEnumerated code: 'cpnl'];
    return constantObj;
}

+ (FNConstant *)ContentIndexPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ContentIndexPanel" type: typeEnumerated code: 'cinl'];
    return constantObj;
}

+ (FNConstant *)FTPFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"FTPFormat" type: typeEnumerated code: 'dfft'];
    return constantObj;
}

+ (FNConstant *)GeneralInformationPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"GeneralInformationPanel" type: typeEnumerated code: 'gpnl'];
    return constantObj;
}

+ (FNConstant *)GeneralPreferencesPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"GeneralPreferencesPanel" type: typeEnumerated code: 'pgnp'];
    return constantObj;
}

+ (FNConstant *)HighSierraFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"HighSierraFormat" type: typeEnumerated code: 'dfhs'];
    return constantObj;
}

+ (FNConstant *)ISO9660Format {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ISO9660Format" type: typeEnumerated code: 'df96'];
    return constantObj;
}

+ (FNConstant *)LabelPreferencesPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"LabelPreferencesPanel" type: typeEnumerated code: 'plbp'];
    return constantObj;
}

+ (FNConstant *)LanguagesPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"LanguagesPanel" type: typeEnumerated code: 'pklg'];
    return constantObj;
}

+ (FNConstant *)MSDOSFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"MSDOSFormat" type: typeEnumerated code: 'dfms'];
    return constantObj;
}

+ (FNConstant *)MacOSExtendedFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"MacOSExtendedFormat" type: typeEnumerated code: 'dfh+'];
    return constantObj;
}

+ (FNConstant *)MacOSFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"MacOSFormat" type: typeEnumerated code: 'dfhf'];
    return constantObj;
}

+ (FNConstant *)MemoryPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"MemoryPanel" type: typeEnumerated code: 'mpnl'];
    return constantObj;
}

+ (FNConstant *)NFSFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"NFSFormat" type: typeEnumerated code: 'dfnf'];
    return constantObj;
}

+ (FNConstant *)NTFSFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"NTFSFormat" type: typeEnumerated code: 'dfnt'];
    return constantObj;
}

+ (FNConstant *)NameAndExtensionPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"NameAndExtensionPanel" type: typeEnumerated code: 'npnl'];
    return constantObj;
}

+ (FNConstant *)PacketWrittenUDFFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"PacketWrittenUDFFormat" type: typeEnumerated code: 'dfpu'];
    return constantObj;
}

+ (FNConstant *)PluginsPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"PluginsPanel" type: typeEnumerated code: 'pkpg'];
    return constantObj;
}

+ (FNConstant *)PreviewPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"PreviewPanel" type: typeEnumerated code: 'vpnl'];
    return constantObj;
}

+ (FNConstant *)ProDOSFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ProDOSFormat" type: typeEnumerated code: 'dfpr'];
    return constantObj;
}

+ (FNConstant *)QuickTakeFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"QuickTakeFormat" type: typeEnumerated code: 'dfqt'];
    return constantObj;
}

+ (FNConstant *)SharingPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"SharingPanel" type: typeEnumerated code: 'spnl'];
    return constantObj;
}

+ (FNConstant *)SidebarPreferencesPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"SidebarPreferencesPanel" type: typeEnumerated code: 'psid'];
    return constantObj;
}

+ (FNConstant *)UDFFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"UDFFormat" type: typeEnumerated code: 'dfud'];
    return constantObj;
}

+ (FNConstant *)UFSFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"UFSFormat" type: typeEnumerated code: 'dfuf'];
    return constantObj;
}

+ (FNConstant *)WebDAVFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"WebDAVFormat" type: typeEnumerated code: 'dfwd'];
    return constantObj;
}

+ (FNConstant *)XsanFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"XsanFormat" type: typeEnumerated code: 'dfac'];
    return constantObj;
}

+ (FNConstant *)applicationResponses {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"applicationResponses" type: typeEnumerated code: 'rmte'];
    return constantObj;
}

+ (FNConstant *)arrangedByCreationDate {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangedByCreationDate" type: typeEnumerated code: 'cdta'];
    return constantObj;
}

+ (FNConstant *)arrangedByKind {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangedByKind" type: typeEnumerated code: 'kina'];
    return constantObj;
}

+ (FNConstant *)arrangedByLabel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangedByLabel" type: typeEnumerated code: 'laba'];
    return constantObj;
}

+ (FNConstant *)arrangedByModificationDate {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangedByModificationDate" type: typeEnumerated code: 'mdta'];
    return constantObj;
}

+ (FNConstant *)arrangedByName {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangedByName" type: typeEnumerated code: 'nama'];
    return constantObj;
}

+ (FNConstant *)arrangedBySize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangedBySize" type: typeEnumerated code: 'siza'];
    return constantObj;
}

+ (FNConstant *)ask {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (FNConstant *)audioFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"audioFormat" type: typeEnumerated code: 'dfau'];
    return constantObj;
}

+ (FNConstant *)bottom {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"bottom" type: typeEnumerated code: 'lbot'];
    return constantObj;
}

+ (FNConstant *)case_ {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"case_" type: typeEnumerated code: 'case'];
    return constantObj;
}

+ (FNConstant *)columnView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"columnView" type: typeEnumerated code: 'clvw'];
    return constantObj;
}

+ (FNConstant *)comment {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"comment" type: typeEnumerated code: 'comt'];
    return constantObj;
}

+ (FNConstant *)commentColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"commentColumn" type: typeEnumerated code: 'elsC'];
    return constantObj;
}

+ (FNConstant *)creationDate {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"creationDate" type: typeEnumerated code: 'ascd'];
    return constantObj;
}

+ (FNConstant *)creationDateColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"creationDateColumn" type: typeEnumerated code: 'elsc'];
    return constantObj;
}

+ (FNConstant *)diacriticals {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"diacriticals" type: typeEnumerated code: 'diac'];
    return constantObj;
}

+ (FNConstant *)expansion {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"expansion" type: typeEnumerated code: 'expa'];
    return constantObj;
}

+ (FNConstant *)flowView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"flowView" type: typeEnumerated code: 'flvw'];
    return constantObj;
}

+ (FNConstant *)groupView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"groupView" type: typeEnumerated code: 'grvw'];
    return constantObj;
}

+ (FNConstant *)hyphens {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"hyphens" type: typeEnumerated code: 'hyph'];
    return constantObj;
}

+ (FNConstant *)iconView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"iconView" type: typeEnumerated code: 'icnv'];
    return constantObj;
}

+ (FNConstant *)kind {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"kind" type: typeEnumerated code: 'kind'];
    return constantObj;
}

+ (FNConstant *)kindColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"kindColumn" type: typeEnumerated code: 'elsk'];
    return constantObj;
}

+ (FNConstant *)labelColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"labelColumn" type: typeEnumerated code: 'elsl'];
    return constantObj;
}

+ (FNConstant *)labelIndex {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"labelIndex" type: typeEnumerated code: 'labi'];
    return constantObj;
}

+ (FNConstant *)large {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"large" type: typeEnumerated code: 'lgic'];
    return constantObj;
}

+ (FNConstant *)largeIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"largeIcon" type: typeEnumerated code: 'lgic'];
    return constantObj;
}

+ (FNConstant *)listView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"listView" type: typeEnumerated code: 'lsvw'];
    return constantObj;
}

+ (FNConstant *)mini {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"mini" type: typeEnumerated code: 'miic'];
    return constantObj;
}

+ (FNConstant *)modificationDate {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"modificationDate" type: typeEnumerated code: 'asmo'];
    return constantObj;
}

+ (FNConstant *)modificationDateColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"modificationDateColumn" type: typeEnumerated code: 'elsm'];
    return constantObj;
}

+ (FNConstant *)name {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"name" type: typeEnumerated code: 'pnam'];
    return constantObj;
}

+ (FNConstant *)nameColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"nameColumn" type: typeEnumerated code: 'elsn'];
    return constantObj;
}

+ (FNConstant *)no {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (FNConstant *)none {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"none" type: typeEnumerated code: 'none'];
    return constantObj;
}

+ (FNConstant *)normal {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"normal" type: typeEnumerated code: 'snrm'];
    return constantObj;
}

+ (FNConstant *)notArranged {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"notArranged" type: typeEnumerated code: 'narr'];
    return constantObj;
}

+ (FNConstant *)numericStrings {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"numericStrings" type: typeEnumerated code: 'nume'];
    return constantObj;
}

+ (FNConstant *)punctuation {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"punctuation" type: typeEnumerated code: 'punc'];
    return constantObj;
}

+ (FNConstant *)readOnly {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"readOnly" type: typeEnumerated code: 'read'];
    return constantObj;
}

+ (FNConstant *)readWrite {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"readWrite" type: typeEnumerated code: 'rdwr'];
    return constantObj;
}

+ (FNConstant *)reversed {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"reversed" type: typeEnumerated code: 'srvs'];
    return constantObj;
}

+ (FNConstant *)right {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"right" type: typeEnumerated code: 'lrgt'];
    return constantObj;
}

+ (FNConstant *)size {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"size" type: typeEnumerated code: 'phys'];
    return constantObj;
}

+ (FNConstant *)sizeColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"sizeColumn" type: typeEnumerated code: 'elss'];
    return constantObj;
}

+ (FNConstant *)small {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"small" type: typeEnumerated code: 'smic'];
    return constantObj;
}

+ (FNConstant *)smallIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"smallIcon" type: typeEnumerated code: 'smic'];
    return constantObj;
}

+ (FNConstant *)snapToGrid {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"snapToGrid" type: typeEnumerated code: 'grda'];
    return constantObj;
}

+ (FNConstant *)unknownFormat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"unknownFormat" type: typeEnumerated code: 'df??'];
    return constantObj;
}

+ (FNConstant *)versionColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"versionColumn" type: typeEnumerated code: 'elsv'];
    return constantObj;
}

+ (FNConstant *)version_ {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"version_" type: typeEnumerated code: 'vers'];
    return constantObj;
}

+ (FNConstant *)whitespace {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"whitespace" type: typeEnumerated code: 'whit'];
    return constantObj;
}

+ (FNConstant *)writeOnly {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"writeOnly" type: typeEnumerated code: 'writ'];
    return constantObj;
}

+ (FNConstant *)yes {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (FNConstant *)April {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"April" type: typeType code: 'apr '];
    return constantObj;
}

+ (FNConstant *)August {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"August" type: typeType code: 'aug '];
    return constantObj;
}

+ (FNConstant *)December {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"December" type: typeType code: 'dec '];
    return constantObj;
}

+ (FNConstant *)EPSPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"EPSPicture" type: typeType code: 'EPS '];
    return constantObj;
}

+ (FNConstant *)February {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"February" type: typeType code: 'feb '];
    return constantObj;
}

+ (FNConstant *)FinderPreferences {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"FinderPreferences" type: typeType code: 'pfrp'];
    return constantObj;
}

+ (FNConstant *)FinderWindow {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"FinderWindow" type: typeType code: 'brow'];
    return constantObj;
}

+ (FNConstant *)Friday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Friday" type: typeType code: 'fri '];
    return constantObj;
}

+ (FNConstant *)GIFPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"GIFPicture" type: typeType code: 'GIFf'];
    return constantObj;
}

+ (FNConstant *)JPEGPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"JPEGPicture" type: typeType code: 'JPEG'];
    return constantObj;
}

+ (FNConstant *)January {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"January" type: typeType code: 'jan '];
    return constantObj;
}

+ (FNConstant *)July {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"July" type: typeType code: 'jul '];
    return constantObj;
}

+ (FNConstant *)June {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"June" type: typeType code: 'jun '];
    return constantObj;
}

+ (FNConstant *)March {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"March" type: typeType code: 'mar '];
    return constantObj;
}

+ (FNConstant *)May {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"May" type: typeType code: 'may '];
    return constantObj;
}

+ (FNConstant *)Monday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Monday" type: typeType code: 'mon '];
    return constantObj;
}

+ (FNConstant *)November {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"November" type: typeType code: 'nov '];
    return constantObj;
}

+ (FNConstant *)October {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"October" type: typeType code: 'oct '];
    return constantObj;
}

+ (FNConstant *)PICTPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"PICTPicture" type: typeType code: 'PICT'];
    return constantObj;
}

+ (FNConstant *)RGB16Color {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"RGB16Color" type: typeType code: 'tr16'];
    return constantObj;
}

+ (FNConstant *)RGB96Color {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"RGB96Color" type: typeType code: 'tr96'];
    return constantObj;
}

+ (FNConstant *)RGBColor {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"RGBColor" type: typeType code: 'cRGB'];
    return constantObj;
}

+ (FNConstant *)Saturday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Saturday" type: typeType code: 'sat '];
    return constantObj;
}

+ (FNConstant *)September {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"September" type: typeType code: 'sep '];
    return constantObj;
}

+ (FNConstant *)Sunday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Sunday" type: typeType code: 'sun '];
    return constantObj;
}

+ (FNConstant *)TIFFPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"TIFFPicture" type: typeType code: 'TIFF'];
    return constantObj;
}

+ (FNConstant *)Thursday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Thursday" type: typeType code: 'thu '];
    return constantObj;
}

+ (FNConstant *)Tuesday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Tuesday" type: typeType code: 'tue '];
    return constantObj;
}

+ (FNConstant *)URL {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"URL" type: typeType code: 'pURL'];
    return constantObj;
}

+ (FNConstant *)Wednesday {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"Wednesday" type: typeType code: 'wed '];
    return constantObj;
}

+ (FNConstant *)acceptsHighLevelEvents {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"acceptsHighLevelEvents" type: typeType code: 'isab'];
    return constantObj;
}

+ (FNConstant *)acceptsRemoteEvents {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"acceptsRemoteEvents" type: typeType code: 'revt'];
    return constantObj;
}

+ (FNConstant *)alias {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (FNConstant *)aliasFile {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"aliasFile" type: typeType code: 'alia'];
    return constantObj;
}

+ (FNConstant *)aliasList {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"aliasList" type: typeType code: 'alst'];
    return constantObj;
}

+ (FNConstant *)allNameExtensionsShowing {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"allNameExtensionsShowing" type: typeType code: 'psnx'];
    return constantObj;
}

+ (FNConstant *)anything {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"anything" type: typeType code: '****'];
    return constantObj;
}

+ (FNConstant *)application {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (FNConstant *)applicationBundleID {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"applicationBundleID" type: typeType code: 'bund'];
    return constantObj;
}

+ (FNConstant *)applicationFile {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"applicationFile" type: typeType code: 'appf'];
    return constantObj;
}

+ (FNConstant *)applicationProcess {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"applicationProcess" type: typeType code: 'pcap'];
    return constantObj;
}

+ (FNConstant *)applicationSignature {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"applicationSignature" type: typeType code: 'sign'];
    return constantObj;
}

+ (FNConstant *)applicationURL {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"applicationURL" type: typeType code: 'aprl'];
    return constantObj;
}

+ (FNConstant *)arrangement {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"arrangement" type: typeType code: 'iarr'];
    return constantObj;
}

+ (FNConstant *)backgroundColor {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"backgroundColor" type: typeType code: 'colr'];
    return constantObj;
}

+ (FNConstant *)backgroundPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"backgroundPicture" type: typeType code: 'ibkg'];
    return constantObj;
}

+ (FNConstant *)best {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"best" type: typeType code: 'best'];
    return constantObj;
}

+ (FNConstant *)boolean {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"boolean" type: typeType code: 'bool'];
    return constantObj;
}

+ (FNConstant *)boundingRectangle {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"boundingRectangle" type: typeType code: 'qdrt'];
    return constantObj;
}

+ (FNConstant *)bounds {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (FNConstant *)calculatesFolderSizes {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"calculatesFolderSizes" type: typeType code: 'sfsz'];
    return constantObj;
}

+ (FNConstant *)capacity {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"capacity" type: typeType code: 'capa'];
    return constantObj;
}

+ (FNConstant *)centimeters {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"centimeters" type: typeType code: 'cmtr'];
    return constantObj;
}

+ (FNConstant *)classInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"classInfo" type: typeType code: 'gcli'];
    return constantObj;
}

+ (FNConstant *)class_ {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (FNConstant *)clipboard {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"clipboard" type: typeType code: 'pcli'];
    return constantObj;
}

+ (FNConstant *)clipping {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"clipping" type: typeType code: 'clpf'];
    return constantObj;
}

+ (FNConstant *)clippingWindow {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"clippingWindow" type: typeType code: 'lwnd'];
    return constantObj;
}

+ (FNConstant *)closeable {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (FNConstant *)collapsed {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"collapsed" type: typeType code: 'wshd'];
    return constantObj;
}

+ (FNConstant *)color {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (FNConstant *)colorTable {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"colorTable" type: typeType code: 'clrt'];
    return constantObj;
}

+ (FNConstant *)column {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"column" type: typeType code: 'lvcl'];
    return constantObj;
}

+ (FNConstant *)columnViewOptions {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"columnViewOptions" type: typeType code: 'cvop'];
    return constantObj;
}

+ (FNConstant *)completelyExpanded {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"completelyExpanded" type: typeType code: 'pexc'];
    return constantObj;
}

+ (FNConstant *)computerContainer {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"computerContainer" type: typeType code: 'pcmp'];
    return constantObj;
}

+ (FNConstant *)computerObject {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"computerObject" type: typeType code: 'ccmp'];
    return constantObj;
}

+ (FNConstant *)container {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"container" type: typeType code: 'ctnr'];
    return constantObj;
}

+ (FNConstant *)containerWindow {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"containerWindow" type: typeType code: 'cwnd'];
    return constantObj;
}

+ (FNConstant *)creatorType {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"creatorType" type: typeType code: 'fcrt'];
    return constantObj;
}

+ (FNConstant *)cubicCentimeters {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"cubicCentimeters" type: typeType code: 'ccmt'];
    return constantObj;
}

+ (FNConstant *)cubicFeet {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"cubicFeet" type: typeType code: 'cfet'];
    return constantObj;
}

+ (FNConstant *)cubicInches {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"cubicInches" type: typeType code: 'cuin'];
    return constantObj;
}

+ (FNConstant *)cubicMeters {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"cubicMeters" type: typeType code: 'cmet'];
    return constantObj;
}

+ (FNConstant *)cubicYards {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"cubicYards" type: typeType code: 'cyrd'];
    return constantObj;
}

+ (FNConstant *)currentPanel {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"currentPanel" type: typeType code: 'panl'];
    return constantObj;
}

+ (FNConstant *)currentView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"currentView" type: typeType code: 'pvew'];
    return constantObj;
}

+ (FNConstant *)dashStyle {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"dashStyle" type: typeType code: 'tdas'];
    return constantObj;
}

+ (FNConstant *)data {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"data" type: typeType code: 'rdat'];
    return constantObj;
}

+ (FNConstant *)date {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"date" type: typeType code: 'ldt '];
    return constantObj;
}

+ (FNConstant *)decimalStruct {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"decimalStruct" type: typeType code: 'decm'];
    return constantObj;
}

+ (FNConstant *)degreesCelsius {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"degreesCelsius" type: typeType code: 'degc'];
    return constantObj;
}

+ (FNConstant *)degreesFahrenheit {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"degreesFahrenheit" type: typeType code: 'degf'];
    return constantObj;
}

+ (FNConstant *)degreesKelvin {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"degreesKelvin" type: typeType code: 'degk'];
    return constantObj;
}

+ (FNConstant *)delayBeforeSpringing {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"delayBeforeSpringing" type: typeType code: 'dela'];
    return constantObj;
}

+ (FNConstant *)description_ {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"description_" type: typeType code: 'dscr'];
    return constantObj;
}

+ (FNConstant *)deskAccessoryFile {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"deskAccessoryFile" type: typeType code: 'dafi'];
    return constantObj;
}

+ (FNConstant *)deskAccessoryProcess {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"deskAccessoryProcess" type: typeType code: 'pcda'];
    return constantObj;
}

+ (FNConstant *)desktop {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktop" type: typeType code: 'desk'];
    return constantObj;
}

+ (FNConstant *)desktopObject {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopObject" type: typeType code: 'cdsk'];
    return constantObj;
}

+ (FNConstant *)desktopPicture {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopPicture" type: typeType code: 'dpic'];
    return constantObj;
}

+ (FNConstant *)desktopPosition {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopPosition" type: typeType code: 'dpos'];
    return constantObj;
}

+ (FNConstant *)desktopShowsConnectedServers {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopShowsConnectedServers" type: typeType code: 'pdsv'];
    return constantObj;
}

+ (FNConstant *)desktopShowsExternalHardDisks {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopShowsExternalHardDisks" type: typeType code: 'pehd'];
    return constantObj;
}

+ (FNConstant *)desktopShowsHardDisks {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopShowsHardDisks" type: typeType code: 'pdhd'];
    return constantObj;
}

+ (FNConstant *)desktopShowsRemovableMedia {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopShowsRemovableMedia" type: typeType code: 'pdrm'];
    return constantObj;
}

+ (FNConstant *)desktopWindow {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"desktopWindow" type: typeType code: 'dktw'];
    return constantObj;
}

+ (FNConstant *)disclosesPreviewPane {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"disclosesPreviewPane" type: typeType code: 'dspr'];
    return constantObj;
}

+ (FNConstant *)disk {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"disk" type: typeType code: 'cdis'];
    return constantObj;
}

+ (FNConstant *)displayedName {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"displayedName" type: typeType code: 'dnam'];
    return constantObj;
}

+ (FNConstant *)documentFile {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"documentFile" type: typeType code: 'docf'];
    return constantObj;
}

+ (FNConstant *)doubleInteger {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"doubleInteger" type: typeType code: 'comp'];
    return constantObj;
}

+ (FNConstant *)ejectable {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ejectable" type: typeType code: 'isej'];
    return constantObj;
}

+ (FNConstant *)elementInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"elementInfo" type: typeType code: 'elin'];
    return constantObj;
}

+ (FNConstant *)encodedString {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"encodedString" type: typeType code: 'encs'];
    return constantObj;
}

+ (FNConstant *)entireContents {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"entireContents" type: typeType code: 'ects'];
    return constantObj;
}

+ (FNConstant *)enumerator {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"enumerator" type: typeType code: 'enum'];
    return constantObj;
}

+ (FNConstant *)eventInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"eventInfo" type: typeType code: 'evin'];
    return constantObj;
}

+ (FNConstant *)everyonesPrivileges {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"everyonesPrivileges" type: typeType code: 'gstp'];
    return constantObj;
}

+ (FNConstant *)expandable {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"expandable" type: typeType code: 'pexa'];
    return constantObj;
}

+ (FNConstant *)expanded {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"expanded" type: typeType code: 'pexp'];
    return constantObj;
}

+ (FNConstant *)extendedFloat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"extendedFloat" type: typeType code: 'exte'];
    return constantObj;
}

+ (FNConstant *)extensionHidden {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"extensionHidden" type: typeType code: 'hidx'];
    return constantObj;
}

+ (FNConstant *)feet {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"feet" type: typeType code: 'feet'];
    return constantObj;
}

+ (FNConstant *)file {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"file" type: typeType code: 'file'];
    return constantObj;
}

+ (FNConstant *)fileRef {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fileRef" type: typeType code: 'fsrf'];
    return constantObj;
}

+ (FNConstant *)fileSpecification {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fileSpecification" type: typeType code: 'fss '];
    return constantObj;
}

+ (FNConstant *)fileType {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fileType" type: typeType code: 'asty'];
    return constantObj;
}

+ (FNConstant *)fileURL {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fileURL" type: typeType code: 'furl'];
    return constantObj;
}

+ (FNConstant *)fixed {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fixed" type: typeType code: 'fixd'];
    return constantObj;
}

+ (FNConstant *)fixedPoint {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fixedPoint" type: typeType code: 'fpnt'];
    return constantObj;
}

+ (FNConstant *)fixedRectangle {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"fixedRectangle" type: typeType code: 'frct'];
    return constantObj;
}

+ (FNConstant *)float128bit {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"float128bit" type: typeType code: 'ldbl'];
    return constantObj;
}

+ (FNConstant *)float_ {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"float_" type: typeType code: 'doub'];
    return constantObj;
}

+ (FNConstant *)floating {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (FNConstant *)folder {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"folder" type: typeType code: 'cfol'];
    return constantObj;
}

+ (FNConstant *)foldersOpenInNewWindows {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"foldersOpenInNewWindows" type: typeType code: 'ponw'];
    return constantObj;
}

+ (FNConstant *)foldersSpringOpen {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"foldersSpringOpen" type: typeType code: 'sprg'];
    return constantObj;
}

+ (FNConstant *)format {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"format" type: typeType code: 'dfmt'];
    return constantObj;
}

+ (FNConstant *)freeSpace {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"freeSpace" type: typeType code: 'frsp'];
    return constantObj;
}

+ (FNConstant *)frontmost {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (FNConstant *)gallons {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"gallons" type: typeType code: 'galn'];
    return constantObj;
}

+ (FNConstant *)grams {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"grams" type: typeType code: 'gram'];
    return constantObj;
}

+ (FNConstant *)graphicText {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"graphicText" type: typeType code: 'cgtx'];
    return constantObj;
}

+ (FNConstant *)group {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"group" type: typeType code: 'sgrp'];
    return constantObj;
}

+ (FNConstant *)groupPrivileges {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"groupPrivileges" type: typeType code: 'gppr'];
    return constantObj;
}

+ (FNConstant *)hasScriptingTerminology {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"hasScriptingTerminology" type: typeType code: 'hscr'];
    return constantObj;
}

+ (FNConstant *)home {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"home" type: typeType code: 'home'];
    return constantObj;
}

+ (FNConstant *)icon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"icon" type: typeType code: 'iimg'];
    return constantObj;
}

+ (FNConstant *)iconFamily {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"iconFamily" type: typeType code: 'ifam'];
    return constantObj;
}

+ (FNConstant *)iconSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"iconSize" type: typeType code: 'lvis'];
    return constantObj;
}

+ (FNConstant *)iconViewOptions {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"iconViewOptions" type: typeType code: 'icop'];
    return constantObj;
}

+ (FNConstant *)id_ {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (FNConstant *)ignorePrivileges {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ignorePrivileges" type: typeType code: 'igpr'];
    return constantObj;
}

+ (FNConstant *)inches {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"inches" type: typeType code: 'inch'];
    return constantObj;
}

+ (FNConstant *)index {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (FNConstant *)informationWindow {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"informationWindow" type: typeType code: 'iwnd'];
    return constantObj;
}

+ (FNConstant *)insertionLocation {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"insertionLocation" type: typeType code: 'pins'];
    return constantObj;
}

+ (FNConstant *)integer {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"integer" type: typeType code: 'long'];
    return constantObj;
}

+ (FNConstant *)internationalText {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"internationalText" type: typeType code: 'itxt'];
    return constantObj;
}

+ (FNConstant *)internationalWritingCode {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"internationalWritingCode" type: typeType code: 'intl'];
    return constantObj;
}

+ (FNConstant *)internetLocationFile {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"internetLocationFile" type: typeType code: 'inlf'];
    return constantObj;
}

+ (FNConstant *)item {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (FNConstant *)journalingEnabled {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"journalingEnabled" type: typeType code: 'Jrnl'];
    return constantObj;
}

+ (FNConstant *)kernelProcessID {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"kernelProcessID" type: typeType code: 'kpid'];
    return constantObj;
}

+ (FNConstant *)kilograms {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"kilograms" type: typeType code: 'kgrm'];
    return constantObj;
}

+ (FNConstant *)kilometers {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"kilometers" type: typeType code: 'kmtr'];
    return constantObj;
}

+ (FNConstant *)label {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"label" type: typeType code: 'clbl'];
    return constantObj;
}

+ (FNConstant *)labelPosition {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"labelPosition" type: typeType code: 'lpos'];
    return constantObj;
}

+ (FNConstant *)large32BitIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"large32BitIcon" type: typeType code: 'il32'];
    return constantObj;
}

+ (FNConstant *)large4BitIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"large4BitIcon" type: typeType code: 'icl4'];
    return constantObj;
}

+ (FNConstant *)large8BitIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"large8BitIcon" type: typeType code: 'icl8'];
    return constantObj;
}

+ (FNConstant *)large8BitMask {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"large8BitMask" type: typeType code: 'l8mk'];
    return constantObj;
}

+ (FNConstant *)largeMonochromeIconAndMask {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"largeMonochromeIconAndMask" type: typeType code: 'ICN#'];
    return constantObj;
}

+ (FNConstant *)list {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (FNConstant *)listViewOptions {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"listViewOptions" type: typeType code: 'lvop'];
    return constantObj;
}

+ (FNConstant *)liters {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"liters" type: typeType code: 'litr'];
    return constantObj;
}

+ (FNConstant *)localVolume {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"localVolume" type: typeType code: 'isrv'];
    return constantObj;
}

+ (FNConstant *)location {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"location" type: typeType code: 'iloc'];
    return constantObj;
}

+ (FNConstant *)locationReference {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"locationReference" type: typeType code: 'insl'];
    return constantObj;
}

+ (FNConstant *)locked {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"locked" type: typeType code: 'aslk'];
    return constantObj;
}

+ (FNConstant *)longFixed {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"longFixed" type: typeType code: 'lfxd'];
    return constantObj;
}

+ (FNConstant *)longFixedPoint {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"longFixedPoint" type: typeType code: 'lfpt'];
    return constantObj;
}

+ (FNConstant *)longFixedRectangle {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"longFixedRectangle" type: typeType code: 'lfrc'];
    return constantObj;
}

+ (FNConstant *)longPoint {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"longPoint" type: typeType code: 'lpnt'];
    return constantObj;
}

+ (FNConstant *)longRectangle {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"longRectangle" type: typeType code: 'lrct'];
    return constantObj;
}

+ (FNConstant *)machPort {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"machPort" type: typeType code: 'port'];
    return constantObj;
}

+ (FNConstant *)machine {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"machine" type: typeType code: 'mach'];
    return constantObj;
}

+ (FNConstant *)machineLocation {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"machineLocation" type: typeType code: 'mLoc'];
    return constantObj;
}

+ (FNConstant *)maximumWidth {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"maximumWidth" type: typeType code: 'clwm'];
    return constantObj;
}

+ (FNConstant *)meters {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"meters" type: typeType code: 'metr'];
    return constantObj;
}

+ (FNConstant *)miles {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"miles" type: typeType code: 'mile'];
    return constantObj;
}

+ (FNConstant *)minimumSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"minimumSize" type: typeType code: 'mprt'];
    return constantObj;
}

+ (FNConstant *)minimumWidth {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"minimumWidth" type: typeType code: 'clwn'];
    return constantObj;
}

+ (FNConstant *)missingValue {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"missingValue" type: typeType code: 'msng'];
    return constantObj;
}

+ (FNConstant *)modal {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (FNConstant *)nameExtension {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"nameExtension" type: typeType code: 'nmxt'];
    return constantObj;
}

+ (FNConstant *)newWindowTarget {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"newWindowTarget" type: typeType code: 'pnwt'];
    return constantObj;
}

+ (FNConstant *)newWindowsOpenInColumnView {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"newWindowsOpenInColumnView" type: typeType code: 'pocv'];
    return constantObj;
}

+ (FNConstant *)null {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"null" type: typeType code: 'null'];
    return constantObj;
}

+ (FNConstant *)opensInClassic {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"opensInClassic" type: typeType code: 'Clsc'];
    return constantObj;
}

+ (FNConstant *)originalItem {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"originalItem" type: typeType code: 'orig'];
    return constantObj;
}

+ (FNConstant *)ounces {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ounces" type: typeType code: 'ozs '];
    return constantObj;
}

+ (FNConstant *)owner {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"owner" type: typeType code: 'sown'];
    return constantObj;
}

+ (FNConstant *)ownerPrivileges {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"ownerPrivileges" type: typeType code: 'ownr'];
    return constantObj;
}

+ (FNConstant *)package {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"package" type: typeType code: 'pack'];
    return constantObj;
}

+ (FNConstant *)parameterInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"parameterInfo" type: typeType code: 'pmin'];
    return constantObj;
}

+ (FNConstant *)partitionSpaceUsed {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"partitionSpaceUsed" type: typeType code: 'pusd'];
    return constantObj;
}

+ (FNConstant *)physicalSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"physicalSize" type: typeType code: 'phys'];
    return constantObj;
}

+ (FNConstant *)pixelMapRecord {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"pixelMapRecord" type: typeType code: 'tpmm'];
    return constantObj;
}

+ (FNConstant *)point {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"point" type: typeType code: 'QDpt'];
    return constantObj;
}

+ (FNConstant *)position {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"position" type: typeType code: 'posn'];
    return constantObj;
}

+ (FNConstant *)pounds {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"pounds" type: typeType code: 'lbs '];
    return constantObj;
}

+ (FNConstant *)preferences {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"preferences" type: typeType code: 'cprf'];
    return constantObj;
}

+ (FNConstant *)preferencesWindow {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"preferencesWindow" type: typeType code: 'pwnd'];
    return constantObj;
}

+ (FNConstant *)preferredSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"preferredSize" type: typeType code: 'appt'];
    return constantObj;
}

+ (FNConstant *)process {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"process" type: typeType code: 'prcs'];
    return constantObj;
}

+ (FNConstant *)processSerialNumber {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"processSerialNumber" type: typeType code: 'psn '];
    return constantObj;
}

+ (FNConstant *)productVersion {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"productVersion" type: typeType code: 'ver2'];
    return constantObj;
}

+ (FNConstant *)properties {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (FNConstant *)property {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"property" type: typeType code: 'prop'];
    return constantObj;
}

+ (FNConstant *)propertyInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"propertyInfo" type: typeType code: 'pinf'];
    return constantObj;
}

+ (FNConstant *)quarts {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"quarts" type: typeType code: 'qrts'];
    return constantObj;
}

+ (FNConstant *)record {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"record" type: typeType code: 'reco'];
    return constantObj;
}

+ (FNConstant *)reference {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"reference" type: typeType code: 'obj '];
    return constantObj;
}

+ (FNConstant *)resizable {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (FNConstant *)rotation {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"rotation" type: typeType code: 'trot'];
    return constantObj;
}

+ (FNConstant *)script {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (FNConstant *)selection {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"selection" type: typeType code: 'sele'];
    return constantObj;
}

+ (FNConstant *)shortFloat {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"shortFloat" type: typeType code: 'sing'];
    return constantObj;
}

+ (FNConstant *)shortInteger {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"shortInteger" type: typeType code: 'shor'];
    return constantObj;
}

+ (FNConstant *)showsIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"showsIcon" type: typeType code: 'shic'];
    return constantObj;
}

+ (FNConstant *)showsIconPreview {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"showsIconPreview" type: typeType code: 'prvw'];
    return constantObj;
}

+ (FNConstant *)showsItemInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"showsItemInfo" type: typeType code: 'mnfo'];
    return constantObj;
}

+ (FNConstant *)showsPreviewColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"showsPreviewColumn" type: typeType code: 'shpr'];
    return constantObj;
}

+ (FNConstant *)sidebarWidth {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"sidebarWidth" type: typeType code: 'sbwi'];
    return constantObj;
}

+ (FNConstant *)small32BitIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"small32BitIcon" type: typeType code: 'is32'];
    return constantObj;
}

+ (FNConstant *)small4BitIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"small4BitIcon" type: typeType code: 'ics4'];
    return constantObj;
}

+ (FNConstant *)small8BitIcon {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"small8BitIcon" type: typeType code: 'ics8'];
    return constantObj;
}

+ (FNConstant *)small8BitMask {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"small8BitMask" type: typeType code: 'ics8'];
    return constantObj;
}

+ (FNConstant *)smallMonochromeIconAndMask {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"smallMonochromeIconAndMask" type: typeType code: 'ics#'];
    return constantObj;
}

+ (FNConstant *)sortColumn {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"sortColumn" type: typeType code: 'srtc'];
    return constantObj;
}

+ (FNConstant *)sortDirection {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"sortDirection" type: typeType code: 'sord'];
    return constantObj;
}

+ (FNConstant *)squareFeet {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"squareFeet" type: typeType code: 'sqft'];
    return constantObj;
}

+ (FNConstant *)squareKilometers {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"squareKilometers" type: typeType code: 'sqkm'];
    return constantObj;
}

+ (FNConstant *)squareMeters {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"squareMeters" type: typeType code: 'sqrm'];
    return constantObj;
}

+ (FNConstant *)squareMiles {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"squareMiles" type: typeType code: 'sqmi'];
    return constantObj;
}

+ (FNConstant *)squareYards {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"squareYards" type: typeType code: 'sqyd'];
    return constantObj;
}

+ (FNConstant *)startup {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"startup" type: typeType code: 'istd'];
    return constantObj;
}

+ (FNConstant *)startupDisk {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"startupDisk" type: typeType code: 'sdsk'];
    return constantObj;
}

+ (FNConstant *)stationery {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"stationery" type: typeType code: 'pspd'];
    return constantObj;
}

+ (FNConstant *)statusbarVisible {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"statusbarVisible" type: typeType code: 'stvi'];
    return constantObj;
}

+ (FNConstant *)string {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"string" type: typeType code: 'TEXT'];
    return constantObj;
}

+ (FNConstant *)styledClipboardText {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"styledClipboardText" type: typeType code: 'styl'];
    return constantObj;
}

+ (FNConstant *)styledText {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"styledText" type: typeType code: 'STXT'];
    return constantObj;
}

+ (FNConstant *)suggestedSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"suggestedSize" type: typeType code: 'sprt'];
    return constantObj;
}

+ (FNConstant *)suiteInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"suiteInfo" type: typeType code: 'suin'];
    return constantObj;
}

+ (FNConstant *)target {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"target" type: typeType code: 'fvtg'];
    return constantObj;
}

+ (FNConstant *)textSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"textSize" type: typeType code: 'fsiz'];
    return constantObj;
}

+ (FNConstant *)textStyleInfo {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"textStyleInfo" type: typeType code: 'tsty'];
    return constantObj;
}

+ (FNConstant *)titled {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (FNConstant *)toolbarVisible {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"toolbarVisible" type: typeType code: 'tbvi'];
    return constantObj;
}

+ (FNConstant *)totalPartitionSize {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"totalPartitionSize" type: typeType code: 'appt'];
    return constantObj;
}

+ (FNConstant *)trash {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"trash" type: typeType code: 'trsh'];
    return constantObj;
}

+ (FNConstant *)trashObject {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"trashObject" type: typeType code: 'ctrs'];
    return constantObj;
}

+ (FNConstant *)typeClass {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"typeClass" type: typeType code: 'type'];
    return constantObj;
}

+ (FNConstant *)unicodeText {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"unicodeText" type: typeType code: 'utxt'];
    return constantObj;
}

+ (FNConstant *)unsignedInteger {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"unsignedInteger" type: typeType code: 'magn'];
    return constantObj;
}

+ (FNConstant *)usesRelativeDates {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"usesRelativeDates" type: typeType code: 'urdt'];
    return constantObj;
}

+ (FNConstant *)utf16Text {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"utf16Text" type: typeType code: 'ut16'];
    return constantObj;
}

+ (FNConstant *)utf8Text {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"utf8Text" type: typeType code: 'utf8'];
    return constantObj;
}

+ (FNConstant *)version {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (FNConstant *)visible {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (FNConstant *)warnsBeforeEmptying {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"warnsBeforeEmptying" type: typeType code: 'warn'];
    return constantObj;
}

+ (FNConstant *)width {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"width" type: typeType code: 'clwd'];
    return constantObj;
}

+ (FNConstant *)window {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (FNConstant *)writingCode {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"writingCode" type: typeType code: 'psct'];
    return constantObj;
}

+ (FNConstant *)yards {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"yards" type: typeType code: 'yard'];
    return constantObj;
}

+ (FNConstant *)zoomable {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (FNConstant *)zoomed {
    static FNConstant *constantObj;
    if (!constantObj)
        constantObj = [FNConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end

