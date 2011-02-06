"""osax.py -- Allows scripting additions (a.k.a. OSAXen) to be called from Python. """

from xml.etree import ElementTree
import string
from StringIO import StringIO

from appscript import *
from appscript import reference, terminology
from appscript.reservedkeywords import kReservedKeywords
import aem

__all__ = ['OSAX', 'scriptingadditions',
		'ScriptingAddition', # deprecated; use OSAX instead
		'ApplicationNotFoundError', 'CommandError', 'k', 'mactypes']


######################################################################
# PRIVATE
######################################################################


class TreeBuilderIgnoreDoctype(ElementTree.TreeBuilder):
	""" Suppress XMLParser.doctype() deprecation warnings in ElementTree 1.3 """
	
	def doctype(self, name, pubid, system):
		pass


class SdefParser:
	""" Parse scripting addition sdef.
		
		Note:
		
		- OSAX terminology can only be retrieved via OSAGetAppTerminology or OSACopyScriptingDefinition;
			while the former is more reliable, it is deprecated in 32-bit and absent in 64-bit Carbon APIs.
		
		- Four char codes that contain non-printing codes in aetes (e.g. the 'caution' enum in StandardAdditions has code '\x00\x00\x00\x02') do not convert to valid code attributes in sdefs.
		
		- xi:include or class-extension elements are not supported, but osaxen are unlikely to use these anyway.
		
		- Synonyms are not supported. (While possible, it would require additional work to ensure that synonym names/codes don't accidentally mask the primary terms.)
	"""
	
	_keywordcache = {}
	_reservedwords = set(kReservedKeywords)
	_specialconversions = {
			' ': '_',
			'-': '_',
			'&': 'and',
			'/': '_',
	}
	_legalchars = string.ascii_letters + '_'
	_alphanum = _legalchars + string.digits
	
	commands = property(lambda self: list(self._commands.values()))

	def __init__(self):
		self.classes, self.enums, self.properties, self.elements, self._commands = [], [], [], [], {}
	
	def _name(self, s):
		if s not in self._keywordcache:
			legal = self._legalchars
			res = ''
			for c in s:
				if c in legal:
					res += c
				elif c in self._specialconversions:
					res += self._specialconversions[c]
				else:
					if res == '':
						res = '_' # avoid creating an invalid identifier
					res += '0x{:X}'.format(ord(c))
				legal = self._alphanum
			if res in self._reservedwords or res.startswith('_') or res.startswith('AS_'):
				res += '_'
			self._keywordcache[s] = str(res)
		return self._keywordcache[s]
	
	def _code(self, s):
		return s.encode('macroman')
	
	def _addnamecode(self, node, collection):
		name = self._name(node.get('name'))
		code = self._code(node.get('code'))
		if name and len(code) == 4 and (name, code) not in collection:
			collection.append((name, code))
	
	def _addcommand(self, node):
		name = self._name(node.get('name'))
		code = self._code(node.get('code'))
		parameters = []
		# Note: overlapping command definitions (e.g. 'path to') should be processed as follows:
		# - If their names and codes are the same, only the last definition is used; other definitions are ignored and will not compile.
		# - If their names are the same but their codes are different, only the first definition is used; other definitions are ignored and will not compile.
		if name and len(code) == 8 and (name not in self._commands or self._commands[name][1] == code):
			self._commands[name] =(name, code, parameters)
			for pnode in node.findall('parameter'):
				self._addnamecode(pnode, parameters)
	
	def parse(self, xml):
		""" Extract name-code mappings from an sdef.
		
			xml : bytes | str -- sdef data
		"""
		xml = ElementTree.parse(StringIO(xml), ElementTree.XMLParser(target=TreeBuilderIgnoreDoctype()))
		for suite in xml.findall('suite'):
			for node in suite:
				try:
					if node.tag in ['command', 'event']:
						self._addcommand(node)
					elif node.tag in ['class', 'record-type', 'value-type']:
						self._addnamecode(node, self.classes)
						for prop in node.findall('property'):
							self._addnamecode(prop, self.properties)
						if node.tag == 'class': # elements
							name = self._name(node.get('plural', 
									node.get('name', '') + 's'))
							code = self._code(node.get('code'))
							if name and name != 's' and len(code) == 4:
								self.elements.append((name, code))
					elif node.tag == 'enumeration':
						for enum in node.findall('enumerator'):
							self._addnamecode(enum, self.enums)
				except:
					pass # ignore problem definitions
	
	def parsefile(self, path):
		""" Extract name-code mappings from an sdef.
		
			path :  str -- path to .sdef file
		"""
		self.parse(aem.ae.copyscriptingdefinition(path))


##


kStandardAdditionsEnums = [ # codes from StandardAdditions aete
		('stop', '\x00\x00\x00\x00'),
		('note', '\x00\x00\x00\x01'),
		('caution', '\x00\x00\x00\x02')]


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
				raise ValueError("Scripting addition not found: %r" % self._osaxname)
			if not terms:
				p = SdefParser()
				p.parsefile(osaxpath)
				if osaxname == 'standardadditions':
					p.enums += kStandardAdditionsEnums # patch in missing codes for compatibility
				terms = _osaxcache[osaxname][1] = terminology.tablesformodule(p)
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
			
	def __getattr__(self, name):
		command = reference.Application.__getattr__(self, name)
		if isinstance(command, reference.Command):
			def osaxcommand(*args, **kargs):
				try:
					return command(*args, **kargs)
				except CommandError, e:
					if int(e) == -1713: # 'No user interaction allowed' error (e.g. user tried to send a 'display dialog' command to a non-GUI python process), so convert the target process to a full GUI process and try again
						aem.ae.transformprocesstoforegroundapplication()
						self.activate()
						return command(*args, **kargs)
			return osaxcommand
		else:
			return command
		
	__repr__ = __str__


ScriptingAddition = OSAX # deprecated but retained for backwards compatibility


##

def dump(osaxname, modulepath):
	"""Dump scripting addition terminology data to Python module.
		osaxname : str -- name of installed scripting addition
		modulepath : str -- path to generated module
		
	Generates a Python module containing a scripting addition's basic terminology 
	(names and codes) as used by osax.
	
	Call the dump() function to dump faulty sdefs to Python module, e.g.:
	
		dump('MyOSAX', '/path/to/site-packages/myosaxglue.py')
	
	Patch any errors by hand, then import the patched module into your script 
	and pass it to osax's OSAX() constructor via its 'terms' argument, e.g.:
	
		from osax import *
		import myosaxglue
		
		myapp = OSAX('MyOSAX', terms=myosaxglue)
	"""
	if not _osaxnames:
		_initcaches()
	originalname = osaxname
	osaxname = osaxname.lower()
	if osaxname.endswith('.osax'):
		osaxname = osaxname[:-5]
	try:
		osaxpath, terms = _osaxcache[osaxname]
	except KeyError, e:
		raise ValueError("Scripting addition not found: %r" % originalname)
	p = SdefParser()
	p.parsefile(osaxpath)
	terminology.dumptables((p.classes, p.enums, p.properties, p.elements, p.commands), osaxpath, modulepath)

