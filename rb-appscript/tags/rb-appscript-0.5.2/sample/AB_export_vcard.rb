#!/usr/bin/env ruby

# Exports all Address Book entries as vcards to current working folder.
#
# Files are named as 'NAME.vcard' (note: existing files will be overwritten).
# If the name is missing, 'unknown' is used instead. If two or more people
# share the same name, files will be named 'NAME.vcard', 'NAME 1.vcard',
# 'NAME 2.vcard', etc.


# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require 'appscript'
include Appscript

people = app('Address Book').people

found_names = []
people.name.get.zip(people.vcard.get).each do |name, vcard|
	name = 'unknown' if name == ''
	name = name.gsub('/', ':')
	filename = "#{name}.vcard"
	i = 1
	while found_names.include?(filename.downcase)
		filename = "#{name} #{i}.vcard"
		i += 1
	end
	found_names.push(filename.downcase)
	File.open(filename, 'w') { |f| f.puts vcard }
end