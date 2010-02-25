//
//  SHNodeSelectingMethods.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 01/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNodeSelectingMethods.h"
#import "SHNodeAttributeMethods.h"
#import "SHConnectableNode.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHNodePrivateMethods.h"

/*
 *
*/
@implementation SHNode (SHNodeSelectingMethods) 

#pragma mark -
#pragma mark -
#pragma mark WITH UNDO methods


//- (void)addChildToSelection_withUndo:(id)child {
//
//	#ifdef NSDebugEnabled
//		[self recordHit:_cmd];
//	#endif
//	
//	NSAssert([self isChild:child], @"cant select an object that is not a child of me");
//	SHOrderedDictionary* targetArray = [self _targetStorageForObject:child];
//
//	if([targetArray isSelected:child]==NO)
//	{
//		[targetArray addObjectToSelection:child];
//		
//		SHUndoManager *um = (SHUndoManager *)[[self nodeGraphModel] undoManager];
//		[um beginUndoGrouping:@"add to selection" reverseName:@"remove from selection"];
//			[[um prepareWithInvocationTarget:self] removeChildFromSelection:child];
//		[um endUndoGrouping];
//	}
//
//	//	self.lastSelectedChild = child;
//	// send a notification - are we using these notifications? Really?
//	// [self performSelectorOnMainThread:@selector(postSHSelectedChildrenChanged_Notification:) withObject:nil waitUntilDone:NO];
//}





#pragma mark -
#pragma mark -


#pragma mark DOESNT NEED UNDO methods


- (void)addChildrenToSelection:(NSArray *)children {
	
	NSParameterAssert([children count]);
	NSMutableSet *nodesSet=nil, *inputsSet=nil, *outputsSet=nil, *icSet=nil;
	[SHNode sortChildrenByType:children :&nodesSet :&inputsSet :&outputsSet :&icSet];

	if(nodesSet)
		[self addNodesToSelection:nodesSet];
	if(inputsSet)
		[self addInputsToSelection:inputsSet];
	if(outputsSet)
		[self addOutputsToSelection:outputsSet];
	if(icSet)
		[self addICsToSelection:icSet];

#ifdef NSDebugEnabled
	[self recordHit:_cmd];
#endif
}

- (void)removeChildrenFromSelection:(NSArray *)children {
	
	NSParameterAssert([children count]);
	NSMutableSet *nodesSet=nil, *inputsSet=nil, *outputsSet=nil, *icSet=nil;
	[SHNode sortChildrenByType:children :&nodesSet :&inputsSet :&outputsSet :&icSet];

	if(nodesSet)
		[self removeNodesFromSelection:nodesSet];
	if(inputsSet)
		[self removeInputsFromSelection:inputsSet];
	if(outputsSet)
		[self removeOutputsFromSelection:outputsSet];
	if(icSet)
		[self removeICsFromSelection:icSet];
}


#pragma mark -
#pragma mark action methods

//- (void)toggleSelectedOfChild:(id)child
//{
//	if([child selectedFlag]==YES){
//		[self addChildToSelection: child];
//	} else {
//		[self removeChildFromSelection: child];
//	}
//}



//nov09- (void)deleteSelectedChildren {

//nov09    NSArray* selectedNodes = [[[_nodesInside selectedObjects] copy] autorelease];
//nov09    NSArray* selectedInputs = [[[_inputs selectedObjects] copy] autorelease];
//nov09    NSArray* selectedOutputs = [[[_outputs selectedObjects] copy] autorelease];
//nov09    NSArray* selectedConnectors = [[[_shInterConnectorsInside selectedObjects] copy] autorelease];

//nov09    [self clearSelectionNoUndo];
    
//nov09    if([selectedConnectors count]>0)
//nov09        [self _removeInterConnectors: selectedConnectors];
//nov09    if([selectedInputs count]>0)
 //nov09       [self _removeInputs: selectedInputs];
//nov09    if([selectedNodes count]>0)
//nov09        [self _removeNodes: selectedNodes];
//nov09    if([selectedOutputs count]>0)
//nov09        [self _removeOutputs: selectedOutputs];
//nov09}


//- (void)deleteSelectedInterConnectors
//{
//	// iterate through _selectedChildInterConnectors
//	NSArray *selectedInterConnectors = [_shInterConnectorsInside selectedObjects];
//
//	id ic;
//	for( ic in selectedInterConnectors) {
//		//logInfo(@"SHNodeSelectingMethods.m: InterConnector to delete is %@, UID %i", value, [value temporaryID] );
//		[self deleteChild:ic undoManager:nil];
//	}	
//}
//
//// ===========================================================
//// - moveSelectedChildrenUpInExecutionOrder
//// ===========================================================
//- (void)moveSelectedChildrenUpInExecutionOrder
//{
////	NSEnumerator *enumerator = [_selectedChildSHNodes objectEnumerator];
////	id value;
////	while ((value = [enumerator nextObject])) {
////		[self moveNodeUpInExecutionOrder:value];
////	}
//}
//
//// ===========================================================
//// - moveSelectedChildrenDownInExecutionOrder
//// ===========================================================
//- (void)moveSelectedChildrenDownInExecutionOrder
//{
////	NSEnumerator *enumerator = [_selectedChildSHNodes objectEnumerator];
////	id value;
////	while ((value = [enumerator nextObject])) {
////		[self moveNodeDownInExecutionOrder:value];
////	}
//}

