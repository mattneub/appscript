#include <Carbon/Carbon.r>

#define Reserved8   reserved, reserved, reserved, reserved, reserved, reserved, reserved, reserved
#define Reserved12  Reserved8, reserved, reserved, reserved, reserved
#define Reserved13  Reserved12, reserved
#define dp_none__   noParams, "", directParamOptional, singleItem, notEnumerated, Reserved13
#define reply_none__   noReply, "", replyOptional, singleItem, notEnumerated, Reserved13
#define synonym_verb__ reply_none__, dp_none__, { }
#define plural__    "", {"", kAESpecialClassProperties, cType, "", reserved, singleItem, notEnumerated, readOnly, Reserved8, noApostrophe, notFeminine, notMasculine, plural}, {}

resource 'aete' (0, "MiniTC Terminology") {
	0x1,  // major version
	0x0,  // minor version
	english,
	roman,
	{
		"Basic Text Suite",
		"Basic commands for working with text.",
		'????',
		1,
		1,
		{
			/* Events */

			"unicode numbers",
			"Convert Unicode text to a list of integers.",
			'TeCo', 'Unum',
			'long',
			"A list of integers in range 0-65535.",
			replyRequired, listOfItems, notEnumerated, Reserved13,
			'TEXT',
			"The unicode text.",
			directParamRequired,
			singleItem, notEnumerated, Reserved13,
			{

			},

			"unicode characters",
			"Convert a list of integers to Unicode text.",
			'TeCo', 'Ucha',
			'TEXT',
			"The unicode text.",
			replyRequired, singleItem, notEnumerated, Reserved13,
			'long',
			"A list of integers in range 0-65535.",
			directParamRequired,
			listOfItems, notEnumerated, Reserved13,
			{

			},

			"strip",
			"Strip whitespace or other characters from Unicode text.",
			'TeCo', 'Strp',
			'TEXT',
			"The modified text.",
			replyRequired, singleItem, notEnumerated, Reserved13,
			'TEXT',
			"The Unicode text to modify.",
			directParamRequired,
			singleItem, notEnumerated, Reserved13,
			{
				"removing", 'Remo', 'TEXT',
				"The character(s) to remove. (default: whitespace characters)",
				optional,
				singleItem, notEnumerated, Reserved13,
				"from", 'From', 'StpE',
				"Where to remove characters. (default: both ends)",
				optional,
				singleItem, enumerated, Reserved13
			}
		},
		{
			/* Classes */

		},
		{
			/* Comparisons */
		},
		{
			/* Enumerations */
			'StpE',
			{
				"left end", 'Left', "",
				"right end", 'Rght', "",
				"both ends", 'Both', ""
			}
		}
	}
};
