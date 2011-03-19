/*
 * ICReferenceRendererGlue.m
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import "ICReferenceRendererGlue.h"

@implementation ICReferenceRenderer
- (NSString *)propertyByCode:(OSType)code {
    switch (code) {
        case 'wrad': return @"alldayEvent";
        case 'pbnd': return @"bounds";
        case 'pcls': return @"class_";
        case 'hclb': return @"closeable";
        case 'lwcl': return @"collating";
        case 'colr': return @"color";
        case 'wrt1': return @"completionDate";
        case 'lwcp': return @"copies";
        case 'wr12': return @"description_";
        case 'wra1': return @"displayName";
        case 'docu': return @"document";
        case 'wrt3': return @"dueDate";
        case 'wra2': return @"email";
        case 'wr5s': return @"endDate";
        case 'lwlp': return @"endingPage";
        case 'lweh': return @"errorHandling";
        case 'wr2s': return @"excludedDates";
        case 'faxn': return @"faxNumber";
        case 'atfn': return @"fileName";
        case 'walp': return @"filepath";
        case 'isfl': return @"floating";
        case 'font': return @"font";
        case 'pisf': return @"frontmost";
        case 'pidx': return @"index";
        case 'wr14': return @"location";
        case 'ismn': return @"miniaturizable";
        case 'pmnd': return @"miniaturized";
        case 'pmod': return @"modal";
        case 'imod': return @"modified";
        case 'pnam': return @"name";
        case 'lwla': return @"pagesAcross";
        case 'lwld': return @"pagesDown";
        case 'wra3': return @"participationStatus";
        case 'ppth': return @"path";
        case 'wrt5': return @"priority";
        case 'pALL': return @"properties";
        case 'wr15': return @"recurrence";
        case 'lwqt': return @"requestedPrintTime";
        case 'prsz': return @"resizable";
        case 'wr13': return @"sequence";
        case 'ptsz': return @"size";
        case 'walf': return @"soundFile";
        case 'wals': return @"soundName";
        case 'wr4s': return @"stampDate";
        case 'wr1s': return @"startDate";
        case 'lwfp': return @"startingPage";
        case 'wre4': return @"status";
        case 'wr11': return @"summary";
        case 'trpr': return @"targetPrinter";
        case 'ptit': return @"titled";
        case 'wale': return @"triggerDate";
        case 'wald': return @"triggerInterval";
        case 'ID  ': return @"uid";
        case 'wr16': return @"url";
        case 'vers': return @"version_";
        case 'pvis': return @"visible";
        case 'wr05': return @"writable";
        case 'iszm': return @"zoomable";
        case 'pzum': return @"zoomed";
        default: return nil;
    }
}

- (NSString *)elementByCode:(OSType)code {
    switch (code) {
        case 'capp': return @"applications";
        case 'atts': return @"attachment";
        case 'wrea': return @"attendees";
        case 'catr': return @"attributeRuns";
        case 'wres': return @"calendars";
        case 'cha ': return @"characters";
        case 'colr': return @"colors";
        case 'wal1': return @"displayAlarms";
        case 'docu': return @"documents";
        case 'wrev': return @"events";
        case 'cobj': return @"items";
        case 'wal2': return @"mailAlarms";
        case 'wal3': return @"openFileAlarms";
        case 'cpar': return @"paragraphs";
        case 'pset': return @"printSettings";
        case 'wal4': return @"soundAlarms";
        case 'ctxt': return @"text";
        case 'wret': return @"todos";
        case 'cwin': return @"windows";
        case 'cwor': return @"words";
        default: return nil;
    }
}

- (NSString *)prefix {
    return @"IC";
}

@end

