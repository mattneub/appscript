"""sfba -- Simple module for constructing scriptable FBAs (faceless background applications). Provides functions for starting and stopping a Carbon event loop, and re-exports aemreceive's contents for convenience.

(C) 2005 HAS
"""

import Carbon.CarbonEvt as _Evt

from aemreceive import * # re-export for convenience

######################################################################
# PRIVATE
######################################################################

installeventhandler(lambda:None, 'aevtoapp')
installeventhandler(lambda front=False:None, 'aevtrapp', ('frnt', 'front', '****'))
installeventhandler(lambda:stopeventloop(), 'aevtquit')

######################################################################
# PUBLIC
######################################################################

def starteventloop():
	"""Start application's main event loop. Call this after all Apple event handlers are installed. 
	Application will then remain open, handling incoming Apple events, until it is explicitly quit 
	(e.g. upon receiving an 'aevtquit' event).
	"""
	_Evt.RunApplicationEventLoop()


def stopeventloop():
	"""Stop application's main event loop. This is automatically called by the default 'quit' event handler.
	If installing a custom 'quit' event handler, remember to have it call this function at some point, 
	otherwise the application can't be quit!
	"""
	_Evt.QuitApplicationEventLoop()

