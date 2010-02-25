//
//  WidgetDisplay.h
//  DebugDrawing
//
//  Created by steve hooley on 23/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "Widget_protocol.h"

@class CALayerStarView, ContentLayerManager, LayerCreation;

@interface WidgetDisplay : _ROOT_OBJECT_ {

	CALayerStarView *_targetView;
	ContentLayerManager *_contentLayerManager;
	LayerCreation *_layerMaker;

	NSMutableArray *_widgets;
}

@property (assign) CALayerStarView *targetView;

- (id)initWithContentLayerManager:(ContentLayerManager *)value1 layerCreator:(LayerCreation *)iMakeLayers;

- (void)addWidget:(NSObject<Widget_protocol> *)value;
- (void)removeWidget:(NSObject<Widget_protocol> *)value; 
- (void)graphDidUpdate;

@end
