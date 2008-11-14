"""aemreceive -- Install Python functions as Apple event handlers.

(C) 2005-2008 HAS
"""

from aem import AEType, AEEnum # re-exported for convenience
from aem import kae # re-export for convenience
kAE = kae # backwards compatibility; deprecated

from main import kMissingValue, Codecs, installeventhandler, removeeventhandler, installcoercionhandler, removecoercionhandler
from handlererror import EventHandlerError
from typedefs import kArgDesc, kArgMissingValue, ArgType, ArgListOf, ArgEnum, ArgMultiChoice
