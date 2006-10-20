"""constants -- Apple event attribute keys and send mode flags.

(C) 2005 HAS
"""

import CarbonX.kAE as _kAE
import CarbonX.AE as _AE

#######
# Default value for Application.event()'s returnid argument

AutoGenerateReturnID = _kAE.kAutoGenerateReturnID


#######
# send() timeout constants

DefaultTimeout = _kAE.kAEDefaultTimeout
NoTimeout = _kAE.kNoTimeOut


#######
# send() bitwise flags

NoReply = _kAE.kAENoReply
QueueReply = _kAE.kAEQueueReply
WaitReply = _kAE.kAEWaitReply

DontReconnect = _kAE.kAEDontReconnect

WantReceipt = _kAE.kAEWantReceipt

NeverInteract = _kAE.kAENeverInteract
CanInteract = _kAE.kAECanInteract
AlwaysInteract = _kAE.kAEAlwaysInteract

CanSwitchLayer = _kAE.kAECanSwitchLayer


#######
# Commonly used event parameter keys, defined here for convenience:

Direct = _kAE.keyDirectObject
ResultType = _kAE.keyAERequestedType

#######
# Event attribute keys # TO CHECK: which of these are useful in Application.event()'s atts argument, or are they only of use when unpacking AppleEvent objects manually (e.g. in aemreceive)?

Ignore = 'cons'
TransactionID = _kAE.keyTransactionIDAttr
ReturnID = _kAE.keyReturnIDAttr
EventClass = _kAE.keyEventClassAttr
EventID = _kAE.keyEventIDAttr
Address = _kAE.keyAddressAttr
OptionalKeyword = _kAE.keyOptionalKeywordAttr
Timeout = _kAE.keyTimeoutAttr
InteractLevel = _kAE.keyInteractLevelAttr
EventSource = _kAE.keyEventSourceAttr
OriginalAddress = _kAE.keyOriginalAddressAttr
AcceptTimeout = _kAE.keyAcceptTimeoutAttr
Subject = 'subj' # not defined in CarbonX.kAE for some reason; dunno why


#######
# Considering/ignoring constants

# Old-style constants for use in (obsolete) 'cons' attribute
Case = _AE.AECreateDesc(_kAE.typeEnumeration, 'case')
Diacriticals = _AE.AECreateDesc(_kAE.typeEnumeration, 'diac')
Expansion = _AE.AECreateDesc(_kAE.typeEnumeration, 'expa')
Punctuation = _AE.AECreateDesc(_kAE.typeEnumeration, 'punc')
Hyphens = _AE.AECreateDesc(_kAE.typeEnumeration, 'hyph')
Whitespace = _AE.AECreateDesc(_kAE.typeEnumeration, 'whit')

# New-style constants for use in 'csig' attribute
CaseConsider = 0x00000001
DiacriticConsider = 0x00000002
WhiteSpaceConsider = 0x00000004
HyphensConsider = 0x00000008
ExpansionConsider = 0x00000010
PunctuationConsider = 0x00000020
# kASConsiderRepliesConsiderMask = 0x00000040
CaseIgnore = 0x00010000 # (default)
DiacriticIgnore = 0x00020000
WhiteSpaceIgnore = 0x00040000
HyphensIgnore = 0x00080000
ExpansionIgnore = 0x00100000
PunctuationIgnore = 0x00200000
# kASConsiderRepliesIgnoreMask = 0x00400000

