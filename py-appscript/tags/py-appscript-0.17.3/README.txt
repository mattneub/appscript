Appscript is packaged using the standard Python Distribution Utilities (a.k.a. Distutils). To install appscript, cd to the appscript-0.17.3 directory and run:

	python setup.py install

Setuptools will be used if available, otherwise the setup.py script will revert to distutils.

If setuptools and bdist_mpkg are both installed, appscript can be installed by running the following command:

	python setup.py bdist_mpkg --open

This will build and open a binary installer for the appscript packages, documentation and examples.

Building appscript from source requires the gcc compiler (supplied with Apple's Developer Tools). Setuptools and bdist_mpkg are available from <http://cheeseshop.python.org/pypi>.

Appscript requires MacPython 2.3 or later and Mac OS X 10.3 or later.


======================================================================
NOTES

- The appscript API has undergone several non-backwards-compatible changes since 0.16.3. Please read the 'IMPORTANT - API CHANGES' file BEFORE installing appscript 0.17.0+.

- Documentation and examples are installed at /Developer/Python.

- Appscript and aem are now moving towards beta 1 status, so please report any problems you have either with the appscript bridge itself or with scripting individual applications. In particular, appscript is a bit more sensitive to application bugs and terminology flaws than AppleScript is, so will sometimes fail on tasks where AppleScript works; identifying these problem apps so that internal/external workarounds can be developed will be useful.


======================================================================
DEPENDENCIES

- HTMLTemplate -- see <http://www.python.org/pypi/HTMLTemplate>

- LaunchServices -- Python 2.3 only; see Py23Compat packages at <http://undefined.org/python/>


======================================================================
COPYRIGHT

(C) 2006 HAS <hhas -at- users - sourceforge - net> <http://appscript.sourceforge.net>

