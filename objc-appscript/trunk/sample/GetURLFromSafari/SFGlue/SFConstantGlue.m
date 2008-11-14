/*
 * SFConstantGlue.m
 * /Applications/Safari.app
 * osaglue 0.5.1
 *
 */

#import "SFConstantGlue.h"

@implementation SFConstant
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
        case 'pURL': return [self URL];
        case 'wed ': return [self Wednesday];
        case 'alis': return [self alias];
        case '****': return [self anything];
        case 'capp': return [self application];
        case 'bund': return [self applicationBundleID];
        case 'rmte': return [self applicationResponses];
        case 'sign': return [self applicationSignature];
        case 'aprl': return [self applicationURL];
        case 'ask ': return [self ask];
        case 'atts': return [self attachment];
        case 'catr': return [self attributeRun];
        case 'best': return [self best];
        case 'bool': return [self boolean];
        case 'qdrt': return [self boundingRectangle];
        case 'pbnd': return [self bounds];
        case 'case': return [self case_];
        case 'cmtr': return [self centimeters];
        case 'cha ': return [self character];
        case 'gcli': return [self classInfo];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'clrt': return [self colorTable];
        case 'lwcp': return [self copies];
        case 'ccmt': return [self cubicCentimeters];
        case 'cfet': return [self cubicFeet];
        case 'cuin': return [self cubicInches];
        case 'cmet': return [self cubicMeters];
        case 'cyrd': return [self cubicYards];
        case 'cTab': return [self currentTab];
        case 'tdas': return [self dashStyle];
        case 'rdat': return [self data];
        case 'ldt ': return [self date];
        case 'decm': return [self decimalStruct];
        case 'degc': return [self degreesCelsius];
        case 'degf': return [self degreesFahrenheit];
        case 'degk': return [self degreesKelvin];
        case 'lwdt': return [self detailed];
        case 'diac': return [self diacriticals];
        case 'docu': return [self document];
        case 'comp': return [self doubleInteger];
        case 'elin': return [self elementInfo];
        case 'encs': return [self encodedString];
        case 'lwlp': return [self endingPage];
        case 'enum': return [self enumerator];
        case 'lweh': return [self errorHandling];
        case 'evin': return [self eventInfo];
        case 'expa': return [self expansion];
        case 'exte': return [self extendedFloat];
        case 'faxn': return [self faxNumber];
        case 'feet': return [self feet];
        case 'atfn': return [self fileName];
        case 'fsrf': return [self fileRef];
        case 'fss ': return [self fileSpecification];
        case 'furl': return [self fileURL];
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
        case 'hyph': return [self hyphens];
        case 'ID  ': return [self id_];
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
        case 'insl': return [self locationReference];
        case 'lfxd': return [self longFixed];
        case 'lfpt': return [self longFixedPoint];
        case 'lfrc': return [self longFixedRectangle];
        case 'lpnt': return [self longPoint];
        case 'lrct': return [self longRectangle];
        case 'port': return [self machPort];
        case 'mach': return [self machine];
        case 'mLoc': return [self machineLocation];
        case 'metr': return [self meters];
        case 'mile': return [self miles];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'msng': return [self missingValue];
        case 'pmod': return [self modal];
        case 'imod': return [self modified];
        case 'pnam': return [self name];
        case 'no  ': return [self no];
        case 'null': return [self null];
        case 'nume': return [self numericStrings];
        case 'ozs ': return [self ounces];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'pmin': return [self parameterInfo];
        case 'ppth': return [self path];
        case 'tpmm': return [self pixelMapRecord];
        case 'QDpt': return [self point];
        case 'lbs ': return [self pounds];
        case 'pset': return [self printSettings];
        case 'psn ': return [self processSerialNumber];
        case 'pALL': return [self properties];
        case 'prop': return [self property];
        case 'pinf': return [self propertyInfo];
        case 'punc': return [self punctuation];
        case 'qrts': return [self quarts];
        case 'reco': return [self record];
        case 'obj ': return [self reference];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'trot': return [self rotation];
        case 'scpt': return [self script];
        case 'sing': return [self shortFloat];
        case 'shor': return [self shortInteger];
        case 'ptsz': return [self size];
        case 'conT': return [self source];
        case 'sqft': return [self squareFeet];
        case 'sqkm': return [self squareKilometers];
        case 'sqrm': return [self squareMeters];
        case 'sqmi': return [self squareMiles];
        case 'sqyd': return [self squareYards];
        case 'lwst': return [self standard];
        case 'lwfp': return [self startingPage];
        case 'TEXT': return [self string];
        case 'styl': return [self styledClipboardText];
        case 'STXT': return [self styledText];
        case 'suin': return [self suiteInfo];
        case 'bTab': return [self tab];
        case 'trpr': return [self targetPrinter];
        case 'ctxt': return [self text];
        case 'tsty': return [self textStyleInfo];
        case 'ptit': return [self titled];
        case 'type': return [self typeClass];
        case 'utxt': return [self unicodeText];
        case 'magn': return [self unsignedInteger];
        case 'ut16': return [self utf16Text];
        case 'utf8': return [self utf8Text];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'whit': return [self whitespace];
        case 'cwin': return [self window];
        case 'cwor': return [self word];
        case 'psct': return [self writingCode];
        case 'yard': return [self yards];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (SFConstant *)applicationResponses {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"applicationResponses" type: typeEnumerated code: 'rmte'];
    return constantObj;
}

