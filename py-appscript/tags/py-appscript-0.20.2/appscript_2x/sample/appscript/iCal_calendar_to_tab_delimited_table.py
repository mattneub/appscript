#!/usr/bin/env python

# Outputs an iCal calendar to tab-delimited table listing start and end times,
# summary and description for each event.

from appscript import *

calendarname = 'US Holidays'

ev = app('iCal').calendars[calendarname].events
events = zip(
        ev.start_date.get(),
        ev.end_date.get(),
        ev.summary.get(),
        ev.description.get())

# Print tab-delimited table:
print 'STARTS\tENDS\tSUMMARY\tDESCRIPTION'
for event in events:
    print '\t'.join([item == k.missing_value and '--' or 
            str(item).replace('\t', ' ').replace('\n', ' ')
            for item in event])