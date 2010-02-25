//
//  SHCustomMutableArrayTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/SHNodeGraph.h>
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHNode.h"
#import "SHConnectableNode.h"
#import "SHNodeAttributeMethods.h"
#import "SH_Path.h"
#import "SHConnectlet.h"
#import "SHInterConnector.h"
#import "SHCustomMutableArray.h"

@interface SHCustomMutableArrayTests : SenTestCase {
	
	SHNode					*_rootNode;
	SHCustomMutableArray	*_customArray;
}

@end

@implementation SHCustomMutableArrayTests


- (void)setUp {

	_rootNode = [[SHNode makeChildWithName:@"root"] retain];

	_customArray = [[SHCustomMutableArray alloc] init];
	_customArray.node = _rootNode;
}

- (void)tearDown {
	[_customArray release];
	[_rootNode release];
}

- (void)addObjects {
	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_rootNode addChild:childnode undoManager:nil];
	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"i1"];
	SHOutputAttribute* o1 = [SHOutputAttribute makeChildWithName:@"o1"];
	[_rootNode addChild:i1 undoManager:nil];
	[_rootNode addChild:o1 undoManager:nil];
	SHInterConnector* int1 = [_rootNode connectOutletOfAttribute:i1 toInletOfAttribute:o1 undoManager:nil];
	STAssertNotNil(int1, @"eh");
}

- (void)testCount {
	// - (unsigned)count
	
	STAssertTrue([_customArray count]==0, @"Haven't added any objects yet! %i", [_customArray count]);
	[self addObjects];
	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
}

- (void)testObjectAtIndex {
	// - (id)objectAtIndex:(NSUInteger)oindex
	
	[self addObjects];
	id ob1 = [_customArray objectAtIndex:0];
	id ob2 = [_customArray objectAtIndex:1];
	id ob3 = [_customArray objectAtIndex:2];
	id ob4 = [_customArray objectAtIndex:3];
	STAssertTrue([[[ob1 name] value] isEqualToString:@"n1"], @"doh");
	STAssertTrue([[[ob2 name] value] isEqualToString:@"i1"], @"doh");
	STAssertTrue([[[ob3 name] value] isEqualToString:@"o1"], @"doh");
	STAssertTrue([ob4 isKindOfClass:[SHInterConnector class]], @"doh");
}

- (void)testInsertObjectAtIndex {
	// - (void)insertObject:(id)anObject atIndex:(NSUInteger)oindex
	
	[self addObjects];
	SHNode* insertnode = [SHNode makeChildWithName:@"insert"];
	[_customArray insertObject:insertnode atIndex:1];
	STAssertTrue([_customArray count]==5, @"Now i have %i", [_customArray count]);
	id ob1 = [_customArray objectAtIndex:0];
	id ob2 = [_customArray objectAtIndex:1];
	id ob3 = [_customArray objectAtIndex:2];
	STAssertTrue([[[ob1 name] value] isEqualToString:@"n1"], @"doh");
	STAssertTrue([[[ob2 name] value] isEqualToString:@"insert"], @"doh");
	STAssertTrue([[[ob3 name] value] isEqualToString:@"i1"], @"doh");
}

- (void)testRemoveObjectAtIndex {
	// - (void)removeObjectAtIndex:(NSUInteger)oindex
	
	[self addObjects];
	[_customArray removeObjectAtIndex:0];
	STAssertTrue([_customArray count]==3, @"Now i have %i", [_customArray count]);
	id ob1 = [_customArray objectAtIndex:0];
	id ob2 = [_customArray objectAtIndex:1];
	id ob3 = [_customArray objectAtIndex:2];
	STAssertTrue([[[ob1 name] value] isEqualToString:@"i1"], @"doh");
	STAssertTrue([[[ob2 name] value] isEqualToString:@"o1"], @"doh");
	STAssertTrue([ob3 isKindOfClass:[SHInterConnector class]], @"doh");
}

- (void)testAddObject {
	// - (void)addObject:(id)anObject
	
	[self addObjects];
	SHNode* insertnode = [SHNode makeChildWithName:@"insert"];
	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
	[_customArray addObject:insertnode];
	STAssertTrue([_customArray count]==5, @"Now i have %i", [_customArray count]);
	id ob1 = [_customArray objectAtIndex:0];
	id ob2 = [_customArray objectAtIndex:1];
	id ob3 = [_customArray objectAtIndex:2];
	STAssertTrue([[[ob1 name] value] isEqualToString:@"n1"], @"doh");
	STAssertTrue([[[ob2 name] value] isEqualToString:@"insert"], @"doh");
	STAssertTrue([[[ob3 name] value] isEqualToString:@"i1"], @"doh");
}

- (void)testGetARealArrayBack {

	[self addObjects];
	NSUInteger preCount = [_customArray count];

	NSArray *immutableCopy1 = [NSArray arrayWithArray:_customArray];
	NSArray *immutableCopy2 = [[_customArray copy] autorelease];
	
	SHNode* insertnode = [SHNode makeChildWithName:@"insert"];
	[_customArray addObject:insertnode];

	STAssertTrue([_customArray count]==preCount+1, @"woah");
	STAssertTrue([immutableCopy1 count]==preCount, @"woah");
	STAssertTrue([immutableCopy2 count]==preCount, @"woah");
}

