#!/usr/bin/env python

from appscript import *

peopleRef = app('Address Book').people[its.emails != []]
print zip(peopleRef.name.get(), peopleRef.emails.value.get())