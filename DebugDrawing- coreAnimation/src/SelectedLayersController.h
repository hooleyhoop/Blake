//
//  SelectedLayersController.h
//  DebugDrawing
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class ContentLayerManager, LayerTreeManipulation;

@interface SelectedLayersController : _ROOT_OBJECT_ {

	ContentLayerManager		*_selectedContentManager;
	LayerTreeManipulation	*_layerManipulator;
}

- (id)initWithContentManager:(ContentLayerManager *)value manipulator:(LayerTreeManipulation *)manip;

- (void)addNewSelectedLayersToRoot:(NSArray *)newlySelectedProxies theirIndexesInFilteredContent:(NSIndexSet *)newIndexes allIndexesOfSelectedNodes:(NSIndexSet *)allIndexes;

- (void)removeProxiesFromSelection:(NSArray *)proxies;

- (void)enforceConsistentState;

- (NSUInteger)selectedCount;

- (NSArray *)rootSelectedLayers;

@end
