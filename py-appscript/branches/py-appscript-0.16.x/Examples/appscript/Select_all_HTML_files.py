#!/usr/bin/env python

from appscript import *

w = app('Finder').Finder_windows[1].target.get()
w.files[its.name_extension.isin(['htm', 'html'])].select()