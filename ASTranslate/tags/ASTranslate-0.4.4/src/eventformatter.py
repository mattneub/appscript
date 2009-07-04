#!/usr/bin/python

import struct, traceback

from Foundation import NSUserDefaults

from aem import kae, ae
import appscript, aem, mactypes
import appscript.reference

import pythonrenderer, rubyrenderer, objcrenderer


_userDefaults = NSUserDefaults.standardUserDefaults()

_standardCodecs = aem.Codecs()

_appCache = {}

#######
# constants

kLanguageCount = 3

# (note: these are same as indexes of segmented control in window)
kPython = 0
kRuby = 1
kObjC = 2

kAll = None


#######

def _unpackEventAttributes(event):
	atts = []
	for code in [kae.keyEventClassAttr, kae.keyEventIDAttr, kae.keyAddressAttr]:
		atts.append(_standardCodecs.unpack(event.getattr(code, kae.typeWildCard)))
	return atts[0].code + atts[1].code, atts[2]


def makeCustomSendProc(addResultFn, origSendProc):
	def customSendProc(event, modeFlags, priority, timeout):
		# unpack required attributes
		try:
			eventcode, addressdesc = _unpackEventAttributes(event)
			appPath = ae.addressdesctopath(addressdesc)
			
			# get app instance and associated data
			if not _appCache.has_key((addressdesc.type, addressdesc.data)):
				if addressdesc.type != kae.typeProcessSerialNumber:
					raise OSAError(10000, 
							"Can't identify application (addressdesc descriptor not typeProcessSerialNumber)")
				app = appscript.app(appPath)
				appData = app.AS_appdata
				
				_appCache[(addressdesc.type, addressdesc.data)] = (app, appData)
			app, appData = _appCache[(addressdesc.type, addressdesc.data)]
			
			# unpack parameters
			desc = event.coerce(kae.typeAERecord)
			params = {}
			for i in range(desc.count()):
				key, value = desc.getitem(i + 1, kae.typeWildCard)
				params[key] = appData.unpack(value)
			resultType = params.pop('rtyp', None)
			directParam = params.pop('----', None)
			try:
				subject = appData.unpack(event.getattr(kae.keySubjectAttr, kae.typeWildCard))
			except Exception:
				subject = None
			
			# apply special cases
			if subject is not None:
				targetRef = subject
			elif eventcode == 'coresetd':
				# Special case: for 'set' command, use direct parameter as target reference and use 'to' parameter for direct argument
				targetRef = directParam
				directParam = params.pop('data')
			elif isinstance(directParam, appscript.reference.Reference):
				# Special case: if direct parameter is a reference, use this as target reference
				targetRef = directParam
				directParam = None
			else:
				targetRef = app
			
			# render
			for key, renderer in [(kPython, pythonrenderer), (kRuby, rubyrenderer), (kObjC, objcrenderer)]:
				try:
					addResultFn(key, renderer.renderCommand(
							appPath, addressdesc, eventcode, 
							targetRef, directParam, params, 
							resultType, modeFlags, timeout, 
							appData))
				except Exception, e:
					traceback.print_exc()
					s = 'Untranslated event %r' % eventcode
					addResultFn(key, s)

		except Exception, e:
			traceback.print_exc()
			s = 'Untranslated event %r' % eventcode
			addResultFn(kAll, s)
		
		# let Apple event execute as normal, if desired
		if _userDefaults.boolForKey_('sendEvents'):
			return origSendProc(event, modeFlags, priority, timeout)
		else:
			return ae.newdesc(kae.typeNull, '')
	return customSendProc

