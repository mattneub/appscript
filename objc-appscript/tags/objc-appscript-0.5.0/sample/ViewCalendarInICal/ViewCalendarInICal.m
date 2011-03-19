#import "ICGlue/ICGlue.h"

int main (int argc, const char * argv[]) {

	if (argc != 2) {
		printf("Usage: viewcal DATE (e.g. viewcal 12/21/08)\n");
		return 0;
	}
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString *dateStr = [NSString stringWithCString: argv[1] encoding: NSUTF8StringEncoding];
	NSDate *date = [NSDate dateWithNaturalLanguageString: dateStr];
	
	ICApplication *ical = [ICApplication applicationWithBundleID: @"com.apple.ical"];
	
	[[ical activate] send];
	
	ICViewCalendarCommand *cmd = [[ical viewCalendar] at: date];
	
	NSError *error;
	id result = [cmd sendWithError: &error];
	
	if (!result)
		NSLog(@"%@", error);
	
	[pool drain];
	return 0;
}
