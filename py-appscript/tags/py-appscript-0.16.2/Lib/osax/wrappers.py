#!/usr/local/bin/pythonw

"""wrappers -- Wrapper functions for useful standard scripting additions.

(C) 2004 HAS
"""

# TO DECIDE: what do do about event timeouts?
# TO DECIDE: what to use for app arguments? Should name/path/id/creator expansion be moved from appscript.app to aem.send.Application to improve ease of use?

import MacOS
from CarbonX.AE import AECreateDesc
from aem import Application, AEType, AEEnum
from main import osax, kCurrentApplication
import macfile


######################################################################
# PRIVATE
######################################################################

_SystemEvents = Application(desc=AECreateDesc('sign', 'sevs')) # used by clipboard commands, which need to target another application to work

def _params(params, *optparams): # pack optional parameters into params dict
	for code, value in optparams:
		if value is not None:
			params[code] = value
	return params

def _aliasToPath(alias):
	return unicode(alias.ResolveAlias(None)[0].as_pathname(), 'utf8')


######################################################################
# PUBLIC
#####################################################################
# User Interaction Suite  -- Basic commands for interacting with the user

class UserCancelled(Exception): # TO FIX: should be subclass of MacOS.Error and contain appropriate error codes
	pass

##

def say(text, display=None, voice=None, waiting=None, outputfile=None, app=kCurrentApplication):
	"""Speak the given text.
		text : str -- the text to speak, which can include intonation characters
		display : str -- the text to display in the feedback window (if different). Ignored unless Speech Recognition is on.
		voice : str -- the voice to speak with.  Ignored if Speech Recognition is on.
		waiting : bool  -- wait for speech to complete before returning (default is true). Ignored unless Speech Recognition is on.
		outputfile : anything -- the alias, file reference or Mac-style path string of an AIFF file (existing or not) to contain the sound output.
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
	"""
	osax('sysottos', _params({'----':text}, ('DISP', display), ('VOIC', voice), ('wfsp', waiting), ('stof', outputfile)), target=app)

def beep(times=None):
	"""Beep 1 or more times
		times : int -- number of times to beep
	"""
	osax('sysobeep', _params({}, ('----', times)))

##

kStop = AEEnum('\x00\x00\x00\x00')
kNote = AEEnum('\x00\x00\x00\x01')
kCaution = AEEnum('\x00\x00\x00\x02')

def displaydialog(text, buttons=None, defaultbutton=None, defaultanswer=None, icon=None, timeout=None , app=kCurrentApplication):
	"""Display a dialog box, optionally requesting user input
		text : str -- the text to display in dialog box
		buttons : list of str -- a list of up to three button names
		defaultbutton : int | str -- the name or number of the default button
		defaultanswer : str -- the default editable text
		icon : str | int | kStop | kNote | kCaution -- the name or ID of the icon to display
		timeout : int -- number of seconds to wait before automatically dismissing dialog
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result : (str, str, bool) -- the button clicked (or '' if dialog gave up), text entered (or None if no defaultanswer given), dialog timed-out flag (or None if no timeout given)
	"""
	try:
		reply = osax('sysodlog', _params({'----':text}, ('dtxt', defaultanswer), ('btns', buttons), ('dflt', defaultbutton), ('disp', icon), ('givu', timeout)), target=app)
	except MacOS.Error, err:
		if err[0] == -128: # user cancelled
			raise UserCancelled
		else:
			raise
	else:
		return reply.get(AEType('bhit')), reply.get(AEType('ttxt')), reply.get(AEType('gavu'))

# some dialog wrappers for convenience:

def displaymessage(text, timeout=None, app=kCurrentApplication):
	displaydialog(text, ['OK'], 1, icon=kNote, timeout=timeout, app=app)

def displaywarning(text, stopbydefault=True, app=kCurrentApplication):
	return displaydialog(text, ['Stop', 'Continue'], not stopbydefault + 1, icon=kCaution, app=app)[0] == 'Continue'

def displayerror(text, buttonname='Quit', app=kCurrentApplication):
	displaydialog(text, [buttonname], icon=kStop, app=app)

##

def chooseitems(items, prompt=None, default=None, multiselelect=None, emptyselect=None, okbutton=None, cancelbutton=None, app=kCurrentApplication):
	"""Allows user to select an item from a list of strings
		items : list of str -- a list of strings to display (an empty list if no selection)
		prompt : str -- the prompt to appear at the top of the list selection dialog
		default : list of str -- list of strings to initially select
		okbutton : str -- the name of the OK button
		cancelbutton : str -- the name of the Cancel button
		multiselelect : bool -- Allow multiple items to be selected?
		emptyselect : bool -- Can the user make no selection and then choose OK?
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result : list of str -- the list of strings chosen
	"""
	reply = osax('gtqpchlt', _params({'----':items}, ('prmp', prompt), ('inSL', default), ('mlsl', multiselelect), 
			('empL', emptyselect), ('okbt', okbutton), ('cnbt', cancelbutton)), target=app)
	if reply == False:
		raise UserCancelled
	else:
		return reply

