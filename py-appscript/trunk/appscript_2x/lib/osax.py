"""osax.py -- Allows scripting additions (a.k.a. OSAXen) to be called from Python.

(C) 2006-2009 HAS
"""

from appscript import *
from appscript import reference, terminology
import aem

__all__ = ['OSAX', 'scriptingadditions',
		'ScriptingAddition', # deprecated; use OSAX instead
		'ApplicationNotFoundError', 'CommandError', 'k', 'mactypes']


######################################################################
# PRIVATE
######################################################################

_osaxcache = {} # a dict of form: {'osax name': ['/path/to/osax', cached_terms_or_None], ...}

_osaxnames = [] # names of all currently available osaxen

def _initcaches():
		_se = aem.Application(aem.findapp.byid('com.apple.systemevents'))
		for domaincode in ['flds', 'fldl', 'fldu']:
			osaxen = aem.app.property(domaincode).property('$scr').elements('file').byfilter(
					aem.its.property('asty').eq('osax').OR(aem.its.property('extn').eq('osax')))
			if _se.event('coredoex', {'----': osaxen.property('pnam')}).send(): # domain has ScriptingAdditions folder
				names = _se.event('coregetd', {'----': osaxen.property('pnam')}).send()
				paths = _se.event('coregetd', {'----': osaxen.property('posx')}).send()
				for name, path in zip(names, paths):
					if name.lower().endswith('.osax'): # remove name extension, if any
						name = name[:-5]
					if name.lower() not in _osaxcache:
						_osaxnames.append(name)
						_osaxcache[name.lower()] = [path, None]
		_osaxnames.sort()


######################################################################
# PUBLIC
######################################################################

def scriptingadditions():
	if not _osaxnames:
		_initcaches()
	return _osaxnames[:]


class OSAX(reference.Application):

	def __init__(self, osaxname='StandardAdditions', name=None, id=None, creator=None, pid=None, url=None, aemapp=None, terms=True):
		if not _osaxcache:
			_initcaches()
		self._osaxname = osaxname
		osaxname = osaxname.lower()
		if osaxname.endswith('.osax'):
			osaxname = osaxname[:-5]
		if terms == True:
			try:
				osaxpath, terms = _osaxcache[osaxname]
			except KeyError:
				raise KeyError("Scripting addition not found: %r" % self._osaxname)
			if not terms:
				terms = _osaxcache[osaxname][1] = terminology.tablesforaetes(aem.ae.getappterminology(osaxpath))
		reference.Application.__init__(self, name, id, creator, pid, url, aemapp, terms)
		try:
			self.AS_appdata.target().event('ascrgdut').send(300) # make sure target application has loaded event handlers for all installed OSAXen
		except aem.EventError, e:
			if e.errornumber != -1708: # ignore 'event not handled' error
				raise
		def _help(*args):
			raise NotImplementedError("Built-in help isn't available for scripting additions.")
		self.AS_appdata.help = _help
		
	def __str__(self):
		if self.AS_appdata.constructor == 'current':
			return 'OSAX(%r)' % self._osaxname
		elif self.AS_appdata.constructor == 'path':
			return 'OSAX(%r, %r)' % (self._osaxname, self.AS_appdata.identifier)
		else:
			return 'OSAX(%r, %s=%r)' % (self._osaxname, self.AS_appdata.constructor, self.AS_appdata.identifier)
		
	__repr__ = __str__


ScriptingAddition = OSAX # backwards compatibility; deprecated # TO DO: delete

