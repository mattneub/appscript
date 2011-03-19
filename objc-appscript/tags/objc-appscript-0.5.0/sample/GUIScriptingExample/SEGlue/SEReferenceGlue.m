/*
 * SEReferenceGlue.m
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.5.1
 *
 */

#import "SEReferenceGlue.h"

@implementation SEReference

/* +app, +con, +its methods can be used in place of SEApp, SECon, SEIts macros */

+ (SEReference *)app {
    return [self referenceWithAppData: nil aemReference: AEMApp];
}

+ (SEReference *)con {
    return [self referenceWithAppData: nil aemReference: AEMCon];
}

+ (SEReference *)its {
    return [self referenceWithAppData: nil aemReference: AEMIts];
}


/* ********************************* */

- (NSString *)description {
    return [SEReferenceRenderer formatObject: AS_aemReference appData: AS_appData];
}


/* Commands */

- (SEAbortTransaction_Command *)abortTransaction_ {
    return [SEAbortTransaction_Command commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'ttrm'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEAbortTransaction_Command *)abortTransaction_:(id)directParameter {
    return [SEAbortTransaction_Command commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'ttrm'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEActivateCommand *)activate {
    return [SEActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEActivateCommand *)activate:(id)directParameter {
    return [SEActivateCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'actv'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEAttachActionToCommand *)attachActionTo {
    return [SEAttachActionToCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'atfa'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEAttachActionToCommand *)attachActionTo:(id)directParameter {
    return [SEAttachActionToCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'atfa'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEAttachedScriptsCommand *)attachedScripts {
    return [SEAttachedScriptsCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'lact'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEAttachedScriptsCommand *)attachedScripts:(id)directParameter {
    return [SEAttachedScriptsCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'lact'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEBeginTransaction_Command *)beginTransaction_ {
    return [SEBeginTransaction_Command commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'begi'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEBeginTransaction_Command *)beginTransaction_:(id)directParameter {
    return [SEBeginTransaction_Command commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'begi'
                    directParameter: directParameter
                    parentReference: self];
}

- (SECancelCommand *)cancel {
    return [SECancelCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cncl'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SECancelCommand *)cancel:(id)directParameter {
    return [SECancelCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cncl'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEClickCommand *)click {
    return [SEClickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'clic'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEClickCommand *)click:(id)directParameter {
    return [SEClickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'clic'
                    directParameter: directParameter
                    parentReference: self];
}

- (SECloseCommand *)close {
    return [SECloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SECloseCommand *)close:(id)directParameter {
    return [SECloseCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clos'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEConfirmCommand *)confirm {
    return [SEConfirmCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cnfm'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEConfirmCommand *)confirm:(id)directParameter {
    return [SEConfirmCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'cnfm'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEConnectCommand *)connect {
    return [SEConnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'conn'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEConnectCommand *)connect:(id)directParameter {
    return [SEConnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'conn'
                    directParameter: directParameter
                    parentReference: self];
}

- (SECountCommand *)count {
    return [SECountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SECountCommand *)count:(id)directParameter {
    return [SECountCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'cnte'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDecrementCommand *)decrement {
    return [SEDecrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'decr'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEDecrementCommand *)decrement:(id)directParameter {
    return [SEDecrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'decr'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDeleteCommand *)delete {
    return [SEDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEDeleteCommand *)delete:(id)directParameter {
    return [SEDeleteCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'delo'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDisconnectCommand *)disconnect {
    return [SEDisconnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'dcon'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEDisconnectCommand *)disconnect:(id)directParameter {
    return [SEDisconnectCommand commandWithAppData: AS_appData
                         eventClass: 'netz'
                            eventID: 'dcon'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDoFolderActionCommand *)doFolderAction {
    return [SEDoFolderActionCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'fola'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEDoFolderActionCommand *)doFolderAction:(id)directParameter {
    return [SEDoFolderActionCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'fola'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDoScriptCommand *)doScript {
    return [SEDoScriptCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'dosc'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEDoScriptCommand *)doScript:(id)directParameter {
    return [SEDoScriptCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'dosc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEDuplicateCommand *)duplicate {
    return [SEDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEDuplicateCommand *)duplicate:(id)directParameter {
    return [SEDuplicateCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'clon'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEEditActionOfCommand *)editActionOf {
    return [SEEditActionOfCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'edfa'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEEditActionOfCommand *)editActionOf:(id)directParameter {
    return [SEEditActionOfCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'edfa'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEEndTransaction_Command *)endTransaction_ {
    return [SEEndTransaction_Command commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'endt'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEEndTransaction_Command *)endTransaction_:(id)directParameter {
    return [SEEndTransaction_Command commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'endt'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEExistsCommand *)exists {
    return [SEExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEExistsCommand *)exists:(id)directParameter {
    return [SEExistsCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'doex'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEGetCommand *)get {
    return [SEGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEGetCommand *)get:(id)directParameter {
    return [SEGetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'getd'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEIncrementCommand *)increment {
    return [SEIncrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'incE'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEIncrementCommand *)increment:(id)directParameter {
    return [SEIncrementCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'incE'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKeyCodeCommand *)keyCode {
    return [SEKeyCodeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kcod'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEKeyCodeCommand *)keyCode:(id)directParameter {
    return [SEKeyCodeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kcod'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKeyDownCommand *)keyDown {
    return [SEKeyDownCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyF'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEKeyDownCommand *)keyDown:(id)directParameter {
    return [SEKeyDownCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyF'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKeyUpCommand *)keyUp {
    return [SEKeyUpCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyU'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEKeyUpCommand *)keyUp:(id)directParameter {
    return [SEKeyUpCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'keyU'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEKeystrokeCommand *)keystroke {
    return [SEKeystrokeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kprs'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEKeystrokeCommand *)keystroke:(id)directParameter {
    return [SEKeystrokeCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'kprs'
                    directParameter: directParameter
                    parentReference: self];
}

- (SELaunchCommand *)launch {
    return [SELaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SELaunchCommand *)launch:(id)directParameter {
    return [SELaunchCommand commandWithAppData: AS_appData
                         eventClass: 'ascr'
                            eventID: 'noop'
                    directParameter: directParameter
                    parentReference: self];
}

- (SELogOutCommand *)logOut {
    return [SELogOutCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'logo'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SELogOutCommand *)logOut:(id)directParameter {
    return [SELogOutCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'logo'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEMakeCommand *)make {
    return [SEMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEMakeCommand *)make:(id)directParameter {
    return [SEMakeCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'crel'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEMoveCommand *)move {
    return [SEMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEMoveCommand *)move:(id)directParameter {
    return [SEMoveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'move'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEOpenCommand *)open {
    return [SEOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEOpenCommand *)open:(id)directParameter {
    return [SEOpenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'odoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEOpenLocationCommand *)openLocation {
    return [SEOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEOpenLocationCommand *)openLocation:(id)directParameter {
    return [SEOpenLocationCommand commandWithAppData: AS_appData
                         eventClass: 'GURL'
                            eventID: 'GURL'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPerformCommand *)perform {
    return [SEPerformCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'perf'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEPerformCommand *)perform:(id)directParameter {
    return [SEPerformCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'perf'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPickCommand *)pick {
    return [SEPickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'pick'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEPickCommand *)pick:(id)directParameter {
    return [SEPickCommand commandWithAppData: AS_appData
                         eventClass: 'prcs'
                            eventID: 'pick'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEPrintCommand *)print {
    return [SEPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEPrintCommand *)print:(id)directParameter {
    return [SEPrintCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'pdoc'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEQuitCommand *)quit {
    return [SEQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEQuitCommand *)quit:(id)directParameter {
    return [SEQuitCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'quit'
                    directParameter: directParameter
                    parentReference: self];
}

- (SERemoveActionFromCommand *)removeActionFrom {
    return [SERemoveActionFromCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'rmfa'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SERemoveActionFromCommand *)removeActionFrom:(id)directParameter {
    return [SERemoveActionFromCommand commandWithAppData: AS_appData
                         eventClass: 'faco'
                            eventID: 'rmfa'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEReopenCommand *)reopen {
    return [SEReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEReopenCommand *)reopen:(id)directParameter {
    return [SEReopenCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'rapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (SERestartCommand *)restart {
    return [SERestartCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'rest'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SERestartCommand *)restart:(id)directParameter {
    return [SERestartCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'rest'
                    directParameter: directParameter
                    parentReference: self];
}

- (SERunCommand *)run {
    return [SERunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SERunCommand *)run:(id)directParameter {
    return [SERunCommand commandWithAppData: AS_appData
                         eventClass: 'aevt'
                            eventID: 'oapp'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESaveCommand *)save {
    return [SESaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SESaveCommand *)save:(id)directParameter {
    return [SESaveCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'save'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESelectCommand *)select {
    return [SESelectCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'slct'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SESelectCommand *)select:(id)directParameter {
    return [SESelectCommand commandWithAppData: AS_appData
                         eventClass: 'misc'
                            eventID: 'slct'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESetCommand *)set {
    return [SESetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SESetCommand *)set:(id)directParameter {
    return [SESetCommand commandWithAppData: AS_appData
                         eventClass: 'core'
                            eventID: 'setd'
                    directParameter: directParameter
                    parentReference: self];
}

- (SEShutDownCommand *)shutDown {
    return [SEShutDownCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'shut'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SEShutDownCommand *)shutDown:(id)directParameter {
    return [SEShutDownCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'shut'
                    directParameter: directParameter
                    parentReference: self];
}

- (SESleepCommand *)sleep {
    return [SESleepCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'slep'
                    directParameter: kASNoDirectParameter
                    parentReference: self];
}

- (SESleepCommand *)sleep:(id)directParameter {
    return [SESleepCommand commandWithAppData: AS_appData
                         eventClass: 'fndr'
                            eventID: 'slep'
                    directParameter: directParameter
                    parentReference: self];
}


/* Elements */

- (SEReference *)CDAndDVDPreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dhao']];
}

- (SEReference *)ClassicDomainObjects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'domc']];
}

- (SEReference *)QuickTimeData {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'qtfd']];
}

- (SEReference *)QuickTimeFiles {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'qtff']];
}

- (SEReference *)UIElements {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'uiel']];
}

- (SEReference *)XMLAttributes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmla']];
}

- (SEReference *)XMLData {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmld']];
}

- (SEReference *)XMLElements {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmle']];
}

- (SEReference *)XMLFiles {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'xmlf']];
}

- (SEReference *)actions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'actT']];
}

- (SEReference *)aliases {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'alis']];
}

- (SEReference *)annotation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'anno']];
}

- (SEReference *)appearancePreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'apro']];
}

- (SEReference *)applicationProcesses {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pcap']];
}

- (SEReference *)applications {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'capp']];
}

- (SEReference *)attachment {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'atts']];
}

- (SEReference *)attributeRuns {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'catr']];
}

- (SEReference *)attributes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'attr']];
}

- (SEReference *)audioData {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'audd']];
}

- (SEReference *)audioFiles {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'audf']];
}

- (SEReference *)browsers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'broW']];
}

- (SEReference *)busyIndicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'busi']];
}

- (SEReference *)buttons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'butT']];
}

- (SEReference *)characters {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cha ']];
}

- (SEReference *)checkboxes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'chbx']];
}

- (SEReference *)colorWells {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colW']];
}

- (SEReference *)colors {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'colr']];
}

- (SEReference *)columns {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ccol']];
}

- (SEReference *)comboBoxes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'comB']];
}

- (SEReference *)configurations {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'conF']];
}

- (SEReference *)deskAccessoryProcesses {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pcda']];
}

- (SEReference *)desktops {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dskp']];
}

- (SEReference *)diskItems {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ditm']];
}

- (SEReference *)disks {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cdis']];
}

- (SEReference *)dockPreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dpao']];
}

- (SEReference *)documents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'docu']];
}

- (SEReference *)domains {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'doma']];
}

- (SEReference *)drawers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'draA']];
}

- (SEReference *)exposePreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'epao']];
}

- (SEReference *)filePackages {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpkg']];
}

- (SEReference *)files {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'file']];
}

- (SEReference *)folderActions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'foac']];
}

- (SEReference *)folders {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cfol']];
}

- (SEReference *)groups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sgrp']];
}

- (SEReference *)growAreas {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'grow']];
}

- (SEReference *)images {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'imaA']];
}

- (SEReference *)incrementors {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'incr']];
}

