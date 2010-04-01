/*
 *  MouseInputAdaptorProtocol.h
 *  DebugDrawing
 *
 *  Created by steve hooley on 21/10/2008.
 *  Copyright 2008 BestBefore Ltd. All rights reserved.
 *
 */
@class CALayerStarView;

@protocol MouseInputAdaptorProtocol <NSObject>

- (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;
- (void)mouseUpAtPoint:(NSPoint)pt;

@end