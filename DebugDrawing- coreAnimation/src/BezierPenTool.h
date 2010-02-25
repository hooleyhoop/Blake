//
//  BezierPen.h
//  DebugDrawing
//
//  Created by steve hooley on 14/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "Widget_protocol.h"

@class Bezier, Graphic;

@interface BezierPenTool : Tool <Widget_protocol> {

	Bezier *_creatingGraphic;
	Bezier *_editingGraphic;
    
    NSBezierPath *_ghostLine;

}

- (void)trackMouseWithEvent:(NSEvent *)event inSketchView:(CALayerStarView *)view;
- (void)createGraphicOfClass:(Class)graphicClass withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;
- (void)startEditingGraphic:(Graphic *)graphic inSketchView:(CALayerStarView *)view;

@end
