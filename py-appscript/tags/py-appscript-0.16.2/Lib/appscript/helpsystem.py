"""helpsystem -- Built-in help.

(C) 2004 HAS
"""

from pprint import pprint
from sys import stdout

from osaterminology.dom import aeteparser
from osaterminology.renderers import textdoc, inheritance, relationships

import reference, terminology

__all__ = ['Help']

######################################################################
# PRIVATE
######################################################################

class _Out:
	"""Default target for writing help text; prints to stdout."""
	def write(self, s):
		stdout.write(s.encode('utf8', 'replace'))


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
		print >> self._helpObj.output, '=' * 78, '\nAppscript Help\n\nCommand:'
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
		self.containingClass = terms.classes().byname('application').full()
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

    -h -- information on help()
    -o -- overview of all supported classes and commands
    -k -- list all built-in type and enumerator names
    -r [class-name] -- one-to-one and one-to-many relationships for specific class/current reference
    -i [class-name] -- inheritance tree for all classes/specific class
    -s [property-or-element-name] -- state of properties and elements of object(s) currently referenced
    -t [class-or-command-name] -- terminology for specific class/command or current reference/command

    Values shown in brackets are optional.

Notes: 
    - If no flags argument is given, '-t' is used.

    - When the -i option is used on a specific class that has multiple inheritance, this will be represented by multiple graphs. When the -i option is used for all classes, classes with multiple inheritance will appear at multiple points in the graph. In both cases, the class's subclasses will appear once in full, then abbreviated for space thereafter.

    - The -s option may take time to process if there are many properties and/or elements to get. When the -s option is used on a command, the command's arguments and result are displayed separately when called.

    - When the -t option is used, one-to-one relationships are shown as '-NAME', one-to-many as '=NAME'; a property's class is shown in angle brackets; a trailing arrow, '->', indicates a class's relationships are already given elsewhere.

For example, to print an overview of TextEdit, a description of its make command and the inheritance tree for its document class:

    app('TextEdit.app').help('-o -d make -i document')"""
	
	
	def __init__(self, path, url, out=_Out()):
		self.output = out
		if path:
			self.terms = aeteparser.parseapp(path)
		else:
			from remoteterminology import getRemoteAetes
			self.terms = aeteparser.parsedata(getRemoteAetes(url))
	
	
	def overview(self):
		print >> self.output, 'Overview:\n'
		textdoc.IndexRenderer(out=self.output).draw(self.terms)
	
	def keywords(self):
		print >> self.output, 'Built-in keywords:\n'
		names = terminology.defaulttypesbycode.values()
		names.sort(lambda a,b:cmp(a.name.lower(), b.name.lower()))
		for name in names:
			print >> self.output, '    %s' % name
		
		
	def command(self, name):
		try:
			command = self.terms.commands().byname(name)
		except KeyError: # application terminology doesn't define this command (e.g. Required Suite or get/set)
			raise HelpError('No terminology available for command %r.' % name)
		else:
			print >> self.output,'Terminology for %s command\n\nCommand:' % command.name,
			textdoc.FullRenderer(options=['full'], out=self.output).draw(command)
	
	
	def klass(self, name):
		klass = self.terms.classes().byname(name).full()
		print >> self.output, 'Terminology for %s class\n\nClass:' % klass.name,
		textdoc.FullRenderer(options=['full'], out=self.output).draw(klass)
	
	
	def property(self, p):
		print >> self.output, 'Property:',
		textdoc.FullRenderer(options=['full'], out=self.output).draw(p)
	
	def element(self, e):
		print >> self.output, 'Element:',
		textdoc.FullRenderer(options=['full'], out=self.output).draw(e)
	
	
	def inheritance(self, className=''):
		if className:
			print >> self.output, 'Inheritance for %s class\n' % className
		else:
			print >> self.output, 'Inheritance for all classes:\n'
		inheritance.InheritanceGrapher(self.terms, inheritance.TextRenderer(self.output)).draw(className)
		print >> self.output


	def relationships(self, ref, className=''):
		if className:
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
		if className:
			relationships.RelationshipGrapher(self.terms, relationships.TextRenderer(self.output)).draw(className, 2)
		else:
			print >> self.output, 'None found.\n' % ref
		print >> self.output

	
	#######
	
	def _resolveRef(self, ref):
		resolver = ReferenceResolver(self.terms)
		ref.AS_aemreference.AEM_resolve(resolver)
		return resolver
	
	
	def _terminologyForClassOrCommand(self, ref, name=None):
		if name:
			if name in self.terms.commands().names():
				self.command(name)
			elif name in self.terms.classes().names():
				self.klass(name)
			else:
				raise HelpError('No terminology available for class/command %r.' % name)
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
				pprint(ref.get(), self.output)
			except:
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
									pprint(getattr(ref, name).get(), self.output)
								except:
									print >> self.output, 'UNAVAILABLE'
				else:
					print >> self.output, 'Current state of referenced property (or properties)\n\n%s:' % \
							definition.name
					self._printRefValue(ref)
	
	
	#######
	
	def _manual(self):
		print >> self.output, self._helpManual

	##
	kNoArg, kOptArg, kReqArg = 0, 1, 2
	
	_handlers = {
			# (requires reference?, takes no/optional/required argument?, function)
			'h':(False, kNoArg, _manual),
			'o':(False, kNoArg, overview),
			'r':(True, kOptArg, relationships),
			'i':(False, kOptArg, inheritance),
			's':(True, kOptArg, _stateForRef),
			't':(True, kOptArg, _terminologyForClassOrCommand),
			'k':(False, kNoArg, keywords),
			# TO DO: allow user to get reference's dictionary (-d)
			# TO DO: allow user to get 'parent' reference (-p)
			# TO DO: allow user to get reference info (-x)
			}



	def help(self, flags, ref): # main call
		result = ref
		if not isinstance(flags, basestring): # assume flags arg contains file/StringIO/etc. object to write help to
			self.output = flags
		else:
			tokens = flags.split()
			print >> self.output, '=' * 78 + '\nAppscript Help (%s)\n' % ' '.join(tokens)
			print >> self.output, 'Reference: %r' % ref
			i = 0
			while i < len(tokens):
				print >> self.output, '\n' + '-' * 78
				token = tokens[i]
				try:
					requiresRef, flag, fn = self._handlers[token[1:]]
				except KeyError:
					print >> self.output, 'Unknown request: %r\n' % token
				else:
					args = []
					if requiresRef:
						args.append(ref)
					if flag == self.kReqArg or flag == self.kOptArg and i+1 < len(tokens) and not tokens[i+1].startswith('-'):
						i += 1
						try:
							word = tokens[i]
						except IndexError:
							word = ''
						args.append(word)
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



