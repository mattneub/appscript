#!/usr/bin/env python

""" osaglue -- generates objc-appscript glue files

(C) 2007-2008 HAS

	Used by ASDictionary 0.12.0+, though may be installed as a shell script 
	and run directly, e.g.:
	
		sudo cp osaglue.py /usr/local/bin/osaglue
		sudo chmod 755 /usr/local/bin/osaglue
		osaglue -o TEGlue -p TE TextEdit
	
	Run 'osaglue' to display command line help.

	Dependencies:
	
		- py-appscript 0.19.0+ 
		- py-osaterminology 0.13.0+
"""


from codecs import getencoder
import os, sys, getopt, StringIO

import aem
from osaterminology.makeidentifier import getconverter
from osaterminology.tables.tablebuilder import *



__version__ = '0.5.0'

######################################################################
# support
######################################################################

kPrefixTag = '<PREFIX>'

# format OSTypes as literals

legalcodechars = ''
for i in range(32, 126):
	c = chr(i)
	if c not in '\\\'"':
		legalcodechars += c

hexencode = getencoder('hex_codec')

def _formatcode(code):
	if [c for c in code if c not in legalcodechars]:
		return '0x' + hexencode(code)[0]
	else:
		return "'%s'" % code

# uppercase first character of identifier

def _capname(s):
	return s and s[0].upper() + s[1:] or '_'

# locate a scripting addition by name

def _findosax(osaxname):
	se = aem.Application(aem.findapp.byid('com.apple.systemevents'))
	for domaincode in ['flds', 'fldl', 'fldu']:
		osax = aem.app.property(domaincode).property('$scr').elements('file').byfilter(
				aem.its.property('pnam').eq(osaxname)
				.OR(aem.its.property('pnam').eq('%s.osax' % osaxname))).byindex(1)
		if se.event('coredoex', {'----': osax}).send(): # domain has ScriptingAdditions folder
			return se.event('coregetd', {'----': osax.property('posx')}).send()
	raise RuntimeError, "Scripting addition %r not found."



######################################################################
# RENDERER
######################################################################


class ImplementationRenderer:
	""" Generates .m files and corresponding .h files. """
	
	def __init__(self, apppath, outdir, prefix):
		self._apppath = apppath
		self._outdir = outdir
		self._prefix = prefix

	def newglue(self, name, hasimplementation=True):
		path = os.path.join(self._outdir, self._prefix + name)
		self._interface = open(path + '.h', 'w')
		if hasimplementation:
			self._implementation = open(path + '.m', 'w')
		else:
			self._implementation = StringIO.StringIO()
		# headers
		for fn, f, suffix in [(self.writeh, self._interface, 'h'), (self.writem, self._implementation, 'm')]:
			fn('/*')
			fn(' * <PREFIX>%s.%s' % (name, suffix))
			print >> f, ' * ' + self._apppath.replace('*/', '*\\/')
			fn(' * osaglue %s' % __version__)
			fn(' *')
			fn(' */')
			fn('')
		self.writeh('#import <Foundation/Foundation.h>')
		self.writeh('#import "Appscript/Appscript.h"')
		self.writem('#import "<PREFIX>%s.h"' % name)
	
	def writeh(self, src):
		print >> self._interface, src.replace(kPrefixTag, self._prefix)
	
	def writem(self, src):
		print >> self._implementation, src.replace(kPrefixTag, self._prefix)
	
	def importmacro(self, name):
		self.writeh('#import "%s"' % name)
	
	def definemacro(self, name, value):
		self.writeh('#define %s (%s)' % (name, value))
	
	def newclass(self, name, parent):
		self.writeh('\n@interface %s : %s' % (name, parent))
		self.writem('\n@implementation %s' % name)
	
	def endclass(self):
		self.writeh('@end\n')
		self.writem('@end\n')
	
	def newmethod(self, src):
		self.writeh(src + ';')
		self.writem(src + ' {')
		
	def endmethod(self):
		self.writem('}\n')
	
	def comment(self, txt):
		src = '\n/* %s */\n' % txt
		self.writeh(src)
		self.writem(src)
	
	def __iadd__(self, value):
		self.writem(value)
		return self
	
	def endglue(self):
		self._interface.close()
		self._implementation.close()



