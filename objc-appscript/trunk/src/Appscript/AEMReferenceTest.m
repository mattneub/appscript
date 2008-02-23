//
//  AEMReferenceTest.m
//  Appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "AEMReferenceTest.h"

// TO DO: -[NSArray description] displays empty arrays as "(\n)" on 10.5 but "()" on 10.4,
// so some tests will currently fail on 10.4


typedef struct {
	id ref;
	NSString *expectedStr;
	id expectedRef;
} Test1DataType;


typedef struct {
	id ref1;
	id ref2;
} Test2DataType;


@implementation AEMReferenceTest

- (void) test1 {
	
	id ref, expectedRef, unpackedRef, desc;
	NSString *expectedStr;
	int i = 0;
	AEMCodecs *c = [AEMCodecs defaultCodecs];
	
	Test1DataType testData[] = {
	
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
		
		{
			[[AEMIts elements: 'cwor'] equals: [NSNull null]],
			@"[[AEMIts elements: 'cwor'] equals: <null>]",
			[[AEMIts elements: 'cwor'] equals: [NSNull null]]
		},
		
		{
			[[[AEMIts elements: 'cwor'] property: 'leng'] greaterThan: [NSNumber numberWithInt: 0]],
			@"[[[AEMIts elements: 'cwor'] property: 'leng'] greaterThan: 0]",
			[[[AEMIts elements: 'cwor'] property: 'leng'] greaterThan: [NSNumber numberWithInt: 0]]
		},
		
		{
			[[AEMIts elements: 'cwor'] lessOrEquals: @""],
			@"[[AEMIts elements: 'cwor'] lessOrEquals: ]",
			[[AEMIts elements: 'cwor'] lessOrEquals: @""]
		},
		
		{
			[[[AEMIts elements: 'cwor'] beginsWith: @"foo"] NOT],
			@"[[[AEMIts elements: 'cwor'] beginsWith: foo] NOT]",
			[[[AEMIts elements: 'cwor'] beginsWith: @"foo"] NOT]
		},
		
		{
			[[AEMIts elements: 'cwor'] contains: @"foo"],
			@"[[AEMIts elements: 'cwor'] contains: foo]",
			[[AEMIts elements: 'cwor'] contains: @"foo"]
		},
		
		{
			[[AEMIts elements: 'cwor'] isIn: @"foo"],
			@"[[AEMIts elements: 'cwor'] isIn: foo]",
			[[AEMIts elements: 'cwor'] isIn: @"foo"]
		},
		
		// misc
		
		{
			[[AEMApp elements: 'docu'] byTest: 
					[[AEMIts property: 'size'] greaterOrEquals: [NSNumber numberWithInt: 42]]],
			@"[[AEMApp elements: 'docu'] byTest: [[AEMIts property: 'size'] greaterOrEquals: 42]]",
			[[AEMApp elements: 'docu'] byTest: 
					[[AEMIts property: 'size'] greaterOrEquals: [NSNumber numberWithInt: 42]]],
		},
		
		{
			[[[[[[[[AEMApp elements: 'docu'] at: 1] property: 'ctxt'] elements: 'cpar'] elements: 'cha '] 
					byRange: [NSNumber numberWithInt: 3]
						 to: [[AEMCon elements: 'cha '] byIndex: [NSNumber numberWithInt: 55]]
					] next: 'cha '] after],
			@"[[[[[[[[AEMApp elements: 'docu'] byIndex: 1] property: 'ctxt'] elements: 'cpar'] elements: 'cha '] "
					@"byRange: 3 "
						 @"to: [[AEMCon elements: 'cha '] byIndex: 55]"
					@"] next: 'cha '] after]",
			[[[[[[[[AEMApp elements: 'docu'] at: 1] property: 'ctxt'] elements: 'cpar'] elements: 'cha '] 
					byRange: [NSNumber numberWithInt: 3]
						 to: [[AEMCon elements: 'cha '] byIndex: [NSNumber numberWithInt: 55]]
					] next: 'cha '] after],
		},
		
		{
			[[[[AEMIts property: 'pnam'] notEquals: @"foo"] AND: 
					[[AEMIts elements: 'cfol'] equals: [NSArray array]]] NOT],
			@"[[[[AEMIts property: 'pnam'] notEquals: foo] AND: [[AEMIts elements: 'cfol'] equals: (\n)]] NOT]",
			[[[[[AEMIts property: 'pnam'] equals: @"foo"] NOT] AND: 
					[[AEMIts elements: 'cfol'] equals: [NSArray array]]] NOT],
		},
		
		// insertion
		
		{
			[[AEMApp elements: 'docu'] beginning],
			@"[[AEMApp elements: 'docu'] beginning]",
			[[AEMApp elements: 'docu'] beginning],
		},
		
		{
			[[AEMApp elements: 'docu'] end],
			@"[[AEMApp elements: 'docu'] end]",
			[[AEMApp elements: 'docu'] end],
		},
		
		{
			[[[AEMApp elements: 'docu'] at: 3] before],
			@"[[[AEMApp elements: 'docu'] byIndex: 3] before]",
			[[[AEMApp elements: 'docu'] at: 3] before],
		},
		
		{
			[[[AEMApp elements: 'docu'] byID: @"foo"] after],
			@"[[[AEMApp elements: 'docu'] byID: foo] after]",
			[[[AEMApp elements: 'docu'] byID: @"foo"] after],
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

- (void)test2 {
	id ref1, ref2;
	int i = 0;
	
	Test2DataType testData[] = {
	
		{
			[[AEMApp property: 'ctxt'] property: 'ctxt'],
			[[AEMCon property: 'ctxt'] property: 'ctxt'],
		},
		
		{
			[[AEMApp property: 'pnam'] property: 'ctxt'],
			[[AEMApp property: 'ctxt'] property: 'ctxt'],
		},
		
		{
			[[AEMApp property: 'ctxt'] property: 'ctxt'],
			[[AEMApp property: 'ctxt'] property: 'pnam'],
		},
		
		{
			[[AEMApp elements: 'ctxt'] property: 'ctxt'],
			[[AEMApp property: 'ctxt'] property: 'ctxt'],
		},
		
		{
			[[AEMApp elements: 'ctxt'] property: 'ctxt'],
			@"[[AEMApp elements: 'ctxt'] property: 'ctxt']",
		},
		
		{
			@"[[AEMApp elements: 'ctxt'] property: 'ctxt']",
			[[AEMApp elements: 'ctxt'] property: 'ctxt'],
		},
		
		// TO DO: need more complex inequality tests, including test specifiers
		
		{nil, nil}
	};
	
	do {
		ref1 = testData[i].ref1;
		ref2 = testData[i].ref2;
		
		if ([ref1 isEqual: ref2])
			STFail(@"Non-equal failed: %@, %@", ref1, ref2);
		i++;
	} while (testData[i].ref1);

}

@end
