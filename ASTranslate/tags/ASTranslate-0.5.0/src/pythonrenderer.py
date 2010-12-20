""" pythonrenderer -- render Apple events as Python 2.x code """

import os.path

from aem import kae
from appscript import referencerenderer
import appscript

from constants import *

######################################################################
# PRIVATE
######################################################################


_commandscache = {}

_originalformatter = referencerenderer._Formatter

class ReFormatter(_originalformatter):
	def __init__(self, appdata, nested=False):
		_originalformatter.__init__(self, appdata, nested)
		# appscript shows full app path in references, but just want visible name here for simplicity
		if not nested and self._appdata.constructor == 'path':
			name = os.path.basename(appdata.identifier)
			if name.lower().endswith('.app'):
				name = name[:-4]
			self.root = 'app(%r)' % name

referencerenderer._Formatter = ReFormatter


def renderobject(obj):
	if isinstance(obj, list):
		return '[%s]' % ', '.join([renderobject(o) for o in obj])
	elif isinstance(obj, dict):
		return '{%s}' % ', '.join(['%s: %s' % (renderobject(k), renderobject(v)) for k, v in obj.items()])
	elif isinstance(obj, appscript.Reference):
		return referencerenderer.renderreference(obj.AS_appdata, obj.AS_aemreference, True)
	else:
		return repr(obj)


######################################################################
# PUBLIC
######################################################################


def renderCommand(appPath, addressdesc, eventcode, 
		targetRef, directParam, params, 
		resultType, modeFlags, timeout, 
		appdata):
	args = []
	if not _commandscache.has_key((addressdesc.type, addressdesc.data)):
		_commandscache[(addressdesc.type, addressdesc.data)] = dict([(data[1][0], (name, 
				dict([(v, k) for (k, v) in data[1][-1].items()])
				)) for (name, data) in appdata.referencebyname().items() if data[0] == 'c'])
	commandsbycode = _commandscache[(addressdesc.type, addressdesc.data)]
	commandName, argNames = commandsbycode[eventcode]
	if directParam is not kNoParam:
		args.append(renderobject(directParam))
	for key, val in params.items():
		args.append('%s=%s' % (argNames[key], renderobject(val)))
	if resultType:
		args.append('resulttype=%s' % renderobject(resultType))
	if modeFlags & kae.kAEWaitReply != kae.kAEWaitReply:
		args.append('waitreply=False')
	if timeout != -1:
		args.append('timeout=%i' % (timeout / 60))
	return '%r.%s(%s)' % (targetRef, commandName, ', '.join(args))


