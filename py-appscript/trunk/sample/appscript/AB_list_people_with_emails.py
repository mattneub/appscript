#!/usr/bin/env python

# Lists the name and email(s) of every person in Address Book
# with one or more email addresses.

from appscript import *

peopleref = app('Address Book').people[its.emails != []]
for name, emails in zip(peopleref.name.get(), peopleref.emails.value.get()):
	print name, emails