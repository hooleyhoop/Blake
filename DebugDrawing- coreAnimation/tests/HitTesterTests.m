//
//  HitTesterTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 7/12/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "Star.h"
#import "StarScene.h"
#import "HitTester.h"
#import "TestUtilities.h"
#import "iAmTransformableProtocol.h"
#import "HitTestContext.h"
#import "Tool.h"

@interface HitTesterTests : SenTestCase {
	
	SHNodeGraphModel	*_model;
	StarScene			*_scene;
	HitTester			*_hitTester;
}

@end

@implementation HitTesterTests

- (void)setUp {
	
	_model = [[SHNodeGraphModel makeEmptyModel] retain];
	_scene = [StarScene new];
	_scene.model = _model;
	NSAssert(_scene.currentProxy!=nil, @"no current proxy");
	_hitTester = [[HitTester alloc] initWithScene:_scene];
}

- (void)tearDown {

	_scene.model = nil;
	[_scene release];
	[_model release];
	[_hitTester release];
}

- (void)testRoughHitTestDrawingBoundsOfWithContext {
	// + (BOOL)roughHitTestDrawingBoundsOf:(Graphic *)each withContext:(HitTestContext *)hitTestCntxt

	OCMockObject *mockTool = MOCKFORPROTOCOL(iAmDrawableProtocol);
	OCMockObject *mockContext = [OCMockObject mockForClass:[HitTestContext class]];
	
	CGContextRef currentContext = [[NSGraphicsContext currentContext] graphicsPort];
	
	[[[mockContext expect] andReturnValue:OCMOCK_VALUE(currentContext)] offScreenCntx];

	CGRect rectToReturn = CGRectMake(5,5,10,10);
	[[[mockTool expect] andReturnValue:OCMOCK_VALUE(rectToReturn)] didDrawAt:currentContext];
	
	[[[mockContext expect] andReturnValue:OCMOCK_VALUE(expectedPositiveValue)] rectIntersectsRect:rectToReturn];

	BOOL didHit = [HitTester roughHitTestDrawingBoundsOf:(id)mockTool withContext:(id)mockContext];
	STAssertTrue( didHit, @"oops" );
	
	[mockTool verify];
	[mockContext verify];
}

- (void)testNodeUnderPointInView {
	//- (SHNode *)nodeUnderPoint:(NSPoint)pt

	// very simple case
	Star *star1 = [Star makeChildWithName:@"star1"];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	star1.geometryRect = CGRectMake(0,0,10,10);
	[star1 setPosition:CGPointMake(0,0)];	
	[star1 enforceConsistentState];

	SHNode *hitNode = [_hitTester nodeUnderPoint:NSMakePoint(5, 5)];
	STAssertTrue(hitNode==star1, @"eh?");

	// -- test the order of returned hits
	Star *star2 = [Star makeChildWithName:@"star2"];
	[_model NEW_addChild:star2 toNode:_model.rootNodeGroup atIndex:1];
	star2.geometryRect = CGRectMake(0,0,10,10);
	[star2 setPosition:CGPointMake(0,0)];	
	[star2 enforceConsistentState];

	SHNode *hitNode2 = [_hitTester nodeUnderPoint:NSMakePoint(5, 5)];
	STAssertTrue( hitNode2==star2, @"eh?");
	
	// more complex case
	// current node is still root but can we click a child?
	STAssertTrue( _model.rootNodeGroup==_model.currentNodeGroup, @"oops");
	
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	Star *star3 = [Star makeChildWithName:@"star3"];
	[node1 addChild:star3 undoManager:nil];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[star3 setGeometryRect:CGRectMake(0,0,10,10)];
    [star3 setPosition:CGPointMake(100,100)];
	[star3 enforceConsistentState];
	
	SHNode *hitNode3 = [_hitTester nodeUnderPoint:NSMakePoint(105, 105)];
	STAssertTrue( hitNode3==node1, @"failed to hit test a child star");
	
//	[_model setCurrentNodeGroup:node1];
}

- (void)testIndexesOfGraphicsIntersectingRect {
	//- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(NSRect)rect 

	Star *star1 = [Star makeChildWithName:@"star1"];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	star1.geometryRect = CGRectMake(0,0,10,10);
	[star1 setPosition:CGPointMake(0,0)];	
	[star1 enforceConsistentState];

	// -- test the order of returned hits
	Star *star2 = [Star makeChildWithName:@"star2"];
	[_model NEW_addChild:star2 toNode:_model.rootNodeGroup atIndex:1];
	star2.geometryRect = CGRectMake(0,0,10,10);
	[star2 setPosition:CGPointMake(0,0)];	
	[star2 enforceConsistentState];

	NSIndexSet *hitIndexes = [_hitTester indexesOfGraphicsIntersectingRect:CGRectMake(0, 0, 10, 10)];
	STAssertTrue( [hitIndexes count]==2, @"should have hit two stars %i", [hitIndexes count] );

	// more complex case
	// current node is still root but can we click a child?
	// add some children..
	STAssertTrue( _model.rootNodeGroup==_model.currentNodeGroup, @"oops");
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	Star *star3 = [Star makeChildWithName:@"star3"];
	[node1 addChild:star3 undoManager:nil];
	[_model NEW_addChild:node1 toNode:_model.rootNodeGroup atIndex:2];
	[star3 setGeometryRect:CGRectMake(0,0,10,10)];
    [star3 setPosition:CGPointMake(100,100)];
	[star3 enforceConsistentState];

	NSIndexSet *hitIndexes2 = [_hitTester indexesOfGraphicsIntersectingRect:CGRectMake(105, 105, 10, 10)];
	STAssertTrue( [hitIndexes2 count]==1, @"should have hit a stars %i", [hitIndexes2 count] );
	STAssertTrue( [hitIndexes2 firstIndex]==2, @"doh %i", [hitIndexes2 firstIndex]);
	
	NSIndexSet *hitIndexes3 = [_hitTester indexesOfGraphicsIntersectingRect:CGRectMake(5, 5, 101, 101)];
	STAssertTrue( [hitIndexes3 count]==3, @"should have hit a stars %i", [hitIndexes3 count] );
}

// for a tool layer
- (void)testHitTestTool {
	// - (void)hitTestTool:(Tool *)aTool atPoint:(NSPoint)pt pixelColours:(CGFloat *)cols

	OCMockObject *mockTool = MOCKFORPROTOCOL(iAmDrawableProtocol);
	[[mockTool expect] _setupDrawing:[OCMArg anyPointer]];
	[[mockTool expect] _tearDownDrawing:[OCMArg anyPointer]];

	CGRect expectedReturnRect = CGRectMake(10,10,10,10);
	[[[mockTool expect] andReturnValue:OCMOCK_VALUE(expectedReturnRect)] didDrawAt:[OCMArg anyPointer]];

	unsigned char pixelColours[4];
	NSPoint hitPoint = NSMakePoint(10,10);
	
	[_hitTester hitTestTool:(id)mockTool atPoint:hitPoint pixelColours:pixelColours];
	STAssertTrue( pixelColours[0]==0, @"doh %u",  (NSUInteger)pixelColours[0]);
	STAssertTrue( pixelColours[1]==0, @"doh %u",  (NSUInteger)pixelColours[1]);
	STAssertTrue( pixelColours[2]==0, @"doh %u",  (NSUInteger)pixelColours[2]);
	STAssertTrue( pixelColours[3]==0, @"doh %u",  (NSUInteger)pixelColours[3]);
	
	[mockTool verify];
}

@end
