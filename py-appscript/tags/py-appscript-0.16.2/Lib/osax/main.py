#!/usr/local/bin/pythonw

"""main -- Basic support for calling OSAXen, the dirty little devils.

(C) 2004 HAS"""

from CarbonX.AE import AECreateDesc
import CarbonX.kAE as _k
import MacOS

from aem import Application, CommandError

__all__ = ['osax', 'CommandError', 'kCurrentApplication']

######################################################################
# PRIVATE
######################################################################

kCurrentApplication = Application()


######################################################################
# PUBLIC
######################################################################

def osax(event, params={}, atts={}, target=kCurrentApplication, timeout=_k.kAEDefaultTimeout):
	"""Call an OSAX ('OSA eXtension').
		event : str -- 8-letter code indicating event's class, e.g. 'sysobeep'
		params : dict -- a dict of form {code:anything,...} containing zero or more parameters for the event
		atts : dict -- a dict of form {code:anything,...} containing zero or more attributes for the event
		target : Application -- target application, e.g. Application('/Applications/TextEdit.app'); default is 'current' application
		timeout : int -- number of ticks to wait for result before raising timeout error
		Result : anything
	"""
	ev = target.event(event, params, atts)
	try:
		return ev.send(timeout)
	except MacOS.Error, err:
		if err[0] == -1708: # Event wasn't handled by application...
			try:
				target.event('ascrgdut').send() # ...so force application to load OSAXen...
			except MacOS.Error, err:
				if err[0] != -1708: # <event ascrgdut> always raises this error; ignore it
					raise
			return ev.send(timeout) # ...and try again.
		else:
			raise


#######
# test

if __name__ == '__main__':
	#print osax('sysocpls')
	#osax('sysobeep', {'----':2})
	#print osax('sysostdf', {'prmp':'Please pick a file...'})
	#print osax('sysonwfl')
	#print Application('/System/Library/CoreServices/Finder.app')
	#print osax('sysodlog', {'----':'Hello from Finder'}, target=Application('/System/Library/CoreServices/Finder.app'))
	print osax('sysodlog', {'----':'Hello from TextEdit'}, target=Application('/Applications/TextEdit.app'))

