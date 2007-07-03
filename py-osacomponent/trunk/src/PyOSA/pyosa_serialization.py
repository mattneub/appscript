
#
# pyosa_serialization.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
#

# TO DO: packscript, unpackscript currently do dodgy serialisation
# From TN2053: "AEGetDescData should not be used on a complex AEDesc like a list, record, or AppleEvent [...]
# If you need to serialize a complex AEDesc, use AEFlattenDesc and AEUnflattenDesc."

import pickle, sys
from pprint import pprint

from CarbonX.AE import AECreateDesc
from CarbonX.kOSA import *
from pyosa_errors import *

__all__ = ['packscript', 'unpackscript']

#######

pyosa_kSerializationVersion = 1
pyosa_kOldestSupportedSerializationVersion = 0


#######

def packscript(source, state, modeflags, codecs):
	# state is a dict of zero or more pickleable values
	try:
		state = codecs.pack(pickle.dumps(state))
	except Exception, e:
		print >> sys.stderr, "PyOSA: couldn't pack script's persistent state (%s) so ignoring it." % e # user warning
		pprint(state, sys.stderr) # user warning
		state = {}
	rec = codecs.pack({
			'source': source,
			'state': state,
			'modeflags': modeflags,
			'pythonversion': sys.version_info,
			'serializationversion': pyosa_kSerializationVersion,
			'oldestsupportedserializationversion': pyosa_kOldestSupportedSerializationVersion,
			})
	return AECreateDesc(typeScript, rec.data)


def unpackscript(desc, codecs):
	# BUG WORKAROUND
	# OSARemoveStorageType is broken on i386+Tiger, removing 3072 (0x0C00), not 12 (0x000C), bytes from
	# data handle. (See <http://lists.apple.com/archives/applescript-implementors/2006/May/msg00027.html>)
	# Therefore, disable it in osafunctions.c and have remove the 12-byte trailer here.
	data = desc.data[:-12] # WORKAROUND
	rec = codecs.unpack(AECreateDesc(typeAERecord, data))
	if rec['serializationversion'] < pyosa_kOldestSupportedSerializationVersion:
		raise ComponentError(errOSADataFormatObsolete)
	if pyosa_kSerializationVersion < rec['oldestsupportedserializationversion']:
		raise ComponentError(errOSADataFormatTooNew)
	source = rec['source']
	state = rec['state']
	modeflags = rec['modeflags']
	try:
		state = pickle.loads(state)
	except Exception, e:
		print >> sys.stderr, "PyOSA: couldn't unpack script's persistent state (%s) so ignoring it." % e # user warning
		state = {}
	return source, state, modeflags # caller should bitwise-OR modeflags # TO DO: check