+ (SFConstant *)ask {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (SFConstant *)case_ {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"case_" type: typeEnumerated code: 'case'];
    return constantObj;
}

+ (SFConstant *)detailed {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (SFConstant *)diacriticals {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"diacriticals" type: typeEnumerated code: 'diac'];
    return constantObj;
}

+ (SFConstant *)expansion {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"expansion" type: typeEnumerated code: 'expa'];
    return constantObj;
}

+ (SFConstant *)hyphens {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"hyphens" type: typeEnumerated code: 'hyph'];
    return constantObj;
}

+ (SFConstant *)no {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (SFConstant *)numericStrings {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"numericStrings" type: typeEnumerated code: 'nume'];
    return constantObj;
}

+ (SFConstant *)punctuation {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"punctuation" type: typeEnumerated code: 'punc'];
    return constantObj;
}

+ (SFConstant *)standard {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (SFConstant *)whitespace {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"whitespace" type: typeEnumerated code: 'whit'];
    return constantObj;
}

+ (SFConstant *)yes {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (SFConstant *)April {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"April" type: typeType code: 'apr '];
    return constantObj;
}

+ (SFConstant *)August {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"August" type: typeType code: 'aug '];
    return constantObj;
}

+ (SFConstant *)December {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"December" type: typeType code: 'dec '];
    return constantObj;
}

+ (SFConstant *)EPSPicture {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"EPSPicture" type: typeType code: 'EPS '];
    return constantObj;
}

+ (SFConstant *)February {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"February" type: typeType code: 'feb '];
    return constantObj;
}

+ (SFConstant *)Friday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Friday" type: typeType code: 'fri '];
    return constantObj;
}

+ (SFConstant *)GIFPicture {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"GIFPicture" type: typeType code: 'GIFf'];
    return constantObj;
}

+ (SFConstant *)JPEGPicture {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"JPEGPicture" type: typeType code: 'JPEG'];
    return constantObj;
}

+ (SFConstant *)January {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"January" type: typeType code: 'jan '];
    return constantObj;
}

+ (SFConstant *)July {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"July" type: typeType code: 'jul '];
    return constantObj;
}

+ (SFConstant *)June {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"June" type: typeType code: 'jun '];
    return constantObj;
}

+ (SFConstant *)March {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"March" type: typeType code: 'mar '];
    return constantObj;
}

+ (SFConstant *)May {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"May" type: typeType code: 'may '];
    return constantObj;
}

+ (SFConstant *)Monday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Monday" type: typeType code: 'mon '];
    return constantObj;
}

+ (SFConstant *)November {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"November" type: typeType code: 'nov '];
    return constantObj;
}

+ (SFConstant *)October {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"October" type: typeType code: 'oct '];
    return constantObj;
}

+ (SFConstant *)PICTPicture {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"PICTPicture" type: typeType code: 'PICT'];
    return constantObj;
}

+ (SFConstant *)RGB16Color {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"RGB16Color" type: typeType code: 'tr16'];
    return constantObj;
}

+ (SFConstant *)RGB96Color {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"RGB96Color" type: typeType code: 'tr96'];
    return constantObj;
}

+ (SFConstant *)RGBColor {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"RGBColor" type: typeType code: 'cRGB'];
    return constantObj;
}

+ (SFConstant *)Saturday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Saturday" type: typeType code: 'sat '];
    return constantObj;
}

+ (SFConstant *)September {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"September" type: typeType code: 'sep '];
    return constantObj;
}

+ (SFConstant *)Sunday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Sunday" type: typeType code: 'sun '];
    return constantObj;
}

