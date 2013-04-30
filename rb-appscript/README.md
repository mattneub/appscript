iTunes 10.6.3 broke appscript because Hamish's method of fetching the dictionary, using an ascr/gdte Apple event, no longer works.

*STOP READING!* iTunes 11.0.1 has fixed that bug. rb-appscript now works just fine with iTunes once again. The fix discussed in this note is no longer needed.

*START READING AGAIN!* iTunes may be fixed, but now the Finder is broken (in Mountain Lion). So you do need this note, in order to script the Finder with rb-appscript. And who knows what else Apple may break?

Fortunately there are other ways to get the dictionary that do still work. I have written a script, *sdefToRBAppscriptModule.rb*, that works around the problem by using a different way of fetching the dictionary, namely by calling the `sdef` command-line tool.

Here's how to use it:

    require 'appscript'
    require 'sdefToRBAppscriptModule.rb' # I have it installed my Ruby library
    
    # start with path to scriptable application
    # f = "/Applications/iTunes.app"
    
    # if what you have isn't a path, use the FindApp module to get it
    f = FindApp.by_id('com.apple.finder')
    
    Finder = SDEFParser.makeModule(f)
    finder = Appscript.app("Finder", Finder)
    
    # and we're off to the races
    p finder.windows[1].name.get # or whatever

Share and enjoy. Please fork and pull-request if you improve on this script.

— Matt Neuburg

