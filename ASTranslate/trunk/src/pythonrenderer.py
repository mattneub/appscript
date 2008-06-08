
from aem import kae


_commandscache = {}


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
		args.append(repr(directParam))
	for key, val in params.items():
		args.append('%s=%r' % (argNames[key], val))
	if resultType:
		args.append('resulttype=%r' % resultType)
	if modeFlags & kae.kAEWaitReply != kae.kAEWaitReply:
		args.append('waitreply=False')
	if timeout != -1:
		args.append('timeout=%i' % (timeout / 60))
	return '%r.%s(%s)' % (targetRef, commandName, ', '.join(args))