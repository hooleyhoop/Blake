//
//  NodeClassFilter.m
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NodeClassFilter.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import <SHShared/SHShared.h>
#import "NodeProxy.h"


static NSString *ObservationCntx = @"NodeClassFilter";

@implementation NodeClassFilter

@synthesize filterType = _filterType;

#pragma mark -
#pragma mark property accessors

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
							  @"childContainer.nodesInside.selection", 
							  nil] retain];
	return modelKeyPathsToObserve;
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillChangeKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillChange:nodesInside_to:from:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillChange:nodesInsideSelection_to:from:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

+ (SEL)selectorForChangedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelChanged:nodesInside_to:from:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelChanged:nodesInsideSelection_to:from:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillInsertKeyPath:(NSString *)keyPath {
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillInsert:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillInsert:nodesInsideSelection:atIndexes:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

+ (SEL)selectorForInsertedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelInserted:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelInserted:nodesInsideSelection:atIndexes:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillReplaceKeyPath:(NSString *)keyPath {

	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillReplace:nodesInside:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillReplace:nodesInsideSelection:with:atIndexes:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelReplaced:nodesInside:with:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelReplaced:nodesInsideSelection:with:atIndexes:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillRemoveKeyPath:(NSString *)keyPath {
	
	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelWillRemove:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelWillRemove:nodesInsideSelection:atIndexes:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

+ (SEL)selectorForRemovedKeyPath:(NSString *)keyPath {

	if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
		return @selector(modelRemoved:nodesInside:atIndexes:);
	if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
		return @selector(modelRemoved:nodesInsideSelection:atIndexes:);
	[NSException raise:@"Unrecognized keypath" format:@"did we observe %@", keyPath];
	return nil;	// COV_NF_LINE
}

#pragma mark init methods
- (id)init {
	
	self = [super init];
	if( self )
	{
		_addedObjectCount = 0;
		_removedObjectCount = 0;
	}
	return self;
}

- (void)dealloc {
	
	if(_model!=nil)
		logError(@"who did this?"); // COV_NF_LINE
	NSAssert(_model==nil, @"you must explicitly clean up before releasing");
	[super dealloc];
}

#pragma mark action methods
- (void)setOptions:(NSDictionary *)opts {
	NSParameterAssert([opts isKindOfClass:[NSDictionary class]]);
	id param1 = [opts objectForKey:@"Class"];
	NSAssert(param1!=nil, @"dodgy options sent to NodeClassFilter");
	[self setClassFilter: param1];
}

//!Alert-putback!- (void)registerAUser:(id)user {
//!Alert-putback!	[super registerAUser:user];
	
	/* It is upto the user to grab the rootProxy and sync / get up to date */
	
//	[_rootNodeProxy addObserver:user forKeyPath:@"filteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial ) context:ObservationCntx];
//	[_rootNodeProxy addObserver:user forKeyPath:@"filteredContent" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial ) context:ObservationCntx];
//!Alert-putback!}

//!Alert-putback!- (void)unRegisterAUser:(id)user {
//	[_rootNodeProxy removeObserver:user forKeyPath:@"filteredContentSelectionIndexes"];
//	[_rootNodeProxy removeObserver:user forKeyPath:@"filteredContent"];
	
//!Alert-putback!    [super unRegisterAUser:user];
//!Alert-putback!}

/*
	Super implementation just goes thru all nodes and calls objectPassesFilter
	so you must overide if you want inputs, outputs, etc
*/
- (void)makeFilteredTreeUpToDate:(NodeProxy *)value {
	[super makeFilteredTreeUpToDate:value];
}

- (BOOL)objectPassesFilter:(id)value {
	
	BOOL passesNewTest = NO;
	if([value isKindOfClass:_filterType] || [value allowsSubpatches])
		passesNewTest = YES;
	return passesNewTest;
}

/* Cull the provided objects and indexes */
- (void)objectsAndIndexesThatPassFilter:(NSArray *)objects :(NSIndexSet *)indexes :(NSMutableArray *)successFullObjects :(NSMutableIndexSet *)successFullIndexes {
	
	NSParameterAssert( [indexes count]==[objects count] );
	
	int addedObjectsIndex = [indexes firstIndex];
	for( id addedObject in objects )
	{
		if([self objectPassesFilter: addedObject]){
			[successFullObjects addObject:addedObject];
			[successFullIndexes addIndex:addedObjectsIndex];
		}
		addedObjectsIndex = [indexes indexGreaterThanIndex:addedObjectsIndex];
	}
}

#pragma mark -
#pragma mark Custom Methods for responding to Model events
#pragma mark -- Nodes --

- (void)modelWillChange:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue {

	/* Do our DIY notification thing - i haven't found a need to pass the correct values yet */
	// NB! newValue is empty, i do not know why or have any control. Therefor have no way of knowing if it will pass the filter
	// so dont want to call - willChangeContent
//	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
//		[each temp_proxy:proxy willChangeContent:nil atIndexes:nil];
//	}
}

- (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue {
	
	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	NSAssert(newValueNullOrNil==NO, @"cant replace if we dont have any new objects");

	/* All new objects, no change indexes */
	NSArray *newNodesInside = (NSArray *)newValue;
	NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSet];
	NSMutableArray *matchedObjects = [NSMutableArray array];
	
	NSUInteger gindex=0;
	for( id addedObject in newNodesInside )
	{
		if([self objectPassesFilter:addedObject])
		{
			[newIndexes addIndex: gindex];
			NodeProxy *makeNodeProxy = [NodeProxy makeNodeProxyWithFilter:self object:addedObject];
			[matchedObjects addObject: makeNodeProxy]; /* make a proxy here, observe the content if it is a group */

			//V2 - handles adding children and starting observations for childrens
			//- defer this in favour of lazily adding them when needed
			// [self makeFilteredTreeUpToDate:makeNodeProxy]; 

			//-- when do we start observing them? -- Because we are using the 'initial' KVO option this will recursively add all nodes,
			//-- ie the equivalent of doing :-
			//-- [self modelChanged:makeNodeProxy nodesInside_to:[addedObject nodesInside] from: ];
//doWeNeedToObserveEachProxy if([makeNodeProxy.originalNode allowsSubpatches])
//doWeNeedToObserveEachProxy [makeNodeProxy startObservingOriginalNode];
		}
		gindex++;
	}
	/* clean up stuff that we are replacing */
//	NSArray *filteredContentRemoving = proxy.filteredContent;
//doWeNeedToObserveEachProxy 	for( NodeProxy *np in filteredContentRemoving ){
//doWeNeedToObserveEachProxy 		[np stopObservingOriginalNode];
//doWeNeedToObserveEachProxy 	}
	
	/* Do our DIY notification thing */
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		[each temp_proxy:proxy willChangeContent:matchedObjects atIndexes:newIndexes];
	}
	
	/* add the Proxies of the children that we observed were added - tree is up-to-date! */
	proxy.indexesOfFilteredContent = newIndexes;
	proxy.filteredContent = matchedObjects;
	
	/* Do our DIY notification thing */
	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
		[each temp_proxy:proxy didChangeContent:matchedObjects atIndexes:newIndexes];
	}
}

/* 
 NB! Broken here! we will get this with objects that we already contain if we try to reorder some children 
 */
- (void)modelWillInsert:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	
	/* Do our DIY notification thing - i haven't found a need to pass the correct values yet */
	// NB! newValue is empty, i do not know why or have any control. Therefor have no way of knowing if it will pass the filter
	// so dont want to call - willInsertContent
//	for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
//		[each temp_proxy:proxy willInsertContent:nil atIndexes:nil];
//	}
}

