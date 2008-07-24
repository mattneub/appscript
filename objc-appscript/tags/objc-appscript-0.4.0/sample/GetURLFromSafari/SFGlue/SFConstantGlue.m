/*
 * SFConstantGlue.m
 *
 * /Applications/Safari.app
 * osaglue 0.3.2
 *
 */

#import "SFConstantGlue.h"

@implementation SFConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'pURL': return [self URL];
        case 'capp': return [self application];
        case 'ask ': return [self ask];
        case 'atts': return [self attachment];
        case 'catr': return [self attributeRun];
        case 'pbnd': return [self bounds];
        case 'cha ': return [self character];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'lwcp': return [self copies];
        case 'cTab': return [self currentTab];
        case 'lwdt': return [self detailed];
        case 'docu': return [self document];
        case 'lwlp': return [self endingPage];
        case 'lweh': return [self errorHandling];
        case 'faxn': return [self faxNumber];
        case 'atfn': return [self fileName];
        case 'isfl': return [self floating];
        case 'font': return [self font];
        case 'pisf': return [self frontmost];
        case 'ID  ': return [self id_];
        case 'pidx': return [self index];
        case 'cobj': return [self item];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'pmod': return [self modal];
        case 'imod': return [self modified];
        case 'pnam': return [self name];
        case 'no  ': return [self no];
        case 'lwla': return [self pagesAcross];
        case 'lwld': return [self pagesDown];
        case 'cpar': return [self paragraph];
        case 'ppth': return [self path];
        case 'pset': return [self printSettings];
        case 'pALL': return [self properties];
        case 'lwqt': return [self requestedPrintTime];
        case 'prsz': return [self resizable];
        case 'ptsz': return [self size];
        case 'conT': return [self source];
        case 'lwst': return [self standard];
        case 'lwfp': return [self startingPage];
        case 'bTab': return [self tab];
        case 'trpr': return [self targetPrinter];
        case 'ctxt': return [self text];
        case 'ptit': return [self titled];
        case 'vers': return [self version_];
        case 'pvis': return [self visible];
        case 'cwin': return [self window];
        case 'cwor': return [self word];
        case 'yes ': return [self yes];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (SFConstant *)ask {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (SFConstant *)detailed {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (SFConstant *)no {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (SFConstant *)standard {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"standard" type: typeEnumerated code: 'lwst'];
    return constantObj;
}

+ (SFConstant *)yes {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (SFConstant *)URL {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"URL" type: typeType code: 'pURL'];
    return constantObj;
}

+ (SFConstant *)application {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"application" type: typeType code: 'capp'];
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

+ (SFConstant *)bounds {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (SFConstant *)character {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"character" type: typeType code: 'cha '];
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

+ (SFConstant *)copies {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (SFConstant *)currentTab {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"currentTab" type: typeType code: 'cTab'];
    return constantObj;
}

+ (SFConstant *)document {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (SFConstant *)endingPage {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"endingPage" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (SFConstant *)errorHandling {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"errorHandling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (SFConstant *)faxNumber {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"faxNumber" type: typeType code: 'faxn'];
    return constantObj;
}

+ (SFConstant *)fileName {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"fileName" type: typeType code: 'atfn'];
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

+ (SFConstant *)id_ {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"id_" type: typeType code: 'ID  '];
    return constantObj;
}

+ (SFConstant *)index {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (SFConstant *)item {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"item" type: typeType code: 'cobj'];
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

+ (SFConstant *)path {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (SFConstant *)printSettings {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"printSettings" type: typeType code: 'pset'];
    return constantObj;
}

+ (SFConstant *)properties {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"properties" type: typeType code: 'pALL'];
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

+ (SFConstant *)startingPage {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"startingPage" type: typeType code: 'lwfp'];
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

+ (SFConstant *)titled {
    static SFConstant *constantObj;
    if (!constantObj)
        constantObj = [SFConstant constantWithName: @"titled" type: typeType code: 'ptit'];
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


