#!/usr/bin/env ruby

# Exports all Address Book entries as vcards to current working folder.
# Files are named as 'FIRSTNAME LASTNAME.vcard'; any missing
# names are replaced with '???'.
#
# (Note: if two people have identical names, the first vcard file will be
# overwritten by the second. The script could be modified to handle
# this condition if necessary.)


# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require 'appscript'
include Appscript

people = app('Address Book').people

people.first_name.get.zip(people.last_name.get, people.vcard.get).each do |first, last, vcard|
	first = '???' if first == :missing_value
	last = '???' if last == :missing_value
	File.open("#{first} #{last}.vcard".gsub('/', ':'), 'w') { |f| f.puts vcard }
end