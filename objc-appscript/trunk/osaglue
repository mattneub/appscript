#!/usr/local/bin/python

from codecs import getencoder
import re, time

from osaterminology.makeidentifier import getconverter
from appscript import terminology
from aem import Application, findapp, AEType

# TO DO: hardcode default types and references/commands in ASConstant and ASReference


# empty the default py-appscript terminology tables, as that info is already hardcoded in objc-appscript

terminology._typebycode = {}
terminology._typebyname = {}
terminology._referencebycode = {}
terminology._referencebyname = {}


######################################################################
# renderers
######################################################################

prefixtag = 'PREFIX'
interfacemethodspattern = re.compile('^(-.+?) {', re.M)

legalcodechars = ''
for i in range(32, 126):
	c = chr(i)
	if c not in '\\\'"':
		legalcodechars += c

hexencode = getencoder('hex_codec')

def formatcode(code):
	if [c for c in code if c not in legalcodechars]:
		return '0x' + hexencode(code)[0]
	else:
		return "'%s'" % code


######################################################################


def renderHead(interface, implementation):
	print >> interface, """/*
 * PREFIXGlue.h
 *
 * %s
 * %s
 *
 */

#import <Appscript/Appscript.h>

#define PREFIXApp [PREFIXReference referenceWithAppData: nil aemReference: AEMApp]
#define PREFIXCon [PREFIXReference referenceWithAppData: nil aemReference: AEMCon]
#define PREFIXIts [PREFIXReference referenceWithAppData: nil aemReference: AEMIts]

""".replace(prefixtag, prefix) % (apppath, time.strftime('%Y-%m-%d %H:%M:%S (%Z)'))

	print >> implementation, """/*
 * PREFIXGlue.m
 *
 * %s
 * %s
 *
 */

#import <PREFIXGlue.h>

""".replace(prefixtag, prefix) % (apppath, time.strftime('%Y-%m-%d %H:%M:%S (%Z)'))


######################################################################


def renderConstantClass(interface, implementation):
	constantClass = prefix + 'Constant'
	print >> interface, '@interface %s : ASConstant' % constantClass
	print >> implementation, '@implementation ' + constantClass
	#######
	print >> interface, '+ (id)constantWithName:(NSString *)name_ type:(DescType)type_ code:(OSType)code_;'
	print >> implementation, '''
+ (id)constantWithName:(NSString *)name_ type:(DescType)type_ code:(OSType)code_ {
    static NSMutableDictionary *constantsByName;
    %s *constantObj;
    NSAppleEventDescriptor *desc_;
    
    if (!constantsByName)
        constantsByName = [[NSMutableDictionary alloc] init];
    constantObj = [constantsByName objectForKey: name_];
    if (!constantObj) {
        desc_ = [[NSAppleEventDescriptor alloc] initWithDescriptorType: type_
                                                                 bytes: &code_
                                                                length: sizeof(code_)];
        constantObj =  [[%s alloc] initWithName: name_ descriptor: desc_];
        [desc_ release];
        [constantsByName setObject: constantObj forKey: name_];
        [constantObj release];
    }
    return constantObj;
}
''' % (constantClass, constantClass)
	#######
	print >> interface, '+ (id)constantWithCode:(OSType)code_;'
	print >> implementation, '''
+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
'''
	for name, code in typebyname:
		code = formatcode(code.code)
		print >> implementation, '''        case %s:
            return [self constantWithName: @"%s" type: %s code: %s];''' % (code, name,
            		isinstance(code, AEType) and 'typeType' or 'typeEnumerated', code)
	print >> implementation, '''        default:
            return nil;
    }
}
'''
	#######
	prevkind = None
	for name, code in typebyname:
		kind = code.__class__.__name__
		if prevkind != kind:
			for t in [interface, implementation]:
				print >> t, '\n/* %s */\n' % {'AEEnum': 'Enumerators', 'AEType': 'Types and properties'}[kind]
		prevkind = kind
		print >> interface, '+ (%s *)%s;' % (constantClass, name)
		print >> implementation, ('+ (%s *)%s {\n'
				'    return [%sConstant constantWithName: @"%s" type: %s code: %s];\n'
				'}\n') % (constantClass, name, 
						prefix, name, 
						isinstance(code, AEType) and 'typeType' or 'typeEnumerated', 
						formatcode(code.code))
	print >> interface, '@end\n\n'
	print >> implementation, '@end\n\n'


