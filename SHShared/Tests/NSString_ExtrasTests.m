//
//  NSString_ExtrasTests.m
//  Shared
//
//  Created by Steve Hooley on 28/07/2006.
//  Copyright (c) 2006 HooleyHoop. All rights reserved.
//


@interface NSString_ExtrasTests : SenTestCase {
	
}

@end

@implementation NSString_ExtrasTests


- (void)setUp {

}

- (void)tearDown {
}

- (void)testStringWithBOOL {
// - (id)stringWithBOOL:(BOOL)value
	
	NSString *string1 = [NSString stringWithBOOL:YES];
	NSString *string2 = [NSString stringWithBOOL:NO];
	STAssertTrue( [string1 isEqualToString:@"YES"], @"what a balls up");
	STAssertTrue( [string2 isEqualToString:@"NO"], @"what a balls up");
	STAssertTrue( [string1 boolValue]==YES, @"what a balls up");
	STAssertTrue( [string2 boolValue]==NO, @"what a balls up");
}

- (void)testFirstCharacter {
	// - (unichar)firstCharacter

	NSString* aString = @"JimmyJammy";
	STAssertTrue( [aString firstCharacter]=='J', @"Doh" );
	
	STAssertTrue( [@"" firstCharacter]=='\0', @"Doh" );
}

- (void)testSortIntoLines {
	//- void sortIntoLines( NSString* fileContents, NSMutableArray* allLines )
	
	NSMutableArray* allLines = [NSMutableArray array];
	NSString *original = @"hello\nmonkey";
	sortIntoLines( original, allLines );
	STAssertTrue( [allLines count]==2, @"doh");
}

- (void)testContainsString {
	// - (BOOL)containsString:(NSString *)aString
	
	STAssertTrue([@"adohby" containsString:@"doh"], @"should");
	STAssertFalse([@"adohby" containsString:@"dob"], @"should not");
}

- (void)testOccurrencesOfString {
	// - (NSUInteger) occurrencesOfString:(NSString*)subString

	STAssertTrue([@"adohby" occurrencesOfString:@"doh"]==1, @"should");
	STAssertTrue([@"adohbydohn" occurrencesOfString:@"doh"]==2, @"should");
	STAssertTrue([@"brazen" occurrencesOfString:@"doh"]==0, @"should");
}


- (void)testLastLine {
	// - (NSString *)lastLine
	
	NSString* saveString1 = @"aNode := SHNode alloc init .";
	saveString1 = [saveString1 stringByAppendingString:@"aNode setName:'node1' . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"nodeToAddTo := aNode . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"aNode := SHNode alloc init . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"aNode setName:'SHNode1' . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"aNode . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"nodeToAddTo addChildNode:aNode  . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"aNode . \n"];
	saveString1 = [saveString1 stringByAppendingString:@"\n"];

	NSString* lastLine = [saveString1 lastLineNoWhiteSpace];
	STAssertFalse( [lastLine isEqualToString:@"aNode . \n"], @"string should be equal but is %@", lastLine );
	STAssertTrue( [lastLine isEqualToString:@"aNode ."], @"string should be equal but is %@", lastLine );
	STAssertTrue( [[saveString1 firstWordOfLastLine]isEqualToString:@"aNode"], @"string should be equal but is %@", lastLine );

}

- (void)testIsNumber {

	NSNumber* result;
	NSString* t1 = @"1234";
	BOOL flag = [t1 isNumber:&result];
	STAssertTrue( flag==YES, @"testIsNumber failed is %u", flag );
	STAssertTrue( [result intValue]==1234, @"testIsNumber failed is %i",  [result intValue]);

	t1 = @"10.1234";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==YES, @"testIsNumber failed" );
	STAssertTrue( [result isEqualToNumber:[NSNumber numberWithDouble:10.1234]],  @"testIsNumber failed is %f",  [result floatValue] );	

	t1 = @"1.1";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==YES, @"testIsNumber failed is %u", flag );
	STAssertTrue( [result isEqualToNumber:[NSNumber numberWithDouble:1.1]],  @"testIsNumber failed is %f",  [result floatValue] );	

	t1 = @"-7";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==YES, @"testIsNumber failed is %u", flag );
	STAssertTrue( [result isEqualToNumber:[NSNumber numberWithInt:-7]],  @"testIsNumber failed is %i",  [result intValue] );	
	
	t1 = @"-7.987456321456987";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==YES, @"testIsNumber failed is %u", flag );
	STAssertTrue( [result isEqualToNumber:[NSNumber numberWithDouble:-7.987456321456987]],  @"testIsNumber failed is %f",  [result floatValue] );	
	
	t1 = @"+7.987456321456987";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==YES, @"testIsNumber failed is %u", flag );
	STAssertTrue( [result isEqualToNumber:[NSNumber numberWithDouble:+7.987456321456987]],  @"testIsNumber failed is %f",  [result floatValue] );	

	t1 = @"+7.98745632145698+7";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==NO, @"testIsNumber failed is %u", flag );

	t1 = @"7.";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==NO, @"testIsNumber failed is %u", flag );

	t1 = @"+7.9874563214569.87";
	flag = [t1 isNumber:&result];
	STAssertTrue( flag==NO, @"testIsNumber failed is %u", flag );
}

- (void)testRemoveLastCharacter {
	// - (NSString *)removeLastCharacter
	
	NSString *testString1 = [@"Steven" removeLastCharacter];
	STAssertTrue( [testString1 isEqualToString:@"Steve"], @"arggh %@", testString1);
	
	NSString *testString2 = [@"aMethod:" removeLastCharacter];
	STAssertTrue( [testString2 isEqualToString:@"aMethod"], @"arggh %@", testString2);
}

- (void)testMakeFirstCharUppercase {
	// - (NSString *)makeFirstCharUppercase
	
	NSString *testString1 = [@"steven" makeFirstCharUppercase];
	STAssertTrue( [testString1 isEqualToString:@"Steven"], @"arggh %@", testString1);
	
	NSString *testString2 = [@"aMethod" makeFirstCharUppercase];
	STAssertTrue( [testString2 isEqualToString:@"AMethod"], @"arggh %@", testString2);
}

- (void)testPrepend {
	// - (NSString *)prepend:(NSString *)value

	NSString *testString1 = [@"steven" prepend:@"Hello"];
	STAssertTrue( [testString1 isEqualToString:@"Hellosteven"], @"arggh %@", testString1);
	
	NSString *testString2 = [@"aMethod" prepend:@"Hello"];
	STAssertTrue( [testString2 isEqualToString:@"HelloaMethod"], @"arggh %@", testString2);
}

- (void)testAppend {

	NSString *testString1 = [@"steven" append:@"Hello"];
	STAssertTrue( [testString1 isEqualToString:@"stevenHello"], @"arggh %@", testString1);
	
	NSString *testString2 = [@"aMethod" append:@"Hello"];
	STAssertTrue( [testString2 isEqualToString:@"aMethodHello"], @"arggh %@", testString2);
}

- (void)testBeginsWith {

	STAssertTrue( [@"stevenHello" beginsWith:@"steven"], @"arggh");
	STAssertTrue( [@"astevenHello" beginsWith:@"aste"], @"arggh");
	STAssertFalse( [@"astevenHello" beginsWith:@"aaste"], @"arggh");
	STAssertFalse( [@"astevenHello" beginsWith:@" astevenHello"], @"arggh");
}

@end
