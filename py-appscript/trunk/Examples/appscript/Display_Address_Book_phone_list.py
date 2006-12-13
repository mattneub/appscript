#!/usr/bin/env python

import os
from HTMLTemplate import Template
from appscript import *
import mactypes

#######
# Template

html = '''<html>
    <head>
        <meta http-equiv="content-type" content="text/html;charset=utf-8">
        <title>Phone List</title>
    </head>
    <body>
        <table width="100%" cellpadding="4">
            <tr node="rep:row" bgcolor="#FFC">
                <td node="con:name">Foo, J</td>
                <td>
                    <span node="-rep:phone">%s (%s)</span>
                    <br node="sep:phone" />
                </td>
            </tr>
        </table>
    </body>
</html>'''

def render_template(node, people):
    node.row.repeat(render_row, people, [False])

def render_row(node, person, isEvenRow):
    if isEvenRow[0]: 
        node.atts['bgcolor'] = '#CCF'
    isEvenRow[0] = not isEvenRow[0]
    node.name.content = person[0]
    node.phone.repeat(render_phone, person[1])

def render_phone(node, tel):
    node.content = node.content % tel

template = Template(render_template, html)


#######

def write(path, txt):
    f = open(path, 'w')
    f.write(txt)
    f.close()

def listPeopleWithPhones():
    p = app('Address Book').people[its.phones != []]
    people = zip(p.last_name.get(), p.first_name.get(), 
            p.phones.label.get(), p.phones.value.get())
    result = []
    for person in people:
        last, first, locations, numbers = person
        name = ', '.join([s for s in (last, first) if s != k.MissingValue])
        result.append((name, zip(numbers, locations)))
    result.sort(lambda i, j: cmp(i[0].lower(), j[0].lower()))
    return result

page = template.render(listPeopleWithPhones())
path = os.tmpnam() + '.html'
write(path, page)
app('Safari').open(mactypes.Alias('/private' + path))