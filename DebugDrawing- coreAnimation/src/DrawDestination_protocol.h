/*
 *  DrawDestination_protocol.h
 *  DebugDrawing
 *
 *  Created by steve hooley on 24/09/2008.
 *  Copyright 2008 BestBefore Ltd. All rights reserved.
 *
 */

@protocol DrawDestination_protocol <NSObject>

- (void)graphic:(id)obj drewAt:(NSRect)dst;

@end