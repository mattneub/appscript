ASDictionary

-----------------------------------
ABOUT

ASDictionary renders scriptable Mac applications' dictionaries in plain text or HTML format, or dumps their raw aete data to file. Requires Mac OS 10.3 or later. 

-----------------------------------
USAGE

1. Drag-n-drop one or more applications onto ASDictionary, or double-click ASDictionary and select from a list of all available applications.

2. Choose the desired output formats: raw aete, plain text and/or HTML.

3. If an HTML format is chosen, choose whether duplicate class definitions should be combined into one or not. (For example, TextEdit defines a 'document' class in its Standard Suite, and again in its TextEdit Suite.)

4. Select a destination folder for the generated files.

-----------------------------------
NOTES

- While ASDictionary is fairly tolerant of weird and buggy application dictionaries, HTML generation may fail on a few especially strange ones. Should this happen, please submit a bug report.

- By default, ASDictionary uses its built-in HTML template to render AppleScript dictionaries. To have it use an external HTML template, copy the ASDictionary folder located within the Templates folder to your ~/Library/Application Support folder. You can then edit the ~/Library/Application Support/ASDictionary/Template.html file to use a different CSS stylesheet, or to make minor modifications to the HTML markup. 

Note that HTML elements containing special 'node' attributes are used by ASDictionary to insert content. Deleting or moving these elements may break the template unless you modify ASDictionary as well; see the Source folder.

- Many thanks to the following for comments, suggestions and bug reports: Philip Aker, Emmanuel Levy, Tim Mansour, Jake Pietrykowski, Courtney Schwartz

-----------------------------------
HISTORY

2006-09-19 -- 0.6.2; renamed to ASDictionary

2006-08-26 -- 0.6.1; now uses appscript 0.16.2 - this fixes some additional HTML rendering problems; combining duplicate class definitions into one is now optional

2006-08-17 -- 0.6.0; now uses appscript 0.16.1 - this fixes rendering problems for applications that have classes in hidden suites, where visible classes by the same name could end up moved to the hidden suite and therefore fail to show up in HTML output (e.g. Mail 2's 'application' class); changed licence from LGPL to MIT; Universal build

2005-11-22 -- 0.5.0; now supports optional external HTML template for AppleScript dictionaries; new icon; no longer renders HTML dictionaries for applications that don't have one

2005-05-27 -- 0.4.1; now ignores invalid reference forms instead of erroring

2005-05-13 -- 0.4.0; now generates appscript-style terminology; allows selection of multiple formats

2005-04-29 -- 0.3.0; more forgiving of weird and broken dictionaries; merges DumpAETE functionality; improves hyperlinking; new cheesy icon

-----------------------------------
COPYRIGHT

(C) 2005 HAS -- <hhas -at- users - sourceforge - net> <http://appscript.sourceforge.net>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.