#!/usr/bin/env ruby

# Creates daily recurring todo items in iCal.
#
# Ported from 'Create daily todos.scpt' by Alexander Kellett 
# <http://web.mac.com/lypanov>
#
# While iCal makes it easy to create recurring events, it lacks a similar
# feature for To Do items. This script can be used to create a daily checklist
# of things to do.
#
# To begin, create a new calendar with the name "Shadow". Then, add a number
# of recurring events to this calendar. All Daily To Dos events must be 
# recurring events as only recurring events are converted to To Dos. Start and
# end dates are ignored.
#
# Now, create a calendar called "Personal". When the script is run, all the
# To Do items will be added to this calendar. Finally, set up a cron job to
# run this script first thing every morning.
#
# See also:
# <http://web.mac.com/lypanov/iWeb/Web/Diary/1EDF1B30-C4AF-4A99-BC4D-
#  4A8AF14BFC96.html>
# <http://web.mac.com/lypanov/iWeb/Web/Diary/9950DF91-726E-42B2-A639-
#  1967D1DE7545.html>

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

ICal = app("iCal")

# The calendar in which recurring todo items should appear:
ToDoCalendarName = "Personal"
    
def create_to_do(summary_text)
    # Adds To Dos to calendar "Personal"
    now = Time.new
    midnight = Time.local(now.year(), now.month(), now.day())
    to_dos = ICal.calendars[ToDoCalendarName].todos
    # don't create an item if it already exists for today!
    if to_dos[its.due_date.ge(midnight).and(
            its.summary.eq(summary_text))].count < 1
        to_dos.end.make(:new=>:todo, :with_properties=>{
                :due_date=>midnight, :summary=>summary_text})
    end
end

def get_label(recurrence, label)
    match = Regexp.new("(?:^|;)#{label}=(.*?)(?:$|;)").match(recurrence)
    return match ? match[1] : nil
end

weekday_code = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"][Time.new.wday]
events = ICal.calendars["Shadow"].events

events.recurrence.get.zip(events.summary.get).each do |recurrence, summary|
    recurs_on_this_weekday = false
    frequency = get_label(recurrence, "FREQ")
    case frequency
        when "WEEKLY"
            days = get_label(recurrence, "BYDAY")
            if days and days.split(",").include?(weekday_code)
                recurs_on_this_weekday = true
            end
        when "DAILY"
            recurs_on_this_weekday = true
    end
    if recurs_on_this_weekday
        puts summary
        create_to_do(summary)
    end
end
