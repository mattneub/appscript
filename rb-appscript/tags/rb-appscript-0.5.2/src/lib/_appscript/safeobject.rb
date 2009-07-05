#
# rb-appscript
#
# safeobject -- ensure Appscript::Reference#method_missing works reliably
#
# New code Copyright (C) 2006-2009 HAS
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
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.

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