- (SEReference *)insertionPreference {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'dhip']];
}

- (SEReference *)interfaces {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'intf']];
}

- (SEReference *)items {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cobj']];
}

- (SEReference *)lists {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'list']];
}

- (SEReference *)localDomainObjects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'doml']];
}

- (SEReference *)locations {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'loca']];
}

- (SEReference *)loginItems {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'logi']];
}

- (SEReference *)menuBarItems {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mbri']];
}

- (SEReference *)menuBars {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'mbar']];
}

- (SEReference *)menuButtons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'menB']];
}

- (SEReference *)menuItems {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'menI']];
}

- (SEReference *)menus {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'menE']];
}

- (SEReference *)movieData {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'movd']];
}

- (SEReference *)movieFiles {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'movf']];
}

- (SEReference *)networkDomainObjects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'domn']];
}

- (SEReference *)networkPreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'neto']];
}

- (SEReference *)outlines {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'outl']];
}

- (SEReference *)paragraphs {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cpar']];
}

- (SEReference *)popUpButtons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'popB']];
}

- (SEReference *)printSettings {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'pset']];
}

- (SEReference *)processes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'prcs']];
}

- (SEReference *)progressIndicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'proI']];
}

- (SEReference *)propertyListFiles {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'plif']];
}

- (SEReference *)propertyListItems {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'plii']];
}

