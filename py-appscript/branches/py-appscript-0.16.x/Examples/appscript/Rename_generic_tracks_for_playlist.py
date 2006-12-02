#!/usr/bin/env python

from appscript import *

playlistName = 'Foo' # YOUR PLAYLIST NAME HERE
newTrackNamePrefix = 'foo' # YOUR NEW TRACK NAME PREFIX

for track in app('iTunes').sources['Library'].playlists[playlistName].tracks.get():
    track.name.set(track.name.get().replace('Track', newTrackNamePrefix))