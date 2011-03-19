#import "ITGlue/ITGlue.h"

// To create glue files: osaglue  -o ITGlue  -p IT  iTunes

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	ITApplication *itunes = [ITApplication applicationWithBundleID: @"com.apple.itunes"];
	
	ITReference *tracks = [[itunes currentPlaylist] tracks];
	
	/* Note: if player is stopped then current playlist isn't available. 
	 * You could either test for this in advance (as shown here) or check
	 * for nil results after sending the 'get' events. Additional NSError
	 * info is also optionally available.
	 */
	if ([[[tracks exists] send] boolValue]) {
	
		/*
		 * Note: Apple event IPC is query-based, allowing you to get a 
		 * property from all elements at once. This is far quicker than
		 * iterating over elements yourself if there are many of them.
		 */
		NSArray *names = [[tracks name] getList];
		NSArray *artists = [[tracks artist] getList];
		NSArray *albums = [[tracks album] getList];
		
		int i;
		for (i = 0; i < [names count]; i++)
			printf("%-60s  %-60s  %-60s\n", [[names objectAtIndex: i] UTF8String],
											[[artists objectAtIndex: i] UTF8String],
											[[albums objectAtIndex: i] UTF8String]);
		
	} else
		printf("Current playlist is not available.\n");
	
	[pool drain];
	return 0;
}