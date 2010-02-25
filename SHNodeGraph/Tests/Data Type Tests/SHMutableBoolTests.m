//
//  SHMutableBoolTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <FScript/FScript.h>
#import "SHMutableBool.h"



@interface SHMutableBoolTests : SenTestCase {
	
}

@end

/*
 *
*/
@implementation SHMutableBoolTests



// any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
//=========================================================== 
// testWillAsk
//=========================================================== 
- (void) testWillAsk
{	
	STAssertTrue([[SHMutableBool willAsk] isEqualToString:@"SHMutableBool"], @"testWillAsk failed");
}

// however, a single data type might respond to more than one request (string and number, etc.)
//=========================================================== 
// testWillAnswer
//=========================================================== 
- (void) testWillAnswer
{
	NSArray* a = [SHMutableBool willAnswer];
	STAssertTrue([[a objectAtIndex:0] isEqualToString:@"SHMutableBool"], @"testWillAnswer failed");
}

// default value must be nil. ie - 'unset'
- (void)testDefaultValue
{
	SHMutableBool* ob = [[[SHMutableBool alloc] init] autorelease];
	STAssertTrue( [ob value]==[NSNull null], @"Default value must be nil - 'unset'");
}

//=========================================================== 
// testDataTypeFromDisplayObject
//=========================================================== 
- (void) testDataTypeFromDisplayObject
{	
	id ob = [SHMutableBool dataTypeFromDisplayObject:@"YES"];
	STAssertTrue([ob boolValue]==YES, @"testDataTypeFromDisplayObject failed");
	id ob2 = [SHMutableBool dataTypeFromDisplayObject:@"NO"];
	STAssertTrue([ob2 boolValue]==NO, @"testDataTypeFromDisplayObject failed");
}

#pragma mark init methods
//=========================================================== 
// testInitWithObject
//=========================================================== 
- (void) testInitWithObject
{
	id ob1 = [[[SHMutableBool alloc] initWithObject:@"YES"] autorelease];
	id ob2 = [[[SHMutableBool alloc] initWithObject:@"NO"] autorelease];
	id ob3 = [[[SHMutableBool alloc] initWithObject:[NSNumber numberWithInt:1]] autorelease];
	id ob4 = [[[SHMutableBool alloc] initWithObject:[NSNumber numberWithInt:0]] autorelease];
	STAssertTrue([ob1 boolValue]==YES, @"testInitWithObject failed");
	STAssertTrue([ob2 boolValue]==NO, @"testInitWithObject failed");
	STAssertTrue([ob3 boolValue]==YES, @"testInitWithObject failed");
	STAssertTrue([ob4 boolValue]==NO, @"testInitWithObject failed");
}

//=========================================================== 
// testinitWithBool
//=========================================================== 
- (void) testinitWithBool
{
	id ob1 = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id ob2 = [[[SHMutableBool alloc] initWithBool:NO] autorelease];
	STAssertTrue([ob1 boolValue]==YES, @"testinitWithBool failed");
	STAssertTrue([ob2 boolValue]==NO, @"testinitWithBool failed");
}

//=========================================================== 
// testinitWithFloat
//=========================================================== 
- (void) testinitWithFloat
{
	id ob1 = [[[SHMutableBool alloc] initWithFloat:1.0] autorelease];
	id ob2 = [[[SHMutableBool alloc] initWithFloat:999.325648] autorelease];
	id ob3 = [[[SHMutableBool alloc] initWithFloat:-999.325648] autorelease];
	id ob4 = [[[SHMutableBool alloc] initWithFloat:0.0] autorelease];
	STAssertTrue([ob1 boolValue]==YES, @"testinitWithFloat failed");
	STAssertTrue([ob2 boolValue]==YES, @"testinitWithFloat failed");
	STAssertTrue([ob3 boolValue]==YES, @"testinitWithFloat failed");
	STAssertTrue([ob4 boolValue]==NO, @"testinitWithFloat failed");
}

