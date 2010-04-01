//
//  GraphLayersController.m
//  DebugDrawing
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "GraphLayersController.h"
#import "AbstractLayer.h"
#import "ContentLayerManager.h"
#import "LayerTreeManipulation.h"

@implementation GraphLayersController

- (id)initWithContentManager:(ContentLayerManager *)value manipulator:(LayerTreeManipulation *)manip {

	self = [super init];
	if(self){
		_layerManipulator = [manip retain];
		_contentLayerManager = [value retain];
	}
	return self;
}

- (void)dealloc {

	[_layerManipulator release];
	[_contentLayerManager release];
	[super dealloc];
}

// This is not a reorder - we need to create a new layer and add it to the layer tree
- (void)_createNewStarLayerForProxy:(NodeProxy *)aGraphic onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind {

	NSParameterAssert(aGraphic);
	NSParameterAssert(layer);
	NSAssert(_contentLayerManager, @"why dont we have a layer manager?");

	[_layerManipulator recursive_newChildLayerForProxy:aGraphic onParentLayer:layer atIndex:ind withLayerManager:_contentLayerManager];
}

- (void)removeStar:(NodeProxy *)aGraphic fromLayer:(AbstractLayer *)layer {

    SHNode *originalNode = aGraphic.originalNode;
	AbstractLayer *existingLayer = [_contentLayerManager lookupLayerForKey:originalNode];

	NSAssert( existingLayer!=nil, @"Cant remove if doesn't exist! Dufas!");
    // recursively remove children
	if([originalNode allowsSubpatches]) {
		for( NodeProxy *each in aGraphic.filteredContent ){
			[self removeStar:each fromLayer:existingLayer];
		}
	}

    // remove the layer from the tree
	[_contentLayerManager removeSubLayerFromParent:existingLayer];
}

- (void)moveStarLayer:(AbstractLayer *)existingLayer toIndex:(NSUInteger)ind {

	[_contentLayerManager moveLayer:existingLayer toIndex:ind];
}

@end
