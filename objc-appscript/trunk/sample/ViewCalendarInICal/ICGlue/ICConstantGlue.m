/*
 * ICConstantGlue.m
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import "ICConstantGlue.h"

@implementation ICConstant
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
        case 'E6ap': return [self accepted];
        case 'alis': return [self alias];
        case 'wrad': return [self alldayEvent];
        case '****': return [self anything];
        case 'capp': return [self application];
        case 'bund': return [self applicationBundleID];
        case 'rmte': return [self applicationResponses];
        case 'sign': return [self applicationSignature];
        case 'aprl': return [self applicationURL];
        case 'ask ': return [self ask];
        case 'atts': return [self attachment];
        case 'wrea': return [self attendee];
        case 'catr': return [self attributeRun];
        case 'best': return [self best];
        case 'bool': return [self boolean];
        case 'qdrt': return [self boundingRectangle];
        case 'pbnd': return [self bounds];
        case 'wres': return [self calendar];
        case 'E4ca': return [self cancelled];
        case 'case': return [self case_];
        case 'cmtr': return [self centimeters];
        case 'cha ': return [self character];
        case 'gcli': return [self classInfo];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'clrt': return [self colorTable];
        case 'wrt1': return [self completionDate];
        case 'E4cn': return [self confirmed];
        case 'lwcp': return [self copies];
        case 'ccmt': return [self cubicCentimeters];
        case 'cfet': return [self cubicFeet];
        case 'cuin': return [self cubicInches];
        case 'cmet': return [self cubicMeters];
        case 'cyrd': return [self cubicYards];
        case 'tdas': return [self dashStyle];
        case 'rdat': return [self data];
        case 'ldt ': return [self date];
        case 'E5da': return [self dayView];
        case 'decm': return [self decimalStruct];
        case 'E6dp': return [self declined];
        case 'degc': return [self degreesCelsius];
        case 'degf': return [self degreesFahrenheit];
        case 'degk': return [self degreesKelvin];
        case 'wr12': return [self description_];
        case 'lwdt': return [self detailed];
        case 'diac': return [self diacriticals];
        case 'wal1': return [self displayAlarm];
        case 'wra1': return [self displayName];
        case 'docu': return [self document];
        case 'comp': return [self doubleInteger];
        case 'wrt3': return [self dueDate];
        case 'elin': return [self elementInfo];
        case 'wra2': return [self email];
        case 'encs': return [self encodedString];
        case 'wr5s': return [self endDate];
        case 'lwlp': return [self endingPage];
        case 'enum': return [self enumerator];
        case 'lweh': return [self errorHandling];
        case 'wrev': return [self event];
        case 'evin': return [self eventInfo];
        case 'wr2s': return [self excludedDates];
        case 'expa': return [self expansion];
        case 'exte': return [self extendedFloat];
        case 'faxn': return [self faxNumber];
        case 'feet': return [self feet];
        case 'atfn': return [self fileName];
        case 'fsrf': return [self fileRef];
        case 'fss ': return [self fileSpecification];
        case 'furl': return [self fileURL];
        case 'walp': return [self filepath];
        case 'fixd': return [self fixed];
        case 'fpnt': return [self fixedPoint];
        case 'frct': return [self fixedRectangle];
        case 'ldbl': return [self float128bit];
        case 'doub': return [self float_];
        case 'isfl': return [self floating];
        case 'font': return [self font];
        case 'pisf': return [self frontmost];
        case 'galn': return [self gallons];
        case 'gram': return [self grams];
        case 'cgtx': return [self graphicText];
        case 'tdp1': return [self highPriority];
        case 'hyph': return [self hyphens];
        case 'inch': return [self inches];
        case 'pidx': return [self index];
        case 'long': return [self integer];
        case 'itxt': return [self internationalText];
        case 'intl': return [self internationalWritingCode];
        case 'cobj': return [self item];
        case 'kpid': return [self kernelProcessID];
        case 'kgrm': return [self kilograms];
        case 'kmtr': return [self kilometers];
        case 'list': return [self list];
        case 'litr': return [self liters];
        case 'wr14': return [self location];
        case 'insl': return [self locationReference];
        case 'lfxd': return [self longFixed];
        case 'lfpt': return [self longFixedPoint];
        case 'lfrc': return [self longFixedRectangle];
        case 'lpnt': return [self longPoint];
        case 'lrct': return [self longRectangle];
        case 'tdp9': return [self lowPriority];
        case 'port': return [self machPort];
        case 'mach': return [self machine];
        case 'mLoc': return [self machineLocation];
        case 'wal2': return [self mailAlarm];
        case 'tdp5': return [self mediumPriority];
        case 'metr': return [self meters];
        case 'mile': return [self miles];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'msng': return [self missingValue];
        case 'pmod': return [self modal];
        case 'imod': return [self modified];
        case 'E5mo': return [self monthView];
        case 'pnam': return [self name];
        case 'no  ': return [self no];
        case 'tdp0': return [self noPriority];
        case 'E4no': return [self none];
        case 'null': return [self null];
        case 'nume': return [self numericStrings];
        case 'wal3': return [self openFileAlarm];
        case 'ozs ': return [self ounces];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'pmin': return [self parameterInfo];
        case 'wra3': return [self participationStatus];
        case 'ppth': return [self path];
        case 'tpmm': return [self pixelMapRecord];
        case 'QDpt': return [self point];
        case 'lbs ': return [self pounds];
        case 'pset': return [self printSettings];
        case 'wrt5': return [self priority];
        case 'psn ': return [self processSerialNumber];
        case 'pALL': return [self properties];
        case 'prop': return [self property];
        case 'pinf': return [self propertyInfo];
        case 'punc': return [self punctuation];
        case 'qrts': return [self quarts];
        case 'reco': return [self record];
        case 'wr15': return [self recurrence];
        case 'obj ': return [self reference];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'trot': return [self rotation];
        case 'scpt': return [self script];
        case 'wr13': return [self sequence];
        case 'sing': return [self shortFloat];
        case 'shor': return [self shortInteger];
        case 'ptsz': return [self size];
        case 'wal4': return [self soundAlarm];
        case 'walf': return [self soundFile];
        case 'wals': return [self soundName];
        case 'sqft': return [self squareFeet];
        case 'sqkm': return [self squareKilometers];
        case 'sqrm': return [self squareMeters];
        case 'sqmi': return [self squareMiles];
        case 'sqyd': return [self squareYards];
        case 'wr4s': return [self stampDate];
        case 'lwst': return [self standard];
        case 'wr1s': return [self startDate];
        case 'lwfp': return [self startingPage];
        case 'wre4': return [self status];
        case 'TEXT': return [self string];
        case 'styl': return [self styledClipboardText];
        case 'STXT': return [self styledText];
        case 'suin': return [self suiteInfo];
        case 'wr11': return [self summary];
        case 'trpr': return [self targetPrinter];
        case 'E4te': return [self tentative];
        case 'E6tp': return [self tentative];
        case 'ctxt': return [self text];
        case 'tsty': return [self textStyleInfo];
        case 'ptit': return [self titled];
        case 'wret': return [self todo];
        case 'wale': return [self triggerDate];
        case 'wald': return [self triggerInterval];
        case 'type': return [self typeClass];
        case 'ID  ': return [self uid];
        case 'utxt': return [self unicodeText];
        case 'E6na': return [self unknown];
        case 'magn': return [self unsignedInteger];
        case 'wr16': return [self url];
        case 'ut16': return [self utf16Text];
        case 'utf8': return [self utf8Text];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'E5we': return [self weekView];
        case 'whit': return [self whitespace];
        case 'cwin': return [self window];
        case 'cwor': return [self word];
        case 'wr05': return [self writable];
        case 'psct': return [self writingCode];
        case 'yard': return [self yards];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (ICConstant *)accepted {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"accepted" type: typeEnumerated code: 'E6ap'];
    return constantObj;
}

+ (ICConstant *)applicationResponses {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"applicationResponses" type: typeEnumerated code: 'rmte'];
    return constantObj;
}

+ (ICConstant *)ask {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (ICConstant *)cancelled {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"cancelled" type: typeEnumerated code: 'E4ca'];
    return constantObj;
}

+ (ICConstant *)case_ {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"case_" type: typeEnumerated code: 'case'];
    return constantObj;
}

+ (ICConstant *)confirmed {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"confirmed" type: typeEnumerated code: 'E4cn'];
    return constantObj;
}

+ (ICConstant *)dayView {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"dayView" type: typeEnumerated code: 'E5da'];
    return constantObj;
}

+ (ICConstant *)declined {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"declined" type: typeEnumerated code: 'E6dp'];
    return constantObj;
}

+ (ICConstant *)detailed {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (ICConstant *)diacriticals {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"diacriticals" type: typeEnumerated code: 'diac'];
    return constantObj;
}

+ (ICConstant *)expansion {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"expansion" type: typeEnumerated code: 'expa'];
    return constantObj;
}

+ (ICConstant *)highPriority {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"highPriority" type: typeEnumerated code: 'tdp1'];
    return constantObj;
}

+ (ICConstant *)hyphens {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"hyphens" type: typeEnumerated code: 'hyph'];
    return constantObj;
}

+ (ICConstant *)lowPriority {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"lowPriority" type: typeEnumerated code: 'tdp9'];
    return constantObj;
}

+ (ICConstant *)mediumPriority {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"mediumPriority" type: typeEnumerated code: 'tdp5'];
    return constantObj;
}

+ (ICConstant *)monthView {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"monthView" type: typeEnumerated code: 'E5mo'];
    return constantObj;
}

+ (ICConstant *)no {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (ICConstant *)noPriority {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"noPriority" type: typeEnumerated code: 'tdp0'];
    return constantObj;
}

+ (ICConstant *)none {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"none" type: typeEnumerated code: 'E4no'];
    return constantObj;
}

+ (ICConstant *)numericStrings {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"numericStrings" type: typeEnumerated code: 'nume'];
    return constantObj;
}

+ (ICConstant *)punctuation {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"punctuation" type: typeEnumerated code: 'punc'];
    return constantObj;
}

+ (ICConstant *)standard {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (ICConstant *)tentative {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"tentative" type: typeEnumerated code: 'E6tp'];
    return constantObj;
}

+ (ICConstant *)unknown {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"unknown" type: typeEnumerated code: 'E6na'];
    return constantObj;
}

+ (ICConstant *)weekView {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"weekView" type: typeEnumerated code: 'E5we'];
    return constantObj;
}

+ (ICConstant *)whitespace {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"whitespace" type: typeEnumerated code: 'whit'];
    return constantObj;
}

+ (ICConstant *)yes {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (ICConstant *)April {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"April" type: typeType code: 'apr '];
    return constantObj;
}

+ (ICConstant *)August {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"August" type: typeType code: 'aug '];
    return constantObj;
}

+ (ICConstant *)December {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"December" type: typeType code: 'dec '];
    return constantObj;
}

+ (ICConstant *)EPSPicture {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"EPSPicture" type: typeType code: 'EPS '];
    return constantObj;
}

+ (ICConstant *)February {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"February" type: typeType code: 'feb '];
    return constantObj;
}

+ (ICConstant *)Friday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Friday" type: typeType code: 'fri '];
    return constantObj;
}

+ (ICConstant *)GIFPicture {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"GIFPicture" type: typeType code: 'GIFf'];
    return constantObj;
}

+ (ICConstant *)JPEGPicture {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"JPEGPicture" type: typeType code: 'JPEG'];
    return constantObj;
}

+ (ICConstant *)January {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"January" type: typeType code: 'jan '];
    return constantObj;
}

+ (ICConstant *)July {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"July" type: typeType code: 'jul '];
    return constantObj;
}

+ (ICConstant *)June {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"June" type: typeType code: 'jun '];
    return constantObj;
}

+ (ICConstant *)March {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"March" type: typeType code: 'mar '];
    return constantObj;
}

+ (ICConstant *)May {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"May" type: typeType code: 'may '];
    return constantObj;
}

+ (ICConstant *)Monday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Monday" type: typeType code: 'mon '];
    return constantObj;
}

+ (ICConstant *)November {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"November" type: typeType code: 'nov '];
    return constantObj;
}

+ (ICConstant *)October {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"October" type: typeType code: 'oct '];
    return constantObj;
}

+ (ICConstant *)PICTPicture {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"PICTPicture" type: typeType code: 'PICT'];
    return constantObj;
}

+ (ICConstant *)RGB16Color {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"RGB16Color" type: typeType code: 'tr16'];
    return constantObj;
}

+ (ICConstant *)RGB96Color {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"RGB96Color" type: typeType code: 'tr96'];
    return constantObj;
}

+ (ICConstant *)RGBColor {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"RGBColor" type: typeType code: 'cRGB'];
    return constantObj;
}

+ (ICConstant *)Saturday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Saturday" type: typeType code: 'sat '];
    return constantObj;
}

+ (ICConstant *)September {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"September" type: typeType code: 'sep '];
    return constantObj;
}

+ (ICConstant *)Sunday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Sunday" type: typeType code: 'sun '];
    return constantObj;
}

+ (ICConstant *)TIFFPicture {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"TIFFPicture" type: typeType code: 'TIFF'];
    return constantObj;
}

+ (ICConstant *)Thursday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Thursday" type: typeType code: 'thu '];
    return constantObj;
}

+ (ICConstant *)Tuesday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Tuesday" type: typeType code: 'tue '];
    return constantObj;
}

+ (ICConstant *)Wednesday {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"Wednesday" type: typeType code: 'wed '];
    return constantObj;
}

+ (ICConstant *)alias {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (ICConstant *)alldayEvent {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"alldayEvent" type: typeType code: 'wrad'];
    return constantObj;
}

+ (ICConstant *)anything {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"anything" type: typeType code: '****'];
    return constantObj;
}

+ (ICConstant *)application {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (ICConstant *)applicationBundleID {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"applicationBundleID" type: typeType code: 'bund'];
    return constantObj;
}

+ (ICConstant *)applicationSignature {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"applicationSignature" type: typeType code: 'sign'];
    return constantObj;
}

+ (ICConstant *)applicationURL {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"applicationURL" type: typeType code: 'aprl'];
    return constantObj;
}

+ (ICConstant *)attachment {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (ICConstant *)attendee {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"attendee" type: typeType code: 'wrea'];
    return constantObj;
}

+ (ICConstant *)attributeRun {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (ICConstant *)best {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"best" type: typeType code: 'best'];
    return constantObj;
}

+ (ICConstant *)boolean {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"boolean" type: typeType code: 'bool'];
    return constantObj;
}

+ (ICConstant *)boundingRectangle {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"boundingRectangle" type: typeType code: 'qdrt'];
    return constantObj;
}

+ (ICConstant *)bounds {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (ICConstant *)calendar {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"calendar" type: typeType code: 'wres'];
    return constantObj;
}

+ (ICConstant *)centimeters {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"centimeters" type: typeType code: 'cmtr'];
    return constantObj;
}

+ (ICConstant *)character {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (ICConstant *)classInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"classInfo" type: typeType code: 'gcli'];
    return constantObj;
}

+ (ICConstant *)class_ {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (ICConstant *)closeable {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (ICConstant *)collating {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (ICConstant *)color {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (ICConstant *)colorTable {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"colorTable" type: typeType code: 'clrt'];
    return constantObj;
}

+ (ICConstant *)completionDate {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"completionDate" type: typeType code: 'wrt1'];
    return constantObj;
}

+ (ICConstant *)copies {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (ICConstant *)cubicCentimeters {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"cubicCentimeters" type: typeType code: 'ccmt'];
    return constantObj;
}

+ (ICConstant *)cubicFeet {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"cubicFeet" type: typeType code: 'cfet'];
    return constantObj;
}

+ (ICConstant *)cubicInches {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"cubicInches" type: typeType code: 'cuin'];
    return constantObj;
}

+ (ICConstant *)cubicMeters {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"cubicMeters" type: typeType code: 'cmet'];
    return constantObj;
}

+ (ICConstant *)cubicYards {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"cubicYards" type: typeType code: 'cyrd'];
    return constantObj;
}

+ (ICConstant *)dashStyle {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"dashStyle" type: typeType code: 'tdas'];
    return constantObj;
}

+ (ICConstant *)data {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"data" type: typeType code: 'rdat'];
    return constantObj;
}

+ (ICConstant *)date {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"date" type: typeType code: 'ldt '];
    return constantObj;
}

+ (ICConstant *)decimalStruct {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"decimalStruct" type: typeType code: 'decm'];
    return constantObj;
}

+ (ICConstant *)degreesCelsius {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"degreesCelsius" type: typeType code: 'degc'];
    return constantObj;
}

+ (ICConstant *)degreesFahrenheit {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"degreesFahrenheit" type: typeType code: 'degf'];
    return constantObj;
}

+ (ICConstant *)degreesKelvin {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"degreesKelvin" type: typeType code: 'degk'];
    return constantObj;
}

+ (ICConstant *)description_ {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"description_" type: typeType code: 'wr12'];
    return constantObj;
}

+ (ICConstant *)displayAlarm {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"displayAlarm" type: typeType code: 'wal1'];
    return constantObj;
}

+ (ICConstant *)displayName {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"displayName" type: typeType code: 'wra1'];
    return constantObj;
}

+ (ICConstant *)document {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (ICConstant *)doubleInteger {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"doubleInteger" type: typeType code: 'comp'];
    return constantObj;
}

+ (ICConstant *)dueDate {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"dueDate" type: typeType code: 'wrt3'];
    return constantObj;
}

+ (ICConstant *)elementInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"elementInfo" type: typeType code: 'elin'];
    return constantObj;
}

+ (ICConstant *)email {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"email" type: typeType code: 'wra2'];
    return constantObj;
}

+ (ICConstant *)encodedString {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"encodedString" type: typeType code: 'encs'];
    return constantObj;
}

+ (ICConstant *)endDate {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"endDate" type: typeType code: 'wr5s'];
    return constantObj;
}

+ (ICConstant *)endingPage {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (ICConstant *)enumerator {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"enumerator" type: typeType code: 'enum'];
    return constantObj;
}

+ (ICConstant *)errorHandling {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (ICConstant *)event {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"event" type: typeType code: 'wrev'];
    return constantObj;
}

+ (ICConstant *)eventInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"eventInfo" type: typeType code: 'evin'];
    return constantObj;
}

+ (ICConstant *)excludedDates {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"excludedDates" type: typeType code: 'wr2s'];
    return constantObj;
}

+ (ICConstant *)extendedFloat {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"extendedFloat" type: typeType code: 'exte'];
    return constantObj;
}

+ (ICConstant *)faxNumber {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (ICConstant *)feet {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"feet" type: typeType code: 'feet'];
    return constantObj;
}

+ (ICConstant *)fileName {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (ICConstant *)fileRef {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fileRef" type: typeType code: 'fsrf'];
    return constantObj;
}

+ (ICConstant *)fileSpecification {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fileSpecification" type: typeType code: 'fss '];
    return constantObj;
}

+ (ICConstant *)fileURL {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fileURL" type: typeType code: 'furl'];
    return constantObj;
}

+ (ICConstant *)filepath {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"filepath" type: typeType code: 'walp'];
    return constantObj;
}

+ (ICConstant *)fixed {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fixed" type: typeType code: 'fixd'];
    return constantObj;
}

+ (ICConstant *)fixedPoint {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fixedPoint" type: typeType code: 'fpnt'];
    return constantObj;
}

+ (ICConstant *)fixedRectangle {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"fixedRectangle" type: typeType code: 'frct'];
    return constantObj;
}

+ (ICConstant *)float128bit {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"float128bit" type: typeType code: 'ldbl'];
    return constantObj;
}

+ (ICConstant *)float_ {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"float_" type: typeType code: 'doub'];
    return constantObj;
}

+ (ICConstant *)floating {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (ICConstant *)font {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (ICConstant *)frontmost {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (ICConstant *)gallons {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"gallons" type: typeType code: 'galn'];
    return constantObj;
}

+ (ICConstant *)grams {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"grams" type: typeType code: 'gram'];
    return constantObj;
}

+ (ICConstant *)graphicText {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"graphicText" type: typeType code: 'cgtx'];
    return constantObj;
}

+ (ICConstant *)id_ {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (ICConstant *)inches {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"inches" type: typeType code: 'inch'];
    return constantObj;
}

+ (ICConstant *)index {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (ICConstant *)integer {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"integer" type: typeType code: 'long'];
    return constantObj;
}

+ (ICConstant *)internationalText {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"internationalText" type: typeType code: 'itxt'];
    return constantObj;
}

+ (ICConstant *)internationalWritingCode {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"internationalWritingCode" type: typeType code: 'intl'];
    return constantObj;
}

+ (ICConstant *)item {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (ICConstant *)kernelProcessID {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"kernelProcessID" type: typeType code: 'kpid'];
    return constantObj;
}

+ (ICConstant *)kilograms {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"kilograms" type: typeType code: 'kgrm'];
    return constantObj;
}

+ (ICConstant *)kilometers {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"kilometers" type: typeType code: 'kmtr'];
    return constantObj;
}

+ (ICConstant *)list {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (ICConstant *)liters {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"liters" type: typeType code: 'litr'];
    return constantObj;
}

+ (ICConstant *)location {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"location" type: typeType code: 'wr14'];
    return constantObj;
}

+ (ICConstant *)locationReference {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"locationReference" type: typeType code: 'insl'];
    return constantObj;
}

+ (ICConstant *)longFixed {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"longFixed" type: typeType code: 'lfxd'];
    return constantObj;
}

+ (ICConstant *)longFixedPoint {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"longFixedPoint" type: typeType code: 'lfpt'];
    return constantObj;
}

+ (ICConstant *)longFixedRectangle {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"longFixedRectangle" type: typeType code: 'lfrc'];
    return constantObj;
}

+ (ICConstant *)longPoint {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"longPoint" type: typeType code: 'lpnt'];
    return constantObj;
}

+ (ICConstant *)longRectangle {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"longRectangle" type: typeType code: 'lrct'];
    return constantObj;
}

+ (ICConstant *)machPort {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"machPort" type: typeType code: 'port'];
    return constantObj;
}

+ (ICConstant *)machine {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"machine" type: typeType code: 'mach'];
    return constantObj;
}

+ (ICConstant *)machineLocation {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"machineLocation" type: typeType code: 'mLoc'];
    return constantObj;
}

+ (ICConstant *)mailAlarm {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"mailAlarm" type: typeType code: 'wal2'];
    return constantObj;
}

+ (ICConstant *)meters {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"meters" type: typeType code: 'metr'];
    return constantObj;
}

+ (ICConstant *)miles {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"miles" type: typeType code: 'mile'];
    return constantObj;
}

+ (ICConstant *)miniaturizable {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (ICConstant *)miniaturized {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (ICConstant *)missingValue {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"missingValue" type: typeType code: 'msng'];
    return constantObj;
}

+ (ICConstant *)modal {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (ICConstant *)modified {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (ICConstant *)name {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (ICConstant *)null {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"null" type: typeType code: 'null'];
    return constantObj;
}

+ (ICConstant *)openFileAlarm {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"openFileAlarm" type: typeType code: 'wal3'];
    return constantObj;
}

+ (ICConstant *)ounces {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"ounces" type: typeType code: 'ozs '];
    return constantObj;
}

+ (ICConstant *)pagesAcross {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (ICConstant *)pagesDown {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (ICConstant *)paragraph {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (ICConstant *)parameterInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"parameterInfo" type: typeType code: 'pmin'];
    return constantObj;
}

+ (ICConstant *)participationStatus {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"participationStatus" type: typeType code: 'wra3'];
    return constantObj;
}

+ (ICConstant *)path {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (ICConstant *)pixelMapRecord {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"pixelMapRecord" type: typeType code: 'tpmm'];
    return constantObj;
}

+ (ICConstant *)point {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"point" type: typeType code: 'QDpt'];
    return constantObj;
}

+ (ICConstant *)pounds {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"pounds" type: typeType code: 'lbs '];
    return constantObj;
}

+ (ICConstant *)printSettings {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (ICConstant *)priority {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"priority" type: typeType code: 'wrt5'];
    return constantObj;
}

+ (ICConstant *)processSerialNumber {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"processSerialNumber" type: typeType code: 'psn '];
    return constantObj;
}

+ (ICConstant *)properties {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (ICConstant *)property {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"property" type: typeType code: 'prop'];
    return constantObj;
}

+ (ICConstant *)propertyInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"propertyInfo" type: typeType code: 'pinf'];
    return constantObj;
}

+ (ICConstant *)quarts {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"quarts" type: typeType code: 'qrts'];
    return constantObj;
}

+ (ICConstant *)record {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"record" type: typeType code: 'reco'];
    return constantObj;
}

+ (ICConstant *)recurrence {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"recurrence" type: typeType code: 'wr15'];
    return constantObj;
}

+ (ICConstant *)reference {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"reference" type: typeType code: 'obj '];
    return constantObj;
}

+ (ICConstant *)requestedPrintTime {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (ICConstant *)resizable {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (ICConstant *)rotation {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"rotation" type: typeType code: 'trot'];
    return constantObj;
}

+ (ICConstant *)script {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (ICConstant *)sequence {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"sequence" type: typeType code: 'wr13'];
    return constantObj;
}

+ (ICConstant *)shortFloat {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"shortFloat" type: typeType code: 'sing'];
    return constantObj;
}

+ (ICConstant *)shortInteger {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"shortInteger" type: typeType code: 'shor'];
    return constantObj;
}

+ (ICConstant *)size {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (ICConstant *)soundAlarm {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"soundAlarm" type: typeType code: 'wal4'];
    return constantObj;
}

+ (ICConstant *)soundFile {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"soundFile" type: typeType code: 'walf'];
    return constantObj;
}

+ (ICConstant *)soundName {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"soundName" type: typeType code: 'wals'];
    return constantObj;
}

+ (ICConstant *)squareFeet {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"squareFeet" type: typeType code: 'sqft'];
    return constantObj;
}

+ (ICConstant *)squareKilometers {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"squareKilometers" type: typeType code: 'sqkm'];
    return constantObj;
}

+ (ICConstant *)squareMeters {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"squareMeters" type: typeType code: 'sqrm'];
    return constantObj;
}

+ (ICConstant *)squareMiles {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"squareMiles" type: typeType code: 'sqmi'];
    return constantObj;
}

+ (ICConstant *)squareYards {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"squareYards" type: typeType code: 'sqyd'];
    return constantObj;
}

+ (ICConstant *)stampDate {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"stampDate" type: typeType code: 'wr4s'];
    return constantObj;
}

+ (ICConstant *)startDate {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"startDate" type: typeType code: 'wr1s'];
    return constantObj;
}

+ (ICConstant *)startingPage {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (ICConstant *)status {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"status" type: typeType code: 'wre4'];
    return constantObj;
}

+ (ICConstant *)string {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"string" type: typeType code: 'TEXT'];
    return constantObj;
}

+ (ICConstant *)styledClipboardText {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"styledClipboardText" type: typeType code: 'styl'];
    return constantObj;
}

+ (ICConstant *)styledText {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"styledText" type: typeType code: 'STXT'];
    return constantObj;
}

+ (ICConstant *)suiteInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"suiteInfo" type: typeType code: 'suin'];
    return constantObj;
}

+ (ICConstant *)summary {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"summary" type: typeType code: 'wr11'];
    return constantObj;
}

+ (ICConstant *)targetPrinter {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (ICConstant *)text {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (ICConstant *)textStyleInfo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"textStyleInfo" type: typeType code: 'tsty'];
    return constantObj;
}

+ (ICConstant *)titled {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (ICConstant *)todo {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"todo" type: typeType code: 'wret'];
    return constantObj;
}

+ (ICConstant *)triggerDate {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"triggerDate" type: typeType code: 'wale'];
    return constantObj;
}

+ (ICConstant *)triggerInterval {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"triggerInterval" type: typeType code: 'wald'];
    return constantObj;
}

+ (ICConstant *)typeClass {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"typeClass" type: typeType code: 'type'];
    return constantObj;
}

+ (ICConstant *)uid {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"uid" type: typeType code: 'ID  '];
    return constantObj;
}

+ (ICConstant *)unicodeText {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"unicodeText" type: typeType code: 'utxt'];
    return constantObj;
}

+ (ICConstant *)unsignedInteger {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"unsignedInteger" type: typeType code: 'magn'];
    return constantObj;
}

+ (ICConstant *)url {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"url" type: typeType code: 'wr16'];
    return constantObj;
}

+ (ICConstant *)utf16Text {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"utf16Text" type: typeType code: 'ut16'];
    return constantObj;
}

+ (ICConstant *)utf8Text {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"utf8Text" type: typeType code: 'utf8'];
    return constantObj;
}

+ (ICConstant *)version {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (ICConstant *)version_ {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (ICConstant *)visible {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (ICConstant *)window {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (ICConstant *)word {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (ICConstant *)writable {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"writable" type: typeType code: 'wr05'];
    return constantObj;
}

+ (ICConstant *)writingCode {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"writingCode" type: typeType code: 'psct'];
    return constantObj;
}

+ (ICConstant *)yards {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"yards" type: typeType code: 'yard'];
    return constantObj;
}

+ (ICConstant *)zoomable {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (ICConstant *)zoomed {
    static ICConstant *constantObj;
    if (!constantObj)
        constantObj = [ICConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end