- (SEReference *)radioButtons {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'radB']];
}

- (SEReference *)radioGroups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'rgrp']];
}

- (SEReference *)relevanceIndicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'reli']];
}

- (SEReference *)rows {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'crow']];
}

- (SEReference *)screenCorner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'epsc']];
}

- (SEReference *)scripts {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'scpt']];
}

- (SEReference *)scrollAreas {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'scra']];
}

- (SEReference *)scrollBars {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'scrb']];
}

- (SEReference *)securityPreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'seco']];
}

- (SEReference *)services {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'svce']];
}

- (SEReference *)sheets {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sheE']];
}

- (SEReference *)shortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'epst']];
}

- (SEReference *)sliders {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sliI']];
}

- (SEReference *)spacesPreferencesObject {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'spsp']];
}

- (SEReference *)spacesShortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'spst']];
}

- (SEReference *)splitterGroups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'splg']];
}

- (SEReference *)splitters {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'splr']];
}

- (SEReference *)staticTexts {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'sttx']];
}

- (SEReference *)systemDomainObjects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'doms']];
}

- (SEReference *)tabGroups {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'tabg']];
}

- (SEReference *)tables {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'tabB']];
}

- (SEReference *)text {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'ctxt']];
}

- (SEReference *)textAreas {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'txta']];
}

