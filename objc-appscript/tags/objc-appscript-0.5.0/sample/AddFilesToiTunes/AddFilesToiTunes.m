#import <Foundation/Foundation.h>
#import "ITGlue/ITGlue.h"

// Usage: addtoitunes playlist file ...

int main (int argc, const char * argv[]) {
	if (argc < 3) {
		printf("Usage: addtoitunes playlist file ...\n.");
		return 0;
	}
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    ITApplication *itunes = [[ITApplication alloc] initWithBundleID: @"com.apple.itunes"];
	NSError *err = nil;
	
	// Argument 1 is name of playlist to which tracks should be added
	NSString *listName = [NSString stringWithUTF8String: argv[1]];
	
	// The remaining arguments are audio file paths
	NSMutableArray *files = [NSMutableArray array];
	int i;
	for (i = 2; i < argc; i++) {
		NSURL *file = [NSURL fileURLWithPath: [NSString stringWithUTF8String: argv[i]]];
		[files addObject: file];
	}
	
	// Build a reference to the specified playlist
	ITReference *playlistRef = [[itunes playlists] byName: listName];
	
	// See if the playlist already exists...
	ASBoolean *listExists = [[playlistRef exists] sendWithError: &err];
	if (err) goto error;
	
	// ... if not, create it
	if (![listExists boolValue]) {
		[[[[itunes make] new_: [ITConstant playlist]]
			   withProperties: [NSDictionary dictionaryWithObject: listName forKey: [ITConstant name]]] 
			   sendWithError: &err];
		if (err) goto error;
	}
	
	// Add the specified files to the playlist...
	[[[itunes add: files] to: playlistRef] sendWithError: &err];
	if (err) goto error;
	
	// ... and, for good measure, start playing it
	[[itunes play: playlistRef] sendWithError: &err];
	
error:
	[itunes release];
    [pool release];
    return [err code];
}
