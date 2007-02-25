
#
# pyosa_serialization.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
#

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
	rec = codecs.unpack(AECreateDesc(typeAERecord, desc.data))
#	if rec['serializationversion'] < pyosa_kOldestSupportedSerializationVersion:
#		raise ComponentError(errOSADataFormatObsolete)
#	if pyosa_kSerializationVersion < rec['oldestsupportedserializationversion']:
#		raise ComponentError(errOSADataFormatTooNew)
	source = rec['source']
	state = rec['state']
	modeflags = rec['modeflags']
	try:
		state = pickle.loads(state)
	except Exception, e:
		print >> sys.stderr, "PyOSA: couldn't unpack script's persistent state (%s) so ignoring it." % e # user warning
		state = {}
	return source, state, modeflags # caller should bitwise-OR modeflags # TO DO: check

