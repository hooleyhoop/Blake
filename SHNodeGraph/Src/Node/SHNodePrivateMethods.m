//
//  SHNodePrivateMethods.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 25/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//
#import "Nodegraph_defs.h"

#import "SHNodePrivateMethods.h"
#import "SHNodeAttributeMethods.h"
#import "SHConnectlet.h"
#import "SHNodeGraphModel.h"
#import "SHAttribute.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHConnectableNode.h"
#import "SHInterConnector.h"

/*
 * Private
*/
@implementation SHNode (SHNodePrivateMethods)

#pragma mark ** WITH UNDO ** methods

// I know i am afraid of chaing undo methods BUT DONT BE! Here is example setting parent and adding outputs are handled in 2 different groups and it works fine
[um beginUndoGrouping];

	// has its own undo stuff
	[container _addOutputs:outputs atIndexes:indexes withKeys:keys undoManager:um];
	[self setParent:outputs to:self undoManager:um];
	STAssertTrue( [[outputs objectAtIndex:0] parentSHNode]==tempParent, @"shikes" );

[um endUndoGrouping];




NEED TO PUT IN AND TEST! container methods no longer set leaf, set parent node, isAboutToBeDeletedFromParentSHNode, hasBeenAddedToParentSHNode
ALL THESE NEED TO BE MOVE UP INTO Node

-- also - container is niot triggerering the 'allItemsArray' Notifications

if([self countOfChildren]==0){
	_isLeaf=YES;
}
if([self countOfChildren]==0){
	_isLeaf=YES;
}
[objects makeObjectsPerformSelector:@selector(hasBeenAddedToParentSHNode)];
[objects makeObjectsPerformSelector:@selector(isAboutToBeDeletedFromParentSHNode)];
[objects makeObjectsPerformSelector:@selector(setParentSHNode:) withObject:nil];

#pragma mark ** WITHOUT UNDO ** methods

//- (BOOL)addPrivateChild:(id<SHNodeLikeProtocol>)aNode {
//	
//	BOOL success = [self addChild:aNode autoRename:YES];
//	if(success)
//		aNode.operatorPrivateMember = YES;
//	return success;
//}


- (void)_changeNameOfChild:(SHChild *)child to:(NSString *)value {

	#ifdef NSDebugEnabled
		[self recordHit:_cmd];
	#endif
	
	if([self isChild:child]==YES)
	{
		SHOrderedDictionary* targetArray = [self _targetStorageForObject:child];
		NSString *oldName = [targetArray keyForObject:child];
		[targetArray renameObject:child to:value];
		
		NSUndoManager* um = [[self nodeGraphModel] undoManager];
		[um beginUndoGrouping];
			if(![um isUndoing])
				[um setActionName:@"change name"];
			[[um prepareWithInvocationTarget:self] _changeNameOfChild:child to:oldName];
		[um endUndoGrouping];
	} else {
		NSException* myException = [NSException exceptionWithName:@"wrong SHOrderedDictionary" reason:@"child is not in that SHOrderedDictionary" userInfo:nil];
		@throw myException;
	}
}

#pragma mark ** WITHOUT UNDO ** methods

@end