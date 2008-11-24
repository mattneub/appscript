"""connect - Creates Apple event descriptor records of typeProcessSerialNumber and typeApplicationURL, used to specify the target application in send.Event() constructor.

(C) 2005-2008 HAS
"""
import struct
from time import sleep

import ae, kae

from aemsend import Event

__all__ = ['launchapp', 'processexistsforpath', 'processexistsforpid', 'processexistsforurl', 
		'processexistsfordesc', 'currentapp', 'localapp', 'remoteapp', 'CantLaunchApplicationError']

######################################################################
# PRIVATE
######################################################################

_kLaunchContinue = 0x4000
_kLaunchNoFileFlags = 0x0800
_kLaunchDontSwitch = 0x0200

_kNoProcess = 0
_kCurrentProcess = 2

_nulladdressdesc = ae.newdesc(kae.typeProcessSerialNumber, struct.pack('LL', 0, _kNoProcess)) # ae.newappleevent complains if you pass None as address, so we give it one to throw away

_launchevent = Event(_nulladdressdesc, 'ascrnoop').AEM_event
_runevent = Event(_nulladdressdesc, 'aevtoapp').AEM_event

#######

def _launchapplication(path, event):
	try:
		return ae.launchapplication(path, event,
				_kLaunchContinue + _kLaunchNoFileFlags + _kLaunchDontSwitch)
	except ae.MacOSError, err:
		raise CantLaunchApplicationError(err.args[0], path)


######################################################################
# PUBLIC
######################################################################


class CantLaunchApplicationError(Exception):
	
	_lserrors = {
		# following taken from <http://developer.apple.com/documentation/Carbon/Reference/LaunchServicesReference>:
		-10660: "The application cannot be run because it is inside a Trash folder.",
		-10810: "An unknown error has occurred.",
		-10811: "The item to be registered is not an application.",
		-10813: "Data of the desired type is not available (for example, there is no kind string).",
		-10814: "No application in the Launch Services database matches the input criteria.",
		-10817: "Data is structured improperly (for example, an item's information property list is malformed).",
		-10818: "A launch of the application is already in progress.",
		-10822: "There is a problem communicating with the server process that maintains the Launch Services database.",
		-10823: "The filename extension to be hidden cannot be hidden.",
		-10825: "The application to be launched cannot run on the current Mac OS version.",
		-10826: "The user does not have permission to launch the application (on a managed network).",
		-10827: "The executable file is missing or has an unusable format.",
		-10828: "The Classic emulation environment was required but is not available.",
		-10829: "The application to be launched cannot run simultaneously in two different user sessions.",
	}

	def __init__(self, errornumber, apppath):
		self._number = errornumber
		self._apppath = apppath
		Exception.__init__(self, errornumber, apppath)
	
	number = property(lambda self: self._number) # deprecated; TO DO: remove
	
	errornumber = property(lambda self: self._number, doc="int -- Mac OS error number")
	
	apppath = property(lambda self: self._apppath, doc="str -- application path")
	
	def __int__(self):
		return self._number
	
	def __str__(self):
		return "Can't launch application at %r: %s (%i)" % (self._apppath, self._lserrors.get(self._number, 'OS error'), self._number)


def launchapp(path):
	"""Send a 'launch' event to an application. If application is not already running, it will be launched in background first."""
	try:
		# If app is already running, calling ae.launchapplication will send a 'reopen' event, so need to check for this first:
		pid = ae.pidforapplicationpath(path)
	except ae.MacOSError, err:
		if err.args[0] == -600: # Application isn't running, so launch it and send it a 'launch' event:
			sleep(1)
			_launchapplication(path, _launchevent)
		else:
			raise
	else: # App is already running, so send it a 'launch' event:
		ae.newappleevent('ascr', 'noop', localappbypid(pid), kae.kAutoGenerateReturnID, 
				kae.kAnyTransactionID).send(kae.kAEWaitReply, kae.kAEDefaultTimeout)

##

def processexistsforpath(path):
	"""Does a local process launched from the specified application file exist?
		Note: if path is invalid, a MacOSError is raised.
	"""
	try:
		ae.pidforapplicationpath(path)
		return True
	except ae.MacOSError, err:
		if err.args[0] == -600: 
			return False
		else:
			raise

def processexistsforpid(pid):
	"""Is there a local application process with the given unix process id?"""
	return ae.isvalidpid(pid)

def processexistsforurl(url):
	"""Does an application process specified by the given eppc:// URL exist?
		Note: this will send a 'launch' Apple event to the target application.
	"""
	if ':' not in url: # workaround: process will crash if no colon in URL (OS bug)
		raise ValueError("Invalid url: %r" % url)
	return processexistsfordesc(ae.newdesc(kae.typeApplicationURL, url))

def processexistsfordesc(desc):
	"""Does an application process specified by the given AEAddressDesc exist?
		Returns false if process doesn't exist OR remote Apple events aren't allowed.
		Note: this will send a 'launch' Apple event to the target application.
	"""
	try:
		# This will usually raise error -1708 if process is running, and various errors
		# if the process doesn't exist/can't be reached. If app is running but busy,
		# AESendMessage() may return a timeout error (this should be -1712, but
		# -609 is often returned instead for some reason).
		Event(desc, 'ascrnoop').send()
	except ae.MacOSError, err:
		return err.args[0] not in [-600, -905] # -600 = no process; -905 = no network access
	return True


#######

currentapp = ae.newdesc(kae.typeProcessSerialNumber, struct.pack('LL', 0, _kCurrentProcess))


def localapp(path):
	"""Make an AEAddressDesc identifying a local application. (Application will be launched if not already running.)
		path : string -- full path to application, e.g. '/Applications/TextEdit.app'
		Result : AEAddressDesc
	"""
	# Always create AEAddressDesc by process serial number; that way there's no confusion if multiple versions of the same app are running
	try:
		pid = ae.pidforapplicationpath(path)
	except ae.MacOSError, err:
		if err.args[0] == -600: # Application isn't running, so launch it in background and send it a standard 'run' event.
			sleep(1)
			pid = _launchapplication(path, _runevent)
		else:
			raise
	return localappbypid(pid)


def localappbypid(pid):
	"""Make an AEAddressDesc identifying a local process.
		pid : integer -- Unix process id
		Result : AEAddressDesc
	"""
	return ae.newdesc(kae.typeKernelProcessID, struct.pack('i', pid))


def remoteapp(url):
	"""Make an AEAddressDesc identifying a running application on another machine.
		url : string -- URL for remote application, e.g. 'eppc://user:password@0.0.0.1/TextEdit'
		Result : AEAddressDesc
	"""
	if ':' not in url: # workaround: process will crash if no colon in URL (OS bug)
		raise ValueError("Invalid url: %r" % url)
	return ae.newdesc(kae.typeApplicationURL, url)

