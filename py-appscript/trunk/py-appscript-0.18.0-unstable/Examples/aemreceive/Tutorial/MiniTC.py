"""MiniTC.app -- A simple demonstration of using the aemreceive package to build a simple AppleScriptable FBA in MacPython.

(C) 2005 HAS
"""

#######
# Import modules

from aemreceive.sfba import *


#######
# Install event handlers

def unicodeNumbers(text):
	return [ord(c) for c in text]

installeventhandler(
		unicodeNumbers,
		'TeCoUnum',
		('----', 'text', kAE.typeUnicodeText)
		)


def unicodeCharacters(intList):
	try:
		return u''.join([unichr(i) for i in intList])
	except ValueError:
		raise EventHandlerError(-1704, 'Some number was outside range 0-65535.')

installeventhandler(
		unicodeCharacters,
		'TeCoUcha',
		('----', 'intList', ArgListOf(kAE.typeInteger))
		)


def stripText(text, removing=None, fromEnd=AEEnum('Both')):
	endCode = fromEnd.code
	method = {'Left': text.lstrip, 'Rght': text.rstrip, 'Both': text.strip}[endCode]
	return method(removing)

installeventhandler(
		stripText,
		'TeCoStrp',
		('----', 'text', kAE.typeUnicodeText),
		('Remo', 'removing', kAE.typeUnicodeText),
		('From', 'fromEnd', ArgEnum('Left', 'Rght', 'Both'))
		)


#######
# Start handling incoming events

starteventloop()
