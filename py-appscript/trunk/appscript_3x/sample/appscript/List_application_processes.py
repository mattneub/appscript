#!/usr/local/bin/python3.0

# Uses System Events to list all running applications.

from appscript import app

sysevents = app('System Events')

processnames = sysevents.application_processes.name.get()
processnames.sort(key=(lambda x: x.lower()))
print('\n'.join(processnames))