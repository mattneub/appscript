#!/usr/bin/env python

import datetime
from appscript import *

# Add event to Home calendar to run from 7pm to 9 pm today
# (note: when only time is given, appscript uses current date)

calendarName = 'Home'
start = datetime.time(19, 0, 0) # 7 pm
end = datetime.time(21, 0, 0) # 9 pm
summary = 'First pants, then shoes.'

app('iCal').calendars[its.title == calendarName].events.end.make(
        new=k.event, with_properties={
                k.start_date: start, 
                k.end_date: end, 
                k.summary: summary})
