#!/usr/bin/env python

from appscript import *

calendarName = 'US Holidays'

ev = app('iCal').calendars[its.title == calendarName].events
events = zip(ev.start_date.get(), ev.end_date.get(), 
        ev.summary.get(), ev.description.get())

# Print tab-delimited table:
print 'STARTS\tENDS\tSUMMARY\tDESCRIPTION'
for event in events:
    print '\t'.join([item == k.MissingValue and '--' or 
            str(item).replace('\t', ' ').replace('\n', '') for item in event])