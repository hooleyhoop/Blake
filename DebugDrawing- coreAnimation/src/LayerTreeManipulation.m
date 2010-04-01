//
//  LayerTreeManipulation.m
//  DebugDrawing
//
//  Created by steve hooley on 14/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "LayerTreeManipulation.h"
#import "AbstractLayer.h"
#import "ContentLayerManager.h"
#import "LayerCreation.h"
#import "CALayerStarView.h"

@implementation LayerTreeManipulation

- (id)initWithLayerCreator:(LayerCreation *)aLc starView:(CALayerStarView *)view {

	self = [super init];
	if(self)
		_layerCreator = [aLc retain];
		_starView = [view retain];
	return self;
}

- (void)dealloc {
	
	[_layerCreator release];
	[_starView release];
	[super dealloc];
}

#pragma mark THESE ARE THE FUCKING SAME!
/* a child layer */
- (void)recursive_newChildLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager {
	
	NSParameterAssert(proxy);
	NSParameterAssert(layer);
	NSParameterAssert(layerManager);
	
	AbstractLayer *newLayer = [_layerCreator makeChildLayerForNode:proxy.originalNode];
	NSAssert(newLayer, @"failed to create new layer");
	
	SHNode *originalNode = proxy.originalNode;
	AbstractLayer *existingLayer = [layerManager lookupLayerForKey:originalNode];
	NSAssert( existingLayer==nil, @"dont think we can reorder existing layers" );
	
	// recursively add children because we fucked up on the observations
	if([proxy.originalNode allowsSubpatches]) {
		NSArray *filteredCnt = [proxy filteredContent];
		for( NodeProxy *each in filteredCnt )
		{
			int indexToInsert = [filteredCnt indexOfObjectIdenticalTo:each];
			NSAssert(indexToInsert!=NSNotFound, @"eh?");
			[self recursive_newChildLayerForProxy:each onParentLayer:newLayer atIndex:indexToInsert withLayerManager:layerManager];
		}
	}
	
	// add this new layer to it's parent layer
	[layerManager insertSublayer:newLayer atIndex:ind inParentLayer:layer];
}

/* a selected layer */
- (AbstractLayer *)recursive_newRootSelectedLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager {

	NSParameterAssert(proxy);
	NSParameterAssert(layer);
	NSParameterAssert(layerManager);
	
	SHNode *originalNode = proxy.originalNode;
	AbstractLayer *existingLayer = [layerManager lookupLayerForKey:originalNode];
	NSAssert( existingLayer==nil, @"dont think we can reorder existing layers" );
	
	AbstractLayer *newLayer=[_layerCreator makeRootSelectedLayerForNode:originalNode inView:_starView];
	NSAssert(newLayer, @"failed to create new layer");
	
	// All children are selected if we are selected
    // recursively add children because we fucked up on the observations
	if([originalNode allowsSubpatches]) 
	{
		NSArray *filteredCnt = [proxy filteredContent];
		NSUInteger i=0;
		for( NodeProxy *each in filteredCnt )
		{
			int indexToInsert = [filteredCnt indexOfObjectIdenticalTo:each];
			NSAssert(indexToInsert!=NSNotFound, @"eh?");
			//TODO: this is shit - no?
			// [self recursive_newChildSelectedLayerForProxy:each onParentLayer:(id)newLayer atIndex:indexToInsert withLayerManager:layerManager];
			[self recursive_newRootSelectedLayerForProxy:each onParentLayer:newLayer atIndex:i++ withLayerManager:layerManager];
		}
    }
	
    // add this new layer to it's parent layer
	[layerManager insertSublayer:newLayer atIndex:ind inParentLayer:layer];
	return newLayer;
}

