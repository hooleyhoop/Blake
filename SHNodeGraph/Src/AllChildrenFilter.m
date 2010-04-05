//
//  AllChildrenFilter.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/05/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "AllChildrenFilter.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import <SHShared/SHShared.h>
#import "NodeProxy.h"
#import "AllChildProxy.h"
#import "SHCustomMutableArray.h"
#import "DelayedNotificationCoalescer.h"
#import <objc/message.h>

@implementation AllChildrenFilter

static NSString *ObservationCntx = @"AllChildrenFilter";

#pragma mark -
#pragma mark class methods
+ (NSString *)observationCntx {
	return ObservationCntx;
}

/* Set up which Properties we want to observe in the model */
+ (NSArray *)modelKeyPathsToObserve {
	static NSArray *modelKeyPathsToObserve = nil;
	if(!modelKeyPathsToObserve)
		modelKeyPathsToObserve = [[NSArray arrayWithObjects:
			@"childContainer.nodesInside.array", 
			@"childContainer.inputs.array", 
			@"childContainer.outputs.array", 
			@"childContainer.shInterConnectorsInside.array", 
			
			@"childContainer.nodesInside.selection",
			@"childContainer.inputs.selection",
			@"childContainer.outputs.selection",
			@"childContainer.shInterConnectorsInside.selection",
			nil] retain];
	return modelKeyPathsToObserve;
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillChangeKeyPath:(NSString *)keyPath {

	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillChange:nodesInside_to:from:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelWillChange:inputs_to:from:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelWillChange:outputs_to:from:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelWillChange:shInterConnectorsInside_to:from:);
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillChange:nodesInsideSelection_to:from:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelWillChange:inputsSelection_to:from:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelWillChange:outputsSelection_to:from:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelWillChange:shInterConnectorsInsideSelection_to:from:);
	
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForChangedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelChanged:nodesInside_to:from:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelChanged:inputs_to:from:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelChanged:outputs_to:from:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelChanged:shInterConnectorsInside_to:from:);
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelChanged:nodesInsideSelection_to:from:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelChanged:inputsSelection_to:from:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelChanged:outputsSelection_to:from:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelChanged:shInterConnectorsInsideSelection_to:from:);

	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillInsertKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillInsert:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelWillInsert:inputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelWillInsert:outputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelWillInsert:shInterConnectorsInside:atIndexes:);
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillInsert:nodesInsideSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelWillInsert:inputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelWillInsert:outputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelWillInsert:shInterConnectorsInsideSelection:atIndexes:);
	
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForInsertedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelInserted:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelInserted:inputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelInserted:outputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelInserted:shInterConnectorsInside:atIndexes:);

	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelInserted:nodesInsideSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelInserted:inputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelInserted:outputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelInserted:shInterConnectorsInsideSelection:atIndexes:);

	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillReplaceKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillReplace:nodesInside:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelWillReplace:inputs:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelWillReplace:outputs:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelWillReplace:shInterConnectorsInside:with:atIndexes:);
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillReplace:nodesInsideSelection:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelWillReplace:inputsSelection:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelWillReplace:outputsSelection:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelWillReplace:shInterConnectorsInsideSelection:with:atIndexes:);
	
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelReplaced:nodesInside:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelReplaced:inputs:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelReplaced:outputs:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelReplaced:shInterConnectorsInside:with:atIndexes:);

	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelReplaced:nodesInsideSelection:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelReplaced:inputsSelection:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelReplaced:outputsSelection:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelReplaced:shInterConnectorsInsideSelection:with:atIndexes:);

	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillRemoveKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillRemove:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelWillRemove:inputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelWillRemove:outputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelWillRemove:shInterConnectorsInside:atIndexes:);
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillRemove:nodesInsideSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelWillRemove:inputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelWillRemove:outputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelWillRemove:shInterConnectorsInsideSelection:atIndexes:);
	
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForRemovedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelRemoved:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.array"])
		return @selector(modelRemoved:inputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.array"])
		return @selector(modelRemoved:outputs:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.array"])
		return @selector(modelRemoved:shInterConnectorsInside:atIndexes:);

	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelRemoved:nodesInsideSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.inputs.selection"])
		return @selector(modelRemoved:inputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.outputs.selection"])
		return @selector(modelRemoved:outputsSelection:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.shInterConnectorsInside.selection"])
		return @selector(modelRemoved:shInterConnectorsInsideSelection:atIndexes:);

	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil; // COV_NF_LINE
}

+ (Class)nodeProxyClass {
	return [AllChildProxy class];
}

#pragma mark init methods
- (id)init {
	
	self = [super init];
	if( self ){
//		_proxyMaker = [[AllChildrenProxyFactory alloc] init];
		_contentInsertionNotificationCoalescer  = [[DelayedNotificationCoalescer alloc] initWithFilter:self mode:@"ContentInsert"];
		_contentRemovedNotificationCoalescer = [[DelayedNotificationCoalescer alloc] initWithFilter:self mode:@"ContentRemoved"];
		_selectionChangedNotificationCoalescer = [[DelayedNotificationCoalescer alloc] initWithFilter:self mode:@"SelectionChanged"];
	}
	return self;
}

//- (id)retain {
//	return [super retain];
//}
//
//- (void)release {
//	[super release];
//}

- (void)dealloc {
	
	if(_model!=nil)
		logError(@"who did this?");
	NSAssert(_model==nil, @"you must explicitly clean up before releasing");
	[_contentInsertionNotificationCoalescer release];
	[_contentRemovedNotificationCoalescer release];
	[_selectionChangedNotificationCoalescer release];
//	[_proxyMaker release];
	[super dealloc];
}

#pragma mark action methods
- (void)_constructFilteredTree:(AllChildProxy *)value {
	
	// try to use our custom array utility to iterate thru all children
	SHCustomMutableArray *fakeArrayForNode = [value.originalNode allChildren];
	
	NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [fakeArrayForNode count])];
	NSMutableArray *matchedObjects = [NSMutableArray array];
	for( SHChild *addedObject in fakeArrayForNode )
	{
		// check we haven't aleady dont this
		NSAssert([value nodeProxyForNode:addedObject]==nil, @"-makeFilteredTreeUpToDate: about to add a node that the proxy already has..");
		
		AllChildProxy *makeNodeProxy = [AllChildProxy makeNodeProxyWithFilter:self object:addedObject];
		
		[matchedObjects addObject: makeNodeProxy]; /* make a proxy here, observe the content if it is a group */
		
		// V2 - important that we DO NOT use NSKeyValueObservingOptionInitial
		// This was how version one worked when we were not limited to manipulating the current node
		// if([makeNodeProxy.originalNode allowsSubpatches])
		//	[makeNodeProxy startObservingOriginalNode];
		//	}
	}
	
	/* add the Proxies of the children that we observed were added - tree is up-to-date! */
	value.indexesOfFilteredContent = newIndexes;
	value.filteredContent = matchedObjects;	
}

// Editing a child node can cause an IC to be removed from a parent. Just the ICs need rebuilding in this case.
- (void)_updateModifiedICs:(AllChildProxy *)value {
	
	[value removeICsNoLongerInNode];
}

- (void)stopObservingModel {
	[self postPendingNotificationsExcept:nil];
	[super stopObservingModel];
}

// construct a proxy for each child - dont really need the proxies for -allChildren filter, but running with it at the moment
- (void)makeFilteredTreeUpToDate:(NodeProxy *)value {
	
	NSParameterAssert( [value isKindOfClass:[AllChildProxy class]] );
	NSAssert( value.filteredTreeNeedsMaking, @"Node proxy doesnt need updating?");
	
	AllChildProxy *proxyCastToRealType = (AllChildProxy *)value;
	// to make sure this method isn't called recursively we must do this at the front rather than at the end
	proxyCastToRealType.filteredTreeNeedsMaking = NO;

	if( [value.originalNode isKindOfClass:[SHParent class]] )
	{
		if( proxyCastToRealType.icWasRemovedHint )
			[self _updateModifiedICs:proxyCastToRealType];
		else
			[self _constructFilteredTree:proxyCastToRealType];
	}
}


#pragma mark -
#pragma mark Custom Methods for responding to Model events

#pragma mark -- Children Removed --

- (void)_doPreRemoveNotification {

	NSAssert( [_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");

	/* Do our DIY notification thing */
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		/* it remains to be seen whether i need to fill in the correct arguments - will be DIFFICULT! */
		[each temp_proxy:_currentNodeProxy willRemoveContent:nil atIndexes:nil];
	}
}

- (void)_doDelayedRemoveNotification {
	
	static BOOL recursionCheck = FALSE;

	NSAssert(FALSE==recursionCheck, @"doh");
	recursionCheck = TRUE;
	
	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent], @"fired a delayed notification when we didnt need to");
	NSAssert( [_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");

	// Assume for the moment that the proxy we have observed making these changes is _currentNodeProxy.
	// It might not be - im not sure yet
	NodeProxy *targetProxy = [_contentRemovedNotificationCoalescer notificationProxy];
	NSAssert( targetProxy && targetProxy==_currentNodeProxy, @"what proxy are we operating on?");
	
	//-- need to construct the correct content and indexes, yay! 
	NSMutableArray *removedContent = [NSMutableArray array];
	NSMutableIndexSet *indexesOfRemovedContent = [NSMutableIndexSet indexSet];

	if([_contentRemovedNotificationCoalescer.nodesRemoved count]){

		NSIndexSet *indexesOfNodesRemoved = _contentRemovedNotificationCoalescer.nodesRemovedIndexes;
		[removedContent addObjectsFromArray:_contentRemovedNotificationCoalescer.nodesRemoved];
		[indexesOfRemovedContent addIndexes:indexesOfNodesRemoved];
	}
	
	if([_contentRemovedNotificationCoalescer.inputsRemoved count]){
		
		NSIndexSet *indexesOfInputsRemoved = _contentRemovedNotificationCoalescer.inputsRemovedIndexes;
		[removedContent addObjectsFromArray:_contentRemovedNotificationCoalescer.inputsRemoved];

		id anInput = [_contentRemovedNotificationCoalescer.inputsRemoved objectAtIndex:0];
		NSUInteger indexInProxy = [targetProxy indexOfOriginalObjectIdenticalTo:anInput];
		NSAssert( indexInProxy!=NSNotFound, @"doh");
		NSUInteger indexInNotification = [indexesOfInputsRemoved firstIndex];
		NSUInteger amountToShiftIndexes = indexInProxy-indexInNotification;
		
		NSMutableIndexSet *shiftedInputIndexes = [[indexesOfInputsRemoved copyIndexesShiftedBy:amountToShiftIndexes] autorelease];
		[indexesOfRemovedContent addIndexes:shiftedInputIndexes];
	}
	
	if([_contentRemovedNotificationCoalescer.outputsRemoved count]){
		
		NSIndexSet *indexesOfOutputsRemoved = _contentRemovedNotificationCoalescer.outputsRemovedIndexes;
		[removedContent addObjectsFromArray:_contentRemovedNotificationCoalescer.outputsRemoved];
		
		id anOutput = [_contentRemovedNotificationCoalescer.outputsRemoved objectAtIndex:0];
		NSUInteger indexInProxy = [targetProxy indexOfOriginalObjectIdenticalTo:anOutput];
		NSAssert( indexInProxy!=NSNotFound, @"doh");
		NSUInteger indexInNotification = [indexesOfOutputsRemoved firstIndex];
		NSUInteger amountToShiftIndexes = indexInProxy-indexInNotification;

		NSMutableIndexSet *shiftedOutputIndexes = [[indexesOfOutputsRemoved copyIndexesShiftedBy:amountToShiftIndexes] autorelease];
		[indexesOfRemovedContent addIndexes:shiftedOutputIndexes];
	}
	
	if([_contentRemovedNotificationCoalescer.icsRemoved count]){
		
		NSIndexSet *indexesOfIcsRemoved = _contentRemovedNotificationCoalescer.icsRemovedIndexes; // should be 5, 6
		[removedContent addObjectsFromArray:_contentRemovedNotificationCoalescer.icsRemoved];

		id anIC = [_contentRemovedNotificationCoalescer.icsRemoved objectAtIndex:0];
		NSUInteger indexInProxy = [targetProxy indexOfOriginalObjectIdenticalTo:anIC];
		NSAssert( indexInProxy!=NSNotFound, @"doh");
		NSUInteger indexInNotification = [indexesOfIcsRemoved firstIndex];
		NSUInteger amountToShiftIndexes = indexInProxy-indexInNotification;

		NSMutableIndexSet *shiftedICIndexes = [[indexesOfIcsRemoved copyIndexesShiftedBy:amountToShiftIndexes] autorelease];
		[indexesOfRemovedContent addIndexes:shiftedICIndexes];	
	}

	/* All objects pass the filter */
	// removedContent
	// indexesOfRemovedContent
	
	/* Send a single notification that IndexesOfFilteredContent has had insertions */

	NSArray *proxiesToRemove = [targetProxy.filteredContent objectsAtIndexes:indexesOfRemovedContent];
	
	[targetProxy removeIndexesFromIndexesOfFilteredContent: indexesOfRemovedContent];
	[targetProxy removeFilteredContentAtIndexes: indexesOfRemovedContent];

	//-- for each new index that was removed, regardless of whether it passes the test slide existing and later indexes to the left
	NSUInteger newInd = [indexesOfRemovedContent lastIndex];
	while(newInd!=NSNotFound){
		[targetProxy.indexesOfFilteredContent shiftIndexesStartingAtIndex:newInd+1 by:-1];
		newInd = [indexesOfRemovedContent indexLessThanIndex:newInd];
	}

	if(proxiesToRemove)
	/* Do our DIY notification thing */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:targetProxy didRemoveContent:proxiesToRemove atIndexes:indexesOfRemovedContent];
	}
	
	recursionCheck = FALSE;
}

