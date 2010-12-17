#
# rb-appscript
#
# safeobject -- ensure Appscript::Reference#method_missing works reliably
#
# Original code Copyright (C) 2005 Thomas Sawyer, Jim Weirich; see below for original copyright
#

# Notes:

# A modified, updated version of basicobject (http://facets.rubyforge.org/), used to provide
# Appscript::Reference and Appscript#GenericReference with stable superclasses.

# Unfortunately, Ruby makes it ludicrously easy for users to accidentally add new methods
# to the Object class. And if these methods' names are the same as application keywords, 
# Ruby will invoke them instead of Reference#method_missing, resulting in incorrect behaviour.
#
# e.g. The following code demonstrates the problem in an unpatched copy of appscript 0.2.1.
# Including modules in the main script for convenience is a not-uncommon practice; unfortunately,
# because main's class is Object, this causes the additional methods to appear on every other
# object in the system as well (very bad).
#
#######
# require 'appscript'
#
# module X
#	def name
#		puts 'X.name was called'
#		return 999
#	end
# end
# include X
#
# Appscript.app('textedit').name.get
########
#
# Result:
#
# # X.name was called
# # /tmp/tmpscript:13: undefined method `get' for 999:Fixnum (NoMethodError)

# The AS_SafeObject class undefines any methods not on the EXCLUDE safe list; traps are
# then applied to Module#method_added and Module#included to detect any subsequent
# method additions and immediately remove those from AS_SafeObject as well.

# Having to insert traps into other users' runtimes isn't exactly an ideal solution, but 
# unless/until Ruby comes up with a safe, sane system for including modules in main that
# doesn't pollute every other namespace as well, it may be the only practical solution. The
# only other alternative would be a major redesign+rewrite of the appscript module to use 
# metaclasses (c.f. js-appscript) instead of method_missing, but this is not really desireable
# as it'd be much more complicated to implement, slower to initialise, and less elegant to
# use (since GenericReferences would have to be dropped).

######################################################################
# ORIGINAL COPYRIGHT
######################################################################

# = basicobject.rb
#
# == Copyright (c) 2005 Thomas Sawyer, Jim Weirich
#
# THE RUBY LICENSE
# (http://www.ruby-lang.org/en/LICENSE.txt)
# 
#  You may redistribute this software and/or modify it under either the terms of
#  the GPL (see below), or the conditions below:
# 
#   1. You may make and give away verbatim copies of the source form of the
#      software without restriction, provided that you duplicate all of the
#      original copyright notices and associated disclaimers.
# 
#   2. You may modify your copy of the software in any way, provided that
#      you do at least ONE of the following:
# 
#        a) place your modifications in the Public Domain or otherwise
#           make them Freely Available, such as by posting said
#           modifications to Usenet or an equivalent medium, or by allowing
#           the author to include your modifications in the software.
# 
#        b) use the modified software only within your corporation or
#           organization.
# 
#        c) rename any non-standard executables so the names do not conflict
#           with standard executables, which must also be provided.
# 
#        d) make other distribution arrangements with the author.
# 
#   3. You may distribute the software in object code or executable
#      form, provided that you do at least ONE of the following:
# 
#        a) distribute the executables and library files of the software,
#           together with instructions (in the manual page or equivalent)
#           on where to get the original distribution.
# 
#        b) accompany the distribution with the machine-readable source of
#           the software.
# 
#        c) give non-standard executables non-standard names, with
#           instructions on where to get the original software distribution.
# 
#        d) make other distribution arrangements with the author.
# 
#   4. You may modify and include the part of the software into any other
#      software (possibly commercial).  But some files in the distribution
#      are not written by the author, so that they are not under these terms.
# 
#      For the list of those files and their copying conditions, see the
#      file LEGAL.
# 
#   5. The scripts and library files supplied as input to or produced as
#      output from the software do not automatically fall under the
#      copyright of the software, but belong to whomever generated them,
#      and may be sold commercially, and may be aggregated with this
#      software.
# 
#   6. THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#      IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#      PURPOSE.

######################################################################
# PUBLIC
######################################################################

require '_appscript/reservedkeywords'

class AS_SafeObject

	EXCLUDE = ReservedKeywords + [
		"Array",
		"Float",
		"Integer",
		"String",
		"`",
		"abort",
		"at_exit",
		"autoload",
		"autoload?",
		"binding",
		"block_given?",
		"callcc",
		"caller",
		"catch",
		"chomp",
		"chomp!",
		"chop",
		"chop!",
		"eval",
		"exec",
		"exit",
		"exit!",
		"fail",
		"fork",
		"format",
		"getc",
		"gets",
		"global_variables",
		"gsub",
		"gsub!",
		"initialize",
		"initialize_copy",
		"iterator?",
		"lambda",
		"load",
		"local_variables",
		"loop",
		"open",
		"p",
		"print",
		"printf",
		"proc",
		"putc",
		"puts",
		"raise",
		"rand",
		"readline",
		"readlines",
		"remove_instance_variable",
		"require",
		"scan",
		"select",
		"set_trace_func",
		"singleton_method_added",
		"singleton_method_removed",
		"singleton_method_undefined",
		"sleep",
		"split",
		"sprintf",
		"srand",
		"sub",
		"sub!",
		"syscall",
		"system",
		"test",
		"throw",
		"trace_var",
		"trap",
		"untrace_var",
		"warn"
	] + [
		/^__/, /^instance_/, /^object_/, /\?$/, /^\W$/,
	]

	def self.hide(name)
		case name.to_s # Ruby1.9 returns method names as symbols, not strings as in 1.8
			when *EXCLUDE
		else
			undef_method(name) rescue nil
		end
	end

	public_instance_methods(true).each { |m| hide(m) }
	#private_instance_methods(true).each { |m| hide(m) }
	protected_instance_methods(true).each { |m| hide(m) }

end



######################################################################
# PRIVATE
######################################################################
# Since Ruby is very dynamic, methods added to the ancestors of
# AS_SafeObject after AS_SafeObject is defined will show up in the
# list of available AS_SafeObject methods. We handle this by defining
# hooks in Module that will hide any defined.

class Module
	madded = method(:method_added)
	define_method(:method_added) do |name|
		# puts "ADDED    %-32s %s" % [name, self]
		result = madded.call(name)
		if self == Object
			AS_SafeObject.hide(name)
		end
		return result
	end
	mincluded = method(:included)
	define_method(:included) do |mod|
		result = mincluded.call(mod)
		# puts "INCLUDED %-32s %s" % [mod, self]
		if mod == Object
			public_instance_methods(true).each { |name| AS_SafeObject.hide(name) }
			#private_instance_methods(true).each { |name| AS_SafeObject.hide(name) }
			protected_instance_methods(true).each { |name| AS_SafeObject.hide(name) }
		end
		return result
	end
end
