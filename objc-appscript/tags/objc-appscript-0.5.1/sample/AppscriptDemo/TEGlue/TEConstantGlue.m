/*
 * TEConstantGlue.m
 * /Applications/TextEdit.app
 * osaglue 0.5.1
 *
 */

#import "TEConstantGlue.h"

@implementation TEConstant
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

+ (TEConstant *)applicationResponses {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"applicationResponses" type: typeEnumerated code: 'rmte'];
    return constantObj;
}

+ (TEConstant *)ask {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (TEConstant *)case_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"case_" type: typeEnumerated code: 'case'];
    return constantObj;
}

+ (TEConstant *)detailed {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (TEConstant *)diacriticals {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"diacriticals" type: typeEnumerated code: 'diac'];
    return constantObj;
}

+ (TEConstant *)expansion {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"expansion" type: typeEnumerated code: 'expa'];
    return constantObj;
}

+ (TEConstant *)hyphens {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"hyphens" type: typeEnumerated code: 'hyph'];
    return constantObj;
}

+ (TEConstant *)no {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (TEConstant *)numericStrings {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"numericStrings" type: typeEnumerated code: 'nume'];
    return constantObj;
}

+ (TEConstant *)punctuation {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"punctuation" type: typeEnumerated code: 'punc'];
    return constantObj;
}

+ (TEConstant *)standard {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (TEConstant *)whitespace {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"whitespace" type: typeEnumerated code: 'whit'];
    return constantObj;
}

+ (TEConstant *)yes {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (TEConstant *)April {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"April" type: typeType code: 'apr '];
    return constantObj;
}

+ (TEConstant *)August {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"August" type: typeType code: 'aug '];
    return constantObj;
}

+ (TEConstant *)December {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"December" type: typeType code: 'dec '];
    return constantObj;
}

+ (TEConstant *)EPSPicture {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"EPSPicture" type: typeType code: 'EPS '];
    return constantObj;
}

+ (TEConstant *)February {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"February" type: typeType code: 'feb '];
    return constantObj;
}

+ (TEConstant *)Friday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Friday" type: typeType code: 'fri '];
    return constantObj;
}

+ (TEConstant *)GIFPicture {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"GIFPicture" type: typeType code: 'GIFf'];
    return constantObj;
}

+ (TEConstant *)JPEGPicture {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"JPEGPicture" type: typeType code: 'JPEG'];
    return constantObj;
}

+ (TEConstant *)January {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"January" type: typeType code: 'jan '];
    return constantObj;
}

+ (TEConstant *)July {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"July" type: typeType code: 'jul '];
    return constantObj;
}

+ (TEConstant *)June {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"June" type: typeType code: 'jun '];
    return constantObj;
}

+ (TEConstant *)March {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"March" type: typeType code: 'mar '];
    return constantObj;
}

+ (TEConstant *)May {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"May" type: typeType code: 'may '];
    return constantObj;
}

+ (TEConstant *)Monday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Monday" type: typeType code: 'mon '];
    return constantObj;
}

+ (TEConstant *)November {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"November" type: typeType code: 'nov '];
    return constantObj;
}

+ (TEConstant *)October {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"October" type: typeType code: 'oct '];
    return constantObj;
}

+ (TEConstant *)PICTPicture {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"PICTPicture" type: typeType code: 'PICT'];
    return constantObj;
}

+ (TEConstant *)RGB16Color {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"RGB16Color" type: typeType code: 'tr16'];
    return constantObj;
}

+ (TEConstant *)RGB96Color {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"RGB96Color" type: typeType code: 'tr96'];
    return constantObj;
}

+ (TEConstant *)RGBColor {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"RGBColor" type: typeType code: 'cRGB'];
    return constantObj;
}

+ (TEConstant *)Saturday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Saturday" type: typeType code: 'sat '];
    return constantObj;
}

+ (TEConstant *)September {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"September" type: typeType code: 'sep '];
    return constantObj;
}

+ (TEConstant *)Sunday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Sunday" type: typeType code: 'sun '];
    return constantObj;
}

+ (TEConstant *)TIFFPicture {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"TIFFPicture" type: typeType code: 'TIFF'];
    return constantObj;
}

+ (TEConstant *)Thursday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Thursday" type: typeType code: 'thu '];
    return constantObj;
}

+ (TEConstant *)Tuesday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Tuesday" type: typeType code: 'tue '];
    return constantObj;
}

