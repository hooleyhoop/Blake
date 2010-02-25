//
//  SceneDisplay.h
//  DebugDrawing
//
//  Created by steve hooley on 23/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "StarSceneUserProtocol.h"

@class CALayerStarView, StarScene, AbstractLayer, SelectedLayer;
@class NodeProxy, ContentLayerManager, LayerTreeManipulation;
@class SelectedLayersController, GraphLayersController;

@interface SceneDisplay : _ROOT_OBJECT_ <StarSceneUserProtocol> {

	StarScene *_starScene;
	CALayerStarView *_targetView;
	
	/* low fat version */
	LayerTreeManipulation		*_layerManipulator;
	ContentLayerManager			*_contentLayerManager, *_selectedContentManager;
	
	GraphLayersController		*_graphLayersController;
	SelectedLayersController	* _selectedLayersController;
}

@property (assign) CALayerStarView *targetView;
@property (assign) StarScene *starScene;
@property (readonly) ContentLayerManager *contentLayerManager;

- (id)initWithContentLayerManager:(ContentLayerManager *)value1 selectedContentLayerManager:(ContentLayerManager *)value2 layerTreeManipulator:(LayerTreeManipulation *)value4;

- (void)graphDidUpdate;

- (void)removeAllLayers;

/* DIY Notifications from Scene */
- (void)nodeProxy:(NodeProxy *)value changedContent:(NSArray *)values;
- (void)nodeProxy:(NodeProxy *)value insertedContent:(NSArray *)values;
- (void)nodeProxy:(NodeProxy *)value removedContent:(NSArray *)values;
- (void)nodeProxy:(NodeProxy *)value changedSelectionTo:(NSIndexSet *)values byDeselecting:(NSIndexSet *)oldValues andSelecting:(NSIndexSet *)newValues;
- (void)currentNodeProxyChangedFrom:(NodeProxy *)oldValue to:(NodeProxy *)newValue;

@end
