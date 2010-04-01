//
//  SelectionWandTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 1/11/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "SelectionWand.h"
#import "StarScene.h"
#import "Graphic.h"
#import "TestUtilities.h"
#import "Star.h"
#import "CALayerStarView.h"
#import "SelectingSceneManipulation.h"
#import "SwappedInIvar.h"
#import "SelectingSceneManipulation.h"
#import "DomainContext.h"
#import "SelectingSceneManipulation.h"

@interface SelectionWandTests : SenTestCase {
	
	SelectionWand				*_selectTool;
	OCMockObject				*_mockDomain;
	OCMockObject				*_mockSelectionHelper;
}

@end

@implementation SelectionWandTests

- (void)setUp {

	_mockDomain = [MOCK(DomainContext) retain];
	_mockSelectionHelper = [MOCK(SelectingSceneManipulation) retain];
	
	_selectTool = [[SelectionWand alloc] initWithDomainContext:(id)_mockDomain selectionHelper:(id)_mockSelectionHelper];
}

- (void)tearDown {

	[_selectTool release];
	[_mockDomain release];
	[_mockSelectionHelper release];
}

- (void)testMarqueeSelectionBoundsFromPointToPoint {
	// + (CGRect)marqueeSelectionBoundsFromPoint:(NSPoint)point1 toPoint:(NSPoint)point2

	NSPoint p1 = NSMakePoint(10,10);
	NSPoint p2 = NSMakePoint(20,20);
	CGRect smallestBounds1 = [SelectionWand marqueeSelectionBoundsFromPoint:p1 toPoint:p2];
	STAssertTrue( CGRectEqualToRect(smallestBounds1, CGRectMake(10,10,10,10)), @"hm, what?");
	
	NSPoint p3 = NSMakePoint(11,11);
	CGRect smallestBounds2 = [SelectionWand marqueeSelectionBoundsFromPoint:p1 toPoint:p3];
	STAssertTrue( CGRectEqualToRect(smallestBounds2, CGRectMake(10,10,2,2)), @"hm, what?");
}

- (void)testDidClickOnGraphicModifyingExistingSelection {
	// - (void)didClickOnGraphic:(SHNode *)graphic modifyingExistingSelection:(BOOL)isModifyingSelection

	OCMockObject *mockGraphic = MOCK(Graphic);
	OCMockObject *mockProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);

	[[[_mockDomain expect] andReturn:mockProxy] nodeProxyForNode:mockGraphic];
	[[_mockSelectionHelper expect] toggleSelectionOfItem:(id)mockProxy shouldModifyCurrent:YES];

	[_selectTool didClickOnGraphic:(id)mockGraphic modifyingExistingSelection:YES];
	
	[_mockDomain verify];
	[_mockSelectionHelper verify];
}

- (void)testMouseDownInEmptySpaceModifyingExistingSelection {
	// - (void)mouseDownInEmptySpaceModifyingExistingSelection:(BOOL)isModifyingSelection

	[[_mockSelectionHelper expect] clearSelection];
	[_selectTool mouseDownInEmptySpaceModifyingExistingSelection:NO];
	[_mockSelectionHelper verify];
}
	
- (void)testBeginModifyingSelectionWithMarquee {
	// - (void)beginModifyingSelectionWithMarquee
	//- (void)endModifyingSelectionWithMarquee
	
	NSIndexSet *currentSelectionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,3)];
	[[[_mockDomain expect] andReturn:currentSelectionIndexes] currentFilteredContentSelectionIndexes];

	[_selectTool beginModifyingSelectionWithMarquee];
	NSAssert( [[_selectTool initialSelection] isEqualToIndexSet: currentSelectionIndexes], @"doh" );

	[_selectTool endModifyingSelectionWithMarquee];
	NSAssert( _selectTool.initialSelection==nil, @"doh" );
	
	[_mockDomain verify];
}

