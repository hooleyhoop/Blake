//
//  SKTUserAdaptor.h
//  BlakeLoader2
//
//  Created by steve hooley on 08/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class SKTGraphicView;


@protocol SKTUserAdaptor <NSObject>

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view;
- (void)drawToolInSketchView:(SKTGraphicView *)view;
- (NSRect)toolDisplaybounds;

// - (enum SKTGraphicDrawingMode)preferredDrawingStyleForGraphic:(SKTGraphic *)graphic;

//- (void)startEditingGraphic:(SKTGraphic *)graphic inSketchView:(SKTGraphicView *)view;
//- (SKTGraphic *)editingGraphic;
//- (void)stopEditingInSketchView:(SKTGraphicView *)view;


@end
