#!/usr/bin/env python

from appscript import *

tracks = app('iTunes').browser_windows[1].view.tracks
tracks.artist.set('Nat King Cole')
tracks.album.set("Let's Fall in Love")