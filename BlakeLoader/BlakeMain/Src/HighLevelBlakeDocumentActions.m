//
//  HighLevelBlakeDocumentActions.m
//  Pharm
//
//  Created by Steven Hooley on 26/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "HighLevelBlakeDocumentActions.h"


@implementation BlakeDocument (HighLevelSketchDocumentActions)

@end


@interface BlakeDocument (HighLevelBlakeDocumentActionsPrivate)

- (void)_undoDeleteSelectedChildrenFromNode_withChildren:(NSArray *)theChildren withNode:(SHNode *)node;
- (void)_redoDeleteSelectedChildrenFromNode_withChildren:(NSArray *)theChildren withNode:(SHNode *)node;

@end

@implementation BlakeDocument (HighLevelBlakeDocumentActionsPrivate)

- (void)_undoDeleteSelectedChildrenFromNode_withChildren:(NSArray *)theChildren withNode:(SHNode *)node {

	NSUndoManager* um = [self undoManager];
	[um beginUndoGrouping];
		[[um prepareWithInvocationTarget:node] setSelectedChildren: theChildren];
		[[um prepareWithInvocationTarget:self] _redoDeleteSelectedChildrenFromNode_withChildren:theChildren withNode:node];
	[um endUndoGrouping];
}

- (void)_redoDeleteSelectedChildrenFromNode_withChildren:(NSArray *)theChildren withNode:(SHNode *)node {

	NSUndoManager* um = [self undoManager];
	[um beginUndoGrouping];
	if(![um isUndoing])
		[um setActionName:@"delete selected children"];		
		[[um prepareWithInvocationTarget:self] _undoDeleteSelectedChildrenFromNode_withChildren:theChildren withNode:node];
//	[um setActionName:@"delete selected children"];
	[um endUndoGrouping];
}


@end

/*
 *
*/
@implementation BlakeDocument (HighLevelBlakeDocumentActions)

#pragma mark -
#pragma mark User Interface methods - low level With UNDO


- (void)deleteSelectedChildrenFromNode:(SHNode *)node {

	NSArray* selectedChildren = [node selectedChildren];
	if([selectedChildren count]>0)
	{
		NSUndoManager *um = [self undoManager];
		[um beginUndoGrouping];
			if(![um isUndoing])
				[um setActionName:@"Delete Selected"];
			[self _undoDeleteSelectedChildrenFromNode_withChildren:selectedChildren withNode:node];
			[self deleteChildren:selectedChildren fromNode:node];

		[um endUndoGrouping];
	}
}


#pragma mark -
#pragma mark User Interface methods - Dont need UNDO

/*	Little Note regarding UNDO and REDO 
	The Undo operations that we register in prepareWithInvocationTarget should themselves be undoable - 
	these actions automatically go onto the redo stack 
*/
- (SHNode *)_makeEmptyGroupInNode:(SHNode *)parentNode withName:(NSString *)name {

	// new change here. From now on onlt manipulate the current node. Gradually i will deprecate these 'maniplulate any node' methods
	NSParameterAssert( parentNode && parentNode==_nodeGraphModel.currentNodeGroup );
	NSParameterAssert(name);
	
	SHNode* n1 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:name];
	if(n1!=nil){
		NSUndoManager *um = [self undoManager];
		if(![um isUndoing])
			[um setActionName:@"new empty group"];

		//TODO: do we need to do this if we are using the document's undomanager? ie. we shouldn't but i'm sure it is broken - test!
		[self updateChangeCount:NSChangeDone];
	}
	return n1;
}

- (SHInputAttribute *)makeInputInCurrentNodeWithType:(NSString *)type {

	SHInputAttribute* inAtt = [SHInputAttribute attributeWithType:type];
	[_nodeGraphModel NEW_addChild:inAtt atIndex:-1];
	return inAtt;
}

- (SHOutputAttribute *)makeOutputInCurrentNodeWithType:(NSString *)type {

	SHOutputAttribute* outAtt = [SHOutputAttribute attributeWithType:type];
	[_nodeGraphModel NEW_addChild:outAtt atIndex:-1];	
	return outAtt;
}

