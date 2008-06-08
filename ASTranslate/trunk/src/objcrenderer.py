#!/usr/bin/python

from struct import unpack

import aem
from appscript import terminology

import Foundation
import objc
objc.loadBundle("Appscript", globals(), 
   bundle_path=objc.pathForFramework(u'/Library/Frameworks/Appscript.framework')) # TO DO: sort path
del objc


_appCache = {}

#######

class ObjCReferenceRenderer(ASReferenceRenderer):
	
	# TO DO: since desired prefix codes aren't known in advance and ASReferenceRenderer's current API is a pain to extend at runtime, just use default 'AS' prefix for now and make user-configurable later on
	
	terms = None # to be set externally (kludge)
	
	def propertyByCode_(self, code):
		return terms[unpack('L', code)[0]][1]
	
	def elementByCode_(self, code):
		return terms[unpack('L', code)[0]][1]


#######

def renderCommand(appPath, addressdesc, eventcode, 
		targetRef, directParam, params, 
		resultType, modeFlags, timeout, 
		appData):
	
	if not _appCache.has_key((addressdesc.type, addressdesc.data)):
		terms = terminology.tablesforapp(aem.Application(desc=addressdesc))
		_appCache[(addressdesc.type, addressdesc.data)] = (terms)
	typebycode, typebyname, referencebycode, referencebyname = _appCache[(addressdesc.type, addressdesc.data)]
	ObjCReferenceRenderer.terms = referencebycode
	
	# TO DO: need to convert params to AEM/Cocoa values, probably by packing as AEDesc with aem.Codecs, wrapping as NSAppleEventDescriptor, and unpacking with AEMCodecs
	
	try:
		return 'TO DO' # > %r' % ObjCReferenceRenderer.render_(targetRef)
	except Exception, e:
		return str(e)
