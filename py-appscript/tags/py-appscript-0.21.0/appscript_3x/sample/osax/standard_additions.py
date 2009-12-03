#!/usr/bin/env python3

from osax import *

# create an OSAX instance for StandardAdditions
sa = OSAX()

sa.beep(2)

sa.activate() # bring current process to front so dialog box will be visible
print(sa.display_dialog('Hello World!'))
# {k.button_returned: 'OK'}

print(sa.path_to(k.scripts_folder, from_=k.local_domain))
# mactypes.Alias('/Library/Scripts')