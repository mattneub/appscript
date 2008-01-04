//
//  AEMReferenceTest.m
//  Appscript
//
//  Created by Hamish Sanderson on 04/01/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AEMReferenceTest.h"


typedef struct {
	id ref1;
	NSString *str;
	id ref2;
} TestDataType;



@implementation AEMReferenceTest

- (void) test1 {
	
	id ref1, ref2, ref3, desc;
	NSString *str;
	int i = 0;
	AEMCodecs *c = [AEMCodecs defaultCodecs];
	
	TestDataType testData[] = {
		{
			[AEMApp property: 'ctxt'], 
			@"[AEMApp property: 'ctxt']", 
			[AEMApp property: 'ctxt']
		},
		
		{
			[AEMApp elements: 'docu'], 
			@"[AEMApp elements: 'docu']", 
			[AEMApp elements: 'docu']
		},
		
		{
			[[AEMApp elements: 'docu'] at: 1], 
			@"[[AEMApp elements: 'docu'] byIndex: 1]", 
			[[AEMApp elements: 'docu'] at: 1], 
		},
		
		{
			[[AEMApp elements: 'docu'] byIndex: [NSNumber numberWithInt: 1]], 
			@"[[AEMApp elements: 'docu'] byIndex: 1]", 
			[[AEMApp elements: 'docu'] byIndex: [NSNumber numberWithInt: 1]], 
		},
		
		{
			[[AEMApp elements: 'docu'] byName: @"foo"], 
			@"[[AEMApp elements: 'docu'] byName: foo]", 
			[[AEMApp elements: 'docu'] byName: @"foo"], 
		},
		
		{
			[[AEMApp elements: 'docu'] byID: [NSNumber numberWithInt: 300]], 
			@"[[AEMApp elements: 'docu'] byID: 300]", 
			[[AEMApp elements: 'docu'] byID: [NSNumber numberWithInt: 300]], 
		},
		
		{
			[[AEMApp elements: 'docu'] next: 'docu'], 
			@"[[AEMApp elements: 'docu'] next: 'docu']", 
			[[AEMApp elements: 'docu'] next: 'docu'], 
		},
		
		{
			[[AEMApp elements: 'docu'] previous: 'docu'], 
			@"[[AEMApp elements: 'docu'] previous: 'docu']", 
			[[AEMApp elements: 'docu'] previous: 'docu'], 
		},
		
		{nil, @"", nil}
	};
	
	do {
		ref1 = testData[i].ref1;
		ref2 = testData[i].ref2;
		str = testData[i].str;
		STAssertEqualObjects([ref1 description], str, @"Description failed.");
		
		desc = [c pack: ref1];
		STAssertEquals([desc class], [NSAppleEventDescriptor class], @"Pack failed.");
		
		NSLog(@"%@", desc);
		STAssertNoThrow(ref3 = [c unpack: desc], @"Unpack errored %@", desc);
		STAssertEqualObjects(ref3, ref1, @"Unpack failed.");
		
		i++;
	} while (testData[i].ref1);
	
	
}

@end
