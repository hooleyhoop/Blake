//
//  SHMutableIntTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <FScript/FScript.h>
#import "SHMutableInt.h"


@interface SHMutableIntTests : SenTestCase {
	
}

@end

/*
 *
*/
@implementation SHMutableIntTests

// any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
//=========================================================== 
// testWillAsk
//=========================================================== 
- (void) testWillAsk
{	
	STAssertTrue([[SHMutableInt willAsk] isEqualToString:@"SHMutableInt"], @"testWillAsk failed");
}

// however, a single data type might respond to more than one request (string and number, etc.)
//=========================================================== 
// testWillAnswer
//=========================================================== 
- (void) testWillAnswer
{
	NSArray* a = [SHMutableInt willAnswer];
	STAssertTrue([[a objectAtIndex:0] isEqualToString:@"SHMutableInt"], @"testWillAnswer failed");
}

// default value must be nil. ie - 'unset'
- (void)testDefaultValue
{
	SHMutableInt* ob = [[[[SHMutableInt alloc] init] autorelease] autorelease];
	STAssertTrue( [ob value]==[NSNull null], @"Default value must be nil - 'unset'");
}


//=========================================================== 
// testDataTypeFromDisplayObject
//=========================================================== 
- (void) testDataTypeFromDisplayObject
{	
	id ob = [SHMutableInt dataTypeFromDisplayObject:@"-11"];
	STAssertTrue([ob intValue]==-11, @"testDataTypeFromDisplayObject failed");
	id ob2 = [SHMutableInt dataTypeFromDisplayObject:@"101"];
	STAssertTrue([ob2 intValue]==101, @"testDataTypeFromDisplayObject failed");
}

#pragma mark init methods
//=========================================================== 
// testInitWithObject
//=========================================================== 
- (void) testInitWithObject
{
	id ob1 = [[[SHMutableInt alloc] initWithObject:@"1"] autorelease];
	id ob2 = [[[SHMutableInt alloc] initWithObject:@"0"] autorelease];
	id ob3 = [[[SHMutableInt alloc] initWithObject:[NSNumber numberWithInt:11]] autorelease];
	id ob4 = [[[SHMutableInt alloc] initWithObject:[NSNumber numberWithInt:-36789]] autorelease];
	STAssertTrue([ob1 intValue]==1, @"testInitWithObject failed");
	STAssertTrue([ob2 intValue]==0, @"testInitWithObject failed");
	STAssertTrue([ob3 intValue]==11, @"testInitWithObject failed");
	STAssertTrue([ob4 intValue]==-36789, @"testInitWithObject failed");
}

//=========================================================== 
// testinitWithInt
//=========================================================== 
- (void) testinitWithInt
{
	id ob1 = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id ob2 = [[[SHMutableInt alloc] initWithInt:-11] autorelease];
	STAssertTrue([ob1 intValue]==11, @"testinitWithInt failed");
	STAssertTrue([ob2 intValue]==-11, @"testinitWithInt failed");
}

//=========================================================== 
// testinitWithFloat
//=========================================================== 
- (void) testinitWithFloat
{
	id ob1 = [[[SHMutableInt alloc] initWithFloat:1.0] autorelease];
	id ob2 = [[[SHMutableInt alloc] initWithFloat:999.325648] autorelease];
	id ob3 = [[[SHMutableInt alloc] initWithFloat:-999.325648] autorelease];
	id ob4 = [[[SHMutableInt alloc] initWithFloat:0.0] autorelease];
	STAssertTrue([ob1 intValue]==1, @"testinitWithFloat failed");
	STAssertTrue([ob2 intValue]==999, @"testinitWithFloat failed");
	STAssertTrue([ob3 intValue]==-999, @"testinitWithFloat failed");
	STAssertTrue([ob4 intValue]==0, @"testinitWithFloat failed");
}

#pragma mark NSCopyopying, hash, isEqual
//=========================================================== 
// testCopyWithZone
//=========================================================== 
- (void) testCopyWithZone
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obYES2 = [obYES duplicate];
	STAssertTrue([obYES isEqual: obYES2], @"testDuplicate failed");
}

//=========================================================== 
// testDuplicate
//=========================================================== 
- (void) testDuplicate
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obYES2 = [obYES duplicate];
	STAssertTrue([obYES isEqual: obYES2], @"testDuplicate failed");
}

