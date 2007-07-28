#!/usr/local/bin/python

"""osax.py -- Allows scripting additions (a.k.a. OSAXen) to be called from Python.

(C) 2006 HAS
"""

from appscript import *
from appscript import reference, terminology
import aem
from osaterminology.getterminology import getaete

__all__ = ['ApplicationNotFoundError', 'ScriptingAddition','CommandError', 'k', 'scriptingadditions']


######################################################################
# PUBLIC
######################################################################

scriptingadditions = [] # names of all currently available osaxen


######################################################################
# PRIVATE
######################################################################

_osaxcache = {} # a dict of form: {'osax name': ['/path/to/osax', cached_terms_or_None], ...}

#_se = app(id='com.apple.systemevents')
_se = aem.Application(aem.findapp.byid('com.apple.systemevents'))
#for domain in [_se.system_domain, _se.local_domain, _se.user_domain]:
for domain in ['flds', 'fldl', 'fldu']:
#	osaxen = domain.scripting_additions_folder.files[
#			(its.file_type == 'osax').OR(its.name_extension == 'osax')]
	osaxen = aem.app.property(domain).property('$scr').elements('file').byfilter(
			aem.its.property('asty').eq('osax').OR(aem.its.property('extn').eq('osax')))
#	for name, path in zip(osaxen.name(), osaxen.POSIX_path()):
	for name, path in zip(_se.event('coregetd', {'----': osaxen.property('pnam')}).send(), 
			_se.event('coregetd', {'----': osaxen.property('posx')}).send()):
		if name.lower().endswith('.osax'):
			name = name[:-5]
		if not _osaxcache.has_key(name.lower()):
			scriptingadditions.append(name)
			_osaxcache[name.lower()] = [path, None]
scriptingadditions.sort()


class _OSAXHelp:
	def __init__(self, osaxpath):
		self.osaxpath = osaxpath
		self.helpobj = None
	
	def __call__(self, flags, ref):
		if not self.helpobj:
			from appscript import helpsystem
			self.helpobj = helpsystem.Help(getaete(self.osaxpath), self.osaxpath)
		return self.helpobj.help(flags, ref)


######################################################################
# PUBLIC
######################################################################

class ScriptingAddition(reference.Application):

	def __init__(self, osaxname='StandardAdditions', name=None, id=None, creator=None, pid=None, url=None, aemapp=None, terms=True):
		self._osaxname = osaxname
		osaxname = osaxname.lower()
		if osaxname.endswith('.osax'):
			osaxname = osaxname[:-5]
		if terms == True:
			try:
				osaxpath, terms = _osaxcache[osaxname]
			except KeyError:
				raise KeyError, "Scripting addition not found: %r" % self._osaxname
			if not terms:
				terms = _osaxcache[osaxname][1] = terminology.tablesforaetes(getaete(osaxpath))
		reference.Application.__init__(self, name, id, creator, pid, url, aemapp, terms)
		try:
			self.AS_appdata.target.event('ascrgdut').send(300) # make sure target application has loaded event handlers for all installed OSAXen
		except aem.CommandError, e:
			if e.number != -1708: # ignore 'event not handled' error
				raise
		self.AS_appdata.help = _OSAXHelp(_osaxcache[osaxname][0])
		
	def __str__(self):
		if self.AS_appdata.constructor == 'current':
			return 'ScriptingAddition(%r)' % self._osaxname
		elif self.AS_appdata.constructor == 'path':
			return 'ScriptingAddition(%r, %r)' % (self._osaxname, self.AS_appdata.identifier)
		else:
			return 'ScriptingAddition(%r, %s=%r)' % (self._osaxname, self.AS_appdata.constructor, self.AS_appdata.identifier)
		
	__repr__ = __str__