+ (TEConstant *)Wednesday {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"Wednesday" type: typeType code: 'wed '];
    return constantObj;
}

+ (TEConstant *)alias {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (TEConstant *)anything {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"anything" type: typeType code: '****'];
    return constantObj;
}

+ (TEConstant *)application {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (TEConstant *)applicationBundleID {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"applicationBundleID" type: typeType code: 'bund'];
    return constantObj;
}

+ (TEConstant *)applicationSignature {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"applicationSignature" type: typeType code: 'sign'];
    return constantObj;
}

+ (TEConstant *)applicationURL {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"applicationURL" type: typeType code: 'aprl'];
    return constantObj;
}

+ (TEConstant *)attachment {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (TEConstant *)attributeRun {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"attributeRun" type: typeType code: 'catr'];
    return constantObj;
}

+ (TEConstant *)best {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"best" type: typeType code: 'best'];
    return constantObj;
}

+ (TEConstant *)boolean {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"boolean" type: typeType code: 'bool'];
    return constantObj;
}

+ (TEConstant *)boundingRectangle {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"boundingRectangle" type: typeType code: 'qdrt'];
    return constantObj;
}

+ (TEConstant *)bounds {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (TEConstant *)centimeters {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"centimeters" type: typeType code: 'cmtr'];
    return constantObj;
}

+ (TEConstant *)character {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (TEConstant *)classInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"classInfo" type: typeType code: 'gcli'];
    return constantObj;
}

+ (TEConstant *)class_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (TEConstant *)closeable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (TEConstant *)collating {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (TEConstant *)color {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (TEConstant *)colorTable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"colorTable" type: typeType code: 'clrt'];
    return constantObj;
}

+ (TEConstant *)copies {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (TEConstant *)cubicCentimeters {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"cubicCentimeters" type: typeType code: 'ccmt'];
    return constantObj;
}

+ (TEConstant *)cubicFeet {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"cubicFeet" type: typeType code: 'cfet'];
    return constantObj;
}

+ (TEConstant *)cubicInches {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"cubicInches" type: typeType code: 'cuin'];
    return constantObj;
}

+ (TEConstant *)cubicMeters {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"cubicMeters" type: typeType code: 'cmet'];
    return constantObj;
}

+ (TEConstant *)cubicYards {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"cubicYards" type: typeType code: 'cyrd'];
    return constantObj;
}

+ (TEConstant *)dashStyle {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"dashStyle" type: typeType code: 'tdas'];
    return constantObj;
}

+ (TEConstant *)data {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"data" type: typeType code: 'rdat'];
    return constantObj;
}

+ (TEConstant *)date {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"date" type: typeType code: 'ldt '];
    return constantObj;
}

+ (TEConstant *)decimalStruct {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"decimalStruct" type: typeType code: 'decm'];
    return constantObj;
}

+ (TEConstant *)degreesCelsius {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"degreesCelsius" type: typeType code: 'degc'];
    return constantObj;
}

+ (TEConstant *)degreesFahrenheit {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"degreesFahrenheit" type: typeType code: 'degf'];
    return constantObj;
}

+ (TEConstant *)degreesKelvin {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"degreesKelvin" type: typeType code: 'degk'];
    return constantObj;
}

+ (TEConstant *)document {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (TEConstant *)doubleInteger {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"doubleInteger" type: typeType code: 'comp'];
    return constantObj;
}

+ (TEConstant *)elementInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"elementInfo" type: typeType code: 'elin'];
    return constantObj;
}

+ (TEConstant *)encodedString {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"encodedString" type: typeType code: 'encs'];
    return constantObj;
}

+ (TEConstant *)endingPage {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (TEConstant *)enumerator {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"enumerator" type: typeType code: 'enum'];
    return constantObj;
}

+ (TEConstant *)errorHandling {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (TEConstant *)eventInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"eventInfo" type: typeType code: 'evin'];
    return constantObj;
}

+ (TEConstant *)extendedFloat {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"extendedFloat" type: typeType code: 'exte'];
    return constantObj;
}

+ (TEConstant *)faxNumber {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (TEConstant *)feet {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"feet" type: typeType code: 'feet'];
    return constantObj;
}

+ (TEConstant *)fileName {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
    return constantObj;
}

+ (TEConstant *)fileRef {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fileRef" type: typeType code: 'fsrf'];
    return constantObj;
}