- (void)modelInserted:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {

	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	NSAssert( newValueNullOrNil==NO, @"cant insert if we dont have any new objects" );

	// for each new graphic that passes the filter test - insert the indexes into _rootNodeProxy.indexesOfFilteredContent
	/* These are, i guess the insertion points - not the location..(?) verify this */
	NSIndexSet *insertedObjectsIndexes = changeIndexes;
	NSAssert(insertedObjectsIndexes!=nil && [insertedObjectsIndexes count]>0, @"cant");

	//-- for each new index that was inserted, regardless of whether it passes the test slide existing and later indexes to the right
	NSMutableIndexSet *inds = proxy.indexesOfFilteredContent;
	NSUInteger newInd = [insertedObjectsIndexes firstIndex];
	while(newInd!=NSNotFound)
	{
		[inds shiftIndexesStartingAtIndex:newInd by:1];
		NSAssert2( [ proxy.indexesOfFilteredContent isEqualToIndexSet:inds], @"what happened? %@, %@", inds, proxy.indexesOfFilteredContent);
		newInd = [insertedObjectsIndexes indexGreaterThanIndex:newInd];
	}

	/* Cull these inserted Objects down to just those that pass the filter test */
	NSMutableArray *successFullObjects = [NSMutableArray array];

	NSMutableIndexSet *successFullIndexes = [NSMutableIndexSet indexSet];
	[self objectsAndIndexesThatPassFilter:newValue :insertedObjectsIndexes :successFullObjects :successFullIndexes];

	NSMutableArray *proxiesForSuccessFullObjects = [NSMutableArray array];
	for( SHNode *node in successFullObjects )
	{
		// IMPORTANT! Do we ALREADY CONTAIN this node? ie. are we reordering?
		int existingIndex = [proxy indexOfOriginalObjectIdenticalTo:node];
		if( existingIndex!=NSNotFound )
		{
			// YES! we already have this - it must be a reorder
			NodeProxy *existingProxy = [[[proxy objectInFilteredContentAtIndex:existingIndex] retain] autorelease];
			NSAssert(existingProxy!=nil, @"hmm, i thought we already had it?");
			[proxiesForSuccessFullObjects addObject:existingProxy];
			
			/* 
				Carefully remove the node from it's existing position without triggering a KVO notification. we will re-add it as if it is a new node 
				Luckily we dont have to do and cleaning up at the moment - just the remove and re-add. If we soup-up proxy we may need to do more. sheeeet.
			 */
			 [proxy.filteredContent removeObjectAtIndex:existingIndex];
			
		} else {
			// NO, we dont have this - must be adding a new node
			NodeProxy *newProxy = [NodeProxy makeNodeProxyWithFilter:self object:node];
			[proxiesForSuccessFullObjects addObject:newProxy];
		}
	}

	/* Send a single notification that IndexesOfFilteredContent has had insertions */
	if([proxiesForSuccessFullObjects count]>0)
	{
		[proxy addIndexesToIndexesOfFilteredContent: successFullIndexes];

		// what indexs are successFullIndexes in indexesOfFilteredContent?
		NSMutableIndexSet *positions = [NSMutableIndexSet indexSet];
		unsigned int current = [successFullIndexes firstIndex];
		NSMutableIndexSet *currentIndexes = [[proxy.indexesOfFilteredContent mutableCopy] autorelease];

		while (current != NSNotFound) {
			int posOfCurrentInIndexesOfFilteredContent = [currentIndexes positionOfIndex: current];
			[positions addIndex: posOfCurrentInIndexesOfFilteredContent];
			current = [successFullIndexes indexGreaterThanIndex: current];
		}
		
		/* Do our DIY notification thing */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:proxy willInsertContent:proxiesForSuccessFullObjects atIndexes:positions];
		}
		
		[proxy insertFilteredContent:proxiesForSuccessFullObjects atIndexes:positions];
		_addedObjectCount = _addedObjectCount + [proxiesForSuccessFullObjects count];
		
		/* Do our DIY notification thing */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:proxy didInsertContent:proxiesForSuccessFullObjects atIndexes:positions];
		}
	}
}

