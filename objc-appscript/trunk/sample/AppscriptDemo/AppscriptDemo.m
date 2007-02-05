#import <Foundation/Foundation.h>
#import "aemexample.m"
#import "appscriptexample.m"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"\n======================================================================\n\n");
	
	aemExample();
	
	NSLog(@"\n======================================================================\n\n");
	
	appscriptExample();

	NSLog(@"\n======================================================================\n\n");
	
    [pool release];
    return 0;
}