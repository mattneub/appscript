#!/usr/local/bin/pythonw

"""mcpy_error.py -- Used to pass known errors caused by client or client's scripts to C wrapper.

(C) 2005 HAS

--------------------------------------------------------------------------------

IMPORTANT: MacPythonOSA.c refers to the mcpy_error module, its ComponentError class and its macOSError attribute by name, so don't modify these names.

Note: any accidental/untrapped errors will cause MacPythonOSA component to write an 'unexpected error' to stderr and return errOSASystemError to client instead. This should be avoided, of course.
"""

# TO DO: handle script error reporting

from sys import exc_info, stdout, stderr
from traceback import extract_tb, print_exception, print_exc

from mcpy_constants import *

######################################################################
# PRIVATE
######################################################################

_errType, _errValue, _errTrace, _errStart, _errEnd = None, None, None, 0, 0 # holds a detailed description of the most recently occurred script error for subsequent retrieval by client


#######

def _formatTrace(trace):
	s = ''
	curpath = None
	for path, lineno, funcname, linecode in trace:
		if path != curpath:
			s += '\n  %s:' % path
			curpath = path
		if len(linecode) > 40:
			linecode = linecode[:35] + '...' + linecode[-5:]
		s += '\n    Line %i%s:\n      %s' % (lineno, 
				funcname and (' in %s' % funcname) or '',
				linecode)
	return s[1:]


def _extractTraceInfo(traceback, source): # TO FIX: what if source = None?
	# used for initialisation and execution errors
	#print extract_tb(traceback)
	traces = extract_tb(traceback)[1:]
	paras = source.replace('\r', '\n').split('\n')
	if not traces:
		return 0, 0, None
	traceNum = 0
	lastLineno = 0
	while traceNum < len(traces):
		path, lineno, funcname, linecode = traces[traceNum]
		if path != '<OSA script>': # TO DECIDE: should each script have a unique name (based on ID)?
			break
		lastLineno = lineno
		traces[traceNum] = ('This script',
				lineno,
				funcname != '?' and funcname or None,
				linecode or paras[lineno - 1].lstrip('\t '))
		traceNum += 1
	# (line numbers are 1-indexed; convert to 0-index for list lookup)
	startPos = len('\n'.join(paras[:lastLineno - 1]) + '\n')
	endPos = startPos + len(paras[lastLineno - 1])
	# TO DO: add indent length to startPos
	#print startPos, endPos, len(source), source[startPos:endPos]
	return startPos, endPos, _formatTrace(traces) # (path/None, lineno, funcname/None, linecode)


def _extractCompileErrorInfo(value, source):
	try:
		paras = source.replace('\r', '\n').split('\n')
		# print value.lineno, value.offset # TEST
		linePos = len('\n'.join(paras[:value.lineno - 1]) + '\n')
		startPos = linePos + value.offset - 1
		endPos = linePos + len(paras[value.lineno - 1])
		if startPos == endPos: # indentation error returns offset for end, not start, of line for some reason
			startPos = linePos
		#print `source[startPos:endPos+1]` # TEST
		return startPos, endPos, str(value)
	except: # if compile() raises TypeError due to null chars in source string, can't get lineno
		return 0, 0, str(value)


######################################################################
# PUBLIC
######################################################################
# Note: following classes shouldn't be instantiated directly; use raiseError(), raiseScriptError() 

class ComponentError(Exception): # Used to alert the C wrapper of a known OSA component error.
	# Note: the C wrapper directly refers to this class so don't mess with it (subclassing is ok though).
	def __init__(self, macOSError):
		Exception.__init__(self)
		self.macOSError = macOSError
	
	def __repr__(self):
		return 'ComponentError(%r)' % self.macOSError
	
	__str__ = __repr__


class ScriptError(ComponentError):
	def __init__(self):
		ComponentError.__init__(self, errOSAScriptError)


#######

def raiseError(code, msg=''): # msg is used in debugging messages only
	print >> stderr, 'MacPythonOSA error %r: %s' % (code, msg)
	if exc_info()[0]:
		print >> stderr, 'Traceback:\n==========' # TEST
		print_exc() # TEST # TO FIX: not always called in response to a trapped exception
		print >> stderr, '\n==========' # TEST
	raise ComponentError(code)

def raiseScriptError(source, msg=''): # TO DO: caller should pass 'compilation', 'initialisation' or 'execution' to be included in error description, as in 'A TypeError occurred during execution: ...' # TO DO: make this function private
	# TO DO: no good if there wasn't an error occurred prior to execution; move exc_info() call to callers and have them pass error info here? Or supply alternative constructor function?
	global _errType, _errValue, _errTrace, _errStart, _errEnd
	_errType, _errValue, traceback = exc_info()
	_errStart, _errEnd, _errTrace = _extractTraceInfo(traceback, source)
	#print >> stderr, 'Script error: %s Traceback:' % msg # TEST
	#print_exception(_errType, _errValue, traceback) # TEST
	raise ScriptError

def raiseScriptCompileError(source, msg=''): # TO DO: rename raiseCompilationError
	global _errType, _errValue, _errTrace, _errStart, _errEnd
	_errType, value = exc_info()[:2]
	_errTrace = None
	_errStart, _errEnd, _errValue = _extractCompileErrorInfo(value, source)
	raise ScriptError

# TO DO: raiseInitialisationError(), raiseExecutionError()

#######

def scriptErrorNumber():
	return 10000 # TO DO: map default error types to custom 'application-defined' range (SInt16)

def scriptErrorMessage():
	name = _errType.__name__
	return '%s %s occurred:\n  %s' % (name[0] in 'aeiouAEIOU' and 'An' or 'A', name, _errValue) + (_errTrace and ('\n\nTraceback (oldest call first):\n%s' %_errTrace) or '')

def briefScriptErrorMessage():
	return '%s: %s' % (_errType.__name__, _errValue)

def errorApp(): # return PSN or name of errant application, if error was the result of an AESend
	return None # TO DO: how to obtain this value? probably have a MacOS.Error subclass in aem that includes application info

def scriptErrorRange():
	#print 'RANGE:', _errStart, _errEnd
	return _errStart, _errEnd

