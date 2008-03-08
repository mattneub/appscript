"""appscriptsupport -- Provides support for appscript's built-in help system.

(C) 2004 HAS
"""

from pprint import pprint, pformat
from sys import stdout
from StringIO import StringIO
from subprocess import Popen
import textwrap

import aem, appscript
from aemreceive import *

from osaterminology.dom import aeteparser
from osaterminology.renderers import textdoc, inheritance, relationships

from appscript import reference, terminology, terminologyparser

__all__ = ['Help']

from AppKit import NSUserDefaults

if not NSUserDefaults.standardUserDefaults().stringForKey_(u'rubyInterpreter'):
	NSUserDefaults.standardUserDefaults().setObject_forKey_(u'/usr/bin/ruby', u'rubyInterpreter')

if not NSUserDefaults.standardUserDefaults().integerForKey_(u'lineWrap'):
	NSUserDefaults.standardUserDefaults().setInteger_forKey_(78, u'lineWrap')

#######
# Data renderers

class DefaultRenderer:
	
	def rendervalue(self, value, prettyprint=False):
		return prettyprint and pformat(value) or repr(value)
	
	renderreference = rendervalue
		
	def rendervalues(self, values, prettyprint=False):
		return [prettyprint and pformat(value) or repr(value) for value in values]

_defaultrenderer = DefaultRenderer()

#######


class RubyRenderer:

	#######
	# manage ruby subprocess

	_rubyapp = None
	
	@staticmethod
	def _findrubyinterpreter():
		return NSUserDefaults.standardUserDefaults().stringForKey_(u'rubyInterpreter')
	
	@staticmethod
	def _findrubyrenderer():
		from AppKit import NSBundle
		return NSBundle.mainBundle().pathForResource_ofType_('rubyrenderer', 'rb')
	
	@classmethod
	def _target(klass):
		if not klass._rubyapp:
			klass._rubyproc = Popen([klass._findrubyinterpreter(), klass._findrubyrenderer()])
			klass._rubyapp = aem.Application(pid= klass._rubyproc.pid)
		return klass._rubyapp
	
	@classmethod
	def quit(self):
		try:
			self._target().event('aevtquit').send()
		except:
			pass	
	
	#######
	
	def __init__(self, appobj):
		self._appobj = appobj
		self._appdata = appobj.AS_appdata
	
	def rendervalue(self, value , prettyprint=False):
		return self.rendervalues([value], prettyprint)[0]
	
	def renderreference(self, value , prettyprint=False):
		return self.rendervalues([value], prettyprint, True)[0]
	
	def rendervalues(self, values, prettyprint=False, isreference=False):
		try:
			return self._target().event('AppSFmt_', {
					'Cons': self._appdata.constructor,
					'Iden': self._appdata.identifier,
					'PPri': prettyprint,
					'Data': values,
					'IsRe': isreference,
					}, codecs=self._appdata).send()
		except aem.CommandError, e:
			# TO DO: if error -600 (e.g. due to crash)
			import sys, traceback
			print >> sys.stderr, '*' * 78
			print >> sys.stderr, "ASDictionary warning: Couldn't translate values to Ruby:" \
					"\n\tAPP: %r\n\tDATA: %r" % (self._appobj, values)
			traceback.print_exc(file=sys.stderr)
			print >> sys.stderr, '*' * 78
			return [repr(value) for value in values]


#######

def quit():
	RubyRenderer.quit()


######################################################################
# PRIVATE
######################################################################


############################

class HelpError(Exception):
	pass


############################

class CommandDecorator:
	"""Command decorator; allows help system to display results of individual commands, e.g.
	
		app('Finder').home.get.help('-s')()
	"""

	def __init__(self, ref, helpObj):
		self._ref = ref
		self._helpObj = helpObj
	
	def __repr__(self):
		return repr(self._ref)
	
	def __call__(self, *args, **kargs):
		print >> self._helpObj.output, '=' * 78, '\nHelp\n\nCommand:'
		print >> self._helpObj.output, self._ref.AS_formatCommand((args, kargs))
		try:
			res = self._ref(*args, **kargs)
		except Exception, e:
			from traceback import print_exc
			print >> self._helpObj.output, '\nError:\n'
			print_exc(file=self._helpObj.output)
			print >> self._helpObj.output, '\n' + '=' * 78
			raise
		else:
			print >> self._helpObj.output, '\nResult:'
			pprint(res, self._helpObj.output)
			print >> self._helpObj.output, '\n' + '=' * 78
			return res
	
	def help(self, *args):
		return self.help(*args)


############################