+ (SFConstant *)TIFFPicture {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"TIFFPicture" type: typeType code: 'TIFF'];
    return constantObj;
}

+ (SFConstant *)Thursday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Thursday" type: typeType code: 'thu '];
    return constantObj;
}

+ (SFConstant *)Tuesday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Tuesday" type: typeType code: 'tue '];
    return constantObj;
}

+ (SFConstant *)URL {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"URL" type: typeType code: 'pURL'];
    return constantObj;
}

+ (SFConstant *)Wednesday {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"Wednesday" type: typeType code: 'wed '];
    return constantObj;
}

+ (SFConstant *)alias {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (SFConstant *)anything {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"anything" type: typeType code: '****'];
    return constantObj;
}

+ (SFConstant *)application {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (SFConstant *)applicationBundleID {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"applicationBundleID" type: typeType code: 'bund'];
    return constantObj;
}

+ (SFConstant *)applicationSignature {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"applicationSignature" type: typeType code: 'sign'];
    return constantObj;
}

+ (SFConstant *)applicationURL {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"applicationURL" type: typeType code: 'aprl'];
    return constantObj;
}

+ (SFConstant *)attachment {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (SFConstant *)attributeRun {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (SFConstant *)best {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"best" type: typeType code: 'best'];
    return constantObj;
}

+ (SFConstant *)boolean {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"boolean" type: typeType code: 'bool'];
    return constantObj;
}

+ (SFConstant *)boundingRectangle {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"boundingRectangle" type: typeType code: 'qdrt'];
    return constantObj;
}

+ (SFConstant *)bounds {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (SFConstant *)centimeters {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"centimeters" type: typeType code: 'cmtr'];
    return constantObj;
}

+ (SFConstant *)character {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (SFConstant *)classInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"classInfo" type: typeType code: 'gcli'];
    return constantObj;
}

+ (SFConstant *)class_ {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (SFConstant *)closeable {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (SFConstant *)collating {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (SFConstant *)color {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (SFConstant *)colorTable {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"colorTable" type: typeType code: 'clrt'];
    return constantObj;
}

+ (SFConstant *)copies {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (SFConstant *)cubicCentimeters {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"cubicCentimeters" type: typeType code: 'ccmt'];
    return constantObj;
}

+ (SFConstant *)cubicFeet {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"cubicFeet" type: typeType code: 'cfet'];
    return constantObj;
}

+ (SFConstant *)cubicInches {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"cubicInches" type: typeType code: 'cuin'];
    return constantObj;
}

+ (SFConstant *)cubicMeters {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"cubicMeters" type: typeType code: 'cmet'];
    return constantObj;
}

+ (SFConstant *)cubicYards {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"cubicYards" type: typeType code: 'cyrd'];
    return constantObj;
}

+ (SFConstant *)currentTab {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"currentTab" type: typeType code: 'cTab'];
    return constantObj;
}

+ (SFConstant *)dashStyle {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"dashStyle" type: typeType code: 'tdas'];
    return constantObj;
}

+ (SFConstant *)data {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"data" type: typeType code: 'rdat'];
    return constantObj;
}

+ (SFConstant *)date {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"date" type: typeType code: 'ldt '];
    return constantObj;
}

+ (SFConstant *)decimalStruct {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"decimalStruct" type: typeType code: 'decm'];
    return constantObj;
}

+ (SFConstant *)degreesCelsius {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"degreesCelsius" type: typeType code: 'degc'];
    return constantObj;
}

+ (SFConstant *)degreesFahrenheit {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"degreesFahrenheit" type: typeType code: 'degf'];
    return constantObj;
}

+ (SFConstant *)degreesKelvin {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"degreesKelvin" type: typeType code: 'degk'];
    return constantObj;
}

+ (SFConstant *)document {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (SFConstant *)doubleInteger {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"doubleInteger" type: typeType code: 'comp'];
    return constantObj;
}

+ (SFConstant *)elementInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"elementInfo" type: typeType code: 'elin'];
    return constantObj;
}

+ (SFConstant *)encodedString {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"encodedString" type: typeType code: 'encs'];
    return constantObj;
}

+ (SFConstant *)endingPage {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (SFConstant *)enumerator {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"enumerator" type: typeType code: 'enum'];
    return constantObj;
}

+ (SFConstant *)errorHandling {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (SFConstant *)eventInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"eventInfo" type: typeType code: 'evin'];
    return constantObj;
}

