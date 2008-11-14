/*
 * ICReferenceGlue.m
 * /Applications/iCal.app
 * osaglue 0.5.1
 *
 */

#import "ICReferenceGlue.h"

@implementation ICReference

/* +app, +con, +its methods can be used in place of ICApp, ICCon, ICIts macros */

+ (ICReference *)app {
    return [self referenceWithAppData: nil aemReference: AEMApp];
}

+ (ICReference *)con {
    return [self referenceWithAppData: nil aemReference: AEMCon];
}

+ (ICReference *)its {
    return [self referenceWithAppData: nil aemReference: AEMIts];
}


/* ********************************* */

- (NSString *)description {
    return [ICReferenceRenderer formatObject: AS_aemReference appData: AS_appData];
}


/* Commands */

- (ICGetURLCommand *)GetURL {
    return [ICGetURLCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICGetURLCommand *)GetURL:(id)directParameter {
    return [ICGetURLCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICActivateCommand *)activate {
    return [ICActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICActivateCommand *)activate:(id)directParameter {
    return [ICActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICCloseCommand *)close {
    return [ICCloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICCloseCommand *)close:(id)directParameter {
    return [ICCloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICCountCommand *)count {
    return [ICCountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICCountCommand *)count:(id)directParameter {
    return [ICCountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICCreateCalendarCommand *)createCalendar {
    return [ICCreateCalendarCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec2'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICCreateCalendarCommand *)createCalendar:(id)directParameter {
    return [ICCreateCalendarCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec2'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICDeleteCommand *)delete {
    return [ICDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICDeleteCommand *)delete:(id)directParameter {
    return [ICDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICDuplicateCommand *)duplicate {
    return [ICDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICDuplicateCommand *)duplicate:(id)directParameter {
    return [ICDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICExistsCommand *)exists {
    return [ICExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICExistsCommand *)exists:(id)directParameter {
    return [ICExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICGetCommand *)get {
    return [ICGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICGetCommand *)get:(id)directParameter {
    return [ICGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICLaunchCommand *)launch {
    return [ICLaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICLaunchCommand *)launch:(id)directParameter {
    return [ICLaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICMakeCommand *)make {
    return [ICMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICMakeCommand *)make:(id)directParameter {
    return [ICMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICMoveCommand *)move {
    return [ICMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICMoveCommand *)move:(id)directParameter {
    return [ICMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICOpenCommand *)open {
    return [ICOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICOpenCommand *)open:(id)directParameter {
    return [ICOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICOpenLocationCommand *)openLocation {
    return [ICOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICOpenLocationCommand *)openLocation:(id)directParameter {
    return [ICOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICPrintCommand *)print {
    return [ICPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICPrintCommand *)print:(id)directParameter {
    return [ICPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICQuitCommand *)quit {
    return [ICQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICQuitCommand *)quit:(id)directParameter {
    return [ICQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICReloadCalendarsCommand *)reloadCalendars {
    return [ICReloadCalendarsCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec8'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICReloadCalendarsCommand *)reloadCalendars:(id)directParameter {
    return [ICReloadCalendarsCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec8'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICReopenCommand *)reopen {
    return [ICReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICReopenCommand *)reopen:(id)directParameter {
    return [ICReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICRunCommand *)run {
    return [ICRunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICRunCommand *)run:(id)directParameter {
    return [ICRunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICSaveCommand *)save {
    return [ICSaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICSaveCommand *)save:(id)directParameter {
    return [ICSaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICSetCommand *)set {
    return [ICSetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICSetCommand *)set:(id)directParameter {
    return [ICSetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICShowCommand *)show {
    return [ICShowCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec3'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICShowCommand *)show:(id)directParameter {
    return [ICShowCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec3'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICSwitchViewCommand *)switchView {
    return [ICSwitchViewCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aeca'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICSwitchViewCommand *)switchView:(id)directParameter {
    return [ICSwitchViewCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aeca'
                    directParameter: directParameter
                    parentReference: self];
}

- (ICViewCalendarCommand *)viewCalendar {
    return [ICViewCalendarCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec9'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (ICViewCalendarCommand *)viewCalendar:(id)directParameter {
    return [ICViewCalendarCommand commandWithAppData: AS_appData
                         eventClass: 'wrbt'
                            eventID: 'aec9'
                    directParameter: directParameter
                    parentReference: self];
}


/* Elements */

- (ICReference *)applications {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'capp']];
}

- (ICReference *)attachment {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'atts']];
}

- (ICReference *)attendees {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wrea']];
}

- (ICReference *)attributeRuns {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'catr']];
}

- (ICReference *)calendars {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wres']];
}

- (ICReference *)characters {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cha ']];
}

- (ICReference *)colors {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colr']];
}

- (ICReference *)displayAlarms {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wal1']];
}

- (ICReference *)documents {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'docu']];
}

- (ICReference *)events {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wrev']];
}

- (ICReference *)items {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cobj']];
}

- (ICReference *)mailAlarms {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wal2']];
}

- (ICReference *)openFileAlarms {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wal3']];
}

- (ICReference *)paragraphs {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpar']];
}

- (ICReference *)printSettings {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pset']];
}

- (ICReference *)soundAlarms {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wal4']];
}

- (ICReference *)text {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ctxt']];
}

- (ICReference *)todos {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'wret']];
}

- (ICReference *)windows {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwin']];
}

- (ICReference *)words {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwor']];
}


/* Properties */

- (ICReference *)alldayEvent {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wrad']];
}

- (ICReference *)bounds {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pbnd']];
}

- (ICReference *)class_ {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcls']];
}

- (ICReference *)closeable {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hclb']];
}

- (ICReference *)collating {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcl']];
}

- (ICReference *)color {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'colr']];
}

- (ICReference *)completionDate {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wrt1']];
}

- (ICReference *)copies {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcp']];
}

- (ICReference *)description_ {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr12']];
}

- (ICReference *)displayName {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wra1']];
}

- (ICReference *)document {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docu']];
}

- (ICReference *)dueDate {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wrt3']];
}

- (ICReference *)email {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wra2']];
}

- (ICReference *)endDate {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr5s']];
}

- (ICReference *)endingPage {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwlp']];
}

- (ICReference *)errorHandling {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lweh']];
}

- (ICReference *)excludedDates {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr2s']];
}

- (ICReference *)faxNumber {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faxn']];
}

- (ICReference *)fileName {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atfn']];
}

- (ICReference *)filepath {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'walp']];
}

- (ICReference *)floating {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (ICReference *)font {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (ICReference *)frontmost {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pisf']];
}

- (ICReference *)id_ {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (ICReference *)index {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pidx']];
}

- (ICReference *)location {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr14']];
}

- (ICReference *)miniaturizable {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ismn']];
}

- (ICReference *)miniaturized {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmnd']];
}

- (ICReference *)modal {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmod']];
}

- (ICReference *)modified {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'imod']];
}

- (ICReference *)name {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pnam']];
}

- (ICReference *)pagesAcross {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwla']];
}

- (ICReference *)pagesDown {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwld']];
}

- (ICReference *)participationStatus {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wra3']];
}

- (ICReference *)path {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ppth']];
}

- (ICReference *)priority {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wrt5']];
}

- (ICReference *)properties {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pALL']];
}

- (ICReference *)recurrence {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr15']];
}

- (ICReference *)requestedPrintTime {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqt']];
}

- (ICReference *)resizable {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (ICReference *)sequence {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr13']];
}

- (ICReference *)size {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptsz']];
}

- (ICReference *)soundFile {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'walf']];
}

- (ICReference *)soundName {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wals']];
}

- (ICReference *)stampDate {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr4s']];
}

- (ICReference *)startDate {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr1s']];
}

- (ICReference *)startingPage {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwfp']];
}

- (ICReference *)status {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wre4']];
}

- (ICReference *)summary {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr11']];
}

- (ICReference *)targetPrinter {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trpr']];
}

- (ICReference *)titled {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptit']];
}

- (ICReference *)triggerDate {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wale']];
}

- (ICReference *)triggerInterval {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wald']];
}

- (ICReference *)uid {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (ICReference *)url {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr16']];
}

- (ICReference *)version_ {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vers']];
}

- (ICReference *)visible {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvis']];
}

- (ICReference *)writable {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'wr05']];
}

- (ICReference *)zoomable {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iszm']];
}

- (ICReference *)zoomed {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pzum']];
}


/* ********************************* */


/* ordinal selectors */

- (ICReference *)first {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (ICReference *)middle {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (ICReference *)last {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (ICReference *)any {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}


/* by-index, by-name, by-id selectors */

- (ICReference *)at:(long)index {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: index]];
}

- (ICReference *)byIndex:(id)index {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: index]];
}

- (ICReference *)byName:(id)name {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (ICReference *)byID:(id)id_ {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}


/* by-relative-position selectors */

- (ICReference *)previous:(ASConstant *)class_ {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ AS_code]]];
}

- (ICReference *)next:(ASConstant *)class_ {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ AS_code]]];
}


/* by-range selector */

- (ICReference *)at:(long)fromIndex to:(long)toIndex {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}

- (ICReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [ICReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [ICReference class]])
        toObject = [toObject AS_aemReference];
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}


/* by-test selector */

- (ICReference *)byTest:(ICReference *)testReference {
    return [ICReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}


/* insertion location selectors */

- (ICReference *)beginning {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginning]];
}

- (ICReference *)end {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}

- (ICReference *)before {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}

- (ICReference *)after {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}


/* Comparison and logic tests */

- (ICReference *)greaterThan:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterThan: object]];
}

- (ICReference *)greaterOrEquals:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterOrEquals: object]];
}

- (ICReference *)equals:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference equals: object]];
}

- (ICReference *)notEquals:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference notEquals: object]];
}

- (ICReference *)lessThan:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessThan: object]];
}

- (ICReference *)lessOrEquals:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessOrEquals: object]];
}

- (ICReference *)beginsWith:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginsWith: object]];
}

- (ICReference *)endsWith:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference endsWith: object]];
}

- (ICReference *)contains:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference contains: object]];
}

- (ICReference *)isIn:(id)object {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference isIn: object]];
}

- (ICReference *)AND:(id)remainingOperands {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference AND: remainingOperands]];
}

- (ICReference *)OR:(id)remainingOperands {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference OR: remainingOperands]];
}

- (ICReference *)NOT {
    return [ICReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference NOT]];
}

@end

