# Demonstrates persistent data storage within compiled scripts.

# Save as an applet. Each time applet is run, the count increases by 1.

# osastore provides a persistent, serialisable data store that will be retained when a script is saved in compiled form (.scpt or .app), and restored once the script is loaded from file.

osastore(
	x = 0 # initial state; will be set when script is compiled
)

import osax

def ae_aevtoapp(*args):
	osastore.x += 1
	osax.say('%i items' % osastore.x)
