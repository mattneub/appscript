# Responds to common applet events.
#
# Note: compile this script before use, e.g:
#	osacompile -s -l PyOSA -o applet-handlers.app applet-handlers.py

def run():
	print '####### HANDLER TEST #######'
	print 'called run()'
	print '####### ############ #######'

def open(o):
	import pprint
	print '####### HANDLER TEST #######'
	print 'called open(...)'
	pprint.pprint(o)
	print '####### ############ #######'

def reopen():
	print '####### HANDLER TEST #######'
	print 'called reopen()'
	print '####### ############ #######'

def idle():
	print '####### HANDLER TEST #######'
	print 'called idle()'
	print '####### ############ #######'
	return 10

# 'quit' handler is disabled for now as PyOSA doesn't yet support delegation
#def quit():
#	parent.quit()
#	print '####### HANDLER TEST #######'
#	print 'called quit()'
#	print '####### ############ #######'
