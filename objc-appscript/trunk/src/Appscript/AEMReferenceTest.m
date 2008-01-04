//
//  AEMReferenceTest.m
//  Appscript
//
//  Created by Hamish Sanderson on 04/01/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AEMReferenceTest.h"


typedef struct {
	id ref;
	NSString *expectedStr;
	id expectedRef;
} TestDataType;



@implementation AEMReferenceTest

- (void) test1 {
	
	id ref, expectedRef, unpackedRef, desc;
	NSString *expectedStr;
	int i = 0;
	AEMCodecs *c = [AEMCodecs defaultCodecs];
	
	TestDataType testData[] = {
	
		// property, all elements
	
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
		
		// element by index, name, ide
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
		
		// element by named ordinal
		
		{
			[[AEMApp elements: 'docu'] first], 
			@"[[AEMApp elements: 'docu'] first]", 
			[[AEMApp elements: 'docu'] first], 
		},
		
		{
			[[AEMApp elements: 'docu'] middle], 
			@"[[AEMApp elements: 'docu'] middle]", 
			[[AEMApp elements: 'docu'] middle], 
		},
		
		{
			[[AEMApp elements: 'docu'] last], 
			@"[[AEMApp elements: 'docu'] last]", 
			[[AEMApp elements: 'docu'] last], 
		},
		
		{
			[[AEMApp elements: 'docu'] any], 
			@"[[AEMApp elements: 'docu'] any]", 
			[[AEMApp elements: 'docu'] any], 
		},
		
		// elements by range
		
		{
			[[AEMCon elements: 'docu'] at: 3], 
			@"[[AEMCon elements: 'docu'] byIndex: 3]", 
			[[AEMCon elements: 'docu'] at: 3], 
		},
		
		{
			[[AEMApp elements: 'docu'] byRange: [[AEMCon elements: 'docu'] at: 3]
											to: [[AEMCon elements: 'docu'] byName: @"foo"]], 
			@"[[AEMApp elements: 'docu'] byRange: [[AEMCon elements: 'docu'] byIndex: 3] "
											@"to: [[AEMCon elements: 'docu'] byName: foo]]", 
			[[AEMApp elements: 'docu'] byRange: [[AEMCon elements: 'docu'] at: 3]
											to: [[AEMCon elements: 'docu'] byName: @"foo"]], 
		},
		
		// elements by test
		
		{
			[[[AEMIts property: 'pnam'] equals: @"foo"] AND: [[AEMIts elements: 'cwor'] equals: [NSArray array]]], 
			@"[[[AEMIts property: 'pnam'] equals: foo] AND: [[AEMIts elements: 'cwor'] equals: (\n)]]", 
			[[[AEMIts property: 'pnam'] equals: @"foo"] AND: [[AEMIts elements: 'cwor'] equals: [NSArray array]]], 
		},
		
		{
			[[AEMCon elements: 'cwor'] notEquals: [NSArray array]],
			@"[[AEMCon elements: 'cwor'] notEquals: (\n)]",
			[[[AEMCon elements: 'cwor'] equals: [NSArray array]] NOT]
		},
		
		{nil, @"", nil}
	};
	
	do {
		ref = testData[i].ref;
		expectedStr = testData[i].expectedStr;
		expectedRef = testData[i].expectedRef;
		STAssertEqualObjects([ref description], expectedStr, @"Description failed.%@", ref);
		
		desc = [c pack: ref];
		STAssertEquals([desc class], [NSAppleEventDescriptor class], @"Pack failed.");
		
		NSLog(@"%@", desc);
		STAssertNoThrow(unpackedRef = [c unpack: desc], @"Unpack errored %@", desc);
		STAssertEqualObjects(unpackedRef, expectedRef, @"Unpack failed.");
		
		i++;
	} while (testData[i].ref);
	
	
}

@end
