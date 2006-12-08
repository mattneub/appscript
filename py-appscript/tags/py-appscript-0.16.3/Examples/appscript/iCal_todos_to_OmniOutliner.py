#!/usr/bin/env python

from appscript import *

topRow = app('OmniOutliner').documents.end.make(new=k.document).rows[1]
topRow.properties.set({k.topic: 'Master todo list', k.expanded: True})

for cal in app('iCal').calendars.get():
    subRow = topRow.rows.end.make(new=k.row, 
            with_properties={k.topic: cal.title.get(), k.expanded: True})
    for summary in cal.todos.summary.get():
        subRow.rows.end.make(new=k.row, 
                with_properties={k.topic: summary})