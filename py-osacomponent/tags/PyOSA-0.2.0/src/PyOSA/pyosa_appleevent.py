
from CarbonX.AE import AECreateDesc
from CarbonX.kOSA import *
import aem

__all__ = ['unpackappleevent']

#######

codecs = aem.Codecs() # TO DO: need to use current application's codecs, with folder actions and any other default handler definitions added
	
kEventAttributes = [
		keyTransactionIDAttr,
		keyReturnIDAttr,
		keyEventClassAttr,
		keyEventIDAttr,
		keyAddressAttr,
		keyOptionalKeywordAttr,
		keyTimeoutAttr,
		keyInteractLevelAttr,
		keyEventSourceAttr,
		keyOriginalAddressAttr,
		keyAcceptTimeoutAttr,
		keyReplyRequestedAttr,
		keySubjectAttr,
		enumConsiderations, # deprecated; clients should use enumConsidsAndIgnores instead
		enumConsidsAndIgnores,
		]

#######


def unpackappleevent(desc):
	attributes, parameters = {}, {}
	for key in kEventAttributes:
		try:
			attributes[key] = codecs.unpack(desc.AEGetAttributeDesc(key, typeWildCard))
		except:
			pass
	for i in range(desc.AECountItems()):
		key, value = desc.AEGetNthDesc(i + 1, typeWildCard)
		parameters[key] = codecs.unpack(value)
	code = attributes[keyEventClassAttr].code + attributes[keyEventIDAttr].code
	return code, attributes, parameters


