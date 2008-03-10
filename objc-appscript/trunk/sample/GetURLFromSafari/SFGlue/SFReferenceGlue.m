/*
 * SFReferenceGlue.m
 *
 * /Applications/Safari.app
 * osaglue 0.3.2
 *
 */

#import "SFReferenceGlue.h"

@implementation SFReference

- (NSString *)description {
	return [SFReferenceRenderer render: AS_aemReference];
}

/* Commands */

- (SFActivateCommand *)activate {
    return [SFActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: nil
                    parentReference: self];
}

- (SFActivateCommand *)activate:(id)directParameter {
    return [SFActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFCloseCommand *)close {
    return [SFCloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: nil
                    parentReference: self];
}

- (SFCloseCommand *)close:(id)directParameter {
    return [SFCloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFCountCommand *)count {
    return [SFCountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: nil
                    parentReference: self];
}

- (SFCountCommand *)count:(id)directParameter {
    return [SFCountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFDeleteCommand *)delete {
    return [SFDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: nil
                    parentReference: self];
}

- (SFDeleteCommand *)delete:(id)directParameter {
    return [SFDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFDoJavaScriptCommand *)doJavaScript {
    return [SFDoJavaScriptCommand commandWithAppData: AS_appData
                         eventClass: 'sfri'
                            eventID: 'dojs'
                    directParameter: nil
                    parentReference: self];
}

- (SFDoJavaScriptCommand *)doJavaScript:(id)directParameter {
    return [SFDoJavaScriptCommand commandWithAppData: AS_appData
                         eventClass: 'sfri'
                            eventID: 'dojs'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFDuplicateCommand *)duplicate {
    return [SFDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: nil
                    parentReference: self];
}

- (SFDuplicateCommand *)duplicate:(id)directParameter {
    return [SFDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFEmailContentsCommand *)emailContents {
    return [SFEmailContentsCommand commandWithAppData: AS_appData
                         eventClass: 'sfri'
                            eventID: 'mlct'
                    directParameter: nil
                    parentReference: self];
}

- (SFEmailContentsCommand *)emailContents:(id)directParameter {
    return [SFEmailContentsCommand commandWithAppData: AS_appData
                         eventClass: 'sfri'
                            eventID: 'mlct'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFExistsCommand *)exists {
    return [SFExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: nil
                    parentReference: self];
}

- (SFExistsCommand *)exists:(id)directParameter {
    return [SFExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFGetCommand *)get {
    return [SFGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: nil
                    parentReference: self];
}

- (SFGetCommand *)get:(id)directParameter {
    return [SFGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFLaunchCommand *)launch {
    return [SFLaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: nil
                    parentReference: self];
}

- (SFLaunchCommand *)launch:(id)directParameter {
    return [SFLaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFMakeCommand *)make {
    return [SFMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: nil
                    parentReference: self];
}

- (SFMakeCommand *)make:(id)directParameter {
    return [SFMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFMoveCommand *)move {
    return [SFMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: nil
                    parentReference: self];
}

- (SFMoveCommand *)move:(id)directParameter {
    return [SFMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFOpenCommand *)open {
    return [SFOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: nil
                    parentReference: self];
}

- (SFOpenCommand *)open:(id)directParameter {
    return [SFOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFOpenLocationCommand *)openLocation {
    return [SFOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: nil
                    parentReference: self];
}

- (SFOpenLocationCommand *)openLocation:(id)directParameter {
    return [SFOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFPrintCommand *)print {
    return [SFPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: nil
                    parentReference: self];
}

- (SFPrintCommand *)print:(id)directParameter {
    return [SFPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFQuitCommand *)quit {
    return [SFQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: nil
                    parentReference: self];
}

- (SFQuitCommand *)quit:(id)directParameter {
    return [SFQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFReopenCommand *)reopen {
    return [SFReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: nil
                    parentReference: self];
}

- (SFReopenCommand *)reopen:(id)directParameter {
    return [SFReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFRunCommand *)run {
    return [SFRunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: nil
                    parentReference: self];
}

- (SFRunCommand *)run:(id)directParameter {
    return [SFRunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFSaveCommand *)save {
    return [SFSaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: nil
                    parentReference: self];
}

- (SFSaveCommand *)save:(id)directParameter {
    return [SFSaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFSetCommand *)set {
    return [SFSetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: nil
                    parentReference: self];
}

- (SFSetCommand *)set:(id)directParameter {
    return [SFSetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: directParameter
                    parentReference: self];
}

- (SFShowBookmarksCommand *)showBookmarks {
    return [SFShowBookmarksCommand commandWithAppData: AS_appData
                         eventClass: 'sfri'
                            eventID: 'opbk'
                    directParameter: nil
                    parentReference: self];
}

- (SFShowBookmarksCommand *)showBookmarks:(id)directParameter {
    return [SFShowBookmarksCommand commandWithAppData: AS_appData
                         eventClass: 'sfri'
                            eventID: 'opbk'
                    directParameter: directParameter
                    parentReference: self];
}


/* Elements */

- (SFReference *)applications {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'capp']];
}

- (SFReference *)attachment {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'atts']];
}

- (SFReference *)attributeRuns {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'catr']];
}

- (SFReference *)characters {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cha ']];
}

- (SFReference *)colors {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colr']];
}

- (SFReference *)documents {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'docu']];
}

- (SFReference *)items {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cobj']];
}

- (SFReference *)paragraphs {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpar']];
}

- (SFReference *)printSettings {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pset']];
}

- (SFReference *)tabs {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'bTab']];
}

- (SFReference *)text {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ctxt']];
}

- (SFReference *)windows {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwin']];
}

- (SFReference *)words {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwor']];
}


/* Properties */

- (SFReference *)URL {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pURL']];
}

- (SFReference *)bounds {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pbnd']];
}

- (SFReference *)class_ {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcls']];
}

- (SFReference *)closeable {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hclb']];
}

- (SFReference *)collating {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcl']];
}

- (SFReference *)color {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'colr']];
}

- (SFReference *)copies {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcp']];
}

- (SFReference *)currentTab {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cTab']];
}

- (SFReference *)document {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docu']];
}

- (SFReference *)endingPage {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwlp']];
}

- (SFReference *)errorHandling {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lweh']];
}

- (SFReference *)faxNumber {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faxn']];
}

- (SFReference *)fileName {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atfn']];
}

- (SFReference *)floating {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (SFReference *)font {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (SFReference *)frontmost {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pisf']];
}

- (SFReference *)id_ {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (SFReference *)index {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pidx']];
}

- (SFReference *)miniaturizable {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ismn']];
}

- (SFReference *)miniaturized {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmnd']];
}

- (SFReference *)modal {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmod']];
}

- (SFReference *)modified {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'imod']];
}

- (SFReference *)name {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pnam']];
}

- (SFReference *)pagesAcross {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwla']];
}

- (SFReference *)pagesDown {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwld']];
}

- (SFReference *)path {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ppth']];
}

- (SFReference *)properties {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pALL']];
}

- (SFReference *)requestedPrintTime {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqt']];
}

- (SFReference *)resizable {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (SFReference *)size {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptsz']];
}

- (SFReference *)source {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'conT']];
}

- (SFReference *)startingPage {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwfp']];
}

- (SFReference *)targetPrinter {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trpr']];
}

- (SFReference *)titled {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptit']];
}

- (SFReference *)version_ {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vers']];
}

- (SFReference *)visible {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvis']];
}

- (SFReference *)zoomable {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iszm']];
}

- (SFReference *)zoomed {
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pzum']];
}


/***********************************/

// ordinal selectors

- (SFReference *)first {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (SFReference *)middle {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (SFReference *)last {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (SFReference *)any {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}

// by-index, by-name, by-id selectors
 
- (SFReference *)at:(long)index {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: index]];
}

- (SFReference *)byIndex:(id)index { // index is normally NSNumber, but may occasionally be other types
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: index]];
}

- (SFReference *)byName:(NSString *)name {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (SFReference *)byID:(id)id_ {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}

// by-relative-position selectors

- (SFReference *)previous:(ASConstant *)class_ {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ AS_code]]];
}

- (SFReference *)next:(ASConstant *)class_ {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ AS_code]]];
}

// by-range selector

- (SFReference *)at:(long)fromIndex to:(long)toIndex {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}

- (SFReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [SFReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [SFReference class]])
        toObject = [toObject AS_aemReference];
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}

