# Save this script as a stay-open applet, then drop files onto it.

# (Note: the 'ae_' based event handler calling scheme is temporary.)

import osax

def ae_aevtoapp():
	osax.beep()

def ae_aevtodoc(items):
	osax.say('%i items' %len(items))
		
