
#
# pyosa_errors.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
#

import MacOS
from sys import exc_info, stderr
from traceback import extract_tb, print_stack

from aem.kae import *
from pyosa_appscript import aem, appscript

#######

errOSACantCoerce = -1700
OSAMissingParameter = -1701
errOSACorruptData = -1702
errOSATypeError = -1703
OSAMessageNotUnderstood = -1708
OSAUndefinedHandler = -1717
OSAIllegalIndex = -1719
OSAIllegalRange = -1720
OSAParameterMismatch = -1721
OSAIllegalAccess = -1723
errOSACantAccess = -1728
errOSARecordingIsAlreadyOn = -1732
errOSASystemError = -1750
errOSAInvalidID = -1751
errOSABadStorageType = -1752
errOSAScriptError = -1753
errOSABadSelector = -1754
errOSASourceNotAvailable = -1756
errOSANoSuchDialect = -1757
errOSADataFormatObsolete = -1758
errOSADataFormatTooNew = -1759
errOSAComponentMismatch = -1761
errOSACantOpenComponent = -1762
errOSAGeneralError = -2700
errOSADivideByZero = -2701
errOSANumericOverflow = -2702
errOSACantLaunch = -2703
errOSAAppNotHighLevelEventAware = -2704
errOSACorruptTerminology = -2705
errOSAStackOverflow = -2706
errOSAInternalTableOverflow = -2707
errOSADataBlockTooLarge = -2708
errOSACantGetTerminology = -2709
errOSACantCreate = -2710
OSASyntaxError = -2740
OSASyntaxTypeError = -2741
OSATokenTooLong = -2742
OSADuplicateParameter = -2750
OSADuplicateProperty = -2751
OSADuplicateHandler = -2752
OSAUndefinedVariable = -2753
OSAInconsistentDeclarations = -2754
OSAControlFlowError = -2755
OSAIllegalAssign = -10003
errOSACantAssign = -10006


kScriptErrorSelectors = [kOSAErrorNumber,
						 kOSAErrorMessage,
						 kOSAErrorBriefMessage,
						 kOSAErrorApp,
						 kOSAErrorPartialResult,
						 kOSAErrorOffendingObject,
						 kOSAErrorExpectedType,
						 kOSAErrorRange]


#######
# note: use raisecomponenterror function to raise ComponentErrors

class ComponentError(StandardError):
	# Represents errors intentionally raised by PyOSA code
	
	_genericerrormessages = { # cribbed from OSA reference docs
		-1700: "A value can't be coerced to the desired type.",
		-1701: "A parameter is missing for a function invocation.",
		-1702: "Some data could not be read.",
		-1703: "Same as errAEWrongDataType; wrong descriptor type.",
		-1708: "A message was sent to an object that didn't handle it.",
		-1717: "A function to be returned doesn't exist.",
		-1719: "An index was out of range. Specialization of errOSACantAccess.",
		-1720: "The specified range is illegal. Specialization of errOSACantAccess.",
		-1721: "The wrong number of parameters were passed to the function, or a parameter pattern cannot be matched.",
		-1723: "A container can not have the requested object.",
		-1728: "An object is not found in a container.",
		-1732: "Recording is already on. Available only in version 1.0.1 or greater.",
		-1750: "Scripting component error.",
		-1751: "Invalid script id.",
		-1752: "Script doesn't seem to belong to AppleScript.",
		-1753: "Script error.",
		-1754: "Invalid selector given.",
		-1756: "Invalid access.",
		-1757: "Source not available.",
		-1758: "No such dialect.",
		-1759: "Data couldn't be read because its format is obsolete.",
		-1761: "Parameters are from two different components.",
		-1762: "Can't connect to system with that ID.",
		-2700: "No actual error code is to be returned.",
		-2701: "An attempt to divide by zero was made.",
		-2702: "An integer or real value is too large to be represented.",
		-2703: "An application can't be launched, or when it is, remote and program linking is not enabled.",
		-2704: "An application can't respond to AppleEvents.",
		-2705: "An application's terminology resource is not readable.",
		-2706: "The runtime stack overflowed.",
		-2707: "A runtime internal data structure overflowed.",
		-2708: "An intrinsic limitation is exceeded for the size of a value or data structure.",
		-2709: "Can't get the event dictionary.",
		-2710: "Can't make class <class identifier>.",
		-2740: "A syntax error occured.",
		-2741: "Another form of syntax was expected.",
		-2742: "A name or number is too long to be parsed.",
		-2750: "A formal parameter, local variable, or instance variable is specified more than once.",
		-2751: "A formal parameter, local variable, or instance variable is specified more than once.",
		-2752: "More than one handler is defined with the same name in a scope where the language doesn't allow it.",
		-2753: "A variable is accessed that has no value.",
		-2754: "A variable is declared inconsistently in the same scope, such as both local and global.",
		-2755: "An illegal control flow occurs in an application. For example, there is no catcher for the throw, or there was a non-lexical loop exit.",
		-10003: "An object can never be set in a container",
		-10006: "An object cannot be set in a container.",
	}
	
	originalexception = None
	errorrange = (0, 0)
	traceback = ''
	
	def __init__(self, errornumber, errormessage=''):
		StandardError.__init__(self, errornumber)
		self.errornumber = errornumber
		self.errormessage = errormessage or self._genericerrormessages.get(
				errornumber, 'An error %i occurred.' % errornumber)
	
	def __repr__(self):
		return 'ComponentError(%r)' % self.errornumber


