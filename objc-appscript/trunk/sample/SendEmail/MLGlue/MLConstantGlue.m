/*
 * MLConstantGlue.m
 *
 * /Applications/Mail.app
 * osaglue 0.4.0
 *
 */

#import "MLConstantGlue.h"

@implementation MLConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'apr ': return [self April];
        case 'aug ': return [self August];
        case 'dec ': return [self December];
        case 'EPS ': return [self EPSPicture];
        case 'feb ': return [self February];
        case 'fri ': return [self Friday];
        case 'GIFf': return [self GIFPicture];
        case 'JPEG': return [self JPEGPicture];
        case 'jan ': return [self January];
        case 'jul ': return [self July];
        case 'jun ': return [self June];
        case 'attp': return [self MIMEType];
        case 'etit': return [self Mac];
        case 'itac': return [self MacAccount];
        case 'mar ': return [self March];
        case 'may ': return [self May];
        case 'mon ': return [self Monday];
        case 'nov ': return [self November];
        case 'oct ': return [self October];
        case 'PICT': return [self PICTPicture];
        case 'tr16': return [self RGB16Color];
        case 'tr96': return [self RGB96Color];
        case 'cRGB': return [self RGBColor];
        case 'sat ': return [self Saturday];
        case 'sep ': return [self September];
        case 'sun ': return [self Sunday];
        case 'TIFF': return [self TIFFPicture];
        case 'thu ': return [self Thursday];
        case 'tue ': return [self Tuesday];
        case 'wed ': return [self Wednesday];
        case 'tacc': return [self account];
        case 'mact': return [self account];
        case 'path': return [self accountDirectory];
        case 'atyp': return [self accountType];
        case 'radd': return [self address];
        case 'alis': return [self alias];
        case 'hdal': return [self all];
        case 'racm': return [self allConditionsMustBeMet];
        case 'alhe': return [self allHeaders];
        case 'x9al': return [self allMessagesAndTheirAttachments];
        case 'x9bo': return [self allMessagesButOmitAttachments];
        case 'abcm': return [self alwaysBccMyself];
        case 'accm': return [self alwaysCcMyself];
        case 'tanr': return [self anyRecipient];
        case '****': return [self anything];
        case 'aapo': return [self apop];
        case 'capp': return [self application];
        case 'bund': return [self applicationBundleID];
        case 'rmte': return [self applicationResponses];
        case 'sign': return [self applicationSignature];
        case 'aprl': return [self applicationURL];
        case 'apve': return [self applicationVersion];
        case 'ask ': return [self ask];
        case 'atts': return [self attachment];
        case 'ecat': return [self attachmentsColumn];
        case 'catr': return [self attributeRun];
        case 'paus': return [self authentication];
        case 'bthc': return [self backgroundActivityCount];
        case 'mcol': return [self backgroundColor];
        case 'lsba': return [self base];
        case 'brcp': return [self bccRecipient];
        case 'rqbw': return [self beginsWithValue];
        case 'best': return [self best];
        case 'bmws': return [self bigMessageWarningSize];
        case 'ccbl': return [self blue];
        case 'bool': return [self boolean];
        case 'qdrt': return [self boundingRectangle];
        case 'pbnd': return [self bounds];
        case 'ecba': return [self buddyAvailabilityColumn];
        case 'case': return [self case_];
        case 'tccc': return [self ccHeader];
        case 'crcp': return [self ccRecipient];
        case 'cmtr': return [self centimeters];
        case 'cha ': return [self character];
        case 'chsp': return [self checkSpellingWhileTyping];
        case 'cswc': return [self chooseSignatureWhenComposing];
        case 'gcli': return [self classInfo];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'rcme': return [self colorMessage];
        case 'mcct': return [self colorQuotedText];
        case 'clrt': return [self colorTable];
        case 'cwcm': return [self compactMailboxesWhenClosing];
        case 'mbxc': return [self container];
        case 'ctnt': return [self content];
        case 'lwcp': return [self copies];
        case 'rcmb': return [self copyMessage];
        case 'ccmt': return [self cubicCentimeters];
        case 'cfet': return [self cubicFeet];
        case 'cuin': return [self cubicInches];
        case 'cmet': return [self cubicMeters];
        case 'cyrd': return [self cubicYards];
        case 'hdcu': return [self custom];
        case 'tdas': return [self dashStyle];
        case 'rdat': return [self data];
        case 'ldt ': return [self date];
        case 'rdrc': return [self dateReceived];
        case 'ecdr': return [self dateReceivedColumn];
        case 'drcv': return [self dateSent];
        case 'ecds': return [self dateSentColumn];
        case 'decm': return [self decimalStruct];
        case 'demf': return [self defaultMessageFormat];
        case 'hdde': return [self default_];
        case 'degc': return [self degreesCelsius];
        case 'degf': return [self degreesFahrenheit];
        case 'degk': return [self degreesKelvin];
        case 'dmdi': return [self delayedMessageDeletionInterval];
        case 'dmos': return [self deleteMailOnServer];
        case 'rdme': return [self deleteMessage];
        case 'dmwm': return [self deleteMessagesWhenMovedFromInbox];
        case 'isdl': return [self deletedStatus];
        case 'lwdt': return [self detailed];
        case 'diac': return [self diacriticals];
        case 'x9no': return [self doNotKeepCopiesOfAnyMessages];
        case 'docu': return [self document];
        case 'rqco': return [self doesContainValue];
        case 'rqdn': return [self doesNotContainValue];
        case 'comp': return [self doubleInteger];
        case 'dhta': return [self downloadHtmlAttachments];
        case 'atdn': return [self downloaded];
        case 'drmb': return [self draftsMailbox];
        case 'elin': return [self elementInfo];
        case 'emad': return [self emailAddresses];
        case 'ejmf': return [self emptyJunkMessagesFrequency];
        case 'ejmo': return [self emptyJunkMessagesOnQuit];
        case 'esmf': return [self emptySentMessagesFrequency];
        case 'esmo': return [self emptySentMessagesOnQuit];
        case 'etrf': return [self emptyTrashFrequency];
        case 'etoq': return [self emptyTrashOnQuit];
        case 'isac': return [self enabled];
        case 'encs': return [self encodedString];
        case 'lwlp': return [self endingPage];
        case 'rqew': return [self endsWithValue];
        case 'enum': return [self enumerator];
        case 'rqie': return [self equalToValue];
        case 'lweh': return [self errorHandling];
        case 'evin': return [self eventInfo];
        case 'exga': return [self expandGroupAddresses];
        case 'expa': return [self expansion];
        case 'rexp': return [self expression];
        case 'exte': return [self extendedFloat];
        case 'faxn': return [self faxNumber];
        case 'feet': return [self feet];
        case 'affq': return [self fetchInterval];
        case 'saft': return [self fetchesAutomatically];
        case 'atfn': return [self fileName];
        case 'fsrf': return [self fileRef];
        case 'fss ': return [self fileSpecification];
        case 'furl': return [self fileURL];
        case 'fixd': return [self fixed];
        case 'fpnt': return [self fixedPoint];
        case 'frct': return [self fixedRectangle];
        case 'mptf': return [self fixedWidthFont];
        case 'ptfs': return [self fixedWidthFontSize];
        case 'isfl': return [self flaggedStatus];
        case 'ecfl': return [self flagsColumn];
        case 'ldbl': return [self float128bit];
        case 'doub': return [self float_];
        case 'font': return [self font];
        case 'rfad': return [self forwardMessage];
        case 'rfte': return [self forwardText];
        case 'frve': return [self frameworkVersion];
        case 'ecfr': return [self fromColumn];
        case 'tfro': return [self fromHeader];
        case 'pisf': return [self frontmost];
        case 'flln': return [self fullName];
        case 'galn': return [self gallons];
        case 'gram': return [self grams];
        case 'cgtx': return [self graphicText];
        case 'ccgy': return [self gray];
        case 'rqgt': return [self greaterThanValue];
        case 'ccgr': return [self green];
        case 'mhdr': return [self header];
        case 'rhed': return [self header];
        case 'hedl': return [self headerDetail];
        case 'thdk': return [self headerKey];
        case 'shht': return [self highlightSelectedThread];
        case 'htuc': return [self highlightTextUsingColor];
        case 'ldsa': return [self hostName];
        case 'hyph': return [self hyphens];
        case 'ID  ': return [self id_];
        case 'etim': return [self imap];
        case 'iact': return [self imapAccount];
        case 'inmb': return [self inbox];
        case 'inch': return [self inches];
        case 'iaoo': return [self includeAllOriginalMessageText];
        case 'iwgm': return [self includeWhenGettingNewMail];
        case 'pidx': return [self index];
        case 'long': return [self integer];
        case 'itxt': return [self internationalText];
        case 'intl': return [self internationalWritingCode];
        case 'cobj': return [self item];
        case 'isjk': return [self junkMailStatus];
        case 'jkmb': return [self junkMailbox];
        case 'axk5': return [self kerberos5];
        case 'kpid': return [self kernelProcessID];
        case 'kgrm': return [self kilograms];
        case 'kmtr': return [self kilometers];
        case 'ldse': return [self ldapServer];
        case 'rqlt': return [self lessThanValue];
        case 'loqc': return [self levelOneQuotingColor];
        case 'lhqc': return [self levelThreeQuotingColor];
        case 'lwqc': return [self levelTwoQuotingColor];
        case 'list': return [self list];
        case 'litr': return [self liters];
        case 'insl': return [self locationReference];
        case 'lfxd': return [self longFixed];
        case 'lfpt': return [self longFixedPoint];
        case 'lfrc': return [self longFixedRectangle];
        case 'lpnt': return [self longPoint];
        case 'lrct': return [self longRectangle];
        case 'mach': return [self machine];
        case 'mLoc': return [self machineLocation];
        case 'attc': return [self mailAttachment];
        case 'mbxp': return [self mailbox];
        case 'ecmb': return [self mailboxColumn];
        case 'mlsh': return [self mailboxListVisible];
        case 'rmfl': return [self markFlagged];
        case 'rmre': return [self markRead];
        case 'tevm': return [self matchesEveryMessage];
        case 'axmd': return [self md5];
        case 'mssg': return [self message];
        case 'msgc': return [self messageCaching];
        case 'eccl': return [self messageColor];
        case 'tmec': return [self messageContent];
        case 'mmfn': return [self messageFont];
        case 'mmfs': return [self messageFontSize];
        case 'meid': return [self messageId];
        case 'tmij': return [self messageIsJunkMail];
        case 'mmlf': return [self messageListFont];
        case 'mlfs': return [self messageListFontSize];
        case 'tnrg': return [self messageSignature];
        case 'msze': return [self messageSize];
        case 'ecms': return [self messageStatusColumn];
        case 'mvwr': return [self messageViewer];
        case 'metr': return [self meters];
        case 'mile': return [self miles];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'msng': return [self missingValue];
        case 'pmod': return [self modal];
        case 'imod': return [self modified];
        case 'smdm': return [self moveDeletedMessagesToTrash];
        case 'rtme': return [self moveMessage];
        case 'pnam': return [self name];
        case 'mnms': return [self newMailSound];
        case 'no  ': return [self no];
        case 'hdnn': return [self noHeaders];
        case 'rqno': return [self none];
        case 'ccno': return [self none];
        case 'axnt': return [self ntlm];
        case 'null': return [self null];
        case 'ecnm': return [self numberColumn];
        case 'nume': return [self numericStrings];
        case 'lsol': return [self oneLevel];
        case 'x9wr': return [self onlyMessagesIHaveRead];
        case 'ccor': return [self orange];
        case 'ccot': return [self other];
        case 'ozs ': return [self ounces];
        case 'oumb': return [self outbox];
        case 'bcke': return [self outgoingMessage];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'pmin': return [self parameterInfo];
        case 'axct': return [self password];
        case 'macp': return [self password];
        case 'ppth': return [self path];
        case 'tpmm': return [self pixelMapRecord];
        case 'dmpt': return [self plainText];
        case 'rpso': return [self playSound];
        case 'QDpt': return [self point];
        case 'etpo': return [self pop];
        case 'pact': return [self popAccount];
        case 'port': return [self port];
        case 'lbs ': return [self pounds];
        case 'mvpv': return [self previewPaneIsVisible];
        case 'ueml': return [self primaryEmail];
        case 'pset': return [self printSettings];
        case 'psn ': return [self processSerialNumber];
        case 'pALL': return [self properties];
        case 'prop': return [self property];
        case 'pinf': return [self propertyInfo];
        case 'punc': return [self punctuation];
        case 'ccpu': return [self purple];
        case 'rqua': return [self qualifier];
        case 'qrts': return [self quarts];
        case 'inom': return [self quoteOriginalMessage];
        case 'isrd': return [self readStatus];
        case 'rcpt': return [self recipient];
        case 'reco': return [self record];
        case 'ccre': return [self red];
        case 'rrad': return [self redirectMessage];
        case 'obj ': return [self reference];
        case 'rrte': return [self replyText];
        case 'rpto': return [self replyTo];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'dmrt': return [self richText];
        case 'trot': return [self rotation];
        case 'rule': return [self rule];
        case 'rucr': return [self ruleCondition];
        case 'rtyp': return [self ruleType];
        case 'rras': return [self runScript];
        case 'risf': return [self sameReplyFormat];
        case 'ldsc': return [self scope];
        case 'scpt': return [self script];
        case 'ldsb': return [self searchBase];
        case 'msbx': return [self selectedMailboxes];
        case 'smgs': return [self selectedMessages];
        case 'sesi': return [self selectedSignature];
        case 'slct': return [self selection];
        case 'sndr': return [self sender];
        case 'tsii': return [self senderIsInMyAddressBook];
        case 'tsim': return [self senderIsMemberOfGroup];
        case 'tsin': return [self senderIsNotInMyAddressBook];
        case 'tsig': return [self senderIsNotMemberOfGroup];
        case 'stmb': return [self sentMailbox];
        case 'host': return [self serverName];
        case 'sing': return [self shortFloat];
        case 'shor': return [self shortInteger];
        case 'rscm': return [self shouldCopyMessage];
        case 'rstm': return [self shouldMoveMessage];
        case 'poms': return [self shouldPlayOtherMailSounds];
        case 'shsp': return [self showOnlineBuddyStatus];
        case 'situ': return [self signature];
        case 'ptsz': return [self size];
        case 'ecsz': return [self sizeColumn];
        case 'etsm': return [self smtp];
        case 'dact': return [self smtpServer];
        case 'mvsc': return [self sortColumn];
        case 'mvsr': return [self sortedAscending];
        case 'raso': return [self source];
        case 'sqft': return [self squareFeet];
        case 'sqkm': return [self squareKilometers];
        case 'sqrm': return [self squareMeters];
        case 'sqmi': return [self squareMiles];
        case 'sqyd': return [self squareYards];
        case 'lwst': return [self standard];
        case 'lwfp': return [self startingPage];
        case 'rser': return [self stopEvaluatingRules];
        case 'stos': return [self storeDeletedMessagesOnServer];
        case 'sdos': return [self storeDraftsOnServer];
        case 'sjos': return [self storeJunkMailOnServer];
        case 'ssos': return [self storeSentMessagesOnServer];
        case 'TEXT': return [self string];
        case 'styl': return [self styledClipboardText];
        case 'STXT': return [self styledText];
        case 'subj': return [self subject];
        case 'ecsu': return [self subjectColumn];
        case 'tsub': return [self subjectHeader];
        case 'lsst': return [self subtree];
        case 'suin': return [self suiteInfo];
        case 'trpr': return [self targetPrinter];
        case 'ctxt': return [self text];
        case 'tsty': return [self textStyleInfo];
        case 'ptit': return [self titled];
        case 'ecto': return [self toColumn];
        case 'ttoo': return [self toHeader];
        case 'ttoc': return [self toOrCcHeader];
        case 'trcp': return [self toRecipient];
        case 'trmb': return [self trashMailbox];
        case 'type': return [self typeClass];
        case 'utxt': return [self unicodeText];
        case 'mbuc': return [self unreadCount];
        case 'magn': return [self unsignedInteger];
        case 'usla': return [self useAddressCompletion];
        case 'ufwf': return [self useFixedWidthFont];
        case 'unme': return [self userName];
        case 'usss': return [self usesSsl];
        case 'ut16': return [self utf16Text];
        case 'utf8': return [self utf8Text];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'mvvc': return [self visibleColumns];
        case 'mvfm': return [self visibleMessages];
        case 'isfw': return [self wasForwarded];
        case 'isrc': return [self wasRedirected];
        case 'isrp': return [self wasRepliedTo];
        case 'whit': return [self whitespace];
        case 'cwin': return [self window];
        case 'cwor': return [self word];
        case 'psct': return [self writingCode];
        case 'yard': return [self yards];
        case 'ccye': return [self yellow];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (MLConstant *)Mac {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Mac" type: typeEnumerated code: 'etit'];
    return constantObj;
}

