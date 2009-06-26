"""reservedkeywords

(C) 2004-2008 HAS
"""

import keyword

# Important: the following must be reserved:
#
# - names of properties and methods used in reference.Application and reference.Reference classes
# - names of built-in keyword arguments in reference.Command.__call__

kReservedKeywords = [
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
	"beginswith",
	"endswith",
	"contains",
	"isin",
	"doesnotbeginwith",
	"doesnotendwith",
	"doesnotcontain",
	"isnotin",
	"AND",
	"NOT",
	"OR",
	"begintransaction",
	"aborttransaction",
	"endtransaction",
	"isrunning",
	"resulttype",
	"ignore",
	"timeout",
	"waitreply",
	"help",
	"as",
	"with",
	"relaunchmode",
	 ] + keyword.kwlist