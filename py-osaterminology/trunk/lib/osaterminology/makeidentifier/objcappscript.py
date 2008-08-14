"""makeidentifier.objcappscript -- Reserved keywords for objc-appscript

(C) 2004-2008 HAS
"""

# Important: the following must be reserved:
#
# - names of ObjC keywords
# - names of NSObject class and instance methods
# - names of methods used in ASConstant, ASReference classes
# - names of additional methods used in Application classes
# - names of built-in keyword arguments in ASCommand
# - anything else?

# TO DO: any ObjC 2.0 additions

######################################################################
# PRIVATE
######################################################################

kObjCKeywords = [
	"const",
	"extern",
	"auto",
	"register",
	"static",
	"unsigned",
	"signed",
	"volatile",
	"char",
	"double",
	"float",
	"int",
	"long",
	"short",
	"void",
	"typedef",
	"struct",
	"union",
	"enum",
	"id",
	"Class",
	"SEL",
	"IMP",
	"BOOL",
	"return",
	"goto",
	"if",
	"else",
	"case",
	"default",
	"switch",
	"break",
	"continue",
	"while",
	"do",
	"for",
	"sizeof",
	"self",
	"super",
	"nil",
	"NIL",
	"YES",
	"NO",
	"true",
	"false",
]

kObjCNSObjectMethods = [
	"initialize",
	"load",
	"new",
	"alloc",
	"allocWithZone",
	"init",
	"copy",
	"copyWithZone",
	"mutableCopy",
	"mutableCopyWithZone",
	"dealloc",
	"finalize",
	"class",
	"superclass",
	"isSubclassOfClass",
	"instancesRespondToSelector",
	"conformsToProtocol",
	"methodForSelector",
	"instanceMethodForSelector",
	"instanceMethodSignatureForSelector",
	"methodSignatureForSelector",
	"description",
	"poseAsClass",
	"cancelPreviousPerformRequestsWithTarget",
	"forwardInvocation",
	"doesNotRecognizeSelector",
	"awakeAfterUsingCoder",
	"classForArchiver",
	"classForCoder",
	"classForKeyedArchiver",
	"classFallbacksForKeyedArchiver",
	"classForKeyedUnarchiver",
	"classForPortCoder",
	"replacementObjectForArchiver",
	"replacementObjectForCoder",
	"replacementObjectForKeyedArchiver",
	"replacementObjectForPortCoder",
	"setVersion",
	"version",
	"attributeKeys",
	"classDescription",
	"inverseForRelationshipKey",
	"toManyRelationshipKeys",
	"toOneRelationshipKeys",
	"classCode",
	"className",
	"scriptingProperties",
	"setScriptingProperties",
]


kObjCAppscriptMethods = [	
	# used by ASReference
	"ID",
	"beginning",
	"end",
	"before",
	"after",
	"previous",
	"next",
	"first",
	"middle",
	"last",
	"any",
	"beginsWith",
	"endsWith",
	"contains",
	"isIn",
	"doesNotBeginWith",
	"doesNotEndWith",
	"doesNotContain",
	"isNotIn",
	"AND",
	"NOT",
	"OR",
	
	# miscellaneous
	"isRunning",
	"launchApplication",
	"launchApplicationWithError",
	"reconnectApplication",
	"reconnectApplicationWithError",
	
	# shortcuts
	"setItem",
	"getItem",
	"getItemWithError",
	"getList",
	"getListWithError",
	"getItemOfType",
	"getListOfType",
	"getIntWithError",
	"getLongWithError",
	"getDoubleWithError",
	
	# used by osaglue-generated XXApplication classes
	"initWithName",
	"initWithBundleID",
	"initWithSignature",
	"initWithPath",
	"initWithURL",
	"initWithPID",
	"initWithDescriptor",
	"beginTransaction",
	"beginTransactionWithSession",
	"abortTransaction",
	"endTransaction",
	"beginTransactionWithError",
	"endTransactionWithError",
	"abortTransactionWithError",
	
	# used by ASConstant
	"constantWithName",
	"constantWithCode",
	
	# used by ASCommand
	"considering",
	"sendMode",
	"waitForReply",
	"ignoreReply",
	"queueReply",
	"timeout",
	"requestedClass",
	"requestedType",
	"returnClass",
	"returnType",
	"returnList",
	"returnListOfClass",
	"returnListOfType",
	"returnDescriptor",
	"sendWithError",
	"send",
	
	# currently unused
	"ignoring",
	"returnID",
	"help",
]


######################################################################
# PUBLIC
######################################################################

kReservedWords = kObjCKeywords + kObjCNSObjectMethods + kObjCAppscriptMethods