class ReferenceResolver:
	"""Gets dictionary objects describing the last specifier in a given reference (i.e. definitions for the property/element itself and its containing class).
	"""
	
	def __init__(self, terms):
		self._terms = terms # an osadictionary.Dictionary instance
		try:
			applicationTerms = terms.classes().byname('application')
		except:
			raise HelpError, "Can't resolve this reference. " \
					"(Dictionary doesn't define an 'application' class.)"
		self.containingClass = applicationTerms.full()
		self.propertyOrElement = None
	
	def _updateContainingClass(self):
		if self.propertyOrElement:
			classes = self.propertyOrElement.type.realvalues('class')
			if classes:
				self.containingClass = classes[-1].full()
			else:
				raise HelpError, "Can't resolve this reference. " \
						"(Can't get properties/elements of %r because it's not a known application class.)" % \
						self.propertyOrElement.type # TO DO: probably don't want to display diagnostic to user as it's not very helpful to them
	
	def property(self, code):
		self._updateContainingClass()
		try:
			self.propertyOrElement = self.containingClass.properties().bycode(code)
		except KeyError:
			raise HelpError, "Can't resolve this reference. " \
					"(%r property isn't listed under the %s class.)" % (code, self.containingClass.name) # TO DO: ditto
		return self
		
	def elements(self, code):
		self._updateContainingClass()
		try:
			self.propertyOrElement = self.containingClass.elements().bycode(code)
		except KeyError:
			# where a property and element have same name and code, the property will be packed as an all-elements specifier, so if we can't find an element with the desired code in the given class, see if it has a property with that code instead:
			try:
				self.propertyOrElement = self.containingClass.properties().bycode(code)
			except KeyError:
				raise HelpError, "Can't resolve this reference. " \
					"(%r element isn't listed under the %s class.)" % (code, self.containingClass.name) # TO DO: ditto
		return self
		
	def __getattr__(self, *args): # ignore reference forms (first, last, byname, byindex, previous, etc.)
		return self
	
	def __call__(self, *args): # ignore calls to byname, byindex, previous, etc.
		return self


#######

class ReferenceStub:
	AS_aemreference = aem.app
	
	def __nonzero__(self):
		return False


######################################################################
# PUBLIC
######################################################################

