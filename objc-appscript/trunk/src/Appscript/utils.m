//
//  utils.m
//  Appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "utils.h"

extern const char *GetMacOSStatusCommentString(OSStatus err) __attribute__((weak_import));

NSString *ASDescriptionForError(OSStatus err) {
	if (GetMacOSStatusCommentString) { // available in 10.4+
		NSString *errorString = [NSString stringWithUTF8String: GetMacOSStatusCommentString(err)];
		if (errorString && ![errorString isEqual: @""])
			return errorString;
	}
	return [NSString stringWithFormat: @"Mac OS error %i", err];
}
