//
//  SHParent.m
//  SHNodeGraph
//
//  Created by steve hooley on 25/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent.h"
#import "SHParent_Connectable.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHChildContainer.h"
#import "SHChildContainer_Selection.h"
#import "SHNodeLikeProtocol.h"
#import "NodeName.h"
#import "SHChild.h"
#import "SH_Path.h"
#import "SHParent_Selection.h"

@implementation SHParent

#pragma mark Class methods
+ (NSSet *)childrenBelongingToParent:(NSObject<ChildAndParentProtocol> *)parent fromSet:(NSSet *)children {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"parentSHNode", parent];
    return [children filteredSetUsingPredicate:predicate];
}

// returns a set of the actual parent that this affected
+ (NSSet *)_removeICSFromRespectiveParents:(NSSet *)icSet undoManager:(NSUndoManager *)um {
	
	NSMutableSet *foundParents = [NSMutableSet setWithCapacity:[icSet count]];
	NSMutableSet *icsRemaining = [[icSet mutableCopy] autorelease];
	while([icsRemaining count]){
		SHInterConnector *anIC = [icsRemaining anyObject];
		NSObject<ChildAndParentProtocol> *icParent = [anIC parentSHNode];
		NSSet *icsInParent = [SHParent childrenBelongingToParent:icParent fromSet:icsRemaining];
		[foundParents addObject:icParent];
		[icParent deleteInterconnectors:[icsInParent allObjects] undoManager:um];
		[icsRemaining minusSet:icsInParent];
	}
	return foundParents;
}

#pragma mark Init methods
/* called from HooleyObject init */
// called for copy, encoder, and regular init
- (id)initBase {
	self=[super initBase];
	if(self){
	}
	return self;
}

