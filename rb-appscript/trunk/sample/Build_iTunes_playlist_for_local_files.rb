#!/usr/local/bin/ruby

# Creates a new playlist named 'my local tracks' if one doesn't already exist, 
# then adds all tracks whose files are stored on a specified volume (or
# volumes).
#
# Very handy if you keep some of your music files on a portable and the rest on
# an external file server. Any time you're on the move and don't have a network
# connection,just set iTunes to play tracks from the 'my local tracks' playlist
# only to avoid 'broken track' problems.
#
# Note that this script may take a while to build the new playlist from scratch
# it's run if there are thousands of local tracks to process. Once the initial 
# playlist is built, smaller updates will happen much more quickly as the
# script is designed to be as efficient as possible (i.e. sends the fewest
# number of Apple events needed to do the job ) when checking for unprocessed
# tracks.

require 'appscript'

# The name of the playlist in which to keep local tracks:
localPlaylistName = 'my local tracks' 

# The RE for matching the paths you want (e.g. those on the startup volume):
pathRE = /^\/Volumes\// 

itunes = AS.app('iTunes')
allTracks = itunes.library_playlists[1].tracks
localPlaylist = itunes.playlists[localPlaylistName]

if not localPlaylist.exists
    itunes.make(:new=>:playlist, :with_properties=>{:name=>localPlaylistName})
end

existingTrackPIDs = localPlaylist.count(:each => :track) > 0 ? \
        localPlaylist.tracks.persistent_ID.get : []
allTracks.location.get.zip(
        allTracks.persistent_ID.get, allTracks.id_.get).each do |f, dbid, id| 
    if f != :MissingValue and not (
            pathRE === f.to_s or existingTrackPIDs.include?(dbid))
        allTracks.ID(id).duplicate(:to => localPlaylist)
    end 
end
