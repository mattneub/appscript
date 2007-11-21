#!/usr/bin/env ruby

# Add an event to Home calendar that runs from 7am to 9 am tomorrow

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require 'appscript'
include Appscript

calendar_name = 'Home'
t = Time.now + 60 * 60 * 24
start = Time.local(t.year, t.month, t.day, 7)
end_ = start + 60 * 60 * 2
summary = 'First pants, then shoes.'

app('iCal').calendars[calendar_name].events.end.make(
        :new => :event, :with_properties => {
                :start_date => start, 
                :end_date => end_, 
                :summary => summary})
