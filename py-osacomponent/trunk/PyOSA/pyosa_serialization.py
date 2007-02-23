
import pickle, sys
from pprint import pprint

from CarbonX.AE import AECreateDesc
from CarbonX.kOSA import *
from pyosa_errors import *

__all__ = ['packscript', 'unpackscript']

#######

pyosa_kOldestSupportedVersion = 0.1
pyosa_kSerializationVersion = 0.1


#######

def packscript(source, state, modeflags, codecs):
	# state is a dict of zero or more pickleable values
	try:
		state = codecs.pack(pickle.dumps(state))
	except Exception, e:
		print >> sys.stderr, "PyOSA: couldn't pack script's persistent state (%s) so ignoring it." % e
		pprint(state, sys.stderr)
		state = {}
	rec = codecs.pack({
			'source': source,
			'state': state,
			'modeflags': modeflags,
			'componentversion': pyosa_kSerializationVersion})
	return AECreateDesc(typeScript, rec.data)


def unpackscript(desc, codecs):
	rec = codecs.unpack(AECreateDesc(typeAERecord, desc.data))
	version = rec['componentversion']
	if version < pyosa_kOldestSupportedVersion:
		raise ComponentError(errOSADataFormatObsolete)
	elif version > pyosa_kSerializationVersion:
		raise ComponentError(errOSADataFormatTooNew)
	source = rec['source']
	state = rec['state']
	modeflags = rec['modeflags']
	try:
		state = pickle.loads(state)
	except Exception, e:
		print >> sys.stderr, "PyOSA: couldn't unpack script's persistent state (%s) so ignoring it." % e
		state = {}
	return source, state, modeflags # caller should bitwise-OR modeflags # TO DO: check