//=========================================================== 
// testIsEqual
//=========================================================== 
- (void) testIsEqual
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obYES2 = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obNO = [[[SHMutableInt alloc] initWithInt:0] autorelease];
	STAssertTrue([obYES isEqual: obYES], @"testIsEqual failed");
	STAssertTrue([obYES isEqual: obYES2], @"testIsEqual failed");
	STAssertTrue(![obYES isEqual: obNO], @"testIsEqual failed");
}

#pragma mark action methods
//=========================================================== 
// testTryToSetValue
//=========================================================== 
- (void) testTryToSetValue
{
	BOOL f;
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	f = [obYES tryToSetValueWith:@"YES"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==1, @"testTryToSetValue failed");

	f = [obYES tryToSetValueWith:@"No"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==0, @"testTryToSetValue failed");

	f = [obYES tryToSetValueWith:@"true"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==1, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"welly"];
	STAssertTrue(f==NO, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:1]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==1, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithFloat:99.99]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==100, @"testTryToSetValue failed is %i", [obYES intValue]);
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:0]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==0, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"4 + 3 - 6"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==1, @"testTryToSetValue failed: int value is %i", [obYES intValue]);
	
	f = [obYES tryToSetValueWith:@"4 + 3 - 7"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==0, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[@"[4 + 3 - 6]" asBlock]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES intValue]==1, @"testTryToSetValue failed");
}

#pragma mark accessor methods
/*	The required 'willAnswer' method for this dataType 
	NOTE: This value should'nt be modifyied internally unless you know what you are doing
	An operator wont modify it's input values */
//=========================================================== 
// testSHMutableInt
//=========================================================== 
- (void) testSHMutableInt
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id ob2 = [obYES SHMutableInt];
	STAssertTrue(ob2 == obYES, @"testSHMutableInt failed");
}

- (void) testSHNumber
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id ob2 = [obYES SHNumber];
	STAssertTrue([ob2 floatValue]==11.0, @"testSHNumber failed");
	[obYES release];
}


//=========================================================== 
// tesIntValue
//=========================================================== 
- (void) tesIntValue
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obNO = [[[SHMutableInt alloc] initWithInt:-11] autorelease];
	STAssertTrue([obYES intValue]==11, @"tesIntValue failed");
	STAssertTrue([obNO intValue]==-11, @"tesIntValue failed");
}

//=========================================================== 
// testStringValue
//=========================================================== 
- (void) testStringValue
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obNO = [[[SHMutableInt alloc] initWithInt:-11] autorelease];
	STAssertTrue([[obYES stringValue] isEqualToString:@"11"], @"testStringValue failed");
	STAssertTrue([[obNO stringValue] isEqualToString:@"-11"], @"testStringValue failed");
}

//=========================================================== 
// testFloatValue
//=========================================================== 
- (void) testFloatValue
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obNO = [[[SHMutableInt alloc] initWithInt:-11] autorelease];
	STAssertTrue([obYES floatValue] == 11.0, @"testFloatValue failed");
	STAssertTrue([obNO floatValue] == -11.0, @"testFloatValue failed");
}

//=========================================================== 
// testDisplayObject
//=========================================================== 
- (void) testDisplayObject
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obNO = [[[SHMutableInt alloc] initWithInt:-11] autorelease];
	STAssertTrue([[obYES displayObject] isEqualToString:@"11"], @"testStringValue failed");
	STAssertTrue([[obNO displayObject] isEqualToString:@"-11"], @"testStringValue failed");
}

//=========================================================== 
// testFScriptSaveString
//=========================================================== 
- (void) testFScriptSaveString
{
	id obYES = [[[SHMutableInt alloc] initWithInt:11] autorelease];
	id obNO = [[[SHMutableInt alloc] initWithInt:0] autorelease];

	NSString* fscriptStringYES = [obYES fScriptSaveString];
	NSString* fscriptStringNO = [obNO fScriptSaveString];

	// execute the save strings in fscript
	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: fscriptStringYES];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	if(!result){
		STFail(@"Failed to execute save string");
	}			
	// is it the same
	STAssertTrue([obYES isEqual:result], @"should be roughly the same");
	
	FSInterpreterResult* execResult2 = [theInterpreter execute: fscriptStringNO];
	id result2 = nil;
	if([execResult2 isOK]){
		result2 = [execResult2 result];
	}
	if(!result2){
		STFail(@"Failed to execute save string");
	}			
	// is it the same
	STAssertTrue([obNO isEqual:result2], @"should be roughly the same");
}


@end
