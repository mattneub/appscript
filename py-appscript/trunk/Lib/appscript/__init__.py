"""appscript -- High-level application scripting support for MacPython.

(C) 2004 HAS
"""

__version__ = '0.18.0'

__all__ = ['ApplicationNotFoundError', 'app','CommandError', 'con', 'its', 'k', 'CantLaunchApplicationError']

from aem.findapp import ApplicationNotFoundError
from aem import CantLaunchApplicationError
from reference import app, CommandError
from genericreference import con, its
from keywordwrapper import k

