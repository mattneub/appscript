#import <Foundation/Foundation.h>
#import "MLGlue/MLGlue.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSError *error = nil;

	/*
	 * The data to insert. Hardcoded here for demonstration purposes; modify to suit.
	 */
	NSString *emailAddress = @"has.temp3@virgin.net";
	NSString *subjectText = @"Hello!";
	NSString *contentText = @"My favourite photo:\n\n";
	NSString *attachmentPath = @"/Library/Desktop Pictures/Nature/Clown Fish.jpg";

	/*
	 * Create a new application object for Mail.
	 */
    MLApplication *mail = [[MLApplication alloc] initWithBundleID: @"com.apple.mail"];
	
	
	/*
	 * Create a new outgoing message, setting the subject and content to the given values. 
	 * The resulting outgoing message reference is retained for use in subsequent commands.
	 */
	MLMakeCommand *makeCmd = [[[mail make] new_: [MLConstant outgoingMessage]] 
								 withProperties: [NSDictionary dictionaryWithObjectsAndKeys: 
																subjectText, [MLConstant subject],
																contentText, [MLConstant content],
																nil]];
	MLReference *msg = [makeCmd sendWithError: &error];
	if (!msg) goto finish;

	/*
	 * Add the email address.
	 *
	 * Note: if multiple addresses need to be added, use a loop and add them one at a time.
	 */
	 makeCmd = [[[[mail make] new_: [MLConstant toRecipient]] 
								at: [[msg toRecipients] end]]
					withProperties: [NSDictionary dictionaryWithObject: emailAddress
															   forKey: [MLConstant address]]];
	
	if (![makeCmd sendWithError: &error]) goto finish;

	/*
	 * Add the image attachment, if given. 
	 *
	 * Note that Mail's dictionary indicates a POSIX path string (NSString) to the image file
	 * is required, rather than the more common alias (AEMAlias) or file URL (NSURL).
	 *
	 * Because [in theory] this command will fail if an invalid path is given, the -sendWithError:
	 * method is used to obtain detailed error information to provide additional feedback.
	 * (In practice, the command fails silently due to a bug in Mail; a report will be filed on this.)
	 */
	if (attachmentPath) {
		makeCmd = [[[[mail make] new_: [MLConstant attachment]]
								   at: [[[msg content] paragraphs] end]]
					   withProperties: [NSDictionary dictionaryWithObject: attachmentPath
																   forKey: [MLConstant fileName]]];
		if (![makeCmd sendWithError: &error]) {
			NSLog(@"Couldn't attach attachment: %@", [error localizedDescription]);
			goto finish;
		}
	}
	
	/*
	 * Send the message.
	 */
	[[msg send_] sendWithError: &error];

finish:
	if (error) NSLog(@"An error occurred:\n%@", error);
	[mail release];
    [pool drain];
    return 0;
}