- (void)testReplaceObjectsInRangeWithObjectsFromArray {
	// - (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray
	
//	[self addObjects];
//	SHNode* insertnode = [SHNode makeChildWithName:@"insert"];
//	[_customArray replaceObjectsInRange:NSMakeRange(0, 1) withObjectsFromArray:[NSArray arrayWithObject:insertnode]];
//	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
//	id ob1 = [_customArray objectAtIndex:0];
//	id ob2 = [_customArray objectAtIndex:1];
//	id ob3 = [_customArray objectAtIndex:2];
//	STAssertTrue([[[ob1 name] value] isEqualToString:@"insert"], @"doh");
//	STAssertTrue([[[ob2 name] value] isEqualToString:@"i1"], @"doh");
//	STAssertTrue([[[ob3 name] value] isEqualToString:@"o1"], @"doh");
}

- (void)testReplaceObjectAtIndex {
	// - (void)replaceObjectAtIndex:(NSUInteger)oindex withObject:(id)anObject
	
//	[self addObjects];
//	SHNode* insertnode = [SHNode makeChildWithName:@"insert"];
//	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"inserti1"];
//	SHOutputAttribute* o1 = [SHOutputAttribute makeChildWithName:@"inserto1"];
//	
//	[_customArray replaceObjectAtIndex:0 withObject:insertnode];
//	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
//	id ob1 = [_customArray objectAtIndex:0];
//	id ob2 = [_customArray objectAtIndex:1];
//	id ob3 = [_customArray objectAtIndex:2];
//	STAssertTrue([[[ob1 name] value] isEqualToString:@"insert"], @"doh");
//	STAssertTrue([[[ob2 name] value] isEqualToString:@"i1"], @"doh");
//	STAssertTrue([[[ob3 name] value] isEqualToString:@"o1"], @"doh");
//	
//	[_customArray replaceObjectAtIndex:1 withObject:i1];
//	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
//	STAssertTrue([[[[_customArray objectAtIndex:1] name] value] isEqualToString:@"inserti1"], @"doh");
//
//	[_customArray replaceObjectAtIndex:2 withObject:o1];
//	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
//	STAssertTrue([[[[_customArray objectAtIndex:2] name] value] isEqualToString:@"inserto1"], @"doh");
//	
//	[_customArray replaceObjectAtIndex:3 withObject:[NSNull null]];
//	STAssertTrue([_customArray count]==4, @"Now i have %i", [_customArray count]);
//	STAssertTrue([_customArray objectAtIndex:3]==[NSNull null], @"doh");
//
//	STAssertThrows(	[_customArray replaceObjectAtIndex:4 withObject:[NSNull null]], @"should be out of range");
}


#pragma mark - These are not to be used 
- (void)testRemoveLastObject {
	// - (void)removeLastObject
	
	STAssertThrows([_customArray removeLastObject], @"doh");
}

- (void)testAddObjectsFromArray {
	// - (void)addObjectsFromArray:(NSArray *)otherArray
	
	STAssertThrows([_customArray addObjectsFromArray:nil], @"doh");
}

- (void)testExchangeObjectAtIndexWithObjectAtIndex {
	// - (void)exchangeObjectAtIndex:(unsigned)idx1 withObjectAtIndex:(unsigned)idx2
	
	STAssertThrows([_customArray exchangeObjectAtIndex:0 withObjectAtIndex:0], @"doh");
}

- (void)testRemoveAllObjects {
	// - (void)removeAllObjects
	
	STAssertThrows([_customArray removeAllObjects], @"doh");
}

- (void)testRemoveObjectInRange {
	// - (void)removeObject:(id)anObject inRange:(NSRange)range
	
	STAssertThrows([_customArray removeObject:nil inRange:NSMakeRange(0, 1)], @"doh");
}

- (void)testRemoveObject {
	// - (void)removeObject:(id)anObject
	
	STAssertThrows([_customArray removeObject:nil], @"doh");
}

- (void)testRemoveObjectsFromIndices {
	// - (void)removeObjectsFromIndices:(unsigned *)indices numIndices:(unsigned)count
	
	STAssertThrows([_customArray removeObjectsFromIndices:0 numIndices:0], @"doh");
}

- (void)testRemoveObjectsInArray {
	// - (void)removeObjectsInArray:(NSArray *)otherArray
	
	STAssertThrows([_customArray removeObjectsInArray:nil], @"doh");
}

- (void)testRemoveObjectsInRange {
	//- (void)removeObjectsInRange:(NSRange)range
	
	STAssertThrows([_customArray removeObjectsInRange:NSMakeRange(0, 1)], @"doh");
}

- (void)testSetArray {
	// - (void)setArray:(NSArray *)otherArray
	
	STAssertThrows([_customArray setArray:nil], @"doh");
}

- (void)testSortUsingFunctionContext {
	// - (void)sortUsingFunction:(int (*)(id, id, void *))compare context:(void *)context
	
	STAssertThrows([_customArray sortUsingFunction:nil context:nil], @"doh");
}

- (void)testSortUsingSelector {
	// - (void)sortUsingSelector:(SEL)comparator
	
	STAssertThrows([_customArray sortUsingSelector:nil], @"doh");
}

- (void)testInsertObjectsAtIndexes {
	// - (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
	
	STAssertThrows([_customArray insertObjects:nil atIndexes:nil], @"doh");
}

- (void)testRemoveObjectsAtIndexes {
	// - (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
	
	STAssertThrows([_customArray removeObjectsAtIndexes:nil], @"doh");
}

- (void)testReplaceObjectsAtIndexesWithObjects {
	// - (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects
	
	STAssertThrows([_customArray replaceObjectsAtIndexes:nil withObjects:nil], @"doh");
}

@end
