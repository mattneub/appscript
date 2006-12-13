#!/usr/local/bin/python

"""osax.py -- Allows scripting additions (a.k.a. OSAXen) to be called from Python.

(C) 2006 HAS
"""

from appscript import *
from appscript import reference, terminology
import aem
from osaterminology.getterminology import getaete

__all__ = ['ApplicationNotFoundError', 'OSAX','CommandError', 'k', 'scriptingadditions']


######################################################################
# PUBLIC
######################################################################

scriptingadditions = [] # names of all currently available osaxen


######################################################################
# PRIVATE
######################################################################

_osaxcache = {} # a dict of form: {'osax name': ['/path/to/osax', cached_terms_or_None], ...}

_se = app('System Events')
for domain in [_se.system_domain, _se.local_domain, _se.user_domain]:
	osaxen = domain.scripting_additions_folder.files[
			(its.file_type == 'osax').OR(its.name_extension == 'osax')]
	for name, path in zip(osaxen.name(), osaxen.POSIX_path()):
		if name.lower().endswith('.osax'):
			name = name[:-5]
		if not _osaxcache.has_key(name.lower()):
			scriptingadditions.append(name)
			_osaxcache[name.lower()] = [path, None]
scriptingadditions.sort()


######################################################################
# PUBLIC
######################################################################

# TO DO: subclass AppData to support help() for osax?

class OSAX(reference.Application):

	def __init__(self, osaxname, name=None, id=None, creator=None, url=None, terms=None): # TO DO: pid
		self._osaxname = osaxname
		osaxname = osaxname.lower()
		if osaxname.endswith('.osax'):
			osaxname = osaxname[:-5]
		if not terms:
			try:
				osaxpath, terms = _osaxcache[osaxname]
			except KeyError:
				raise KeyError, "Scripting addition not found: %r" % self._osaxname
			if not terms:
				terms = _osaxcache[osaxname][1] = terminology.tablesforaetes(getaete(osaxpath))
		reference.Application.__init__(self, name, id, creator, url, terms)
		try:
			self.AS_appdata.target.event('ascrgdut').send(300) # make sure target application has loaded event handlers for all installed OSAXen
		except aem.CommandError, e:
			if e.number != -1708: # ignore 'event not handled' error
				raise
		
	def __str__(self):
		if self.AS_appdata.path:
			return "ScriptingAddition(%r, name=%r)" % (self._osaxname, self.AS_appdata.path)
		elif self.AS_appdata.url:
			return "ScriptingAddition(%r, url=%r)" % (self._osaxname, self.AS_appdata.url)
		else:
			return "ScriptingAddition(%r)" % self._osaxname
		
	__repr__ = __str__


#  OSAX('StandardAdditions').say('hello world')

