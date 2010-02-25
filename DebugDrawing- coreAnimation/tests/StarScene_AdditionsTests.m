//
//  StarScene_AdditionsTests.m
//  DebugDrawing
//
//  Created by steve hooley on 26/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface StarScene_AdditionsTests : SenTestCase {
	
}

@end


@implementation StarScene_AdditionsTests

+ (void)resetObservers {
	

	_selectedItemIndexesChanges = 0;
	_selectedItemsChanges = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [context isEqualToString:@"StarSceneTests"] )
	{
		if( [keyPath isEqualToString:@"currentFilteredContentSelectionIndexes"] ){
		} else if( [keyPath isEqualToString:@"currentFilteredContent"] ){
		} else if( [keyPath isEqualToString:@"selectedItemIndexes"] ){
			_selectedItemIndexesChanges++;
		} else if( [keyPath isEqualToString:@"selectedItems"] ){
			_selectedItemsChanges++;
		}		
		
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}



//- (void)testDirtyRectCallbacks {
//
//	NSArray *dirtyRects = [scene dirtyRects];
//	STAssertTrue( [dirtyRects count]==0, @"should be dirty %i", [dirtyRects count]);
//
//	Star *star1 = [Star makeChildWithName:@"star1"];
//	Star *star2 = [Star makeChildWithName:@"star2"];
//	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
//	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
//	
//	[node1 addChild:star2 undoManager:nil];
//	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
//	[model NEW_addChild:audio1 toNode:model.rootNodeGroup atIndex:1];
//	[model NEW_addChild:node1 toNode:model.rootNodeGroup atIndex:2];
//	
//	/* When adding each star will have the same default dirty rect */
//	dirtyRects = [scene dirtyRects];
//	STAssertTrue( [dirtyRects count]==1, @"should be dirty %i", [dirtyRects count]);
//
//	[star1 setPhysicalBounds:NSMakeRect(10,10,100,100)];
//	[star2 setPhysicalBounds:NSMakeRect(20,20,40,40)];
//	[star1 enforceConsistentState];
//	[star2 enforceConsistentState];
//	
//	/* Before coalescing we should have 3 rects */
//	STAssertTrue( [dirtyRects count]==3, @"should be dirty %i", [dirtyRects count]);
//}

//- (void)testCoalesceDirtyRects {
//	// - (void)coalesceDirtyRects
//	
//	[scene graphic:nil becameDirtyInRect:NSMakeRect(0,0,10,10)];
//	
//	[scene graphic:nil becameDirtyInRect:NSMakeRect(20,20,10,10)];
//	[scene graphic:nil becameDirtyInRect:NSMakeRect(40,40,10,10)];
//	[scene graphic:nil becameDirtyInRect:NSMakeRect(15,15,30,30)]; // this should join up rect 2 & 3
//
//	[scene graphic:nil becameDirtyInRect:NSMakeRect(100,100,10,10)];
//
//	[scene coalesceDirtyRects];
//	NSArray *dirtyRects = [scene dirtyRects];
//	STAssertTrue( [dirtyRects count]==3, @"should be dirty %i", [dirtyRects count]);
//	NSRect rect1 = [[dirtyRects objectAtIndex:0] rectValue];
//	NSRect rect2 = [[dirtyRects objectAtIndex:1] rectValue];
//	NSRect rect3 = [[dirtyRects objectAtIndex:2] rectValue];
//
//	// coalesceDirtyRects doesn't preserve the order
//	STAssertTrue( NSEqualRects(rect1, NSMakeRect(0,0,10,10)), @"should be dirty %@", NSStringFromRect(rect1));
//	STAssertTrue( NSEqualRects(rect3, NSMakeRect(15,15,35,35)), @"should be dirty %@", NSStringFromRect(rect3));
//	STAssertTrue( NSEqualRects(rect2, NSMakeRect(100,100,10,10)), @"should be dirty %@", NSStringFromRect(rect2));
//}

