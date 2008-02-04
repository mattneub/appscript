#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem.ae import *
from aem import Codecs, Application

codecs = Codecs()

osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

scriptDesc = codecs.pack('''
tell app "finder" to home
''')



f = osac.OSAGetSendProc()

print f


def c(ae, m, p, t):
	print
	print 'EVT', `ae.type, ae.data[:64] + (ae.data[64:] and '...' or '')`
	
	try:
		r=f(ae, m, p, t)
	except Exception, e:
		print 'ERROR', e
		r = Application().event('aevtansr', {'errn':e[0]}).AEM_event
	print 'RES', `r.type, r.data[:64] + (r.data[64:] and '...' or '')`
	print
	
	return r

osac.OSASetSendProc(c)


print `codecs.unpack(osac.OSADoScript(scriptDesc, 0, typeChar, 0))`

print osac.OSAGetSendProc()

print

osac.OSASetSendProc(f)

print `codecs.unpack(osac.OSADoScript(scriptDesc, 0, typeChar, 0))`



print osac.OSAGetSendProc()