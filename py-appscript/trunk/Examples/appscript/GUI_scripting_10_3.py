#!/usr/bin/env python

# OS 10.3

from appscript import *

texteditGUI = app('System Events').processes['TextEdit']

app('TextEdit').activate()

mref = texteditGUI.menu_bars[1].menus#.help()
mref['File'].menu_bar_items['File'].menu_items['New'].click()
mref['Edit'].menu_bar_items['Edit'].menu_items['Paste'].click()
mref['Window'].menu_bar_items['Window'].menu_items['Zoom Window'].click()