+ (MLConstant *)all {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"all" type: typeEnumerated code: 'hdal'];
    return constantObj;
}

+ (MLConstant *)allMessagesAndTheirAttachments {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allMessagesAndTheirAttachments" type: typeEnumerated code: 'x9al'];
    return constantObj;
}

+ (MLConstant *)allMessagesButOmitAttachments {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allMessagesButOmitAttachments" type: typeEnumerated code: 'x9bo'];
    return constantObj;
}

+ (MLConstant *)anyRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"anyRecipient" type: typeEnumerated code: 'tanr'];
    return constantObj;
}

+ (MLConstant *)apop {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"apop" type: typeEnumerated code: 'aapo'];
    return constantObj;
}

+ (MLConstant *)applicationResponses {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"applicationResponses" type: typeEnumerated code: 'rmte'];
    return constantObj;
}

+ (MLConstant *)ask {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (MLConstant *)attachmentsColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"attachmentsColumn" type: typeEnumerated code: 'ecat'];
    return constantObj;
}

+ (MLConstant *)base {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"base" type: typeEnumerated code: 'lsba'];
    return constantObj;
}

+ (MLConstant *)beginsWithValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"beginsWithValue" type: typeEnumerated code: 'rqbw'];
    return constantObj;
}

+ (MLConstant *)blue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"blue" type: typeEnumerated code: 'ccbl'];
    return constantObj;
}