// Inserted
#pragma mark -- Children Inserted --

/* Send content inserted notification */
- (void)_doPreInsertionNotification {

	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	
	/* Do our DIY notification thing */
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		/* it remains to be seen whether i need to fill in the correct arguments - will be DIFFICULT! */
		[each temp_proxy:_currentNodeProxy willInsertContent:nil atIndexes:nil];
	}
}

- (void)_doDelayedInsertionNotification {

	static BOOL recursionCheck = FALSE;
	
	NSAssert(FALSE==recursionCheck, @"doh");
	recursionCheck = TRUE;
	
	NSAssert( [_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent], @"fired a delayed notification when we didnt need to");
	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");

	// Assume for the moment that the proxy we have observed making these changes is _currentNodeProxy.
	// It might not be - im not sure yet
	NodeProxy *targetProxy = [_contentInsertionNotificationCoalescer notificationProxy];
	NSAssert( targetProxy && targetProxy==_currentNodeProxy, @"what proxy are we operating on?");

	//!!!!!here	-- need to construct the correct content and indexes, yay! 
	NSMutableArray *insertedContent = [NSMutableArray array];
	[insertedContent addObjectsFromArray:_contentInsertionNotificationCoalescer.nodesInserted];
	[insertedContent addObjectsFromArray:_contentInsertionNotificationCoalescer.inputsInserted];
	[insertedContent addObjectsFromArray:_contentInsertionNotificationCoalescer.outputsInserted];
	[insertedContent addObjectsFromArray:_contentInsertionNotificationCoalescer.icsInserted];

	NSMutableIndexSet *indexesOfInsertions = [NSMutableIndexSet indexSet];
	NSUInteger countOfNodes = [[targetProxy.originalNode nodesInside] count];
	NSUInteger countOfInputs = [[targetProxy.originalNode inputs] count];
	NSUInteger countOfOutputs = [[targetProxy.originalNode outputs] count];
	[indexesOfInsertions addIndexes:_contentInsertionNotificationCoalescer.nodesInsertedIndexes];

	NSMutableIndexSet *shiftedInputIndexes = [[_contentInsertionNotificationCoalescer.inputsInsertedIndexes copyIndexesShiftedBy:countOfNodes] autorelease];
	[indexesOfInsertions addIndexes:shiftedInputIndexes];
	
	NSMutableIndexSet *shiftedOutputIndexes = [[_contentInsertionNotificationCoalescer.outputsInsertedIndexes copyIndexesShiftedBy:countOfNodes+countOfInputs] autorelease];
	[indexesOfInsertions addIndexes:shiftedOutputIndexes];
	
	NSMutableIndexSet *shiftedICIndexes = [[_contentInsertionNotificationCoalescer.icsInsertedIndexes copyIndexesShiftedBy:countOfNodes+countOfInputs+countOfOutputs] autorelease];
	[indexesOfInsertions addIndexes:shiftedICIndexes];

	/* REMEMBER! Filter updates the proxy tree! */
	
	// -- node could be moved OR Inserted,
	// -- create or get the proxies for the inserted content - This is all the same as in the other filter - REFACTOR
	NSMutableArray *proxiesForSuccessFullObjects = [NSMutableArray array];

	for( id each in insertedContent )
	{
		int existingIndex = [targetProxy indexOfOriginalObjectIdenticalTo:each];
		if( existingIndex!=NSNotFound )
		{
			// YES! we already have this - it must be a reorder
			// YES! we already have this - it must be a reorder
			NodeProxy *existingProxy = [[[targetProxy objectInFilteredContentAtIndex:existingIndex] retain] autorelease];
			NSAssert(existingProxy!=nil, @"hmm, i thought we already had it?");
			[proxiesForSuccessFullObjects addObject:existingProxy];
			
			/* 
			 Carefully remove the node from it's existing position without triggering a KVO notification. we will re-add it as if it is a new node 
			 Luckily we dont have to do and cleaning up at the moment - just the remove and re-add. If we soup-up proxy we may need to do more. sheeeet.
			 */
			[targetProxy.filteredContent removeObjectAtIndex:existingIndex];

		} else {
			// NO, we dont have this - must be adding a new node
			AllChildProxy *newProxy = [AllChildProxy makeNodeProxyWithFilter:self object:each];
			[proxiesForSuccessFullObjects addObject:newProxy];
		}
	}
	
	// update the proxy's children and stuff - this is also same as in the other filter
	[targetProxy insertFilteredContent:proxiesForSuccessFullObjects atIndexes:indexesOfInsertions];
	[targetProxy addIndexesToIndexesOfFilteredContent: indexesOfInsertions];

	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		[each temp_proxy:targetProxy didInsertContent:proxiesForSuccessFullObjects atIndexes:indexesOfInsertions];
	}
	
	recursionCheck = FALSE;
}