/* This is of limited use.. will fail if attributes aren't in current node */
- (void)connectOutletOfInput:(SHProtoAttribute *)att1 toInletOfOutput:(SHProtoAttribute *)att2 {

	SHInterConnector* i1 = [_nodeGraphModel connectOutletOfAttribute:att1 toInletOfAttribute:att2];
	if(i1!=nil){
	} else {
		logError(@"Didnt make a connection");
	}
}

/* Paths are relative to curentNode */
- (void)connectOutletOfInputAtPath:(SH_Path *)att1 toInletOfOutputAtPath:(SH_Path *)att2 fudgeID:(int)fid {

	SHNode *currNode = [_nodeGraphModel currentNodeGroup];
	SHInterConnector *i1 = [currNode connectAttributeAtRelativePath:att1 toAttributeAtRelativePath:att2 undoManager:self.undoManager];
	if(i1!=nil){
	}
}

- (void)connectOutletOfInputAtPath:(SH_Path *)att1 toInletOfOutputAtPath:(SH_Path *)att2 {

	[self connectOutletOfInputAtPath:att1 toInletOfOutputAtPath:att2 fudgeID:-1];
}

/* This seems a bit wierd - node can -deleteChildren -- something todo with undo? */
- (void)deleteChildren:(NSArray *)arrayValue fromNode:(SHNode *)node {

	NSArray *filteredChildrenToDelete = nil;

	if([arrayValue count]>0)
	{		
		// -- get all affected interconnectors -- an affected interconnector might not nesasrily be *in* thi node
		NSArray *dependantInterConnectors = [node interConnectorsDependantOnChildren: arrayValue];
		if([dependantInterConnectors count])
		{
			NSMutableArray *childrenNotIncludingInterConnectors = nil;
			childrenNotIncludingInterConnectors = [[arrayValue mutableCopy] autorelease];
			[childrenNotIncludingInterConnectors removeObjectsInArray: dependantInterConnectors];
			
			// -- remove the interconnectors in an undoable way
			// -- This is a bit tricky - all ics returned by interConnectorsDependantOnChildren won't be children of node
			NSMutableArray *icsInNode = [NSMutableArray array], *icsInNodeParent = [NSMutableArray array];
			for( SHInterConnector *ic in dependantInterConnectors ){
				if([ic parentSHNode]==node)
					[icsInNode addObject:ic];
				else if([ic parentSHNode]==[node parentSHNode])
					[icsInNodeParent addObject:ic];
				else
					[NSException raise:@"should only be deleting interconnectors from self or parent" format:@"--- nrrrgg ---"];
			}
			/* Shit! This is one place where we cannot limit operations only to the current node */
			if([icsInNode count])
				[self deleteInterConnectors:icsInNode fromNode:node];
			if([icsInNodeParent count])
				[self deleteInterConnectors:icsInNodeParent fromNode:[node parentSHNode]];
			
			filteredChildrenToDelete = (NSArray *)childrenNotIncludingInterConnectors;
		} else {
			filteredChildrenToDelete = arrayValue;
		}

		// -- remove the nodes in an undoable way
		if( [filteredChildrenToDelete count]>0 ) {
			[_nodeGraphModel deleteChildren:filteredChildrenToDelete fromNode:node];
		}
		
	}
}

- (void)deleteInterConnectors:(NSArray *)ics fromNode:(NSObject<ChildAndParentProtocol> *)node {
	
	NSParameterAssert([ics count]);
	NSParameterAssert(node);
	[node deleteInterconnectors:ics undoManager:[self undoManager]];
}

