"""ASDictionary -- Render application terminology in plain text or appscript/AppleScript HTML format, or dump raw aete resources to file.

(C) 2005 HAS

"""

from os import mkdir
from os.path import basename, splitext, join, exists
from sys import argv, stderr
from traceback import print_exc
from EasyDialogs import ProgressBar

import osax
from osaterminology.renderers import quickdoc
from osaterminology.getterminology import getaete
from osaterminology.renderers import htmldoc

#######
# MAIN

# supported formats
kRaw = 'raw aete'
kText = 'plain text'
kAppscript = 'Python appscript HTML'
kRbAppscript = 'Ruby appscript HTML'
kAppleScript = 'AppleScript HTML'


#######

def writeRaw(path, outFolder):
	targetFolder = join(outFolder, splitext(basename(path))[0]) + ' aetes' # app may have >1 aetes, so dump them into a single folder
	if not exists(targetFolder):
		mkdir(targetFolder)
	for i, aete in enumerate(getaete(path)):
		f = open(join(targetFolder, str(i)), 'w')
		f.write(aete)
		f.close()
		
		
def writeText(path, outFolder):
	f = file(join(outFolder, splitext(basename(path))[0] + '.txt'), 'w')
	try:
		f.write('\xEF\xBB\xBF') # UTF8 BOM
		quickdoc.app(path, f)
	except:
		f.close()
		raise
	f.close()


#######

try:
	if len(argv) > 1:
		appPaths = argv[1:]
	else:
		appPaths = [alias.path for alias in osax.chooseapp(prompt='Select the application(s) to process:', multiselect=True)]
	outFormat = osax.chooseitems([kRaw, kText, kAppscript, kRbAppscript, kAppleScript], 'Select output formats:', multiselelect=True)
	if (kAppscript in outFormat or kAppleScript in outFormat) and \
			osax.displaydialog('Combine duplicate classes?', ['No', 'Yes'], 'Yes')[0] == 'Yes':
		options = ['collapse']
	else:
		options = []
	outFolder = (osax.choosefolder('Select folder to write the file%s to:' % (len(appPaths) > 1 and 's' or ''))).path
	failedApps = []
	progbar = ProgressBar('Rendering terminology for:', len(appPaths))
	for path in appPaths:
		progbar.label(splitext(basename(path))[0].encode('macroman', 'replace')[:254]) # ProgressBar is kinda Stone Age
		progbar.inc()
		try:
			if not bool(getaete(path)):
				raise RuntimeError, "no terminology found"
			# Dump aetes	
			if kRaw in outFormat:
				writeRaw(path, outFolder)
			# Render in quickdoc format
			if kText in outFormat:
				writeText(path, outFolder)
			# Render in HTML format
			userTemplatePath = join(osax.pathto(osax.kApplicationSupport, osax.kUserDomain).path, 'ASDictionary/AppleScriptTemplate.html')
			if not exists(userTemplatePath):
				userTemplatePath = join(osax.pathto(osax.kApplicationSupport).path, 'ASDictionary/Template.html')
			if exists(userTemplatePath):
				f = open(userTemplatePath)
				userTemplateHTML = f.read()
				f.close()
			else:
				userTemplateHTML = None
			if kAppscript in outFormat:
				htmldoc.doc(path, join(outFolder, splitext(basename(path))[0] + ' py.html') , 'py-appscript', options, userTemplateHTML)
			if kRbAppscript in outFormat:
				htmldoc.doc(path, join(outFolder, splitext(basename(path))[0] + ' rb.html') , 'rb-appscript', options, userTemplateHTML)
			if kAppleScript in outFormat:
				htmldoc.doc(path, join(outFolder, splitext(basename(path))[0] + '.html'), 'applescript', options, userTemplateHTML)
		except Exception, err:
			print >> stderr, "ASDictionary: Can't render terminology for application %r:" % path, err
			print_exc()
			failedApps.append('%s (%s)' % (basename(path), err))
	if failedApps:
		osax.displaydialog("Couldn't render terminology for: " + ', '.join(failedApps), ['OK'], 1, icon=osax.kCaution)
except osax.UserCancelled:
	pass
except Exception, err:
	print >> stderr, "ASDictionary error:", err
	print_exc()
	osax.displayerror("An error occurred: %s" % err)
