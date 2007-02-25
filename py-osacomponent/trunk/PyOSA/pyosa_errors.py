
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
from traceback import extract_tb

from CarbonX.kOSA import *
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
	
	def __init__(self, errornumber):
		StandardError.__init__(self, errornumber)
		self.errornumber = errornumber
	
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

def raisecomponenterror(errornumber):
	raise ComponentError(errornumber)
	

def raisescripterror(errornumber, briefmessage, originalexception, source):
	# TO DO: using exc_info here may cause circular references
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
					}).AECoerceDesc(typeOSAErrorRange)
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
		return desc.AECoerceDesc(desiredtype)
	except MacOS.Error:
		raisecomponenterror(errOSACantCoerce)

