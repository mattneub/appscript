#!/usr/local/bin/python2.4

import struct
from CarbonX import kAE
import appscript, aem, macfile
import appscript.reference
from aem.send import PSN


_standardCodecs = aem.Codecs()

_appCache = {}


def _pathToAppByPSN(hi, lo):
	hiPSN, loPSN, fsref = PSN.GetNextProcess(0, 0)
	while (hiPSN, loPSN) != (hi, lo):
	        hiPSN, loPSN, fsref = PSN.GetNextProcess(hiPSN, loPSN)
	return macfile.File.makewithfsref(fsref).path


def _unpackEventAttributes(event):
	atts = []
	for code in [aem.k.EventClass, aem.k.EventID, aem.k.Address]:
		atts.append(_standardCodecs.unpack(event.AEGetAttributeDesc(code, kAE.typeWildCard)))
	return atts[0].code + atts[1].code, atts[2]


def makeCustomSendProc(out, origSendProc):
	def customSendProc(event, modeFlags, priority, timeout):
		args = []
		# unpack required attributes
		eventcode, target = _unpackEventAttributes(event)
		try:
			# get app instance and associated data
			if not _appCache.has_key((target.type, target.data)):
				if target.type != kAE.typeProcessSerialNumber:
					raise OSAError(10000, "Can't identify application (target descriptor not typeProcessSerialNumber)")
				app = appscript.app(_pathToAppByPSN(*struct.unpack('LL', target.data)))
				appData = app.AS_appdata
				commandsbycode = dict([(data[1][0], (name, 
						dict([(v, k) for (k, v) in data[1][-1].items()])
						)) for (name, data) in appData.referencebyname.items() if data[0] == 'c'])
				_appCache[(target.type, target.data)] = (app, appData, commandsbycode)
			app, appData, commandsbycode = _appCache[(target.type, target.data)]
			# unpack parameters
			params = appData.unpack(event.AECoerceDesc(kAE.typeAERecord))
			resultType = params.pop(aem.AEType('rtyp'), None)
			directParam = params.pop(aem.AEType('----'), None)
			# apply special cases
			if eventcode == 'corecrel' and params.has_key(aem.AEType('insh')):
				# Special case: if 'make' command has an 'at' parameter, use 'at' parameter as target reference
				target = params.pop(aem.AEType('insh'))
			elif eventcode == 'coresetd':
				# Special case: for 'set' command, use direct parameter as target reference and use 'to' parameter for direct argument
				target = directParam
				directParam = params.pop(aem.AEType('data'))
			elif isinstance(directParam, appscript.reference.Reference):
				# Special case: if direct parameter is a reference, use this as target reference
				target = directParam
				directParam = None
			else:
				target = app
			# build command and arguments list
			commandName, argNames = commandsbycode[eventcode]
			if directParam is not None:
				args.append(`directParam`)
			for key, val in params.items():
				args.append('%s=%r' % (argNames[key.code], val))
			if resultType:
				args.append('resulttype=%r' % resultType)
			if modeFlags & kAE.kAEWaitReply != kAE.kAEWaitReply:
				args.append('waitreply=False')
			if timeout != -1:
				args.append('timeout=%i' % (timeout / 60))
			# result!
			out('%r.%s(%s)' % (target, commandName, ', '.join(args)))
		except Exception, e:
			import traceback
			traceback.print_exc()
			out('Untranslated event %r' % eventcode)
		# let Apple event execute as normal
		return origSendProc(event, modeFlags, priority, timeout)
	return customSendProc


if __name__ == '__main__':
	
	import osascript, sys
	_ci = osascript.Interpreter()
	scpt = _ci.newscript()
	scpt.setruncallbacks(send=makeCustomSendProc(sys.stdout.write, _ci.componentcallbacks()[2]))
	scpt.compile('''
	--ignoring application responses
	with timeout of 20 seconds
	--tell app "Finder" to get folder 1 of home as alias
	
	--tell app "textedit" to get end of documents
	
	--tell app "textedit" to make new document at end of documents --with properties {text:"hello"}
	
	--tell app "finder" to get name of every folder of home whose name starts with "m" or name starts with "d"
	
	--tell app "finder" to get items (folder "Documents") thru (file -2) of folder "has" of folder "users" of startup disk
	
	--tell app "finder" to get items "Documents" thru -2 of home
	
	--tell app "textedit" to get words (word 3) thru (word 5) of document 1
	
	tell application "TextEdit" to make document
	
	end
	--end
	''')
	scpt.run()

