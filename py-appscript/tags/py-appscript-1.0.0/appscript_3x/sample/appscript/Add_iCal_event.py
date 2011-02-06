#!/usr/bin/env python3

# Shows how to add an event to iCal

import datetime
from appscript import *

# Add event to Home calendar to run from 7pm to 9 pm today
# (note: when only time is given, appscript uses current date)

calendarname = 'Home'
start = datetime.time(19, 0, 0) # 7 pm
end = datetime.time(21, 0, 0) # 9 pm
summary = 'Watch dinner & eat teevee'

# Note to OS X 10.3 users:
# iCal 1.x doesn't support by-name reference form, so use:
# app('iCal').calendars[its.title == calendarname]... instead.

app('iCal').calendars[calendarname].events.end.make(
        new=k.event, with_properties={
                k.start_date: start, 
                k.end_date: end, 
                k.summary: summary})