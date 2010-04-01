//
//  CALayerStarViewTests.m
//  DebugDrawing
//
//  Created by steve hooley on 12/12/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "TestUtilities.h"
#import "StarScene.h"
#import "Star.h"
#import "AppControl.h"
#import "CALayerStarView.h"
#import "AppControl.h"
#import "EditingViewController.h"

@interface CALayerStarViewTests : SenTestCase {
	
	SHNodeGraphModel	*model;
	StarScene			*scene;
	CALayerStarView		*view;
}

@end


@implementation CALayerStarViewTests

- (void)setUp {
	
	model = [[SHNodeGraphModel makeEmptyModel] retain];
	scene = [StarScene new];
	scene.model = model;
	view = [[CALayerStarView alloc] initWithFrame:NSMakeRect(0, 0, 800, 600)];
	[view setupCALayerStuff];
//june09	view.starScene = scene;
}

- (void)tearDown {
	
//june09	view.starScene = nil;
	[view release];
	scene.model = nil;
	[scene release];
	[model release];
}

// TEST THAT THE VIEW'S LAYER TREE REFLECTS THE MODEL'S TREE
- (void)testJustTestThatWorksJustWorks
{
	// -- add some items to the model
	SHNode *root = model.rootNodeGroup;
	
	Star *star1 = [Star makeChildWithName:@"star1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	Star *star2 = [Star makeChildWithName:@"star2"];
	SHNode *node2 = [SHNode makeChildWithName:@"node2"];

	[node1 addChild:star2 undoManager:nil];
	[node1 addChild:node2 undoManager:nil];

	/* add root nodes to the model */
	[model NEW_addChild:star1 toNode:root atIndex:0];
	[model NEW_addChild:node1 toNode:root atIndex:1];

	//-- verify that views layers are the Same	
//june09	NSArray *sublayers = [view.contentLayer sublayers];
//june09	STAssertTrue( [sublayers count]==2, @"%i", [sublayers count] );

//june09	CALayer *starLayer1 = [sublayers objectAtIndex:0];
//june09	CALayer *nodeLayer1 = [sublayers objectAtIndex:1];
//june09	STAssertTrue( [starLayer1 delegate]==star1, @"err" );
//june09	STAssertTrue( [nodeLayer1 delegate]==node1, @"err" );

//june09	NSArray *subsublayers = [nodeLayer1 sublayers];
//june09	STAssertTrue( [subsublayers count]==2, @"%i", [subsublayers count] );

//june09	CALayer *starLayer2 = [subsublayers objectAtIndex:0];
//june09	CALayer *nodeLayer2= [subsublayers objectAtIndex:1];
//june09	STAssertTrue( [starLayer2 delegate]==star2, @"err" );
//june09	STAssertTrue( [nodeLayer2 delegate]==node2, @"err" );
}

- (void)testSomeLayerReorderingOrderStuff {
	
	Star *star1 = [Star makeChildWithName:@"star1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	Star *star2 = [Star makeChildWithName:@"star2"];
	SHNode *node2 = [SHNode makeChildWithName:@"node2"];

	/* add root nodes to the model */
	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
	[model NEW_addChild:node1 toNode:model.rootNodeGroup atIndex:1];
	[model NEW_addChild:star2 toNode:model.rootNodeGroup atIndex:1];
	[model NEW_addChild:node2 toNode:model.rootNodeGroup atIndex:1];

//june09	NSArray *sublayers = [view.contentLayer sublayers];
//june09	STAssertTrue( [sublayers count]==4, @"%i", [sublayers count] );
	
//june09	CALayer *starLayer1 = [sublayers objectAtIndex:0];
//june09	CALayer *nodeLayer2 = [sublayers objectAtIndex:1];
//june09	CALayer *starLayer2 = [sublayers objectAtIndex:2];
//june09	CALayer *nodeLayer1 = [sublayers objectAtIndex:3];

//june09	STAssertTrue( [starLayer1 delegate]==star1, @"err %@", [starLayer1 delegate] );
//june09	STAssertTrue( [nodeLayer2 delegate]==node2, @"err %@", [nodeLayer2 delegate] );
//june09	STAssertTrue( [starLayer2 delegate]==star2, @"err %@", [starLayer2 delegate] );
//june09	STAssertTrue( [nodeLayer1 delegate]==node1, @"err %@", [nodeLayer1 delegate] );
	
	//-- try swapping a layer and seeing what happens..
//june09	[model add:1 toIndexOfChild:star1]; // current index is 0
//june09	[model add:1 toIndexOfChild:star2]; // current index is 2

//june09	sublayers = [view.contentLayer sublayers];
//june09	STAssertTrue( [sublayers count]==4, @"%i", [sublayers count] );
//june09	nodeLayer2 = [sublayers objectAtIndex:0];
//june09	starLayer1 = [sublayers objectAtIndex:1];
//june09	nodeLayer1 = [sublayers objectAtIndex:2];
//june09	starLayer2 = [sublayers objectAtIndex:3];
	
//june09	STAssertTrue( [starLayer1 delegate]==star1, @"err %@", [starLayer1 delegate] );
//june09	STAssertTrue( [nodeLayer2 delegate]==node2, @"err %@", [nodeLayer2 delegate] );
//june09	STAssertTrue( [starLayer2 delegate]==star2, @"err %@", [starLayer2 delegate] );
//june09	STAssertTrue( [nodeLayer1 delegate]==node1, @"err %@", [nodeLayer1 delegate] );
	
	//-- WHY the HELL do we swap in these selected items? Why the notifications
	
	//-- How do we get notifications in the wrong order? - ANSWER: Because of the 'Initial' setting in the KVO. when we Observe an add we begin observing the added nodes children from within the observe method. Because we use 'initial' we receive the notification that the child was added before we receive the notification that the parent was added. I think this makes the child observation pretty pointless.
}

// SetMouseCoalescingEnabled
- (void)testSomeSelectionStuff {
	
	Star *star1 = [Star makeChildWithName:@"star1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	Star *star2 = [Star makeChildWithName:@"star2"];
	SHNode *node2 = [SHNode makeChildWithName:@"node2"];

	/* add root nodes to the model */
	NSLog(@"RootNode is %@", model.rootNodeGroup );
	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
	[model NEW_addChild:node1 toNode:model.rootNodeGroup atIndex:1];
	[model NEW_addChild:star2 toNode:model.rootNodeGroup atIndex:2];
	[model NEW_addChild:node2 toNode:model.rootNodeGroup atIndex:3];

	/* TEST ROOT NODE FIRST */
	
	// select an object
//june09	[model addChildrenToSelection:[NSArray arrayWithObject:star1] inNode:model.rootNodeGroup];
//june09	SelectedLayer *viewSelectedLayer = view->selectedContentLayer;
//june09	STAssertTrue(viewSelectedLayer!=nil, @"we should have a selected layer");
	
//june09	NSArray *subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==1, @"we should have a selected layer %i", [subLayers count]);
//june09	STAssertTrue([[subLayers objectAtIndex:0] delegate]==star1, @"Incorrect Order" );

	// add another object
//june09	[model addChildrenToSelection:[NSArray arrayWithObject:node2] inNode:model.rootNodeGroup];
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==2, @"we should have a selected layer %i", [subLayers count]);
//june09	STAssertTrue([[subLayers objectAtIndex:1] delegate]==node2, @"Incorrect Order" );

	// add another object inbetween the previous two
//june09	[model addChildrenToSelection:[NSArray arrayWithObject:star2] inNode:model.rootNodeGroup];
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==3, @"we should have a selected layer %i", [subLayers count]);
//june09	STAssertTrue([[subLayers objectAtIndex:0] delegate]==star1, @"Incorrect Order" );
//june09	STAssertTrue([[subLayers objectAtIndex:1] delegate]==star2, @"Incorrect Order" );
//june09	STAssertTrue([[subLayers objectAtIndex:2] delegate]==node2, @"Incorrect Order" );

	// try removing from selection
//june09	[model removeChildrenFromSelection:[NSArray arrayWithObject:star2] inNode:model.rootNodeGroup];
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==2, @"we should have a selected layer %i", [subLayers count]);

	/* NOW TEST DEEPER */
//june09	Star *deepStar1 = [Star makeChildWithName:@"deepStar1"];
//june09	SHNode *deepNode1 = [SHNode makeChildWithName:@"deepNode1"];
//june09	Star *deepStar2 = [Star makeChildWithName:@"deepStar1"];
//june09	SHNode *deepNode2 = [SHNode makeChildWithName:@"deepNode2"];

//june09	[model NEW_addChild:deepStar1 toNode:node1 atIndex:0];
//june09	[model NEW_addChild:deepNode1 toNode:node1 atIndex:1];
//june09	[model NEW_addChild:deepStar2 toNode:node1 atIndex:2];
//june09	[model NEW_addChild:deepNode2 toNode:node1 atIndex:3];
	
	/* This will deselect current selection */
//june09	[model moveDownALevelIntoNodeGroup:node1];
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==0, @"we should have a selected layer %i", [subLayers count]);
	
