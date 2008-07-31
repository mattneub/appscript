"""objcappscripttypedefs -- translation tables between objc-appscript-style typenames and corresponding AE codes

(C) 2007 HAS
"""

types = [
	('April', 'apr '),
	('August', 'aug '),
	('December', 'dec '),
	('EPSPicture', 'EPS '),
	('February', 'feb '),
	('Friday', 'fri '),
	('GIFPicture', 'GIFf'),
	('JPEGPicture', 'JPEG'),
	('January', 'jan '),
	('July', 'jul '),
	('June', 'jun '),
	('March', 'mar '),
	('May', 'may '),
	('Monday', 'mon '),
	('November', 'nov '),
	('October', 'oct '),
	('PICTPicture', 'PICT'),
	('RGB16Color', 'tr16'),
	('RGB96Color', 'tr96'),
	('RGBColor', 'cRGB'),
	('Saturday', 'sat '),
	('September', 'sep '),
	('Sunday', 'sun '),
	('TIFFPicture', 'TIFF'),
	('Thursday', 'thu '),
	('Tuesday', 'tue '),
	('Wednesday', 'wed '),
	('alias', 'alis'),
	('anything', '****'),
	('applicationBundleID', 'bund'),
	('applicationSignature', 'sign'),
	('applicationURL', 'aprl'),
	('best', 'best'),
	('boolean', 'bool'),
	('boundingRectangle', 'qdrt'),
	('centimeters', 'cmtr'),
	('classInfo', 'gcli'),
	('colorTable', 'clrt'),
	('cubicCentimeters', 'ccmt'),
	('cubicFeet', 'cfet'),
	('cubicInches', 'cuin'),
	('cubicMeters', 'cmet'),
	('cubicYards', 'cyrd'),
	('dashStyle', 'tdas'),
	('data', 'rdat'),
	('date', 'ldt '),
	('decimalStruct', 'decm'),
	('degreesCelsius', 'degc'),
	('degreesFahrenheit', 'degf'),
	('degreesKelvin', 'degk'),
	('doubleInteger', 'comp'),
	('elementInfo', 'elin'),
	('encodedString', 'encs'),
	('enumerator', 'enum'),
	('eventInfo', 'evin'),
	('extendedFloat', 'exte'),
	('feet', 'feet'),
	('fileRef', 'fsrf'),
	('fileSpecification', 'fss '),
	('fileURL', 'furl'),
	('fixed', 'fixd'),
	('fixedPoint', 'fpnt'),
	('fixedRectangle', 'frct'),
	('float_', 'doub'),
	('float128bit', 'ldbl'),
	('gallons', 'galn'),
	('grams', 'gram'),
	('graphicText', 'cgtx'),
	('inches', 'inch'),
	('integer', 'long'),
	('internationalText', 'itxt'),
	('internationalWritingCode', 'intl'),
	('kernelProcessID', 'kpid'),
	('kilograms', 'kgrm'),
	('kilometers', 'kmtr'),
	('list', 'list'),
	('liters', 'litr'),
	('locationReference', 'insl'),
	('longFixed', 'lfxd'),
	('longFixedPoint', 'lfpt'),
	('longFixedRectangle', 'lfrc'),
	('longPoint', 'lpnt'),
	('longRectangle', 'lrct'),
	('machPort', 'port'),
	('machine', 'mach'),
	('machineLocation', 'mLoc'),
	('meters', 'metr'),
	('miles', 'mile'),
	('missingValue', 'msng'),
	('null', 'null'),
	('ounces', 'ozs '),
	('parameterInfo', 'pmin'),
	('pixelMapRecord', 'tpmm'),
	('point', 'QDpt'),
	('pounds', 'lbs '),
	('processSerialNumber', 'psn '),
	('property', 'prop'),
	('propertyInfo', 'pinf'),
	('quarts', 'qrts'),
	('record', 'reco'),
	('reference', 'obj '),
	('rotation', 'trot'),
	('script', 'scpt'),
	('shortFloat', 'sing'),
	('shortInteger', 'shor'),
	('squareFeet', 'sqft'),
	('squareKilometers', 'sqkm'),
	('squareMeters', 'sqrm'),
	('squareMiles', 'sqmi'),
	('squareYards', 'sqyd'),
	('string', 'TEXT'),
	('styledClipboardText', 'styl'),
	('styledText', 'STXT'),
	('suiteInfo', 'suin'),
	('textStyleInfo', 'tsty'),
	('typeClass', 'type'),
	('unicodeText', 'utxt'),
	('unsignedInteger', 'magn'),
	('utf16Text', 'ut16'),
	('utf8Text', 'utf8'),
	('version', 'vers'),
	('writingCode', 'psct'),
	('yards', 'yard'),
]


pseudotypes = [ # non-concrete types that are only used for documentation purposes; use to remap typesbycode
		('file', 'file'), # typically FileURL, but could be other file types as well
		('number', 'nmbr'), # any numerical type: Integer, Float, Long
		# ('text', 'ctxt'), # Word X, Excel X uses 'ctxt' instead of 'TEXT' or 'utxt' (TO CHECK: is this Excel's stupidity, or is it acceptable?)
]


properties = [
		('class_', 'pcls'), # used as a key in AERecord structures that have a custom class; also some apps (e.g. Jaguar Finder) may omit it from their dictionaries despite using it
		('id_', 'ID  '), # some apps (e.g. iTunes) may omit 'id' property from terminology despite using it
]


enumerations = [
		('savo', [
				('yes', 'yes '), 
				('no', 'no  '), 
				('ask', 'ask '),
		]),
		# constants used in commands' 'ignore' argument (note: most apps currently ignore these):
		('cons', [
			('case_', 'case'),
			('diacriticals', 'diac'),
			('expansion', 'expa'),
			('punctuation', 'punc'),
			('hyphens', 'hyph'),
			('whitespace', 'whit'),
			('numericStrings', 'nume'),
			('applicationResponses', 'rmte'),
		]),
]



commands = [
	# required suite
	('run', 'aevtoapp', []),
	('open', 'aevtodoc', []),
	('print', 'aevtpdoc', []),
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
	('openLocation', 'GURLGURL', [('window', 'WIND')]), 
]
