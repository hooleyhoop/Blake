//
//  NSArray_ExtensionsTests.m
//  SHShared
//
//  Created by steve hooley on 04/03/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface NSArray_ExtensionsTests : SenTestCase {
	
	NSMutableArray *_array;
}

@end


@implementation NSArray_ExtensionsTests

- (void)setUp {
	_array = [[NSMutableArray array] retain];
}

- (void)tearDown {
	[_array release];
}

- (void)testIsEquivalentTo {
		
	NSMutableArray *array2 = [NSMutableArray array];

	id mock1 = [OCMockObject mockForClass:[SHooleyObject class]];
	id mock2 = [OCMockObject mockForClass:[SHooleyObject class]];
	[_array addObject:mock1];
	[array2 addObject:mock2];

	/* OCMOCK TESTS */
//	id mockArgument = [OCMockObject mockForClass:[NSObject class]];
//	id mockObject = [OCMockObject mockForClass:[NSObject class]];
//	BOOL equalityTestResult=YES;
//	[[[mockObject stub] andReturnValue:OCMOCK_VALUE(equalityTestResult)] isEqual:mockArgument];
//	BOOL result = [mockObject isEqual:mockArgument];
//	STAssertTrue(result, @"eh?");

	[[[mock1 expect] andReturnBOOLValue:YES] isEquivalentTo:mock2];
	BOOL equivalence = [mock1 isEquivalentTo:mock2];
	STAssertTrue( equivalence, @"OCMock tests failed");
	/* End OCMock Tests */
	
	[[[mock1 expect] andReturnBOOLValue:YES] isEquivalentTo:mock2];
	STAssertTrue([_array isEquivalentTo:array2], @"Should be");
	[mock1 verify];
}

- (void)testContainsObjectIdenticalTo {
	// - (BOOL)containsObjectIdenticalTo:(id)obj
	
	OCMockObject *mock1 = [OCMockObject mockForClass:[NSObject class]];
	NSMutableArray *array2 = [NSArray arrayWithObject:mock1];
	STAssertTrue([array2 containsObjectIdenticalTo:mock1], @"nuts");
}

- (void)testItemsThatRespondToSelector {
	// - (NSMutableArray *)itemsThatRespondToSelector:(SEL)aSelector

	NSMutableArray *array2 = [NSArray arrayWithObjects:self, [NSNull null], @"steve", nil];
	NSMutableArray *results = [array2 itemsThatRespondToSelector:@selector(setUp)];
	STAssertTrue([results count]==1, @"nope");
	STAssertTrue([results objectAtIndex:0]==self, @"nope");
}

- (void)testItemsThatResultOfSelectorIsNotNIL {
	// - (NSMutableArray *)itemsThatResultOfSelectorIsNotNIL:(SEL)aSelector
	
	NSMutableArray *array2 = [NSArray arrayWithObjects:self, [NSNull null], @"steve", nil];
	NSMutableArray *results = [array2 itemsThatResultOfSelectorIsNotNIL:@selector(uppercaseString)];
	STAssertTrue([results count]==1, @"nope");
	STAssertTrue([results objectAtIndex:0]==@"steve", @"nope");
}

- (void)testCollectResultsOfSelector {
	// - (NSMutableArray *)collectResultsOfSelector:(SEL)aSelector

	NSMutableArray *array2 = [NSArray arrayWithObjects:self, [NSNull null], @"steve", nil];
	NSMutableArray *results = [array2 collectResultsOfSelector:@selector(uppercaseString)];
	STAssertTrue([results count]==1, @"nope");
	STAssertTrue([[results objectAtIndex:0] isEqual:@"STEVE"], @"nope");
}

// need this for below
- (NSNumber *)giveMeABoolWrappedAsANumber:(id)value { return [NSNumber numberWithBool:YES]; }

- (void)testItemsThatResultOfSelectorIsTrue {
	// - (NSMutableArray *)itemsThatResultOfSelectorIsTrue:(SEL)aSelector withObject:(id)value

	NSMutableArray *array2 = [NSArray arrayWithObjects:self, [NSNull null], @"steve", nil];
	NSMutableArray *results = [array2 itemsThatResultOfSelectorIsTrue:@selector(giveMeABoolWrappedAsANumber:) withObject:@"steve"];
	STAssertTrue([results count]==1, @"nope");
	STAssertTrue([[results objectAtIndex:0] isEqual:self], @"nope");
}

- (void)testFirstItemThatResultOfSelectorIsTrue {
	// - (id)firstItemThatResultOfSelectorIsTrue:(SEL)aSelector withObject:(id)value

	NSMutableArray *array2 = [NSArray arrayWithObjects:self, [NSNull null], @"steve", nil];
	id ob = [array2 firstItemThatResultOfSelectorIsTrue:@selector(isEqualToString:) withObject:@"steve"];
	STAssertTrue([ob isEqual:@"steve"], @"nope");
}

- (void)testInsertObjectsFromArray {
	// - (void)insertObjectsFromArray:(NSArray *)array atIndex:(int)oindex

	NSMutableArray *array2 = [NSMutableArray arrayWithObjects:self, [NSNull null], @"steve", nil];
	NSArray *array3 = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
	[array2 insertObjectsFromArray:array3 atIndex:2];
	
	STAssertTrue( [array2 count]==6, @"doh");
	STAssertTrue( [array2 objectAtIndex:0]==self, @"doh");
	STAssertTrue( [array2 objectAtIndex:1]==[NSNull null], @"doh");
	STAssertTrue( [array2 objectAtIndex:2]==@"a", @"doh");
	STAssertTrue( [array2 objectAtIndex:3]==@"b", @"doh");
	STAssertTrue( [array2 objectAtIndex:4]==@"c", @"doh");
	STAssertTrue( [array2 objectAtIndex:5]==@"steve", @"doh");
}

@end
