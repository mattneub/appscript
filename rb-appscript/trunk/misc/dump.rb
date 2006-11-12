#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "ae"
require "aem"
require "findapp"
require "_appscript/terminology"

if ARGV.length != 3
	puts "dump.rb

Outputs an application's terminology as a Ruby module file, suitable for use by AS::Application.

Usage:

	ruby  dump.rb  application-name-or-path  module-name  module-path

Example:

	ruby  dump.rb  Address\ Book  AddressBook  ~/addressbook_terms.rb"
	
	exit
end

appPath = FindApp.byname(ARGV[0])
moduleName = ARGV[1]
outPath = ARGV[2]

if not /^[A-Z][A-Za-z0-9_]*$/ === moduleName
	raise RuntimeError, "Invalid module name."
end

File.open(outPath, "w") do |f|
	# Get aete(s)
	begin
		aetes = AEM::Codecs.new.unpack(AE.getAppTerminology(appPath).coerce(KAE::TypeAEList))
	rescue AE::MacOSError => e
		if  e.to_i == -192 # aete resource not found
			raise RuntimeError, "No terminology found."
		else
			raise
		end
	end
	
	# Parse aete(s) into intermediate tables, suitable for use by Terminology#tablesForModule
	tables = TerminologyParser.buildTablesForAetes(aetes)
	
	# Write module code
	f.puts "module #{moduleName}"
	f.puts "\tVersion = 1.1"
	f.puts "\tPath = #{appPath.inspect}"
	f.puts
	(["Classes", "Enumerators", "Properties", "Elements"].zip(tables[0,4])).each do |name, table|
		f.puts "\t#{name} = ["
		table.sort.each do |item|
			f.puts "\t\t#{item.inspect},"
		end
		f.puts "\t]"
		f.puts
	end
	f.puts "\tCommands = ["
	tables[4].sort.each do |name, code, params|
		f.puts "\t\t[#{name.inspect}, #{code.inspect}, ["
			params.each do |item|
				f.puts "\t\t\t#{item.inspect},"
			end
		f.puts "\t\t]],"
	end
	f.puts "\t]"
	f.puts "end"
end