/* Can't add Interconnectors! */
- (void)addChildren:(NSArray *)arrayValue toNode:(SHNode *)node atIndexes:(NSArray *)positions {

	NSParameterAssert( [arrayValue count] );
	NSAssert( [_nodeGraphModel currentNodeGroup]==node, @"thing are stricter around here now");

	NSUInteger i=0, index;
	NSMutableArray *nodesSet=nil, *inputsSet=nil, *outputsSet=nil;
	NSMutableIndexSet *nodeInds=nil, *inputInds=nil, *outputInds=nil;
	
	for( SHNode *eachNode in arrayValue ) 
	{
		if([positions count])
			index = [[positions objectAtIndex:i] intValue];
		else
			index = NSNotFound;
		
		/* InterConnector */
		if([eachNode isKindOfClass:[SHInterConnector class]]) {
			NSError* err = [NSError errorWithDomain:@"Cant add SHInterConnectors" code:1 userInfo:nil];
			logError([err domain]);
		}
		
		/* Everything else */
		else if([eachNode conformsToProtocol:@protocol(SHNodeLikeProtocol)])
		{			
			if([eachNode isKindOfClass:[SHNode class]]){
				if(!nodesSet){
					nodesSet = [NSMutableArray array];
					if(index!=NSNotFound)
						nodeInds = [NSMutableIndexSet indexSet];
				}
				[nodesSet addObject:eachNode];
				[nodeInds addIndex:index];
				
			} else if([eachNode isKindOfClass:[SHOutputAttribute class]]){
				if(!outputsSet){
					outputsSet = [NSMutableArray array];
					if(index!=NSNotFound)
						outputInds = [NSMutableIndexSet indexSet];
				}
				[outputsSet addObject:eachNode];
				[outputInds addIndex:index];

			} else if([eachNode isKindOfClass:[SHInputAttribute class]]){
				if(!inputsSet){
					inputsSet = [NSMutableArray array];
					if(index!=NSNotFound)
						inputInds = [NSMutableIndexSet indexSet];
				}
				[inputsSet addObject:eachNode];
				[inputInds addIndex:index];
			}

		} else {
			logError(@"Cant add objects that do not conform to SHNodeLikeProtocol");
		}
		i++;
	}
	if(nodesSet)
		[_nodeGraphModel insertGraphics:nodesSet atIndexes:nodeInds];
	if(inputsSet)
		[_nodeGraphModel insertGraphics:inputsSet atIndexes:inputInds];
	if(outputsSet)
		[_nodeGraphModel insertGraphics:outputsSet atIndexes:outputInds];
}

- (void)addChildrenToSelection:(NSArray *)childrenToSelect inNode:(SHNode *)theParentNode {

	NSAssert( [_nodeGraphModel currentNodeGroup]==theParentNode, @"thing are stricter around here now");

//Refactor		NSUndoManager* um = [self undoManager];
	// BOOL isInUndo = [um isUndoing];
	// BOOL isInRedo = [um isRedoing];
	logInfo(@"Adding children to selection %@", childrenToSelect);
	
//	[um beginUndoGrouping];
//		[um setActionName:@"select children"];
	[_nodeGraphModel addChildrenToCurrentSelection:childrenToSelect];
//Refactor			[[um prepareWithInvocationTarget:self] removeChildrenFromSelection:childrenToSelect inNode:theParentNode];
		/* NB not updating document change count here */
//	[um endUndoGrouping];	
}

- (void)removeChildrenFromSelection:(NSArray *)childrenToDeSelect inNode:(SHNode *)theParentNode {

	NSAssert( [_nodeGraphModel currentNodeGroup]==theParentNode, @"thing are stricter around here now");

//Refactor		NSUndoManager* um = [self undoManager];
//	[um beginUndoGrouping];
//		[um setActionName:@"deselect children"];
		[_nodeGraphModel removeChildrenFromCurrentSelection:childrenToDeSelect];
//Refactor			[[um prepareWithInvocationTarget:self] addChildrenToSelection:childrenToDeSelect inNode:theParentNode];
		/* NB not updating document change count here */
//	[um endUndoGrouping];		
}

- (void)moveDownAlevelIntoSelectedNodeGroup {

//jan10	NSArray *currentNodeSelection = [[_nodeGraphModel currentNodeGroup] selectedChildNodes];
//jan10	if([currentNodeSelection count]==1){
//jan10		[self moveDownALevelIntoNodeGroup:[currentNodeSelection objectAtIndex:0]];
//jan10	}
}

