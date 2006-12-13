"""getterminology -- Retrieve sdef and aete data for applications, and aeut data for scripting components.

(C) 2005 HAS
"""

import MacOS
from aem import Codecs
from CarbonX.AE import AEDesc

import OSATerminology as _osat

__all__ = ['getsdef', 'getaete', 'getaeut']

######################################################################
# PRIVATE
######################################################################

_codecs = Codecs()

def _extract(fn, type):
	try:
		desc = fn()
	except MacOS.Error, err:
		if err.args[0] != -192: # re-raise unless aete resource not found
			raise
		return []
	else:
		lst = _codecs.unpack(desc)
		if not isinstance(lst, list):
			lst = [lst]
		return [val.data for val in lst if isinstance(val, AEDesc) and val.type == type]


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
	return _extract((lambda: _osat.GetAppTerminology(path)[0]), 'aete')

def getaeut(code='ascr'):
	"""Get a scripting component's built-in terminology (aeut)
		code : str -- 4-letter code indication component subtype (default: AppleScript)
		Result : list of str -- zero or more strings of binary aeut data
	"""
	return _extract((lambda: _osat.GetSysTerminology(code)), 'aeut')

