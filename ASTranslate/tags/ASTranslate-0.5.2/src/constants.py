""" constants """

kLanguageCount = 3

# (note: these are same as indexes of segmented control in window)
kLangPython = 0
kLangRuby = 1
kLangObjC = 2

kLangAll = None


class kNoParam: pass


class UntranslatedKeywordError(RuntimeError):
	
	def __init__(self, kind, code, lang):
		RuntimeError.__init__(self, kind, code, lang)
		self.kind, self.code, self.lang = kind, code, lang
	
	def __str__(self):
		return "Couldn't find keyword definition for %s code %r and %s translator can't display raw AE codes."% (self.kind, self.code, self.lang)
		
class UntranslatedUserPropertyError(RuntimeError):
	
	def __init__(self, name, lang):
		RuntimeError.__init__(self, name, lang)
		self.name, self.lang = name, lang
	
	def __str__(self):
		return "Found user-defined property %r but %s translator can only display dictionary-defined names."% (self.name, self.lang)

