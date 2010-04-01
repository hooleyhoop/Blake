//
//  CALayerStarView.h
//  DebugDrawing
//
//  Created by steve hooley on 05/12/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class EditingViewController;

@interface CALayerStarView : NSView {
	
    IBOutlet EditingViewController *_viewController;

//    AbstractLayer *blackTransparentLayer;    
	

}

@property (readwrite, assign) EditingViewController *viewController;

#pragma mark CALayerStuff
// - (AbstractLayer *)contentLayer;

- (void)setupCALayerStuff;
// - (void)syncStars;

// - (void)addStar:(NodeProxy *)aGraphic toLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind;
// - (void)removeStar:(NodeProxy *)aGraphic fromLayer:(AbstractLayer *)layer;

// - (void)removeAllLayers;

//- (AbstractLayer *)blackTransparentLayer;

- (void)setViewController:(EditingViewController *)newController;

@end
