"""mcpy_pack -- pack and unpack AEDescs.

(C) 2005 HAS

--------------------------------------------------------------------------------
"""

from CarbonX.AE import AECreateDesc

from aem import Codecs, AEType

from mcpy_constants import *
import mcpy_error

######################################################################
# PRIVATE
######################################################################

_codecs = Codecs()

#######

def _strToStyledTextDesc(s):
	# This keeps Script Editor happy when it calls OSADisplay and OSAGetSource (it ignores us if we send it back plain text instead)
	if isinstance(s, unicode):
		s = s.encode('MacRoman', 'replace')
	if not isinstance(s, str):
		print "Error: Can't make AEDesc of typeStyledText: not a string."
		raise TypeError # TO DO
	return _codecs.pack({
			AEType('ksty'): AECreateDesc('styl', '\x00\x01\x00\x00\x00\x00\x00\x10\x00\x0e\x00\x03\x00\x00\x00\x0c\x00\x00\x00\x00\xBB\x00'), 
			AEType('ktxt'): s}).AECoerceDesc('STXT')

_coercions = {
		typeChar: lambda val: str(val),
		typeStyledText: _strToStyledTextDesc,
		typeUnicodeText: lambda val: unicode(val, 'MacRoman'),
		# TO DO: what else? (e.g. typeScript?)
		}


######################################################################
# PUBLIC
######################################################################

# TO DO: ability to pack application references so they'll display correctly in SE Results; appscript.app, ae.Application, etc.; see how AS shows stuff like 'application "Foo"' and 'document 1 of application "Foo"'

def packAsType(val, type): # TO DECIDE: how best to support coercions (e.g. would it be better to install additional AE coercions, or do casts here?)
	try:
		if type == typeWildCard or type == typeBest or val == None: # TO CHECK: best way to handle typeBest?
			return _codecs.pack(val)
		elif _coercions.has_key(type):
			return _codecs.pack(_coercions[type](val))
		else:
			val = _codecs.pack(val)
			if val.type != type:
				val = val.AECoerceDesc(type)
			return val
	except:
		mcpy_error.raiseError(errOSACantCoerce, "Can't coerce %r to %r." % (val, type))


pack = _codecs.pack
unpack = _codecs.unpack