######################################################################


def renderCommandClasses(interface, implementation):
	for name, (kind, data) in referencebyname:
		if kind != 'c':
			continue
		commandclass = prefix + name[0].upper() + name[1:] + 'Command'
		code = data[0]
		params = data[1].items()
		params.sort()
		print >> interface, '@interface %s : ASCommand' % commandclass
		print >> implementation, '@implementation %s\n' % commandclass
		for paramname, paramcode in params:
			print >> interface, '- (%s *)%s:(id)value;' % (commandclass, paramname)
			print >> implementation, ('- (%s *)%s:(id)value {\n'
					'    [AS_event setParameter: value forKeyword: %s];\n'
					'    return self;\n'
					'}\n') % (commandclass, paramname, formatcode(paramcode))
		print >> interface, '@end\n\n'
		print >> implementation, '@end\n\n'


######################################################################


def renderReferenceClass(interface, implementation):
	print >> interface, '@interface %sReference : ASReference' % prefix
	print >> implementation, '@implementation %sReference' % prefix
	prevkind = None
	for name, (kind, data) in referencebyname:
		if kind != prevkind:
			for t in [interface, implementation]:
				print >> t, '\n/* %s */\n' % {'c': 'Commands', 'p': 'Properties', 'e': 'Elements'}[kind]
		prevkind = kind
		if kind == 'c':
			commandclass = prefix + name[0].upper() + name[1:] + 'Command'
			for directParam in ['', ':(id)directParameter']:
				print >> interface, '- (%s *)%s;' % (commandclass, name + directParam)
				code = data[0]
				print >> implementation, ('- (%s *)%s {\n'
						'    return [%s commandWithAppData: AS_appData\n'
						'                         eventClass: %s\n'
						'                            eventID: %s\n'
						'                    directParameter: %s\n'
						'                    parentReference: self];\n'
						
						'}\n') % (commandclass, name + directParam,
								commandclass,
								formatcode(code[:4]),
								formatcode(code[4:]),
								directParam and 'directParameter' or 'nil')
		else:
			print >> interface, '- (%sReference *)%s;' % (prefix, name)
			print >> implementation, ('- (%sReference *)%s {\n'
					'    return [%sReference referenceWithAppData: AS_appData\n'
					'                    aemReference: [AS_aemReference %s: %s]];\n'
					'}\n') % (prefix, name, prefix, {'p': 'property', 'e': 'elements'}[kind], formatcode(data))
	renderSelectors(interface, implementation)
	print >> interface, '@end\n\n'
	print >> implementation, '@end\n\n'