class Help:
	"""Provides built-in help for an application."""
	
	_helpManual = """Help Manual

Print requested information on application and/or current reference. 

Syntax:

    reference.help(flags)

The optional flags argument is a string containing one or more of the following:

    -h -- show this help
    -o -- overview of all suites, classes and commands
    -k -- list all built-in keywords (type names)
    -u [suite-name] -- summary of named suite or all suites
    -t [class-or-command-name] -- terminology for named class/command or current reference/command
    -i [class-name] -- inheritance tree for named class or all classes
    -r [class-name] -- one-to-one and one-to-many relationships for named class or current reference
    -s [property-or-element-name] -- values of properties and elements of object(s) currently referenced

    Values shown in brackets are optional.

Notes: 
    - If no flags argument is given, '-t' is used.

    - When the -i option is used on a specific class that has multiple inheritance, this will be represented by multiple graphs. When the -i option is used for all classes, classes with multiple inheritance will appear at multiple points in the graph. In both cases, the class's subclasses will appear once in full, then abbreviated for space thereafter.

    - The -s option may take time to process if there are many properties and/or elements to get.

    - When the -t option is used, one-to-one relationships are shown as '-NAME', one-to-many as '=NAME'; a property's class is shown in angle brackets; a trailing arrow, '->', indicates a class's relationships are already given elsewhere.

For example, to print an overview of TextEdit, a description of its make command and the inheritance tree for its document class:

    app('TextEdit.app').help('-o -t make -i document')"""
	
	# TO DO: osax support
	
	def __init__(self, appobj, style='py-appscript', out=StringIO()):
		"""
			aetes : list of AEDesc -- list of aetes
			out : anything -- any file-like object that implements a write(str) method
		"""
		aetes = terminology.aetesforapp(appobj.AS_appdata.target)
		appname = appobj.AS_appdata.identifier or u'Current Application'
		self.terms = aeteparser.parseaetes(aetes, appname, style)
		self.style = style
		if style == 'rb-appscript':
			self.datarenderer = RubyRenderer(appobj)
		else:
			self.datarenderer = _defaultrenderer
		self.output = out
	
	def overview(self):
		print >> self.output, 'Overview:\n'
		textdoc.IndexRenderer(style=self.style, options=['sort', 'collapse'], out=self.output).draw(self.terms)
	
	def suite(self, suiteName=''):
		if suiteName:
			if not self.terms.suites().exists(suiteName):
				raise HelpError('No information available for suite %r.' % suiteName)
			s = 'Summary of %s'
			if not suiteName.lower().endswith('suite'):
				s += ' suite'
			terms = self.terms.suites().byname(suiteName)
			print >> self.output, (s + ':\n') % terms.name
		else:
			print >> self.output, 'Summary of all suites:\n'
			terms = self.terms
		textdoc.SummaryRenderer(style=self.style, out=self.output).draw(terms)
	
	def keywords(self):
		print >> self.output, 'Built-in keywords (type names):\n'
		if self.style == 'applescript':
			from osaterminology.dom import applescripttypes
			typenames = applescripttypes.typebyname.keys()
		else:
			from osaterminology import appscripttypedefs
			formatter = {'appscript': 'k.%s', 'py-appscript': 'k.%s', 'rb-appscript': ':%s'}[self.style]
			typenames = [formatter % name for name, code in appscripttypedefs.types]
		typenames.sort(lambda a,b:cmp(a.lower(), b.lower()))
		for name in typenames:
			print >> self.output, '    %s' % name
		
		
	def command(self, name):
		command = self.terms.commands().byname(name)
		s = StringIO()
		print >> s, 'Terminology for %s command\n\nCommand:' % command.name,
		textdoc.FullRenderer(style=self.style, options=['full'], out=s).draw(command)
		print >> self.output, s.getvalue()
	
	
	def klass(self, name):
		klass = self.terms.classes().byname(name).full()
		s = StringIO()
		print >> s, 'Terminology for %s class\n\nClass:' % klass.name,
		textdoc.FullRenderer(style=self.style, options=['full'], out=s).draw(klass)
		print >> self.output, s.getvalue()
	
	
	def property(self, p):
		s = StringIO()
		print >> s, 'Property:',
		textdoc.FullRenderer(style=self.style, options=['full'], out=s).draw(p)
		print >> self.output, s.getvalue()
	
	def element(self, e):
		s = StringIO()
		print >> s, 'Element:',
		textdoc.FullRenderer(style=self.style, options=['full'], out=s).draw(e)
		print >> self.output, s.getvalue()
	
	
	def inheritance(self, className=''):
		if className:
			if not self.terms.classes().exists(className):
				raise HelpError('No information available for class %r.' % className)
			print >> self.output, 'Inheritance for %s class\n' % className
		else:
			print >> self.output, 'Inheritance for all classes:\n'
		inheritance.InheritanceGrapher(self.terms, inheritance.TextRenderer(self.output)).draw(className)
		print >> self.output


	def relationships(self, ref, className=''):
		if className:
			if not self.terms.classes().exists(className):
				raise HelpError('No information available for class %r.' % className)
			print >> self.output, 'Relationships for %s class\n' % className
		else:
			definition = self._resolveRef(ref).propertyOrElement
			if definition:
				print >> self.output, 'Relationships for %s\n' % definition.name
				if definition:
					value = definition.type.realvalue()
					if value.kind == 'class': # if target's value is application object, not data, print class description
						className = value.name
			else:
				print >> self.output, 'Relationships for application class\n'
				className = 'application'
		relationships.RelationshipGrapher(self.terms, relationships.TextRenderer(self.output)).draw(className, 2)
		print >> self.output

	
	#######
	
	def _resolveRef(self, ref):
		resolver = ReferenceResolver(self.terms)
		ref.AS_aemreference.AEM_resolve(resolver)
		return resolver
	
	
	def _terminologyForClassOrCommand(self, ref, name=None):
		if name:
			if self.terms.commands().exists(name):
				self.command(name)
			elif self.terms.classes().exists(name):
				self.klass(name)
			else:
				raise HelpError('No information available for class/command %r.' % name)
		else:
			print >> self.output, 'Description of reference\n'
			if isinstance(ref, reference.Command):
				self.command(ref.AS_name)
			else:
				definition = self._resolveRef(ref).propertyOrElement
				if definition:
					if definition.kind == 'property': # print description of target property/element
						self.property(definition)
					else:
						self.element(definition)
					print >> self.output
					value = definition.type.realvalue()
					if value.kind == 'class': # if target's value is application object, not data, print class description
						self.klass(value.name)
				else: # must be top-level application object
					self.klass('application')
	
	
	##
	
	def _printRefValue(self, ref):
			try:
				print >> self.output, self.datarenderer.rendervalue(ref.get(), True)
			except Exception, e:
				print >> self.output, 'UNAVAILABLE'
	
	
	def _stateForRef(self, ref, attr=None):
		if isinstance(ref, reference.Command):
			print >> self.output, "Command's state will be displayed when called."
			return CommandDecorator
		else: # it's a reference
			if attr: # print current state of selected property/element only
				print >> self.output, 'Current state of selected property/element of referenced object(s)\n\n%s:' % attr
				self._printRefValue(getattr(ref, attr))
			else: # print current state of all properties and elements
				resolver = self._resolveRef(ref)
				definition = resolver.propertyOrElement
				if definition is None: # help() was called on application object
					value = resolver.containingClass
				else:
					value = definition.type.realvalue()
				if value.kind == 'class':
					print >> self.output, 'Current state of referenced object(s)'
					if definition:
						print >> self.output, '\n--- Get reference ---\n\n', ref.get()
					for heading, attributeNames in [
							('---- Properties ----', value.full().properties().names()),
							('----- Elements -----', value.full().elements().names())]:
						print >> self.output, '\n%s' % heading
						for name in attributeNames:
							print >> self.output, '\n%s:' % name
							if name == 'entire_contents':
								print >> self.output, 'UNAVAILABLE'
							else:
								try:
									print >> self.output, self.datarenderer.rendervalue(getattr(ref, name).get(), True)
								except Exception, e:
									print >> self.output, 'UNAVAILABLE'
				else:
					print >> self.output, 'Current state of referenced property (or properties)\n\n%s:' % \
							definition.name
					self._printRefValue(ref)
	
	
	#######
	
	def _manual(self):
		print >> self.output, self._helpManual

	##
	
	_handlers = {
			# (requires reference?, takes no/optional/required argument?, function)
			'h':(False, False, _manual),
			'o':(False, False, overview),
			'r':(True, True, relationships),
			'i':(False, True, inheritance),
			's':(True, True, _stateForRef),
			't':(True, True, _terminologyForClassOrCommand),
			'k':(False, False, keywords),
			'u':(False, True, suite),
			}



	def help(self, flags, ref=ReferenceStub()): # main call
		result = ref
		if not isinstance(flags, basestring): # assume flags arg contains file/StringIO/etc. object to write help to
			self.output = flags
		else:
			tokens = flags.split()
			print >> self.output, '=' * 78 + '\nHelp (%s)' % ' '.join(tokens)
			if ref:
				print >> self.output, '\nReference: %s' % self.datarenderer.renderreference(ref)
			i = 0
			while i < len(tokens):
				print >> self.output, '\n' + '-' * 78
				token = tokens[i]
				try:
					requiresRef, optArg, fn = self._handlers[token[1:]]
				except KeyError:
					print >> self.output, 'Unknown option: %r\n' % token
				else:
					args = []
					if requiresRef:
						args.append(ref)
					if optArg:
						word = []
						while i + 1 < len(tokens) and not tokens[i + 1].startswith('-'):
							i += 1
							word.append(tokens[i])
						if word:
							args.append(' '.join(word))
					try:
						wrapper = fn(self, *args)
					except HelpError, e:
						print >> self.output, e
					except Exception, e:
						from traceback import print_exc
						print_exc()
						print >> self.output, '%s: %s' % (e.__class__.__name__, e)
					else:
						if wrapper:
							result = wrapper(ref, self) # add wrapper
				i += 1
			print >> self.output, '\n' + '=' * 78
		return result