#pragma mark -- Children Selected --

/* Send selection Changed Notification */
- (void)_doPreSelectionNotification {

	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	
	/* Do our DIY notification thing */
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		/* it remains to be seen whether i need to fill in the correct arguments - will be DIFFICULT! */
		[each temp_proxy:_currentNodeProxy willChangeSelection:nil];
	}
}

- (void)_doDelayedSelectionNotification {
		
	static BOOL recursionCheck = FALSE;
	
	NSAssert(FALSE==recursionCheck, @"doh");
	recursionCheck = TRUE;
	
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent], @"fired a delayed notification when we didnt need to");
	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	
	NodeProxy *targetProxy = [_selectionChangedNotificationCoalescer notificationProxy];
	NSAssert( targetProxy && targetProxy==_currentNodeProxy, @"what proxy are we operating on?");

	NSUInteger inputOffset = [[targetProxy.originalNode nodesInside] count];
	NSUInteger outputOffset = inputOffset + [[targetProxy.originalNode inputs] count];
	NSUInteger icOffset = outputOffset + [[targetProxy.originalNode outputs] count];
	
	NSMutableIndexSet *partialSelectionIndexesAfterEvent = [NSMutableIndexSet indexSet];
	NSMutableIndexSet *partialSelectionIndexesBeforeEvent = [NSMutableIndexSet indexSet];
	
	if(_selectionChangedNotificationCoalescer.selectedNodeIndexes){
		[partialSelectionIndexesAfterEvent addIndexes:_selectionChangedNotificationCoalescer.selectedNodeIndexes];
		[partialSelectionIndexesBeforeEvent addIndexes:_selectionChangedNotificationCoalescer.oldSelectedNodeIndexes];
	} // else {
		// -- no change in nodes - leaving a hole
	
	if(_selectionChangedNotificationCoalescer.selectedInputIndexes){
		NSMutableIndexSet *shiftedInputIndexes = [[_selectionChangedNotificationCoalescer.selectedInputIndexes copyIndexesShiftedBy:inputOffset] autorelease];
		NSMutableIndexSet *shiftedOldInputIndexes = [[_selectionChangedNotificationCoalescer.oldSelectedInputIndexes copyIndexesShiftedBy:inputOffset] autorelease];
		NSAssert( [shiftedInputIndexes count]&&[partialSelectionIndexesAfterEvent count] ? [shiftedInputIndexes firstIndex] > [partialSelectionIndexesAfterEvent lastIndex] : YES, @"oh no, index crash!");
		NSAssert( [shiftedOldInputIndexes count]&&[partialSelectionIndexesBeforeEvent count] ? [shiftedOldInputIndexes firstIndex]>[partialSelectionIndexesBeforeEvent lastIndex] : YES, @"oh no, index crash!");
		[partialSelectionIndexesAfterEvent addIndexes:shiftedInputIndexes];
		[partialSelectionIndexesBeforeEvent addIndexes:shiftedOldInputIndexes];
	} // else {
		// -- no change in inputs - leaving a hole
	
	if(_selectionChangedNotificationCoalescer.selectedOutputIndexes){
		NSMutableIndexSet *shiftedOutputIndexes = [[_selectionChangedNotificationCoalescer.selectedOutputIndexes copyIndexesShiftedBy:outputOffset] autorelease];
		NSMutableIndexSet *shiftedOLDOutputIndexes = [[_selectionChangedNotificationCoalescer.oldSelectedOutputIndexes copyIndexesShiftedBy:outputOffset] autorelease];
		NSAssert( [shiftedOutputIndexes count]&&[partialSelectionIndexesAfterEvent count] ? [shiftedOutputIndexes firstIndex] > [partialSelectionIndexesAfterEvent lastIndex] : YES, @"oh no, index crash!");
		NSAssert( [shiftedOLDOutputIndexes count]&&[partialSelectionIndexesBeforeEvent count] ? [shiftedOLDOutputIndexes firstIndex] > [partialSelectionIndexesBeforeEvent lastIndex]: YES, @"oh no, index crash!");
		[partialSelectionIndexesAfterEvent addIndexes:shiftedOutputIndexes];
		[partialSelectionIndexesBeforeEvent addIndexes:shiftedOLDOutputIndexes];
	} // else
		// -- no change in outputs - leaving a hole
	
	if(_selectionChangedNotificationCoalescer.selectedICIndexes){
		NSMutableIndexSet *shiftedICIndexes = [[_selectionChangedNotificationCoalescer.selectedICIndexes copyIndexesShiftedBy:icOffset] autorelease];
		NSMutableIndexSet *shiftedOLDICIndexes = [[_selectionChangedNotificationCoalescer.oldSelectedICIndexes copyIndexesShiftedBy:icOffset] autorelease];
		NSAssert( [shiftedICIndexes count]&&[partialSelectionIndexesAfterEvent count] ? [shiftedICIndexes firstIndex] > [partialSelectionIndexesAfterEvent lastIndex] : YES, @"oh no, index crash!");
		NSAssert( [shiftedOLDICIndexes count]&&[partialSelectionIndexesBeforeEvent count] ? [shiftedOLDICIndexes firstIndex] > [partialSelectionIndexesBeforeEvent lastIndex] : YES, @"oh no, index crash!");
		[partialSelectionIndexesAfterEvent addIndexes:shiftedICIndexes];
		[partialSelectionIndexesBeforeEvent addIndexes:shiftedOLDICIndexes];
	} // else {
		// -- no change in ics - leaving a hole

	
	NSMutableIndexSet *outOfDateProxySelectionIndexes = [[targetProxy.filteredContentSelectionIndexes mutableCopy] autorelease];