#######
# note: use raisescripterror function to raise ScriptErrors

class ScriptError(StandardError):
	# Represents errors raised in client scripts
	
	def __init__(self, errornumber, errormessage, originalexception, traceback, source):
		StandardError.__init__(self, errornumber, errormessage, originalexception, traceback)
		print >> stderr, 'ScriptError traceback %r' % traceback # debug
		self.errornumber = errornumber
		self.errormessage = errormessage
		self.originalexception = originalexception
		self._tracebackobj = traceback
		self._source = source
		self._errorrange = None
		self._tracebackstring = ''
	
	def __repr__(self):
		return 'ScriptError(%r, %r, %s(%s))' % (self.errornumber, self.errormessage, 
				self.originalexception.__class__.__name__,
				', '.join([repr(arg) for arg in self.originalexception.args]))
	
	#######
	
	def _formattrace(traces):
		res = []
		curpath = None
		for path, linenum, funcname, linecode in traces:
			if path != curpath:
				res.append('  %s:' % path)
				curpath = path
			if len(linecode) > 40:
				linecode = linecode[:35] + '...' + linecode[-5:]
			res.append('    Line %i%s:\n      %s' % (linenum, 
					funcname and (' in %s' % funcname) or '', linecode))
		return '\n'.join(res)
	_formattrace = staticmethod(_formattrace)


	def _extracttracebackinfo(self):
		# used for initialisation and execution errors
		# TO DO: long/recursive traces should be truncated for space
		if not self._source:
			self._errorrange = (0, 0)
		traces = extract_tb(self._tracebackobj)[1:]
		paras = self._source.replace('\r', '\n').split('\n')
		if not traces:
			self._errorrange = (0, 0)
		tracecount = 0
		previouslinenum = 0
		while tracecount < len(traces):
			path, linenum, funcname, linecode = traces[tracecount]
			if path != '<PyOSAScript>': # TO DO: this'll mess up on errors in imported modules
				break
			previouslinenum = linenum
			traces[tracecount] = (path, #('This script',
					linenum,
					funcname != '?' and funcname or None,
					linecode or paras[linenum - 1].lstrip('\t '))
			tracecount += 1
		# (note: line numbers are 1-indexed; convert to 0-index for list lookup)
		startindex = len('\n'.join(paras[:previouslinenum - 1]) + '\n')
		self._errorrange = (startindex, startindex + len(paras[previouslinenum - 1]))
		self._tracebackstring = self._formattrace(traces)


	def _extractcompilationerrorinfo(self):
		try:
			paras = self._source.replace('\r', '\n').split('\n')
			lineindex = len('\n'.join(paras[:self.originalexception.lineno - 1]) + '\n')
			startindex = lineindex + self.originalexception.offset - 1
			endindex = lineindex + len(paras[self.originalexception.lineno - 1])
			if startindex == endindex: # indentation error returns offset for end, not start, of line for some reason
				startindex = lineindex
			self._errorrange = (startindex, endindex)
		except: # if compile() raises TypeError due to null chars in source string, can't get linenum
			self._errorrange = (0, 0)
	
	#######
	
	def setsource(self, source):
		self._source = source
	
	def errorrange(self):
		if not self._errorrange:
			if self.errornumber == OSASyntaxError:
				self._extractcompilationerrorinfo()
			else:
				self._extracttracebackinfo()
