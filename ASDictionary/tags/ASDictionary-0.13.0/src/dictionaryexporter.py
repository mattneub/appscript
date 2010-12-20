""" dictionaryexporter -- Dictionary export function and corresponding Apple event handler. """

import os

from AppKit import *

from aem import *
from aemreceive import *
from osaterminology import makeidentifier
from osaterminology.dom import aeteparser, sdefparser
from osaterminology.makeglue import objcappscript
from osaterminology.renderers import quickdoc, htmldoc, htmldoc2


######################################################################
# PRIVATE
######################################################################


kStyleToSuffix = {
		'applescript': '-AS',
		'py-appscript': '-py', 
		'rb-appscript': '-rb', 
		'objc-appscript': '-objc',
}


def _makeDestinationFolder(outFolder, styleSubfolderName, formatSubfolderName, fileName):
	destFolder = os.path.join(outFolder, styleSubfolderName, formatSubfolderName or '')
	if not os.path.exists(destFolder):
		os.makedirs(destFolder)
	return os.path.join(destFolder, fileName)


######################################################################
# define handler for 'export dictionaries' events # TO DO: junk this?

kPlainText = 'PTex'
kSingleHTML = 'SHTM'
kFrameHTML = 'FHTM'
kObjCGlue = 'OCGl'
kASStyle = 'AScr'
kPyStyle = 'PyAp'
kRbStyle = 'RbAp'
kObjCStyle = 'OCAp'

kAECodeToStyle = {
	kASStyle: 'applescript',
	kPyStyle: 'py-appscript',
	kRbStyle: 'rb-appscript',
	kObjCStyle: 'objc-appscript',
}

class AEProgress:

	kClassKey = AEType('pcls')
	kClassValue = AEType('ExpR')
	#kNameKey = AEType('pnam')
	kSuccessKey = AEType('Succ')
	kSourceKey = AEType('Sour')
	kDestKey = AEType('Dest')
	kErrorKey = AEType('ErrS')
	kMissingValue = AEType('msng')

	def __init__(self, itemcount, stylecount, formatcount, controller):
		self._results = []

	def shouldcontinue(self):
		return True
		
	def nextitem(self, name, inpath):
		self._results.append({
				self.kClassKey:self.kClassValue,
				#self.kNameKey:name, 
				self.kSourceKey:mactypes.File(inpath)})
	
	def nextoutput(self, outpath):
		self._results[-1][self.kDestKey] = mactypes.File(outpath)
		
	def didsucceed(self):
		self._results[-1][self.kSuccessKey] = True
		self._results[-1][self.kErrorKey] = self.kMissingValue
		
	def didfail(self, errormessage):
		self._results[-1][self.kSuccessKey] = False
		self._results[-1][self.kDestKey] = self.kMissingValue
		self._results[-1][self.kErrorKey] = errormessage
	
	def didfinish(self):
		return self._results


def handle_exportdictionaries(sources, outfolder, 
		fileformats=[AEEnum(kFrameHTML)], styles=[AEEnum(kASStyle)],
		compactclasses=False, showinvisibles=False, usesubfolders=False):
	items = []
	for alias in sources:
		name = os.path.splitext(os.path.basename(alias.path.rstrip('/')))[0]
		items.append({
			'objcPrefix': objcappscript.nametoprefix(name),
			'name': name, 
			'path': alias.path,
			})
	outfolder = outfolder.path
	plaintext = AEEnum(kPlainText) in fileformats
	singlehtml = AEEnum(kSingleHTML) in fileformats
	framehtml = AEEnum(kFrameHTML) in fileformats
	isobjcglue = AEEnum(kObjCGlue) in fileformats
	styles = [kAECodeToStyle[o.code] for o in styles]
	options = []
	if compactclasses:
		options.append('collapse')
	if showinvisibles:
		options.append('full')
	progressobj = AEProgress(len(items), len(styles), len(fileformats), None)
	return export(items, styles, plaintext, singlehtml, framehtml, isobjcglue, options, outfolder, usesubfolders, progressobj)


