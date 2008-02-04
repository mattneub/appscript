#!/usr/local/bin/python

from Carbon.Cm import OpenDefaultComponent
from osascript.osa import OSAComponentInstance
from aem.kae import *
from aem import Codecs

codecs = Codecs()

osac = OSAComponentInstance(OpenDefaultComponent('osa ', 'ascr'))

scriptDesc = codecs.pack('''
delay 1
42
''')

i = 0

f = osac.OSAGetActiveProc()

def activeProc():
	global i
	i+=1
	r = f()
	if r: print 'Err', r
	return r

print f

print f()

osac.OSASetActiveProc(activeProc)

print `codecs.unpack(osac.OSADoScript(scriptDesc, 0, typeChar, 0))`

print osac.OSAGetActiveProc()

print i

i = 0

osac.OSASetActiveProc(f)

print `codecs.unpack(osac.OSADoScript(scriptDesc, 0, typeChar, 0))`

print i



print osac.OSAGetActiveProc()