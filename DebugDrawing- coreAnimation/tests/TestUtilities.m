//
//  TestUtilities.m
//  DebugDrawing
//
//  Created by steve hooley on 25/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "TestUtilities.h"
#import "Star.h"
#import "StarGroup.h"

@implementation TestUtilities

+ (void)addSomeDefaultItemsToModel:(SHNodeGraphModel *)aModel {

	// add a star, a star group, a node and a node group
	Star *star1 = [Star makeChildWithName:@"star1"];
	SKTAudio *audio1 = [SKTAudio makeChildWithName:@"audio1"];
	SHNode *node1 = [SHNode makeChildWithName:@"node1"];
	
	Star *star2 = [Star makeChildWithName:@"star2"];
	SKTAudio *audio2 = [SKTAudio makeChildWithName:@"audio2"];
	SHNode *node2 = [SHNode makeChildWithName:@"node2"];
	//	StarGroup *starGroup1 = [StarGroup new];
//	NodeGroup *nodeGroup1 = [NodeGroup new];
	
	// add children to starGroup and nodeGroup
	[node1 addChild:star2 undoManager:nil];
	[node1 addChild:audio2 undoManager:nil];
	[node1 addChild:node2 undoManager:nil];
	
	[star1 setGeometryRect:CGRectMake(0,0,100,100)];
    [star1 setPosition:CGPointMake(28, 250)];
	
	[star2 setGeometryRect:CGRectMake(0,0,40,40)];
    [star2 setPosition:CGPointMake(220,80)];

//	Star *star2 = [Star new];
//	StarGroup *starGroup2 = [StarGroup new];
//	SHNode *node2 = [SHNode new];
//	NodeGroup *nodeGroup2 = [NodeGroup new];
	
//	Star *star3 = [Star new];
//	StarGroup *starGroup3 = [StarGroup new];
//	SHNode *node3 = [SHNode new];
//	NodeGroup *nodeGroup3 = [NodeGroup new];
	
//	[starGroup1 addNode:star2];
//	[starGroup1 addNode:starGroup2];
//	[starGroup1 addNode:node2];
//	[starGroup1 addNode:nodeGroup2];
//	
//	[nodeGroup1 addNode:star3];
//	[nodeGroup1 addNode:starGroup3];
//	[nodeGroup1 addNode:node3];
//	[nodeGroup1 addNode:nodeGroup3];
	
	// add another level
//	[starGroup2 addNode: [Star new]];
//	[nodeGroup2 addNode: [Star new]];
//	[starGroup3 addNode: [Star new]];
//	[nodeGroup3 addNode: [Star new]];
//	
//	[starGroup2 addNode: [Node new]];
//	[nodeGroup2 addNode: [Node new]];
//	[starGroup3 addNode: [Node new]];
//	[nodeGroup3 addNode: [Node new]];
	
	/* add root nodes to the model */
	[aModel NEW_addChild:star1 toNode:aModel.rootNodeGroup atIndex:0];
	[aModel NEW_addChild:audio1 toNode:aModel.rootNodeGroup atIndex:1];
	[aModel NEW_addChild:node1 toNode:aModel.rootNodeGroup atIndex:2];
	
//	[aModel insertGraphic:starGroup1 atIndex:1];
//	[aModel insertGraphic:nodeGroup1 atIndex:3];
	
	[aModel setCurrentNodeGroup:node1];
}

@end
