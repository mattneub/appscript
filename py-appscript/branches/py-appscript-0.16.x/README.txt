Appscript is packaged using the standard Python Distribution Utilities (a.k.a. Distutils). To install appscript, cd to the appscript-0.16.2 directory and run:

	python setup.py bdist_mpkg --open

Building appscript from source requires bdist_mpkg (http://undefined.org/python/) and the gcc compiler (supplied with Apple's Developer Tools).

Appscript requires MacPython 2.3 or later and Mac OS X 10.3 or later.


======================================================================
NOTES

- This Distutils package will install aem, aemreceive, appscript, CarbonX, macfile, osaterminology and osax; these will all be installed in site-packages/aeosa. Previous versions of these packages will need to be removed manually before use.

- Documentation and examples should now be installed at /Developer/Python. (Previous versions were installed in /Applications/Utilities/appscript; these should be removed manually.)

- ASTS has been dropped. Existing installations should be removed manually.

- The appscript API has undergone several changes, including the following:

	- the filter reference form syntax has changed (you will need to update your scripts accordingly)

	- 'app' is no longer a class (only an issue if subclassing it/using it for typechecking purposes)

- The aem and osaterminology packages have also undergone significant changes. See the documentation for details.

- appscript 0.16.1+ uses 'ascrgdte' events to retrieve terminology for both local and remote applications (previous versions used OSAGetAppTerminology). Due to a bug in Cocoa Scripting (bug id #4677156), classes and commands defined in hidden 'tpnm' suites are lost, so class, property and command names that are only defined there won't be available to appscript (e.g. the obsoleted 'title' property in iCal 2's dictionary is missing, so scripts written to work on OS 10.3 will need to be modified to work on OS 10.4 and vice-versa).

- Appscript and aem are now moving towards beta 1 status, so please report any problems you have either with the appscript bridge itself or with scripting individual applications. In particular, appscript is a bit more sensitive to application bugs and terminology flaws than AppleScript is, so will sometimes fail on tasks where AppleScript works; identifying these problem apps so that internal/external workarounds can be developed will be useful.


======================================================================
DEPENDENCIES

- HTMLTemplate -- see <http://www.python.org/pypi/HTMLTemplate>

- LaunchServices -- Python 2.3 only; see Py23Compat packages at <http://undefined.org/python/>


======================================================================
COPYRIGHT

(C) 2006 HAS <hhas -at- users - sourceforge - net> <http://appscript.sourceforge.net>