- (void)testSetMarqueeSelectionBounds {
	// - (void)setMarqueeSelectionBounds:(CGRect)newMarqueeBounds
	
	NSIndexSet *currentSelectionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,3)];
	[[[_mockDomain expect] andReturn:currentSelectionIndexes] currentFilteredContentSelectionIndexes];
	
	[_selectTool beginModifyingSelectionWithMarquee];

	CGRect newMarqueeBounds = CGRectMake(10,10,20,20);
	[[[_mockDomain expect] andReturn:currentSelectionIndexes] indexesOfGraphicsIntersectingRect:newMarqueeBounds];
	[[_mockSelectionHelper expect] modifyInitialSelection:currentSelectionIndexes withMarqueedIndexes:currentSelectionIndexes];

	[_selectTool setMarqueeSelectionBounds:newMarqueeBounds];
	
	[_selectTool endModifyingSelectionWithMarquee];
	
	[_mockDomain verify];
	[_mockSelectionHelper verify];
}

	
// -- mouse down on an object and it becomes 'Current' or 'Active' - not selected. Mouse up and it becomes selected
- (void)testSelectActionAtPtModifyExistingSelectionInStarView {
//	- (void)selectActionAtPt:(NSPoint)pt inStarView:(CALayerStarView *)view modifyExistingSelection:(BOOL)modifyExistingSelection ;

//june09	Star *star1 = [Star makeChildWithName:@"star1"];
//june09	[model setCurrentNodeGroup:model.rootNodeGroup];
//june09	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
//june09	star1.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star1 setPosition:NSMakePoint(0,0)];
//june09	[star1 enforceConsistentState];
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
	
	/* Test normal click */
//june09	[_selectTool selectActionAtPt:NSMakePoint(5,5) inStarView:view modifyExistingSelection:NO];
//june09	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );

//june09	[_selectTool selectActionAtPt:NSMakePoint(20,5) inStarView:view modifyExistingSelection:NO];
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
	
//june09	[_selectTool selectActionAtPt:NSMakePoint(5,5) inStarView:view modifyExistingSelection:YES];
//june09	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );
	
	/* Test shift click */
//june09	Star *star2 = [Star makeChildWithName:@"star2"];
//june09	[model NEW_addChild:star2 toNode:model.rootNodeGroup atIndex:1];
//june09	star2.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star2 setPosition:NSMakePoint(30,30)];
//june09	[star2 enforceConsistentState];	

	// toggle it on
//june09	[_selectTool selectActionAtPt:NSMakePoint(35,35) inStarView:view modifyExistingSelection:YES];
//june09	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );
//june09	STAssertTrue([[[scene selectedItems] objectAtIndex:0] originalNode]==star2, @"no way");
	
	// toggle it off
//june09	[_selectTool selectActionAtPt:NSMakePoint(35,35) inStarView:view modifyExistingSelection:YES];
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
	
	// toggle 2 stars on
//june09	[_selectTool selectActionAtPt:NSMakePoint(5,5) inStarView:view modifyExistingSelection:YES];
//june09	[_selectTool selectActionAtPt:NSMakePoint(35,35) inStarView:view modifyExistingSelection:YES];
//june09	STAssertTrue( [[scene selectedItems] count]==2, @"bah" );
	
	// clean up?
//june09	[_selectTool selectActionAtPt:NSMakePoint(200,5) inStarView:view modifyExistingSelection:NO];
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
}