//june09	[model addChildrenToSelection:[NSArray arrayWithObject:deepStar1] inNode:node1];
//june09	viewSelectedLayer = view->selectedContentLayer;
//june09	STAssertTrue(viewSelectedLayer!=nil, @"we should have a selected layer");
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==1, @"we should have a selected layer %i", [subLayers count]);
//june09	SelectedLayer *intermediateLayer = [subLayers objectAtIndex:0];
//june09	STAssertTrue([intermediateLayer delegate]==node1, @"Incorrect Order" );

//june09	NSArray *deepSubLayers = [intermediateLayer sublayers];
//june09	STAssertTrue([deepSubLayers count]==1, @"we should have a selected layer %i", [deepSubLayers count]);
//june09	STAssertTrue([[deepSubLayers objectAtIndex:0] delegate]==deepStar1, @"Incorrect Order" );

	// add another object
//june09	[model addChildrenToSelection:[NSArray arrayWithObject:deepNode2] inNode:node1];
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==1, @"we should have a selected layer %i", [subLayers count]);
//june09	intermediateLayer = [subLayers objectAtIndex:0];
	
//june09	deepSubLayers = [intermediateLayer sublayers];
//june09	STAssertTrue([deepSubLayers count]==2, @"we should have a selected layer %i", [deepSubLayers count]);
//june09	STAssertTrue([[deepSubLayers objectAtIndex:1] delegate]==deepNode2, @"Incorrect Order" );
	
	// add another object inbetween the previous two
