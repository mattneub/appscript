"""AppscriptHelpAgent -- Provides external support for built-in appscript help systems.

(C) 2007 HAS
"""

from StringIO import StringIO
from threading import Timer

# use Cocoa as CarbonEvt lacks threading (i.e. GIL) support
from PyObjCTools import NibClassBuilder, AppHelper
from AppKit import NSApp

from aemreceive import *
import appscript, aem, CarbonX.AE

from appscript.reference import AppData
from appscript.terminology import aetesforapp
from appscript.helpsystem import Help


__name__ = 'AppscriptHelpAgent'
__version__ = '0.1.0'

#######

_waittime = 60 * 60 # automatically quit after this no. of seconds of inactivity

_cache = {}

_codecs = AppData(aem.Application, 'current', None, True)

#######

NibClassBuilder.extractClasses("MainMenu")

_watchdog = None

def restartwatchdog():
	global _watchdog
	if _watchdog:
		_watchdog.cancel()
	_watchdog = Timer(_waittime, lambda: NSApp().terminate_(None))
	_watchdog.start()

restartwatchdog()

#######

class _AEOMApplication:
	def __init__(self, result):
		self._result = result
	
	def property(self, code):
		self._result['result'] = unicode({'pnam': __name__, 'vers': __version__}[code])


class _AEOMResolver:
	def __init__(self, result):
		self.app = _AEOMApplication(result)


def getd(ref):
	try:
		result = {}
		ref.AEM_resolve(_AEOMResolver(result))
		return result['result']
	except:
		raise EventHandlerError(-1728)
installeventhandler(
		getd,
		'coregetd',
		('----', 'ref', kAE.typeObjectSpecifier)
		)

#######

def help(constructor, identity, style, flags, aemreference): # TO DO: command support
	restartwatchdog()
	id = (constructor, identity, style)
	if id not in _cache:
		if constructor == 'path':
			appobj = appscript.app(identity)
		elif constructor == 'pid':
			appobj = appscript.app(pid=identity)
		elif constructor == 'url':
			appobj = appscript.app(url=identity)
		elif constructor == 'aemapp':
			appobj = appscript.app(aemapp=aem.Application(desc=identity))
		elif constructor == 'current':
			appobj = appscript.app()
		else:
			raise RuntimeError, 'Unknown constructor: %r' % constructor
		output = StringIO()
		aetes = aetesforapp(appobj.AS_appdata.target)
		appobj.AS_appdata.helpobject = Help(aetes, identity or u'Current Application', style, output)
		_cache[id] = (appobj, output)
	ref, output = _cache[id]
	output.truncate(0)
	if aemreference is not None:
		ref = ref.AS_newreference(aemreference)
	ref.help(flags)
	return output.getvalue()

installeventhandler(help,
		'ASHAHelp',
		('Cons', 'constructor', kAE.typeChar),
		('Iden', 'identity', kAE.typeWildCard),
		('Styl', 'style', kAE.typeChar),
		('Flag', 'flags', kAE.typeChar),
		('aRef', 'aemreference', kAE.typeWildCard))

#######

AppHelper.runEventLoop()
