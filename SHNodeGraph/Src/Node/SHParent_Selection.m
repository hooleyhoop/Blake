//
//  SHParent_Selection.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent_Selection.h"
#import "SHChildContainer_Selection.h"
#import "SHProtoOutputAttribute.h"
#import "SHProtoInputAttribute.h"
#import "SHInterConnector.h"

@implementation SHParent (SHParent_Selection)

#pragma mark -
#pragma mark NOT UNDOABLE ACTION methods

- (void)clearSelectionNoUndo {
	[_childContainer clearSelectionNoUndo];
}

- (void)setSelectedChildren:(NSArray *)children {
	
 	NSParameterAssert(children!=nil);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	NSMutableArray *nodesSet=[NSMutableArray array], *inputsSet=[NSMutableArray array], *outputsSet=[NSMutableArray array], *icSet=[NSMutableArray array];
	
	for( id child in children )
	{
		NSAssert([self isChild:child], @"can't select an object that is not a child of me");
		
		if([child isKindOfClass:[SHParent class]]){
			[nodesSet addObject:child];
		} else if([child isKindOfClass:[SHProtoOutputAttribute class]]){
			[outputsSet addObject:child];
		} else if([child isKindOfClass:[SHProtoInputAttribute class]]){
			[inputsSet addObject:child];
		} else if([child isKindOfClass:[SHInterConnector class]]){
			[icSet addObject:child];
		}
	}
	
	[_childContainer setSelectedNodes:nodesSet];
	[_childContainer setSelectedInputs:inputsSet];
	[_childContainer setSelectedOutputs:outputsSet];
	[_childContainer setSelectedInterconnectors:icSet];
}

- (NSArray *)selectedChildren {
	return [_childContainer selectedChildren];
}

- (void)addChildToSelection:(id)child {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	[_childContainer addChildToSelection:child];
}

- (BOOL)hasSelection {
	return [_childContainer hasSelection];
}

#pragma mark add to selection
- (void)addNodesToSelection:(NSSet *)values {
	[[self nodesInside] addObjectsToSelection:values];
}

- (void)addInputsToSelection:(NSSet *)values {
	[[self inputs] addObjectsToSelection:values];
}

- (void)addOutputsToSelection:(NSSet *)values {
	[[self outputs] addObjectsToSelection:values];
}

- (void)addICsToSelection:(NSSet *)values {
	[[self shInterConnectorsInside] addObjectsToSelection:values];
}

#pragma mark removing methods
- (void)removeNodesFromSelection:(NSSet *)values {
	[[self nodesInside] removeObjectsFromSelection:values];
}

- (void)removeInputsFromSelection:(NSSet *)values {
	[[self inputs] removeObjectsFromSelection:values];
}

- (void)removeOutputsFromSelection:(NSSet *)values {
	[[self outputs] removeObjectsFromSelection:values];
}

- (void)removeICsFromSelection:(NSSet *)values {
	[[self shInterConnectorsInside] removeObjectsFromSelection:values];
}

- (void)removeChildFromSelection:(id)child {
	
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

#ifdef NSDebugEnabled
	[self recordHit:_cmd];
#endif
	
	SHOrderedDictionary* targetArray = [_childContainer _targetStorageForObject:child];
	NSAssert(targetArray, @"doh");
	if([targetArray isSelected:child]==YES)
	{
		[targetArray removeObjectFromSelection:child];
		
		//08 may		SHUndoManager *um = (SHUndoManager *)[[self nodeGraphModel] undoManager];
		//08 may		[um beginUndoGrouping:@"remove from selection" reverseName:@"add to selection"];
		//08 may		[[um prepareWithInvocationTarget:self] addChildToSelection:child];
		//08 may		[um endUndoGrouping];
		
		// [self setLastSelectedChild:child];
		// send a notification
		// [self performSelectorOnMainThread:@selector(postSHSelectedChildrenChanged_Notification:) withObject:nil waitUntilDone:NO];
	}
}

- (void)selectAllChildren {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer selectAllChildren];
}

- (void)unSelectAllChildren {
	[self unSelectAllChildNodes];
	[self unSelectAllChildInputs];
	[self unSelectAllChildOutputs];
	[self unSelectAllChildInterConnectors];
}

- (void)unSelectAllChildNodes {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer unSelectAllChildNodes];
}

- (void)unSelectAllChildInputs {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer unSelectAllChildInputs];
}

- (void)unSelectAllChildOutputs {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer unSelectAllChildOutputs];
}

- (void)unSelectAllChildInterConnectors {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer unSelectAllChildInterConnectors];
}

- (void)setSelectedNodesInsideIndexes:(NSMutableIndexSet *)value {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer setSelectedNodesInsideIndexes:value];
}

- (void)setSelectedInputIndexes:(NSMutableIndexSet *)value {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer setSelectedInputIndexes:value];
}

- (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer setSelectedOutputIndexes:value];
}

- (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value {
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");
	[_childContainer setSelectedInterConnectorIndexes:value];
}

- (NSMutableIndexSet *)selectedNodesInsideIndexes {
	return [[self nodesInside] selection];
}

- (NSMutableIndexSet *)selectedInputIndexes {
	return [[self inputs] selection];
}

- (NSMutableIndexSet *)selectedOutputIndexes {
	return [[self outputs] selection];
}

- (NSMutableIndexSet *)selectedInterConnectorIndexes {
	return [[self shInterConnectorsInside] selection];
}

- (NSArray *)selectedChildNodes {
	return [[self nodesInside] selectedObjects]; 
}

- (NSArray *)selectedChildInputs {
	return [[self inputs] selectedObjects]; 
}

- (NSArray *)selectedChildOutputs {
	return [[self outputs] selectedObjects]; 
}

- (NSArray *)selectedChildInterConnectors {
	return [[self shInterConnectorsInside] selectedObjects]; 
}

@end