//june09	[model addChildrenToSelection:[NSArray arrayWithObject:deepStar2] inNode:node1];
//june09	deepSubLayers = [intermediateLayer sublayers];
//june09	STAssertTrue([deepSubLayers count]==3, @"we should have a selected layer %i", [subLayers count]);
//june09	STAssertTrue([[deepSubLayers objectAtIndex:0] delegate]==deepStar1, @"Incorrect Order" );
//june09	STAssertTrue([[deepSubLayers objectAtIndex:1] delegate]==deepStar2, @"Incorrect Order" );
//june09	STAssertTrue([[deepSubLayers objectAtIndex:2] delegate]==deepNode2, @"Incorrect Order" );
	
//june09	[model removeChildrenFromSelection:[NSArray arrayWithObject:deepNode2] inNode:node1];
//june09	deepSubLayers = [intermediateLayer sublayers];
//june09	STAssertTrue([deepSubLayers count]==2, @"we should have a selected layer %i", [subLayers count]);
//june09	STAssertTrue([[deepSubLayers objectAtIndex:1] delegate]==deepStar2, @"Incorrect Order" );
	
	/* remove all selected layers should force the intermediate layer to be removed */
//june09	[model removeChildrenFromSelection:[NSArray arrayWithObjects:deepStar1, deepStar2, nil] inNode:node1];
//june09	viewSelectedLayer = view->selectedContentLayer;
//june09	STAssertTrue(viewSelectedLayer!=nil, @"we should have a selected layer");
//june09	subLayers = [viewSelectedLayer sublayers];
//june09	STAssertTrue([subLayers count]==0, @"we should have a selected layer %i", [subLayers count]);
}

- (void)testHitTestLayersFromNodeAtPoint {
	
	// - (SHNode *)hitTestLayersFromNode:(NodeProxy *)currentNodeProxy atPoint:(NSPoint)pt;

//june09	Star *star1 = [Star makeChildWithName:@"star1"];
//june09	[model NEW_addChild:star1 toNode:model.rootNodeGroup atIndex:0];
//june09	star1.geometryRect = NSMakeRect(0,0,10,10);
//june09	[star1 setPosition:NSMakePoint(0,0)];
//june09	[star1 enforceConsistentState];
	
//june09	SHNode *hitNode = [view hitTestLayersFromNode:scene.currentProxy atPoint:NSMakePoint(0,0)];
//june09	STAssertTrue(hitNode==star1, @"nope");
	
//june09	hitNode = [view hitTestLayersFromNode:scene.currentProxy atPoint:NSMakePoint(-10,0)];
//june09	STAssertTrue(hitNode==nil, @"nope");

//june09	hitNode = [view hitTestLayersFromNode:scene.currentProxy atPoint:NSMakePoint(10,20)];
//june09	STAssertTrue(hitNode==nil, @"nope");
}

- (void)testSetViewController {
	// - (void)setViewController:(EditingViewController *)newController
	
	OCMockObject *mockViewCntrlr = MOCK(EditingViewController);
	[[mockViewCntrlr expect] setNextResponder:nil];
	
	[view setViewController:(id)mockViewCntrlr];
	STAssertTrue([view nextResponder]==(id)mockViewCntrlr, @"doh");
	[mockViewCntrlr verify];
	
	[[[mockViewCntrlr expect] andReturn:nil] nextResponder];
	[[mockViewCntrlr expect] setNextResponder:nil];
	[view setViewController:nil];
	STAssertTrue([view nextResponder]==nil, @"doh");
	[mockViewCntrlr verify];
}

- (void)testBecomeFirstResponder {
	// - (BOOL)becomeFirstResponder
	// - (BOOL)resignFirstResponder
	
	STAssertTrue([view becomeFirstResponder], @"doh");
	STAssertTrue([view resignFirstResponder], @"doh");
}


- (void)testWantsDefaultClipping {
	//- (BOOL)wantsDefaultClipping
	
	STAssertFalse( [view wantsDefaultClipping], @"doh");
}

- (void)testIsOpaque {
	// - (BOOL)isOpaque
	
	STAssertTrue( [view isOpaque], @"doh");
}

- (void)testAcceptsFirstResponder {
	// - (BOOL)acceptsFirstResponder
	
	STAssertTrue( [view acceptsFirstResponder], @"doh");
}

@end
