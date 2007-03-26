# Test event log, osax, appscript support.

import osax

# PyOSA 0.1.0 bug: Creating osax.ScriptingAddition instances at the top level of a script
# will result in crashes if the script is run as an applet. If this is a problem, moving the
# offending line into an event handler should work around it for now. (In this case, move
# the following line into the 'run' function.)
sa = osax.ScriptingAddition()

def run():
	log(43)
	sa.say('hello')
	sa.display_alert(parent.name())
	return app('finder').home()