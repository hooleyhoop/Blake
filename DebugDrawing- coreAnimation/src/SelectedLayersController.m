//
//  SelectedLayersController.m
//  DebugDrawing
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SelectedLayersController.h"
#import "AbstractLayer.h"
#import "ContentLayerManager.h"
#import "LayerTreeManipulation.h"

@interface SelectedLayersController (PrivateMethods)
- (void)_createNewSelectedStarLayerForProxy:(NodeProxy *)aGraphic onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind;
- (void)removeSelectedStar:(NodeProxy *)aGraphic;
@end

@implementation SelectedLayersController


- (id)initWithContentManager:(ContentLayerManager *)value manipulator:(LayerTreeManipulation *)manip {

	self = [super init];
	if(self){
		_layerManipulator = [manip retain];
		_selectedContentManager = [value retain];
	}
	return self;
}

- (void)dealloc {

	[_layerManipulator release];
	[_selectedContentManager release];
	[super dealloc];
}

- (void)addNewSelectedLayersToRoot:(NSArray *)newlySelectedProxies theirIndexesInFilteredContent:(NSIndexSet *)newIndexes allIndexesOfSelectedNodes:(NSIndexSet *)allIndexes {

	NSParameterAssert(newlySelectedProxies);
	NSParameterAssert(newIndexes);
	NSParameterAssert(allIndexes);

	AbstractLayer *existingLayer = [_selectedContentManager containerLayer_temporary];
	NSAssert(existingLayer, @"where is root selection layer?");
	
	unsigned int currentIndex = [newIndexes firstIndex];

	for( id each in newlySelectedProxies )
	{
		//-- work out index of each to add
		NSUInteger indexToAdd = [allIndexes  positionOfIndex:currentIndex];
		[self _createNewSelectedStarLayerForProxy:each onParentLayer:existingLayer atIndex:indexToAdd];
		
		currentIndex = [newIndexes indexGreaterThanIndex: currentIndex];
	}
}

// This is not a reorder - we need to create a new layer and add it to the layer tree
- (void)_createNewSelectedStarLayerForProxy:(NodeProxy *)aGraphic onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind {
	
	NSParameterAssert(aGraphic);
	NSParameterAssert(layer);
	NSAssert(_selectedContentManager, @"why dont we have a layer manager?");
	
	AbstractLayer *selectedLayer = [_layerManipulator recursive_newRootSelectedLayerForProxy:aGraphic onParentLayer:layer atIndex:ind withLayerManager:_selectedContentManager];
}

//- (SelectedLayer *)_layerForCurrentNodeInSelectionTree {
//	
//	SelectedLayer *parentLayer = (SelectedLayer *)[_selectedContentManager lookupLayerForKey:_starScene.currentProxy.originalNode];
//	if(!parentLayer)
//	{
//		[_layerManipulator makeSelectedLayersUptoAndIncluding:_starScene.currentProxy.originalNode withLayerManager:_selectedContentManager];
//		parentLayer = (SelectedLayer *)[_selectedContentManager lookupLayerForKey:_starScene.currentProxy.originalNode];
//	}
//	NSAssert(parentLayer, @"this should never happen");
//	return parentLayer;
//}

- (void)removeProxiesFromSelection:(NSArray *)proxies {

	NSParameterAssert(proxies);

	for( id each in proxies )
		[self removeSelectedStar:each];

//	AbstractLayer *existingLayer = [_selectedContentManager containerLayer_temporary];
//	NSArray *remainingSublayers = [parentLayer sublayers];
	// remove empty parent layers
//	if([remainingSublayers count]==0) {
//		[_layerManipulator removeEmptyLayerAndEmptyLayersAbove:existingLayer withLayerManager:_selectedContentManager];
//	}
}

- (void)removeSelectedStar:(NodeProxy *)aGraphic {

	NSParameterAssert(aGraphic);

	SHNode *originalNode = aGraphic.originalNode;
	AbstractLayer *existingLayer = [_selectedContentManager lookupLayerForKey:originalNode];

	NSAssert( existingLayer!=nil, @"Cant remove if doesn't exist! Dufas!");
    // recursively remove children
	if([originalNode allowsSubpatches]) {
		for( NodeProxy *each in aGraphic.filteredContent ){
			[self removeSelectedStar:each];
		}
	}

    // remove the layer from the tree
	[_selectedContentManager removeSubLayerFromParent:existingLayer];
}

/* At the moment SelectedLayers need updating after all graphics changes have taken place so that the layers matrix is only calculated once after all graphics changes */
- (void)enforceConsistentState {
	
	[[self rootSelectedLayers] makeObjectsPerformSelector:@selector(enforceConsistentState)];
}

- (NSUInteger)selectedCount {

	return [[self rootSelectedLayers] count];
}

- (NSArray *)rootSelectedLayers {
	return [[_selectedContentManager containerLayer_temporary] sublayers];
}

@end
