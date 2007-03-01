# Responds to common applet events. (Messages will be printed to Console.)
#
# Note: compile this script before use, e.g:
#	osacompile -s -l PyOSA -o applet-handlers.app applet-handlers.py

def run():
	# called when applet icon is double-clicked in Finder
	print '\n####### HANDLER TEST #######'
	print 'called run()'
	print '####### ############ #######\n'

def open(aliaslist):
	# called when one or more files are dropped on applet icon
	import pprint
	print '\n####### HANDLER TEST #######'
	print 'called open(...)'
	pprint.pprint(aliaslist)
	print '####### ############ #######\n'

def reopen():
	# called when running applet icon is clicked in Dock
	print '\n####### HANDLER TEST #######'
	print 'called reopen()'
	print '####### ############ #######\n'

def idle():
	# called periodically while applet is running
	print '\n####### HANDLER TEST #######'
	print 'called idle()'
	print '####### ############ #######\n'
	return 10

def quit():
	# called when application is quitting (e.g. Cmd-Q)
	print '\n####### HANDLER TEST #######'
	print 'called quit()'
	print '####### ############ #######\n'
	# important: if intercepting the quit event, make sure to
	# 'continue' it, otherwise the applet will never quit:
	parent.quit() 