def aetesforapp(aemapp):
	"""Get aetes from local/remote app via an ascrgdte event; result is a list of byte strings."""
	try:
		aetes = aemapp.event('ascrgdte', {'----':0}).send(5 * 60) # some processes (e.g. AppleSpell.service, ARDAgent.app) don't respond to ascrgdte events, so keep timeout interval short and ignore timeout errors
	except Exception, e: # (e.g.application not running)
		if isinstance(e, EventError) and e.errornumber in [-192, -609, -1712]:
			aetes = []
		else:
			raise RuntimeError("Can't get terminology for application (%r): %s" % (aemapp, e))
	if not isinstance(aetes, list):
		aetes = [aetes]
	return [aete for aete in aetes if isinstance(aete, ae.AEDesc) and aete.type == kae.typeAETE and aete.data]


######################################################################
# PUBLIC
######################################################################


def export(items, styles, plainText, singleHTML, frameHTML, objcGlue, options, outFolder, exportToSubfolders, progress):
	styleInfo = [(style, kStyleToSuffix[style]) for style in styles]
	# process each item
	for i, item in enumerate(items):
		sdef = aetes = None
		objcPrefix, name, path = item['objcPrefix'], item['name'], item['path']
		if path == NSBundle.mainBundle().bundlePath():
			continue
		progress.nextitem(name, path)
		try:
			isOSAX = path.lower().endswith('.osax')
			if isOSAX:
				try:
					sdef = ae.copyscriptingdefinition(path)
				except ae.MacOSError, e:
					if e.args[0] == -10827:
						progress.didfail(u"No terminology found.")
						continue
					else:
						raise
			else:
				Application
				aetes = aetesforapp(Application(path))
			if not bool(sdef or aetes):
				progress.didfail(u"No terminology found.")
				continue
			for style, suffix in styleInfo:
				styleSubfolderName = exportToSubfolders and style or ''
				if not progress.shouldcontinue():
					for item in items[i:]:
						progress.didfail(u"User cancelled.")
						progress.nextapp(item['name'], item['path'])
					progress.didfail(u"User cancelled.")
					progress.didfinish()
					return
				if plainText and not isOSAX:
					outputPath = _makeDestinationFolder(outFolder, styleSubfolderName, 
							exportToSubfolders and 'text', name + suffix + '.txt')
					progress.nextoutput(u'%s' % outputPath)
					f = file(outputPath, 'w')
					try:
						f.write('\xEF\xBB\xBF') # UTF8 BOM
						quickdoc.renderaetes(aetes, f, makeidentifier.getconverter(style))
					except:
						f.close()
						raise
					f.close()
				if singleHTML or frameHTML:
					if isOSAX:
						terms = sdefparser.parsexml(sdef, path, style)
					else:
						terms = aeteparser.parseaetes(aetes, path, style)
					if singleHTML:
						outputPath = _makeDestinationFolder(outFolder, styleSubfolderName, 
								exportToSubfolders and 'html', name + suffix + '.html')
						progress.nextoutput(u'%s' % outputPath)
						html = htmldoc.renderdictionary(terms, style, options)
						f = open(outputPath, 'w')
						f.write(str(html))
						f.close()
					if frameHTML:
						outputPath = _makeDestinationFolder(outFolder, styleSubfolderName, 
								exportToSubfolders and 'frame-html', name + suffix)
						progress.nextoutput(u'%s' % outputPath)
						htmldoc2.renderdictionary(terms, outputPath, style, options)
			if objcGlue and not isOSAX:
				outputPath = _makeDestinationFolder(outFolder, 
						exportToSubfolders and 'objc-appscript' or '', 
						'%s%sGlue' % (exportToSubfolders and 'glues/' or '', objcPrefix), '')
				objcappscript.makeappglue(path, objcPrefix, outputPath, aetes)
				progress.nextoutput(u'%s' % outputPath)
		except Exception, err:
			from traceback import format_exc
			progress.didfail(u'Unexpected error:/n%s' % format_exc())
		else:
			progress.didsucceed()
	return progress.didfinish()


#######


def init():
	installeventhandler(handle_exportdictionaries, 'ASDiExpD',
			('----', 'sources', ArgListOf(kae.typeAlias)),
			('ToFo', 'outfolder', kae.typeAlias),
			('Form', 'fileformats', ArgListOf(ArgEnum(kPlainText, kSingleHTML, kFrameHTML, kObjCGlue))),
			('Styl', 'styles', ArgListOf(ArgEnum(kASStyle, kPyStyle, kRbStyle, kObjCStyle))),
			('ClaC', 'compactclasses', kae.typeBoolean),
			('SInv', 'showinvisibles', kae.typeBoolean),
			('SubF', 'usesubfolders', kae.typeBoolean))
