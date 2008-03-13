#import <Foundation/Foundation.h>
#import "SEGlue/SEGlue.h"
#import "DefaultGlue/ASDefaultGlue.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *targetAppName = @"TextEdit";
	
    SEApplication *systemEvents = [[SEApplication alloc] initWithName: @"System Events"];
	
	// The default application glue provides only Required Suite commands (run, activate, quit, etc)
	ASDefaultApplication *app = [[ASDefaultApplication alloc] initWithName: targetAppName];
	
	
	// Bring the target application to the front
	NSError *err;
	[[app activate] sendWithError: &err];
	if (err) {
		NSLog(@"%@", err);
		goto finish;
	}
	
	// Send Command-N to frontmost application to make new document
	[[[systemEvents keystroke: @"n"] using: [SEConstant commandDown]] send];
	
	// Type "Hello World"
	[[systemEvents keystroke: @"Hello World"] send];

finish:
	[systemEvents release];
    [pool drain];
    return 0;
}
