//
//  SHMutableFloatTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <FScript/FScript.h>
#import "SHMutableFloat.h"

@interface SHMutableFloatTests : SenTestCase {
	
}

@end

/*
 *
*/
@implementation SHMutableFloatTests

// any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
//=========================================================== 
// testWillAsk
//=========================================================== 
- (void)testWillAsk
{	
	STAssertTrue([[SHMutableFloat willAsk] isEqualToString:@"SHMutableFloat"], @"testWillAsk failed");
}

// however, a single data type might respond to more than one request (string and number, etc.)
//=========================================================== 
// testWillAnswer
//=========================================================== 
- (void)testWillAnswer
{
	NSArray* a = [SHMutableFloat willAnswer];
	STAssertTrue([[a objectAtIndex:0] isEqualToString:@"SHMutableFloat"], @"testWillAnswer failed");
}

// default value must be nil. ie - 'unset'
- (void)testDefaultValue
{
	SHMutableFloat* ob = [[[SHMutableFloat alloc] init] autorelease];
	STAssertTrue( [ob value]==[NSNull null], @"Default value must be nil - 'unset'");
}

//=========================================================== 
// testDataTypeFromDisplayObject
//=========================================================== 
- (void)testDataTypeFromDisplayObject
{	
	id ob = [SHMutableFloat dataTypeFromDisplayObject:@"11.2"];
	STAssertTrue([ob floatValue]==11.2f, @"testDataTypeFromDisplayObject failed is %f", [ob floatValue]);
	id ob2 = [SHMutableFloat dataTypeFromDisplayObject:@"-456"];
	STAssertTrue([ob2 floatValue]==-456.0f, @"testDataTypeFromDisplayObject failed %f", [ob floatValue]);
}

#pragma mark init methods
//=========================================================== 
// testInitWithObject
//=========================================================== 
- (void)testInitWithObject
{
//	id ob1 = [[SHMutableFloat alloc] initWithObject:@"YES"] autorelease];
//	id ob2 = [[SHMutableFloat alloc] initWithObject:@"NO"] autorelease];
//	id ob3 = [[SHMutableFloat alloc] initWithObject:[NSNumber numberWithInt:1]] autorelease];
//	id ob4 = [[SHMutableFloat alloc] initWithObject:[NSNumber numberWithInt:0]] autorelease];
//	STAssertTrue([ob1 floatValue]==1.0f, @"testinitWithFloat failed");
//	STAssertTrue([ob2 floatValue]==0.0f, @"testinitWithFloat failed");
//	STAssertTrue([ob3 floatValue]==1.0f, @"testinitWithFloat failed");
//	STAssertTrue([ob4 floatValue]==0.0f, @"testinitWithFloat failed");
}

//=========================================================== 
// testinitWithBool
//=========================================================== 
- (void)testinitWithFloat
{
	id ob1 = [[[SHMutableFloat alloc] initWithFloat:11.01f] autorelease];
	id ob2 = [[[SHMutableFloat alloc] initWithFloat:-11.01f] autorelease];
	STAssertTrue([ob1 floatValue]==11.01f, @"testinitWithFloat failed is %f", [ob1 floatValue]);
	STAssertTrue([ob2 floatValue]==-11.01f, @"testinitWithFloat failed is %f", [ob2 floatValue]);
}


//=========================================================== 
// testinitWithInt
//=========================================================== 
- (void)testinitWithInt
{
	id ob1 = [[[SHMutableFloat alloc] initWithInt:1] autorelease];
	id ob2 = [[[SHMutableFloat alloc] initWithInt:999] autorelease];
	id ob3 = [[[SHMutableFloat alloc] initWithInt:-999] autorelease];
	id ob4 = [[[SHMutableFloat alloc] initWithInt:0] autorelease];
	STAssertTrue([ob1 floatValue]==1.0, @"testinitWithFloat failed");
	STAssertTrue([ob2 floatValue]==999.0, @"testinitWithFloat failed");
	STAssertTrue([ob3 floatValue]==-999.0, @"testinitWithFloat failed");
	STAssertTrue([ob4 floatValue]==0.0, @"testinitWithFloat failed");
}

#pragma mark NSCopyopying, hash, isEqual
//=========================================================== 
// testCopyWithZone
//=========================================================== 
- (void)testCopyWithZone
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.254f] autorelease];
	id obYES2 = [obYES duplicate];
	STAssertTrue([obYES isEqual: obYES2], @"testDuplicate failed");
}

//=========================================================== 
// testDuplicate
//=========================================================== 
- (void)testDuplicate
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.254f] autorelease];
	id obYES2 = [obYES duplicate];
	STAssertTrue([obYES isEqual: obYES2], @"testDuplicate failed");
}