#		print >> stderr, 'Error range: %r' % (self._errorrange,) # debug
		return self._errorrange
	errorrange = property(errorrange)
			
	
	def traceback(self):
		self.errorrange
		print >> stderr, 'Traceback:\n%s\n\n' % (self._tracebackstring,) # debug
		return self._tracebackstring
	traceback = property(traceback)



#######
# raise script and component errors

def raisecomponenterror(errornumber, errormessage=''):
	print >> stderr, 'raise ComponentError:'
	print >> stderr, '-' * 80
	print_stack(None, 20, stderr)
	print >> stderr, '-' * 80
	print >> stderr
	raise ComponentError(errornumber, errormessage)
	

def raisescripterror(errornumber, briefmessage, originalexception, source):
	# TO DO: using exc_info here may cause circular references that leak memory; need to check this
	if errornumber == OSASyntaxError:
		raise ScriptError(errornumber, briefmessage, originalexception, None, source)
	else:
		raise ScriptError(errornumber, briefmessage, originalexception, exc_info()[2], source)


#######
# determine OSA error information from ScriptError instance, and pack into AEDescs; 
# called by raisePythonError in pythonerrors.c


def packerror(selector, desiredtype, errorobj, codecs):
	if selector == kOSAErrorNumber: print >> stderr, 'packerror selector=%r desiredtype=%r\n    errorobj=%r' % (selector, desiredtype, errorobj) # debug
	if selector not in kScriptErrorSelectors:
		raisecomponenterror(errOSABadSelector)
	if isinstance(errorobj, ScriptError):
		# TO DO: some/all of this code should be moved into a ScriptError method)
		originalexception = errorobj.originalexception
		if selector == kOSAErrorNumber:
			# TO DO: if errOSAGeneralError, try to determine a more specific runtime error number, e.g. if MacOS.Error/aem.CommandError/appscript.CommandError, get error number from that; if TypeError, use errOSACantCoerce, etc.
			val = errorobj.errornumber 
		elif selector == kOSAErrorMessage:
			val = '%s: %s\n\n%s' % (errorobj.errormessage, errorobj.originalexception, errorobj.traceback)
		elif selector == kOSAErrorBriefMessage:
			val = '%s: %s' % (errorobj.errormessage, errorobj.originalexception)
			val = str(errorobj.originalexception)
		elif selector == kOSAErrorApp:
		# The value of desiredType must be typeProcessSerialNumber (for the PSN) or a text descriptor type such as typeChar (for the name).
				val = '<Unknown Application>'
		elif selector == kOSAErrorPartialResult:
			val = None
		elif selector == kOSAErrorOffendingObject:
			val = None
		elif selector == kOSAErrorExpectedType:
			val = None
		else: # selector == kOSAErrorRange
			startindex, endindex = errorobj.errorrange
			val = codecs.pack({
					aem.AEType(keyOSASourceStart): startindex, 
					aem.AEType(keyOSASourceEnd): endindex,
					}).coerce(typeOSAErrorRange)
	elif isinstance(errorobj, ComponentError):
		# TO DO: some/all of this code should be moved into a ComponentError method)
		if selector == kOSAErrorNumber:
			val = errorobj.errornumber
		elif selector in [kOSAErrorMessage, kOSAErrorBriefMessage]:
			val = errorobj.errormessage
		else:
			val = None
	else: # unexpected error
		if selector == kOSAErrorNumber:
			val = errOSASystemError
		elif selector in [kOSAErrorMessage, kOSAErrorBriefMessage]:
			val = 'PyOSA encountered an internal bug (see stderr for details): %s' % errorobj
		else:
			val = None
#	print >> stderr, '    value=%r' % val # debug
	desc = codecs.pack(val)
#	print >> stderr, '    desc=%r' % desc # debug
	try:
		return desc.coerce(desiredtype)
	except MacOS.Error:
		raisecomponenterror(errOSACantCoerce)