+ (MLConstant *)buddyAvailabilityColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"buddyAvailabilityColumn" type: typeEnumerated code: 'ecba'];
    return constantObj;
}

+ (MLConstant *)case_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"case_" type: typeEnumerated code: 'case'];
    return constantObj;
}

+ (MLConstant *)ccHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ccHeader" type: typeEnumerated code: 'tccc'];
    return constantObj;
}

+ (MLConstant *)custom {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"custom" type: typeEnumerated code: 'hdcu'];
    return constantObj;
}

+ (MLConstant *)dateReceivedColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateReceivedColumn" type: typeEnumerated code: 'ecdr'];
    return constantObj;
}

+ (MLConstant *)dateSentColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateSentColumn" type: typeEnumerated code: 'ecds'];
    return constantObj;
}

+ (MLConstant *)default_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"default_" type: typeEnumerated code: 'hdde'];
    return constantObj;
}

+ (MLConstant *)detailed {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (MLConstant *)diacriticals {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"diacriticals" type: typeEnumerated code: 'diac'];
    return constantObj;
}

+ (MLConstant *)doNotKeepCopiesOfAnyMessages {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doNotKeepCopiesOfAnyMessages" type: typeEnumerated code: 'x9no'];
    return constantObj;
}

+ (MLConstant *)doesContainValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doesContainValue" type: typeEnumerated code: 'rqco'];
    return constantObj;
}

+ (MLConstant *)doesNotContainValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doesNotContainValue" type: typeEnumerated code: 'rqdn'];
    return constantObj;
}

+ (MLConstant *)endsWithValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"endsWithValue" type: typeEnumerated code: 'rqew'];
    return constantObj;
}

+ (MLConstant *)equalToValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"equalToValue" type: typeEnumerated code: 'rqie'];
    return constantObj;
}

+ (MLConstant *)expansion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"expansion" type: typeEnumerated code: 'expa'];
    return constantObj;
}

+ (MLConstant *)flagsColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"flagsColumn" type: typeEnumerated code: 'ecfl'];
    return constantObj;
}

+ (MLConstant *)fromColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fromColumn" type: typeEnumerated code: 'ecfr'];
    return constantObj;
}

+ (MLConstant *)fromHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fromHeader" type: typeEnumerated code: 'tfro'];
    return constantObj;
}

+ (MLConstant *)gray {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"gray" type: typeEnumerated code: 'ccgy'];
    return constantObj;
}

+ (MLConstant *)greaterThanValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"greaterThanValue" type: typeEnumerated code: 'rqgt'];
    return constantObj;
}

+ (MLConstant *)green {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"green" type: typeEnumerated code: 'ccgr'];
    return constantObj;
}

+ (MLConstant *)headerKey {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"headerKey" type: typeEnumerated code: 'thdk'];
    return constantObj;
}

+ (MLConstant *)hyphens {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"hyphens" type: typeEnumerated code: 'hyph'];
    return constantObj;
}

+ (MLConstant *)imap {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"imap" type: typeEnumerated code: 'etim'];
    return constantObj;
}

+ (MLConstant *)kerberos5 {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"kerberos5" type: typeEnumerated code: 'axk5'];
    return constantObj;
}

+ (MLConstant *)lessThanValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"lessThanValue" type: typeEnumerated code: 'rqlt'];
    return constantObj;
}

+ (MLConstant *)mailboxColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailboxColumn" type: typeEnumerated code: 'ecmb'];
    return constantObj;
}

+ (MLConstant *)matchesEveryMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"matchesEveryMessage" type: typeEnumerated code: 'tevm'];
    return constantObj;
}

+ (MLConstant *)md5 {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"md5" type: typeEnumerated code: 'axmd'];
    return constantObj;
}

+ (MLConstant *)messageColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageColor" type: typeEnumerated code: 'eccl'];
    return constantObj;
}

+ (MLConstant *)messageContent {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageContent" type: typeEnumerated code: 'tmec'];
    return constantObj;
}

+ (MLConstant *)messageIsJunkMail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageIsJunkMail" type: typeEnumerated code: 'tmij'];
    return constantObj;
}

