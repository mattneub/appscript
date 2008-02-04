"""findapp -- Support module for obtaining the full path to a local application given its name, bundle id or creator type. If application isn't found, an ApplicationNotFoundError exception is raised.

(C) 2004-2008 HAS
"""

from os.path import exists, expanduser

from ae import FindApplicationForInfo, MacOSError

__all__ = ['byname', 'byid', 'bycreator']

######################################################################
# PRIVATE
######################################################################

def _findApp(name=None, id=None, creator='????'):
	try:
		return FindApplicationForInfo(creator, id, name)
	except MacOSError, err:
		if err[0] == -10814:
			raise ApplicationNotFoundError, name or id or creator
		else:
			raise


######################################################################
# PUBLIC
######################################################################

class ApplicationNotFoundError(Exception):
	def __init__(self, name):
		self.name = name
		Exception.__init__(self, name)
	
	def __str__(self):
		return 'Local application %r not found.' % self.name


def byname(name):
	"""Find the application with the given name and return its full path. 
	
	Absolute paths are also accepted. An '.app' suffix is optional.
	
	Examples: 
		byname('TextEdit')
		byname('Finder.app')
	"""
	if not name.startswith('/'): # application name only, not its full path
		try:
			name = _findApp(name)
		except ApplicationNotFoundError:
			if name.lower().endswith('.app'):
				raise
			name = _findApp(name + '.app')
	if not exists(name) and not name.lower().endswith('.app') and exists(name + '.app'):
		name += '.app'
	if not exists(name):
		raise ApplicationNotFoundError, name
	return name

		
def byid(id):
	"""Find the application with the given bundle id and return its full path.
	
	Examples:
		byid('com.apple.textedit')
	"""
	return _findApp(id=id)


def bycreator(creator):
	"""Find the application with the given creator type and return its full path.
	
	Examples:
		bycreator('ttxt')
	"""
	if len(creator) != 4 or creator == '????':
		raise ApplicationNotFoundError, creator
	return _findApp(creator=creator)


######################################################################
# TEST
######################################################################

if __name__ == '__main__':
	
	print `byname('textedit.app')`
	print `byname('/Applications/TextEdit.app')`
	print `byname('textedit')`
	print `byid('com.apple.textedit')`
	print `bycreator('ttxt')`
	# print `byname('~/foo.app')`
	# print `byname(u'\u0192\u0192.app')`

