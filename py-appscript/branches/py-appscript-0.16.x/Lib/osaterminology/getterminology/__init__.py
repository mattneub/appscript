"""getterminology -- Retrieve sdef and aete data for applications, and aeut data for scripting components.

(C) 2005 HAS
"""

import MacOS
from aem import Codecs

import OSATerminology as _osat

__all__ = ['getsdef', 'getaete', 'getaeut']

######################################################################
# PRIVATE
######################################################################

_codecs = Codecs()
_codecs.decoders['aete'] = _codecs.decoders['aeut'] = lambda desc,app: desc.data


######################################################################
# PUBLIC
######################################################################

def getsdef(path):
	"""Get an application's terminology as sdef XML data, if available.
		path : str | unicode | FSRef -- full path to app
		Result : str | None -- XML data, or None if OS version < 10.4
	"""
	return _osat.CopyScriptingDefinition(path)

def getaete(path):
	"""Get an application's terminology as zero or more aete(s).
		path : str | unicode | FSSpec -- full path to app
		Result : list of str -- zero or more strings of binary aete data
	"""
	try:
		desc = _osat.GetAppTerminology(path)[0]
	except MacOS.Error, err:
		if err.args[0] == -192: # aete resource not found
			aetes = []
		else:
			raise
	else:
		aetes = _codecs.unpack(desc)
		if not isinstance(aetes, list):
			aetes = [aetes]
		aetes = [aete for aete in aetes if aete != None] # AS applets don't raise error -192 for some reason
	return aetes

def getaeut(code='ascr'):
	"""Get a scripting component's built-in terminology (aeut)
		code : str -- 4-letter code indication component subtype (default: AppleScript)
		Result : str -- binary aeut data
	"""
	return _codecs.unpack(_osat.GetSysTerminology(code))

