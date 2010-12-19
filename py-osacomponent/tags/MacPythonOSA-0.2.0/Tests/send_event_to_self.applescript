# Demonstrates sending an event to host application.

def run():
	return ae.Application().event('coregetd', {'----':ae.app.elements('docu')}).send()