- (SEReference *)textFields {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'txtf']];
}

- (SEReference *)toolBars {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'tbar']];
}

- (SEReference *)tracks {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'trak']];
}

- (SEReference *)userDomainObjects {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'domu']];
}

- (SEReference *)users {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'uacc']];
}

- (SEReference *)valueIndicators {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'vali']];
}

- (SEReference *)windows {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwin']];
}

- (SEReference *)words {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference elements: 'cwor']];
}


/* Properties */

- (SEReference *)CDAndDVDPreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhas']];
}

- (SEReference *)Classic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'clsc']];
}

- (SEReference *)ClassicDomain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldc']];
}

- (SEReference *)FolderActionScriptsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fasf']];
}

- (SEReference *)MACAddress {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'maca']];
}

- (SEReference *)POSIXPath {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'posx']];
}

- (SEReference *)UIElementsEnabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'uien']];
}

- (SEReference *)URL {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'url ']];
}

- (SEReference *)acceptsHighLevelEvents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isab']];
}

- (SEReference *)acceptsRemoteEvents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'revt']];
}

- (SEReference *)accountName {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'user']];
}

- (SEReference *)active {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'acti']];
}

- (SEReference *)activity {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsa']];
}

- (SEReference *)allWindowsShortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epaw']];
}

- (SEReference *)animate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dani']];
}

