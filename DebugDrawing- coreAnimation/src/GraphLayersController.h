//
//  GraphLayersController.h
//  DebugDrawing
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class ContentLayerManager, LayerTreeManipulation, NodeProxy, AbstractLayer;

@interface GraphLayersController : _ROOT_OBJECT_ {

	ContentLayerManager		*_contentLayerManager;
	LayerTreeManipulation	*_layerManipulator;
}

- (id)initWithContentManager:(ContentLayerManager *)value manipulator:(LayerTreeManipulation *)manip;

- (void)_createNewStarLayerForProxy:(NodeProxy *)aGraphic onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind;
- (void)removeStar:(NodeProxy *)aGraphic fromLayer:(AbstractLayer *)layer;
- (void)moveStarLayer:(AbstractLayer *)existingLayer toIndex:(NSUInteger)ind;

@end
