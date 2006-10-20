#!/usr/bin/env python

from appscript import *

print app('iTunes').sources[1].user_playlists.name.get()