- (SEReference *)appearance {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'appe']];
}

- (SEReference *)appearancePreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aprp']];
}

- (SEReference *)appleMenuFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'amnu']];
}

- (SEReference *)applicationBindings {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spcs']];
}

- (SEReference *)applicationFile {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'appf']];
}

- (SEReference *)applicationSupportFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asup']];
}

- (SEReference *)applicationWindowsShortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'eppw']];
}

- (SEReference *)applicationsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'apps']];
}

- (SEReference *)architecture {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'arch']];
}

- (SEReference *)arrowKeyModifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spam']];
}

- (SEReference *)audioChannelCount {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'acha']];
}

- (SEReference *)audioCharacteristic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'audi']];
}

- (SEReference *)audioSampleRate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asra']];
}

- (SEReference *)audioSampleSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'assz']];
}

- (SEReference *)autoPlay {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'autp']];
}

- (SEReference *)autoPresent {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'apre']];
}

- (SEReference *)autoQuitWhenDone {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aqui']];
}

- (SEReference *)autohide {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dahd']];
}

- (SEReference *)automatic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'auto']];
}

- (SEReference *)automaticLogin {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aulg']];
}

- (SEReference *)backgroundOnly {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'bkgo']];
}

- (SEReference *)blankCD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhbc']];
}

- (SEReference *)blankDVD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhbd']];
}

- (SEReference *)bottomLeftScreenCorner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epbl']];
}

- (SEReference *)bottomRightScreenCorner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epbr']];
}

- (SEReference *)bounds {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pbnd']];
}

- (SEReference *)bundleIdentifier {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'bnid']];
}

- (SEReference *)busyStatus {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'busy']];
}

- (SEReference *)capacity {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'capa']];
}

- (SEReference *)changeInterval {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cinT']];
}

- (SEReference *)class_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcls']];
}

- (SEReference *)closeable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hclb']];
}

- (SEReference *)collating {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcl']];
}

- (SEReference *)color {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'colr']];
}

- (SEReference *)connected {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'conn']];
}

- (SEReference *)container {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ctnr']];
}

- (SEReference *)contents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pcnt']];
}

- (SEReference *)controlPanelsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ctrl']];
}

- (SEReference *)controlStripModulesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdev']];
}

- (SEReference *)copies {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwcp']];
}

- (SEReference *)creationDate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ascd']];
}

- (SEReference *)creationTime {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mdcr']];
}

- (SEReference *)creatorType {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fcrt']];
}

- (SEReference *)currentConfiguration {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cnfg']];
}

- (SEReference *)currentDesktop {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'curd']];
}

- (SEReference *)currentLocation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'locc']];
}

- (SEReference *)currentUser {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'curu']];
}

- (SEReference *)customApplication {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhca']];
}

- (SEReference *)customScript {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhcs']];
}

- (SEReference *)dashboardShortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epdb']];
}

- (SEReference *)dataFormat {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'tdfr']];
}

- (SEReference *)dataRate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ddra']];
}

- (SEReference *)dataSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dsiz']];
}

- (SEReference *)defaultApplication {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asda']];
}

- (SEReference *)description_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'desc']];
}

- (SEReference *)deskAccessoryFile {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dafi']];
}

- (SEReference *)desktopFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'desk']];
}

- (SEReference *)desktopPicturesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dtp$']];
}

- (SEReference *)dimensions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pdim']];
}

- (SEReference *)displayName {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dnaM']];
}