//=========================================================== 
// testIsEqual
//=========================================================== 
- (void)testIsEqual
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:2.54f] autorelease];
	id obYES2 = [[[SHMutableFloat alloc] initWithFloat:2.54f] autorelease];
	id obNO = [[[SHMutableFloat alloc] initWithFloat:0.0f] autorelease];
	STAssertTrue([obYES isEqual: obYES], @"testIsEqual failed");
	STAssertTrue([obYES isEqual: obYES2], @"testIsEqual failed");
	STAssertTrue(![obYES isEqual: obNO], @"testIsEqual failed");
}

#pragma mark action methods
//=========================================================== 
// testTryToSetValue
//=========================================================== 
- (void)testTryToSetValue
{
	BOOL f;
	id obYES;
	obYES = [[[SHMutableFloat alloc] initWithFloat:1.0f] autorelease];
	f = [obYES tryToSetValueWith:@"YES"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==1.0f, @"testTryToSetValue failed");

	f = [obYES tryToSetValueWith:@"No"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==0.0f, @"testTryToSetValue failed");

	f = [obYES tryToSetValueWith:@"true"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==1.0f, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"welly"];
	STAssertTrue(f==NO, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:1]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==1.0f, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithFloat:99.99]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==99.99f, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:0]];
	STAssertTrue(f==YES, @"testTryToSetValue failed is %i", f);
	STAssertTrue([obYES floatValue]==0.0f, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"4 + 3 - 6"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==1.0f, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"4 + 3 - 8.5"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==-1.5f, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[@"[4 + 3 - 6]" asBlock]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES floatValue]==1.0f, @"testTryToSetValue failed");
}

#pragma mark accessor methods
/*	The required 'willAnswer' method for this dataType 
	NOTE: This value should'nt be modifyied internally unless you know what you are doing
	An operator wont modify it's input values */
//=========================================================== 
// testSHMutableFloat
//=========================================================== 
- (void)testSHMutableFloat
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.5] autorelease];
	id ob2 = [obYES SHMutableFloat];
	STAssertTrue(ob2 == obYES, @"testSHMutableFloat failed");
}

- (void)testSHNumber
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.5] autorelease];
	id ob2 = [obYES SHNumber];
	STAssertTrue([ob2 floatValue]==11.5, @"testSHNumber failed is %f", [ob2 floatValue]);
	[obYES release];
}

//=========================================================== 
// testIntValue
//=========================================================== 
- (void)testIntValue
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.2] autorelease];
	id obNO = [[[SHMutableFloat alloc] initWithFloat:-66.9] autorelease];
	STAssertTrue([obYES intValue]==11, @"testBoolValue failed");
	STAssertTrue([obNO intValue]==-67, @"testBoolValue failed is %i",[obNO intValue]);
}

//=========================================================== 
// testStringValue
//=========================================================== 
- (void)testStringValue
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.3] autorelease];
	id obNO = [[[SHMutableFloat alloc] initWithFloat:-600.5] autorelease];
	STAssertTrue([[obYES stringValue] isEqualToString:@"11.3"], @"testStringValue failed is %@", [obYES stringValue]);
	STAssertTrue([[obNO stringValue] isEqualToString:@"-600.5"], @"testStringValue failed is %@", [obNO stringValue]);
}

//=========================================================== 
// testFloatValue
//=========================================================== 
- (void)testFloatValue
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.0] autorelease];
	id obNO = [[[SHMutableFloat alloc] initWithFloat:-100.0] autorelease];
	STAssertTrue([obYES floatValue] == 11.0, @"testFloatValue failed");
	STAssertTrue([obNO floatValue] == -100, @"testFloatValue failed");
}


//=========================================================== 
// testDisplayObject
//=========================================================== 
- (void)testDisplayObject
{
	id obYES = [[[SHMutableFloat alloc] initWithFloat:11.3] autorelease];
	id obNO = [[[SHMutableFloat alloc] initWithFloat:-600.5] autorelease];
	STAssertTrue([[obYES displayObject] isEqualToString:@"11.3"], @"testStringValue failed is %@", [obYES stringValue]);
	STAssertTrue([[obNO displayObject] isEqualToString:@"-600.5"], @"testStringValue failed is %@", [obNO stringValue]);
}

//=========================================================== 
// testFScriptSaveString
//=========================================================== 
- (void)testFScriptSaveString
{
	SHMutableFloat* obYES = [[[SHMutableFloat alloc] initWithFloat:99.9f] autorelease];
	SHMutableFloat* obNO = [[[SHMutableFloat alloc] initWithFloat:-99.9f] autorelease];

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
