//
//  LayerFamiliar.m
//  DebugDrawing
//
//  Created by steve hooley on 18/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "LayerFamiliar.h"
#import "XForm.h"
#import "BoundingGeometry.h"

@implementation LayerFamiliar

#pragma mark -
#pragma mark Class methods
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	
    if( [theKey isEqualToString:@"geometryRect"] || [theKey isEqualToString:@"transformMatrix"] ) //  || [theKey isEqualToString:@"widgetOrigin"] 
        return NO;
	else
		[NSException raise:@"what else is there?" format:@""];
	return [super automaticallyNotifiesObserversForKey:theKey];
}

#pragma mark Instance methods
- (id)init {
	
	self = [super init];
	if(self){
		_xForm = [[XForm alloc] init];
		_geom = [[BoundingGeometry alloc] init];
	}
	return self;
}

- (void)dealloc {
	
	[_xForm release];
	[_geom release];
	[super dealloc];
}

#pragma mark Actions
/* like an end of run loop thing - we may want to get a patch uptodate but not have it do it's evaluateOncePerFrame 
 eg. when we are dragging a tool, so in a way evaluateOncePerFrame is broken into two parts - enabling us to only call
 the finalize bit if we need to do so
 */
- (void)enforceConsistentState {
	
	// if the xForm is Dirty or the geom has changed we need to recalc the offset Matrix	
	if(_xForm.needsRecalculating){
		// there is no reason why _xForm couldnt send this notification for us - ie pass in self
		[self willChangeValueForKey:@"transformMatrix"];
		[_xForm enforceConsistentState];
		[self didChangeValueForKey:@"transformMatrix"];
	}
	
	if(_geom.geomDidChange){
		[self willChangeValueForKey:@"geometryRect"];
		[self didChangeValueForKey:@"geometryRect"];
		_geom.geomDidChange = NO;
	}
	
	// What is recalc drawing bounds? For now just concentrating on sending notifications to layer
	//june09	if(_drawingBoundsDidChange==YES)
	//june09		[self recalculateDrawingBounds];
}

#pragma mark Utilities
//- (CGPoint)localPtToParentSpace:(CGPoint)value {
//    return [_xForm localPtToParentSpace:value];
//}
//
//- (CGPoint)parentSpacePtToLocalSpace:(CGPoint)value {
//    return [_xForm parentSpacePtToLocalSpace:value];
//}

// should we cache this?
//june09- (void)transformedGeometryRectPoints:(CGPoint *)ptArray {
	
	// anti clockwise pts of the geometry rect from bottom left
//june09	CGPoint p1 = _geometryOrigin;
//june09	CGPoint p2 = CGPointMake( p1.x+_geometryRect.size.width, p1.y );
//june09	CGPoint p3 = CGPointMake( p2.x, p2.y+_geometryRect.size.height );
//june09	CGPoint p4 = CGPointMake( p1.x, p3.y );
	
//june09	-- this is no good! we need to apply other matrixes before hand
//june09	ptArray[0] = [self localPtToParentSpace:p1];
//june09	ptArray[1] = [self localPtToParentSpace:p2];
//june09	ptArray[2] = [self localPtToParentSpace:p3];
//june09	ptArray[3] = [self localPtToParentSpace:p4];
//june09}

// should we cache this?
//june09- (CGRect)transformedGeometryRectBoundingBox {
	
//june09	CGPoint ptArray[4];
//june09	[self transformedGeometryRectPoints:ptArray];
	
	// find minx, maxx, miny, maxy
//june09	CGFloat minx = ptArray[0].x < ptArray[1].x ? ptArray[0].x : ptArray[1].x;
//june09	minx =minx < ptArray[2].x ? minx : ptArray[2].x;
//june09	minx =minx < ptArray[3].x ? minx : ptArray[3].x;
//june09	CGFloat miny = ptArray[0].y < ptArray[1].y ? ptArray[0].y : ptArray[1].y;
//june09	miny = miny < ptArray[2].y ? miny : ptArray[2].y;
//june09	miny = miny < ptArray[3].y ? miny : ptArray[3].y;
//june09	CGFloat maxx = ptArray[0].x > ptArray[1].x ? ptArray[0].x : ptArray[1].x;
//june09	maxx = maxx > ptArray[2].x ? maxx : ptArray[2].x;
//june09	maxx = maxx > ptArray[3].x ? maxx : ptArray[3].x;
//june09	CGFloat maxy = ptArray[0].y > ptArray[1].y ? ptArray[0].y : ptArray[1].y;
//june09	maxy = maxy > ptArray[2].y ? maxy : ptArray[2].y;
//june09	maxy = maxy > ptArray[3].y ? maxy : ptArray[3].y;
//june09	CGRect transformedBounds = CGRectMake( minx, miny, maxx-minx, maxy-miny );
//june09	return transformedBounds;
//june09}

#pragma mark Accessors

- (void)applyMatrixToContext:(CGContextRef)cntx {

	NSAssert( _debug_didApplyContext==NO, @"did pop matrix?" );
	
	CGContextSaveGState(cntx);
	CGContextConcatCTM( cntx, [self transformMatrix] );
	
	_debug_didApplyContext = YES;
}

- (void)restoreContext:(CGContextRef)cntx {

	NSAssert( _debug_didApplyContext==YES, @"did apply matrix?" );

	//-- pop transform
	CGContextRestoreGState(cntx);
	
	_debug_didApplyContext = NO;
}

- (CGRect)didDrawAt:(CGContextRef)cntx {
	
	NSAssert( _debug_didApplyContext==YES, @"did apply matrix?" );

	CGAffineTransform cntxCTM = CGContextGetCTM(cntx);
	return CGRectApplyAffineTransform( self.geometryRect, cntxCTM );
}

- (CGRect)geometryRect {
	return _geom.geometryRect;
}

- (void)setGeometryRect:(CGRect)val {
	[_geom setGeometryRect:val];
}

- (CGAffineTransform)transformMatrix {

	NSAssert(_xForm.needsRecalculating==NO, @"Matrix Not Ready! - Inconsistent state");
    return [_xForm unCompensatedTransformMatrix];
}

- (CGFloat)scale {
	return _xForm.scale;
}

- (void)setScale:(CGFloat)val {
    _xForm.scale = val;
}

- (CGPoint)position {
    return _xForm.position;
}

- (void)setPosition:(CGPoint)val {
	_xForm.position =val;
}

- (CGPoint)anchorPt {
    return _xForm.anchorPt;
}

/* anchor point is relative to lower left point of bounds */
- (void)setAnchorPt:(CGPoint)val {
	_xForm.anchorPt = val;
}

// rotation is degrees
- (CGFloat)rotation {
	return _xForm.rotation;
}

- (void)setRotation:(CGFloat)val {
	_xForm.rotation = val;
}

- (XForm *)xForm {
	return _xForm;
}

@end