- (SEReference *)displayedName {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dnam']];
}

- (SEReference *)dockPreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dpas']];
}

- (SEReference *)dockSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dsze']];
}

- (SEReference *)document {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docu']];
}

- (SEReference *)documentsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'docs']];
}

- (SEReference *)doubleClickMinimizes {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mndc']];
}

- (SEReference *)downloadsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'down']];
}

- (SEReference *)duplex {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dupl']];
}

- (SEReference *)duration {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'durn']];
}

- (SEReference *)ejectable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isej']];
}

- (SEReference *)enabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'enaB']];
}

- (SEReference *)endingPage {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwlp']];
}

- (SEReference *)entireContents {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ects']];
}

- (SEReference *)errorHandling {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lweh']];
}

- (SEReference *)exposePreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epas']];
}

- (SEReference *)extensionsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'extz']];
}

- (SEReference *)favoritesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'favs']];
}

- (SEReference *)faxNumber {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faxn']];
}

- (SEReference *)file {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'file']];
}

- (SEReference *)fileName {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'atfn']];
}

- (SEReference *)fileType {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asty']];
}

- (SEReference *)floating {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isfl']];
}

- (SEReference *)focused {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'focu']];
}

- (SEReference *)folderActionsEnabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'faen']];
}

- (SEReference *)font {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (SEReference *)fontSmoothingLimit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ftsm']];
}

- (SEReference *)fontSmoothingStyle {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ftss']];
}

- (SEReference *)fontsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'font']];
}

- (SEReference *)format {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dfmt']];
}

- (SEReference *)freeSpace {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'frsp']];
}

- (SEReference *)frontmost {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pisf']];
}

- (SEReference *)fullName {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fnam']];
}

- (SEReference *)fullText {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'anot']];
}

- (SEReference *)functionKey {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsk']];
}

- (SEReference *)functionKeyModifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsy']];
}

- (SEReference *)hasScriptingTerminology {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hscr']];
}

- (SEReference *)help_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'help']];
}

- (SEReference *)hidden {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hidn']];
}

- (SEReference *)highQuality {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hqua']];
}

- (SEReference *)highlightColor {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'hico']];
}

- (SEReference *)homeDirectory {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'home']];
}

- (SEReference *)homeFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cusr']];
}

- (SEReference *)href {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'href']];
}

- (SEReference *)id_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ID  ']];
}

- (SEReference *)ignorePrivileges {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'igpr']];
}

- (SEReference *)index {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pidx']];
}

- (SEReference *)insertionAction {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhat']];
}

- (SEReference *)interface {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'intf']];
}

- (SEReference *)keyModifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spky']];
}

- (SEReference *)kind {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'kind']];
}

- (SEReference *)launcherItemsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'laun']];
}

- (SEReference *)libraryFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dlib']];
}

- (SEReference *)localDomain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldl']];
}

- (SEReference *)localVolume {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isrv']];
}

- (SEReference *)location {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dplo']];
}

- (SEReference *)logOutWhenInactive {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'aclk']];
}

- (SEReference *)logOutWhenInactiveInterval {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'acto']];
}

- (SEReference *)looping {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'loop']];
}

- (SEReference *)magnification {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmag']];
}

- (SEReference *)magnificationSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dmsz']];
}

- (SEReference *)maximumValue {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'maxV']];
}

- (SEReference *)miniaturizable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ismn']];
}

- (SEReference *)miniaturized {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmnd']];
}

- (SEReference *)minimizeEffect {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'deff']];
}

- (SEReference *)minimumValue {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'minW']];
}

- (SEReference *)modal {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pmod']];
}

- (SEReference *)modificationDate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'asmo']];
}

- (SEReference *)modificationTime {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mdtm']];
}

- (SEReference *)modified {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'imod']];
}

- (SEReference *)modifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epso']];
}

- (SEReference *)mouseButton {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsb']];
}

- (SEReference *)mouseButtonModifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epsm']];
}

- (SEReference *)moviesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mdoc']];
}