######################################################################


class ClassBuilder:
	
	_osaxloader = ''
	
	def __init__(self, terms):
		self.typebycode = terms[0].items()
		self.typebycode.sort(lambda a, b: cmp(a[1], b[1]))
		self.typebyname = terms[1].items()
		self.typebyname.sort(lambda a, b: cmp(a[1][0], b[1][0]) or cmp(a[0], b[0]))
		self.referencebycode = terms[2].items()
		self.referencebycode.sort(lambda a, b: cmp(a[1][1], b[1][1]))
		self.referencebyname = terms[3].items()
		self.referencebyname.sort(lambda a, b: cmp(a[1][0], b[1][0]) or cmp(a[0], b[0]))
	
	##
	
	def render_constant(self, src):
		src.newglue('ConstantGlue')
		src.newclass('<PREFIX>Constant', 'ASConstant')
		# AE code to constant converter
		src.newmethod('+ (id)constantWithCode:(OSType)code_')
		src += '    switch (code_) {'
		for code, name in self.typebycode:
			src += '        case %s: return [self %s];' % (_formatcode(code), name)
		src += '        default: return [[self superclass] constantWithCode: code_];'
		src += '    }'
		src.endmethod()
		# constant constructors
		prevkind = None
		for name, (kind, code) in self.typebyname:
			if prevkind != kind:
				src.comment({kEnum: 'Enumerators', kType: 'Types and properties'}[kind])
			prevkind = kind
			src.newmethod('+ (<PREFIX>Constant *)%s' % name)
			src += '    static <PREFIX>Constant *constantObj;'
			src += '    if (!constantObj)'
			src += '        constantObj = [<PREFIX>Constant constantWithName: @"%s" type: %s code: %s];' % (
					name, kind == kType and 'typeType' or 'typeEnumerated', _formatcode(code))
			src += '    return constantObj;'
			src.endmethod()
		src.endclass()
	
	##

	def render_commands(self, src):
		src.newglue('CommandGlue')
		src.importmacro('<PREFIX>ReferenceRendererGlue.h')
		# add -description support
		src.newclass('<PREFIX>Command', 'ASCommand')
		src.newmethod('- (NSString *)AS_formatObject:(id)obj appData:(id)appData')
		src += '    return [<PREFIX>ReferenceRenderer formatObject: obj appData: appData];'
		src.endmethod()
		src.endclass()
		# render each command class
		for name, (kind, data) in self.referencebyname:
			if kind == kCommand:
				classname = '<PREFIX>' + _capname(name) + 'Command'
				code = data[0]
				params = data[1].items()
				params.sort()
				src.newclass(classname, '<PREFIX>Command')
				for paramname, paramcode in params:
					src.newmethod('- (%s *)%s:(id)value' % (classname, paramname))
					src += '    [AS_event setParameter: value forKeyword: %s];' % _formatcode(paramcode)
					src += '    return self;\n'
					src.endmethod()
				src.newmethod('- (NSString *)AS_commandName')
				src += '    return @"%s";' % name
				src.endmethod()
				if params:
					src.newmethod('- (NSString *)AS_parameterNameForCode:(DescType)code')
					src += '    switch (code) {'
					for paramname, paramcode in params:
						src += '        case %s:' % _formatcode(paramcode)
						src += '            return @"%s";' % paramname
					src += '    }'
					src += '    return [super AS_parameterNameForCode: code];'
					src += '}\n'
				src.endclass()

	##
	
	def render_reference(self, src):
		src.newglue('ReferenceGlue')
		src.importmacro('<PREFIX>CommandGlue.h')
		src.importmacro('<PREFIX>ReferenceRendererGlue.h')
		for name in ['App', 'Con', 'Its']:
			src.definemacro('<PREFIX>%s' % name, 
					'(<PREFIX>Reference *)[<PREFIX>Reference referenceWithAppData: nil aemReference: AEM%s]' % name)
		src.newclass('<PREFIX>Reference', 'ASReference')
		# add +app, +con, +its methods so that scripting languages can easily use glues via BridgeSupport
		src.comment('+app, +con, +its methods can be used in place of <PREFIX>App, <PREFIX>Con, <PREFIX>Its macros')
		for name in ['App', 'Con', 'Its']:
			src.newmethod('+ (<PREFIX>Reference *)%s' % name.lower())
			src += '    return [self referenceWithAppData: nil aemReference: AEM%s];' % name
			src.endmethod()
		src.comment('*********************************')
		# add -description support
		src.newmethod('- (NSString *)description')
		src += '    return [<PREFIX>ReferenceRenderer formatObject: AS_aemReference appData: AS_appData];'
		src.endmethod()
		# add dictionary-defined property, element and command methods
		prevkind = None
		for name, (kind, data) in self.referencebyname:
			if kind != prevkind:
				src.comment({kCommand: 'Commands', kProperty: 'Properties', kElement: 'Elements'}[kind])
			prevkind = kind
			if kind == kCommand:
				classname = '<PREFIX>' + _capname(name) + 'Command'
				for directParam in ['', ':(id)directParameter']:
					src.newmethod('- (%s *)%s%s' % (classname, name, directParam))
					code = data[0]
					src += '    return [%s commandWithAppData: AS_appData' % classname
					src += '                         eventClass: %s' % _formatcode(code[:4])
					src += '                            eventID: %s' % _formatcode(code[4:])
					src += '                    directParameter: %s' % (directParam and 'directParameter' or 'kASNoDirectParameter')
					src += '                    parentReference: self];'
					src.endmethod()
			else:
				src.newmethod('- (<PREFIX>Reference *)%s' % name)
				src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
				src += '                    aemReference: [AS_aemReference %s: %s]];' % (
						{kProperty: 'property', kElement: 'elements'}[kind], _formatcode(data))
				src.endmethod()
		# add selector methods (-byIndex, -byName, etc.)
		src.comment('*********************************')
		#
		src.comment('ordinal selectors')
		for methodname in ['first', 'middle', 'last', 'any']:
			src.newmethod('- (<PREFIX>Reference *)%s' % methodname)
			src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
			src += '                                 aemReference: [AS_aemReference %s]];' % methodname
			src.endmethod()
		#
		src.comment('by-index, by-name, by-id selectors')
		for methodname, type, var in [('at', 'long', 'index'), ('byIndex', 'id', 'index'), ('byName', 'id', 'name'), ('byID', 'id', 'id_')]:
			src.newmethod('- (<PREFIX>Reference *)%s:(%s)%s' % (methodname, type, var))
			src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
			src += '                                 aemReference: [AS_aemReference %s: %s]];' % (methodname, var)
			src.endmethod()
		#
		src.comment('by-relative-position selectors')
		for methodname, type, var in [('previous', 'ASConstant *', 'class_'), ('next', 'ASConstant *', 'class_')]:
			src.newmethod('- (<PREFIX>Reference *)%s:(%s)%s' % (methodname, type, var))
			src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
			src += '                                 aemReference: [AS_aemReference %s: [%s AS_code]]];' % (methodname, var)
			src.endmethod()
		#
		src.comment('by-range selector')
		src.newmethod('- (<PREFIX>Reference *)at:(long)fromIndex to:(long)toIndex')
		src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
		src += '                                 aemReference: [AS_aemReference at: fromIndex to: toIndex]];'
		src.endmethod()
		src.newmethod('- (<PREFIX>Reference *)byRange:(id)fromObject to:(id)toObject')
		src += '    // takes two con-based references, with other values being expanded as necessary'
		src += '    if ([fromObject isKindOfClass: [<PREFIX>Reference class]])'
		src += '        fromObject = [fromObject AS_aemReference];'
		src += '    if ([toObject isKindOfClass: [<PREFIX>Reference class]])'
		src += '        toObject = [toObject AS_aemReference];'
		src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
		src += '                                 aemReference: [AS_aemReference byRange: fromObject to: toObject]];'
		src.endmethod()
		#
		src.comment('by-test selector')
		src.newmethod('- (<PREFIX>Reference *)byTest:(<PREFIX>Reference *)testReference')
		src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
		src += '                    aemReference: [AS_aemReference byTest: [testReference AS_aemReference]]];'
		src.endmethod()
		#
		src.comment('insertion location selectors')
		for methodname in ['beginning', 'end', 'before', 'after']:
			src.newmethod('- (<PREFIX>Reference *)%s' % methodname)
			src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
			src += '                                 aemReference: [AS_aemReference %s]];' % methodname
			src.endmethod()
		#
		src.comment('Comparison and logic tests')
		for methodname in ['greaterThan', 'greaterOrEquals', 'equals', 'notEquals', 'lessThan', 'lessOrEquals', 'beginsWith', 'endsWith', 'contains', 'isIn']:
			src.newmethod('- (<PREFIX>Reference *)%s:(id)object' % methodname)
			src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
			src += '                                 aemReference: [AS_aemReference %s: object]];' % methodname
			src.endmethod()
		#
		for methodname in ['AND', 'OR']:
			src.newmethod('- (<PREFIX>Reference *)%s:(id)remainingOperands' % methodname)
			src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
			src += '                                 aemReference: [AS_aemReference %s: remainingOperands]];' % methodname
			src.endmethod()
		#
		src.newmethod('- (<PREFIX>Reference *)NOT')
		src += '    return [<PREFIX>Reference referenceWithAppData: AS_appData'
		src += '                                 aemReference: [AS_aemReference NOT]];'
		src.endmethod()
		src.endclass()

	##
	
	def render_application(self, src):
		src.newglue('ApplicationGlue')
		src.importmacro('<PREFIX>ConstantGlue.h')
		src.importmacro('<PREFIX>ReferenceGlue.h')
		src.newclass('<PREFIX>Application', '<PREFIX>Reference')
		# private initialiser
		src.comment('note: clients shouldn\'t need to call -initWithTargetType:data: themselves')
		src.newmethod('- (id)initWithTargetType:(ASTargetType)targetType_ data:(id)targetData_')
		src += '    ASAppData *appData;\n'
		src += '    appData = [[ASAppData alloc] initWithApplicationClass: [AEMApplication class]'
		src += '                                            constantClass: [<PREFIX>Constant class]'
		src += '                                           referenceClass: [<PREFIX>Reference class]'
		src += '                                               targetType: targetType_'
		src += '                                               targetData: targetData_];'
		src += '    self = [super initWithAppData: appData aemReference: AEMApp];'
		src += ''
		src += '    if (!self) return self;'
		if self._osaxloader:
			src += self._osaxloader
		src += '    return self;'
		src.endmethod()
		# public constructors
		src.comment('initialisers')
		src.newmethod('+ (id)application')
		src += '    return [[[self alloc] init] autorelease];'
		src.endmethod()
		for name, call in [
				('+ (id)applicationWithName:(NSString *)name', 'initWithName: name'), 
				('+ (id)applicationWithBundleID:(NSString *)bundleID', 'initWithBundleID: bundleID'),
				('+ (id)applicationWithURL:(NSURL *)url', 'initWithURL: url'),
				('+ (id)applicationWithPID:(pid_t)pid', 'initWithPID: pid'),
				('+ (id)applicationWithDescriptor:(NSAppleEventDescriptor *)desc', 'initWithDescriptor: desc')]:
			src.newmethod(name)
			src += '    return [[[self alloc] %s] autorelease];' % call
			src.endmethod()
		src.newmethod('- (id)init')
		src += '    return [self initWithTargetType: kASTargetCurrent data: nil];'
		src.endmethod()
		for name, target, data in [
				('- (id)initWithName:(NSString *)name', 'kASTargetName', 'name'),
				('- (id)initWithBundleID:(NSString *)bundleID', 'kASTargetBundleID', 'bundleID'),
				('- (id)initWithURL:(NSURL *)url', 'kASTargetURL', 'url'),
				('- (id)initWithPID:(pid_t)pid', 'kASTargetPID', '[NSNumber numberWithUnsignedLong: pid]'),
				('- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc', 'kASTargetDescriptor', 'desc')]:
			src.newmethod(name)
			src += '    return [self initWithTargetType: %s data: %s];' % (target, data)
			src.endmethod()
		src.comment('misc')
		src.newmethod('- (<PREFIX>Reference *)AS_referenceWithObject:(id)object')
		src += '    if ([object isKindOfClass: [<PREFIX>Reference class]])'
		src += '        return [[[<PREFIX>Reference alloc] initWithAppData: AS_appData'
		src += '                aemReference: [object AS_aemReference]] autorelease];'
		src += '    else if ([object isKindOfClass: [AEMQuery class]])'
		src += '        return [[[<PREFIX>Reference alloc] initWithAppData: AS_appData'
		src += '                aemReference: object] autorelease];'
		src += '    else if (!object)'
		src += '        return [[[<PREFIX>Reference alloc] initWithAppData: AS_appData'
		src += '                aemReference: AEMApp] autorelease];'
		src += '    else'
		src += '        return [[[<PREFIX>Reference alloc] initWithAppData: AS_appData'
		src += '                aemReference: AEMRoot(object)] autorelease];'
		src.endmethod()
		src.endclass()
	
	##
	
	def render_referencerenderer(self, src):
		src.newglue('ReferenceRendererGlue')
		src.newclass('<PREFIX>ReferenceRenderer', 'ASReferenceRenderer')
		for methodname, codeprefix in [('property', kProperty), ('element', kElement)]:
			src.newmethod('- (NSString *)%sByCode:(OSType)code' % methodname)
			src += '    switch (code) {'
			for code, (_, name) in self.referencebycode:
				if code[0] == codeprefix:
					src += '        case %s: return @"%s";' % (_formatcode(code[1:]), name)
			src += '        default: return nil;'
			src += '    }'
			src.endmethod()
		src.newmethod('- (NSString *)prefix')
		src += '    return @"<PREFIX>";'
		src.endmethod()
		src.endclass()
	
	##
	
	def _renderaemconstant(self, type, name, code, src):
		src.writeh('    %s<PREFIX>%s = %s,' % (type, _capname(name), _formatcode(code)))
	
	def render_aemheader(self, src):
		src.newglue('AEMConstants', False)
		src.comment('Types, enumerators, properties')
		src.writeh('enum {')
		for name, (kind, code) in self.typebyname:
			self._renderaemconstant('k', name, code, src)
		src.writeh('};\n')
		src.writeh('enum {')
		for name, (kind, data) in self.referencebyname:
			if kind != kCommand:
				self._renderaemconstant(kind, name, data, src)
		src.writeh('};\n')
		src.comment('Events')
		knownparams = set()
		for name, (kind, data) in self.referencebyname:
			if kind == kCommand:
				src.writeh('enum {')
				code = data[0]
				self._renderaemconstant('ec', name, code[:4], src)
				self._renderaemconstant('ei', name, code[4:], src)
				params = data[1].items()
				params.sort()
				for name, code in params:
					if name in knownparams:
						src.writeh('//  %s<PREFIX>%s = %s,' % ('ep', _capname(name), _formatcode(code)))
					else:
						knownparams.add(name)
						self._renderaemconstant('ep', name, code, src)
				src.writeh('};\n')
	
	##
	
	def render_header(self, src):
		src.newglue('Glue', False)
		src.importmacro('<PREFIX>ApplicationGlue.h')
		src.importmacro('<PREFIX>CommandGlue.h')
		src.importmacro('<PREFIX>ConstantGlue.h')
		src.importmacro('<PREFIX>ReferenceGlue.h')
		src.importmacro('<PREFIX>ReferenceRendererGlue.h')


