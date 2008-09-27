"""mactypes -- Defines user-friendly wrapper classes for Mac OS datatypes that don't have a suitable Python equivalent.

(C) 2008 HAS

- File objects encompass AEDescs of typeFSRef/typeFSSpec/typeFileURL to save user from having to deal with them directly. File objects refer to filesystem locations which may or may not already exist.

- Alias objects wrap AEDescs of typeAlias. Aliases refer to filesystem objects and can track them as they're moved around the disk or renamed.

Both classes provide a variety of constructors and read-only properties for getting raw objects in and out. Objects are comparable and nominally hashable.

- Units objects represent units of measurement. Default unit types are defined in aem; clients can add additional definitions to aem Codecs/appscript AppData objects as needed.

"""

from os.path import abspath

from ae import AECreateDesc, ConvertPathToURL, ConvertURLToPath, MacOSError
import kae

kCFURLPOSIXPathStyle = 0
kCFURLHFSPathStyle = 1
kCFURLWindowsPathStyle = 2

__all__ = ['Alias', 'File', 'Units']


######################################################################
# PRIVATE
######################################################################
# Constants

class _NoPath: pass

def _ro(*args):
	raise AttributeError('Property is read-only.')


class _Base:
	def __eq__(self, val):
		return self is val or (self.__class__ == val.__class__ and self.url == val.url)
	
	def __ne__(self, val):
		return not self == val
	
	def __hash__(self):
		return hash(self.__class__)


######################################################################
# PUBLIC
######################################################################

class Alias(_Base):
	"""A persistent reference to a filesystem object."""
	
	# Constructors
	
	def __init__(self, path):
		"""Make Alias object from POSIX path."""
		if path is _NoPath:
			self._desc = None
		else:
			urldesc = AECreateDesc(kae.typeFileURL, 
					ConvertPathToURL(abspath(path), kCFURLPOSIXPathStyle))
			try:
				self._desc = urldesc.AECoerceDesc(kae.typeAlias)
			except MacOSError, err:
				if err[0] == -1700:
					raise ValueError("Can't make mactypes.Alias as file doesn't exist: %r" % path)
				else:
					raise
		
	def makewithhfspath(klass, path):
		return klass.makewithurl(ConvertPathToURL(path, kCFURLHFSPathStyle))
	makewithhfspath = classmethod(makewithhfspath)
	
	def makewithurl(klass, url):
		"""Make File object from file URL."""
		obj = klass(_NoPath)
		obj._desc = AECreateDesc(kae.typeFileURL, url).AECoerceDesc(kae.typeAlias)
		return obj
	makewithurl = classmethod(makewithurl)
	
	def makewithdesc(klass, desc):
		"""Make Alias object from CarbonX.AE.AEDesc of typeAlias (typeFSS/typeFSRef/typeFileURL are also allowed).
		"""
		if desc.type != kae.typeAlias:
			desc = desc.AECoerceDesc(kae.typeAlias)
		obj = klass(_NoPath)
		obj._desc = desc
		return obj
	makewithdesc = classmethod(makewithdesc)
	
	# Instance methods
	
	def __repr__(self):
		return 'mactypes.Alias(%r)' % unicode(self.path)
	
	# Properties
	
	path = property(lambda self: ConvertURLToPath(self.url, kCFURLPOSIXPathStyle), _ro, doc="Get as POSIX path.")
	
	hfspath = property(lambda self: ConvertURLToPath(self.url, kCFURLHFSPathStyle), _ro, doc="Get as HFS path.")
	
	url = property(lambda self: self._desc.AECoerceDesc(kae.typeFileURL).data, _ro, doc="Get as file URL.")
	
	file = property(lambda self: File.makewithdesc(self._desc), _ro, doc="Get as mactypes.File.")
	
	alias = property(lambda self: self, _ro, doc="Get as mactypes.Alias (i.e. itself).")
	
	desc = property(lambda self: self._desc, _ro, doc="Get as CarbonX.AE.AEDesc.")



