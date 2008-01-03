
#
# pyosa_eventhandlerdefinitions.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
# Hardcoded event handler definitions
# (taken from StandardAdditions.osax, Digital Hub Scripting.osax)
# (uses same format as command definitions in appscript.terminology)
#


# TO DO: It'd be more robust to look up osax dictionaries for additional event handler definitions rather than hardcoding them here. OTOH, it'd also be slower; though perhaps not significantly so if objc-appscript's aete parser was used.


kCommand = 'c'

# TO DO: any other osax-defined event handlers that should be listed here?

kBuiltInEventHandlerDefs = {
		# idle
		'idle': (kCommand, ('miscidle', {})),
		# Folder Actions
		'opening_folder': (kCommand, ('facofopn', {})),
		'closing_folder_window_for': (kCommand, ('facofclo', {})),
		'moving_folder_window_for': (kCommand, ('facofsiz', {'from': 'fnsz'})),
		'adding_folder_items_to': (kCommand, ('facofget', {'after_receiving': 'flst'})),
		'removing_folder_items_from': (kCommand, ('facoflos', {'after_losing': 'flst'})),
		# Digital Hub Scripting
		'music_CD_appeared': (kCommand, ('dhubaucd', {})),
		'picture_CD_appeared': (kCommand, ('dhubpicd', {})),
		'video_DVD_appeared': (kCommand, ('dhubvdvd', {})),
		'blank_CD_appeared': (kCommand, ('dhubbcd ', {})),
		'blank_DVD_appeared': (kCommand, ('dhubbdvd', {})),
		}

