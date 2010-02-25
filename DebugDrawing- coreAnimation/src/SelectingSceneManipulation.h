//
//  SelectingSceneManipulation.h
//  DebugDrawing
//
//  Created by steve hooley on 06/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class StarScene, NodeProxy;

@interface SelectingSceneManipulation : _ROOT_OBJECT_ {

	StarScene *_scene;
}

- (id)initWithScene:(StarScene *)value;

- (void)toggleSelectionOfItem:(NodeProxy *)proxyItem shouldModifyCurrent:(BOOL)modifyCurrentSelection;
- (void)clearSelection;
- (void)modifyInitialSelection:(NSIndexSet *)initialSelection withMarqueedIndexes:(NSIndexSet *)indexesOfGraphicsInRubberBand;

@end