//	-- What have we got?
//	--------------------
//	-- 1) out of date selection indexes
//	-- 2) selectionIndexes before event		"partialSelectionIndexesBeforeEvent" 
//	-- 3) selectionIndexes after event		"partialSelectionIndexesAfterEvent"
//	
//	BOTH OF THESE HAVE HOLES IF NO SELECTION EVENT HAPPENED FOR THAT TYPE
//	
//	-- What do we need?
//	--------------------
//	-- 1) indexes of elements selected in this event
//	-- 2) indexes of elements deselected in this event
//	-- 3) current selection indexes
//
//	1 {
//		items in partialSelectionIndexesAfterEvent but not partialSelectionIndexesBeforeEvent
//	}
//	
//	2 {
//		items in partialSelectionIndexesBeforeEvent but not partialSelectionIndexesAfterEvent
//	}
//	
//	3 {
//		outOfDateProxySelectionIndexes + selected - deselected
//	}
//	
//	-- check
//	--------
//	-- get all selection indexes from current node and assert that they are the same
	
	
	NSMutableIndexSet *newSelectedItemsThatPassFilter = [[partialSelectionIndexesAfterEvent mutableCopy] autorelease];
	[newSelectedItemsThatPassFilter removeIndexes:partialSelectionIndexesBeforeEvent];

	NSMutableIndexSet *deselectedObjectsThatPassFilter = [[partialSelectionIndexesBeforeEvent mutableCopy] autorelease];
	[deselectedObjectsThatPassFilter removeIndexes:partialSelectionIndexesAfterEvent];
	
	[outOfDateProxySelectionIndexes removeIndexes:deselectedObjectsThatPassFilter];
	[outOfDateProxySelectionIndexes addIndexes:newSelectedItemsThatPassFilter];
	
	NSIndexSet *calculatedCurrentSelection = outOfDateProxySelectionIndexes;
	
	//	if( [partialSelectionIndexesBeforeEvent count]>0 ) 
