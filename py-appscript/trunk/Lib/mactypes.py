"""mactypes -- Defines user-friendly wrapper classes for Mac OS datatypes that don't have a suitable Python equivalent.

(C) 2006 HAS

- File encompasses FSRefs/FSSpecs/FileURLs to save user from having to deal with them directly. Files refer to specific locations on the filesystem which may or may not already exist. (Note that FSRefs and FSSpecs are only obtainable from a File object when it specifies an existing filesystem path; FSRefs by design, FSSpecs due to flaws in the Carbon.File extension's implementation.)

- Alias wraps Carbon.File.Alias objects. Aliases keep track of filesystem objects as they're moved around the disk or renamed.

Both classes provide a variety of constructors and read-only properties for getting raw objects in and out. Objects are comparable and nominally hashable.

"""

from urlparse import urlparse, urlunparse
from urllib import quote, unquote
from CarbonX.AE import AECreateDesc
from CarbonX import kAE
import Carbon.File
import MacOS

__all__ = ['Alias', 'File', 'Units']

######################################################################
# PRIVATE
######################################################################
# Constants

_typeFileURL = 'furl'

_diffVolErr = -1303
_errFSRefsDifferent = -1420

class _NoPath: pass

def _ro(*args):
	raise AttributeError, 'Property is read-only.'


class _Base:
	def __eq__(self, val): # TO DO: should also support comparisons of non-existent files
		if self.__class__ != val.__class__:
			return False
		try:
			self.fsref.FSCompareFSRefs(val.fsref)
		except MacOS.Error, err: # Dumb wrapper implementation raises 'not found' errors for non-matches instead of just returning True/False, so trap and handle these errors appropriately.
			if err[0] in [_diffVolErr, _errFSRefsDifferent]:
				return False
			else:
				raise
		else:
			return True
	
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
		if path is not _NoPath:
			self._alias = Carbon.File.FSNewAlias(None, Carbon.File.FSRef(unicode(path)))
		self._desc = None
	
	def makewithfsref(klass, fsref):
		"""Make Alias object from Carbon.File.FSRef."""
		return klass.makewithfsalias(Carbon.File.FSNewAlias(None, fsref))
	makewithfsref = classmethod(makewithfsref)
	
	def makewithfsalias(klass, alias):
		"""Make Alias object from Carbon.File.Alias."""
		obj = klass(_NoPath)
		obj._alias = alias
		return obj
	makewithfsalias = classmethod(makewithfsalias)
	
	def makewithaedesc(klass, desc):
		"""Make Alias object from CarbonX.AE.AEDesc of typeAlias (typeFSS, typeFSRef, typeFileURL should also be acceptable).
			Note: behaviour for other descriptor types is undefined and will probably fail.
		"""
		obj = klass(_NoPath)
		obj._alias = Carbon.File.Alias(rawdata=desc.AECoerceDesc(kAE.typeAlias).data)
		return obj
	makewithaedesc = classmethod(makewithaedesc)
	
	# Instance methods
	
	def __repr__(self):
		return 'mactypes.Alias(%r)' % unicode(self.fsref.as_pathname(), 'utf8')
	
	# Properties
	
	path = property(lambda self: unicode(self._alias.FSResolveAlias(None)[0].as_pathname(), 'utf8'), _ro, doc="Get as POSIX path.")
	
	file = property(lambda self: File.makewithfsref(self.fsref), _ro, doc="Get as mactypes.File.")
	
	alias = property(lambda self: self, _ro, doc="Get as mactypes.Alias (i.e. itself).")
	
	fsref = property(lambda self: self._alias.FSResolveAlias(None)[0], _ro, doc="Get as Carbon.File.FSRef.")
	
	fsspec = property(lambda self: self._alias.ResolveAlias(None)[0], _ro, doc="Get as legacy Carbon.File.FSSpec.")
	
	fsalias = property(lambda self: self._alias, _ro, doc="Get as Carbon.File.Alias.")
	
	def aedesc(self):
		if not self._desc:
			self._desc = AECreateDesc(kAE.typeAlias, self._alias.data)
		return self._desc
	aedesc = property(aedesc, _ro, doc="Get as CarbonX.AE.AEDesc.")



