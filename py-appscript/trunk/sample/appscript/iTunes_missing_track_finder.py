#!/usr/bin/env python

# Cleans up iTunes' Library playlist by deleting tracks with missing files.

# Modelled on Bob Ippolito's missingTrackFinder.py script. 
#
# Note: Bob says 'Be extra careful about running this if you have MP3s over a 
# network, if the drive isn't mounted it may report these tracks as missing!'


from appscript import *


# Notes: 
#
# The following line should delete all iTunes file tracks whose file is missing:
#
#	app('iTunes').sources['Library'].library_playlists['Library'] \
#        .file_tracks[its.location == k.missing_value].delete()
#
# Alas; iTunes' scripting support is a bit limited, so we have to do it 
# the slow and tedious way instead:

for track in app('iTunes').sources['Library'] \
            .library_playlists['Library'].file_tracks.get():
    if track.location.get() == k.missing_value:
        track.delete()


# Footnote: To get better efficiency, get lists of all file tracks and all file 
# track locations up-front and work on these.This'll significantly reduce the
# number of Apple events that the script sends (a common performance 
# bottleneck).
#
#	tracksref = app('iTunes').sources['Library'] \
#           .library_playlists['Library'].file_tracks
#	tracks = tracksref.get()
#	locs = tracksref.location.get()
#	for i in range(len(tracks)):
#		if locs[i] == k.missing_value:
#			tracks[i].delete()