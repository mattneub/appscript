#!/usr/bin/env python

from HTMLTemplate import Template
from appscript import *


dest = '/Users/has/thumbs.html' # YOUR PATH HERE


#######
# HTML template

html = """<html>
    <head>
        <title>Thumbs</title>
    </head>
    <body>
        <table>
            <tr node="rep:row">
                <td node="rep:cell">
                    <img src="" node="con:img" />
                    <ul>
                        <li node="rep:info">info</li>
                    </ul>
                </td>
            </tr>
        </table>
    </body>
</html>"""

def render_template(node, photos, width=4):
    node.row.repeat(render_row, range(0, len(photos), width), photos, width)

def render_row(node, i, photos, width):
    node.cell.repeat(render_cell, range(i, min(i + width, len(photos))), photos)

def render_cell(node, i, photos):
        node.img.atts['src'] = 'file://localhost' + photos[i][k.thumbnail_path]
        node.info.repeat(render_info, [k.name, k.date, k.comment], photos[i])

def render_info(node, prop, photo):
    if photo[prop]:
        node.content = str(photo[prop])
    else:
        node.omit()


#######
# Support

def encodeNonASCII(txt):
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
# Render thumbnails page

template = Template(render_template, html)
# get the properties of every photo of current album
photos = app('iPhoto').current_album.photos.properties.get()
page = template.render(photos)
write(dest, encodeNonASCII(page))