//	{
//		//-- Remove the selections
//		// only remove objects that aren't in new selection as well!
//		NSUInteger oldSelectionIndex = [partialSelectionIndexesBeforeEvent firstIndex];
//		while( oldSelectionIndex!=NSNotFound )
//		{
//			if( ![partialSelectionIndexesAfterEvent containsIndex:oldSelectionIndex] )
//			{
//				SHNode *originalNode = targetProxy.originalNode;
//				SHNode *deselectedObject = [originalNode childAtIndex:oldSelectionIndex];
//				NSAssert(deselectedObject, @"heh!");
//				NSAssert([outOfDateProxySelectionIndexes containsIndex:oldSelectionIndex], @"How can we deselect an object that we have necer selected?");
//				[deselectedObjectsThatPassFilter addIndex:oldSelectionIndex];
//			}
//			oldSelectionIndex=[partialSelectionIndexesBeforeEvent indexGreaterThanIndex:oldSelectionIndex];
//		}
//	}
//			
//	//-- Add the new selections
//	
//	if([partialSelectionIndexesAfterEvent count]>0)
//	{
//		NSUInteger newSelectionIndex = [partialSelectionIndexesAfterEvent firstIndex];
//		while( newSelectionIndex!=NSNotFound )
//		{
//			id selectedObject = [targetProxy.originalNode childAtIndex:newSelectionIndex];
//			NSAssert(selectedObject!=nil, @"must have this");
////				NSUInteger indexOfSelectedOb = [targetProxy indexOfOriginalObjectIdenticalTo:selectedObject];
////				if(indexOfSelectedOb!=NSNotFound)
////				{
//			NSAssert([targetProxy.originalNode countOfChildren]>newSelectionIndex, @"bad index observeValueForKeyPath selection2");
//				
//			/* This item may well already be selected - we still need it for our DIY notification */
//#warning! shit here			[selectedItemsThatPassFilter addIndex: newSelectionIndex];
//				
//			/* But that doesn't mean we must select it again as we didnt deselect items from old selection if they are also in new selection */
//			if( [outOfDateProxySelectionIndexes containsIndex:newSelectionIndex]==NO )
//				[newSelectedItemsThatPassFilter addIndex: newSelectionIndex];
////				}
//			newSelectionIndex=[partialSelectionIndexesAfterEvent indexGreaterThanIndex:newSelectionIndex];
//		}
//	}

	// ASSERT CORRECTNESS
	NSMutableIndexSet *actualCurrentIndexes = [NSMutableIndexSet indexSet];
	[actualCurrentIndexes addIndexes:[_currentNodeProxy.originalNode selectedNodesInsideIndexes]]; 
	[actualCurrentIndexes addIndexes:[[[_currentNodeProxy.originalNode selectedInputIndexes] copyIndexesShiftedBy:inputOffset] autorelease]];
	[actualCurrentIndexes addIndexes:[[[_currentNodeProxy.originalNode selectedOutputIndexes] copyIndexesShiftedBy:outputOffset] autorelease]];
	[actualCurrentIndexes addIndexes:[[[_currentNodeProxy.originalNode selectedInterConnectorIndexes] copyIndexesShiftedBy:icOffset] autorelease]];
	NSAssert([calculatedCurrentSelection isEqualToIndexSet:actualCurrentIndexes], @"gone wrong keeping track of selection indexes");
	
	
	// SEND THE CUSTOM NOTIFICATION
	// this is a terible hack, instead of passing in the changeIndexes, pass in an array that contains the change indexes as well as other stuff
	NSArray *dataToPassToNotification = [NSArray arrayWithObjects:actualCurrentIndexes, newSelectedItemsThatPassFilter, deselectedObjectsThatPassFilter, nil];
		
	/* Do our DIY notification thing */
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		[each temp_proxy:targetProxy willChangeSelection:(id)dataToPassToNotification];
	}
	
	// remove the unselected
	if([deselectedObjectsThatPassFilter count]>0)
		[targetProxy removeIndexesFromSelection:deselectedObjectsThatPassFilter];
		
	// add the new selections
	if([newSelectedItemsThatPassFilter count]>0){
		[targetProxy addIndexesToSelection: newSelectedItemsThatPassFilter];
	} 
	
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		[each temp_proxy:targetProxy didChangeSelection:(id)dataToPassToNotification]; // Hack
	}
	
	recursionCheck = FALSE;
}

