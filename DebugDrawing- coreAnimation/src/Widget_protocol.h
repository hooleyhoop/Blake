/*
 *  Widget_protocol.h
 *  DebugDrawing
 *
 *  Created by steve hooley on 16/10/2008.
 *  Copyright 2008 BestBefore Ltd. All rights reserved.
 *
 */
@class CALayerStarView;
@protocol iAmTransformableProtocol, iAmDrawableProtocol;

@protocol Widget_protocol <NSObject, iAmTransformableProtocol, iAmDrawableProtocol>

- (void)enforceConsistentState;

@end