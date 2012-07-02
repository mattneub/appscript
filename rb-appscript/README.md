iTunes 10.6.3 broke appscript because Hamish's method of fetching the dictionary, using an ascr/gdte Apple event, no longer works. This is an unnecessary limitation, as there are other ways to get the dictionary that do still work. I have written a script, sdefToRBAppscriptModule, that works around the problem by using a different way of fetching the dictionary, namely by calling the `sdef` command-line tool.

Here's how to use it:

	# require appscript (must be at least version 0.6.1)
	# require this file -- we will error out if appscript has not been required
	
	# start with path to scriptable application
	
	f = "/Applications/iTunes.app"
	
	# if what you have isn't a path, use the FindApp module to get it
	# e.g.: f = FindApp.by_id('com.apple.itunes')
	
	Tunes = SDEFParser.makeModule(f)
	itu = Appscript.app("iTunes", Tunes)
	
	# and we're off to the races
	p itu.selection.get # or whatever

Share and enjoy. Please fork and pull-request if you improve on this script.

— Matt Neuburg

