# Prints out parameters passed by Mail's 'Run AppleScript' rule action.
#
# Note: compile this script before use, e.g:
#	osacompile -l PyOSA -o mail-rule.scpt mail-rule.py

from pprint import pprint

def perform_mail_action_with_messages(messages, in_mailboxes, for_rule):
	print '='*80
	print 'MAIL ACTION'
	print '\nmessages:'
	pprint(messages)
	print '\nin_mailboxes:'
	pprint(in_mailboxes)
	print '\nfor_rule:'
	pprint(for_rule)
	print '='*80
