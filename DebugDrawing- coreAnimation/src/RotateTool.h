//
//  RotateTool.h
//  DebugDrawing
//
//  Created by steve hooley on 18/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "Widget_protocol.h"

@class Graphic, NodeProxy, StarScene;

@interface RotateTool : Tool <Widget_protocol> {

	NodeProxy	*_itemToRotate;
	
	BOOL _xformDidChange;
	BOOL _sizeNeedsUpdating;
}

@property (retain) NodeProxy *itemToRotate;


//- (void)rotateSelectedGraphicWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;

//- (void)_drawZAxisHandleAtPoint:(NSPoint)pt rotation:(CGFloat)rotationRads;
//- (void)_drawZAxisCircleAtPoint:(NSPoint)pt rotation:(CGFloat)rotationRads;

@end





