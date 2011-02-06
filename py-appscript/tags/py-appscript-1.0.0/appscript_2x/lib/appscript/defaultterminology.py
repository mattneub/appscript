"""defaultterminology -- translation tables between appscript-style typenames and corresponding AE codes """

types = [
		# Human-readable names for commonly used AE types.
		# Most of these names are equivalent to AS names, though
		# a few are adjusted to be more 'programmer friendly', 
		# e.g. 'float' instead of 'real', and a few have no AS equivalent,
		# e.g. 'utf8_text'
		('anything', '****'),
		
		('boolean', 'bool'),
		
		('short_integer', 'shor'),
		('integer', 'long'),
		('unsigned_integer', 'magn'),
		('double_integer', 'comp'),
		
		('fixed', 'fixd'),
		('long_fixed', 'lfxd'),
		('decimal_struct', 'decm'),
		
		('short_float', 'sing'),
		('float', 'doub'),
		('extended_float', 'exte'),
		('float_128bit', 'ldbl'),
		
		('string', 'TEXT'),
		('styled_text', 'STXT'),
		('text_style_info', 'tsty'),
		('styled_clipboard_text', 'styl'),
		('encoded_string', 'encs'),
		('writing_code', 'psct'),
		('international_writing_code', 'intl'),
		('international_text', 'itxt'),
		('unicode_text', 'utxt'),
  		('utf8_text', 'utf8'), # typeUTF8Text
		('utf16_text', 'ut16'), # typeUTF16ExternalRepresentation
		
		('version', 'vers'),
		('date', 'ldt '),
		('list', 'list'),
		('record', 'reco'),
		('data', 'tdta'),
		('script', 'scpt'),
		
		('location_reference', 'insl'),
		('reference', 'obj '),
		
		('alias', 'alis'),
		('file_ref', 'fsrf'),
		('file_specification', 'fss '),
		('file_url', 'furl'),
		
		('point', 'QDpt'),
		('bounding_rectangle', 'qdrt'),
		('fixed_point', 'fpnt'),
		('fixed_rectangle', 'frct'),
		('long_point', 'lpnt'),
		('long_rectangle', 'lrct'),
		('long_fixed_point', 'lfpt'),
		('long_fixed_rectangle', 'lfrc'),
		
		('EPS_picture', 'EPS '),
		('GIF_picture', 'GIFf'),
		('JPEG_picture', 'JPEG'),
		('PICT_picture', 'PICT'),
		('TIFF_picture', 'TIFF'),
		('RGB_color', 'cRGB'),
		('RGB16_color', 'tr16'),
		('RGB96_color', 'tr96'),
		('graphic_text', 'cgtx'),
		('color_table', 'clrt'),
		('pixel_map_record', 'tpmm'),
		
		('best', 'best'),
		('type_class', 'type'),
		('enumerator', 'enum'),
		('property', 'prop'),
		
		# AEAddressDesc types
		
		('mach_port', 'port'),
		('kernel_process_id', 'kpid'),
		('application_bundle_id', 'bund'),
		('process_serial_number', 'psn '),
		('application_signature', 'sign'),
		('application_url', 'aprl'),
		
		# misc.
		
		('missing_value', 'msng'),
		
		('null', 'null'),
		
		('machine_location', 'mLoc'),
		('machine', 'mach'),
		
		('dash_style', 'tdas'),
		('rotation', 'trot'),
		
		('suite_info', 'suin'),
		('class_info', 'gcli'),
		('property_info', 'pinf'),
		('element_info', 'elin'),
		('event_info', 'evin'),
		('parameter_info', 'pmin'),
		
		('item', 'cobj'), # Apple have removed the 'item' class definition from skeleton.sdef
		
		# unit types
		
		('centimeters', 'cmtr'),
		('meters', 'metr'),
		('kilometers', 'kmtr'),
		('inches', 'inch'),
		('feet', 'feet'),
		('yards', 'yard'),
		('miles', 'mile'),
		
		('square_meters', 'sqrm'),
		('square_kilometers', 'sqkm'),
		('square_feet', 'sqft'),
		('square_yards', 'sqyd'),
		('square_miles', 'sqmi'),
		
		('cubic_centimeters', 'ccmt'),
		('cubic_meters', 'cmet'),
		('cubic_inches', 'cuin'),
		('cubic_feet', 'cfet'),
		('cubic_yards', 'cyrd'),
		
		('liters', 'litr'),
		('quarts', 'qrts'),
		('gallons', 'galn'),
		
		('grams', 'gram'),
		('kilograms', 'kgrm'),
		('ounces', 'ozs '),
		('pounds', 'lbs '),
		
		('degrees_Celsius', 'degc'),
		('degrees_Fahrenheit', 'degf'),
		('degrees_Kelvin', 'degk'),
		
		# month and weekday
		
		('January', 'jan '),
		('February', 'feb '),
		('March', 'mar '),
		('April', 'apr '),
		('May', 'may '),
		('June', 'jun '),
		('July', 'jul '),
		('August', 'aug '),
		('September', 'sep '),
		('October', 'oct '),
		('November', 'nov '),
		('December', 'dec '),
		
		('Sunday', 'sun '),
		('Monday', 'mon '),
		('Tuesday', 'tue '),
		('Wednesday', 'wed '),
		('Thursday', 'thu '),
		('Friday', 'fri '),
		('Saturday', 'sat '),
]