#pragma mark -
#pragma mark -- Children Inserted --
- (void)_willInsertSomethingIntoProxy:(NodeProxy *)proxy {

	[self postPendingNotificationsExcept:_contentInsertionNotificationCoalescer];

	NSAssert(proxy==_currentNodeProxy, @"this may not be wrong.. i just haven't tested it yet, or discovered it is needed");
	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	
	// -- send the willChange notification once per runloop
	[_contentInsertionNotificationCoalescer fireSingleWillChangeNotification:proxy];
}

// do pretty much the same thing regardless of nodes, inputs, etc.
- (void)_didInsert:(id)newValue atIndexes:(NSIndexSet *)changeIndexes intoProxy:(NodeProxy *)proxy selector:(SEL)insertMethod {
	
	//-- send a willChange notification once per runloop
	NSAssert(proxy==_currentNodeProxy, @"this may not be wrong.. i just haven't tested it yet, or discovered it is needed");
	NSAssert( [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	NSAssert( [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]==NO, @"we can only do one kind of manipulation at once");
	
//	[_contentInsertionNotificationCoalescer performSelector:insertMethod withObject:newValue withObject:changeIndexes];
	objc_msgSend( _contentInsertionNotificationCoalescer, insertMethod, newValue, changeIndexes, nil );
	// -- send the didChange notification once per runloop
	[_contentInsertionNotificationCoalescer queueSinglePostponedNotification:proxy];
}

// Will Insert
- (void)modelWillInsert:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _willInsertSomethingIntoProxy:proxy];
}
- (void)modelWillInsert:(NodeProxy *)proxy inputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _willInsertSomethingIntoProxy:proxy];
}
- (void)modelWillInsert:(NodeProxy *)proxy outputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _willInsertSomethingIntoProxy:proxy];
}
- (void)modelWillInsert:(NodeProxy *)proxy shInterConnectorsInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _willInsertSomethingIntoProxy:proxy];
}

