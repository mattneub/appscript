
#
# pyosa_scriptmanager.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
# Defines ScriptManager class, instances of which are used by osafunctions.c to
# load/store/compile/run/etc. client scripts, and to hold and display result values.
#

# IMPORTANT NOTE: C code retains ownership of all CarbonX.AEDescs passed as arguments,
# and takes ownership of all CarbonX.AEDescs returned as results. Python code must NOT
# retain these AEDescs after returning control to C code or memory errors will occur.

import MacOS, struct
from sys import stderr
from pprint import pprint
from StringIO import StringIO
from copy import deepcopy

from CarbonX.kOSA import *
from CarbonX.AE import AECreateDesc, AEDesc
import appscript.reference

from pyosa_errors import *
from pyosa_scriptcontext import *
from pyosa_serialization import *
from pyosa_appscript import *
from pyosa_colorizesource import *

# TO DO: packing of appscript Keyword instances in coercetodesc will be tricky: keywords don't contain AEDesc info, so those identifying external applications often won't pack correctly/at all via the host codecs - not sure how to deal with this yet

#######

kSendFlagsMask = ( kOSAModeNeverInteract
				 | kOSAModeCanInteract
				 | kOSAModeAlwaysInteract
				 | kOSAModeDontReconnect
				 | kOSAModeCantSwitchLayer
				 | kOSAModeDoRecord
				 )

#######