pseudotypes = [ # non-concrete types that are only used for documentation purposes; use to remap typesbycode
		('file', 'file'), # typically FileURL, but could be other file types as well
		('number', 'nmbr'), # any numerical type: Integer, Float, Long
		# ('text', 'ctxt'), # Word X, Excel X uses 'ctxt' instead of 'TEXT' or 'utxt' (TO CHECK: is this Excel's stupidity, or is it acceptable?)
]


properties = [
		('class_', 'pcls'), # used as a key in AERecord structures that have a custom class; also, Apple have removed the 'item' class definition from skeleton.sdef
		('properties', 'pALL'), # Apple have removed the 'item' class definition from skeleton.sdef
		('id', 'ID  '), # some apps (e.g. iTunes) may omit 'id' property from terminology despite using it
]


elements = [
		('items', 'cobj'), # Apple have removed the 'item' class definition from skeleton.sdef
]


enumerations = [
		('savo', [
				('yes', 'yes '), 
				('no', 'no  '), 
				('ask', 'ask '),
		]),
		# constants used in commands' 'ignore' argument (note: most apps currently ignore these):
		('cons', [
			('case', 'case'),
			('diacriticals', 'diac'),
			('expansion', 'expa'),
			('punctuation', 'punc'),
			('hyphens', 'hyph'),
			('whitespace', 'whit'),
			('numeric_strings', 'nume'),
			('application_responses', 'rmte'),
		]),
]


commands = [
	# required suite
	('run', 'aevtoapp', []),
	('open', 'aevtodoc', []),
	('print_', 'aevtpdoc', []),
	('quit', 'aevtquit', [('saving', 'savo')]),
	# 'reopen' and 'activate' aren't listed in required suite, but should be
	('reopen', 'aevtrapp', []),
	('activate', 'miscactv', []),
	# 'launch' is a special case not listed in the required suite and implementation is provided by
	# the Apple event bridge (not the target applications), which uses the Process Manager/
	# LaunchServices to launch an application without sending it the usual run/open event.
	('launch', 'ascrnoop', []),
	# 'get' and 'set' commands are often omitted from applications' core suites, even when used
	('get', 'coregetd', []),
	('set', 'coresetd', [('to', 'data')]),
	# some apps (e.g. Safari) which support GetURL events may omit it from their terminology; 
	# 'open location' is the name Standard Additions defines for this event, so use it here
	('open_location', 'GURLGURL', [('window', 'WIND')]), 
]