+ (TEConstant *)fileSpecification {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fileSpecification" type: typeType code: 'fss '];
    return constantObj;
}

+ (TEConstant *)fileURL {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fileURL" type: typeType code: 'furl'];
    return constantObj;
}

+ (TEConstant *)fixed {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fixed" type: typeType code: 'fixd'];
    return constantObj;
}

+ (TEConstant *)fixedPoint {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fixedPoint" type: typeType code: 'fpnt'];
    return constantObj;
}

+ (TEConstant *)fixedRectangle {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"fixedRectangle" type: typeType code: 'frct'];
    return constantObj;
}

+ (TEConstant *)float128bit {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"float128bit" type: typeType code: 'ldbl'];
    return constantObj;
}

+ (TEConstant *)float_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"float_" type: typeType code: 'doub'];
    return constantObj;
}

+ (TEConstant *)floating {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (TEConstant *)font {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (TEConstant *)frontmost {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (TEConstant *)gallons {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"gallons" type: typeType code: 'galn'];
    return constantObj;
}

+ (TEConstant *)grams {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"grams" type: typeType code: 'gram'];
    return constantObj;
}

+ (TEConstant *)graphicText {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"graphicText" type: typeType code: 'cgtx'];
    return constantObj;
}

+ (TEConstant *)id_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (TEConstant *)inches {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"inches" type: typeType code: 'inch'];
    return constantObj;
}

+ (TEConstant *)index {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (TEConstant *)integer {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"integer" type: typeType code: 'long'];
    return constantObj;
}

+ (TEConstant *)internationalText {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"internationalText" type: typeType code: 'itxt'];
    return constantObj;
}

+ (TEConstant *)internationalWritingCode {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"internationalWritingCode" type: typeType code: 'intl'];
    return constantObj;
}

+ (TEConstant *)item {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (TEConstant *)kernelProcessID {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"kernelProcessID" type: typeType code: 'kpid'];
    return constantObj;
}

+ (TEConstant *)kilograms {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"kilograms" type: typeType code: 'kgrm'];
    return constantObj;
}

+ (TEConstant *)kilometers {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"kilometers" type: typeType code: 'kmtr'];
    return constantObj;
}

+ (TEConstant *)list {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (TEConstant *)liters {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"liters" type: typeType code: 'litr'];
    return constantObj;
}

+ (TEConstant *)locationReference {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"locationReference" type: typeType code: 'insl'];
    return constantObj;
}

+ (TEConstant *)longFixed {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"longFixed" type: typeType code: 'lfxd'];
    return constantObj;
}

+ (TEConstant *)longFixedPoint {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"longFixedPoint" type: typeType code: 'lfpt'];
    return constantObj;
}

+ (TEConstant *)longFixedRectangle {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"longFixedRectangle" type: typeType code: 'lfrc'];
    return constantObj;
}

+ (TEConstant *)longPoint {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"longPoint" type: typeType code: 'lpnt'];
    return constantObj;
}

+ (TEConstant *)longRectangle {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"longRectangle" type: typeType code: 'lrct'];
    return constantObj;
}

+ (TEConstant *)machPort {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"machPort" type: typeType code: 'port'];
    return constantObj;
}

+ (TEConstant *)machine {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"machine" type: typeType code: 'mach'];
    return constantObj;
}

+ (TEConstant *)machineLocation {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"machineLocation" type: typeType code: 'mLoc'];
    return constantObj;
}

+ (TEConstant *)meters {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"meters" type: typeType code: 'metr'];
    return constantObj;
}

+ (TEConstant *)miles {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"miles" type: typeType code: 'mile'];
    return constantObj;
}

+ (TEConstant *)miniaturizable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (TEConstant *)miniaturized {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (TEConstant *)missingValue {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"missingValue" type: typeType code: 'msng'];
    return constantObj;
}

+ (TEConstant *)modal {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (TEConstant *)modified {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (TEConstant *)name {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (TEConstant *)null {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"null" type: typeType code: 'null'];
    return constantObj;
}

+ (TEConstant *)ounces {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"ounces" type: typeType code: 'ozs '];
    return constantObj;
}

+ (TEConstant *)pagesAcross {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"pagesAcross" type: typeType code: 'lwla'];
    return constantObj;
}

+ (TEConstant *)pagesDown {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"pagesDown" type: typeType code: 'lwld'];
    return constantObj;
}

