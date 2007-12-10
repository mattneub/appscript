ASTranslate

-----------------------------------
ABOUT

A simple tool for converting application commands written in AppleScript into their appscript equivalent.

Usage:

1. Launch ASTranslate and type or paste one or more AppleScript commands into the top half of the window, e.g.:

	tell application "TextEdit" to get text of every document

	with timeout of 10 seconds		tell application "Finder" to folder 1 of home as alias	end timeout

2. Select Document > Translate. The AppleScript code is compiled and executed, and the bottom pane displays each Apple event sent by AppleScript as appscript code, e.g.:

	app(u'/Applications/TextEdit.app').documents.text.get()

	app(u'/System/Library/CoreServices/Finder.app').home.folders[1].get(resulttype=k.Alias, timeout=10)

Click on the tabs below the bottom pane to switch between Python and Ruby translations. 

Note that Ruby appscript translations are only available if rb-appscript 0.3.0 or later is installed. You can obtain the latest rb-appscript release from:

	http://rb-appscript.rubyforge.org/

-----------------------------------
NOTES

- ASTranslate only sniffs outgoing Apple events sent by AppleScript; it's not a full-blown AppleScript->Python code converter or anything like that.

- The output is fairly dumb, but is handy when figuring out how to translate a particular reference or command from AppleScript to Python.

- Don't forget that all Apple events sent by AppleScript will be passed to applications to be handled as normal. i.e. Destructive commands (e.g. 'tell "Finder" to delete some file') will still do their destructive thing; invalid or unsuccessful commands will cause AppleScript to raise an error, etc.

- Ruby translations are only available if rb-appscript is installed on the host machine's default Ruby installation. (The command line ruby interpreter used by ASTranslate is determined by the host's /bin/sh $PATH environment variable.)

- Source code is available via svn; see <http://appscript.sourceforge.net>.

-----------------------------------
HISTORY

2007-12-10 -- 0.3.1; fixed a bug where commands wouldn't translate if a parameter's AE code was also used by a class/property/enumerator in the same application dictionary [MM]

2007-06-25 -- 0.3.0; added rb-appscript support; subject ('subj') attributes now display correctly

2006-08-17 -- 0.2.0; updated for appscript 0.16.1; fixed 'make' command rendering bug

2006-01-05 -- 0.1.1; now renders complex filter references correctly

2005-12-07 -- 0.1.0; first release

-----------------------------------
COPYRIGHT

(C) 2005 HAS -- <hhas -at- users - sourceforge - net> <http://appscript.sourceforge.net>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
