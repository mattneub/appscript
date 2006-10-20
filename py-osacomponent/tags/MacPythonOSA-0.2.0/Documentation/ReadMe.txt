MacPythonOSA ReadMe

----------------------------------------------------------------------
IMPORTANT

This development release of the MacPythonOSA component is incomplete, untested, and contains bugs, some of which will *crash* the host application. See the IMPORTANT section below for a non-comprehensive list of current issues. 

MacPythonOSA is provided in its current form primarily as proof-of-concept and is not ready or intended for general use. Anyone interested in getting involved in its development (advice, code, etc.) will be very welcome (OSA/Python gurus especially).

Questions, criticisms, suggestions, offers of help, money, etc. to <hhas -at- users - sourceforge - net>.

Good luck!

----------------------------------------------------------------------
IMPORTANT

This component is incomplete, untested, and contains at least one buggy feature (the 'host' attribute) that will crash the host application if used. 

In its current state there's no guarantees you'll even get it to build, never mind run. (FWIW, it does OMM.)

Some OSA features are not yet fully implemented, others aren't yet implemented at all.

Dynamic importing of Python.framework is not yet implemented (it's currently linked against Python 2.3.5), so loading this component in a process that already has a Python interpreter present will probably cause it to crash. 

There is no insulation between scripts or component instances: all share the same modules (addressing this would require a major rewrite). 

There is no support for executing scripts concurrently.

Support for installing and using application-defined callbacks (active proc, etc.) is unfinished.

There is no support yet for mirroring stdout/stderr to host application's event log; console.log only for now.

The serialisation format for compiled script objects is not yet finalised, and may change in non backwards-compatible fashion.

There's no run-only option when saving compiled scripts (bytecode isn't guaranteed to be portable across Python versions).

There is no scripting terminology support for either incoming or outgoing events. Only aem API is currently supported.

Remember to select the correct OSA language in script editor before compiling Python code. Also, note that Tiger's script editor currently has a bug that prevents this.

Python.framework, appscript and other external dependencies currently not included in component builds.

Remember, applications that have already loaded an OSA component must be restarted to reload that component following modifications to component's code.

Documentation may contain errors and omissions and not be fully up-to-date.

Documentation may be incomprehensible.

Code may be incomprehensible.

Expect bugs, breakage, dodgy design and possible crashes. Use at own risk.


----------------------------------------------------------------------
EXAMPLES

def run():	return 2 + 2
# -> script editor's result pane displays '4'

(More examples in MacPythonOSA_project/Tests)

----------------------------------------------------------------------
DEPENDENCIES

- MacPython 2.3+
- appscript

----------------------------------------------------------------------
COPYRIGHT

(C) 2005 HAS