- (id)init {
	
	self=[super init];
	if(self)
	{
		_childContainer = [[SHChildContainer alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
    self = [super initWithCoder:coder];
	if(self){
		_childContainer = [[coder decodeObjectForKey:@"childContainer"] retain];
	}
	NSAssert(_childContainer, @"oops");
    return self;
}

- (void)dealloc {

	[_childContainer release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	
	SHParent *copy = [super copyWithZone:zone];
	copy->_childContainer = [[SHChildContainer alloc] init];
	
	// NB Just copying the childcontainer would break parent-child tree 
	// all these children will have the wrong parent? wont they?
	// copy->_childContainer = [_childContainer copyWithZone:zone];

	// we must 'manually' build a new tree
	if([_childContainer.nodesInside count]){
		NSMutableArray *nodes_copy = [[_childContainer.nodesInside deepCopyOfObjects] autorelease];	
		[nodes_copy makeObjectsPerformSelector:@selector(release)];
		[copy addItemsOfSingleType:nodes_copy atIndexes:nil undoManager:nil];
	}
	
	if([_childContainer.inputs count]){
		NSMutableArray *inputs_copy = [[_childContainer.inputs deepCopyOfObjects] autorelease];
		[inputs_copy makeObjectsPerformSelector:@selector(release)];
		[copy addItemsOfSingleType:inputs_copy atIndexes:nil undoManager:nil];
	}
	
	if([_childContainer.outputs count]){
		NSMutableArray *outputs_copy = [[_childContainer.outputs deepCopyOfObjects] autorelease];
		[outputs_copy makeObjectsPerformSelector:@selector(release)];
		[copy addItemsOfSingleType:outputs_copy atIndexes:nil undoManager:nil];
	}
// we need to do something like get the index paths of each original ic and recreate it in the copy
	if([_childContainer.shInterConnectorsInside count]){
		for( SHInterConnector *each in _childContainer.shInterConnectorsInside )
		{
			NSArray *indexPathsForConnectlets = [each indexPathsForConnectlets];
			NSArray *outIndexPath = [indexPathsForConnectlets objectAtIndex:0];
			NSArray *inIndexPath = [indexPathsForConnectlets objectAtIndex:1];
			NSObject<SHNodeLikeProtocol> *inAtt = [copy objectForIndexPathToNode:inIndexPath];
			NSObject<SHNodeLikeProtocol> *outAtt = [copy objectForIndexPathToNode:outIndexPath];
			NSAssert(inAtt, @"fuck - no inAtt");
			NSAssert(outAtt, @"fuck - no outAtt");
			NSAssert([inAtt isKindOfClass:[SHProtoAttribute class]], @"fuck - wrong class");
			NSAssert([outAtt isKindOfClass:[SHProtoAttribute class]], @"fuck - wrong class");
			
			[copy _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt andInletOfAtt:(SHProtoAttribute *)inAtt undoManager:nil];
			NSAssert([copy interConnectorFor:(SHProtoAttribute *)outAtt and:(SHProtoAttribute *)inAtt], @"fuck - failed to recreate the connection");

		}

	}
	return copy;
}

- (void)encodeWithCoder:(NSCoder *)coder {

	[super encodeWithCoder:coder];
	[coder encodeObject:_childContainer forKey:@"childContainer"];
}

/* purpose is to check if copy worked correctly? */
- (BOOL)isEquivalentTo:(id)anObject {

	NSParameterAssert(anObject);

	if([super isEquivalentTo:anObject]==NO)
		return NO;
	
	SHChildContainer *dup = ((SHParent *)anObject)->_childContainer;
	NSAssert(dup!=nil, @"container cant be nil");
	if([_childContainer isEqualToContainer:dup]==NO)
		return NO;
	return YES;
}

#pragma mark Stuff needed for adding and removing children
- (BOOL)checkItemsAreValidChildren:(NSArray *)objects {

	NSParameterAssert([objects count]);

	for( SHChild<SHNodeLikeProtocol> *child in objects )
	{
		if( [child conformsToProtocol:@protocol(SHNodeLikeProtocol)]==NO && 
		   [child conformsToProtocol:@protocol(SHInputLikeProtocol)]==NO && 
		   [child conformsToProtocol:@protocol(SHOutputLikeProtocol)]==NO &&
		   [child isKindOfClass:[SHInterConnector class]]==NO)
			return NO;
		if( child.parentSHNode!=nil )
			return NO;
		if([self isNodeParentOfMe:(id)child])
			return NO;
	}
	return YES;
}

// Given a load of legal objects, make sure each has a name that doesnt clash with existing names
- (NSArray *)_prepareObjectsNamesForAdding:(NSArray *)objects withUndoManager:(NSUndoManager *)um {

	NSParameterAssert([objects count]);

	/* get current or placeholder filenames */
	NSArray *startingFileNames = [NodeName currentOrNewNamesForNodes: objects];

	/* transform them to unique filenames */
	NSArray *uniqueNames = [NodeName uniqueChildNamesBasedOn:startingFileNames forSet:_childContainer];
	NSAssert2([objects count]==[uniqueNames count], @"not the correct amont of UniqueNames for objects %i - %i", [objects count], [uniqueNames count]);

	// give the objects the unique names
	[NodeName _setNamesOfObjects:objects toNames:uniqueNames withUndoManager:um];
	return uniqueNames;
}

/* set parent for single object */
- (void)_makeParentOfObject:(SHChild *)value undoManager:(NSUndoManager *)theUmm {
	
	NSParameterAssert(value);
	[value setParentSHNode:self];
	[[theUmm prepareWithInvocationTarget:self] _undoSetParentOfObject:value undoManager:theUmm];
	[value hasBeenAddedToParentSHNode];
}

- (void)_undoSetParentOfObject:(SHChild *)value undoManager:(NSUndoManager *)theUmm {
	
	NSParameterAssert(value);
	[value isAboutToBeDeletedFromParentSHNode];
	[value setParentSHNode:nil];
	[[theUmm prepareWithInvocationTarget:self] _makeParentOfObject:value undoManager:theUmm];
}

/* set parent for Array of objects */
- (void)_makeParentOfObjects:(NSArray *)values undoManager:(NSUndoManager *)theUmm {

	NSParameterAssert([values count]);
	[values makeObjectsPerformSelector:@selector(setParentSHNode:) withObject:self];
	[[theUmm prepareWithInvocationTarget:self] _undoSetParentOfObjects:values undoManager:theUmm];
	[values makeObjectsPerformSelector:@selector(hasBeenAddedToParentSHNode)];
}

- (void)_undoSetParentOfObjects:(NSArray *)values undoManager:(NSUndoManager *)theUmm {
	
	NSParameterAssert([values count]);
	[values makeObjectsPerformSelector:@selector(isAboutToBeDeletedFromParentSHNode)];
	[values makeObjectsPerformSelector:@selector(setParentSHNode:) withObject:nil];
	[[theUmm prepareWithInvocationTarget:self] _makeParentOfObjects:values undoManager:theUmm];
}

#pragma mark adding children

/* These add and set the parent and are undoable. They Don't check for connections etc. */

- (void)addChild:(SHChild *)object atIndex:(NSInteger)index undoManager:(NSUndoManager *)um {

	NSParameterAssert(object);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	NSArray *objects = [NSArray arrayWithObject:object];
	NSIndexSet *indexes=nil;
	if(index!=-1)
		indexes = [NSIndexSet indexSetWithIndex:index];
	[self addItemsOfSingleType:objects atIndexes:indexes undoManager:um];
}

/* Indexes can be nil */
- (void)addItemsOfSingleType:(NSArray *)objects atIndexes:(NSIndexSet *)indexes undoManager:(NSUndoManager *)um {

	NSParameterAssert( [objects count] );
	NSParameterAssert( indexes!=nil ? [objects count]==[indexes count] : [indexes count]==0 );
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	if( ![self checkItemsAreValidChildren:objects])
		[NSException raise:@"Not valid children" format:@""];

	NSArray *preparedNames = [self _prepareObjectsNamesForAdding:objects withUndoManager:um];

	/* we need strings, not NodeNames. could change this? */
	NSArray *keys = [NodeName stringsFromNodeNames:preparedNames];

	NSAssert2([objects count]==[keys count], @"not the correct amont of keys for objects %i - %i", [objects count], [keys count]);
	id ob = [objects objectAtIndex:0];
	if([ob isKindOfClass:[SHParent class]]){
		[_childContainer _addNodes:objects atIndexes:indexes withKeys:keys undoManager:um];
	} else if([ob isKindOfClass:[SHProtoInputAttribute class]]){
		[_childContainer _addInputs:objects atIndexes:indexes withKeys:keys undoManager:um];
	} else if([ob isKindOfClass:[SHProtoOutputAttribute class]]){
		[_childContainer _addOutputs:objects atIndexes:indexes withKeys:keys undoManager:um];
	} else {
		[NSException raise:@"Cant add object of that type" format:@""];
	}

	[self _makeParentOfObjects:objects undoManager:um];
}

// bear in mind that outAttr isn't nesarily an SHOutputAttribute or inAttr an SHInputAttribute
- (void)_makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAttr andInletOfAtt:(SHProtoAttribute *)inAttr undoManager:(NSUndoManager *)um {

	NSParameterAssert(outAttr);
	NSParameterAssert(inAttr);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	/* New test bit to make sure we have the correct node to make the new interconnector in */
	/* The correct node is either us or one of our children */
	if(NO==[self _validParentForConnectionBetweenOutletOf:outAttr andInletOfAtt:inAttr])
		return;
	
	//-- needs a name if going to set it in a Dictionary
	SHInterConnector *anInterConnector = [SHInterConnector interConnector];
	//	[anInterConnector setTemporaryID: UID];
	NSArray *icsToAdd = [NSArray arrayWithObject:anInterConnector];
	[self _prepareObjectsNamesForAdding:icsToAdd withUndoManager:um];

	[_childContainer _addInterConnector:anInterConnector between:outAttr and:inAttr undoManager:um];
	[self _makeParentOfObjects:icsToAdd undoManager:um];	
}

/* There are several valid connections.. */
- (BOOL)_validParentForConnectionBetweenOutletOf:(SHProtoAttribute *)outAttr andInletOfAtt:(SHProtoAttribute *)inAttr {
	
	NSParameterAssert(outAttr);
	NSParameterAssert(inAttr);
	
	BOOL amValidParent = NO;
	NSObject<ChildAndParentProtocol> *outParent = [outAttr parentSHNode];
	NSObject<ChildAndParentProtocol> *inParent = [inAttr parentSHNode];
	
	if(outParent==inParent){
		if(outParent==self)
			//-- ok
			amValidParent = YES;
		
	} else {
		// -- [outAttr parentSHNode] must contain [inAttr parentSHNode] -- OR -- [inAttr parentSHNode] must contain [outAttr parentSHNode] -- OR‚Äö√Ñ√∂‚àö√ë‚àö‚àÇ‚Äö√†√∂‚àö√´‚Äö√†√∂‚Äö√†√á
		BOOL p2IsUpperNode = [outParent isNodeParentOfMe:inParent];
		BOOL p1IsUpperNode = [inParent isNodeParentOfMe:outParent];
		
		if(p2IsUpperNode || p1IsUpperNode) {
			
			//-- ok, but need to redirect the message call
			//-- make interconnector in the upper node
			NSObject<SHParentLikeProtocol> *realInterConnectorParent = p2IsUpperNode ? inParent : outParent;
			if(realInterConnectorParent==self){
				//-- ok
				amValidParent = YES;
			}
		} else {
			//-- i think this is one more important case
			// both attributes are inside different nodes that are children of me
			if([outParent parentSHNode]==[inParent parentSHNode]){
				if([outParent parentSHNode]==self){
					//-- ok
					amValidParent = YES;
				}
			}
		}
		//if the inner node is an input then we cant go out from it
		if(amValidParent && outParent!=self && [outAttr isKindOfClass:[SHProtoInputAttribute class]])
			return NO;
		
		//if the inner node is an output then we cant go in to it
		if(amValidParent && inParent!=self && [inAttr isKindOfClass: [SHProtoOutputAttribute class]])
			return NO;
	}
	return amValidParent;
}

#pragma mark removing children


/* These seems to assume that interconnectors have been removed - dont use directly - use nodegraphmodel methods */
- (void)deleteNodes:(NSArray *)nodes undoManager:(NSUndoManager *)um {
    
    NSParameterAssert([nodes count]>0);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	for( SHParent *child in nodes )
		NSAssert([self isChild:child], @"can't delete a Node that is not a child of me");
    [_childContainer clearSelectionNoUndo]; /* Not Undoable */
    [_childContainer _removeNodes:nodes undoManager:um];
	[self _undoSetParentOfObjects:nodes undoManager:um];
}

/* These seems to assume that interconnectors have been removed - dont use directly - use nodegraphmodel methods */
- (void)deleteInputs:(NSArray *)inputs undoManager:(NSUndoManager *)um {
    
    NSParameterAssert([inputs count]>0);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

    //--check all are inputs in this node
    for( SHProtoInputAttribute *inp in inputs )
        NSAssert([self isChild:inp], @"can't delete an input that is not a child of me");
    [_childContainer clearSelectionNoUndo];        /* Not Undoable */
    [_childContainer _removeInputs:inputs undoManager:um];
	[self _undoSetParentOfObjects:inputs undoManager:um];
}

/* These seems to assume that interconnectors have been removed - dont use directly - use nodegraphmodel methods */
- (void)deleteOutputs:(NSArray *)outputs undoManager:(NSUndoManager *)um {
	
    NSParameterAssert([outputs count]>0);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	for( SHProtoOutputAttribute *child in outputs )
		NSAssert([self isChild:child], @"can't delete an output that is not a child of me");
    [_childContainer clearSelectionNoUndo];        /* Not Undoable */
    [_childContainer _removeOutputs:outputs undoManager:um];
	[self _undoSetParentOfObjects:outputs undoManager:um];
}

// ICs may be deleted from a node that is not current in the model. Special case
- (void)deleteInterconnectors:(NSArray *)ics undoManager:(NSUndoManager *)um {
	
    NSParameterAssert([ics count]>0);

#ifdef DEBUG
	for( SHInterConnector *child in ics ){
		NSAssert([self isChild:child], @"can't delete an interconnector that is not a child of me");
	}
#endif
    [_childContainer clearSelectionNoUndo];        /* Not Undoable */
    [_childContainer _removeInterConnectors:ics undoManager:um];
	[self _undoSetParentOfObjects:ics undoManager:um];
}

- (void)deleteChildren:(NSArray *)childrenToDelete undoManager:(NSUndoManager *)um { 
	
	NSParameterAssert([childrenToDelete count]);
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	NSMutableArray *nodesSet=nil, *inputsSet=nil, *outputsSet=nil;
	NSMutableSet *icSet=nil;
	for( id child in childrenToDelete )
	{
		NSAssert([self isChild:child], @"can't delete an object that is not a child of me");
		
		if([child isKindOfClass:[SHParent class]]){
			if(!nodesSet)
				nodesSet = [NSMutableArray array];
			[nodesSet addObject:child];
		} else if([child isKindOfClass:[SHProtoOutputAttribute class]]){
			if(!outputsSet)
				outputsSet = [NSMutableArray array];
			[outputsSet addObject:child];
		} else if([child isKindOfClass:[SHProtoInputAttribute class]]){
			if(!inputsSet)
				inputsSet = [NSMutableArray array];
			[inputsSet addObject:child];
		} else if([child isKindOfClass:[SHInterConnector class]]){
			if(!icSet)
				icSet = [NSMutableSet set];
			[icSet addObject:child];
		}
	}

	for( SHParent *eachNode in nodesSet ){
		NSArray *ics = [self allConnectionsToChild:eachNode];
		if([ics count]){
			if(!icSet)
				icSet = [NSMutableSet set];
			[icSet addObjectsFromArray:ics];
		}
	}
	for( SHProtoInputAttribute *eachInput in inputsSet ){
		NSArray *ics = [eachInput allConnectedInterConnectors];
		if([ics count]){
			if(!icSet)
				icSet = [NSMutableSet set];
			[icSet addObjectsFromArray:ics];
		}
	}
	for( SHProtoOutputAttribute *eachOutput in outputsSet ){
		NSArray *ics = [eachOutput allConnectedInterConnectors];
		if([ics count]){
			if(!icSet)
				icSet = [NSMutableSet set];
			[icSet addObjectsFromArray:ics];
		}
	}
	
	if(icSet){
		// The interconnectors will not nesasarily be children of me
		// This is where our 'only act on the currentNode' s[ectacularly falls down
		NSAssert(_otherNodesAffectedByRemove==nil, @"hmm");
		NSSet *nodesAffectedByRemove = [SHParent _removeICSFromRespectiveParents:icSet undoManager:um];
		_otherNodesAffectedByRemove = [nodesAffectedByRemove setMinus:self];
	}

	// The order of these is critical for AllChildrenFilter
	if(outputsSet)
		[self deleteOutputs:outputsSet undoManager:um];
	if(inputsSet)
		[self deleteInputs:inputsSet undoManager:um];
	if(nodesSet)
		[self deleteNodes:nodesSet undoManager:um];
	
	// This is super important, dont return before you do this 
	_otherNodesAffectedByRemove = nil;
}


- (void)deleteChild:(SHChild *)child undoManager:(NSUndoManager *)um {
	
	NSParameterAssert(child);
	NSAssert([self isChild:child], @"can't delete an interconnector that is not a child of me");
	NSAssert(_nodeGraphModel==nil || [_nodeGraphModel currentNodeGroup]==self, @"v2 can only edit current node");

	// iterate through all connectors associated with the node we are going to delete
	if( [child respondsToSelector:@selector(allConnectedInterConnectors)] )
	{
		NSMutableArray *nodeConnectors = [(id)child allConnectedInterConnectors];
		if([nodeConnectors count]){
			NSAssert(_otherNodesAffectedByRemove==nil, @"hmm");
			NSSet *nodesAffectedByRemove = [SHParent _removeICSFromRespectiveParents:[NSSet setWithArray:nodeConnectors] undoManager:um];
			_otherNodesAffectedByRemove = [nodesAffectedByRemove setMinus:self];
		}
	}

	[_childContainer clearSelectionNoUndo];  /* Not Undoable */

	if([child isKindOfClass:[SHParent class]]){
		[_childContainer _removeNode:(SHParent *)child withKey:[child name].value undoManager:um];
		
	} else if([child isKindOfClass:[SHProtoOutputAttribute class]]){
		[_childContainer _removeOutput:(SHProtoOutputAttribute *)child withKey:[child name].value undoManager:um];
		
	} else if([child isKindOfClass:[SHProtoInputAttribute class]]){
		[_childContainer _removeInput:(SHProtoInputAttribute *)child withKey:[child name].value undoManager:um];
		
	} else if([child isKindOfClass:[SHInterConnector class]]){
		[_childContainer _removeInterConnector:(SHInterConnector *)child undoManager:um];
	}
	[self _undoSetParentOfObject:child undoManager:um];
	
	// This is super important, dont return before you do this 
	_otherNodesAffectedByRemove = nil;
}

#pragma mark Utilities
- (BOOL)isNameUsedByChild:(NSString *)aName {
	NSParameterAssert(aName);
	return [self childWithKey:aName] ? YES : NO;
}

- (SHChild<SHNodeLikeProtocol> *)childWithKey:(NSString *)aName  {
	NSParameterAssert(aName);
	return [_childContainer childWithKey:aName];
}

- (NSUInteger)indexOfChild:(id)child {
	NSParameterAssert(child);
	return [_childContainer indexOfChild:child];
}

// Reorder
- (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:(NSUndoManager *)um {	
	[_childContainer setIndexOfChild:child to:index undoManager:um];
}

// Table drag
- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)index undoManager:(NSUndoManager *)um {
	[_childContainer moveChildren:children toInsertionIndex:index undoManager:um];
}

- (SHChild *)nodeAtIndex:(NSUInteger)mindex {
	return [_childContainer nodeAtIndex:mindex];
}

- (SHChild *)inputAtIndex:(NSUInteger)mindex {
	return [_childContainer inputAtIndex:mindex];
}

- (SHChild *)outputAtIndex:(NSUInteger)mindex {
	return [_childContainer outputAtIndex:mindex];
}

- (SHChild *)connectorAtIndex:(NSUInteger)mindex {
	return [_childContainer connectorAtIndex:mindex];
}

- (BOOL)isChild:(id)value {
	NSParameterAssert(value);
	return [_childContainer isChild:value];
}

- (BOOL)isLeaf {
	return [_childContainer isEmpty];
}

- (SHOrderedDictionary *)nodesInside {
	return _childContainer.nodesInside;
}

- (SHOrderedDictionary *)inputs {
	return _childContainer.inputs;
}

- (SHOrderedDictionary *)outputs {
	return _childContainer.outputs;
}

- (SHOrderedDictionary *)shInterConnectorsInside {
	return _childContainer.shInterConnectorsInside;
}

- (NSUInteger)countOfChildren {
	return [_childContainer countOfChildren];
}

/* return an array of the nodes in reverse order (aNode first, self last) */
- (NSArray *)reverseNodeChainToNode:(NSObject<SHNodeLikeProtocol> *)aNode {
	
	NSParameterAssert(aNode);
	NSMutableArray *nodeChain = [NSMutableArray array];
	
	if([aNode isNodeParentOfMe:self])
	{
		[nodeChain addObject:aNode];
		NSObject<ChildAndParentProtocol> *nodeParent = [aNode parentSHNode];
		while(nodeParent!=self){
			[nodeChain addObject:nodeParent];
			nodeParent = [nodeParent parentSHNode];
			NSAssert(nodeParent!=nil, @"eh?");
		}
		[nodeChain addObject:nodeParent];
	} else {
		NSException* myException = [NSException exceptionWithName:@"childNotFound" reason:@"reverseNodeChainToNode: no index cause it isnt even a child you spak" userInfo:nil];
		[myException raise];
	}
	return nodeChain;
}

/* return a path like @"node6/circle/ic4" - ie the node names */
- (SH_Path *)relativePathToChild:(NSObject<SHNodeLikeProtocol> *)aNode {
	
	NSParameterAssert(aNode);

	// nodeChain should contain self & aNode so will always be at least 2 long
	NSArray* nodeChain = [self reverseNodeChainToNode:aNode];
	NSAssert([nodeChain count]>1, @"wrong - unless aNode isnt a parent..");
	
	int i, count = [nodeChain count];
	SHChild *nn = [nodeChain objectAtIndex:count-2];
	NSString *name = [nn name].value;
	NSAssert(name, @"cant get relativePathToChild without a name");
	SH_Path* relPath = [SH_Path pathWithString:name];
	if(count>1)
		for(i=(count-3);i>-1;i--)
		{
			nn = [nodeChain objectAtIndex:i];
			name = [nn name].value;
			NSAssert(name, @"cant get relativePathToChild without a name");
			relPath = [relPath append:name];
		}
	return relPath;
}

- (NSObject<SHNodeLikeProtocol> *)childAtRelativePath:(SH_Path *)relativeChildPath {
	
	NSParameterAssert(relativeChildPath);

	NSArray* pc = [relativeChildPath pathComponents];
	id node = self;
	for( NSString *nodeName in pc ) 
	{
		node = [node childWithKey:nodeName];
		if(node==nil)
			return nil;
	}
	return node;
}

// ===========================================================
// - indexPathToNode:
//	returns an array like [n3, n2, n2, i2] that is the path to node
// ===========================================================
- (NSArray *)indexPathToNode:(NSObject<SHNodeLikeProtocol> *)aNode {

	NSParameterAssert(aNode);
	int index1, i;
	NSMutableArray* resultWrapper = nil;
	
	NSArray* nodeChain = [self reverseNodeChainToNode:aNode];
	NSAssert([nodeChain count]>1, @"reverseNodeChainToNode: should have raised an exception!");

	resultWrapper = [NSMutableArray arrayWithCapacity:[nodeChain count]];
	// first object in array is 'self' - skip it
	NSAssert([nodeChain lastObject]==self, @"should be");
	for(i=[nodeChain count]-2; i>-1; i--)
	{
		NSObject<SHNodeLikeProtocol> *child = [nodeChain objectAtIndex:i];
		NSObject<ChildAndParentProtocol> *parent = [child parentSHNode];
		char identifierChar;
		
		if([child isKindOfClass:[SHParent class]])
			identifierChar = 'n';
		else if([child isKindOfClass:[SHProtoInputAttribute class]])
			identifierChar = 'i';
		else if([child isKindOfClass:[SHProtoOutputAttribute class]])
			identifierChar = 'o';
		else if([child isKindOfClass:[SHInterConnector class]])
			identifierChar = 'c';
		index1 = [parent indexOfChild:child];
		[resultWrapper addObject:[NSString stringWithFormat:@"%c%i", identifierChar, index1]];
	}
	return resultWrapper;
}

- (NSObject<SHNodeLikeProtocol> *)objectForIndexPathToNode:(NSArray *)value {
	
	NSString *indexString = [value objectAtIndex:0];
	NSObject<SHNodeLikeProtocol> *ob = [self objectForIndexString:indexString];

	for( NSUInteger i=1; i<[value count]; i++ )
	{
		indexString = [value objectAtIndex:i];
		NSAssert([ob conformsToProtocol:@protocol(SHParentLikeProtocol)], @"sheet!");
		ob = [(NSObject<SHParentLikeProtocol> *)ob objectForIndexString:indexString];
	}
	return ob;
}

/* get the object represented by one of the items in the array above */
- (NSObject<SHNodeLikeProtocol> *)objectForIndexString:(NSString *)value {
	
	NSParameterAssert(value);

	/* we must parse the path to the node */
	id childObject;
	char firstChar = [value characterAtIndex:0];
	int itemIndex = [[value substringFromIndex:1] intValue];
	switch(firstChar){
		case 'n':
			childObject = [_childContainer.nodesInside objectAtIndex:itemIndex];
			break;
		case 'i':
			childObject = [_childContainer.inputs objectAtIndex:itemIndex];
			break;
		case 'o':
			childObject = [_childContainer.outputs objectAtIndex:itemIndex];
			break;
		case 'c':
			childObject = [_childContainer.shInterConnectorsInside objectAtIndex:itemIndex];
			break;
		default:
			logError(@"error");
			return nil;
	}
	return childObject;
}

- (NSSet *)otherNodesAffectedByRemove {
	return _otherNodesAffectedByRemove;
}
@end
