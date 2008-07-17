
from aem import kae
from appscript import referencerenderer
import appscript
import os.path

_commandscache = {}


class ReFormatter(referencerenderer._Formatter):
	def __init__(self, appData, nested=False):
		self._appData = appData
		if nested:
			self.root = 'app'
		elif self._appData.constructor == 'current':
			self.root = 'app()'
		elif self._appData.constructor == 'path':
			name = os.path.basename(self._appData.identifier)
			if name.lower().endswith('.app'):
				name = name[:-4]
			self.root = 'app(%r)' % name
		else:
			self.root = 'app(%s=%r)' % (self._appData.constructor, self._appData.identifier)
		self.result = ''

referencerenderer._Formatter = ReFormatter


def renderobject(obj):
	if isinstance(obj, list):
		return '[%s]' % ', '.join([renderobject(o) for o in obj])
	elif isinstance(obj, dict):
		return '{%s}' % ', '.join([(renderobject(k), renderobject(v)) for k, v in obj.items()])
	elif isinstance(obj, appscript.Reference):
		return referencerenderer.renderreference(obj.AS_appdata, obj.AS_aemreference, True)
	else:
		return repr(obj)



def renderCommand(appPath, addressdesc, eventcode, 
		targetRef, directParam, params, 
		resultType, modeFlags, timeout, 
		appData):
	args = []
	if not _commandscache.has_key((addressdesc.type, addressdesc.data)):
		_commandscache[(addressdesc.type, addressdesc.data)] = dict([(data[1][0], (name, 
				dict([(v, k) for (k, v) in data[1][-1].items()])
				)) for (name, data) in appData.referencebyname.items() if data[0] == 'c'])
	commandsbycode = _commandscache[(addressdesc.type, addressdesc.data)]
	commandName, argNames = commandsbycode[eventcode]
	if directParam is not None:
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