// Did Insert
- (void)modelInserted:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didInsert:newValue atIndexes:changeIndexes intoProxy:proxy selector:@selector(appendNodesInserted:atIndexes:)];
}
- (void)modelInserted:(NodeProxy *)proxy inputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didInsert:newValue atIndexes:changeIndexes intoProxy:proxy selector:@selector(appendInputsInserted:atIndexes:)];
}
- (void)modelInserted:(NodeProxy *)proxy outputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didInsert:newValue atIndexes:changeIndexes intoProxy:proxy selector:@selector(appendOutputsInserted:atIndexes:)];
}
- (void)modelInserted:(NodeProxy *)proxy shInterConnectorsInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didInsert:newValue atIndexes:changeIndexes intoProxy:proxy selector:@selector(appendIcsInserted:atIndexes:)];
}

// Removed
#pragma mark -- Children Removed --
- (void)_willRemoveSomethingFromProxy:(NodeProxy *)proxy {

	[self postPendingNotificationsExcept:_contentRemovedNotificationCoalescer];

	NSAssert(proxy==_currentNodeProxy, @"this may not be wrong.. i just haven't tested it yet, or discovered it is needed");
	[_contentRemovedNotificationCoalescer fireSingleWillChangeNotification:proxy];
}

- (void)_didRemove:(id)newValue atIndexes:(NSIndexSet *)changeIndexes fromProxy:(NodeProxy *)proxy selector:(SEL)insertMethod {

	NSAssert(proxy==_currentNodeProxy, @"this may not be wrong.. i just haven't tested it yet, or discovered it is needed");
	NSParameterAssert( newValue && [newValue count] );
	NSParameterAssert( [newValue count]==[changeIndexes count] );

	[_contentRemovedNotificationCoalescer performSelector:insertMethod withObject:newValue withObject:changeIndexes];

	// -- send the didChange notification once per runloop
	[_contentRemovedNotificationCoalescer queueSinglePostponedNotification:proxy];
}

- (void)modelWillRemove:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {

	[self _willRemoveSomethingFromProxy:proxy];
	//	-- does this effect ics?
	//	if you delete an input it could remove an ic 2 levels above
	NSSet *otherNodesAffectedByRemove = [proxy.originalNode otherNodesAffectedByRemove];
	if([otherNodesAffectedByRemove count]){
		for( id each in otherNodesAffectedByRemove ){
			AllChildProxy *np = (AllChildProxy *)[self nodeProxyForNode:each];
			NSAssert(np, @"node must have a proxy in the filter");
			[np interConnectorsWereRemoved];
		}
	}
}

- (void)modelWillRemove:(NodeProxy *)proxy inputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {

	[self _willRemoveSomethingFromProxy:proxy];
	NSSet *otherNodesAffectedByRemove = [proxy.originalNode otherNodesAffectedByRemove];
	if([otherNodesAffectedByRemove count]){
		for( id each in otherNodesAffectedByRemove ){
			AllChildProxy *np = (AllChildProxy *)[self nodeProxyForNode:each];
			NSAssert(np, @"node must have a proxy in the filter");
			[np interConnectorsWereRemoved];
		}
	}
}

- (void)modelWillRemove:(NodeProxy *)proxy outputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {

	[self _willRemoveSomethingFromProxy:proxy];
	NSSet *otherNodesAffectedByRemove = [proxy.originalNode otherNodesAffectedByRemove];
	if([otherNodesAffectedByRemove count]){
		for( id each in otherNodesAffectedByRemove ){
			AllChildProxy *np = (AllChildProxy *)[self nodeProxyForNode:each];
			NSAssert(np, @"node must have a proxy in the filter");
			[np interConnectorsWereRemoved];
		}
	}
}

- (void)modelWillRemove:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _willRemoveSomethingFromProxy:proxy];
}

- (void)modelRemoved:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didRemove:oldValue atIndexes:changeIndexes fromProxy:proxy selector:@selector(appendNodesRemoved:atIndexes:)];
}
- (void)modelRemoved:(NodeProxy *)proxy inputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didRemove:oldValue atIndexes:changeIndexes fromProxy:proxy selector:@selector(appendInputsRemoved:atIndexes:)];
}
- (void)modelRemoved:(NodeProxy *)proxy outputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didRemove:oldValue atIndexes:changeIndexes fromProxy:proxy selector:@selector(appendOutputsRemoved:atIndexes:)];
}
- (void)modelRemoved:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[self _didRemove:oldValue atIndexes:changeIndexes fromProxy:proxy selector:@selector(appendIcsRemoved:atIndexes:)];
}

#pragma mark -- Selection Changed --
// Changed
- (void)_willChangeSelectionInProxy:(NodeProxy *)proxy {
	
	[self postPendingNotificationsExcept:_selectionChangedNotificationCoalescer];

	NSAssert(proxy==_currentNodeProxy, @"this may not be wrong.. i just haven't tested it yet, or discovered it is needed");
	[_selectionChangedNotificationCoalescer fireSingleWillChangeNotification:proxy];
}

- (void)_didChangeSelectionTo:(id)newValue from:(id)oldValue inProxy:(NodeProxy *)proxy selector:(SEL)insertMethod {

	NSAssert(proxy==_currentNodeProxy, @"this may not be wrong.. i just haven't tested it yet, or discovered it is needed");
	NSAssert([newValue isEqualToIndexSet:oldValue]==NO, @"what?");
	[_selectionChangedNotificationCoalescer performSelector:insertMethod withObject:oldValue withObject:newValue];
	[_selectionChangedNotificationCoalescer queueSinglePostponedNotification:proxy];
}