+ (MLConstant *)messageStatusColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageStatusColumn" type: typeEnumerated code: 'ecms'];
    return constantObj;
}

+ (MLConstant *)no {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (MLConstant *)noHeaders {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"noHeaders" type: typeEnumerated code: 'hdnn'];
    return constantObj;
}

+ (MLConstant *)none {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"none" type: typeEnumerated code: 'rqno'];
    return constantObj;
}

+ (MLConstant *)ntlm {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ntlm" type: typeEnumerated code: 'axnt'];
    return constantObj;
}

+ (MLConstant *)numberColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"numberColumn" type: typeEnumerated code: 'ecnm'];
    return constantObj;
}

+ (MLConstant *)numericStrings {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"numericStrings" type: typeEnumerated code: 'nume'];
    return constantObj;
}

+ (MLConstant *)oneLevel {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"oneLevel" type: typeEnumerated code: 'lsol'];
    return constantObj;
}

+ (MLConstant *)onlyMessagesIHaveRead {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"onlyMessagesIHaveRead" type: typeEnumerated code: 'x9wr'];
    return constantObj;
}

+ (MLConstant *)orange {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"orange" type: typeEnumerated code: 'ccor'];
    return constantObj;
}

+ (MLConstant *)other {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"other" type: typeEnumerated code: 'ccot'];
    return constantObj;
}

+ (MLConstant *)password {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"password" type: typeEnumerated code: 'axct'];
    return constantObj;
}

+ (MLConstant *)plainText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"plainText" type: typeEnumerated code: 'dmpt'];
    return constantObj;
}

+ (MLConstant *)pop {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pop" type: typeEnumerated code: 'etpo'];
    return constantObj;
}

+ (MLConstant *)punctuation {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"punctuation" type: typeEnumerated code: 'punc'];
    return constantObj;
}

+ (MLConstant *)purple {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"purple" type: typeEnumerated code: 'ccpu'];
    return constantObj;
}

+ (MLConstant *)red {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"red" type: typeEnumerated code: 'ccre'];
    return constantObj;
}

+ (MLConstant *)richText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"richText" type: typeEnumerated code: 'dmrt'];
    return constantObj;
}

+ (MLConstant *)senderIsInMyAddressBook {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsInMyAddressBook" type: typeEnumerated code: 'tsii'];
    return constantObj;
}

+ (MLConstant *)senderIsMemberOfGroup {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsMemberOfGroup" type: typeEnumerated code: 'tsim'];
    return constantObj;
}

+ (MLConstant *)senderIsNotInMyAddressBook {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsNotInMyAddressBook" type: typeEnumerated code: 'tsin'];
    return constantObj;
}

+ (MLConstant *)senderIsNotMemberOfGroup {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"senderIsNotMemberOfGroup" type: typeEnumerated code: 'tsig'];
    return constantObj;
}

+ (MLConstant *)sizeColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sizeColumn" type: typeEnumerated code: 'ecsz'];
    return constantObj;
}

+ (MLConstant *)smtp {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"smtp" type: typeEnumerated code: 'etsm'];
    return constantObj;
}

+ (MLConstant *)standard {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (MLConstant *)subjectColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subjectColumn" type: typeEnumerated code: 'ecsu'];
    return constantObj;
}

+ (MLConstant *)subjectHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subjectHeader" type: typeEnumerated code: 'tsub'];
    return constantObj;
}

+ (MLConstant *)subtree {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subtree" type: typeEnumerated code: 'lsst'];
    return constantObj;
}

+ (MLConstant *)toColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toColumn" type: typeEnumerated code: 'ecto'];
    return constantObj;
}

+ (MLConstant *)toHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toHeader" type: typeEnumerated code: 'ttoo'];
    return constantObj;
}

+ (MLConstant *)toOrCcHeader {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toOrCcHeader" type: typeEnumerated code: 'ttoc'];
    return constantObj;
}

+ (MLConstant *)whitespace {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"whitespace" type: typeEnumerated code: 'whit'];
    return constantObj;
}

+ (MLConstant *)yellow {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"yellow" type: typeEnumerated code: 'ccye'];
    return constantObj;
}

+ (MLConstant *)yes {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (MLConstant *)April {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"April" type: typeType code: 'apr '];
    return constantObj;
}

+ (MLConstant *)August {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"August" type: typeType code: 'aug '];
    return constantObj;
}

+ (MLConstant *)December {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"December" type: typeType code: 'dec '];
    return constantObj;
}

+ (MLConstant *)EPSPicture {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"EPSPicture" type: typeType code: 'EPS '];
    return constantObj;
}

+ (MLConstant *)February {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"February" type: typeType code: 'feb '];
    return constantObj;
}

+ (MLConstant *)Friday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Friday" type: typeType code: 'fri '];
    return constantObj;
}

+ (MLConstant *)GIFPicture {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"GIFPicture" type: typeType code: 'GIFf'];
    return constantObj;
}

+ (MLConstant *)JPEGPicture {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"JPEGPicture" type: typeType code: 'JPEG'];
    return constantObj;
}

+ (MLConstant *)January {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"January" type: typeType code: 'jan '];
    return constantObj;
}

+ (MLConstant *)July {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"July" type: typeType code: 'jul '];
    return constantObj;
}

+ (MLConstant *)June {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"June" type: typeType code: 'jun '];
    return constantObj;
}

+ (MLConstant *)MIMEType {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"MIMEType" type: typeType code: 'attp'];
    return constantObj;
}

+ (MLConstant *)MacAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"MacAccount" type: typeType code: 'itac'];
    return constantObj;
}

+ (MLConstant *)March {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"March" type: typeType code: 'mar '];
    return constantObj;
}

+ (MLConstant *)May {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"May" type: typeType code: 'may '];
    return constantObj;
}

+ (MLConstant *)Monday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Monday" type: typeType code: 'mon '];
    return constantObj;
}

+ (MLConstant *)November {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"November" type: typeType code: 'nov '];
    return constantObj;
}

+ (MLConstant *)October {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"October" type: typeType code: 'oct '];
    return constantObj;
}

+ (MLConstant *)PICTPicture {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"PICTPicture" type: typeType code: 'PICT'];
    return constantObj;
}

+ (MLConstant *)RGB16Color {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"RGB16Color" type: typeType code: 'tr16'];
    return constantObj;
}

+ (MLConstant *)RGB96Color {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"RGB96Color" type: typeType code: 'tr96'];
    return constantObj;
}

+ (MLConstant *)RGBColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"RGBColor" type: typeType code: 'cRGB'];
    return constantObj;
}

+ (MLConstant *)Saturday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Saturday" type: typeType code: 'sat '];
    return constantObj;
}

+ (MLConstant *)September {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"September" type: typeType code: 'sep '];
    return constantObj;
}

+ (MLConstant *)Sunday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Sunday" type: typeType code: 'sun '];
    return constantObj;
}

+ (MLConstant *)TIFFPicture {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"TIFFPicture" type: typeType code: 'TIFF'];
    return constantObj;
}

+ (MLConstant *)Thursday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Thursday" type: typeType code: 'thu '];
    return constantObj;
}

+ (MLConstant *)Tuesday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Tuesday" type: typeType code: 'tue '];
    return constantObj;
}

+ (MLConstant *)Wednesday {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"Wednesday" type: typeType code: 'wed '];
    return constantObj;
}

+ (MLConstant *)account {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"account" type: typeType code: 'mact'];
    return constantObj;
}

+ (MLConstant *)accountDirectory {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"accountDirectory" type: typeType code: 'path'];
    return constantObj;
}

