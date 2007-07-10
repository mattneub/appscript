#!/usr/bin/env ruby

# Exports phone numbers from Address Book.

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "osax"
include Appscript, OSAX

# create Application object for Address Book
AB = app("Address Book")

# prompt user for name of Address Book group to export from
DefaultChoice = ["<All>"]

groups = DefaultChoice + AB.groups.name.get
choice = osax.choose_from_list(groups, :default_items => DefaultChoice)
if choice == false # user cancelled
	exit
elsif choice == DefaultChoice
	ref = AB
else
	ref = AB.groups[choice[0]]
end

# build a reference identifying those people with one or more phone numbers
p = ref.people[its.phones.ne([])]

# get first and last names for those people, replacing any :missing_value
# entries with empty strings
last_names = p.last_name.get.collect { |val| val.is_a?(String) ? val : "" }
first_names = p.first_name.get.collect { |val| val.is_a?(String) ? val : "" }

# get lists of phone numbers and locations for those people
locations = p.phones.label.get
numbers = p.phones.value.get

# build an array containing each person's details:
# [[last name, first name, locations, numbers], ...]
people = last_names.zip(first_names, locations, numbers)

# sort array by last and first name
people.sort! do |a, b|
	a[0,2].collect { |s| s.downcase } <=> b[0,2].collect { |s| s.downcase }
end

# print table
puts " #{'_' * 70} "
people.each do |last_name, first_name, locations, numbers|
	name = [last_name, first_name].delete_if { |s| s == "" }.join(', ')
	puts "|#{' ' * 70}|"
	# print each phone number in turn
	numbers.zip(locations).each do |number, location|
		puts "| #{name.ljust(32)} #{number.ljust(20)} (#{(location + ')').ljust(13)} |"
		name = ""
	end
	puts "|#{'_' * 70}|"
end