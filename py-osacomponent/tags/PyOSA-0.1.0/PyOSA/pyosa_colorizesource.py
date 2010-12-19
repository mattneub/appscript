
#
# pyosa_colorizesource.py
# PyOSA
#
# Copyright (C) 2007 HAS
#
#
#

from StringIO import StringIO
from struct import pack
from tokenize import *
from keyword import iskeyword

from CarbonX.AE import AECreateDesc
from CarbonX.kAE import *
import aem

__all__ = ['sourcetostyledtext']

######################################################################

codecs = aem.Codecs()

# From TextEdit.h:
#
#	struct StScrpRec {
#	  short               scrpNStyles;            /*number of styles in scrap*/
#	  ScrpSTTable         scrpStyleTab;           /*table of styles for scrap*/
#	};
#
#	struct ScrpSTElement {
#	  long                scrpStartChar;          /*starting character position*/
#	  short               scrpHeight;
#	  short               scrpAscent;
#	  short               scrpFont;
#	  StyleField          scrpFace;               /*StyleField occupies 16-bits, but only first 8-bits are used*/
#	  short               scrpSize;
#	  RGBColor            scrpColor;
#	};

kStyleData = {
	'COMMENT':	pack('hhhhhHHH', 16, 14, 3, 0, 12, 0x8000, 0x8000, 0x8000), # grey (comment)
	'NAME':		pack('hhhhhHHH', 16, 14, 3, 0, 12, 0xA000, 0x0000, 0x0000), # red (keyword)
	'STRING':	pack('hhhhhHHH', 16, 14, 3, 0, 12, 0x0000, 0x0000, 0xC000), # blue (string literal)
	'NONE':		pack('hhhhhHHH', 16, 14, 3, 0, 12, 0x0000, 0x0000, 0x0000), # black (everything else)
}


######################################################################

def sourcetostyledtext(desc):
	chardesc = desc.AECoerceDesc(typeChar)
	source = chardesc.data
	linelengths = [0] + [len(line) for line in source.split('\n')]
	styledata = []
	linenum = 1
	linecursor = 0
	endpos = 0
	for kind, s, (srow, scol), (erow, ecol), line in generate_tokens(StringIO(source).readline):
		tokentype = tok_name[kind]
		if tokentype in ['COMMENT', 'STRING'] or tokentype == 'NAME' and iskeyword(s):
			while linenum < srow:
				linecursor += linelengths[linenum] + 1
				linenum += 1
			startpos = linecursor + scol
			if endpos != startpos:
				styledata.append(pack('l', endpos) + kStyleData['NONE'])
			while linenum < erow:
				linecursor += linelengths[linenum] + 1
				linenum += 1
			endpos = linecursor + ecol
			styledata.append(pack('l', startpos) + kStyleData[tokentype])
	if endpos != len(source):
		styledata.append(pack('l', endpos) + kStyleData['NONE'])
	styledata = pack('h', len(styledata)) + ''.join(styledata)
	return codecs.pack({
				aem.AEType(keyAEText): chardesc,
				aem.AEType(keyAEStyles): AECreateDesc(typeScrapStyles, styledata)
				}).AECoerceDesc(typeStyledText)


