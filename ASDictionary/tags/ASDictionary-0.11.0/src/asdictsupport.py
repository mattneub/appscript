#!/usr/local/bin/python

"""asdictsupport -- Provides support for asdict command line tool.

(C) 2007 HAS
"""

from getopt import getopt
from sys import argv, stderr, exit
from StringIO import StringIO

import appscript
from appscript import terminology
from aem.ae import GetAppTerminology as getaete
from osaterminology.dom import aeteparser, osadictionary
from osaterminology.renderers import htmldoc, quickdoc
from osaterminology.makeidentifier import getconverter
import aem
from aemreceive import *

import appscriptsupport


#######

_osaxpathsbyname = {}
#_se = app(id='com.apple.systemevents')
_se = aem.Application(aem.findapp.byid('com.apple.systemevents'))
#for domain in [_se.system_domain, _se.local_domain, _se.user_domain]:
for domain in ['flds', 'fldl', 'fldu']:
#	osaxen = domain.scripting_additions_folder.files[
#			(its.file_type == 'osax').OR(its.name_extension == 'osax')]
	osaxen = aem.app.property(domain).property('$scr').elements('file').byfilter(
			aem.its.property('asty').eq('osax').OR(aem.its.property('extn').eq('osax')))
#	for name, path in zip(osaxen.name(), osaxen.POSIX_path()):
	if _se.event('coredoex', {'----': osaxen.property('pnam')}).send(): # domain has ScriptingAdditions folder
		names = _se.event('coregetd', {'----': osaxen.property('pnam')}).send()
		paths = _se.event('coregetd', {'----': osaxen.property('posx')}).send()
		for name, path in zip(names, paths):
			if name.lower().endswith('.osax'):
				name = name[:-5]
			_osaxpathsbyname[name.lower()] = path


#######

def getaetedata(appname):
	if _osaxpathsbyname.has_key(appname.lower()):
		return getaete(_osaxpathsbyname[appname.lower()])
	elif appname.startswith('eppc://'):
		return terminology.aetedataforapp(aem.Application(url=appname))
	else:
		return getaete(aem.findapp.byname(appname))

def _makehelpobj(appname, style):
	# TO DO: osax support
	try:
		if appname.startswith('eppc://'):
			appobj = appscript.app(url=appname)
		else:
			appobj = appscript.app(appname)
	except appscript.ApplicationNotFoundError:
		raise EventHandlerError(-10000, 'Application %s not found.' % appname)
	helpobj = appscriptsupport.Help(appobj, style, StringIO())
#	del helpobj._handlers['h']
#	del helpobj._handlers['s']
	return helpobj


#######

_sessions = {}
_sessionID = 0

#######
# Event handlers

def exporttext(appname, style, optstr):
	opts, args = getopt(optstr, 'NHTs:cah')
	opts = dict(opts)
	out = StringIO()
	if _osaxpathsbyname.has_key(appname):
		appname = _osaxpathsbyname[appname]
	else:
		appname = aem.findapp.byname(appname)
	quickdoc.app(appname, out, getconverter(style))
	return out.getvalue()

installeventhandler(exporttext,
		'ASDiTEXT',
		('Appl', 'appname', 'utxt'),
		('Styl', 'style', 'utxt'),
		('Opts', 'optstr', 'utxt'))


def exporthtml(appname, style, optstr):
	opts, args = getopt(optstr, 'NHTs:cah')
	opts = dict(opts)
	if _osaxpathsbyname.has_key(appname):
		appname = _osaxpathsbyname[appname]
	else:
		appname = aem.findapp.byname(appname)
	aetedata = getaetedata(appname)
	terms = aeteparser.parseaetes(aetedata, appname, style)
	options = [option for flag, option in [('-c', 'collapse'), ('-a', 'showall')] if opts.has_key(flag)]
	return htmldoc.renderdictionary(terms, style, options)

installeventhandler(exporthtml,
		'ASDiHTML',
		('Appl', 'appname', 'utxt'),
		('Styl', 'style', 'utxt'),
		('Opts', 'optstr', 'utxt'))


def opensession(appname, style):
	global _sessionID
	_sessionID += 1
	session = str(_sessionID)
	_sessions[session] = _makehelpobj(appname, style)
	return session


installeventhandler(opensession,
		'ASDiOses',
		('Appl', 'appname', 'utxt'),
		('Styl', 'style', 'utxt'))


def closesession(session):
	del _sessions[session]

installeventhandler(closesession,
		'ASDiCses',
		('Sess', 'session', 'utxt'))


def help(appname=None, style=None, session=None, vieweroptions='-o'):
	if session:
		if _sessions.has_key(session):
			helpobj = _sessions[session]
		else: 
			# Session no longer exists as ASDictionary was restarted since session was created,
			# so automatically recreate session and continue as normal.
			# TO DO: visibility settings will currently return to default; either document this, or have
			# asdict supply visibility setting as well.
			_sessions[session] = helpobj = _makehelpobj(appname, style)
	else: # non-interactive; TO DO: caching
		helpobj = _makehelpobj(appname, style)
	output = helpobj.output
	output.truncate(0)
	helpobj.help(vieweroptions)
	return output.getvalue()

installeventhandler(help,
		'ASDiHelp',
		('Appl', 'appname', 'utxt'),
		('Styl', 'style', 'utxt'),
		('Sess', 'session', 'utxt'),
		('Opts', 'vieweroptions', 'utxt'))


def setvisibility(session, show):
	_sessions[session].terms.setvisibility({
			'all': osadictionary.kAll,
			'hidden': osadictionary.kHidden,
			'visible': osadictionary.kVisible,
			}[show])

installeventhandler(setvisibility,
		'ASDiSvis',
		('Sess', 'session', 'utxt'),
		('Show', 'show', 'utxt'))