##

def chooseapp(title=None, prompt=None, multiselect=None, app=kCurrentApplication):
	"""Choose an application on this machine or the network
		title : str -- the dialog window title
		prompt : str -- the prompt to appear at the top of the application chooser dialog box
		multiselect : bool -- Allow multiple items to be selected?
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result : macfile.Alias | list of macfile.Alias -- path(s) to application(s)
	"""
	try:
		return osax('sysoppcb', _params({'rtyp':AEType('alis')}, ('appr', title), ('prmp', prompt), ('mlsl', multiselect)), target=app, timeout=3600*5) # extra-long timeout as making multiple selections can take some time
	except MacOS.Error, err:
		if err[0] == -128: # user cancelled
			raise UserCancelled
		else:
			raise


def choosefile(prompt=None, onlyshowtypes=None, app=kCurrentApplication):
	"""Choose a file on a disk or server
		prompt : str -- a prompt to be displayed in the file chooser
		onlyshowtypes : list of str -- restrict the files shown to only these file types (up to 4)
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result : macfile.Alias -- to the chosen file
	"""
	try:
		return osax('sysostdf', _params({}, ('prmp', prompt), ('ftyp', onlyshowtypes)), target=app)
	except MacOS.Error, err:
		if err[0] == -128: # user cancelled
			raise UserCancelled
		else:
			raise


def choosenewfile(prompt=None, defaultname=None, app=kCurrentApplication):
	"""Get a new file reference from the user, without creating the file
		prompt : str -- the text to display in the file creation dialog box
		defaultname : str -- the default name for the new file
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result: str -- the URL of the file the user specified
	"""
	try:
		return osax('sysonwfl', _params({}, ('prmt', prompt), ('dfnm', defaultname)), target=app)
	except MacOS.Error, err:
		if err[0] == -128: # user cancelled
			raise UserCancelled
		else:
			raise


def choosefolder(prompt=None, app=kCurrentApplication):
	"""Choose a folder on a disk or server
		prompt : str -- a prompt to be displayed in the folder chooser
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result: macfile.Alias -- chosen folder
	"""
	try:
		return osax('sysostfl', _params({}, ('prmp', prompt)), target=app)
	except MacOS.Error, err:
		if err[0] == -128: # user cancelled
			raise UserCancelled
		else:
			raise


kWebServers = AEEnum('esvw')
kFTPServers = AEEnum('esvf')
kTelnetHosts = AEEnum('esvt')
kFileServers = AEEnum('esva')
kNewsServers = AEEnum('esvn')
kDirectoryServices = AEEnum('esvd')
kMediaServers = AEEnum('esvm')
kRemoteApplications = AEEnum('esve')

def chooseurl(showservices=None, editable=None, app=kCurrentApplication):
	"""Choose a service on the Internet
		showservices : list of kWebServers | kFTPServers | kTelnetHosts | kFileServers | kNewsServers | kDirectoryServices | kMediaServers | kRemoteApplications -- which network services to show
		editable [pedu] <bool> (optional) -- Allow user to type in a URL?
		app : aem.send.Application -- the application to use (default = kCurrentApplication)
		Result: str -- the URL chosen
	"""
	try:
		return osax('sysochur', _params({}, ('', showing)), target=app)
	except MacOS.Error, err:
		if err[0] == -128: # user cancelled
			raise UserCancelled
		else:
			raise


#######
# Clipboard Commands Suite -- Access to the Clipboard in applications

def setclipboard(data):
	"""Place data on an application's clipboard. Activate the target application first
		data : anything -- the data to place on the clipboard
	"""
	return osax('JonspClp', {'----':data}, target=_SystemEvents)


def getclipboard(desiredtype=None):
	"""Return the contents of an application's clipboard. Activate the target application first
		desiredtype : str -- 4-letter code; the type of data desired (see also clipboardinfo)
		Result: list of anything -- the data from its clipboard
	"""
	return osax('JonsgClp', _params({}, ('rtyp', desiredtype and AEType(desiredtype))), target=_SystemEvents)


def clipboardinfo(desiredtype=None):
	"""Return information about the clipboard
		desiredtype : str -- 4-letter code; restricts result to information about only this data type
		Result: list of list -- one list of [data type, size] for each type of data on the clipboard
	"""
	return osax('JonsiClp', _params({}, ('for ', desiredtype and AEType(desiredtype))), target=_SystemEvents)


