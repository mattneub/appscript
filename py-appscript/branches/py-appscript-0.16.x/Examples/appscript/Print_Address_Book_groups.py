#!/usr/bin/env python

from appscript import *

def compareIgnoringCase(str1, str2):
    return cmp(str1.lower(), str2.lower())


groupsRef = app('Address Book').groups
groupNames = groupsRef.name.get()
groupNames.sort(compareIgnoringCase)
peopleNames = groupsRef.people.name.get()

for i in range(len(groupNames)):
    print groupNames[i]
    if peopleNames[i]:
        peopleNames[i].sort(compareIgnoringCase)
        print '\t' + '\n\t'.join(peopleNames[i])
    else:
        print '\t<empty>'