#pragma mark -
#pragma mark accessor methods
#pragma mark SUPER *NEW* action methods



#pragma mark -

// ===========================================================
// - selectedFlag:
// ===========================================================
//- (BOOL) selectedFlag {
//	return _selectedFlag;
//}
// ===========================================================
// - setSelectedFlag:
// ===========================================================
//- (void) setSelectedFlag:(BOOL)aFlag {
//	_selectedFlag = aFlag;
//}

//=========================================================== 
// - selectedNodeAndAttributeIndexes
//=========================================================== 
//- (NSMutableIndexSet *)selectedNodeAndAttributeIndexes
//{
//	NSMutableIndexSet* set = [NSMutableIndexSet indexSet];
//	
//	// iterate through all selected node and make an index set
//	id child;
//	int i, count=[_selectedChildNodesAndAttributes count];
//	for(i=0; i<count; i++){
//		child = [_selectedChildNodesAndAttributes objectAtIndex:i];
//		int ind = [[self nodesAndAttributesInside] indexOfObjectIdenticalTo:child];
//		[set addIndex:ind];
//	}
//	return set;
//}

//=========================================================== 
// - setSelectedNodeAndAttributeIndexes:
//=========================================================== 
//- (void)setSelectedNodeAndAttributeIndexes:(NSMutableIndexSet *)value
//{
//	// iterate through all nodes unselecting or selecting them
//	id child;
//	int i, count=[_nodesInside count];
//	for(i=0; i<count; i++)
//	{
//		child = [_nodesInside objectAtIndex:i];
//		// is this node in the index set?
//		if([value containsIndex:i]){
//			if(![child selectedFlag])
//				[self addChildToSelection: child];
//		} else {
//			if([child selectedFlag])
//				[self removeChildFromSelection: child];
//		}
//	}
//	
//	count=[_inputs count];
//	for(i=0; i<count; i++)
//	{
//		child = [_inputs objectAtIndex:i];
//		int offsetIndex = i+[_nodesInside count];
//		// is this node in the index set?
//		if([value containsIndex:offsetIndex]){
//			if(![child selectedFlag])
//				[self addChildToSelection: child];
//		} else {
//			if([child selectedFlag])
//				[self removeChildFromSelection: child];
//		}
//	}
//	
//	count=[_outputs count];
//	for(i=0; i<count; i++)
//	{
//		child = [_outputs objectAtIndex:i];
//		int offsetIndex = i+[_nodesInside count]+[_inputs count];
//
//		// is this node in the index set?
//		if([value containsIndex:offsetIndex]){
//			if(![child selectedFlag])
//				[self addChildToSelection: child];
//		} else {
//			if([child selectedFlag])
//				[self removeChildFromSelection: child];
//		}
//	}
//	
//}



+ (NSSet *)keyPathsForValuesAffectingAllChildrenSelectedIndexes {
    return [NSSet setWithObjects:@"_nodesInside.selection", @"_inputs.selection", @"_outputs.selection", @"_shInterConnectorsInside.selection", nil];
}

//nov09- (NSMutableIndexSet *)allChildrenSelectedIndexes {
	
//nov09	NSMutableIndexSet* newSet = [NSMutableIndexSet indexSet];

//nov09	int nCount = [_nodesInside count];
//nov09	int iCount = [_inputs count];
//nov09	int oCount = [_outputs count];
//	int cCount = [_shInterConnectorsInside count];
//nov09	int totalNumberOfChildren = [self countOfChildren];
	
//nov09	NSMutableIndexSet* nodeIndexes = [self selectedNodesInsideIndexes];
//nov09	NSMutableIndexSet* inputIndexes = [self selectedInputIndexes];
//nov09	NSMutableIndexSet* outputIndexes = [self selectedOutputIndexes];
//nov09	NSMutableIndexSet* connectorIndexes = [self selectedInterConnectorIndexes];

//nov09	int firstNodeIndex = [nodeIndexes firstIndex];
//nov09	int firstInputIndex = [inputIndexes firstIndex];
//nov09	int firstOutputIndex = [outputIndexes firstIndex];
//nov09	int firstConnectorIndex = [connectorIndexes firstIndex];

//nov09	if(firstNodeIndex != NSNotFound)
//nov09		[newSet addIndexes: nodeIndexes];
		
//nov09	int inOffset = nCount;
//nov09	NSMutableIndexSet *shiftedInputIndexes = [[inputIndexes copyIndexesShiftedBy:inOffset] autorelease];
//nov09	[newSet addIndexes: shiftedInputIndexes];

//nov09	int outOffset = inOffset + iCount;
//nov09	NSMutableIndexSet *shiftedOutputIndexes = [[outputIndexes copyIndexesShiftedBy:outOffset] autorelease];
//nov09	[newSet addIndexes:shiftedOutputIndexes];
	