+ (MLConstant *)accountType {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"accountType" type: typeType code: 'atyp'];
    return constantObj;
}

+ (MLConstant *)address {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"address" type: typeType code: 'radd'];
    return constantObj;
}

+ (MLConstant *)alias {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (MLConstant *)allConditionsMustBeMet {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allConditionsMustBeMet" type: typeType code: 'racm'];
    return constantObj;
}

+ (MLConstant *)allHeaders {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"allHeaders" type: typeType code: 'alhe'];
    return constantObj;
}

+ (MLConstant *)alwaysBccMyself {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"alwaysBccMyself" type: typeType code: 'abcm'];
    return constantObj;
}

+ (MLConstant *)alwaysCcMyself {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"alwaysCcMyself" type: typeType code: 'accm'];
    return constantObj;
}

+ (MLConstant *)anything {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"anything" type: typeType code: '****'];
    return constantObj;
}

+ (MLConstant *)application {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (MLConstant *)applicationBundleID {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"applicationBundleID" type: typeType code: 'bund'];
    return constantObj;
}

+ (MLConstant *)applicationSignature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"applicationSignature" type: typeType code: 'sign'];
    return constantObj;
}

+ (MLConstant *)applicationURL {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"applicationURL" type: typeType code: 'aprl'];
    return constantObj;
}

+ (MLConstant *)applicationVersion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"applicationVersion" type: typeType code: 'apve'];
    return constantObj;
}

+ (MLConstant *)attachment {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (MLConstant *)attributeRun {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (MLConstant *)authentication {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"authentication" type: typeType code: 'paus'];
    return constantObj;
}

+ (MLConstant *)backgroundActivityCount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"backgroundActivityCount" type: typeType code: 'bthc'];
    return constantObj;
}

+ (MLConstant *)backgroundColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"backgroundColor" type: typeType code: 'mcol'];
    return constantObj;
}

+ (MLConstant *)bccRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"bccRecipient" type: typeType code: 'brcp'];
    return constantObj;
}

+ (MLConstant *)best {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"best" type: typeType code: 'best'];
    return constantObj;
}

+ (MLConstant *)bigMessageWarningSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"bigMessageWarningSize" type: typeType code: 'bmws'];
    return constantObj;
}

+ (MLConstant *)boolean {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"boolean" type: typeType code: 'bool'];
    return constantObj;
}

+ (MLConstant *)boundingRectangle {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"boundingRectangle" type: typeType code: 'qdrt'];
    return constantObj;
}

+ (MLConstant *)bounds {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (MLConstant *)ccRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ccRecipient" type: typeType code: 'crcp'];
    return constantObj;
}

+ (MLConstant *)centimeters {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"centimeters" type: typeType code: 'cmtr'];
    return constantObj;
}

+ (MLConstant *)character {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (MLConstant *)checkSpellingWhileTyping {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"checkSpellingWhileTyping" type: typeType code: 'chsp'];
    return constantObj;
}

+ (MLConstant *)chooseSignatureWhenComposing {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"chooseSignatureWhenComposing" type: typeType code: 'cswc'];
    return constantObj;
}

+ (MLConstant *)classInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"classInfo" type: typeType code: 'gcli'];
    return constantObj;
}

+ (MLConstant *)class_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (MLConstant *)closeable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (MLConstant *)collating {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (MLConstant *)color {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (MLConstant *)colorMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"colorMessage" type: typeType code: 'rcme'];
    return constantObj;
}

+ (MLConstant *)colorQuotedText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"colorQuotedText" type: typeType code: 'mcct'];
    return constantObj;
}

+ (MLConstant *)colorTable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"colorTable" type: typeType code: 'clrt'];
    return constantObj;
}

+ (MLConstant *)compactMailboxesWhenClosing {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"compactMailboxesWhenClosing" type: typeType code: 'cwcm'];
    return constantObj;
}

+ (MLConstant *)container {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"container" type: typeType code: 'mbxc'];
    return constantObj;
}

+ (MLConstant *)content {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"content" type: typeType code: 'ctnt'];
    return constantObj;
}

+ (MLConstant *)copies {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (MLConstant *)copyMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"copyMessage" type: typeType code: 'rcmb'];
    return constantObj;
}

+ (MLConstant *)cubicCentimeters {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"cubicCentimeters" type: typeType code: 'ccmt'];
    return constantObj;
}

+ (MLConstant *)cubicFeet {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"cubicFeet" type: typeType code: 'cfet'];
    return constantObj;
}

+ (MLConstant *)cubicInches {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"cubicInches" type: typeType code: 'cuin'];
    return constantObj;
}

+ (MLConstant *)cubicMeters {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"cubicMeters" type: typeType code: 'cmet'];
    return constantObj;
}

+ (MLConstant *)cubicYards {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"cubicYards" type: typeType code: 'cyrd'];
    return constantObj;
}

+ (MLConstant *)dashStyle {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dashStyle" type: typeType code: 'tdas'];
    return constantObj;
}

+ (MLConstant *)data {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"data" type: typeType code: 'rdat'];
    return constantObj;
}

+ (MLConstant *)date {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"date" type: typeType code: 'ldt '];
    return constantObj;
}

+ (MLConstant *)dateReceived {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateReceived" type: typeType code: 'rdrc'];
    return constantObj;
}

+ (MLConstant *)dateSent {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"dateSent" type: typeType code: 'drcv'];
    return constantObj;
}

+ (MLConstant *)decimalStruct {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"decimalStruct" type: typeType code: 'decm'];
    return constantObj;
}

+ (MLConstant *)defaultMessageFormat {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"defaultMessageFormat" type: typeType code: 'demf'];
    return constantObj;
}

+ (MLConstant *)degreesCelsius {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"degreesCelsius" type: typeType code: 'degc'];
    return constantObj;
}

+ (MLConstant *)degreesFahrenheit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"degreesFahrenheit" type: typeType code: 'degf'];
    return constantObj;
}

+ (MLConstant *)degreesKelvin {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"degreesKelvin" type: typeType code: 'degk'];
    return constantObj;
}

+ (MLConstant *)delayedMessageDeletionInterval {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"delayedMessageDeletionInterval" type: typeType code: 'dmdi'];
    return constantObj;
}

+ (MLConstant *)deleteMailOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deleteMailOnServer" type: typeType code: 'dmos'];
    return constantObj;
}

+ (MLConstant *)deleteMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deleteMessage" type: typeType code: 'rdme'];
    return constantObj;
}

+ (MLConstant *)deleteMessagesWhenMovedFromInbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deleteMessagesWhenMovedFromInbox" type: typeType code: 'dmwm'];
    return constantObj;
}

+ (MLConstant *)deletedStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deletedStatus" type: typeType code: 'isdl'];
    return constantObj;
}

+ (MLConstant *)deliveryAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"deliveryAccount" type: typeType code: 'dact'];
    return constantObj;
}

+ (MLConstant *)document {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (MLConstant *)doubleInteger {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"doubleInteger" type: typeType code: 'comp'];
    return constantObj;
}

+ (MLConstant *)downloadHtmlAttachments {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"downloadHtmlAttachments" type: typeType code: 'dhta'];
    return constantObj;
}

+ (MLConstant *)downloaded {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"downloaded" type: typeType code: 'atdn'];
    return constantObj;
}

+ (MLConstant *)draftsMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"draftsMailbox" type: typeType code: 'drmb'];
    return constantObj;
}

+ (MLConstant *)elementInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"elementInfo" type: typeType code: 'elin'];
    return constantObj;
}