_selectorimplementation = """
/***********************************/

// ordinal selectors

- (PREFIXReference *)first {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference first]];
}

- (PREFIXReference *)middle {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference middle]];
}

- (PREFIXReference *)last {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference last]];
}

- (PREFIXReference *)any {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference any]];
}

// by-index, by-name, by-id selectors
 
- (PREFIXReference *)at:(long)index {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: index]];
}

- (PREFIXReference *)byIndex:(id)index { // index is normally NSNumber, but may occasionally be other types
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byIndex: index]];
}

- (PREFIXReference *)byName:(NSString *)name {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byName: name]];
}

- (PREFIXReference *)byID:(id)id_ {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byID: id_]];
}

// by-relative-position selectors

- (PREFIXReference *)previous:(ASConstant *)class_ {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference previous: [class_ code]]];
}

- (PREFIXReference *)next:(ASConstant *)class_ {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference next: [class_ code]]];
}

// by-range selector

- (PREFIXReference *)at:(long)fromIndex to:(long)toIndex {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];
}
- (PREFIXReference *)byRange:(id)fromObject to:(id)toObject {
    // takes two con-based references, with other values being expanded as necessary
    if ([fromObject isKindOfClass: [PREFIXReference class]])
        fromObject = [fromObject AS_aemReference];
    if ([toObject isKindOfClass: [PREFIXReference class]])
        toObject = [toObject AS_aemReference];
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];
}

// by-test selector

- (PREFIXReference *)byTest:(PREFIXReference *)testReference {
    // note: getting AS_aemReference won't work for ASDynamicReference
    return [[self class] referenceWithAppData: AS_appData
                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];
}

// insertion location selectors

- (PREFIXReference *)start {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference start]];
}
- (PREFIXReference *)end {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference end]];
}
- (PREFIXReference *)before {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference before]];
}
- (PREFIXReference *)after {
    return [[self class] referenceWithAppData: AS_appData
                                 aemReference: [AS_aemReference after]];
}
"""

def renderSelectors(interface, implementation):
	selectors = _selectorimplementation.replace(prefixtag, prefix)
	for methoddef in interfacemethodspattern.findall(selectors):
		print >> interface, '%s;' % methoddef
	print >> implementation, selectors


######################################################################


_applicationclassimplementation = """

@implementation PREFIXApplication

// clients shouldn't need to call this next method themselves
- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_ {
	ASAppData *appData;
	
	appData = [[ASAppData alloc] initWithApplicationClass: [AEMApplication class]
											   targetType: targetType_
											   targetData: targetData_];
	self = [super initWithAppData: appData aemReference: AEMApp];
	if (!self) return self;
	return self;
}

// initialisers

- (id)init {
	return [self initWithTargetType: kASTargetCurrent data: nil];
}

- (id)initWithName:(NSString *)name {
	return [self initWithTargetType: kASTargetName data: name];
}

// TO DO: initWithBundleID, initWithSignature

- (id)initWithPath:(NSString *)path {
	return [self initWithTargetType: kASTargetPath data: path];	
}

- (id)initWithURL:(NSURL *)url {
	return [self initWithTargetType: kASTargetURL data: url];
}

- (id)initWithPID:(pid_t)pid {
	return [self initWithTargetType: kASTargetPID data: [NSNumber numberWithUnsignedLong: pid]];
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	return [self initWithTargetType: kASTargetDescriptor data: desc];
}

@end
"""


def renderApplicationClass(interface, implementation):
	classdef = _applicationclassimplementation.replace(prefixtag, prefix)
	print >> interface, '@interface %sApplication : ASReference' % prefix
	for methoddef in interfacemethodspattern.findall(classdef):
		print >> interface, '%s;' % methoddef
	print >> interface, '@end\n'
	print >> implementation, classdef


######################################################################

apppath = findapp.byname('textedit')
prefix = 'TE'
appObj = Application(apppath)
outDir = '/Users/has/TEGlue'

######################################################################
# get tables

typebycode, typebyname, referencebycode, referencebyname = terminology.tablesforapp(appObj, 'objc-appscript')
referencebyname = referencebyname.items()
referencebyname.sort(lambda a, b: cmp(a[1][0], b[1][0]) or cmp(a[0], b[0]))
typebyname = typebyname.items()
typebyname.sort(lambda a, b: cmp(a[1].__class__.__name__, b[1].__class__.__name__) or cmp(a[0], b[0]))

#######
# render tables

from StringIO import StringIO
interface = StringIO()
implementation = StringIO()

renderHead(interface, implementation)
renderConstantClass(interface, implementation)
renderCommandClasses(interface, implementation)
renderReferenceClass(interface, implementation)
renderApplicationClass(interface, implementation)

#print interface.getvalue()
#print '\n\n\n\n\n'
print implementation.getvalue()
