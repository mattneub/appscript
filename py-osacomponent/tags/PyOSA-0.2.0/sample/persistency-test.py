# Note: compile this script as an applet before use, e.g:
#	osacompile -l PyOSA -o persistency-test.app persistency-test.py

# 'state' is a top-level PyOSA variable containing a PersistentState instance.
# To set initial state at runtime, call the state object as shown here:

import osax

state( 
	count = 0,
)

# This state can now be accessed and/or modified from elsewhere in
# the script, with any changes being retained when the script is stored. 

def run():
	state.count += 1
	osax.ScriptingAddition().display_alert('count = %i' % state.count)
	