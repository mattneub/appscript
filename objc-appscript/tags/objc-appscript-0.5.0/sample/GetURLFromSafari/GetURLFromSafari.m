#import <Foundation/Foundation.h>
#import "SFGlue/SFGlue.h"

// To make Safari glue:  osaglue  -o SFGlue  -p SF  Safari

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    SFApplication *safari = [[SFApplication alloc] initWithBundleID: @"com.apple.safari"];
	
	if ([safari isRunning]) {
	
		SFReference *docRef = [[safari documents] at: 1];
		
		NSError *err;
		id name = [[[docRef name] get] sendWithError: &err];
		if (name)
			NSLog(@"Title: %@", name);
		else
			NSLog(@"Error:\n%@", err);
		
		id url = [[[docRef URL] get] sendWithError: &err];
		if (url)
			NSLog(@"URL: %@", url);
		else
			NSLog(@"Error:\n%@", err);
	
	} else
		NSLog(@"Safari is not running.");
	
	[safari release];
    [pool drain];
    return 0;
}