// by-test selector

- (SFReference *)byTest:(SFReference *)testReference {
    // note: getting AS_aemReference won't work for ASDynamicReference
    return [SFReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}

// insertion location selectors

- (SFReference *)beginning {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginning]];
}

- (SFReference *)end {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}

- (SFReference *)before {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}

- (SFReference *)after {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}

// Comparison and logic tests

- (SFReference *)greaterThan:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterThan: object]];
}

- (SFReference *)greaterOrEquals:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterOrEquals: object]];
}

- (SFReference *)equals:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference equals: object]];
}

- (SFReference *)notEquals:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference notEquals: object]];
}

- (SFReference *)lessThan:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessThan: object]];
}

- (SFReference *)lessOrEquals:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessOrEquals: object]];
}

- (SFReference *)beginsWith:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginsWith: object]];
}

- (SFReference *)endsWith:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference endsWith: object]];
}

- (SFReference *)contains:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference contains: object]];
}

- (SFReference *)isIn:(id)object {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference isIn: object]];
}

- (SFReference *)AND:(id)remainingOperands {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference AND: remainingOperands]];
}

- (SFReference *)OR:(id)remainingOperands {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference OR: remainingOperands]];
}

- (SFReference *)NOT {
    return [SFReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference NOT]];
}

@end


