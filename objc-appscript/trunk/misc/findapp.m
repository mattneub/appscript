//
//  findapp.m
//  Copyright (C) 2007 HAS
//

#import "findapp.h"

extern NSURL* AEMFindApplication(OSType creator, NSString *bundleID, NSString *name) {
	OSErr err;
	CFURLRef outAppURL;
	
	err = LSFindApplicationForInfo(creator,
								   (CFStringRef)bundleID,
								   (CFStringRef)name,
								   NULL,
								   &outAppURL);
	if (err) return nil;
	return (NSURL *)outAppURL;
}