#pragma mark NSCopyopying, hash, isEqual
//=========================================================== 
// testCopyWithZone
//=========================================================== 
- (void) testCopyWithZone
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obYES2 = [obYES duplicate];
	STAssertTrue([obYES isEqual: obYES2], @"testDuplicate failed");
}

//=========================================================== 
// testDuplicate
//=========================================================== 
- (void) testDuplicate
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obYES2 = [obYES duplicate];
	STAssertTrue([obYES isEqual: obYES2], @"testDuplicate failed");
}

//=========================================================== 
// testIsEqual
//=========================================================== 
- (void)testIsEqual
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obYES2 = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obNO = [[[SHMutableBool alloc] initWithBool:NO] autorelease];
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
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	BOOL f = [obYES tryToSetValueWith:@"YES"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==YES, @"testTryToSetValue failed");

	f = [obYES tryToSetValueWith:@"No"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==NO, @"testTryToSetValue failed");

	f = [obYES tryToSetValueWith:@"true"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==YES, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"welly"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:1]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==YES, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:99.99]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==YES, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[NSNumber numberWithInt:0]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==NO, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"4 + 3 - 6"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==YES, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:@"4 + 3 - 7"];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==NO, @"testTryToSetValue failed");
	
	f = [obYES tryToSetValueWith:[@"[4 + 3 - 6]" asBlock]];
	STAssertTrue(f==YES, @"testTryToSetValue failed");
	STAssertTrue([obYES boolValue]==YES, @"testTryToSetValue failed");
}

#pragma mark accessor methods
/*	The required 'willAnswer' method for this dataType 
	NOTE: This value should'nt be modifyied internally unless you know what you are doing
	An operator wont modify it's input values */
//=========================================================== 
// testSHMutableBool
//=========================================================== 
- (void) testSHMutableBool
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id ob2 = [obYES SHMutableBool];
	STAssertTrue(ob2 == obYES, @"testSHMutableBool failed");
}

- (void) testSHNumber
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id ob2 = [obYES SHNumber];
	STAssertTrue([ob2 floatValue]==1.0, @"testSHNumber failed");
}

//=========================================================== 
// testBoolValue
//=========================================================== 
- (void) testBoolValue
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obNO = [[[SHMutableBool alloc] initWithBool:NO] autorelease];
	STAssertTrue([obYES boolValue]==YES, @"testBoolValue failed");
	STAssertTrue([obNO boolValue]==NO, @"testBoolValue failed");
}

//=========================================================== 
// testStringValue
//=========================================================== 
- (void) testStringValue
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obNO = [[[SHMutableBool alloc] initWithBool:NO] autorelease];
	STAssertTrue([[obYES stringValue] isEqualToString:@"YES"], @"testStringValue failed");
	STAssertTrue([[obNO stringValue] isEqualToString:@"NO"], @"testStringValue failed");
}

//=========================================================== 
// testFloatValue
//=========================================================== 
- (void) testFloatValue
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obNO = [[[SHMutableBool alloc] initWithBool:NO] autorelease];
	STAssertTrue([obYES floatValue] == 1.0, @"testFloatValue failed");
	STAssertTrue([obNO floatValue] == 0, @"testFloatValue failed");
}

//=========================================================== 
// testDisplayObject
//=========================================================== 
- (void) testDisplayObject
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obNO = [[[SHMutableBool alloc] initWithBool:NO] autorelease];
	STAssertTrue([[obYES displayObject] isEqualToString:@"YES"], @"testStringValue failed");
	STAssertTrue([[obNO displayObject] isEqualToString:@"NO"], @"testStringValue failed");
}

//=========================================================== 
// testFScriptSaveString
//=========================================================== 
- (void) testFScriptSaveString
{
	id obYES = [[[SHMutableBool alloc] initWithBool:YES] autorelease];
	id obNO = [[[SHMutableBool alloc] initWithBool:NO] autorelease];

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
