
from subprocess import Popen
import traceback
import aem
import AppKit
from Foundation import NSUserDefaults

_userDefaults = NSUserDefaults.standardUserDefaults()

if not _userDefaults.stringForKey_(u'rubyInterpreter'):
	_userDefaults.setObject_forKey_(u'/usr/bin/ruby', u'rubyInterpreter')


_rubyapp = None


def initialize():
	global _rubyapp
	rubypath = _userDefaults.stringForKey_('rubyInterpreter')
	rendererscript = AppKit.NSBundle.mainBundle().pathForResource_ofType_('rubyrenderer', 'rb')
	rubyproc = Popen([rubypath, rendererscript])
	_rubyapp = aem.Application(pid=rubyproc.pid)

def cleanup():
	try:
		_rubyapp.event('aevtquit').send()
	except:
		pass


def renderCommand(appPath, addressdesc, eventcode, 
		targetRef, directParam, params, 
		resultType, modeFlags, timeout, 
		appData):
	if _rubyapp is None:
		return "Ruby translation not available. (Please check a valid ruby interpreter is specified in ASTranslate's preferences.)"
	try:
		return _rubyapp.event('EvntFmt_', {
				'AppP': appPath,
				'Evnt': eventcode,
				'Targ': targetRef,
				'DPar': directParam,
				'KPar': params,
				'RTyp': resultType,
				'Mode': modeFlags,
				'Time': timeout,
				}, codecs=appData).send()
	except aem.CommandError, e:
		if int(e) != -600:
			traceback.print_exc()
		return "Ruby translation not available. (Please check that rb-appscript is installed for the version of ruby specified in ASTranslate's preferences.)"