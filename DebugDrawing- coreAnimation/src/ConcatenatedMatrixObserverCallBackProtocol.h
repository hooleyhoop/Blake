/*
 *  ConcatenatedMatrixObserverCallBackProtocol.h
 *  DebugDrawing
 *
 *  Created by steve hooley on 29/09/2009.
 *  Copyright 2009 BestBefore Ltd. All rights reserved.
 *
 */

@class XForm, ConcatenatedMatrixObserver;

@protocol ConcatenatedMatrixObserverCallBackProtocol

- (XForm *)xForm;
- (NSArray *)childrenToTellConcatenatedMatrixIsDirty;
- (ConcatenatedMatrixObserver *)concatenatedMatrixObserver;

@end
