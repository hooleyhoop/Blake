//
//  ZoomController.h
//  DebugDrawing
//
//  Created by shooley on 06/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

@interface ZoomController : _ROOT_OBJECT_ {

	CGAffineTransform _zoomMatrix, _inverseMat;
	CGFloat _zoom;
	CGPoint _pos;
	CGPoint _centrePt;
	BOOL _inverseMatDirty;
}

@property (readonly) CGAffineTransform zoomMatrix;
@property (readwrite) CGPoint centrePt;

- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal;
- (void)zoomByX:(CGFloat)xVal y:(CGFloat)yVal;
- (void)setCentrePt:(CGPoint)pt;

- (void)updateMatrix;

- (CGPoint)inversePt:(NSPoint)pt;

- (void)resetZoomSettings;

- (void)setZoomValue:(CGFloat)value;
- (CGFloat)zoomValue;

@end
