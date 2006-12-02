#!/usr/bin/env python

# A simple script to post a playlist from iTunes on to a metaweblog API enabled blog.

from xmlrpclib import Server
from appscript import *

# The URL for the XML-RPC interface to the blog
blogURL = "http://www.yourserver.org/cgi-bin/mt-xmlrpc.cgi"

# The id of the blog to post to
blogID = "2"

# Username/password that has permission to post to the blog
blogUsername = ""
blogPassword = ""

# Info for this post
postTitle = "Top 25 Most Played Songs for the Week"
playlistName = "Top 25 This Month"

# Get the content of  playlist from iTunes.
playlist = app('iTunes').sources['Library'].user_playlists[playlistName]
if not playlist.exists():
    raise RuntimeError, "Can't find a playlist named %r." % playlistName
tracks = playlist.tracks
songs = zip(tracks.artist.get(), tracks.name.get(),
        tracks.album.get(), tracks.played_count.get())

# Munge the list into the format for posting
def format(s):
    return str(s).replace('&', '&amp;').replace('<', '&lt;') \
            .replace('>', '&gt;').replace('"', '&quot;') or '&nbsp;'

resultHTML = '''<table>
<tr><th>Artist</th><th>Song</th><th>Album</th><th>Play Count</th></tr>
%s
</table>''' % '\n'.join([
        '<tr>%s</tr>' % ''.join(['<td>%s</td>' % format(s) for s in song])
        for song in songs])

# Post to the blog using the MetaWeblog API
content = {'title': postTitle, 'description': resultHTML}

Server(blogURL).metaWeblog.newPost(
        blogID, blogUsername, blogPassword, content, 1)