#!/usr/bin/env python

# Get the name and URL of a Safari window.

from appscript import app

def infoForBrowserWindow(idx=1):
    """Get name and URL of a Safari window. (Raises a RuntimeError
                if window doesn't exist or is empty.)
        idx : integer -- index of window (1 = front)
        Result : tuple -- a tuple of two unicode strings: (name, url)
    """
    safari = app('Safari')
    if not safari.windows[idx].exists():
        raise RuntimeError, "Window %r doesn't exist." % idx
    else:
        pageName = safari.windows[idx].name.get()
        pageURL = safari.windows[idx].document.URL.get()
    if not pageURL:
        raise RuntimeError, "Window %r is empty." % idx
    return pageName, pageURL


# test
print infoForBrowserWindow()