+ (SFConstant *)extendedFloat {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"extendedFloat" type: typeType code: 'exte'];
    return constantObj;
}

+ (SFConstant *)faxNumber {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (SFConstant *)feet {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"feet" type: typeType code: 'feet'];
    return constantObj;
}

+ (SFConstant *)fileName {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (SFConstant *)fileRef {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fileRef" type: typeType code: 'fsrf'];
    return constantObj;
}

+ (SFConstant *)fileSpecification {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fileSpecification" type: typeType code: 'fss '];
    return constantObj;
}

+ (SFConstant *)fileURL {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fileURL" type: typeType code: 'furl'];
    return constantObj;
}

+ (SFConstant *)fixed {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fixed" type: typeType code: 'fixd'];
    return constantObj;
}

+ (SFConstant *)fixedPoint {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fixedPoint" type: typeType code: 'fpnt'];
    return constantObj;
}

+ (SFConstant *)fixedRectangle {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fixedRectangle" type: typeType code: 'frct'];
    return constantObj;
}

+ (SFConstant *)float128bit {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"float128bit" type: typeType code: 'ldbl'];
    return constantObj;
}

+ (SFConstant *)float_ {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"float_" type: typeType code: 'doub'];
    return constantObj;
}

+ (SFConstant *)floating {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (SFConstant *)font {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (SFConstant *)frontmost {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (SFConstant *)gallons {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"gallons" type: typeType code: 'galn'];
    return constantObj;
}

+ (SFConstant *)grams {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"grams" type: typeType code: 'gram'];
    return constantObj;
}

+ (SFConstant *)graphicText {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"graphicText" type: typeType code: 'cgtx'];
    return constantObj;
}

+ (SFConstant *)id_ {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (SFConstant *)inches {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"inches" type: typeType code: 'inch'];
    return constantObj;
}

+ (SFConstant *)index {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (SFConstant *)integer {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"integer" type: typeType code: 'long'];
    return constantObj;
}

+ (SFConstant *)internationalText {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"internationalText" type: typeType code: 'itxt'];
    return constantObj;
}

+ (SFConstant *)internationalWritingCode {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"internationalWritingCode" type: typeType code: 'intl'];
    return constantObj;
}

+ (SFConstant *)item {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (SFConstant *)kernelProcessID {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"kernelProcessID" type: typeType code: 'kpid'];
    return constantObj;
}

+ (SFConstant *)kilograms {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"kilograms" type: typeType code: 'kgrm'];
    return constantObj;
}

+ (SFConstant *)kilometers {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"kilometers" type: typeType code: 'kmtr'];
    return constantObj;
}

+ (SFConstant *)list {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (SFConstant *)liters {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"liters" type: typeType code: 'litr'];
    return constantObj;
}

+ (SFConstant *)locationReference {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"locationReference" type: typeType code: 'insl'];
    return constantObj;
}

+ (SFConstant *)longFixed {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"longFixed" type: typeType code: 'lfxd'];
    return constantObj;
}

+ (SFConstant *)longFixedPoint {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"longFixedPoint" type: typeType code: 'lfpt'];
    return constantObj;
}

+ (SFConstant *)longFixedRectangle {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"longFixedRectangle" type: typeType code: 'lfrc'];
    return constantObj;
}

+ (SFConstant *)longPoint {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"longPoint" type: typeType code: 'lpnt'];
    return constantObj;
}

+ (SFConstant *)longRectangle {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"longRectangle" type: typeType code: 'lrct'];
    return constantObj;
}

+ (SFConstant *)machPort {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"machPort" type: typeType code: 'port'];
    return constantObj;
}

+ (SFConstant *)machine {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"machine" type: typeType code: 'mach'];
    return constantObj;
}

+ (SFConstant *)machineLocation {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"machineLocation" type: typeType code: 'mLoc'];
    return constantObj;
}

+ (SFConstant *)meters {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"meters" type: typeType code: 'metr'];
    return constantObj;
}

+ (SFConstant *)miles {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"miles" type: typeType code: 'mile'];
    return constantObj;
}