#######
# Scripting Commands Suite -- Commands to work with scripts

kYes = AEEnum('yes ')
kAsk = AEEnum('ask ')
kNo = AEEnum('no  ')

##

def loadscript(path):
	"""Return a script object loaded from a specified disk file
		path : str -- the file containing the script object to load
		Result: AEDesc -- the script object loaded (an AEDesc of typeScript)
	"""
	return osax('sysoload', {'----':macfile.File(path)})


def storescript(script, path, replacing=kAsk):
	"""Store a script object into a file
		script : AEDesc -- the script object to store (an AEDesc of typeScript)
		path : str -- the file to store the script object in
		replacing : kYes | kAsk | kNo -- control display of Save As dialog; default is kAsk
	"""
	osax('sysostor', {'----':script, 'fpth':macfile.File(path), 'savo':replacing})


def runscript(script, parameters=[], component='AppleScript'):
	"""Run a specified OSA script or script file.
		script : str | Alias | FSSpec -- the script text, an alias or file reference of a script file, or an AEDesc of typeScript to run
		[parameters : list of anything -- list of parameters
		[component : str -- the scripting component to use; default is AppleScript
		Result: anything -- the result of running the script
	"""
	return osax('sysodsct', {'----':script, 'plst':parameters, 'scsy':component})


def scriptingcomponents():
	"""Return a list of all scripting components (e.g. AppleScript)
		Result: <TEXT> (list) -- a list of installed scripting components
	"""
	return osax('sysocpls')


#######
# Miscellaneous Commands Suite -- Other useful commands

def setvolume(level):
	"""Set the sound output volume
		level : int -- the volume level, from 0 (silent) to 7 (full volume)
	"""
	osax('aevtstvl', {'----':level})


def systemattribute(attribute, testbits=None):
	"""Test attributes of this computer
		attribute : str -- 4-letter code; the attribute to test (either a "Gestalt" value or a shell environment variable). # TO CHECK: Which codes? Does it take long strings too? (Apple's documentation is hopeless...)
		testbits : int -- test specific bits of response
		Result: int | str -- the result of the query (or a list of all environment variables, if no attribute is provided)
	"""
	return osax('fndrgstl', _params({'----':AEType(attribute)}, ('has ', testbits)))


kApplicationSupport = AEEnum('asup')
kCurrentUser = AEEnum('cusr')
kDesktop = AEEnum('desk')
kDesktopPictures = AEEnum('dtp\xC4')
kFolderActions = AEEnum('fasf')
kFonts = AEEnum('font')
kHelp = AEEnum('\xC4hlp')
kKeychain = AEEnum('kchn')
kModemScripts = AEEnum('\xC4mod')
kPreferences = AEEnum('pref')
kPrinterDescriptions = AEEnum('ppdf')
kScriptingAdditions = AEEnum('\xC4scr')
kScripts = AEEnum('scr\xC4')
kSharedLibraries = AEEnum('\xC4lib')
kStartupDisk = AEEnum('boot')
kSystem = AEEnum('macs')
kSystemPreferences = AEEnum('sprf')
kTemporaryItems = AEEnum('temp')
kTrash = AEEnum('trsh')
kUsers = AEEnum('usrs')
kVoices = AEEnum('fvoc')

kNetworkDomain = AEEnum('fldn')
kSystemDomain = AEEnum('flds')
kLocalDomain = AEEnum('fldl')
kUserDomain = AEEnum('fldu')

def pathto(location, domain=None, asstring=False):
	"""Returns full path name to the folder specified
		location : kApplicationSupport | kCurrentUser | kDesktop | kDesktopPictures | kFolderActions | kFonts | kHelp | kKeychain | kModemScripts | kPreferences | kPrinterDescriptions | kScriptingAdditions | kScripts | kSharedLibraries | kStartupDisk | kSystem | kSystemPreferences | kTemporaryItems | kTrash | kUsers | kVoices -- the folder to return
		domain : kNetworkDomain | kSystemDomain | kLocalDomain | kUserDomain -- where to look for the indicated folder
		asstring : boolean -- return unicode string (Mac path) instead of alias
		Result: macfile.Alias | str -- the path name to the folder or application specified
	"""
	return osax('earsffdr', _params({'----':location}, ('from', domain), ('rtyp', asstring and AEType('utxt') or None)))


######################################################################
# TEST
######################################################################

if __name__ == '__main__':
	say('hello world')
	displaymessage('hello world', app=Application('/Applications/textedit.app'))