class File(_Base):
	"""A reference to a filesystem location."""
	
	# Constructors
	
	def __init__(self, path):
		"""Make File object from POSIX path."""
		if path is not _NoPath:
			if not isinstance(path, unicode):
				path = unicode(path)
			self._path = abspath(path)
			self._url = ConvertPathToURL(self._path, kCFURLPOSIXPathStyle)
			self._desc = AECreateDesc(kae.typeFileURL, self._url)
	
	def makewithhfspath(klass, path):
		return klass.makewithurl(ConvertPathToURL(path, kCFURLHFSPathStyle))
	makewithhfspath = classmethod(makewithhfspath)
	
	def makewithurl(klass, url):
		"""Make File object from file URL."""
		obj = klass(_NoPath)
		obj._desc = AECreateDesc(kae.typeFileURL, url)
		obj._url = url
		obj._path = ConvertURLToPath(url, kCFURLPOSIXPathStyle)
		return obj
	makewithurl = classmethod(makewithurl)
		
	def makewithdesc(klass, desc):
		"""Make File object from CarbonX.AE.AEDesc of typeFSS/typeFSRef/typeFileURL.
			Note: behaviour for other descriptor types is undefined: typeAlias will cause problems, others will probably fail.
		"""
		obj = klass(_NoPath)
		obj._path = None
		obj._url = None
		if desc.type in [kae.typeFSS, kae.typeFSRef, kae.typeFileURL]:
			obj._desc = desc
		else:
			obj._desc = desc.AECoerceDesc(kae.typeFileURL)
		return obj
	makewithdesc = classmethod(makewithdesc)
	
	# Instance methods
	
	def __repr__(self):
		return 'mactypes.File(%r)' % self.path
	
	# Properties
	
	def path(self):
		if self._path is None:
			self._path = ConvertURLToPath(self.url, kCFURLPOSIXPathStyle)
		return self._path
	path = property(path, _ro, doc="Get as POSIX path.")
	
	hfspath = property(lambda self: ConvertURLToPath(self.url, kCFURLHFSPathStyle), _ro, doc="Get as HFS path.")
	
	def url(self):
		if self._url is None:
			if self._desc.type == kae.typeFileURL:
				self._url = self._desc.data
			else:
				self._url = self._desc.AECoerceDesc(kae.typeFileURL).data
		return self._url
	url = property(url, _ro, doc="Get as file URL.")
	
	file = property(lambda self: File(self.path), _ro, doc="Get as mactypes.File.")
	
	alias = property(lambda self: Alias.makewithdesc(self.desc), _ro, doc="Get as mactypes.Alias.")
	
	def desc(self):
		if self._desc is None:
			self._desc = AECreateDesc(kae.typeFileURL, self.url)
		return self._desc
	desc = property(desc, _ro, doc="Get as CarbonX.AE.AEDesc.")



#######

class Units:
	"""Represents a measurement; e.g. 3 inches, 98.5 degrees Fahrenheit.
	
	The AEM defines a standard set of unit types; some applications may define additional types for their own use. This wrapper stores the raw unit type and value data; aem/appscript Codecs objects will convert this to/from an AEDesc, or raise an error if the unit type is unrecognised.
	"""
	
	def __init__(self, value, type):
		"""
			value : int | float -- the unit value, e.g. 3
			type : str -- the unit type name, e.g. 'inches'
		"""
		self._value = value
		self._type = type
	
	value = property(lambda self: self._value, _ro, doc="Get unit value, e.g. 3")
	type = property(lambda self: self._type, _ro, doc="Get unit type, e.g. 'inches'")
	
	def __eq__(self, val):
		return self is val or (self.__class__ == val.__class__ 
				and self._value == val.value and self._type == val.type)
	
	def __ne__(self, val):
		return not self == val
	
	def __hash__(self):
		return hash((self.value, self.type))
	
	def __repr__(self):
		return 'mactypes.Units(%r, %r)' % (self.value, self.type)
	
	def __str__(self):
		return '%r %s' % (self.value, self.type.replace('_', ' '))
	
	def __int__(self):
		return int(self.value)
	
	def __float__(self):
		return float(self.value)