+ (MLConstant *)emailAddresses {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emailAddresses" type: typeType code: 'emad'];
    return constantObj;
}

+ (MLConstant *)emptyJunkMessagesFrequency {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyJunkMessagesFrequency" type: typeType code: 'ejmf'];
    return constantObj;
}

+ (MLConstant *)emptyJunkMessagesOnQuit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyJunkMessagesOnQuit" type: typeType code: 'ejmo'];
    return constantObj;
}

+ (MLConstant *)emptySentMessagesFrequency {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptySentMessagesFrequency" type: typeType code: 'esmf'];
    return constantObj;
}

+ (MLConstant *)emptySentMessagesOnQuit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptySentMessagesOnQuit" type: typeType code: 'esmo'];
    return constantObj;
}

+ (MLConstant *)emptyTrashFrequency {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyTrashFrequency" type: typeType code: 'etrf'];
    return constantObj;
}

+ (MLConstant *)emptyTrashOnQuit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"emptyTrashOnQuit" type: typeType code: 'etoq'];
    return constantObj;
}

+ (MLConstant *)enabled {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"enabled" type: typeType code: 'isac'];
    return constantObj;
}

+ (MLConstant *)encodedString {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"encodedString" type: typeType code: 'encs'];
    return constantObj;
}

+ (MLConstant *)endingPage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (MLConstant *)enumerator {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"enumerator" type: typeType code: 'enum'];
    return constantObj;
}

+ (MLConstant *)errorHandling {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (MLConstant *)eventInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"eventInfo" type: typeType code: 'evin'];
    return constantObj;
}

+ (MLConstant *)expandGroupAddresses {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"expandGroupAddresses" type: typeType code: 'exga'];
    return constantObj;
}

+ (MLConstant *)expression {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"expression" type: typeType code: 'rexp'];
    return constantObj;
}

+ (MLConstant *)extendedFloat {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"extendedFloat" type: typeType code: 'exte'];
    return constantObj;
}

+ (MLConstant *)faxNumber {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (MLConstant *)feet {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"feet" type: typeType code: 'feet'];
    return constantObj;
}

+ (MLConstant *)fetchInterval {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fetchInterval" type: typeType code: 'affq'];
    return constantObj;
}

+ (MLConstant *)fetchesAutomatically {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fetchesAutomatically" type: typeType code: 'saft'];
    return constantObj;
}

+ (MLConstant *)fileName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (MLConstant *)fileRef {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fileRef" type: typeType code: 'fsrf'];
    return constantObj;
}

+ (MLConstant *)fileSpecification {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fileSpecification" type: typeType code: 'fss '];
    return constantObj;
}

+ (MLConstant *)fileURL {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fileURL" type: typeType code: 'furl'];
    return constantObj;
}

+ (MLConstant *)fixed {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixed" type: typeType code: 'fixd'];
    return constantObj;
}

+ (MLConstant *)fixedPoint {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixedPoint" type: typeType code: 'fpnt'];
    return constantObj;
}

+ (MLConstant *)fixedRectangle {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixedRectangle" type: typeType code: 'frct'];
    return constantObj;
}

+ (MLConstant *)fixedWidthFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixedWidthFont" type: typeType code: 'mptf'];
    return constantObj;
}

+ (MLConstant *)fixedWidthFontSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fixedWidthFontSize" type: typeType code: 'ptfs'];
    return constantObj;
}

+ (MLConstant *)flaggedStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"flaggedStatus" type: typeType code: 'isfl'];
    return constantObj;
}

+ (MLConstant *)float128bit {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"float128bit" type: typeType code: 'ldbl'];
    return constantObj;
}

+ (MLConstant *)float_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"float_" type: typeType code: 'doub'];
    return constantObj;
}

+ (MLConstant *)floating {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (MLConstant *)font {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (MLConstant *)forwardMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"forwardMessage" type: typeType code: 'rfad'];
    return constantObj;
}

+ (MLConstant *)forwardText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"forwardText" type: typeType code: 'rfte'];
    return constantObj;
}

+ (MLConstant *)frameworkVersion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"frameworkVersion" type: typeType code: 'frve'];
    return constantObj;
}

+ (MLConstant *)frontmost {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (MLConstant *)fullName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"fullName" type: typeType code: 'flln'];
    return constantObj;
}

+ (MLConstant *)gallons {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"gallons" type: typeType code: 'galn'];
    return constantObj;
}

+ (MLConstant *)grams {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"grams" type: typeType code: 'gram'];
    return constantObj;
}

+ (MLConstant *)graphicText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"graphicText" type: typeType code: 'cgtx'];
    return constantObj;
}

+ (MLConstant *)header {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"header" type: typeType code: 'mhdr'];
    return constantObj;
}

+ (MLConstant *)headerDetail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"headerDetail" type: typeType code: 'hedl'];
    return constantObj;
}

+ (MLConstant *)highlightSelectedThread {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"highlightSelectedThread" type: typeType code: 'shht'];
    return constantObj;
}

+ (MLConstant *)highlightTextUsingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"highlightTextUsingColor" type: typeType code: 'htuc'];
    return constantObj;
}

+ (MLConstant *)hostName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"hostName" type: typeType code: 'ldsa'];
    return constantObj;
}

+ (MLConstant *)id_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (MLConstant *)imapAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"imapAccount" type: typeType code: 'iact'];
    return constantObj;
}

+ (MLConstant *)inbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"inbox" type: typeType code: 'inmb'];
    return constantObj;
}

+ (MLConstant *)inches {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"inches" type: typeType code: 'inch'];
    return constantObj;
}

+ (MLConstant *)includeAllOriginalMessageText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"includeAllOriginalMessageText" type: typeType code: 'iaoo'];
    return constantObj;
}

+ (MLConstant *)includeWhenGettingNewMail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"includeWhenGettingNewMail" type: typeType code: 'iwgm'];
    return constantObj;
}

+ (MLConstant *)index {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (MLConstant *)integer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"integer" type: typeType code: 'long'];
    return constantObj;
}

+ (MLConstant *)internationalText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"internationalText" type: typeType code: 'itxt'];
    return constantObj;
}

+ (MLConstant *)internationalWritingCode {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"internationalWritingCode" type: typeType code: 'intl'];
    return constantObj;
}

+ (MLConstant *)item {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (MLConstant *)junkMailStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"junkMailStatus" type: typeType code: 'isjk'];
    return constantObj;
}

+ (MLConstant *)junkMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"junkMailbox" type: typeType code: 'jkmb'];
    return constantObj;
}

+ (MLConstant *)kernelProcessID {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"kernelProcessID" type: typeType code: 'kpid'];
    return constantObj;
}

+ (MLConstant *)kilograms {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"kilograms" type: typeType code: 'kgrm'];
    return constantObj;
}

+ (MLConstant *)kilometers {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"kilometers" type: typeType code: 'kmtr'];
    return constantObj;
}

+ (MLConstant *)ldapServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ldapServer" type: typeType code: 'ldse'];
    return constantObj;
}

+ (MLConstant *)levelOneQuotingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"levelOneQuotingColor" type: typeType code: 'loqc'];
    return constantObj;
}

+ (MLConstant *)levelThreeQuotingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"levelThreeQuotingColor" type: typeType code: 'lhqc'];
    return constantObj;
}

+ (MLConstant *)levelTwoQuotingColor {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"levelTwoQuotingColor" type: typeType code: 'lwqc'];
    return constantObj;
}

+ (MLConstant *)list {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (MLConstant *)liters {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"liters" type: typeType code: 'litr'];
    return constantObj;
}

