#!/usr/bin/python

import struct, traceback
from CarbonX import kAE, kOSA
import appscript, aem, mactypes
import appscript.reference
from aem.send import PSN


_standardCodecs = aem.Codecs()

_appCache = {}


def _pathToAppByPSN(hi, lo):
	hiPSN, loPSN, fsref = PSN.GetNextProcess(0, 0)
	while (hiPSN, loPSN) != (hi, lo):
	        hiPSN, loPSN, fsref = PSN.GetNextProcess(hiPSN, loPSN)
	return mactypes.File.makewithfsref(fsref).path


def _unpackEventAttributes(event):
	atts = []
	for code in [kAE.keyEventClassAttr, kAE.keyEventIDAttr, kAE.keyAddressAttr]:
		atts.append(_standardCodecs.unpack(event.AEGetAttributeDesc(code, kAE.typeWildCard)))
	return atts[0].code + atts[1].code, atts[2]


def makeCustomSendProc(rubyapp, appendResult, origSendProc):
	def customSendProc(event, modeFlags, priority, timeout):
		args = []
		# unpack required attributes
		try:
			eventcode, target = _unpackEventAttributes(event)
			appPath = _pathToAppByPSN(*struct.unpack('LL', target.data))
			# get app instance and associated data
			if not _appCache.has_key((target.type, target.data)):
				if target.type != kAE.typeProcessSerialNumber:
					raise OSAError(10000, "Can't identify application (target descriptor not typeProcessSerialNumber)")
				app = appscript.app(appPath)
				appData = app.AS_appdata
				commandsbycode = dict([(data[1][0], (name, 
						dict([(v, k) for (k, v) in data[1][-1].items()])
						)) for (name, data) in appData.referencebyname.items() if data[0] == 'c'])
				_appCache[(target.type, target.data)] = (app, appData, commandsbycode)
			app, appData, commandsbycode = _appCache[(target.type, target.data)]
			# unpack parameters
			
			desc = event.AECoerceDesc(kAE.typeAERecord)
			params = {}
			for i in range(desc.AECountItems()):
				key, value = desc.AEGetNthDesc(i + 1, kAE.typeWildCard)
				params[key] = appData.unpack(value)
			resultType = params.pop('rtyp', None)
			directParam = params.pop('----', None)
			
			try:
				subject = appData.unpack(event.AEGetAttributeDesc(kOSA.keySubjectAttr, kAE.typeWildCard))
			except Exception:
				subject = None
			
			# apply special cases
			if subject is not None:
				target = subject
			elif eventcode == 'corecrel' and params.has_key('insh'):
				# Special case: if 'make' command has an 'at' parameter, use 'at' parameter as target reference
				target = params.pop('insh')
			elif eventcode == 'coresetd':
				# Special case: for 'set' command, use direct parameter as target reference and use 'to' parameter for direct argument
				target = directParam
				directParam = params.pop('data')
			elif isinstance(directParam, appscript.reference.Reference):
				# Special case: if direct parameter is a reference, use this as target reference
				target = directParam
				directParam = None
			else:
				target = app
			# Python
			# build command and arguments list
			commandName, argNames = commandsbycode[eventcode]
			if directParam is not None:
				args.append(`directParam`)
			for key, val in params.items():
				args.append('%s=%r' % (argNames[key], val))
			if resultType:
				args.append('resulttype=%r' % resultType)
			if modeFlags & kAE.kAEWaitReply != kAE.kAEWaitReply:
				args.append('waitreply=False')
			if timeout != -1:
				args.append('timeout=%i' % (timeout / 60))
			# Ruby
			try:
				rubystr = rubyapp.event('EvntFmt_', {
						'AppP': appPath,
						'Evnt': eventcode,
						'Targ': target,
						'DPar': directParam,
						'KPar': params,
						'RTyp': resultType,
						'Mode': modeFlags,
						'Time': timeout,
						}, codecs=appData).send()
			except aem.CommandError, e:
				if int(e) != -600:
					traceback.print_exc()
				rubystr = 'Ruby translation not available.'
			# result!
			appendResult('%r.%s(%s)' % (target, commandName, ', '.join(args)), rubystr)
		except Exception, e:
			traceback.print_exc()
			s = 'Untranslated event %r' % eventcode
			appendResult(s, s)
		# let Apple event execute as normal
		return origSendProc(event, modeFlags, priority, timeout)
	return customSendProc


if __name__ == '__main__':
	
	def out(s1, s2):
		sys.stdout.write((s2))

	from subprocess import Popen
	import aem
	
	_rubyproc = Popen(['/usr/bin/ruby', '/Users/has/appscript/ASTranslate/rubyrenderer.rb'])
	_rubyapp = aem.Application(pid=_rubyproc.pid)
	
	
	try:
	
		import osascript, sys
		_ci = osascript.Interpreter()
		scpt = _ci.newscript()
		scpt.setruncallbacks(send=makeCustomSendProc(_rubyapp, out, _ci.componentcallbacks()[2]))
		scpt.compile('''
		--ignoring application responses
		--with timeout of 20 seconds
		
		tell app "Finder" to get folder 1 of home as alias
		
		--tell app "textedit" to get end of documents
		
		--tell app "textedit" to make new document at end of documents --with properties {text:"hello"}
		
		--tell app "finder" to get name of every folder of home whose name starts with "m" or name starts with "d"
		
		--tell app "finder" to get items (folder "Documents") thru (file -2) of folder "has" of folder "users" of startup disk
		
		--tell app "finder" to get items "Documents" thru -2 of home
		
		--tell app "textedit" to get words (word 3) thru (word 5) of document 1
		
		--tell application "TextEdit" to make document
		
		--tell application "RagTime 6" to get note alert text
		
		--end
		--end
		''')
		scpt.run()

	finally:
		_rubyapp.event('aevtquit').send()
	