//- (void)test_AccuracyOfDirtyRects {
//	
//	Star *star1 = [Star makeChildWithName:@"star1"], *star2 = [Star makeChildWithName:@"star2"];
//	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
//	
//	[node1 addChild:star1 undoManager:nil]; [node1 addChild:star2 undoManager:nil];
//	[model NEW_addChild:node1 toNode:model.rootNodeGroup atIndex:0];
//	[star1 setPhysicalBounds:NSMakeRect(10,10,50,50)];
//	[star2 setPhysicalBounds:NSMakeRect(200,200,40,40)];
//	[star1 enforceConsistentState];
//	[star2 enforceConsistentState];
//
//	/* Moving star2 to 200,200,40,40 causes a big area to become dirty - the whole area is coalesced into 1 rect */
//	[scene coalesceDirtyRects];
//	NSArray *dirtyRects = [scene dirtyRects];
//	STAssertTrue( [dirtyRects count]==1, @"should be dirty %i", [dirtyRects count]);
//	[scene drewScene];
//	
//	// move the stars - when a star moves the old location and the new location must be marked as dirty! gulp! should it be 2 different rects?
//	[star1 setPhysicalBounds:NSMakeRect(0,0,40,40)];
//	[star2 setPhysicalBounds:NSMakeRect(210,210,50,50)];
//	[star1 enforceConsistentState];
//	[star2 enforceConsistentState];
//	
//	[scene coalesceDirtyRects];
//	dirtyRects = [scene dirtyRects];
//	STAssertTrue( [dirtyRects count]==2, @"should be dirty %i", [dirtyRects count]);
//	NSRect rect1 = [[dirtyRects objectAtIndex:0] rectValue];
//	NSRect rect2 = [[dirtyRects objectAtIndex:1] rectValue];
//	STAssertTrue( NSEqualRects(rect1, NSMakeRect(0,0,60,60)), @"should be dirty %@", NSStringFromRect(rect1));
//	STAssertTrue( NSEqualRects(rect2, NSMakeRect(200,200,60,60)), @"should be dirty %@", NSStringFromRect(rect2));
//
//	[scene drewScene];
//}


//- (void)testGraphicUnderPointIndexIsSelectedHandle {
//	// - (NodeProxy *)graphicUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle
//
//	Star *star1=[Star makeChildWithName:@"star1"], *star2=[Star makeChildWithName:@"star2"], *star3=[Star makeChildWithName:@"star3"];
//	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
//	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
//	[node1 addChild:star2 undoManager:nil];
//	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
//	[model NEW_addChild:audio1 toNode:model.rootNodeGroup atIndex:1];
//	[model NEW_addChild:node1 toNode:model.rootNodeGroup atIndex:2];
//	[model NEW_addChild:star3 toNode:model.rootNodeGroup atIndex:3];	
//	[star1 setPhysicalBounds:NSMakeRect(0,0, 100, 100)];	// full screen
//	[star2 setPhysicalBounds:NSMakeRect(50, 50, 50, 50)];	// top right hand corner
//	[star3 setPhysicalBounds:NSMakeRect(45,45,10,10)];	// centre
//
//	NodeProxy *hitGraphic1 = [scene graphicUnderPoint:NSMakePoint(10,10) index:NULL isSelected:NULL handle:NULL];
//	NodeProxy *hitGraphic2 = [scene graphicUnderPoint:NSMakePoint(75,75) index:NULL isSelected:NULL handle:NULL];
//	NodeProxy *hitGraphic3 = [scene graphicUnderPoint:NSMakePoint(50,50) index:NULL isSelected:NULL handle:NULL];
//
//	STAssertTrue(hitGraphic1.originalNode==star1, @"Nope %@", hitGraphic1.originalNode);
//	STAssertTrue(hitGraphic2.originalNode==node1, @"Nope %@", hitGraphic2.originalNode);
//	STAssertTrue(hitGraphic3.originalNode==star3, @"Nope %@", hitGraphic3.originalNode);
//}

- (void)testDrawingBoundsOfGraphics {
	// + (NSRect)drawingBoundsOfGraphics:(NSArray *)graphics;
	
	Star *star1=[Star makeChildWithName:@"star1"];
	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
	STAssertTrue( [[scene currentFilteredContent] count]==1, @"Err %i", [[scene currentFilteredContent] count]);
	
	NSRect db = [StarScene drawingBoundsOfGraphics:[NSArray arrayWithObject:[[scene currentFilteredContent] objectAtIndex:0]]];
	STAssertTrue( NSEqualRects(db, NSMakeRect(0,0,50,50)), @"%@", NSStringFromRect(db));
}

@end
