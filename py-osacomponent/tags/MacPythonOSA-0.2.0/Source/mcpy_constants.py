#!/usr/local/bin/pythonw

from CarbonX.kAE import *
from CarbonX.kOSA import * # TO DO: get rid of this dependency

# Common OSA error codes (OSAconst omits these)

errOSACantCoerce = -1700 # handleOSACoerceToDesc
errOSACorruptData = -1702 # handleOSALoad, handleOSAStore
errAEEventNotHandled = -1708 # handleOSADoEvent, handleOSAExecuteEvent
errAERecordingIsAlreadyOn = -1732 # handleOSAStartRecording
errOSASystemError = -1750 # any unexpected component error
errOSAInvalidID = -1751 # script storage
errOSABadStorageType = -1752 # handleOSALoad, handleOSAStore
errOSAScriptError = -1753 # handleOSACompile, handleOSAExecute, handleOSADoEvent, etc. (client should obtain actual script error via handleOSAScriptError())
errOSABadSelector = -1754 # any function not supported by component
errOSASourceNotAvailable = -1756 # handleOSAGetSource
errOSANoSuchDialect = -1757 # unused
errOSADataFormatObsolete = -1758 # handleOSALoad
errOSADataFormatTooNew = -1759 # handleOSALoad
errOSAComponentMismatch = -1761
errOSACantOpenComponent = -1762 # componentOpen

# Script error description selectors; used by handleOSAScriptError

#kOSAErrorNumber = keyErrorNumber
#kOSAErrorMessage = keyErrorString
#kOSAErrorBriefMessage = 'errb'
#kOSAErrorApp = 'erap'
#kOSAErrorPartialResult = 'ptlr'
#kOSAErrorOffendingObject = 'erob'
#kOSAErrorExpectedType = 'errt'
#kOSAErrorRange = 'erng'


kASHasOpenHandler = 'hsod'

# kOSAUseStandardDispatch = -1 # Used in the resumeDispatchProc parameter of OSASetResumeDispatchProc and OSAGetResumeDispatchProc to indicate that the event is dispatched using standard Apple event dispatching.


# kOSANoDispatch = 0 # Used in the resumeDispatchProc parameter of OSASetResumeDispatchProc to dispatch the event using standard Apple event dispatching.


# kOSADontUsePhac  = 1 # Used in the refCon parameter of OSASetResumeDispatchProc to dispatch the event using standard Apple event dispatching, excluding the special handler table.