class OSAXClassBuilder(ClassBuilder):

	_osaxloader = '\n'.join([
			'    // make sure osaxen are loaded',
			'    static int isReady = 0;',
			'    if (!isReady) {',
			'        isReady = 1;',
			'        AEMApplication *targetApp = [[self AS_appData] targetWithError: nil];',
			'	[[targetApp eventWithEventClass: kASAppleScriptSuite eventID: kGetAEUT] send];',
			'    }'])


######################################################################


class GlueRenderer:

	_terminologytablebuilder = TerminologyTableBuilder('objc-appscript')

	def __init__(self, outdir, prefix):
		self._outdir = outdir
		self._prefix = prefix
		
	def _render(self, apppath, builder):
		for attrname in dir(builder):
			if attrname.startswith('render_'):
				renderer = ImplementationRenderer(apppath, self._outdir, self._prefix)
				getattr(builder, attrname)(renderer)
	
	##
	
	def renderappaetes(self, apppath, aetes):
		self._render(apppath, ClassBuilder(self._terminologytablebuilder.tablesforaetes(aetes)))
	
	def renderosaxaetes(self, osaxpath, aetes):
		self._render(osaxpath, OSAXClassBuilder(self._terminologytablebuilder.tablesforaetes(aetes)))
	
	def renderappglue(self, appname):
		apppath = aem.findapp.byname(appname)
		self._render(apppath, ClassBuilder(self._terminologytablebuilder.tablesforapp(aem.Application(apppath))))
	
	def renderosaxglue(self, osaxname):
		if not osaxname.startswith('/'):
			osaxname = _findosax(osaxname)
		try:
			aete = aem.ae.GetAppTerminology(osaxname)[0]
		except aem.MacOSError, e:
			if e.args[0] == -192:
				print >> sys.stderr, "No terminology found for osax: %s" % osaxname
				sys.exit()
		self._render('[%s]' % osaxname, OSAXClassBuilder(self._terminologytablebuilder.tablesforaetes([aete])))
	
	def renderdefaultglue(self):
		self._render('<default terminology>', ClassBuilder(self._terminologytablebuilder.tablesforaetes([])))