- (void)add:(int)amountToMove toIndexOfChild:(id)aChild {
	
//Refactor		NSUndoManager* um = [self undoManager];
	[_nodeGraphModel add:amountToMove toIndexOfChild:aChild];
//Refactor		[[um prepareWithInvocationTarget:self] add:amountToMove*-1 toIndexOfChild:aChild];
//Refactor		[self updateChangeCount:NSChangeDone];
}

- (BOOL)_currentGroupCanBeCustomized {

	SHNode *currentNode = [_nodeGraphModel currentNodeGroup];
	if( currentNode.operatorPrivateMember==NO && currentNode.allowsSubpatches==YES ) 
		return YES;
	return NO;
}

#pragma mark Higher level actions that utilize undo in lower level actions
- (void)groupChildren:(NSArray *)someChildren {

	/* verify that each child lives in the same level and is in this document */
	if(someChildren==nil || [someChildren count]==0){
		[NSException raise:@"Should not get here - cant group ZERO Children" format:@"should not get here"];
	}
	
	id parentNode=nil;
	for( id eachChild in someChildren )
	{
		if(parentNode==nil){
			parentNode = [eachChild parentSHNode];
			SHNode *docRoot = [_nodeGraphModel rootNodeGroup];
			if(parentNode!=docRoot && [parentNode isNodeParentOfMe:docRoot]==NO){
				[NSException raise:@"Should not get here" format:@"cant group nodes from different levels"];
				return;
			}
		}
		if([eachChild parentSHNode]!=parentNode)
			return;
	}

	SHNode *newMacro = [self _makeEmptyGroupInNode:parentNode withName:@"macro"];
	
	SH_Path *newMacroPath = [[_nodeGraphModel currentNodeGroup] relativePathToChild:newMacro];
	
	//-- dependant interconnectors
	NSArray *dependantInterConnectors = [[_nodeGraphModel currentNodeGroup] interConnectorsDependantOnChildren: someChildren];
	NSMutableArray *reConnections = [NSMutableArray array];

	// -- which interconnectors are to be moved inside?
	// -- which interconnectors need to be connected from outside to indside the new node?
	for( SHInterConnector *each in dependantInterConnectors ){
	
		SHProtoAttribute *inAtt = [[each inSHConnectlet] parentAttribute];
		SHProtoAttribute *outAtt = [[each outSHConnectlet] parentAttribute];
		id archive = [each currentConnectionInfo];
		SH_Path *inPath = [archive objectAtIndex:0];
		SH_Path *outPath = [archive objectAtIndex:1];
				
		if( [someChildren indexOfObjectIdenticalTo: inAtt]!=NSNotFound )
		{
			if( [someChildren indexOfObjectIdenticalTo: outAtt]!=NSNotFound ) 
			{
				// moving both ends
				// insert path to new node in both ends
				//this/is/the/old/path/to/input
				//this/is/the/old/path/to/NEWPATH/input
				inPath = [inPath insertPathComponentBeforeLast: newMacroPath];
				outPath = [outPath insertPathComponentBeforeLast: newMacroPath];
	
			} else {
				//	moving one end
				inPath = [inPath insertPathComponentBeforeLast: newMacroPath];
			}
		} else {
			// verify moving one end
			NSAssert([someChildren containsObject:outAtt], @"doh");
		//	moving one end
			outPath = [outPath insertPathComponentBeforeLast: newMacroPath];
		}
		/* we will connect this new connector after we have completed moving the nodes */
		[reConnections addObject:[NSArray arrayWithObjects:inPath, outPath, nil]];		
	}
	[self deleteInterConnectors:dependantInterConnectors fromNode:[_nodeGraphModel currentNodeGroup]];
	NSMutableArray *childrenNotIncludingInterConnectors = [[someChildren mutableCopy] autorelease];
	[childrenNotIncludingInterConnectors removeObjectsInArray: dependantInterConnectors];
	
	[self deleteChildren:childrenNotIncludingInterConnectors fromNode:parentNode];
	
	// [currDoc moveDownALevelIntoNodeGroup: newMacro];
	[self addChildren:childrenNotIncludingInterConnectors toNode_NOT_CURRENT:newMacro];
	
	// do the reconnections
	for( id eachICArchive in reConnections )
	{
		SH_Path *p1 = [eachICArchive objectAtIndex:1];
		SH_Path *p2 = [eachICArchive objectAtIndex:0];
		[self connectOutletOfInputAtPath:p1 toInletOfOutputAtPath:p2 ];
	}
	
}

