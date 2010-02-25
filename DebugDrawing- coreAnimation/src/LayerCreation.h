//
//  LayerCreation.h
//  DebugDrawing
//
//  Created by Steven Hooley on 7/2/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

@class AbstractLayer, SHNode, NodeProxy, ContentLayerManager, CALayerStarView;
@protocol Widget_protocol;

@interface LayerCreation : _ROOT_OBJECT_ {

}

- (AbstractLayer *)makeChildLayerForNode:(SHNode *)node;

- (AbstractLayer *)makeRootSelectedLayerForNode:(SHNode *)node inView:(CALayerStarView *)starView;
//- (AbstractLayer *)makeSelectedLayerForNode:(SHNode *)node;

- (AbstractLayer *)makeWidgetLayerForTool:(NSObject<Widget_protocol> *)tool;

@end