//nov09	int conOffset = outOffset + oCount;
//nov09	NSMutableIndexSet *shiftedICIndexes = [[connectorIndexes copyIndexesShiftedBy:conOffset] autorelease];
//nov09	[newSet addIndexes: shiftedICIndexes];

//nov09	if([newSet lastIndex]!=NSNotFound)
//nov09		if([newSet lastIndex] >= totalNumberOfChildren){
//nov09			logError( @"we fucked up somewhere %i, %i", [newSet lastIndex], totalNumberOfChildren);
//nov09			NSException* myException = [NSException exceptionWithName:@"selected indexes are impossible" reason:@"Dick HEad" userInfo:nil];
//nov09			@throw myException;
//nov09		}
//nov09	return newSet;
//nov09}

//nov09- (void)setAllChildrenSelectedIndexes:(NSMutableIndexSet *)value {

//nov09	int nCount = [_nodesInside count];
//nov09	int iCount = [_inputs count];
//nov09	int oCount = [_outputs count];
//nov09	int cCount = [_shInterConnectorsInside count];
	
//nov09	NSMutableIndexSet* nodeIndexes = [NSMutableIndexSet indexSet];
//nov09	NSMutableIndexSet* inputIndexes = [NSMutableIndexSet indexSet];
//nov09	NSMutableIndexSet* outputIndexes = [NSMutableIndexSet indexSet];
//nov09	NSMutableIndexSet* connectorIndexes = [NSMutableIndexSet indexSet];

//nov09    NSUInteger currentIndex = [value firstIndex];
 //nov09   while (currentIndex < nCount) {
//nov09		[nodeIndexes addIndex:currentIndex];
//nov09		currentIndex = [value indexGreaterThanIndex:currentIndex];
 //nov09   }
//nov09	int iLimit = nCount + iCount;
 //nov09   while (currentIndex < iLimit) {
//nov09		[inputIndexes addIndex:currentIndex];
//nov09		currentIndex = [value indexGreaterThanIndex:currentIndex];
 //nov09   }	
//nov09	iLimit = nCount + iCount + oCount;
//nov09    while (currentIndex < iLimit) {
//nov09		[outputIndexes addIndex:currentIndex];
//nov09		currentIndex = [value indexGreaterThanIndex:currentIndex];
//nov09    }		
//nov09	iLimit = nCount + iCount + oCount + cCount;
//nov09    while (currentIndex < iLimit) {
//nov09		[connectorIndexes addIndex:currentIndex];
//nov09		currentIndex = [value indexGreaterThanIndex:currentIndex];
 //nov09   }	
	
	// int firstNodeIndex = [nodeIndexes firstIndex];
//nov09	int firstInputIndex = [inputIndexes firstIndex];
//nov09	int firstOutputIndex = [outputIndexes firstIndex];
//nov09	int firstConnectorIndex = [connectorIndexes firstIndex];

//nov09	if(firstInputIndex!=NSNotFound)
//nov09		[inputIndexes shiftIndexesStartingAtIndex:firstInputIndex by: -1*nCount ];
//nov09	if(firstOutputIndex!=NSNotFound)
//nov09		[outputIndexes shiftIndexesStartingAtIndex:firstOutputIndex by: -1*(nCount+iCount) ];
//nov09	if(firstConnectorIndex!=NSNotFound)
//nov09		[connectorIndexes shiftIndexesStartingAtIndex:firstConnectorIndex by: -1*(nCount+iCount+oCount) ];
	
//nov09	NSAssert( [nodeIndexes lastIndex]<nCount || [nodeIndexes lastIndex]==NSNotFound, @"we fucked it");
//nov09	NSAssert( [inputIndexes lastIndex]<iCount || [inputIndexes lastIndex]==NSNotFound, @"we fucked it");
//nov09	NSAssert( [outputIndexes lastIndex]<oCount || [outputIndexes lastIndex]==NSNotFound, @"we fucked it");
//nov09	NSAssert( [connectorIndexes lastIndex]<cCount || [connectorIndexes lastIndex]==NSNotFound, @"we fucked it");

	//logInfo(@"setting out indexes %@", outputIndexes);
//nov09	[self setSelectedNodesInsideIndexes: nodeIndexes];
//nov09	[self setSelectedInputIndexes: inputIndexes];
//nov09	[self setSelectedOutputIndexes: outputIndexes];
//nov09	[self setSelectedInterConnectorIndexes: connectorIndexes];
//nov09}

//- (void)setSelectedChildNodesAndAttributes:(NSMutableArray *)value
//{
//    if (_selectedChildNodesAndAttributes != value) {
//        [_selectedChildNodesAndAttributes release];
//        _selectedChildNodesAndAttributes = [value retain];
//    }
//}



#pragma mark notification methods

//- (void)postSHSelectedChildrenChanged_Notification:(id)arg
//{
//	//NSDictionary *d = [NSDictionary dictionaryWithObject:_selectedNodeIndexes forKey:@"theIndexes"];
//	NSNotification *n = [NSNotification notificationWithName:@"SHSelectedChildrenChanged" object:self userInfo:nil];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ]; // could post when idle
//}

@end
