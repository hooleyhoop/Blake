//
//  SHChildContainer_Selection.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChildContainer_Selection.h"


@implementation SHChildContainer (SHChildContainer_Selection)

#pragma mark -
#pragma mark NOT UNDOABLE ACTION methods

- (void)clearSelectionNoUndo {
	
	if([[_nodesInside selection] count])
		[_nodesInside setSelection: [NSMutableIndexSet indexSet]];
	if([[_inputs selection] count])
		[_inputs setSelection: [NSMutableIndexSet indexSet]];
	if([[_outputs selection] count])
		[_outputs setSelection: [NSMutableIndexSet indexSet]];
	if([[_shInterConnectorsInside selection] count])
		[_shInterConnectorsInside setSelection: [NSMutableIndexSet indexSet]];
}

- (BOOL)hasSelection {
	
	if([[_nodesInside selection] count])
		return YES;
	if([[_inputs selection] count])
		return YES;
	if([[_outputs selection] count])
		return YES;
	if([[_shInterConnectorsInside selection] count])
		return YES;
	return NO;
}

- (void)setSelectedNodes:(NSArray *)nodesSet {
	[_nodesInside setSelectedObjects:nodesSet];
}

- (void)setSelectedInputs:(NSArray *)inputsSet {
	[_inputs setSelectedObjects:inputsSet];
}

- (void)setSelectedOutputs:(NSArray *)outputsSet {
	[_outputs setSelectedObjects:outputsSet];
}

- (void)setSelectedInterconnectors:(NSArray *)icSet {
	[_shInterConnectorsInside setSelectedObjects:icSet];
}

- (NSArray *)selectedChildren {
	
	NSMutableArray* allSelected = [NSMutableArray arrayWithArray:[_nodesInside selectedObjects]];
	[allSelected addObjectsFromArray:[_inputs selectedObjects]];
	[allSelected addObjectsFromArray:[_outputs selectedObjects]];
	[allSelected addObjectsFromArray:[_shInterConnectorsInside selectedObjects]];
	return allSelected;
}

- (void)addChildToSelection:(id)child {
	
	NSAssert([self isChild:child], @"can't select an object that is not a child of me");
	SHOrderedDictionary* targetArray = [self _targetStorageForObject:child];
	
	if([targetArray isSelected:child]==NO) {
		[targetArray addObjectToSelection:child];
	}
}

- (void)selectAllChildren {
	
	[_nodesInside setSelection:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[_nodesInside count])]];
	[_inputs setSelection:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[_inputs count])]];
	[_outputs setSelection:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[_outputs count])]];
	[_shInterConnectorsInside setSelection:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[_shInterConnectorsInside count])]];
}

- (void)unSelectAllChildNodes {
	[_nodesInside setSelection:[NSMutableIndexSet indexSet]];
}

- (void)unSelectAllChildInputs {
	[_inputs setSelection:[NSMutableIndexSet indexSet]];
}

- (void)unSelectAllChildOutputs {
	[_outputs setSelection:[NSMutableIndexSet indexSet]];
}

- (void)unSelectAllChildInterConnectors {
	[_shInterConnectorsInside setSelection:[NSMutableIndexSet indexSet]];
}

- (void)setSelectedNodesInsideIndexes:(NSMutableIndexSet *)value {
	[_nodesInside setSelection:value];
}

- (void)setSelectedInputIndexes:(NSMutableIndexSet *)value {
	[_inputs setSelection:value];
}

- (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value {
	[_outputs setSelection:value];
}

- (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value {
	[_shInterConnectorsInside setSelection:value];
}

//- (void)_setSelectionForStorage:(SHOrderedDictionary *)targetStorage newSelection:(NSMutableIndexSet *)value {
//	[targetStorage setSelection: value];
//}

@end