- (void)modelWillReplace:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}

- (void)modelReplaced:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content changed - NSKeyValueChangeReplacement" format:@""];
}

- (void)modelWillRemove:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {

	/* Do our DIY notification thing - i haven't found a need to pass the correct values yet */
	// NB! newValue is empty, i do not know why or have any control. Therefor have no way of knowing if it will pass the filter
	// so dont want to call - willRemoveContent
}

- (void)modelRemoved:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {

	NSParameterAssert([oldValue count]==[changeIndexes count]);
	BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
	NSAssert(oldValueNullOrNil==NO, @"cant remove if we dont have any old objects");
	NSIndexSet *removedObjectsIndexes = changeIndexes;
	NSAssert(removedObjectsIndexes!=nil && [removedObjectsIndexes count]>0, @"cant");

	/* Cull these inserted Objects down to just those that pass the filter test */
	NSMutableArray *successFullObjects = [NSMutableArray array];
	NSMutableIndexSet *successFullIndexes = [NSMutableIndexSet indexSet];
	[self objectsAndIndexesThatPassFilter:oldValue :removedObjectsIndexes :successFullObjects :successFullIndexes];

	/* Send a single notification that IndexesOfFilteredContent has had insertions */
	NSArray *proxiesToRemove = nil;
	NSMutableIndexSet *positions = [NSMutableIndexSet indexSet];

	if([successFullObjects count]>0)
	{
		// remove graphics at the indexes of these indeses
		unsigned int current = [successFullIndexes firstIndex];
		while (current != NSNotFound) {
			int posOfCurrentInIndexesOfFilteredContent = [proxy.indexesOfFilteredContent positionOfIndex: current];
			[positions addIndex: posOfCurrentInIndexesOfFilteredContent];
			current = [successFullIndexes indexGreaterThanIndex: current];
		}
		proxiesToRemove = [proxy.filteredContent objectsAtIndexes:positions];
//doWeNeedToObserveEachProxy 		for( NodeProxy *np in proxiesToRemove ){
//doWeNeedToObserveEachProxy 			[np stopObservingOriginalNode];
//doWeNeedToObserveEachProxy 		}
		
		/* Do our DIY notification thing */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:proxy willRemoveContent:proxiesToRemove atIndexes:positions];
		}		
		
		[proxy removeIndexesFromIndexesOfFilteredContent: successFullIndexes];
		[proxy removeFilteredContentAtIndexes: positions];

		_removedObjectCount = _removedObjectCount+[positions count];
	}

	//-- for each new index that was removed, regardless of whether it passes the test slide existing and later indexes to the left
	NSUInteger newInd = [removedObjectsIndexes lastIndex];
	while(newInd!=NSNotFound){
		[proxy.indexesOfFilteredContent shiftIndexesStartingAtIndex:newInd+1 by:-1];
		newInd = [removedObjectsIndexes indexLessThanIndex:newInd];
	}
	
	if(proxiesToRemove)
		/* Do our DIY notification thing */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:proxy didRemoveContent:proxiesToRemove atIndexes:positions];
		}
}

