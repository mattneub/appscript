#!/usr/bin/env pythonw

# Generates an HTML file listing all tracks in the current iTunes playlist.
#
# Requires HTMLTemplate <http://pypi.python.org/pypi/HTMLTemplate>

from HTMLTemplate import Template
from appscript import *
from osax import *


#######
# HTML template

html = """<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <title node="con:title">Untitled Playlist</title>
    </head>
    <body>
        <h1 node="con:title2">Untitled Playlist</h1>
        <table width="100%" border="4" cellspacing="0" cellpadding="4">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Title</th>
                    <th>Artist</th>
                    <th>Album</th>
                    <th>Time</th>
                </tr>
            </thead>
            <tbody>
                <tr node="rep:track">
                    <td node="con:idx">1</td>
                    <td node="con:title">album name</td>
                    <td node="con:artist">artist</td>
                    <td node="con:album">album</td>
                    <td node="con:time">0:00</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="4">Total playing time</td>
                    <td node="con:totaltime">1:00</td>
                </tr>
            </tfoot>
        </table>
    </body>
</html>"""

def render_template(node, playlist):
    node.title.content = node.title2.content = playlist.name.get() + ' playlist'
    node.totaltime.content = playlist.time.get()
    ref = playlist.tracks
    node.track.repeat(render_track, range(0, playlist.count(each=k.track)), 
            ref.name.get(), ref.artist.get(), ref.album.get(), ref.time.get())

def render_track(node, i, names, artists, albums, times):
    node.idx.content = str(i + 1)
    node.title.content = names[i] or '-'
    node.artist.content = artists[i] or '-'
    node.album.content = albums[i] or '-'
    time = times[i]
    if time == k.missing_value: 
    	time = '-:--'
    node.time.content = time


#######
# Support

def encodenonascii(txt):
    """Convert non-ASCII characters to HTML entities"""
    res = []
    for char in txt:
        if ord(char) < 128:
            res.append(char)
        else:
            res.append('&#%i;' % ord(char))
    return ''.join(res)

def write(path, txt):
    f = open(path, 'w')
    f.write(txt)
    f.close()
    

#######
# Main

# Prompt user to specify HTML file to save to:
sa = OSAX()
sa.activate()
outfile = sa.choose_file_name(default_name='iTunes_albums.html')

# Render current playlist to HTML file:
template = Template(render_template, html)
playlist = app('iTunes').browser_windows[1].view.get()
page = template.render(playlist)
write(outfile.path, encodenonascii(page))

# Preview HTML file in user's default browser:
sa.open_location(outfile.url)