#######
# Install event handler

_cache = {}

def help(constructor, identity, style, flags, aemreference, commandname=''):
	id = (constructor, identity, style)
	if id not in _cache:
		if constructor == 'path':
			appobj = appscript.app(identity)
		elif constructor == 'pid':
			appobj = appscript.app(pid=identity)
		elif constructor == 'url':
			appobj = appscript.app(url=identity)
		elif constructor == 'aemapp':
			appobj = appscript.app(aemapp=aem.Application(desc=identity))
		elif constructor == 'current':
			appobj = appscript.app()
		else:
			raise RuntimeError, 'Unknown constructor: %r' % constructor
		output = StringIO()		
		helpobj = Help(appobj, style, output)
		_cache[id] = (appobj, helpobj, output)
	ref, helpobj, output = _cache[id]
	output.truncate(0)
	if aemreference is not None:
		ref = ref.AS_newreference(aemreference)
	if commandname:
		ref = getattr(ref, commandname)
	helpobj.help(flags, ref)
	s = output.getvalue()
	print `s`
	if NSUserDefaults.standardUserDefaults().boolForKey_(u'enableLineWrap'):
		res = []
		textwrapper = textwrap.TextWrapper(width=NSUserDefaults.standardUserDefaults().integerForKey_(u'lineWrap'), 
				subsequent_indent=' ' * 12)
		for line in s.split('\n'):
			res.append(textwrapper.fill(line))
		s = u'\n'.join(res)
	print `s`
	return s


installeventhandler(help,
		'AppSHelp',
		('Cons', 'constructor', kAE.typeChar),
		('Iden', 'identity', kAE.typeWildCard),
		('Styl', 'style', kAE.typeChar),
		('Flag', 'flags', kAE.typeChar),
		('aRef', 'aemreference', kAE.typeWildCard),
		('CNam', 'commandname', kAE.typeChar)
		)
