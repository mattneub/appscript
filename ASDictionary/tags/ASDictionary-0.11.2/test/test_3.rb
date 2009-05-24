#!/usr/local/bin/ruby

require 'appscript'; include Appscript
require 'pp'

app('Finder').home.folders[con.folders[1], con.folders['Movies']].get


pp app('Finder').desktop.items.name.help('-s').get

