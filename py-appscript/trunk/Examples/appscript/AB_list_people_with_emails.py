#!/usr/bin/env python

# Lists the name and email(s) of every person in Address Book
# with one or more email addresses.

from appscript import *

peopleRef = app('Address Book').people[its.emails != []]
print zip(peopleRef.name.get(), peopleRef.emails.value.get())