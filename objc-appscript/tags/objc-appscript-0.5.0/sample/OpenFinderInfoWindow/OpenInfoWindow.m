#import <Foundation/Foundation.h>
#import "FNGlue/FNGlue.h"

/*
 * Opens a Finder information window for the specified file.
 */

int main (int argc, const char * argv[]) {
	int err = 0;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	if (argc != 2) {
		printf("Usage: infowin file\n");
		return err;
	}
	
	NSString *path = [NSString stringWithCString: argv[1] encoding: NSUTF8StringEncoding];
	
	NSURL *file = [NSURL fileURLWithPath: path];
	
	FNApplication *finder = [FNApplication applicationWithName: @"Finder"];

	FNReference *ref = [[[finder items] byIndex: file] informationWindow];

	NSError *error;
	id result = [[ref open] sendWithError: &error];
	
	if (result)
		[[finder activate] send];
	else {
		err = [error code];
		printf("%s\n", [[error localizedDescription] UTF8String]);
	}

    [pool drain];
    return err;
}