- (void)modelWillChange:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue {
	[self _willChangeSelectionInProxy:proxy];
}
- (void)modelWillChange:(NodeProxy *)proxy inputsSelection_to:(id)newValue from:(id)oldValue {
	[self _willChangeSelectionInProxy:proxy];
}
- (void)modelWillChange:(NodeProxy *)proxy outputsSelection_to:(id)newValue from:(id)oldValue {
	[self _willChangeSelectionInProxy:proxy];
}
- (void)modelWillChange:(NodeProxy *)proxy shInterConnectorsInsideSelection_to:(id)newValue from:(id)oldValue {
	[self _willChangeSelectionInProxy:proxy];
}
- (void)modelChanged:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue {
	[self _didChangeSelectionTo:newValue from:oldValue inProxy:proxy selector:@selector(changedSelectedNodeIndexesFrom:to:)];
}
- (void)modelChanged:(NodeProxy *)proxy inputsSelection_to:(id)newValue from:(id)oldValue {
	[self _didChangeSelectionTo:newValue from:oldValue inProxy:proxy selector:@selector(changedSelectedInputIndexesFrom:to:)];
}
- (void)modelChanged:(NodeProxy *)proxy outputsSelection_to:(id)newValue from:(id)oldValue {
	[self _didChangeSelectionTo:newValue from:oldValue inProxy:proxy selector:@selector(changedSelectedOutputIndexesFrom:to:)];
}
- (void)modelChanged:(NodeProxy *)proxy shInterConnectorsInsideSelection_to:(id)newValue from:(id)oldValue {
	[self _didChangeSelectionTo:newValue from:oldValue inProxy:proxy selector:@selector(changedSelectedICIndexesFrom:to:)];
}

// Inserted
#pragma mark -- Selection Inserted -- NOT USED
- (void)modelWillInsert:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}
- (void)modelInserted:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}

- (void)modelWillInsert:(NodeProxy *)proxy inputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}
- (void)modelInserted:(NodeProxy *)proxy inputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}

- (void)modelWillInsert:(NodeProxy *)proxy outputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}
- (void)modelInserted:(NodeProxy *)proxy outputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}

- (void)modelWillInsert:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}
- (void)modelInserted:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}

// Replaced
#pragma mark -- Selection Replaced -- NOT USED
- (void)modelWillReplace:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}
- (void)modelReplaced:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}

- (void)modelWillReplace:(NodeProxy *)proxy inputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}
- (void)modelReplaced:(NodeProxy *)proxy inputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}

- (void)modelWillReplace:(NodeProxy *)proxy outputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}
- (void)modelReplaced:(NodeProxy *)proxy outputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}

- (void)modelWillReplace:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}
- (void)modelReplaced:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}

// Removed
#pragma mark -- Selection Removed -- NOT USED
- (void)modelWillRemove:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}
- (void)modelRemoved:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}

- (void)modelWillRemove:(NodeProxy *)proxy inputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}
- (void)modelRemoved:(NodeProxy *)proxy inputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}

- (void)modelWillRemove:(NodeProxy *)proxy outputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}
- (void)modelRemoved:(NodeProxy *)proxy outputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}

- (void)modelWillRemove:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}
- (void)modelRemoved:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}

#pragma mark -- Children Replaced -- NOT USED

- (void)modelWillReplace:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelReplaced:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelWillReplace:(NodeProxy *)proxy inputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelReplaced:(NodeProxy *)proxy inputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelWillReplace:(NodeProxy *)proxy outputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelReplaced:(NodeProxy *)proxy outputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelWillReplace:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}
- (void)modelReplaced:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}

#pragma mark -- Children Changed -- NOT USED
// Changed
- (void)modelWillChange:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}
- (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}

- (void)modelWillChange:(NodeProxy *)proxy inputs_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}
- (void)modelChanged:(NodeProxy *)proxy inputs_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}

- (void)modelWillChange:(NodeProxy *)proxy outputs_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}
- (void)modelChanged:(NodeProxy *)proxy outputs_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}

- (void)modelWillChange:(NodeProxy *)proxy shInterConnectorsInside_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}
- (void)modelChanged:(NodeProxy *)proxy shInterConnectorsInside_to:(id)newValue from:(id)oldValue {
	[NSException raise:@"filtered content changed - Are we allowing this?" format:@""];
}


#pragma mark -
#pragma mark Sanity Check
- (BOOL)hasPendingNotifications {
	
	if([_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent] || [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent] || [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent] )
		return YES;
	return NO;
}

- (void)postPendingNotificationsExcept:(DelayedNotificationCoalescer *)value {

	if(value!=_contentInsertionNotificationCoalescer && [_contentInsertionNotificationCoalescer isWaitingForNotificationToBeSent]){
		[_contentInsertionNotificationCoalescer postNotification];
	}
	if(value!=_contentRemovedNotificationCoalescer && [_contentRemovedNotificationCoalescer isWaitingForNotificationToBeSent]){
		[_contentRemovedNotificationCoalescer postNotification];
	}
	if(value!=_selectionChangedNotificationCoalescer && [_selectionChangedNotificationCoalescer isWaitingForNotificationToBeSent]){
		[_selectionChangedNotificationCoalescer postNotification];
	}
}

- (void)currentNodeGroupWillChange {
	[self postPendingNotificationsExcept:nil];
}

- (void)willBeginMultipleEdit {
	[self postPendingNotificationsExcept:nil];
}
- (void)didEndMultipleEdit {
	[self postPendingNotificationsExcept:nil];
}
@end
