# Test event log, osax, appscript support.

import osax
sa = osax.ScriptingAddition()

def run():
	log(43)
	sa.say('hello')
	sa.display_alert(host.name())
	return app('finder').home()