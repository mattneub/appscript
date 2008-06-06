#!/usr/local/bin/ruby
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

# The MRASafeObject class undefines any methods not on the EXCLUDE safe list; traps are
# then applied to Module#method_added and Module#included to detect any subsequent
# method additions and immediately remove those from MRASafeObject as well.

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

class MRASafeObject

	NSObjectMethods = [
	:"_scriptingRemoveValueForSpecifier:",
	
	:!, :!=, :"!=:", :!~, :<, :<=, :<=>, :==, :"==:", :===, :=~, :>, :>=, :"Array:", :CAML_supportedClass, :CA_JSClass, :CA_JSClassName, :"CA_addValue:multipliedBy:", :"CA_copyJSValue:", :CA_copyRenderValue, :"CA_distanceToValue:", :"CA_interpolateValue:byFraction:", :CI_affineTransform, :CI_rect, :"Float:", :"Integer:", :"String:", :"[]:", :[]=, :__callee__, :__id__, :__method__, :__send__, :_accessibilityUIElementPath, :"_accessibilityUIElementPathForChild:", :"_addObserver:forProperty:options:context:", :"_addOptionValue:toArray:withKey:type:", :"_addPlaceholderOptionValue:isDefault:toArray:withKey:binder:binding:", :_asScriptTerminologyNameArray, :_asScriptTerminologyNameString, :"_bind:toController:withKeyPath:valueTransformerName:options:existingNibConnectors:connectorsToRemove:connectorsToAdd:", :"_binderClassForBinding:withBinders:", :"_binderForBinding:withBinders:createAutoreleasedInstanceIfNotFound:", :"_binderWithClass:withBinders:createAutoreleasedInstanceIfNotFound:", :_bindingAdaptor, :_bindingCreationDelegate, :"_bindingInformationWithExistingNibConnectors:availableControllerChoices:", :_cfTypeID, :"_cleanupBindingsWithExistingNibConnectors:exception:", :"_compatibility_takeValue:forKey:", :"_concealBinding:", :"_conformsToProtocolNamed:", :_copyDescription, :"_createKeyValueBindingForKey:name:bindingType:", :"_createMutableArrayValueGetterWithContainerClassID:key:", :"_createMutableSetValueGetterWithContainerClassID:key:", :"_createOtherValueGetterWithContainerClassID:key:", :"_createOtherValueSetterWithContainerClassID:key:", :"_createValueGetterWithContainerClassID:key:", :"_createValuePrimitiveGetterWithContainerClassID:key:", :"_createValuePrimitiveSetterWithContainerClassID:key:", :"_createValueSetterWithContainerClassID:key:", :"_didChangeValuesForKeys:", :"_exposeBinding:valueClass:", :_exposedBindings, :"_guaranteeStorageInDictionary:addBinding:", :"_id2ref:", :_implicitObservationInfo, :"_invokeSelector:withArguments:onKeyPath:", :_isAXConnector, :_isKVOA, :"_keysForValuesAffectingValueForKey:", :"_kitNewObjectSetVersion:", :_localClassNameForClass, :"_notifyObserversForKeyPath:change:", :"_oldValueForKey:", :"_oldValueForKeyPath:", :"_optionDescriptionsForBinding:", :"_placeSuggestionsInDictionary:acceptableControllers:boundBinders:binder:binding:", :_registerDefaultPlaceholders, :"_registerObjectClass:placeholder:binding:", :_releaseBindingAdaptor, :"_removeObserver:forProperty:", :"_scriptingAddObjectsFromArray:toValueForKey:", :"_scriptingAddObjectsFromSet:toValueForKey:", :"_scriptingAddToReceiversArray:", :"_scriptingAlternativeValueRankWithDescriptor:", :"_scriptingArrayOfObjectsForSpecifier:", :"_scriptingCanAddObjectsToValueForKey:", :"_scriptingCanHandleCommand:", :"_scriptingCanInsertBeforeOrReplaceObjectsAtIndexes:inValueForKey:", :"_scriptingCanSetValue:forSpecifier:", :"_scriptingCoerceValue:forKey:", :"_scriptingCopyWithProperties:forValueForKey:ofContainer:", :_scriptingCount, :_scriptingCountNonrecursively, :"_scriptingCountOfValueForKey:", :"_scriptingDescriptorOfComplexType:orReasonWhyNot:", :"_scriptingDescriptorOfEnumeratorType:orReasonWhyNot:", :"_scriptingDescriptorOfObjectType:orReasonWhyNot:", :"_scriptingDescriptorOfValueType:orReasonWhyNot:", :"_scriptingEnumeratorOfType:withDescriptor:", :"_scriptingIndexOfObjectForSpecifier:", :"_scriptingIndexOfObjectWithName:inValueForKey:", :"_scriptingIndexOfObjectWithUniqueID:inValueForKey:", :"_scriptingIndexesOfObjectsForSpecifier:", :"_scriptingIndicesOfObjectsAfterValidatingSpecifier:", :"_scriptingIndicesOfObjectsForSpecifier:count:", :"_scriptingInsertObject:inValueForKey:", :"_scriptingInsertObjects:atIndexes:inValueForKey:", :"_scriptingMightHandleCommand:", :"_scriptingObjectAtIndex:inValueForKey:", :"_scriptingObjectCountInValueForKey:", :"_scriptingObjectForSpecifier:", :"_scriptingObjectWithName:inValueForKey:", :"_scriptingObjectWithUniqueID:inValueForKey:", :"_scriptingObjectsAtIndexes:inValueForKey:", :"_scriptingRemoveAllObjectsFromValueForKey:", :"_scriptingRemoveObjectsAtIndexes:fromValueForKey:", :"_scriptingRemo
Script ended 2008-06-06 14:32:15 +0100 (0)
veValueForSpecifier:", :"_scriptingReplaceObjectAtIndex:withObjects:inValueForKey:", :"_scriptingSetOfObjectsForSpecifier:", :"_scriptingSetValue:forKey:", :"_scriptingSetValue:forSpecifier:", :_scriptingShouldCheckObjectIndexes, :"_scriptingValueForKey:", :"_scriptingValueForSpecifier:", :"_scriptingValueOfComplexType:withDescriptor:", :"_scriptingValueOfObjectType:withDescriptor:", :"_scriptingValueOfOneOfAlternativeTypes:withDescriptor:", :"_scriptingValueOfValueType:withDescriptor:", :"_selectorToGetValueWithNameForKey:", :"_selectorToGetValueWithUniqueIDForKey:", :"_setBindingAdaptor:", :"_setBindingCreationDelegate:", :"_setObject:forBothSidesOfRelationshipWithKey:", :"_shouldAddObservationForwardersForKey:", :"_stateMarkerForValue:", :"_suggestedControllerKeyForController:binding:", :"_supportsGetValueWithNameForKey:perhapsByOverridingClass:", :"_supportsGetValueWithUniqueIDForKey:perhapsByOverridingClass:", :"_unbind:existingNibConnectors:connectorsToRemove:connectorsToAdd:", :"_willChangeValuesForKeys:", :"`:", :accessInstanceVariablesDirectly, :"accessibilityArrayAttributeCount:", :"accessibilityArrayAttributeValues:index:maxCount:", :"accessibilityAttributeValue:forParameter:", :"accessibilityDecodeOverriddenAttributes:", :"accessibilityEncodeOverriddenAttributes:", :"accessibilityIndexOfChild:", :accessibilityOverriddenAttributes, :accessibilityParameterizedAttributeNames, :"accessibilitySetOverrideValue:forAttribute:", :accessibilityShouldUseUniqueId, :accessibilitySupportsOverriddenAttributes, :"acos:", :"acosh:", :"addObject:toBothSidesOfRelationshipWithKey:", :"addObject:toPropertyWithKey:", :"addObserver:forKeyPath:options:context:", :"add_finalizer:", :allPropertyKeys, :alloc, :"allocWithZone:", :allocate, :ancestors, :"animatorShouldPerformSelector:", :argv, :"asin:", :"asinh:", :"assoc:", :at_exit, :atan2, :"atan:", :"atanh:", :attributeKeys, :autoload, :autoload?, :"autoload?:", :"automaticallyNotifiesObserversForKey:", :"awakeAfterUsingCoder:", :"bind:toObject:withKeyPath:options:", :binding, :binmode, :block_given?, :"blockdev?:", :"call_finalizer:", :"cancelPreviousPerformRequestsWithTarget:", :"cancelPreviousPerformRequestsWithTarget:selector:object:", :"cbrt:", :"change_privilege:", :"chardev?:", :class, :classCode, :classDescription, :"classDescriptionForDestinationKey:", :classFallbacksForKeyedArchiver, :classForArchiver, :classForCoder, :classForKeyedArchiver, :classForKeyedUnarchiver, :classForPortCoder, :className, :class_eval, :class_exec, :class_variable_defined?, :class_variable_get, :class_variable_set, :class_variables, :clear, :clearProperties, :clone, :close, :closed?, :"coerceValue:forKey:", :"coerceValueForScriptingProperties:", :"conformsToProtocol:", :const_defined?, :const_get, :const_missing, :"const_missing:", :const_set, :constants, :copy, :"copyScriptingValue:forKey:withProperties:", :"copyWithZone:", :"cos:", :"cosh:", :"createKeyValueBindingForKey:typeMask:", :debugDescription, :"defaultPlaceholderForMarker:withBinding:", :default_dir, :define_singleton_method, :"delete:", :delete_if, :description, :"detach:", :"dictionaryWithValuesForKeys:", :"didChange:valuesAtIndexes:forKey:", :"didChangeValueForKey:", :"didChangeValueForKey:withSetMutation:usingObjects:", :dir, :"directory?:", :disable, :display, :"doesContain:", :"doesNotRecognizeSelector:", :dup, :each, :each_byte, :each_key, :each_pair, :each_value, :egid, :"egid=:", :eid, :"eid=:", :empty?, :enable, :"ensure_gem_subdirectories:", :entityName, :enum_for, :eof, :eof?, :eql?, :equal?, :"equal?:", :"erf:", :"erfc:", :euid, :"euid=:", :"executable?:", :"executable_real?:", :"exist?:", :"exists?:", :"exp:", :"exposeBinding:", :exposedBindings, :extend, :external_encoding, :file, :"file?:", :filename, :fileno, :finalize, :finalizers, :flushAllKeyBindings, :flushClassKeyBindings, :flushKeyBindings, :fork, :"forwardInvocation:", :"forwardingTargetForSelector:", :freeze, :"frexp:", :frozen?, :"gamma:", :garbage_collect, :gem, :getbyte, :getc, :getegid, :geteuid, :getgid, :"getpgid:", :getpgrp, :getpriority, :"getrlimit:", :getuid, :gid, :"gid=:", :global_variables, :"grant_privilege:", :groups, :"groups=:", :"grpowned?:", :"handleQueryWithUnboundKey:", :"handleTakeValue:forUnboundKey:", :"has_key?:", :"has_value?:", :hash, :hypot, :identical?, :"implementsSelector:", :include?, :"include?:", :"included:", :included_modules, :"index:", :"infoForBinding:", :init, :initgroups, :initialize, :"initialize:", :inplace_mode, :"inplace_mode=:", :"insertValue:atIndex:inPropertyWithKey:", :"insertValue:inPropertyWithKey:", :inspect, :"instanceMethodDescriptionForSelector:", :"instanceMethodForSelector:", :"instanceMethodSignatureForSelector:", :instance_eval, :instance_exec, :instance_method, :instance_methods, :instance_of?, :instance_variable_defined?, :instance_variable_get, :instance_variable_set, :instance_variables, :"instancesImplementSelector:", :"instancesRespondToSelector:", :internal_encoding, :"inverseForRelationshipKey:", :invert, :"isAncestorOfObject:", :"isCaseInsensitiveLike:", :"isEqual:", :"isEqualTo:", :isFault, :"isGreaterThan:", :"isGreaterThanOrEqualTo:", :"isKindOfClass:", :"isLessThan:", :"isLessThanOrEqualTo:", :"isLike:", :"isMemberOfClass:", :isNSArray__, :isNSData__, :isNSDate__, :isNSDictionary__, :isNSNumber__, :isNSSet__, :isNSString__, :isNSValue__, :"isNotEqualTo:", :isProxy, :"isSubclassOfClass:", :"isToManyKey:", :is_a?, :issetugid, :iterator?, :"key:", :"key?:", :"keyPathsForValuesAffectingValueForKey:", :"keyValueBindingForKey:typeMask:", :keys, :kind_of?, :lambda, :ldexp, :length, :"lgamma:", :lineno, :"lineno=:", :list, :load, :"load_bridge_support_file:", :load_full_rubygems_library, :local_variables, :"log10:", :"log2:", :loop, :maxgroups, :"maxgroups=:", :"member?:", :method, :"methodDescriptionForSelector:", :"methodForSelector:", :"methodSignatureForSelector:", :method_defined?, :methods, :module_eval, :module_exec, :"mutableArrayValueForKey:", :"mutableArrayValueForKeyPath:", :mutableCopy, :"mutableCopyWithZone:", :"mutableSetValueForKey:", :"mutableSetValueForKeyPath:", :name, :new, :"newScriptingObjectOfClass:forValueForKey:withContentsValue:properties:", :"nextSlicePiece:", :nil?, :objc_ancestors, :objectSpecifier, :object_id, :observationInfo, :"observeValueForKeyPath:ofObject:change:context:", :"optionDescriptionsForBinding:", :"owned?:", :"ownsDestinationObjectsForRelationshipKey:", :path, :"performSelector:", :"performSelector:object:afterDelay:", :"performSelector:onThread:withObject:waitUntilDone:", :"performSelector:onThread:withObject:waitUntilDone:modes:", :"performSelector:withObject:", :"performSelector:withObject:afterDelay:", :"performSelector:withObject:afterDelay:inModes:", :"performSelector:withObject:withObject:", :"performSelectorInBackground:withObject:", :"performSelectorOnMainThread:withObject:waitUntilDone:", :"performSelectorOnMainThread:withObject:waitUntilDone:modes:", :pid, :"pipe?:", :pos, :"pos=:", :"poseAsClass:", :ppid, :private_class_method, :private_instance_methods, :private_method_defined?, :private_methods, :proc, :protected_instance_methods, :protected_method_defined?, :protected_methods, :public_class_method, :public_instance_method, :public_instance_methods, :public_method, :public_method_defined?, :public_methods, :public_send, :"putc:", :"rassoc:", :re_exchange, :re_exchangeable?, :"readable?:", :"readable_real?:", :readbyte, :readchar, :rehash, :reject, :reject!, :"removeObject:fromBothSidesOfRelationshipWithKey:", :"removeObject:fromPropertyWithKey:", :"removeObserver:forKeyPath:", :"removeValueAtIndex:fromPropertyWithKey:", :remove_class_variable, :"remove_finalizer:", :"replace:", :"replaceValueAtIndex:inPropertyWithKey:withValue:", :"replacementObjectForArchiver:", :"replacementObjectForCoder:", :"replacementObjectForKeyedArchiver:", :"replacementObjectForPortCoder:", :"require:", :"resolveClassMethod:", :"resolveInstanceMethod:", :respond_to?, :"respondsToSelector:", :rewind, :rid, :scriptingProperties, :"scriptingValueForSpecifier:", :select, :self, :send, :"setDefaultPlaceholder:forMarker:withBinding:", :"setKeys:triggerChangeNotificationsForDependentKey:", :"setNilValueForKey:", :"setObservationInfo:", :"setScriptingProperties:", :"setValue:forKey:", :"setValue:forKeyPath:", :"setValue:forUndefinedKey:", :"setValuesForKeysWithDictionary:", :"setVersion:", :"set_home:", :"set_paths:", :"set_trace_func:", :"setegid:", :"seteuid:", :"setgid:", :"setgid?:", :setpgid, :setpgrp, :setpriority, :setregid, :setresgid, :setresuid, :setreuid, :"setrgid:", :"setruid:", :setsid, :"setuid:", :"setuid?:", :shift, :sid_available?, :"sin:", :singleton_methods, :"sinh:", :size, :"size:", :"size?:", :skip, :"socket?:", :"sqrt:", :start, :"sticky?:", :store, :"storedValueForKey:", :stress, :"stress=:", :superclass, :switch, :"symlink?:", :taint, :tainted?, :"takeStoredValue:forKey:", :"takeStoredValuesFromDictionary:", :"takeValue:forKey:", :"takeValue:forKeyPath:", :"takeValuesFromDictionary:", :"tan:", :"tanh:", :tap, :tell, :times, :toManyRelationshipKeys, :toOneRelationshipKeys, :to_a, :to_enum, :to_hash, :to_i, :to_io, :to_s, :uid, :"uid=:", :"unableToSetNilForKey:", :"unbind:", :"undefine_finalizer:", :untaint, :"update:", :useStoredAccessor, :"validateTakeValue:forKeyPath:", :"validateValue:forKey:", :"validateValue:forKey:error:", :"validateValue:forKeyPath:error:", :"value?:", :"valueAtIndex:inPropertyWithKey:", :"valueClassForBinding:", :"valueForKey:", :"valueForKeyPath:", :"valueForUndefinedKey:", :"valueWithName:inPropertyWithKey:", :"valueWithUniqueID:inPropertyWithKey:", :values, :"valuesForKeys:", :version, :waitall, :"warn:", :"willChange:valuesAtIndexes:forKey:", :"willChangeValueForKey:", :"willChangeValueForKey:withSetMutation:usingObjects:", :"world_readable?:", :"world_writable?:", :"writable?:", :"writable_real?:", :"zero?:", :zone].collect { |n| n.to_s }

	EXCLUDE = NSObjectMethods + MRAReservedKeywords + [
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
# MRASafeObject after MRASafeObject is defined will show up in the
# list of available MRASafeObject methods. We handle this by defining
# hooks in Module that will hide any defined.

class Module
	madded = method(:method_added)
	define_method(:method_added) do |name|
		# puts "ADDED    %-32s %s" % [name, self]
		result = madded.call(name)
		if self == Object
			MRASafeObject.hide(name)
		end
		return result
	end
	mincluded = method(:included)
	define_method(:included) do |mod|
		result = mincluded.call(mod)
		# puts "INCLUDED %-32s %s" % [mod, self]
		if mod == Object
			public_instance_methods(true).each { |name| MRASafeObject.hide(name) }
			#private_instance_methods(true).each { |name| MRASafeObject.hide(name) }
			protected_instance_methods(true).each { |name| MRASafeObject.hide(name) }
		end
		return result
	end
end
