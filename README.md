This is Hamish Sanderson's appscript, imported from sourceforge (svn) to github (git).

Original source: <http://sourceforge.net/projects/appscript>

Hamish has made it very clear that he isn't willing to touch this code any further. So it seems obligatory that someone else should put it in a place and form where people can fork it and continue to maintain it. Here it is, then. Please fork and let's carry on. 

### GROUND OF BEING

This is open source. That means if you think there's a problem, and you care about it, you figure out Hamish's code and fix it. Keeping appscript alive is not *my* responsibility, it's *everyone's* responsibility. I didn't write it. I'm not its keeper. All I did was move it over from sourceforge to a good place. Less whining and more coding, please. Thank you.

### NOTE

I am interested personally in rb-appscript. Python users and Objective-C users, you should fork and solve issues as they arise. I have no knowledge of Python and no way to test, so I don't want to take responsibility for changes in the Python code.

### ISSUES

rb-appscript broke against iTunes, and later against the Finder. There's no reason in the world, however, why appscript should stop working just because Hamish insists on using `'ascr/gdte'` as a way of fetching an application's dictionary. There are many other ways to fetch the dictionary that work perfectly well with appscript. Please see the rbappscript folder for my solution (for rb-appscript). It should not be difficult for a Python person to imitate this in Python if desired.

Another problem that has come to my attention is that there may be something wrong with the rb-appscript gemspec, such that it doesn't install properly. I don't know anything about gemspecs, and no one has suggested a fix. However, there's an easy workaround: install manually, like this:

    $ cd /path/to/trunk
    $ ruby extconf.rb
    $ make
    $ make install

That installs into the Ruby library, and I actually like that better than using rb-appscript as a gem anyway.

— Matt Neuburg

