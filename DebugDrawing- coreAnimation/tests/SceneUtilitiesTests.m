//
//  SceneUtilitiesTests.m
//  DebugDrawing
//
//  Created by steve hooley on 10/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


#import "TestUtilities.h"
#import "SceneUtilities.h"
#import "Star.h"
#import "StarScene.h"

@interface SceneUtilitiesTests : SenTestCase {
	
	SHNodeGraphModel	*_model;
	StarScene			*_scene;
}

@end

@implementation SceneUtilitiesTests

- (void)setUp {
	
	_model = [[SHNodeGraphModel makeEmptyModel] retain];
	_scene = [StarScene new];
	_scene.model = _model;
	
	STAssertTrue( [[_scene currentFilteredContent] count]==0, @"Err %i", [[_scene currentFilteredContent] count]);
}

- (void)tearDown {
	
	_scene.model = nil;
	[_scene release];
	[_model release];
}

- (void)testIsMoveableFromScene {
	// + (BOOL)isMoveable:(NodeProxy *)np fromScene:(StarScene *)scene 

	// add some nodes - make sure at least 2 rotatable
	[TestUtilities addSomeDefaultItemsToModel: _model];
	[_model setCurrentNodeGroup:_model.rootNodeGroup];
	Star *star1 = [Star makeChildWithName:@"star1"];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];

	// if no objects are selected there shouldn't be any rotatable items
	NSArray *filteredContent = [_scene currentFilteredContent];
	STAssertTrue([filteredContent count]==3, @"eh? %i", [filteredContent count]);
	
	NodeProxy *ob1 = [filteredContent objectAtIndex:0]; // Star
	NodeProxy *ob2 = [filteredContent objectAtIndex:1];	// Star
	NodeProxy *ob3 = [filteredContent objectAtIndex:2];	// Node
	
	STAssertTrue( [ob1.originalNode isKindOfClass:[Star class]], @"Fucked up");
	STAssertTrue( [ob2.originalNode isKindOfClass:[Star class]], @"Fucked up");
	STAssertTrue( [ob3.originalNode isKindOfClass:[SHNode class]], @"Fucked up");

	BOOL isMoveable1 = [SceneUtilities isMoveable:ob1];
	BOOL isMoveable2 = [SceneUtilities isMoveable:ob2];
	BOOL isMoveable3 = [SceneUtilities isMoveable:ob3];

	STAssertTrue( isMoveable1, @"Fucked up");
	STAssertTrue( isMoveable2, @"Fucked up");
	STAssertFalse( isMoveable3, @"Fucked up");
}

- (void)testIdentifyTargetObjects {
	
	// add some nodes - make sure at least 2 rotatable
	[TestUtilities addSomeDefaultItemsToModel: _model];
	[_model setCurrentNodeGroup:_model.rootNodeGroup];

	Star *star1 = [Star makeChildWithName:@"star1"];
	[_model NEW_addChild:star1 toNode:_model.rootNodeGroup atIndex:0];
	STAssertTrue([[_scene currentFilteredContent] count]==3, @"eh? %i", [[_scene currentFilteredContent] count]);
	
	// if no objects are selected there shouldn't be any rotatable items
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:[NSMutableIndexSet indexSet]];
	NSArray *targetObjects = [SceneUtilities identifyTargetObjectsFromScene:_scene];
	STAssertTrue(targetObjects==nil, @"Fucked up");
	
	// if one object is selected, and it is rotatable it should be the target
	NSMutableIndexSet *newSelection1 = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:newSelection1];
	targetObjects = [SceneUtilities identifyTargetObjectsFromScene:_scene];
	STAssertTrue([targetObjects count]==1, @"Fucked up");
	STAssertTrue([targetObjects objectAtIndex:0]==[[_scene currentFilteredContent] objectAtIndex:0], @"Fucked up");
	
	// if the one selected item isn't rotateable then there should be no targets
	NSMutableIndexSet *newSelection2 = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(2,1)];
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:newSelection2];
	targetObjects = [SceneUtilities identifyTargetObjectsFromScene:_scene];
	STAssertTrue([targetObjects count]==0, @"Fucked up");
	
	// if more than one item is selected there should be no targets
	NSMutableIndexSet *newSelection3 = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
	[_model.rootNodeGroup setSelectedNodesInsideIndexes:newSelection3];
	targetObjects = [SceneUtilities identifyTargetObjectsFromScene:_scene];
	STAssertTrue([targetObjects count]==0, @"Fucked up");
}

- (void)testInfoForProxyFromSceneIndexIsSelected {
	//+ (void)infoForProxy:(NodeProxy *)np fromScene:(StarScene *)scene index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected

	[TestUtilities addSomeDefaultItemsToModel: _model];
	[_model setCurrentNodeGroup:_model.rootNodeGroup];
	
	NSArray *stars2 = _scene.stars;
	
	NSUInteger clickedGraphicIndex;
	BOOL clickedGraphicIsSelected;

	[SceneUtilities infoForProxy:[stars2 objectAtIndex:0] fromScene:_scene index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected];
	
	STAssertTrue(clickedGraphicIndex==0, @"eh? %i", clickedGraphicIndex);
	STAssertTrue(clickedGraphicIsSelected==NO, @"eh? %i", clickedGraphicIsSelected);

	[_scene selectItemAtIndex:0];
	[SceneUtilities infoForProxy:[stars2 objectAtIndex:0] fromScene:_scene index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected];
	
	STAssertTrue(clickedGraphicIndex==0, @"eh? %i", clickedGraphicIndex);
	STAssertTrue(clickedGraphicIsSelected==YES, @"eh? %i", clickedGraphicIsSelected);	
}

- (void)testInfoForProxyIndexIsSelectedIsMovable {
	// - (void)infoForProxy:(NodeProxy *)np fromScene:(StarScene *) index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected isMovable:(BOOL *)outIsMovable

	[TestUtilities addSomeDefaultItemsToModel: _model];
	[_model setCurrentNodeGroup:_model.rootNodeGroup];

	NSArray *stars2 = _scene.stars;

	NSUInteger clickedGraphicIndex;
	BOOL clickedGraphicIsSelected, clickedGraphicIsMosveable;
	[SceneUtilities infoForProxy:[stars2 objectAtIndex:0] fromScene:_scene index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected isMovable:&clickedGraphicIsMosveable];
	
	STAssertTrue(clickedGraphicIndex==0, @"eh? %i", clickedGraphicIndex);
	STAssertTrue(clickedGraphicIsSelected==NO, @"eh? %i", clickedGraphicIsSelected);
	STAssertTrue(clickedGraphicIsMosveable==YES, @"eh? %i", clickedGraphicIsMosveable);

	[_scene selectItemAtIndex:0];
	[SceneUtilities infoForProxy:[stars2 objectAtIndex:0] fromScene:_scene index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected isMovable:&clickedGraphicIsMosveable];

	STAssertTrue(clickedGraphicIndex==0, @"eh? %i", clickedGraphicIndex);
	STAssertTrue(clickedGraphicIsSelected==YES, @"eh? %i", clickedGraphicIsSelected);
	STAssertTrue(clickedGraphicIsMosveable==YES, @"eh? %i", clickedGraphicIsMosveable);
}

@end