- (void)unGroupNode:(SHNode *)aNodeGroup {

	//-- get the parent of child
	SHNode *parent = [[self nodeGraphModel] currentNodeGroup];
	
	NSArray *dependantInterConnectors1 = [parent interConnectorsDependantOnChildren: [NSArray arrayWithObject:aNodeGroup]];
	NSMutableArray *cumulativeDependentICs = [NSMutableArray arrayWithArray:dependantInterConnectors1];
	NSMutableArray *connectorArchives = [NSMutableArray array];
	
	for( SHInterConnector *eachIC in cumulativeDependentICs ){
		id archive = [eachIC currentConnectionInfo];
		[connectorArchives addObject:archive];
	}
	
//	id childToUngroup;
//	for(childToUngroup in allSelectedNodes)
//	{
		if([aNodeGroup isKindOfClass:[SHNode class]] && [aNodeGroup allowsSubpatches])
		{
	//		SH_Path *pathToUngroupingNode = [parent relativePathToChild: aNodeGroup];

			//-- get all children from aNodeGroup.
			NSArray *allChildren = [_nodeGraphModel allChildrenFromNode: aNodeGroup];
			NSMutableArray *normalArray = [[allChildren mutableCopy] autorelease];
			
			/* The connectors returned from this may well belong to different parents */
			NSArray *dependantInterConnectors2 = [aNodeGroup interConnectorsDependantOnChildren: normalArray];
			for( id eachIC in dependantInterConnectors2 )
			{
				if( [cumulativeDependentICs indexOfObjectIdenticalTo: eachIC]==NSNotFound )
				{
					// eek! Ungrouping will cause nodes to be renamed.. connections wont be valid..
//nov09					SHProtoAttribute *outOf = [eachIC outOfAtt];
//nov09					SHProtoAttribute *into = [eachIC intoAtt];
//nov09					SHNode *parent = [eachIC parentSHNode];
					
	//				id archive = [eachIC currentConnectionInfo];
//					SH_Path *inPath = [archive objectAtIndex:0];
//					SH_Path *outPath = [archive objectAtIndex:1];
//					
//
//					//-- modify the archive to reflect the new positions of the attributes
//					//-- ie, remove pathToUngroupingNode
//					// 
//					SH_Path *newInPath = [inPath removePathComponentBeforeLast: pathToUngroupingNode];
//					SH_Path *newOutPath = [outPath removePathComponentBeforeLast: pathToUngroupingNode];
//					if(newInPath!=nil)
//						inPath = newInPath;
//					if(newOutPath!=nil)
//						outPath = newOutPath;
					[cumulativeDependentICs addObject:eachIC];
//					//-- new connector! archive it.
//					NSAssert([inPath isEquivalentTo:outPath]==NO, @"Doh 2");
//nov09					[connectorArchives addObject:[NSArray arrayWithObjects:outOf, into, parent, nil]];
				}
			}

			//-- delete them
			[normalArray removeObjectsInArray: cumulativeDependentICs];

			//-- undo order is important
			[self deleteChildren:normalArray fromNode: aNodeGroup];
			
			//-- remove child from its parent
			[self deleteChildren:[NSArray arrayWithObject: aNodeGroup] fromNode:parent];

			//-- add children to parent
			[self addChildren:normalArray toNode:parent];
		}
//	} 
	
	//-- add the connectors back in
	for( id eachICArchive in connectorArchives ){
		
		SHProtoAttribute *p1 = [eachICArchive objectAtIndex:0];
		SHProtoAttribute *p2 = [eachICArchive objectAtIndex:1];
		[self connectOutletOfInput:p1 toInletOfOutput:p2 ];
	}
}


- (SHNode *)makeEmptyGroupInCurrentNodeWithName:(NSString *)name {

	SHNode* currNode = [_nodeGraphModel currentNodeGroup];
    NSAssert( currNode!=nil, @"Need a currentNode");
	return [self _makeEmptyGroupInNode:currNode withName:name];
}

