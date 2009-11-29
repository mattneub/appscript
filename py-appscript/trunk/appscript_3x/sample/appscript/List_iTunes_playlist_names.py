#!/usr/bin/env python3

# List names of playlists in iTunes.

from appscript import *

print(app('iTunes').sources[1].user_playlists.name.get())