//
//  utils.m
//  Appscript
//
//  Copyright (C) 2007 HAS
//

#import "utils.h"


NSString *AEMDescTypeToDisplayString(OSType code) {
	NSMutableString *str;
	char c;
	int i;
	
	code = CFSwapInt32HostToBig(code);
	str = [NSMutableString stringWithCapacity: 16];
	for (i = 0; i < sizeof(code); i++) {
		c = ((char*)(&code))[i];
		if (c < 32 || c > 126 || c == '\\' || c == '\'')
			[str appendFormat: @"\\x%02x", c];
		else
			[str appendFormat: @"%c", c];
	}
	return str;
}