//- (void)recursive_newChildSelectedLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager {
//	
//	NSParameterAssert(proxy);
//	NSParameterAssert(layer);
//	NSParameterAssert(layerManager);
//	
//	SHNode *originalNode = proxy.originalNode;
//	AbstractLayer *existingLayer = [layerManager lookupLayerForKey:originalNode];
//	NSAssert( existingLayer==nil, @"dont think we can reorder existing layers" );
//	
//	AbstractLayer *newLayer=[_layerCreator makeSelectedLayerForNode:originalNode];
//	NSAssert(newLayer, @"failed to create new layer");
//
//	// All children are selected if we are selected
//    // recursively add children because we fucked up on the observations
//	if([originalNode allowsSubpatches]) 
//	{
//		NSArray *filteredCnt = [proxy filteredContent];
//		for( NodeProxy *each in filteredCnt )
//		{
//			int indexToInsert = [filteredCnt indexOfObjectIdenticalTo:each];
//			NSAssert(indexToInsert!=NSNotFound, @"eh?");
//			[self recursive_newChildSelectedLayerForProxy:each onParentLayer:(id)newLayer atIndex:indexToInsert withLayerManager:layerManager];
//		}
//    }
//	
//    // add this new layer to it's parent layer
//	[layerManager insertSublayer:newLayer atIndex:ind inParentLayer:layer];	
//}

// proxy2 must be a child of proxy1
//- (void)makeSelectedLayersUptoAndIncluding:(SHNode *)node1 withLayerManager:(ContentLayerManager *)layerManager {
//
//	NSParameterAssert(node1);
//	NSParameterAssert(layerManager);
//
//	AbstractLayer *newLayer = [_layerCreator makeSelectedLayerForNode:node1];
//	NSAssert(newLayer, @"failed to create layer");
//	SHNode *parentNode = (id)[node1 parentSHNode];
//	if(!parentNode) {
//		[layerManager insertSublayer:newLayer atIndex:0 inParentLayer:[layerManager containerLayer_temporary]];
//	} else {
//		SelectedLayer *superLayer = (SelectedLayer *)[layerManager lookupLayerForKey:parentNode];
//		// recursively make all the layers above this layer if needed
//		if(!superLayer){
//			[self makeSelectedLayersUptoAndIncluding:parentNode withLayerManager:layerManager];
//			superLayer = (SelectedLayer *)[layerManager lookupLayerForKey:parentNode];
//			NSAssert(superLayer, @"recursive layer creation failed");
//		}
//		[layerManager insertSublayer:newLayer atIndex:0 inParentLayer:superLayer];
//	}
//	
//	// this will fail if currentNode is rootNode
////	NSArray *rev3 = [proxy1.originalNode reverseNodeChainToNode:proxy2.originalNode];
////	for(NSUInteger i=[rev3 count]; i>0; i--)
////	{
////		SHNode *parentNode = [rev3 objectAtIndex:i-1];
////		SelectedLayer *thisLayer = (SelectedLayer *)[layerManager lookupLayerForKey:parentNode];
////		if(!thisLayer) {
////			thisLayer = [_layerCreator makeSelectedLayerForNode:parentNode];
////			
////			NSAssert( [parentLayer.sublayers count]==0, @"i can't think of an occassion when this shouldn't be so");
////			
////			if(!parentLayer) // MUST be the Root Node!
////				parentLayer = (SelectedLayer *)layerManager.containerLayer_temporary;
////			[layerManager insertSublayer:thisLayer atIndex:0 inParentLayer:parentLayer];
////		}
////		parentLayer = thisLayer;
////	}
//}

- (void)removeEmptyLayerAndEmptyLayersAbove:(AbstractLayer *)emptyLayer withLayerManager:(ContentLayerManager *)layerManager {
	
	NSParameterAssert(emptyLayer);
	NSAssert([[emptyLayer sublayers] count]==0, @"This is not an empty layer");
	
	AbstractLayer *parentLayer = (AbstractLayer *)[emptyLayer superlayer];
	[layerManager removeSubLayerFromParent:emptyLayer];
	if([[parentLayer sublayers] count]==0 && parentLayer!=[layerManager containerLayer_temporary]) {
		[self removeEmptyLayerAndEmptyLayersAbove:parentLayer withLayerManager:layerManager];
	}
}

@end