+ (TEConstant *)paragraph {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (TEConstant *)parameterInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"parameterInfo" type: typeType code: 'pmin'];
    return constantObj;
}

+ (TEConstant *)path {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (TEConstant *)pixelMapRecord {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"pixelMapRecord" type: typeType code: 'tpmm'];
    return constantObj;
}

+ (TEConstant *)point {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"point" type: typeType code: 'QDpt'];
    return constantObj;
}

+ (TEConstant *)pounds {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"pounds" type: typeType code: 'lbs '];
    return constantObj;
}

+ (TEConstant *)printSettings {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (TEConstant *)processSerialNumber {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"processSerialNumber" type: typeType code: 'psn '];
    return constantObj;
}

+ (TEConstant *)properties {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (TEConstant *)property {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"property" type: typeType code: 'prop'];
    return constantObj;
}

+ (TEConstant *)propertyInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"propertyInfo" type: typeType code: 'pinf'];
    return constantObj;
}

+ (TEConstant *)quarts {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"quarts" type: typeType code: 'qrts'];
    return constantObj;
}

+ (TEConstant *)record {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"record" type: typeType code: 'reco'];
    return constantObj;
}

+ (TEConstant *)reference {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"reference" type: typeType code: 'obj '];
    return constantObj;
}

+ (TEConstant *)requestedPrintTime {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"requestedPrintTime" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (TEConstant *)resizable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (TEConstant *)rotation {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"rotation" type: typeType code: 'trot'];
    return constantObj;
}

+ (TEConstant *)script {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (TEConstant *)shortFloat {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"shortFloat" type: typeType code: 'sing'];
    return constantObj;
}

+ (TEConstant *)shortInteger {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"shortInteger" type: typeType code: 'shor'];
    return constantObj;
}

+ (TEConstant *)size {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (TEConstant *)squareFeet {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"squareFeet" type: typeType code: 'sqft'];
    return constantObj;
}

+ (TEConstant *)squareKilometers {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"squareKilometers" type: typeType code: 'sqkm'];
    return constantObj;
}

+ (TEConstant *)squareMeters {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"squareMeters" type: typeType code: 'sqrm'];
    return constantObj;
}

+ (TEConstant *)squareMiles {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"squareMiles" type: typeType code: 'sqmi'];
    return constantObj;
}

+ (TEConstant *)squareYards {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"squareYards" type: typeType code: 'sqyd'];
    return constantObj;
}

+ (TEConstant *)startingPage {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (TEConstant *)string {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"string" type: typeType code: 'TEXT'];
    return constantObj;
}

+ (TEConstant *)styledClipboardText {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"styledClipboardText" type: typeType code: 'styl'];
    return constantObj;
}

+ (TEConstant *)styledText {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"styledText" type: typeType code: 'STXT'];
    return constantObj;
}

+ (TEConstant *)suiteInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"suiteInfo" type: typeType code: 'suin'];
    return constantObj;
}

+ (TEConstant *)targetPrinter {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"targetPrinter" type: typeType code: 'trpr'];
    return constantObj;
}

+ (TEConstant *)text {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (TEConstant *)textStyleInfo {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"textStyleInfo" type: typeType code: 'tsty'];
    return constantObj;
}

+ (TEConstant *)titled {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (TEConstant *)typeClass {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"typeClass" type: typeType code: 'type'];
    return constantObj;
}

+ (TEConstant *)unicodeText {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"unicodeText" type: typeType code: 'utxt'];
    return constantObj;
}

+ (TEConstant *)unsignedInteger {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"unsignedInteger" type: typeType code: 'magn'];
    return constantObj;
}

+ (TEConstant *)utf16Text {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"utf16Text" type: typeType code: 'ut16'];
    return constantObj;
}

+ (TEConstant *)utf8Text {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"utf8Text" type: typeType code: 'utf8'];
    return constantObj;
}

+ (TEConstant *)version {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (TEConstant *)version_ {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"version_" type: typeType code: 'vers'];
    return constantObj;
}

+ (TEConstant *)visible {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (TEConstant *)window {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (TEConstant *)word {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (TEConstant *)writingCode {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"writingCode" type: typeType code: 'psct'];
    return constantObj;
}

+ (TEConstant *)yards {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"yards" type: typeType code: 'yard'];
    return constantObj;
}

+ (TEConstant *)zoomable {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (TEConstant *)zoomed {
    static TEConstant *constantObj;
    if (!constantObj)
        constantObj = [TEConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end

