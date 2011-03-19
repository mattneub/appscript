#!/usr/local/bin/macruby

require 'pp'
require 'appscript'; include Appscript

itunes = app('iTunes')

t = itunes.library_playlists[1].tracks[its.kind.begins_with('MPEG')]

pp t.name.get.zip(t.artist.get, t.album.get)