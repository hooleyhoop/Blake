//
//  LayerFamiliar.h
//  DebugDrawing
//
//  Created by steve hooley on 18/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class XForm, BoundingGeometry;

@interface LayerFamiliar : _ROOT_OBJECT_ {

	XForm *_xForm;	// This will be an input later on, and the geometry bit will be separated out
	BoundingGeometry *_geom;
	
	BOOL _debug_didApplyContext;
}

- (void)enforceConsistentState;

//- (CGPoint)localPtToParentSpace:(CGPoint)value;
//- (CGPoint)parentSpacePtToLocalSpace:(CGPoint)value;

//june09- (void)transformedGeometryRectPoints:(CGPoint *)ptArray;
//june09- (CGRect)transformedGeometryRectBoundingBox;

- (void)applyMatrixToContext:(CGContextRef)cntx;
- (void)restoreContext:(CGContextRef)cntx;

- (CGRect)didDrawAt:(CGContextRef)cntx;

- (CGRect)geometryRect;
- (void)setGeometryRect:(CGRect)val;
- (CGAffineTransform)transformMatrix;
- (CGFloat)scale;
- (void)setScale:(CGFloat)val;
- (CGPoint)position;
- (void)setPosition:(CGPoint)val;
- (CGPoint)anchorPt;
- (void)setAnchorPt:(CGPoint)val;
- (CGFloat)rotation;
- (void)setRotation:(CGFloat)val;
- (XForm *)xForm;

@end
