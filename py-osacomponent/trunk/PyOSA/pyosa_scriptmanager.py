#!/usr/local/bin/python

# IMPORTANT NOTE: C code retains ownership of all CarbonX.AEDescs passed as arguments,
# and takes ownership of all CarbonX.AEDescs returned as results. Python code must NOT
# retain these AEDescs after returning control to C code or memory errors will occur.

import MacOS
from sys import stderr
from pprint import pprint
from StringIO import StringIO

from CarbonX.kOSA import *
from CarbonX.AE import AECreateDesc, AEDesc

from pyosa_errors import *
from pyosa_scriptcontext import *
from pyosa_serialization import *
from pyosa_appscript import *

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
		self.source = None # TO DO: issource
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
			raiseComponentError(errOSACantCoerce)


	def _sourcetostyledtext(self, desc):
		# (note: Script Editor likes to ask for typeStyledText when it calls OSADisplay and OSAGetSource)
		return self.appscriptservices.pack({
				aem.AEType(keyAEText): desc.AECoerceDesc(typeChar),
				aem.AEType(keyAEStyles): AECreateDesc(typeScrapStyles, 
						'\x00\x01\x00\x00\x00\x00\x00\x10\x00\x0e\x00\x03\x00\x00\x00\x0c\x00\x00\x00\x00\xBB\x00') # blue text
				}).AECoerceDesc(typeStyledText)
	
	
	#######
	
	def setvalue(self, value):
		self.isvalue = True
		self.value = value # TO DO: cache packed value for efficiency; provide value() and valuedesc() methods
		print 'SETVALUE: %r' % (value,)
	
	
	def getpysource(self):
		return self.source or ''
		
	
	def valueaspythonvalue(self):
		if isinstance(self.value, AEDesc):
			return self.appscriptservices.unpack(self.value)
		else:
			return self.value
	
	def valueasaedesc(self, fullyqualifydescriptors=False): 
		if isinstance(self.value, AEDesc):
			return self.value
		elif fullyqualifydescriptors:
			print 'PyOSA note: client requested fully qualify descriptors for value:'
			pprint(self.value)
			print
			return self.appscriptservices.pack(self.value) # TO DO: use qualifiedpack
		else:
			return self.appscriptservices.pack(self.value)
	
	
	
	#######
	
	def store(self, modeflags):
		# TO DO: what modeflags to use?
		if self.source is not None:
			if self.context:
				state = self.context.state()
			else:
				state = {}
			return packscript(self.source, state, modeflags, self.appscriptservices)
		elif self.isvalue:
			return packscript(self.display(typeUnicodeText, kOSAModeNull), {}, modeflags, self.appscriptservices)
		else:
			raiseComponentError(errOSACantAccess)
		
	
	def load(self, scriptdesc, modeflags):
		# TO DO: what modeflags to use?
		self.modeflags = modeflags
		self.source, state, modeflags = unpackscript(scriptdesc, self.appscriptservices)
		if self.modeflags & kOSAModeCompileIntoContext:
			self.context = ScriptContext(self.appscriptservices, self.source, state)
			
	
	#######
	
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
			else:
				context = ScriptContext(self.appscriptservices, self.source)
		else:
			raiseComponentError(errOSACantAccess)
		res = context.execute(modeflags)
		return res
	
	
	def display(self, desiredtype, modeflags):
		#print 'display() desiredtype=%r modeflags=%08x' % (desiredtype, modeflags)
		if self.source is not None:
			desc = self.appscriptservices.pack('<PyOSAScript>')
		elif self.isvalue:
			if modeflags & kOSAModeDisplayForHumans:
				res = StringIO()
				pprint(self.valueaspythonvalue(), res)
				val = res.getvalue()
			else:
				val = repr(self.valueaspythonvalue())
			desc = self.appscriptservices.pack(val)
		else:
			raiseComponentError(errOSACantAccess)
		return self._coercedesc(desc, desiredtype)
	
	
	#######
	
	def setscriptinfo(self, selector, value):
		if selector == kOSAScriptIsModified:
			self.ismodified = bool(value)
		else:
			raiseComponentError(errOSACantAccess)
	
	
	def setscriptfile(self, fsref):
		self.fsref = fsref
	
	
	def getscriptinfo(self, selector):
		if selector == kOSAScriptIsModified:
			return int(self.ismodified or (self.context and self.context.ismodified()))
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
				raiseComponentError(errOSACantAccess)
			return self.context.hasopenhandler()
		else:
			raiseComponentError(errOSACantAccess)
	
	
	#######
	
	def compile(self, sourcedesc, modeflags):
		print 'Compiling...'
		self.source = self.appscriptservices.unpack(sourcedesc)
		if modeflags & kOSAModeCompileIntoContext:
			self.context = ScriptContext(self.appscriptservices, self.source)
		print '\tDone.'
	
	
	#######
	
	def getsource(self, desiredtype):
		if self.source is not None:
			desc = self.appscriptservices.pack(self.source)
		elif self.isvalue:
		
			desc = self.appscriptservices.pack(repr(self.valueaspythonvalue()))
		else:
			raiseComponentError(errOSACantAccess)
		if desiredtype == typeStyledText: # colour compiled source code blue
			try:
				return self._sourcetostyledtext(desc)
			except MacOS.Error:
				pass
		return self._coercedesc(desc, desiredtype)
	
	def _identity(self, target): # TEST
		import appscript.reference
		if isinstance(target, appscript.reference.Application):
			return target.AS_appdata.target.AEM_identity
		elif isinstance(target, aem.Application):
			return target.AEM_identity
		return '???'
	
	def coercefromdesc(self, desc, modeflags):
		if desc.type == typeAppleEvent:
			code, atts, params = self.appscriptservices.unpackappleevent(desc)
			if code == 'ascrtell':
				target = params['----']
				self.source = '' #'TARGET: %r %r' % (target, self._identity(target))
			elif code == 'ascrtend':
				self.source = ''
			elif code == 'ascrgdte':
				target = atts['addr']
				self.source = '# getting terminology for %r' % self._identity(target)
			elif code == 'ascrcmnt' and \
					self._identity(atts['addr'])[1] == ('psn ', '\x00\x00\x00\x00\x00\x00\x00\x02'):
				if '----' in params:
					self.source = '# %r' % params['----']
				else:
					self.source = '#'
			else:
				target = atts['addr']
				self.source = 'EVENT: %r %r \n\t\t%r \n\t\t%r' % (code, self._identity(target), atts, params) # TO DO: format event as string
		else:
			self.value = desc
	
	
	def coercetodesc(self, desiredtype, modeflags):
		print 'coercetodesc: %r %x' % (desiredtype, modeflags)
		if self.source:
			desc = self.store(kOSAModeNull)
		elif self.isvalue:
			try:
				desc = self.valueasaedesc(bool(modeflags & kOSAModeFullyQualifyDescriptors))
			except Exception, e:
				print >> stderr, "Couldn't coerce to desc: %s" % e
				pprint(self.valueaspythonvalue(), stderr)
				print >> stderr
				raiseComponentError(errOSACantCoerce)
		else:
			raiseComponentError(errOSACantAccess)
		print '    desctype = %r' % desc.type
		return self._coercedesc(desc, desiredtype)
	
	
	#######
	
	def executeevent(self, event, modeflags):
		if not self.context:
			raiseComponentError(errOSACantAccess)
		code, atts, params = self.appscriptservices.unpackappleevent(event)
		result = self.context.handleevent(code, atts, params, modeflags)	
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