+ (MLConstant *)locationReference {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"locationReference" type: typeType code: 'insl'];
    return constantObj;
}

+ (MLConstant *)longFixed {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"longFixed" type: typeType code: 'lfxd'];
    return constantObj;
}

+ (MLConstant *)longFixedPoint {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"longFixedPoint" type: typeType code: 'lfpt'];
    return constantObj;
}

+ (MLConstant *)longFixedRectangle {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"longFixedRectangle" type: typeType code: 'lfrc'];
    return constantObj;
}

+ (MLConstant *)longPoint {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"longPoint" type: typeType code: 'lpnt'];
    return constantObj;
}

+ (MLConstant *)longRectangle {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"longRectangle" type: typeType code: 'lrct'];
    return constantObj;
}

+ (MLConstant *)machPort {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"machPort" type: typeType code: 'port'];
    return constantObj;
}

+ (MLConstant *)machine {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"machine" type: typeType code: 'mach'];
    return constantObj;
}

+ (MLConstant *)machineLocation {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"machineLocation" type: typeType code: 'mLoc'];
    return constantObj;
}

+ (MLConstant *)mailAttachment {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailAttachment" type: typeType code: 'attc'];
    return constantObj;
}

+ (MLConstant *)mailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailbox" type: typeType code: 'mbxp'];
    return constantObj;
}

+ (MLConstant *)mailboxListVisible {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"mailboxListVisible" type: typeType code: 'mlsh'];
    return constantObj;
}

+ (MLConstant *)markFlagged {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"markFlagged" type: typeType code: 'rmfl'];
    return constantObj;
}

+ (MLConstant *)markRead {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"markRead" type: typeType code: 'rmre'];
    return constantObj;
}

+ (MLConstant *)message {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"message" type: typeType code: 'mssg'];
    return constantObj;
}

+ (MLConstant *)messageCaching {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageCaching" type: typeType code: 'msgc'];
    return constantObj;
}

+ (MLConstant *)messageFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageFont" type: typeType code: 'mmfn'];
    return constantObj;
}

+ (MLConstant *)messageFontSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageFontSize" type: typeType code: 'mmfs'];
    return constantObj;
}

+ (MLConstant *)messageId {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageId" type: typeType code: 'meid'];
    return constantObj;
}

+ (MLConstant *)messageListFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageListFont" type: typeType code: 'mmlf'];
    return constantObj;
}

+ (MLConstant *)messageListFontSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageListFontSize" type: typeType code: 'mlfs'];
    return constantObj;
}

+ (MLConstant *)messageSignature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageSignature" type: typeType code: 'tnrg'];
    return constantObj;
}

+ (MLConstant *)messageSize {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageSize" type: typeType code: 'msze'];
    return constantObj;
}

+ (MLConstant *)messageViewer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"messageViewer" type: typeType code: 'mvwr'];
    return constantObj;
}

+ (MLConstant *)meters {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"meters" type: typeType code: 'metr'];
    return constantObj;
}

+ (MLConstant *)miles {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"miles" type: typeType code: 'mile'];
    return constantObj;
}

+ (MLConstant *)miniaturizable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (MLConstant *)miniaturized {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (MLConstant *)missingValue {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"missingValue" type: typeType code: 'msng'];
    return constantObj;
}

+ (MLConstant *)modal {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (MLConstant *)modified {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (MLConstant *)moveDeletedMessagesToTrash {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"moveDeletedMessagesToTrash" type: typeType code: 'smdm'];
    return constantObj;
}

+ (MLConstant *)moveMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"moveMessage" type: typeType code: 'rtme'];
    return constantObj;
}

+ (MLConstant *)name {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (MLConstant *)newMailSound {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"newMailSound" type: typeType code: 'mnms'];
    return constantObj;
}

+ (MLConstant *)null {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"null" type: typeType code: 'null'];
    return constantObj;
}

+ (MLConstant *)ounces {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ounces" type: typeType code: 'ozs '];
    return constantObj;
}

+ (MLConstant *)outbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"outbox" type: typeType code: 'oumb'];
    return constantObj;
}

+ (MLConstant *)outgoingMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"outgoingMessage" type: typeType code: 'bcke'];
    return constantObj;
}

+ (MLConstant *)pagesAcross {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (MLConstant *)pagesDown {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (MLConstant *)paragraph {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (MLConstant *)parameterInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"parameterInfo" type: typeType code: 'pmin'];
    return constantObj;
}

+ (MLConstant *)path {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (MLConstant *)pixelMapRecord {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pixelMapRecord" type: typeType code: 'tpmm'];
    return constantObj;
}

+ (MLConstant *)playSound {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"playSound" type: typeType code: 'rpso'];
    return constantObj;
}

+ (MLConstant *)point {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"point" type: typeType code: 'QDpt'];
    return constantObj;
}

+ (MLConstant *)popAccount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"popAccount" type: typeType code: 'pact'];
    return constantObj;
}

+ (MLConstant *)port {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"port" type: typeType code: 'port'];
    return constantObj;
}

+ (MLConstant *)pounds {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"pounds" type: typeType code: 'lbs '];
    return constantObj;
}

+ (MLConstant *)previewPaneIsVisible {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"previewPaneIsVisible" type: typeType code: 'mvpv'];
    return constantObj;
}

+ (MLConstant *)primaryEmail {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"primaryEmail" type: typeType code: 'ueml'];
    return constantObj;
}

+ (MLConstant *)printSettings {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (MLConstant *)processSerialNumber {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"processSerialNumber" type: typeType code: 'psn '];
    return constantObj;
}

+ (MLConstant *)properties {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (MLConstant *)property {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"property" type: typeType code: 'prop'];
    return constantObj;
}

+ (MLConstant *)propertyInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"propertyInfo" type: typeType code: 'pinf'];
    return constantObj;
}

+ (MLConstant *)qualifier {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"qualifier" type: typeType code: 'rqua'];
    return constantObj;
}

+ (MLConstant *)quarts {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"quarts" type: typeType code: 'qrts'];
    return constantObj;
}

+ (MLConstant *)quoteOriginalMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"quoteOriginalMessage" type: typeType code: 'inom'];
    return constantObj;
}

+ (MLConstant *)readStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"readStatus" type: typeType code: 'isrd'];
    return constantObj;
}

+ (MLConstant *)recipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"recipient" type: typeType code: 'rcpt'];
    return constantObj;
}

+ (MLConstant *)record {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"record" type: typeType code: 'reco'];
    return constantObj;
}

+ (MLConstant *)redirectMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"redirectMessage" type: typeType code: 'rrad'];
    return constantObj;
}

+ (MLConstant *)reference {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"reference" type: typeType code: 'obj '];
    return constantObj;
}

+ (MLConstant *)replyText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"replyText" type: typeType code: 'rrte'];
    return constantObj;
}

+ (MLConstant *)replyTo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"replyTo" type: typeType code: 'rpto'];
    return constantObj;
}

+ (MLConstant *)requestedPrintTime {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (MLConstant *)resizable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (MLConstant *)rotation {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"rotation" type: typeType code: 'trot'];
    return constantObj;
}

+ (MLConstant *)rule {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"rule" type: typeType code: 'rule'];
    return constantObj;
}

+ (MLConstant *)ruleCondition {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ruleCondition" type: typeType code: 'rucr'];
    return constantObj;
}

+ (MLConstant *)ruleType {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"ruleType" type: typeType code: 'rtyp'];
    return constantObj;
}