def prefixfromname(name):
	prefix = getconverter('objc-appscript')(name)
	return prefix[0].upper() + prefix[1:]


######################################################################

######################################################################
# parse argv

def renderwithargv(argv):
	opts, args = getopt.getopt(argv[1:], 'hvo:p:x:')
	opts = dict(opts)
	
	
	if opts.has_key('-v'):
		print __version__
		sys.exit()
	
	if opts.has_key('-h'):
		print """osaglue -- Generate .h and .m glue files for objc-appscript.
	
	SYNOPSIS
	
	    osaglue [-hvx] [-o output-directory] [-p prefix] [-x osax-name] [application-name]
	
	DESCRIPTION
	
	The -h option prints this help and exits immediately.
	
	The -v option prints osaglue's version number and exits immediately.
	
	The -o option may be used to specify the directory to which the glue files
	should be written. If the directory doesn't already exist, one is created.
	If omitted, the glue files are written to the current directory.
	
	The prefix argument, -p, is prepended to the names of all glue files and classes.
	Developers should specify a unique prefix that won't cause namespace conflicts
	in their project. If omitted, the application name is used instead.
	
	If the -x argument is given, it must be the name of an installed scripting addition
	or the full path to a scripting addition at any location. In this case, osaglue will
	generate glue files containing the terminology for that scripting addition, allowing
	its commands to be invoked within a given (usually current) application.
	
	The application-name argument may be the name or full path of the application
	for which glues should be generated. If omitted, the resulting glue files will
	contain only the default terminology provided by appscript.
	
	EXAMPLES
	
	To generate TEGlue.h and associated files for TextEdit:
	
	    osaglue -o TEGlue -p TE TextEdit
	    
	"""
		sys.exit()
	
	
	outdir = opts.get('-o', '')
	
	if opts.has_key('-p'):
		prefix = opts['-p']
	elif args:
		prefix = prefixfromname(args[0])
	else:
		prefix = 'ASDefault'
	
	if outdir and not os.path.exists(outdir):
		os.makedirs(outdir)
		
	osaxname = opts.get('-x', '')
	
	renderer = GlueRenderer(outdir, prefix)
	if osaxname:
		renderer.renderosaxglue(osaxname)
	elif args:
		renderer.renderappglue(args[0])
	else:
		renderer.renderdefaultglue()


if __name__ == '__main__':
	renderwithargv(sys.argv)

