#!/usr/bin/env python

# OS 10.4

from appscript import *

texteditGUI = app('System Events').processes['TextEdit']

app('TextEdit').activate()

mref = texteditGUI.menu_bars[1].menus
mref['File'].menu_items['New'].click()
mref['Edit'].menu_items['Paste'].click()
mref['Window'].menu_items['Zoom Window'].click()