+ (MLConstant *)runScript {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"runScript" type: typeType code: 'rras'];
    return constantObj;
}

+ (MLConstant *)sameReplyFormat {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sameReplyFormat" type: typeType code: 'risf'];
    return constantObj;
}

+ (MLConstant *)scope {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"scope" type: typeType code: 'ldsc'];
    return constantObj;
}

+ (MLConstant *)script {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (MLConstant *)searchBase {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"searchBase" type: typeType code: 'ldsb'];
    return constantObj;
}

+ (MLConstant *)selectedMailboxes {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selectedMailboxes" type: typeType code: 'msbx'];
    return constantObj;
}

+ (MLConstant *)selectedMessages {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selectedMessages" type: typeType code: 'smgs'];
    return constantObj;
}

+ (MLConstant *)selectedSignature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selectedSignature" type: typeType code: 'sesi'];
    return constantObj;
}

+ (MLConstant *)selection {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"selection" type: typeType code: 'slct'];
    return constantObj;
}

+ (MLConstant *)sender {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sender" type: typeType code: 'sndr'];
    return constantObj;
}

+ (MLConstant *)sentMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sentMailbox" type: typeType code: 'stmb'];
    return constantObj;
}

+ (MLConstant *)serverName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"serverName" type: typeType code: 'host'];
    return constantObj;
}

+ (MLConstant *)shortFloat {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shortFloat" type: typeType code: 'sing'];
    return constantObj;
}

+ (MLConstant *)shortInteger {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shortInteger" type: typeType code: 'shor'];
    return constantObj;
}

+ (MLConstant *)shouldCopyMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shouldCopyMessage" type: typeType code: 'rscm'];
    return constantObj;
}

+ (MLConstant *)shouldMoveMessage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shouldMoveMessage" type: typeType code: 'rstm'];
    return constantObj;
}

+ (MLConstant *)shouldPlayOtherMailSounds {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"shouldPlayOtherMailSounds" type: typeType code: 'poms'];
    return constantObj;
}

+ (MLConstant *)showOnlineBuddyStatus {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"showOnlineBuddyStatus" type: typeType code: 'shsp'];
    return constantObj;
}

+ (MLConstant *)signature {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"signature" type: typeType code: 'situ'];
    return constantObj;
}

+ (MLConstant *)size {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (MLConstant *)smtpServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"smtpServer" type: typeType code: 'dact'];
    return constantObj;
}

+ (MLConstant *)sortColumn {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sortColumn" type: typeType code: 'mvsc'];
    return constantObj;
}

+ (MLConstant *)sortedAscending {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"sortedAscending" type: typeType code: 'mvsr'];
    return constantObj;
}

+ (MLConstant *)source {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"source" type: typeType code: 'raso'];
    return constantObj;
}

+ (MLConstant *)squareFeet {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"squareFeet" type: typeType code: 'sqft'];
    return constantObj;
}

+ (MLConstant *)squareKilometers {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"squareKilometers" type: typeType code: 'sqkm'];
    return constantObj;
}

+ (MLConstant *)squareMeters {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"squareMeters" type: typeType code: 'sqrm'];
    return constantObj;
}

+ (MLConstant *)squareMiles {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"squareMiles" type: typeType code: 'sqmi'];
    return constantObj;
}

+ (MLConstant *)squareYards {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"squareYards" type: typeType code: 'sqyd'];
    return constantObj;
}

+ (MLConstant *)startingPage {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (MLConstant *)stopEvaluatingRules {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"stopEvaluatingRules" type: typeType code: 'rser'];
    return constantObj;
}

+ (MLConstant *)storeDeletedMessagesOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeDeletedMessagesOnServer" type: typeType code: 'stos'];
    return constantObj;
}

+ (MLConstant *)storeDraftsOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeDraftsOnServer" type: typeType code: 'sdos'];
    return constantObj;
}

+ (MLConstant *)storeJunkMailOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeJunkMailOnServer" type: typeType code: 'sjos'];
    return constantObj;
}

+ (MLConstant *)storeSentMessagesOnServer {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"storeSentMessagesOnServer" type: typeType code: 'ssos'];
    return constantObj;
}

+ (MLConstant *)string {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"string" type: typeType code: 'TEXT'];
    return constantObj;
}

+ (MLConstant *)styledClipboardText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"styledClipboardText" type: typeType code: 'styl'];
    return constantObj;
}

+ (MLConstant *)styledText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"styledText" type: typeType code: 'STXT'];
    return constantObj;
}

+ (MLConstant *)subject {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"subject" type: typeType code: 'subj'];
    return constantObj;
}

+ (MLConstant *)suiteInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"suiteInfo" type: typeType code: 'suin'];
    return constantObj;
}

+ (MLConstant *)targetPrinter {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (MLConstant *)text {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (MLConstant *)textStyleInfo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"textStyleInfo" type: typeType code: 'tsty'];
    return constantObj;
}

+ (MLConstant *)titled {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (MLConstant *)toRecipient {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"toRecipient" type: typeType code: 'trcp'];
    return constantObj;
}

+ (MLConstant *)trashMailbox {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"trashMailbox" type: typeType code: 'trmb'];
    return constantObj;
}

+ (MLConstant *)typeClass {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"typeClass" type: typeType code: 'type'];
    return constantObj;
}

+ (MLConstant *)unicodeText {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"unicodeText" type: typeType code: 'utxt'];
    return constantObj;
}

+ (MLConstant *)unreadCount {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"unreadCount" type: typeType code: 'mbuc'];
    return constantObj;
}

+ (MLConstant *)unsignedInteger {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"unsignedInteger" type: typeType code: 'magn'];
    return constantObj;
}

+ (MLConstant *)useAddressCompletion {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"useAddressCompletion" type: typeType code: 'usla'];
    return constantObj;
}

+ (MLConstant *)useFixedWidthFont {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"useFixedWidthFont" type: typeType code: 'ufwf'];
    return constantObj;
}

+ (MLConstant *)userName {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"userName" type: typeType code: 'unme'];
    return constantObj;
}

+ (MLConstant *)usesSsl {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"usesSsl" type: typeType code: 'usss'];
    return constantObj;
}

+ (MLConstant *)utf16Text {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"utf16Text" type: typeType code: 'ut16'];
    return constantObj;
}

+ (MLConstant *)utf8Text {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"utf8Text" type: typeType code: 'utf8'];
    return constantObj;
}

+ (MLConstant *)version {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (MLConstant *)version_ {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (MLConstant *)visible {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (MLConstant *)visibleColumns {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"visibleColumns" type: typeType code: 'mvvc'];
    return constantObj;
}

+ (MLConstant *)visibleMessages {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"visibleMessages" type: typeType code: 'mvfm'];
    return constantObj;
}

+ (MLConstant *)wasForwarded {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"wasForwarded" type: typeType code: 'isfw'];
    return constantObj;
}

+ (MLConstant *)wasRedirected {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"wasRedirected" type: typeType code: 'isrc'];
    return constantObj;
}

+ (MLConstant *)wasRepliedTo {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"wasRepliedTo" type: typeType code: 'isrp'];
    return constantObj;
}

+ (MLConstant *)window {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (MLConstant *)word {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (MLConstant *)writingCode {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"writingCode" type: typeType code: 'psct'];
    return constantObj;
}

+ (MLConstant *)yards {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"yards" type: typeType code: 'yard'];
    return constantObj;
}

+ (MLConstant *)zoomable {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (MLConstant *)zoomed {
    static MLConstant *constantObj;
    if (!constantObj)
        constantObj = [MLConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end


