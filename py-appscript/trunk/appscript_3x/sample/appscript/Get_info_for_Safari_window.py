#!/usr/bin/env python3

# Get the name and URL of a Safari window.

from appscript import app

def infoforbrowserwindow(idx=1):
    """Get name and URL of a Safari window. (Raises a RuntimeError
                if window doesn't exist or is empty.)
        idx : integer -- index of window (1 = front)
        Result : tuple -- a tuple of two unicode strings: (name, url)
    """
    safari = app('Safari')
    if not safari.windows[idx].exists():
        raise RuntimeError("Window %r doesn't exist." % idx)
    else:
        pagename = safari.windows[idx].name.get()
        pageurl = safari.windows[idx].document.URL.get()
    if not pageurl:
        raise RuntimeError("Window %r is empty." % idx)
    return pagename, pageurl


# test
print(infoforbrowserwindow())