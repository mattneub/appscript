#!/usr/bin/env ruby

# Prints the sub-folder hierarchy of a given folder as a list of folder names indented according to depth.

# Note: if using the appscript gem, rubygems must be required first:
begin; require 'rubygems'; rescue LoadError; end

require "appscript"
include Appscript

def print_folder_tree(folder, indent='')
    puts indent + folder.name.get
    folder.folders.get.each { |folder| print_folder_tree(folder, indent + "\t") }
end

print_folder_tree(app('Finder').home.folders['Documents'])