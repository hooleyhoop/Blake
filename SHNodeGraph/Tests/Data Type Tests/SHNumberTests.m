//
//  SHNumberTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 01/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <FScript/FScript.h>
#import "SHNumber.h"

@interface SHNumberTests : SenTestCase {
	
}

/*
 *
*/
@implementation SHNumberTests

#pragma mark -
#pragma mark class methods
// any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
//=========================================================== 
// testWillAsk
//=========================================================== 
- (void) testWillAsk
{	
	STAssertTrue([[SHNumber willAsk] isEqualToString:@"SHNumber"], @"testWillAsk failed");
}

// however, a single data type might respond to more than one request (string and number, etc.)
//=========================================================== 
// testWillAnswer
//=========================================================== 
- (void) testWillAnswer
{
	NSArray* a = [SHNumber willAnswer];
	STAssertTrue([[a objectAtIndex:0] isEqualToString:@"SHNumber"], @"testWillAnswer failed");
}

// default value must be nil. ie - 'unset'
- (void)testDefaultValue
{
	SHNumber* ob = [[[SHNumber alloc] init] autorelease];
	STAssertTrue( [ob value]==[NSNull null], @"Default value must be nil - 'unset'");
}

//=========================================================== 
// testDataTypeFromDisplayObject
//=========================================================== 
- (void) testDataTypeFromDisplayObject
{
	id ob = [SHNumber dataTypeFromDisplayObject:@"10.5"];
	STAssertTrue([ob floatValue]==10.5, @"testDataTypeFromDisplayObject failed");
}

- (void) testNumberWithObject
{
	// + (id) numberWithObject:(id)ob
	id ob = [SHNumber numberWithObject:@"10.5"];
	STAssertTrue([ob floatValue]==10.5, @"testDataTypeFromDisplayObject failed");
}

- (void) testNumberWithInt
{
	// + (id) numberWithInt:(int)intVal
	id ob = [SHNumber numberWithInt:10];
	STAssertTrue([ob intValue]==10, @"testDataTypeFromDisplayObject failed");
}

- (void) testNumberWithFloat
{
	// + (id) numberWithFloat:(float)floatVal
	id ob = [SHNumber numberWithFloat:10.0];
	STAssertTrue([ob floatValue]==10.0, @"testDataTypeFromDisplayObject failed");
}

- (void) testNumberWithBool
{
	// + (id) numberWithBool:(BOOL)boolVal
	id ob = [SHNumber numberWithBool:YES];
	STAssertTrue([ob boolValue]==YES, @"testDataTypeFromDisplayObject failed");
}

#pragma mark init methods
//=========================================================== 
// testInitWithObject
//=========================================================== 
- (void) testInitWithObject
{
	NSNumber* n = [NSNumber numberWithInt:10];
	id ob = [[[SHNumber alloc] initWithObject:n] autorelease];
	STAssertNotNil(ob, @"testInitWithObject failed");
	
	id ob2 = [[[SHNumber alloc] initWithObject:@"10"] autorelease];
	STAssertTrue([ob2 floatValue]==10.0, @"testDataTypeFromDisplayObject failed");
}

//=========================================================== 
// initWithFloat
//=========================================================== 
- (void) testinitWithFloat
{
	id ob = [[[SHNumber alloc] initWithFloat:10.0] autorelease];
	STAssertNotNil(ob, @"initWithFloat failed");
}

//=========================================================== 
// testinitWithBool
//=========================================================== 
- (void) testinitWithBool
{
	id ob = [[[SHNumber alloc] initWithBool:YES] autorelease];
	STAssertNotNil(ob, @"initWithFloat failed");
	STAssertTrue([ob floatValue]==1.0, @"testDataTypeFromDisplayObject failed");
}



//=========================================================== 
// testCopyWithZone
//=========================================================== 
- (void) testCopyWithZone
{
	id ob = [[[SHNumber alloc] initWithFloat:10.0] autorelease];
	id ob2 = [[ob copy] autorelease];
	STAssertTrue([ob floatValue]==[ob2 floatValue], @"testCopyWithZone failed");
}

#pragma mark accessor methods

//=========================================================== 
// testDisplayObject
//=========================================================== 
- (void) testDisplayObject
{	id ob = [[[SHNumber alloc] initWithFloat:10.5] autorelease];
	STAssertTrue([[ob displayObject] isEqualToString:@"10.5"], @"testStringValue failed");
}

//=========================================================== 
// testStringValue
//=========================================================== 
- (void) testStringValue {
	id ob = [[[SHNumber alloc] initWithFloat:10.5] autorelease];
	STAssertTrue([[ob stringValue] isEqualToString:@"10.5"], @"testStringValue failed");
}

//=========================================================== 
// testFloatValue
//=========================================================== 
- (void) testFloatValue {
	id ob = [[[SHNumber alloc] initWithFloat:10.0] autorelease];
	STAssertTrue([ob floatValue]==10.0, @"testFloatValue failed");
}

//=========================================================== 
// testIntValue
//=========================================================== 
- (void) testIntValue {
	// - (int) intValue;
	id ob = [[[SHNumber alloc] initWithInt:15] autorelease];
	STAssertTrue([ob intValue]==15, @"testFloatValue failed");
}

//=========================================================== 
// testBoolValue
//=========================================================== 
- (void) testBoolValue {
	// - (BOOL) boolValue;
	id ob = [[[SHNumber alloc] initWithBool:YES] autorelease];
	STAssertTrue([ob boolValue]==YES, @"testFloatValue failed");
}


//=========================================================== 
// testSaveFScriptString
//=========================================================== 
- (void) testSaveFScriptString
{
	id num1 = [[[SHNumber alloc] initWithFloat:0.5] autorelease];
	NSString* fscriptString = [num1 fScriptSaveString];
	// execute the save strings in fscript
	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: fscriptString];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	if(!result){
		STFail(@"Failed to execute save string");
	}			
	// is it the same
	STAssertTrue([num1 isEqual:result], @"should be roughly the same");
}

//=========================================================== 
// testIsEqualTo
//=========================================================== 
- (void) testIsEqualTo
{
	id num1 = [[[SHNumber alloc] initWithFloat:0.5] autorelease];
	id num2 = [[[SHNumber alloc] initWithFloat:0.5] autorelease];
	id num3 = [[[SHNumber alloc] initWithFloat:0.51] autorelease];
	BOOL result = [num1 isEqual:num2];
	STAssertTrue(result==YES, @"testisEqual failed");
	BOOL result2 = [num1 isEqual:num3];
	STAssertTrue(result2==NO, @"testisEqual failed");
}

@end