- (SEReference *)mtu {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'mtu ']];
}

- (SEReference *)musicCD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhmc']];
}

- (SEReference *)musicFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: '%doc']];
}

- (SEReference *)name {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pnam']];
}

- (SEReference *)nameExtension {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'extn']];
}

- (SEReference *)naturalDimensions {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ndim']];
}

- (SEReference *)networkDomain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldn']];
}

- (SEReference *)networkPreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'netp']];
}

- (SEReference *)numbersKeyModifiers {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spnm']];
}

- (SEReference *)orientation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'orie']];
}

- (SEReference *)packageFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pkgf']];
}

- (SEReference *)pagesAcross {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwla']];
}

- (SEReference *)pagesDown {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwld']];
}

- (SEReference *)partitionSpaceUsed {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pusd']];
}

- (SEReference *)path {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ppth']];
}

- (SEReference *)physicalSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'phys']];
}

- (SEReference *)picture {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'picP']];
}

- (SEReference *)pictureCD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhpc']];
}

- (SEReference *)picturePath {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'picp']];
}

- (SEReference *)pictureRotation {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'chnG']];
}

- (SEReference *)picturesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pdoc']];
}

- (SEReference *)position {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'posn']];
}

- (SEReference *)preferencesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pref']];
}

- (SEReference *)preferredRate {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prfr']];
}

- (SEReference *)preferredVolume {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prfv']];
}

- (SEReference *)presentationMode {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prmd']];
}

- (SEReference *)presentationSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (SEReference *)previewDuration {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvwd']];
}

- (SEReference *)previewTime {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvwt']];
}

- (SEReference *)productVersion {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ver2']];
}

- (SEReference *)properties {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pALL']];
}

- (SEReference *)publicFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pubb']];
}

- (SEReference *)quitDelay {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'qdel']];
}

- (SEReference *)randomOrder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ranD']];
}

- (SEReference *)recentApplicationsLimit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rapl']];
}

- (SEReference *)recentDocumentsLimit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rdcl']];
}

- (SEReference *)recentServersLimit {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'rsvl']];
}

- (SEReference *)requestedPrintTime {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwqt']];
}

- (SEReference *)requirePasswordToUnlock {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pwul']];
}

- (SEReference *)requirePasswordToWake {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pwwk']];
}

- (SEReference *)resizable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'prsz']];
}

- (SEReference *)role {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'role']];
}

- (SEReference *)scriptMenuEnabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scmn']];
}

- (SEReference *)scriptingAdditionsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: '$scr']];
}

- (SEReference *)scriptsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scr$']];
}

- (SEReference *)scrollArrowPlacement {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sclp']];
}

- (SEReference *)scrollBarAction {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sclb']];
}

- (SEReference *)secureVirtualMemory {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scvm']];
}

- (SEReference *)securityPreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'secp']];
}

- (SEReference *)selected {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'selE']];
}

- (SEReference *)server {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'srvr']];
}

- (SEReference *)settable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'stbl']];
}

- (SEReference *)sharedDocumentsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdat']];
}

- (SEReference *)shortName {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'cfbn']];
}

- (SEReference *)shortVersion {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'assv']];
}

- (SEReference *)showDesktopShortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'epde']];
}

- (SEReference *)showSpacesShortcut {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spcs']];
}

- (SEReference *)shutdownFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'shdf']];
}

- (SEReference *)sitesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'site']];
}

- (SEReference *)size {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptsz']];
}

- (SEReference *)smoothScrolling {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'scls']];
}

- (SEReference *)spacesColumns {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spcl']];
}

- (SEReference *)spacesEnabled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spen']];
}

- (SEReference *)spacesPreferences {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'essp']];
}

- (SEReference *)spacesRows {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sprw']];
}

- (SEReference *)speakableItemsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'spki']];
}

- (SEReference *)speed {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sped']];
}

- (SEReference *)startTime {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'offs']];
}

- (SEReference *)startingPage {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'lwfp']];
}

- (SEReference *)startup {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'istd']];
}