- (void)deleteSelectedChildrenFromCurrentNode {

	SHNode* currNode = [_nodeGraphModel currentNodeGroup];
    NSAssert( currNode!=nil, @"Need a currentNode");
	[self deleteSelectedChildrenFromNode:currNode];
}

- (void)addChildrenToCurrentNode:(NSArray *)arrayValue {

    NSParameterAssert(arrayValue!=nil);
    NSParameterAssert([arrayValue count]>0);
	SHNode* currNode = [_nodeGraphModel currentNodeGroup];
    NSAssert( currNode!=nil, @"Need a currentNode");
	[self addChildren:arrayValue toNode:currNode];
}

- (void)addChildren:(NSArray *)arrayValue toNode_NOT_CURRENT:(SHNode *)node {

	NSAssert( [_nodeGraphModel currentNodeGroup]!=node, @"thing are stricter around here now");
	[self addChildren:arrayValue toNode:node atIndexes:nil];
}

- (void)addChildren:(NSArray *)arrayValue toNode:(SHNode *)node {

	NSAssert( [_nodeGraphModel currentNodeGroup]==node, @"thing are stricter around here now");
	[self addChildren:arrayValue toNode:node atIndexes:nil];
}

- (void)deleteChildrenFromCurrentNode:(NSArray *)arrayValue {

	SHNode* currNode = [_nodeGraphModel currentNodeGroup];
	[self deleteChildren:arrayValue fromNode:currNode];
}

- (void)selectAllChildrenInCurrentNode {

	SHNode* currentNodeGroup = [_nodeGraphModel currentNodeGroup];
	[self selectAllChildrenInNode: currentNodeGroup];
}

- (void)selectAllChildrenInNode:(SHNode *)node {
	
	NSAssert( [_nodeGraphModel currentNodeGroup]==node, @"thing are stricter around here now");
	NSArray *allChildren = [NSArray arrayWithArray:(NSArray *)[node allChildren]];
	[self addChildrenToSelection:allChildren inNode:node];
}

/* may have to rename this later when i find out ho the tableView handles it (we want to get the table view to use the undoable versions) */
- (void)addChildToSelectionInCurrentNode:(id)child {

	NSParameterAssert(child);
	SHNode *currentNodeGroup = [_nodeGraphModel currentNodeGroup];
	[self addChildrenToSelection:[NSArray arrayWithObject:child] inNode:currentNodeGroup];
}

- (void)deSelectAllChildrenInCurrentNode {

	SHNode *currentNodeGroup = [_nodeGraphModel currentNodeGroup];
	[self deSelectAllChildrenInNode: currentNodeGroup ];
}

- (void)deSelectAllChildrenInNode:(SHNode *)node {

	NSAssert( [_nodeGraphModel currentNodeGroup]==node, @"thing are stricter around here now");
	NSArray *allSelectedChildrenInNode = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
	if([allSelectedChildrenInNode count])
		[self removeChildrenFromSelection:allSelectedChildrenInNode inNode:node];
}

- (void)addContentsOfFile:(NSString *)filePath toNode:(SHNode *)node atIndex:(int)index {

	NSAssert( [_nodeGraphModel currentNodeGroup]==node, @"thing are stricter around here now");
//DEC09	SHNode* result = [_nodeGraphModel loadNodeFromFile:filePath];
//DEC09	[self addChildren:[NSArray arrayWithObject:result] toNode:node atIndexes:[NSArray arrayWithObject:[NSNumber numberWithInt:index]]];
}

- (void)moveChildren:(NSArray *)obsToDrag toInsertionIndex:(NSUInteger)row shouldCopy:(BOOL)copyFlag {
	
	if(copyFlag){
		NSArray *objectDuplicates = [[[NSArray alloc] initWithArray:obsToDrag copyItems:YES] autorelease];
		[_nodeGraphModel insertGraphics:objectDuplicates atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row,[objectDuplicates count])]];
	} else {
		[_nodeGraphModel moveChildren:obsToDrag toInsertionIndex:row];
	}
}

@end
