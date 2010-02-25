//
//  SelectedItemTests.m
//  DebugDrawing
//
//  Created by steve hooley on 31/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Star.h"
#import "SelectedItem.h"

@interface SelectedItemTests : SenTestCase {
	
	Star *testStar;
	SelectedItem *selectedItem;
	NodeProxy *proxy;
}

@end

@implementation SelectedItemTests

- (void)setUp {

	testStar = [Star new];
	proxy = [[NodeProxy newNodeProxyWithFilter:nil object:testStar] retain];
	selectedItem = [[SelectedItem alloc] initWithNodeProxy:proxy];
}

- (void)tearDown {

	[selectedItem release];
	[proxy release];
	[testStar release];
}

- (void)testCalculatedPhysicalBoundsOfNodeProxy {
	// + (NSRect)calculatedPhysicalBoundsOfNodeProxy:(NodeProxy *)nProxy;
	
	NSRect originalRect = NSMakeRect(10,10,90,90);
	[testStar setPhysicalBounds:originalRect];
	
	NSRect calculatedBounds = [SelectedItem calculatedPhysicalBoundsOfNodeProxy:proxy];
	STAssertTrue(NSEqualRects(originalRect, calculatedBounds), @"should be simple case of returning stars bounds");

	SHNode *node2 = [SHNode makeChildWithName:@"node2"];
	Star *testStar2 = [[Star new] autorelease];
	[testStar2 setPhysicalBounds:originalRect];
	[node2 addChild:testStar2 undoManager:nil];
	NodeProxy *proxy2 = [NodeProxy newNodeProxyWithFilter:nil object:testStar2];
	NSRect calculatedBounds2 = [SelectedItem calculatedPhysicalBoundsOfNodeProxy:proxy2];
	STAssertTrue(NSEqualRects(originalRect, calculatedBounds2), @"should be simple case of returning stars bounds");
}

//- (void)testBoundsOfEdge {
//	// - (NSRect)boundsOfEdge:(int)edge;
//	
//	NSRect originalRect = NSMakeRect(10,10,90,90);
//	[testStar setPhysicalBounds:originalRect];
//	
//	NSRect hitEdgeNone = [selectedItem boundsOfEdge:SKTGraphicNoHandle];
//	NSRect hitEdgeTop = [selectedItem boundsOfEdge:SKTGraphicTopEdge];
//	NSRect hitEdgeLeft = [selectedItem boundsOfEdge:SKTGraphicLeftEdge];
//	NSRect hitEdgeRight = [selectedItem boundsOfEdge:SKTGraphicRightEdge];
//	NSRect hitEdgeBottom = [selectedItem boundsOfEdge:SKTGraphicBottomEdge];
//	
//	STAssertTrue(NSEqualRects(hitEdgeNone, NSZeroRect), @"oh no %@", NSStringFromRect(hitEdgeNone));
//	
//	STAssertTrue(NSEqualRects(hitEdgeLeft, NSMakeRect(8,10,4,90)), @"oh no %@", NSStringFromRect(hitEdgeLeft));
//	STAssertTrue(NSEqualRects(hitEdgeRight, NSMakeRect(98,8,4,90)), @"oh no %@", NSStringFromRect(hitEdgeRight));
//	STAssertTrue(NSEqualRects(hitEdgeTop, NSMakeRect(10,98,90,4)), @"oh no %@", NSStringFromRect(hitEdgeTop));
//	STAssertTrue(NSEqualRects(hitEdgeBottom, NSMakeRect(10,8,90,4)), @"oh no %@", NSStringFromRect(hitEdgeBottom));
//}

//- (void)testEdgeUnderPoint {
//	//- (NSInteger)edgeUnderPoint:(NSPoint)point 
//
//	NSRect originalRect = NSMakeRect(10,10,90,90);
//	[testStar setPhysicalBounds:originalRect];
//	
//	NSInteger hitEdge1 = [selectedItem edgeUnderPoint:NSMakePoint(20,20)];
//	NSInteger hitEdge2 = [selectedItem edgeUnderPoint:NSMakePoint(50,100)];
//	NSInteger hitEdge3 = [selectedItem edgeUnderPoint:NSMakePoint(10,30)];
//	NSInteger hitEdge4 = [selectedItem edgeUnderPoint:NSMakePoint(100,30)];
//	NSInteger hitEdge5 = [selectedItem edgeUnderPoint:NSMakePoint(30,10)];
//	
//	STAssertTrue(hitEdge1==SKTGraphicNoHandle, @"Blah"); // none
//	STAssertTrue(hitEdge2==SKTGraphicTopEdge, @"Blah %i", hitEdge2); // top
//	STAssertTrue(hitEdge3==SKTGraphicLeftEdge, @"Blah %i", hitEdge3); // left
//	STAssertTrue(hitEdge4==SKTGraphicRightEdge, @"Blah"); // right
//	STAssertTrue(hitEdge5==SKTGraphicBottomEdge, @"Blah %i", hitEdge5); // bottom
//}

- (void)testMoveEdgeByXByX {
	// - (void)moveEdge:(int)edge byX:(CGFloat)xamount byY:(CGFloat)yamount

	NSRect originalRect = NSMakeRect(10,10,90,90);
	[testStar setPhysicalBounds:originalRect];
	
	[selectedItem moveEdge:SKTGraphicLeftEdge byX:5 byY:0];
	STAssertTrue(NSEqualRects([selectedItem physicalBounds], NSMakeRect(15,10,85,90)), @"oh no %@", NSStringFromRect([selectedItem physicalBounds]));

	[selectedItem moveEdge:SKTGraphicTopEdge byX:0 byY:5];
	STAssertTrue(NSEqualRects([selectedItem physicalBounds], NSMakeRect(15,10,85,95)), @"oh no %@", NSStringFromRect([selectedItem physicalBounds]));

	[selectedItem moveEdge:SKTGraphicRightEdge byX:5 byY:0];
	STAssertTrue(NSEqualRects([selectedItem physicalBounds], NSMakeRect(15,10,90,95)), @"oh no %@", NSStringFromRect([selectedItem physicalBounds]));

	[selectedItem moveEdge:SKTGraphicBottomEdge byX:0 byY:5];
	STAssertTrue(NSEqualRects([selectedItem physicalBounds], NSMakeRect(15,15,90,90)), @"oh no %@", NSStringFromRect([selectedItem physicalBounds]));
}

@end
