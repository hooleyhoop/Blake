//
//  NSIndexSet_ExtrasTests.m
//  SHShared
//
//  Created by steve hooley on 30/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//


@interface NSIndexSet_ExtrasTests : SenTestCase {
	
    NSAutoreleasePool *_pool;
	NSMutableIndexSet *_indexset;
}

@end

@implementation NSIndexSet_ExtrasTests

- (void)setUp {
    
    _pool = [[NSAutoreleasePool alloc] init];
	_indexset = [[NSMutableIndexSet indexSet] retain];	
}

- (void)tearDown {

	[_indexset release];
    [_pool drain];
}

- (void)testPositionOfIndex {
	// - (int)positionOfIndex:(int)index
	
	[_indexset addIndexesInRange:NSMakeRange(0, 11)];
	NSUInteger pos = [_indexset positionOfIndex:5];
	STAssertTrue(pos==5, @"WRONG! %i", pos);
}

- (void)testPositionsOfIndexes {
	
	[_indexset addIndex:2];
	[_indexset addIndex:4];
	[_indexset addIndex:6];

	NSMutableIndexSet *testIndexes = [NSMutableIndexSet indexSetWithIndex:2];
	[testIndexes addIndex:6];
	
	NSIndexSet *poss = [_indexset positionsOfIndexes:testIndexes];
	STAssertTrue([poss firstIndex]==0, @"WRONG! %i", [poss firstIndex]);
	STAssertTrue([poss indexGreaterThanIndex:[poss firstIndex]]==2, @"WRONG! %i", [poss indexGreaterThanIndex:[poss firstIndex]]);
}

- (void)testIndexesShiftedBy {
//- (NSMutableIndexSet *)indexesShiftedBy:(NSInteger)shiftAmount

	[_indexset addIndexesInRange:NSMakeRange(5, 2)];
	[_indexset addIndexesInRange:NSMakeRange(10, 2)];

	NSMutableIndexSet *shiftedIndexes = [[_indexset copyIndexesShiftedBy:3] autorelease];
	STAssertTrue( [shiftedIndexes count]==4, @"indexShift failed");

	STAssertTrue( [shiftedIndexes containsIndex:8], @"indexShift failed");
	STAssertTrue( [shiftedIndexes containsIndex:9], @"indexShift failed");
	STAssertTrue( [shiftedIndexes containsIndex:13], @"indexShift failed");
	STAssertTrue( [shiftedIndexes containsIndex:14], @"indexShift failed");
	
	NSMutableIndexSet *shiftedIndexes2 = [[shiftedIndexes copyIndexesShiftedBy:-8] autorelease];
	STAssertTrue( [shiftedIndexes2 containsIndex:0], @"indexShift failed");
	STAssertTrue( [shiftedIndexes2 containsIndex:1], @"indexShift failed");
	STAssertTrue( [shiftedIndexes2 containsIndex:5], @"indexShift failed");
	STAssertTrue( [shiftedIndexes2 containsIndex:6], @"indexShift failed");
}

- (void)testCopyIndexesExcluding {
// - (NSIndexSet *)copyIndexesExcluding:(NSIndexSet *)indexesToExclude
	
	[_indexset addIndexesInRange:NSMakeRange(5, 5)];
	NSIndexSet *someOtherIndexSet = [NSIndexSet indexSetWithIndex:7];
	
	NSIndexSet *resultantIndexSet = [[_indexset copyIndexesExcluding:someOtherIndexSet] autorelease];
	STAssertTrue( [resultantIndexSet count]==4, @"indexShift failed");

	STAssertTrue( [resultantIndexSet containsIndex:5], @"indexShift failed");
	STAssertTrue( [resultantIndexSet containsIndex:6], @"indexShift failed");
	STAssertTrue( [resultantIndexSet containsIndex:8], @"indexShift failed");
	STAssertTrue( [resultantIndexSet containsIndex:9], @"indexShift failed");
}

