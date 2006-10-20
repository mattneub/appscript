#!/usr/bin/env ruby

# Prints the sub-folder hierarchy of a given folder as a list of folder names indented according to depth.

require "appscript"

def printFolderTree(folder, indent='')
    puts indent + folder.name.get
    folder.folders.get.each { |folder| printFolderTree(folder, indent + "\t") }
end

printFolderTree(AS.app('Finder').home.folders['Documents'])