+ (SFConstant *)miniaturizable {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (SFConstant *)miniaturized {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (SFConstant *)missingValue {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"missingValue" type: typeType code: 'msng'];
    return constantObj;
}

+ (SFConstant *)modal {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (SFConstant *)modified {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (SFConstant *)name {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (SFConstant *)null {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"null" type: typeType code: 'null'];
    return constantObj;
}

+ (SFConstant *)ounces {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"ounces" type: typeType code: 'ozs '];
    return constantObj;
}

+ (SFConstant *)pagesAcross {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (SFConstant *)pagesDown {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (SFConstant *)paragraph {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (SFConstant *)parameterInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"parameterInfo" type: typeType code: 'pmin'];
    return constantObj;
}

+ (SFConstant *)path {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (SFConstant *)pixelMapRecord {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"pixelMapRecord" type: typeType code: 'tpmm'];
    return constantObj;
}

+ (SFConstant *)point {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"point" type: typeType code: 'QDpt'];
    return constantObj;
}

+ (SFConstant *)pounds {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"pounds" type: typeType code: 'lbs '];
    return constantObj;
}

+ (SFConstant *)printSettings {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (SFConstant *)processSerialNumber {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"processSerialNumber" type: typeType code: 'psn '];
    return constantObj;
}

+ (SFConstant *)properties {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (SFConstant *)property {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"property" type: typeType code: 'prop'];
    return constantObj;
}

+ (SFConstant *)propertyInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"propertyInfo" type: typeType code: 'pinf'];
    return constantObj;
}

+ (SFConstant *)quarts {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"quarts" type: typeType code: 'qrts'];
    return constantObj;
}

+ (SFConstant *)record {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"record" type: typeType code: 'reco'];
    return constantObj;
}

+ (SFConstant *)reference {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"reference" type: typeType code: 'obj '];
    return constantObj;
}

+ (SFConstant *)requestedPrintTime {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (SFConstant *)resizable {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (SFConstant *)rotation {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"rotation" type: typeType code: 'trot'];
    return constantObj;
}

+ (SFConstant *)script {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (SFConstant *)shortFloat {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"shortFloat" type: typeType code: 'sing'];
    return constantObj;
}

+ (SFConstant *)shortInteger {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"shortInteger" type: typeType code: 'shor'];
    return constantObj;
}

+ (SFConstant *)size {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (SFConstant *)source {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"source" type: typeType code: 'conT'];
    return constantObj;
}

+ (SFConstant *)squareFeet {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"squareFeet" type: typeType code: 'sqft'];
    return constantObj;
}

+ (SFConstant *)squareKilometers {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"squareKilometers" type: typeType code: 'sqkm'];
    return constantObj;
}

+ (SFConstant *)squareMeters {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"squareMeters" type: typeType code: 'sqrm'];
    return constantObj;
}

+ (SFConstant *)squareMiles {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"squareMiles" type: typeType code: 'sqmi'];
    return constantObj;
}

+ (SFConstant *)squareYards {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"squareYards" type: typeType code: 'sqyd'];
    return constantObj;
}

+ (SFConstant *)startingPage {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (SFConstant *)string {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"string" type: typeType code: 'TEXT'];
    return constantObj;
}

+ (SFConstant *)styledClipboardText {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"styledClipboardText" type: typeType code: 'styl'];
    return constantObj;
}

+ (SFConstant *)styledText {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"styledText" type: typeType code: 'STXT'];
    return constantObj;
}

+ (SFConstant *)suiteInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"suiteInfo" type: typeType code: 'suin'];
    return constantObj;
}

+ (SFConstant *)tab {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"tab" type: typeType code: 'bTab'];
    return constantObj;
}

+ (SFConstant *)targetPrinter {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (SFConstant *)text {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (SFConstant *)textStyleInfo {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"textStyleInfo" type: typeType code: 'tsty'];
    return constantObj;
}

+ (SFConstant *)titled {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (SFConstant *)typeClass {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"typeClass" type: typeType code: 'type'];
    return constantObj;
}

+ (SFConstant *)unicodeText {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"unicodeText" type: typeType code: 'utxt'];
    return constantObj;
}

+ (SFConstant *)unsignedInteger {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"unsignedInteger" type: typeType code: 'magn'];
    return constantObj;
}

+ (SFConstant *)utf16Text {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"utf16Text" type: typeType code: 'ut16'];
    return constantObj;
}

+ (SFConstant *)utf8Text {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"utf8Text" type: typeType code: 'utf8'];
    return constantObj;
}

+ (SFConstant *)version {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (SFConstant *)version_ {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (SFConstant *)visible {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (SFConstant *)window {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (SFConstant *)word {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (SFConstant *)writingCode {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"writingCode" type: typeType code: 'psct'];
    return constantObj;
}

+ (SFConstant *)yards {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"yards" type: typeType code: 'yard'];
    return constantObj;
}

+ (SFConstant *)zoomable {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (SFConstant *)zoomed {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end

