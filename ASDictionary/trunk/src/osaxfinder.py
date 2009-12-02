""" osaxfinder -- Provides information on installed scripting additions.

(C) 2007-2009 HAS
"""

import os
from appscript import *

_osaxinfo = {}

def init():
	sysev = app(id='com.apple.systemevents')
	for domain in [sysev.system_domain, sysev.local_domain, sysev.user_domain]:
		filesref = domain.scripting_additions_folder.files[its.visible == True]
		if filesref.name.exists():
			for path, filetype in zip(filesref.POSIX_path(), filesref.file_type()):
				name = os.path.basename(path)
				if name.lower().endswith('.osax'):
					info = (True, name[:-5], path)
				elif name.lower().endswith('.app'):
					info = (False, name[:-4], path)
				elif filetype == 'osax':
					info = (True, name, path)
				elif filetype == 'APPL':
					info = (False, name, path)
				else:
					continue
				_osaxinfo[info[1].lower()] = info

def names():
	return sorted(
			(name for isosax, name, path in _osaxinfo.values()), 
			lambda a,b:cmp(a.lower(), b.lower()))

def pathforname(name):
	return _osaxinfo[name.lower()][2]
		