#pragma mark -- Selection --
// we call [each temp_proxy:proxy willChangeSelection:(id)dataToPassToNotification]; below when we have the new and old values
- (void)modelWillChange:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue {
}

- (void)modelChanged:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue {

	// Some selection indexes might have been removed, some might have been added. Redraw the selection handles for any graphic whose selectedness has changed, unless the binding is changing completely (signalled by null old or new value), in which case just redraw the whole view.
	NSIndexSet *oldSelectionIndexes = oldValue;
	NSIndexSet *newSelectionIndexes = newValue;

	BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;

	NSIndexSet *currentSelection = [[proxy.filteredContentSelectionIndexes copy] autorelease];
	NSMutableIndexSet *deselectedObjectsThatPassFilter = [NSMutableIndexSet indexSet];
	/* Initially, oldvalues will be nil */
	if( oldValueNullOrNil==NO && newValueNullOrNil==NO && [oldSelectionIndexes count]>0 ) 
	{
		//-- Remove the selections
		
		unsigned oldSelectionIndex = [oldSelectionIndexes firstIndex];
		while( oldSelectionIndex!=NSNotFound ) {
			// only remove objects that aren't in new selection as well!
			if( ![newSelectionIndexes containsIndex:oldSelectionIndex] )
			{
				// this is wrong - right?
				// NSAssert([[proxy.originalNode nodesInside] count]>oldSelectionIndex, @"bad index observeValueForKeyPath selection1");
				// surely oldSelectionIndex pertains to the model, not the filter
				SHNode *originalNode = proxy.originalNode;
				NSAssert(originalNode, @"heh!");
				SHChild *deselectedObject = [originalNode nodeAtIndex:oldSelectionIndex];
				NSAssert(deselectedObject, @"heh!");

				NSUInteger indexOfDeselectedOb = [proxy indexOfOriginalObjectIdenticalTo: deselectedObject];
				if(indexOfDeselectedOb!=NSNotFound){
					NSAssert([currentSelection containsIndex:indexOfDeselectedOb], @"How can we deselect an object that we have necer selected?");
					[deselectedObjectsThatPassFilter addIndex:indexOfDeselectedOb];
				}
			}
			oldSelectionIndex=[oldSelectionIndexes indexGreaterThanIndex:oldSelectionIndex];
		}
	}

//	this cant be right! only deselct old if there is new?
//	if( newValueNullOrNil==NO ) {

		//-- Add the new selections
		NSMutableIndexSet *selectedItemsThatPassFilter=[NSMutableIndexSet indexSet];
		NSMutableIndexSet *newSelectedItemsThatPassFilter=[NSMutableIndexSet indexSet];

		if([newSelectionIndexes count]>0)
		{
			unsigned newSelectionIndex = [newSelectionIndexes firstIndex];
			while( newSelectionIndex!=NSNotFound )
			{
				id selectedObject = [[proxy.originalNode nodesInside] objectAtIndex:newSelectionIndex];
				NSAssert(selectedObject!=nil, @"must have this");
				NSUInteger indexOfSelectedOb = [proxy indexOfOriginalObjectIdenticalTo:selectedObject];
				if(indexOfSelectedOb!=NSNotFound)
				{
					NSAssert([[proxy.originalNode nodesInside] count]>newSelectionIndex, @"bad index observeValueForKeyPath selection2");
					
					/* This item may well already be selected - we still need it for our DIY notification */
					[selectedItemsThatPassFilter addIndex: indexOfSelectedOb];
					
					/* But that doesn't mean we must select it again as we didnt deselect items from old selection if they are also in new selection */
					if( [currentSelection containsIndex:indexOfSelectedOb]==NO )
						[newSelectedItemsThatPassFilter addIndex: indexOfSelectedOb];
				}
				newSelectionIndex=[newSelectionIndexes indexGreaterThanIndex:newSelectionIndex];
			}
		}
		
		// this is a terible hack, instead of passing in the changeIndexes, pass in an array that contains the change indexes as well as other stuff
		NSArray *dataToPassToNotification = [NSArray arrayWithObjects:selectedItemsThatPassFilter, newSelectedItemsThatPassFilter, deselectedObjectsThatPassFilter, nil];
	
		/* Do our DIY notification thing */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:proxy willChangeSelection:(id)dataToPassToNotification]; // 
		}
	
		// remove the unselected
		if([deselectedObjectsThatPassFilter count]>0)
			[proxy removeIndexesFromSelection:deselectedObjectsThatPassFilter];
		
		// add the new selections
		if([newSelectedItemsThatPassFilter count]>0){
			[proxy addIndexesToSelection: newSelectedItemsThatPassFilter];
		} 
