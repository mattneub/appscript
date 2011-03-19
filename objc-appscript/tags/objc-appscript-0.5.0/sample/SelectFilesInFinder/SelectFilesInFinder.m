#import "FNGlue/FNGlue.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	FNApplication *finder = [[FNApplication alloc] initWithBundleID: @"com.apple.finder"];
	
	[[finder activate] send];
	
	NSArray *files = [NSArray arrayWithObjects: 
		[NSURL fileURLWithPath: [@"~/Movies" stringByStandardizingPath]],
		[NSURL fileURLWithPath: [@"~/Music" stringByStandardizingPath]],
		[NSURL fileURLWithPath: [@"~/Pictures" stringByStandardizingPath]],
		nil];
	
	NSError *err;
	[[finder select: files] sendWithError: &err];
	
	if (err) NSLog(@"%@", err);
    
	[finder release];
    [pool drain];
    return 0;
}
