# Demonstrates sending an event to another application.

finder = ae.Application(ae.findapp.byname('Finder'))

def run():
	return finder.event('coregetd', {'----':ae.app.property('home').elements('cobj')}).send()