class ScriptManager:
	def __init__(self, appscriptservices):
		self.appscriptservices = appscriptservices
		self._reset()
	
	def _reset(self):
		self.source = None # TO DO: issource
		self.state = {}
		self.initialstate = {}
		self.context = None
		self.fsref = None
		self.value = None
		self.isvalue = False
		self.ismodified = False
		self.modeflags = 0
		self.sendflags = 0


	#######
	
	def _coercedesc(self, desc, desiredtype):
		if desiredtype in [typeWildCard, typeBest] or desc.type == typeNull:
			return desc.AEDuplicateDesc()
		try:
			return desc.AECoerceDesc(desiredtype)
		except MacOS.Error:
			raisecomponenterror(errOSACantCoerce)
	
	
	def _appidentity(self, target):
		if isinstance(target, appscript.reference.Application):
			target = target.AS_appdata.target
		if isinstance(target, aem.Application):
			target = target.AEM_identity
		return target
	
	
	def _formatevent(self, desc): # TO DO: finish
		code = desc.AEGetAttributeDesc('evcl', '****').data \
				+ desc.AEGetAttributeDesc('evid', '****').data
		target = desc.AEGetAttributeDesc('addr', '****')
		if code == 'ascrgdte':
			return '\nGET AETE: %r %r' % (target.type, target.data)
		if code in ['ascrtell', 'ascrtend']: # Python doesn't do 'tell' blocks, so ignore these
			return ''
		elif code == 'ascrcmnt':
			if self._appidentity(target) == ('desc', 
					('psn ', '\x00\x00\x00\x00\x00\x00\x00\x02')):
				try:
					data = desc.AEGetParamDesc('----', '****')
				except:
					return '\n#'
				else:
					return '\n# %r' % self.appscriptservices.unpack()
		code, atts, params = self.appscriptservices.unpackappleevent(desc)
		# TO DO: if psn target, get app's path; if url target, get url; then construct app object using these for readability (note: this isn't ideal since there might be >1 instance of an app; the alternative is to improve appscript's repr support)
		targetapp = self.appscriptservices.unpack(target)
		parameters = {}
		for i in range(desc.AECountItems()):
			key, value = desc.AEGetNthDesc(i + 1, typeWildCard)
			parameters[key] = targetapp.AS_appdata.unpack(value)
		s = StringIO()
		pprint(atts, s)
		pprint(parameters, s)
		return '\nEVENT: %r %r \n\t%s' % (code, self._appidentity(targetapp), s.getvalue().replace('\n', '\n\t'))
	
	
	#######
	# set script/value
	
	
	def compile(self, sourcedesc, modeflags):
		print >> stderr, 'Compiling (as context=%r)' % bool(modeflags & kOSAModeCompileIntoContext) # debug
		self._reset()
		self.ismodified = True
		self.source = self.appscriptservices.unpack(sourcedesc)
		if modeflags & kOSAModeCompileIntoContext: # make permanent context
			self.context = ScriptContext(self.appscriptservices, self.source)
		
	
	def load(self, scriptdesc, modeflags):
		# TO DO: what modeflags to use?
		self._reset()
		self.modeflags = modeflags
		self.source, self.state, modeflags = unpackscript(scriptdesc, self.appscriptservices)
		self.initialstate = deepcopy(self.state)
		if self.modeflags & kOSAModeCompileIntoContext:
			self.context = ScriptContext(self.appscriptservices, self.source, self.state)
		
	
	def coercefromdesc(self, desc, modeflags):
		print >> stderr, "Coercing from desc: %r (%r) %08x" % (desc.type, desc.data[:64], modeflags) # debug
		self._reset()
		self.ismodified = True
		if desc.type == typeAppleEvent:
			self.source = self._formatevent(desc)
		else:
			self.isvalue = True
			self.value = desc
	
	
	def setvalue(self, value):
		self._reset()
		self.isvalue = True
		self.value = value # TO DO: cache packed value for efficiency; provide value() and valuedesc() methods
		print >> stderr, 'setting value' #'SETVALUE: %r' % (value,) # debug
			
	
	#######
	# execute
	
	def execute(self, parentcontext, modeflags):
		# TO DO: what modeflags to use?
		# TO DO: parentcontext support
		# - If current script isn't a context, exec it in the parent context, calling its run handler if it has one? (not making the run handler compulsory when current script isn't a context should allow PyOSA to work better with command-line-style environments such as Smile text windows or SD console)
		# - How to support parent contexts when current script is also a context (bearing in mind that, unlike AppleScript script objects, Python modules don't do automatic delegation)? Assign parent context to a top-level 'parent' variable, which can then be used to access/manipulate the parent's contents?
		if self.context:
			context = self.context
		elif self.source is not None:
			if context:
				context.compile(self.source)
			else: # make temporary context
				context = ScriptContext(self.appscriptservices, self.source)
				self.state = context.state()
		else:
			raisecomponenterror(errOSACantAccess)
		res = context.execute(modeflags)
		return res
	
	
	def executeevent(self, event, modeflags):
		if self.context:
			context = self.context
		else: # make temporary context
			context = ScriptContext(self.appscriptservices, self.source, self.state)
			self.state = context.state()
		code, atts, params = self.appscriptservices.unpackappleevent(event)
		result = context.handleevent(code, atts, params, modeflags)
		return result

	
	def doevent(self, event, modeflags, reply):
		try:
			result = self.executeevent(event, modeflags)
		except ScriptError, e:
			for key in kScriptErrorSelectors:
				desc = packerror(key, typeWildCard, self.source, e)
				if desc.type != typeNull:
					reply.AEPutParamDesc(key, desc)
		else:
			if result is not None:
				reply.AEPutParamDesc('----', self.appscriptservices.pack(result))
	
	
	#######
	# info
	
	def setscriptinfo(self, selector, value):
		if selector == kOSAScriptIsModified:
			self.ismodified = bool(value)
		else:
			raisecomponenterror(errOSACantAccess)
	
	
	def setscriptfile(self, fsref):
		self.fsref = fsref
	
	
	def scriptinfo(self, selector):
		if selector == kOSAScriptIsModified:
			if self.ismodified: 
				res = True
			elif self.context:
				res = self.context.state() != self.initialstate
			else:
				res = self.state != self.initialstate
			return int(res)
		elif selector == kOSAScriptIsTypeCompiledScript:
			return int(self.source is not None)
		elif selector == kOSAScriptIsTypeScriptValue:
			return int(self.isvalue)
		elif selector == kOSAScriptIsTypeScriptContext:
			return int(self.context is not None)
		elif selector == kOSAScriptBestType:
			if self.isvalue:
				return struct.unpack('l', self.appscriptservices.pack(value).type)[0]
			else:
				return struct.unpack('l', typeScript)[0]
		elif selector == kOSACanGetSource:
			return 1
		elif selector == kASHasOpenHandler:
			if not self.context:
				raisecomponenterror(errOSACantAccess)
			return self.context.hasopenhandler()
		else:
			raisecomponenterror(errOSACantAccess)
	
	
	#######
	# get script/value
	
	
	def store(self, modeflags):
		# TO DO: what modeflags to use?
		if self.source is not None:
			if self.context:
				state = self.context.state()
			else:
				state = self.state
			return packscript(self.source, state, modeflags, self.appscriptservices)
		elif self.isvalue:
			return packscript(self.display(typeUnicodeText, kOSAModeNull), state, modeflags, self.appscriptservices)
		else:
			raisecomponenterror(errOSACantAccess)
	
	
	def display(self, desiredtype, modeflags):
		#print >> stderr, 'display() desiredtype=%r modeflags=%08x' % (desiredtype, modeflags) # debug
		if self.source is not None:
			desc = self.appscriptservices.pack('<PyOSAScript>')
		elif self.isvalue:
			if 1: # modeflags & kOSAModeDisplayForHumans: # TEST # TO DO: always pretty print? (it would make list and dict results easier to read)
				res = StringIO()
				pprint(self.valueaspyobject(), res)
				val = res.getvalue()
			else:
				val = repr(self.valueaspyobject())
			desc = self.appscriptservices.pack(val)
		else:
			raisecomponenterror(errOSACantAccess)
		if desiredtype == typeStyledText: # colour as compiled source code
			try:
				return sourcetostyledtext(desc)
			except: # if anything goes wrong, ignore and display as uncoloured text
				pass
		return self._coercedesc(desc, desiredtype)
	
	
	def coercetodesc(self, desiredtype, modeflags):
		print >> stderr, 'coercetodesc: %r %x' % (desiredtype, modeflags) # debug
		if self.source:
			desc = self.store(kOSAModeNull)
		elif self.isvalue:
			try:
				desc = self.valueasaedesc(bool(modeflags & kOSAModeFullyQualifyDescriptors))
			except Exception, e:
				print >> stderr, "Couldn't coerce to desc: %s" % e # debug
				pprint(self.valueaspyobject(), stderr) # debug
				print >> stderr # debug
				raisecomponenterror(errOSACantCoerce)
		else:
			raisecomponenterror(errOSACantAccess)
		print >> stderr, '    desctype = %r' % desc.type # debug
		return self._coercedesc(desc, desiredtype)
	
	
	def sourceaspyobject(self): # TO DO: unused
		return self.source or ''
	
	
	def sourceasaedesc(self, desiredtype):
		if self.source is not None:
			desc = self.appscriptservices.pack(self.source)
		elif self.isvalue:
			desc = self.appscriptservices.pack(repr(self.valueaspyobject()))
		else:
			raisecomponenterror(errOSACantAccess)
		if desiredtype == typeStyledText: # colour compiled source code
			try:
				return sourcetostyledtext(desc)
			except MacOS.Error:
				pass
		return self._coercedesc(desc, desiredtype)
		
	
	def valueaspyobject(self):
		if isinstance(self.value, AEDesc):
			return self.appscriptservices.unpack(self.value)
		else:
			return self.value
	
	
	def valueasaedesc(self, fullyqualifydescriptors=False): 
		if isinstance(self.value, AEDesc):
			return self.value
		elif fullyqualifydescriptors:
			print >> stderr, 'PyOSA note: client requested fully qualify descriptors for value (note: this is not yet implemented):' # debug
			pprint(self.value, stderr) # debug
			print >> stderr # debug
			return self.appscriptservices.pack(self.value) # TO DO: use qualifiedpack
		else:
			return self.appscriptservices.pack(self.value)
	
	
	#######

