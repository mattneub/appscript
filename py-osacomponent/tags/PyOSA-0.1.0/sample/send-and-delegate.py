# send-to-self and delegate tests
#
# - app().name.get() sends an event to the hose, i.e. current, application;
#	events are sent via InvokeOSASendUPP
#
# - parent.name.get() sends an event to the script's parent 
#	(for now this is the host application); 
#	events are sent via AEResumeDispatch

def run():
	return app().name.get(), parent.name.get()