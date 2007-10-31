
#import "appscriptexample.h"

void appscriptExample(void) {

    TEApplication *textedit;
	TEMakeCommand *makeCmd;
	TEGetCommand *getCmd;
    id result;
    
    textedit = [[TEApplication alloc]
                 initWithName: @"TextEdit.app"];
    NSLog(@"textedit:\n%@\n\n", textedit);
    
    // tell application "TextEdit" to \
    //     make new document with properties {text:"Hi!"}
    
	NSLog(@"make new document:\n");
    makeCmd = [[[textedit make] new_: [TEConstant document]]
					 withProperties: [NSDictionary dictionaryWithObjectsAndKeys:
											@"Hi 2!", [TEConstant text], nil]];
	result = [makeCmd send];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\nnumber: %i\nmessage: %@\n\n",
		      [makeCmd errorNumber], [makeCmd errorString]);

    // tell application "TextEdit" to get text of document 1
	
	NSLog(@"get text of document 1:\n");
    getCmd = [[[[textedit documents] at: 1] text] get];
	result = [getCmd send];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\nnumber: %i\nmessage: %@\n\n",
		      [getCmd errorNumber], [getCmd errorString]);

    // tell application "TextEdit" to get document 100
	
	NSLog(@"get document 100:\n");
    getCmd = [[[[textedit documents] at: 100] text] get];
	result = [getCmd send];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\nnumber: %i\nmessage: %@\n\n",
		      [getCmd errorNumber], [getCmd errorString]);
	
    // tell application "TextEdit" to get every document

	NSLog(@"get every document:\n");
    getCmd = [[textedit documents] get];
	result = [getCmd send];
    if (result) 
        NSLog(@"result:\n%@\n\n", result);
    else
        NSLog(@"error:\nnumber: %i\nmessage: %@\n\n",
		      [getCmd errorNumber], [getCmd errorString]);

    [textedit release];

}