// This is used when coalescing insertions
- (void)testOffsetAndMerge {
	//- (NSIndexSet *)offsetAndMerge:(NSIndexSet *)value
	
	NSMutableArray *brainCheck = [NSMutableArray array];
	for(NSUInteger i=0; i<10; i++)
		[brainCheck addObject:[NSNull null]];

	// 2, 5, 9
	NSMutableIndexSet *originalSet = [NSMutableIndexSet indexSetWithIndex:2];
	[originalSet addIndex:5];
	[originalSet addIndex:9];
	
	NSObject *ob1 = [[NSObject new] autorelease];
	NSObject *ob2 = [[NSObject new] autorelease];
	NSObject *ob3 = [[NSObject new] autorelease];
	NSArray *firstObjectsToInsert = [NSArray arrayWithObjects:ob1,ob2,ob3,nil];

	[brainCheck insertObjects:firstObjectsToInsert atIndexes:originalSet];
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob1]==2, @"doh");
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob2]==5, @"doh");
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob3]==9, @"doh");

	// 0, 3, 9
	NSMutableIndexSet *newSet = [NSMutableIndexSet indexSetWithIndex:0];
	[newSet addIndex:3];
	[newSet addIndex:9];
	
	NSObject *ob4 = [[NSObject new] autorelease];
	NSObject *ob5 = [[NSObject new] autorelease];
	NSObject *ob6 = [[NSObject new] autorelease];
	NSArray *secondObjectsToInsert = [NSArray arrayWithObjects:ob4,ob5,ob6,nil];
	
	[brainCheck insertObjects:secondObjectsToInsert atIndexes:newSet];
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob4]==0, @"doh");
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob5]==3, @"doh");
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob6]==9, @"doh");
	
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob1]==4, @"doh %i", [brainCheck indexOfObjectIdenticalTo:ob1]);
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob2]==7, @"doh %i", [brainCheck indexOfObjectIdenticalTo:ob2]);
	STAssertTrue([brainCheck indexOfObjectIdenticalTo:ob3]==12, @"doh %i", [brainCheck indexOfObjectIdenticalTo:ob3]);
	
	// 0, 3, .4., .7., 9, .12.
	NSIndexSet *resultSet = [originalSet offsetAndMerge:newSet];
	
	STAssertTrue( [resultSet containsIndex:0], @"doh");
	STAssertTrue( [resultSet containsIndex:3], @"doh");
	STAssertTrue( [resultSet containsIndex:4], @"doh");
	STAssertTrue( [resultSet containsIndex:7], @"doh");
	STAssertTrue( [resultSet containsIndex:9], @"doh");
	STAssertTrue( [resultSet containsIndex:12], @"doh");
}

// This is used when coalescing removals
- (void)testReverseOffsetAndMerge {
	
	// Doesnt look like a reverse offset and merge is needed.
	NSMutableIndexSet *originalSet = [NSMutableIndexSet indexSetWithIndex:2];
	NSIndexSet *resultSet1 = [originalSet reverseOffsetAndMerge:[NSIndexSet indexSetWithIndex:2]];
	NSIndexSet *resultSet2 = [originalSet reverseOffsetAndMerge:[NSIndexSet indexSetWithIndex:1]];
	NSIndexSet *resultSet3 = [originalSet reverseOffsetAndMerge:[NSIndexSet indexSetWithIndex:0]];

	STAssertTrue( [resultSet1 containsIndex:2], @"doh");
	STAssertTrue( [resultSet1 containsIndex:3], @"doh");
	STAssertTrue( [resultSet2 containsIndex:1], @"doh");
	STAssertTrue( [resultSet3 containsIndex:0], @"doh");
	
	NSMutableIndexSet *originalSet2 = [NSMutableIndexSet indexSetWithIndex:1];
	NSIndexSet *resultSet4 = [originalSet2 reverseOffsetAndMerge:[NSIndexSet indexSetWithIndex:0]];
	
	STAssertTrue( [resultSet4 containsIndex:1], @"doh");
	STAssertTrue( [resultSet4 containsIndex:0], @"doh");
}

- (void)testIndexesLessThan {
	// - (NSIndexSet *)indexesLessThan:(NSUInteger)value
	
	NSIndexSet *startSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
	NSIndexSet *cutDown = [startSet indexesLessThan:5];
	STAssertTrue(5==[cutDown count], @"doh!");
	STAssertTrue([cutDown containsIndex:0], @"doh!");
	STAssertTrue([cutDown containsIndex:1], @"doh!");
	STAssertTrue([cutDown containsIndex:2], @"doh!");
	STAssertTrue([cutDown containsIndex:3], @"doh!");
	STAssertTrue([cutDown containsIndex:4], @"doh!");
	
	NSIndexSet *startSet2 = [NSIndexSet indexSetWithIndex:1];
	NSIndexSet *cutDown2 = [startSet2 indexesLessThan:0];
	STAssertTrue(0==[cutDown2 count], @"doh! %i", [cutDown2 count]);
}

- (void)testIndexesGreaterThanOrEqualTo {
	// - (NSIndexSet *)indexesGreaterThanOrEqualTo:(NSUInteger)value
	
	NSIndexSet *startSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,10)];
	NSIndexSet *cutDown = [startSet indexesGreaterThanOrEqualTo:5];
	STAssertTrue(5==[cutDown count], @"doh! %i", [cutDown count]);
	STAssertTrue([cutDown containsIndex:5], @"doh!");
	STAssertTrue([cutDown containsIndex:6], @"doh!");
	STAssertTrue([cutDown containsIndex:7], @"doh!");
	STAssertTrue([cutDown containsIndex:8], @"doh!");
	STAssertTrue([cutDown containsIndex:9], @"doh!");
}

@end