//		else {
//			proxy.filteredContentSelectionIndexes = selectedObjectsThatPassFilter;
//		}

		/* Do our DIY notification thing - with the terrible hack of passing in an array */
		for( id<SHContentProviderUserProtocol> each in _registeredUsers ){
			[each temp_proxy:proxy didChangeSelection:(id)dataToPassToNotification];
		}
//	}
}

- (void)modelWillInsert:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}

- (void)modelInserted:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeInsertion"];
}

- (void)modelWillReplace:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}

- (void)modelReplaced:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeReplacement" format:@"filtered content selection changed - NSKeyValueChangeReplacement"];
}

- (void)modelWillRemove:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}

- (void)modelRemoved:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes {
	[NSException raise:@"filtered content selection changed - NSKeyValueChangeRemoval" format:@"filtered content selection changed - NSKeyValueChangeRemoval"];
}

#pragma mark -

//- (NSIndexSet *)allModelSelectionIndexes {
//	
//    // A graphic view doesn't hold onto the selection indexes. That would be a cache that hasn't been justified by performance measurement (not yet anyway).
//	// Get the selection indexes from the bound-to object (an array controller, in Sketch's case). It's poor practice for a method that returns a collection 
//	// (and an index set is a collection) to return nil, so never return nil.
//    NSIndexSet *selectionIndexes = [_model valueForKeyPath:@"selectionIndexes"];
//    return selectionIndexes;
//}


