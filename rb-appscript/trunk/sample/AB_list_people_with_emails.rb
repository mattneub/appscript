#!/usr/bin/env ruby

# Lists the name and email(s) of every person in Address Book with one or more email addresses.

require "appscript"

peopleRef = AS.app('Address Book').people[AS.its.emails.ne([])]
p peopleRef.name.get.zip(peopleRef.emails.value.get)