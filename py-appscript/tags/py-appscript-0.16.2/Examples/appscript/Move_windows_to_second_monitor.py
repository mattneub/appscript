#!/usr/bin/env python

# TO DECIDE: how best to deal with menu bars? (add 22px to top of display, and 
# some apps, e.g. Finder, are stupid and window title bars will underlap menu 
# bar if top bounds is set to less than this)

# TO DECIDE: how best to deal with windows larger than the monitor they're 
# moving to? (scale proportionally or keep current size? both approaches have 
# problems)

# TO DECIDE: how to allow behavior to be customised for individual apps? e.g. 
# Finder gets menu bar height wrong (44px) and script should be able to 
# compensate for this to prevent windows underlapping menu bar

# TO DO: find out if MacPython can get monitor info from OS instead of having 
# user hardcode it

from appscript import *

#######

_skipApps = [
        'TabletDriver.app',
        'Internet Explorer.app',
        'Eudora.app',
        'Smile.app',
        'System Events.app',
        'Python.app'] # list any scriptable apps to ignore 
# (Note: ALWAYS skip Python.app to avoid deadlocking)



class Display:
    """Represents a monitor display."""
    
    def __init__(self, position, resolution):
        """
            position : tuple -- monitor's absolute position: (left, top)
            resolution : tuple -- monitor's resolution: (width, height)
        
            Note: remember to include menu bar height when calculating top
        """
        self.x, self.y = position
        self.w, self.h = resolution
        self.bounds = (self.x, self.y, self.x + self.w - 1, self.y + self.h - 1)
    
    def contains(self, bounds):
        ax1, ay1 = bounds[:2]
        bx1, by1, bx2, by2 = self.bounds
        return (bx1 <= ax1 <= bx2) and (by1 <= ay1 <= by2)



def moveWindows(d1, d2, windows):
    """Move windows from first display to second.
        d1 : Display -- first display
        d2 : Display -- second display
        windows : reference -- a reference to application's window objects
    """
    for window, (x1, y1, x2, y2) in zip(windows.get(), windows.bounds.get()):
        if d1.contains((x1, y1, x2, y2)):
            newX = int((x1 - d1.x) * (float(d2.w) / d1.w) + d2.x)
            newY = int((y1 - d1.y) * (float(d2.h) / d1.h) + d2.y)
            window.bounds.set((newX, newY, newX + x2 - x1, newY + y2 - y1))


#######
# Main

# YOUR VALUES HERE:
display1 = Display((0, 22), (1280, 854)) # monitor 1 position and resolution
display2 = Display((1280, 0), (800, 600)) # monitor 2 position and resolution


def moveAll(fromDisplay, toDisplay):
    for path in [path for path in app('System Events').processes.file.get() 
            if path != k.MissingValue and not path.split('/')[-1] in _skipApps]:
        try:
            application = app(path)
            if application.isscriptable:
                moveWindows(fromDisplay, toDisplay, application.windows)
        except Exception, e:
            print "Can't move windows for app(%r):\n\t%r" % (path, e)


#######
# Test

if __name__ = '__main__':
    moveAll(display1, display2) # Move windows from first to second screen...
    moveAll(display2, display1) # ...then move them back again.