class File(_Base):
	"""A reference to a filesystem location."""
	
	# Constructors
	
	def __init__(self, path):
		"""Make File object from POSIX path."""
		self._path = unicode(path)
		#self._hfs = None
		self._url = None
		self._fsref = None
		self._fsspec = None
		self._desc = None
	
	def makewithurl(klass, url):
		"""Make File object from file URL."""
		scheme, netloc, path = urlparse(url)[:3]
		if scheme != 'file':
			raise ValueError, 'Not a file URL.'
		obj = klass(unicode(unquote(path), 'utf8'))
		obj._url = url
		return obj
	makewithurl = classmethod(makewithurl)
	
	def makewithfsref(klass, fsref):
		"""Make File object from Carbon.File.FSRef."""
		obj = klass(unicode(fsref.as_pathname(), 'utf8'))
		obj._fsref = fsref
		return obj
	makewithfsref = classmethod(makewithfsref)
	
	def makewithfsspec(klass, fsspec):
		"""Make File object from legacy Carbon.File.FSSpec."""
		obj = klass(unicode(fsspec.as_pathname(), 'utf8'))
		obj._fsspec = fsspec
		return obj
	makewithfsspec = classmethod(makewithfsspec)
	
	def makewithaedesc(klass, desc):
		"""Make File object from CarbonX.AE.AEDesc of typeFSS, typeFSRef, typeFileURL.
			Note: behaviour for other descriptor types is undefined: typeAlias will cause problems, others will probably fail.
		"""
		if desc.type == _typeFileURL:
			url = desc.data
		else:
			url = desc.AECoerceDesc(_typeFileURL).data
		obj = klass(unicode(unquote(urlparse(url)[2]), 'utf8'))
		obj._url = url
		obj._desc = desc
		return obj
	makewithaedesc = classmethod(makewithaedesc)
	
	# Instance methods
	
	def __repr__(self):
		return 'mactypes.File(%r)' % self._path
	
	# Properties
	
	path = property(lambda self:self._path, _ro, doc="Get as POSIX path.")
	
	def url(self):
		if self._url is None:
			self._url = urlunparse(('file', 'localhost', quote(self._path.encode('utf8')), '', '', ''))
		return self._url
	url = property(url, _ro, doc="Get as file URL.")
	
	file = property(lambda self: self, _ro, doc="Get as mactypes.File (i.e. itself).")
	
	alias = property(lambda self: Alias.makewithfsref(self.fsref), _ro, doc="Get as mactypes.Alias.")
	
	def fsref(self):
		if self._fsref:
			return self._fsref
		else:
			if self._desc:
				self._fsref = Carbon.File.FSRef(rawdata=self._desc.AECoerceDesc(kAE.typeFSRef).data)
				return self._fsref
			else:
				return Carbon.File.FSRef(self._path)
	fsref = property(fsref, _ro, doc="Get as Carbon.File.FSRef.")
	
	def fsspec(self):
		if self._fsspec:
			return self._fsspec
		else:
			if self._desc:
				self._fsspec = Carbon.File.FSSpec(rawdata=self._desc.AECoerceDesc(kAE.typeFSS).data)
				return self._fsspec
			else:
				return Carbon.File.FSSpec(self._path)
	fsspec = property(fsspec, _ro, doc="Get as legacy Carbon.File.FSSpec.")
	
	fsalias = property(lambda self: Carbon.File.FSNewAlias(None, self.fsref), _ro, doc="Get as Carbon.File.Alias.")
	
	def aedesc(self):
		if self._desc is None:
			if self._fsref:
				self._desc = AECreateDesc(k.typeFSRef, self._fsref.data)
			elif self._fsspec:
				self._desc = AECreateDesc(k.typeFSS, self._fsspec.data)
			else:
				self._desc = AECreateDesc(_typeFileURL, self.url)
		return self._desc
	aedesc = property(aedesc, _ro, doc="Get as CarbonX.AE.AEDesc.")



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
	
	value = property(lambda self: self._value, _ro, doc="Get unit value, e.g. 3.")
	type = property(lambda self: self._type, _ro, doc="Get unit type, e.g. 'inches'")
	
	def __eq__(self, val):
		return self.__class__ == val.__class__ and self._value == val.value and self._type == val.type
	
	def __ne__(self, val):
		return not self == val
	
	def __hash__(self):
		return hash((self.value, self.type))
	
	def __repr__(self):
		return 'mactypes.Units(%r, %r)' % (self.value, self.type)
	
	def __str__(self):
		return '%r %s' % (self.value, self.type)
	
	def __int__(self):
		return int(self.value)
	
	def __float__(self):
		return float(self.value)

