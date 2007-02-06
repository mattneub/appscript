#!/usr/bin/env python

# Uses System Events to list all running applications.

from appscript import app

sysevents = app('System Events')

processnames = sysevents.application_processes.name.get()
processnames.sort(lambda x, y: cmp(x.lower(), y.lower()))
print '\n'.join(processnames)