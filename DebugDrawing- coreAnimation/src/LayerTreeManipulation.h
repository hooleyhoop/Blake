//
//  LayerTreeManipulation.h
//  DebugDrawing
//
//  Created by steve hooley on 14/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class NodeProxy, AbstractLayer, SelectedLayer, ContentLayerManager, LayerCreation, SHNode, CALayerStarView;

@interface LayerTreeManipulation : _ROOT_OBJECT_ {

	LayerCreation		*_layerCreator;
	CALayerStarView		*_starView;
}

- (id)initWithLayerCreator:(LayerCreation *)aLc starView:(CALayerStarView *)view;

// create a layer for this child and all it's children
- (AbstractLayer *)recursive_newRootSelectedLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager;

- (void)recursive_newChildLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager;
//- (void)recursive_newChildSelectedLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager;

//- (void)makeSelectedLayersUptoAndIncluding:(SHNode *)proxy1 withLayerManager:(ContentLayerManager *)layerManager;
- (void)removeEmptyLayerAndEmptyLayersAbove:(AbstractLayer *)emptyLayer withLayerManager:(ContentLayerManager *)layerManager;

@end
