#!/usr/bin/env python

from appscript import app

sysevents = app('System Events')

processes = sysevents.application_processes.name.get()
processes.sort(lambda x, y: cmp(x.lower(), y.lower()))
print processes