// This doesn't contribute to any KVC or KVO compliance. It's just a convenience method that's invoked down below.
//- (NSArray *)selectedGraphics {
//	
//  //  return [[_model graphics] objectsAtIndexes:_filteredContentSelectionIndexes];
//	return nil;
//}


- (void)setClassFilter:(NSString *)value {
	
	NSParameterAssert(value!=nil);
	_filterType = NSClassFromString(value);
	NSAssert([NSStringFromClass(_filterType) isEqualToString:value], @"failed to set filter type");
}

//- (void)_syncSelectionIndexes {
//	
//	NSMutableIndexSet *newSelection = [NSMutableIndexSet indexSet];
//    id graphicItem;
//    for (graphicItem in _rootNodeProxy.filteredContent)
//	{
//		if([_model isSelected:graphicItem])
//			[newSelection addIndex:[_rootNodeProxy.filteredContent indexOfObjectIdenticalTo: graphicItem]];
//    }
//	self.filteredContentSelectionIndexes = newSelection;
//}

#pragma mark Indexed accessors methods


//- (void)removeObjectFromFilteredContentAtIndex:(unsigned)theIndex {
//	
//	NSParameterAssert([_rootNodeProxy.filteredContent count]>theIndex);
//    [_rootNodeProxy.filteredContent removeObjectAtIndex:theIndex];
//}

//- (void)replaceObjectInFilteredContentAtIndex:(unsigned)theIndex withObject:(id)obj {
//	
//    [_rootNodeProxy.filteredContent replaceObjectAtIndex:theIndex withObject:obj];
//}

//- (BOOL)isSelected:(id)value {
//	
//	NSParameterAssert([_rootNodeProxy.filteredContent containsObject:value]==true);
//	
//	int ind = [_rootNodeProxy.filteredContent indexOfObjectIdenticalTo: value];
//	if(ind!=NSNotFound && [_filteredContentSelectionIndexes containsIndex:ind])
//		return YES;
//	return NO;
//}

/* New Stuff */
//- (void)addIndexToIndexesOfFilteredContent:(NSUInteger)value {
//
//	/*
//	 * Problem: 
//	 * If we add an index that we already contain it means we are inserting
//	 * a value and that the existing index and everything after it must be incremented.
//	 */
//#ifdef NSDebugEnabled
//	NSArray *debugAllContent = [[_model graphics] array];
//	NSAssert( [self objectPassesFilter:[debugAllContent objectAtIndex:value]], @"cant add that index to filtered content");
//#endif
//	
//	//-- for each new index that we are adding, slide existing and later indexes to the right
//	if(value!=NSNotFound){
//		[_rootNodeProxy.indexesOfFilteredContent shiftIndexesStartingAtIndex:value by:1];
//	}
//
//	[_rootNodeProxy.indexesOfFilteredContent addIndex:value];
//}

//- (void)removeIndexFromIndexesOfFilteredContent:(NSUInteger)value {
//	
//	NSParameterAssert([_rootNodeProxy.indexesOfFilteredContent containsIndex:value]);
//	[_rootNodeProxy.indexesOfFilteredContent removeIndex:value];
//}
/* END New Stuff */


//- (NSArray *)selectedContent {
//	
//	return [self objectsInFilteredContentAtIndexes: _filteredContentSelectionIndexes];
//}

@end