- (SEReference *)startupDisk {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sdsk']];
}

- (SEReference *)startupItemsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'empz']];
}

- (SEReference *)stationery {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pspd']];
}

- (SEReference *)storedStream {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'isss']];
}

- (SEReference *)subrole {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'sbrl']];
}

- (SEReference *)systemDomain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'flds']];
}

- (SEReference *)systemFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'macs']];
}

- (SEReference *)targetPrinter {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trpr']];
}

- (SEReference *)temporaryItemsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'temp']];
}

- (SEReference *)timeScale {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'tmsc']];
}

- (SEReference *)title {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'titl']];
}

- (SEReference *)titled {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptit']];
}

- (SEReference *)topLeftScreenCorner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'eptl']];
}

- (SEReference *)topRightScreenCorner {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'eptr']];
}

- (SEReference *)totalPartitionSize {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'appt']];
}

- (SEReference *)trash {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'trsh']];
}

- (SEReference *)type {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'ptyp']];
}

- (SEReference *)typeClass {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'type']];
}

- (SEReference *)typeIdentifier {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'utid']];
}

- (SEReference *)unixId {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'idux']];
}

- (SEReference *)userDomain {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'fldu']];
}

- (SEReference *)utilitiesFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'uti$']];
}

- (SEReference *)value {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'valL']];
}

- (SEReference *)version_ {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vers']];
}

- (SEReference *)videoDVD {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'dhvd']];
}

- (SEReference *)videoDepth {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'vcdp']];
}

- (SEReference *)visible {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pvis']];
}

- (SEReference *)visualCharacteristic {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'visu']];
}

- (SEReference *)volume {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'volu']];
}

- (SEReference *)workflowsFolder {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'flow']];
}

- (SEReference *)zone {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'zone']];
}

- (SEReference *)zoomable {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'iszm']];
}

- (SEReference *)zoomed {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference property: 'pzum']];
}


/* ********************************* */


/* ordinal selectors */

- (SEReference *)first {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (SEReference *)middle {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (SEReference *)last {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (SEReference *)any {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}


/* by-index, by-name, by-id selectors */

- (SEReference *)at:(long)index {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: index]];
}

- (SEReference *)byIndex:(id)index {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: index]];
}

- (SEReference *)byName:(id)name {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (SEReference *)byID:(id)id_ {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}


/* by-relative-position selectors */

- (SEReference *)previous:(ASConstant *)class_ {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ AS_code]]];
}

- (SEReference *)next:(ASConstant *)class_ {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ AS_code]]];
}


/* by-range selector */

- (SEReference *)at:(long)fromIndex to:(long)toIndex {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}

- (SEReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [SEReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [SEReference class]])
        toObject = [toObject AS_aemReference];
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}


/* by-test selector */

- (SEReference *)byTest:(SEReference *)testReference {
    return [SEReference referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}


/* insertion location selectors */

- (SEReference *)beginning {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginning]];
}

- (SEReference *)end {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}

- (SEReference *)before {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}

- (SEReference *)after {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}


/* Comparison and logic tests */

- (SEReference *)greaterThan:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterThan: object]];
}

- (SEReference *)greaterOrEquals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference greaterOrEquals: object]];
}

- (SEReference *)equals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference equals: object]];
}

- (SEReference *)notEquals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference notEquals: object]];
}

- (SEReference *)lessThan:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessThan: object]];
}

- (SEReference *)lessOrEquals:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference lessOrEquals: object]];
}

- (SEReference *)beginsWith:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference beginsWith: object]];
}

- (SEReference *)endsWith:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference endsWith: object]];
}

- (SEReference *)contains:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference contains: object]];
}

- (SEReference *)isIn:(id)object {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference isIn: object]];
}

- (SEReference *)AND:(id)remainingOperands {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference AND: remainingOperands]];
}

- (SEReference *)OR:(id)remainingOperands {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference OR: remainingOperands]];
}

- (SEReference *)NOT {
    return [SEReference referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference NOT]];
}

@end

