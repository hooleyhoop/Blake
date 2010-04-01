/*
 *  iAmTransformableProtocol.h
 *  DebugDrawing
 *
 *  Created by steve hooley on 29/07/2009.
 *  Copyright 2009 BestBefore Ltd. All rights reserved.
 *
 */
@protocol iAmTransformableProtocol <NSObject>

- (void)enforceConsistentState;

- (CGRect)geometryRect;
- (void)setGeometryRect:(CGRect)rect;

- (CGAffineTransform)transformMatrix;

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end


@protocol iAmDrawableProtocol <NSObject>

// apple a matrix, etc.
- (void)_setupDrawing:(CGContextRef)cntx;
- (void)_tearDownDrawing:(CGContextRef)cntx;
- (CGRect)didDrawAt:(CGContextRef)cntx;

@end


@protocol iAmGraphicNodeProtocol <iAmTransformableProtocol, iAmDrawableProtocol>

- (CGAffineTransform)concatenatedMatrix;

@end