- (void)testSeclectActionInRectInStarView {
//june09	maybe we need scene
// - (void)seclectActionInRect:(NSRect)rect inStarView:(CALayerStarView *)view
	
	// add some nodes to select
//june09	Star *star1 = [Star makeChildWithName:@"star1"];
//june09	[model setCurrentNodeGroup:model.rootNodeGroup];
//june09	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
//june09	star1.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star1 setPosition:NSMakePoint(10,10)]; // 10 - 20
//june09	[star1 enforceConsistentState];
	
//june09	Star *star2 = [Star makeChildWithName:@"star2"];
//june09	[model NEW_addChild:star2 toNode:model.rootNodeGroup atIndex:1];
//june09	star2.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star2 setPosition:NSMakePoint(30,30)];		// 30 - 40
//june09	[star2 enforceConsistentState];	
	
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
	
	// test dragging and selecting
//june09	[_selectTool seclectActionInRect:NSMakeRect(0,011,11) inStarView: ];
//june09	STAssertTrue( NSEqualRects( _selectTool.marqueeSelectionBounds, NSMakeRect(0,0,11,11)), @"nope");
//june09	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );
//june09	STAssertTrue([[[scene selectedItems] objectAtIndex:0] originalNode]==star1, @"no way");
	
	// contract the marquee
//june09	[_selectTool dragMouseToPoint:NSMakePoint(-10,-10)];
//june09	STAssertTrue( NSEqualRects( _selectTool.marqueeSelectionBounds, NSMakeRect(0,0,-10,-10)), @"nope");
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
	
	// move to a new point
//june09	[_selectTool mouseDownAtPoint:NSMakePoint(35,35)];
//june09	[_selectTool dragMouseToPoint:NSMakePoint(40,40)];
//june09	STAssertTrue( NSEqualRects( _selectTool.marqueeSelectionBounds, NSMakeRect(35,35,5,5)), @"nope");
//june09	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );
//june09	STAssertTrue([[[scene selectedItems] objectAtIndex:0] originalNode]==star2, @"no way");
	
	// expand backwards
//june09	[_selectTool dragMouseToPoint:NSMakePoint(0,0)];
//june09	STAssertTrue( [[scene selectedItems] count]==2, @"bah" );
	
	// clean up?
//june09	[_selectTool selectActionAtPt:NSMakePoint(200,5) inStarView:view modifyExistingSelection:NO];
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );	
}

- (void)testDragging {
	
	// add some nodes to select
//june09	Star *star1 = [Star makeChildWithName:@"star1"];
//june09	[model setCurrentNodeGroup:model.rootNodeGroup];
//june09	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
//june09	star1.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star1 setPosition:NSMakePoint(10,10)]; // 10 - 20
//june09	[star1 enforceConsistentState];
	
//june09	Star *star2 = [Star makeChildWithName:@"star2"];
//june09	[model NEW_addChild:star2 toNode:model.rootNodeGroup atIndex:1];
//june09	star2.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star2 setPosition:NSMakePoint(30,30)];		// 30 - 40
//june09	[star2 enforceConsistentState];	
	
//june09	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );

//	// test dragging and selecting
//	[_selectTool mouseDownAtPoint:NSMakePoint(0,0)];
//	[_selectTool dragMouseToPoint:NSMakePoint(11,11)];
//	STAssertTrue( NSEqualRects( _selectTool.marqueeSelectionBounds, NSMakeRect(0,0,11,11)), @"nope");
//	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );
//	STAssertTrue([[[scene selectedItems] objectAtIndex:0] originalNode]==star1, @"no way");
//
//	// contract the marquee
//	[_selectTool dragMouseToPoint:NSMakePoint(-10,-10)];
//	STAssertTrue( NSEqualRects( _selectTool.marqueeSelectionBounds, NSMakeRect(0,0,-10,-10)), @"nope");
//	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );
//
//	// move to a new point
//	[_selectTool mouseDownAtPoint:NSMakePoint(35,35)];
//	[_selectTool dragMouseToPoint:NSMakePoint(40,40)];
//	STAssertTrue( NSEqualRects( _selectTool.marqueeSelectionBounds, NSMakeRect(35,35,5,5)), @"nope");
//	STAssertTrue( [[scene selectedItems] count]==1, @"bah" );
//	STAssertTrue([[[scene selectedItems] objectAtIndex:0] originalNode]==star2, @"no way");
//	
//	// expand backwards
//	[_selectTool dragMouseToPoint:NSMakePoint(0,0)];
//	STAssertTrue( [[scene selectedItems] count]==2, @"bah" );
//	
//	// clean up?
//	[_selectTool selectActionAtPt:NSMakePoint(200,5) inStarView:view modifyExistingSelection:NO];
//	STAssertTrue( [[scene selectedItems] count]==0, @"bah" );

}

- (void)testIdentifier {
	// - (NSString *)identifier
	
	STAssertTrue( [[_selectTool identifier] isEqualToString:@"SKTSelectTool"], @"doh");
}


@end
