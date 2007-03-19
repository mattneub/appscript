"""appscript -- High-level application scripting support for MacPython.

(C) 2004 HAS
"""

__version__ = '0.17.2'

__all__ = ['ApplicationNotFoundError', 'app','CommandError', 'con', 'its', 'k']

from aem.findapp import ApplicationNotFoundError
from reference import app, CommandError
from genericreference import con, its
from keywordwrapper import k

