#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem.ae import *
from aem import Codecs, Application

codecs = Codecs()

osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

scriptDesc = codecs.pack('''
continue foo()
log 42
99
''')

osac.OSASetDefaultTarget(AECreateDesc(typeNull, ''))

scriptID = osac.OSACompile(scriptDesc, kOSAModeCompileIntoContext, 0)



def fn(ae):
	print
	print 'EVT', `ae.type, ae.data[:64] + (ae.data[64:] and '...' or '')`
	#raise 'fuk'
	r = Application().event('aevtansr', {'----':10000}).AEM_event
	print 'RES', `r.type, r.data[:64] + (r.data[64:] and '...' or '')`
	print
	return r



osac.OSASetResumeDispatchProc(fn)
print osac.OSAGetResumeDispatchProc()
i = osac.OSAExecute(scriptID, 0, 0)
print `codecs.unpack(osac.OSADisplay(i, typeWildCard, 0))`


print osac.OSAGetResumeDispatchProc()
print `codecs.unpack(osac.OSADoScript(scriptDesc, 0, typeChar, 0))`

osac.OSASetResumeDispatchProc((kOSANoDispatch, 0))
print osac.OSAGetResumeDispatchProc()
print `codecs.unpack(osac.OSADoScript(scriptDesc, 0, typeChar, 0))`

osac.OSASetResumeDispatchProc((kOSAUseStandardDispatch, kOSADontUsePhac))
print osac.OSAGetResumeDispatchProc()

