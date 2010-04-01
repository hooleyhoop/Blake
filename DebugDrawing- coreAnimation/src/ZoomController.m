//
//  ZoomController.m
//  DebugDrawing
//
//  Created by shooley on 06/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "ZoomController.h"
//#import "MathUtilities.h"

@interface ZoomController ()

@property (readwrite) CGAffineTransform zoomMatrix;

@end

@implementation ZoomController

@synthesize zoomMatrix=_zoomMatrix;
@synthesize centrePt=_centrePt;

#pragma mark -
#pragma mark Class methods
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {

    if( [theKey isEqualToString:@"zoomValue"] ) 
        return NO;
    if( [theKey isEqualToString:@"zoomMatrix"] ) 
        return YES;
	else
		[NSException raise:@"what else is there?" format:@""];
	return [super automaticallyNotifiesObserversForKey:theKey];
}

#pragma mark Init methods
- (id)init {

	self = [super init];
	if(self){
		[self resetZoomSettings];
	}
	return self;
}

- (void)updateMatrix {
	
	_inverseMatDirty = YES;

	CGFloat originX=_centrePt.x/_zoom, originY=_centrePt.y/_zoom;
	CGAffineTransform posMatrix1 = CGAffineTransformMakeTranslation( _pos.x, _pos.y );
	// CGAffineTransform rotMatrix1 = CATransform3DMakeRotation( 0, 0, 0, 0 );
	CGAffineTransform originMatrix1 = CGAffineTransformMakeTranslation( originX, originY );
	CGAffineTransform scaleMatrix = CGAffineTransformMakeScale( _zoom, _zoom );
	// CGAffineTransform originMatrix2 = CATransform3DMakeTranslation( -originX, -originY, 1.0f );

	CGAffineTransform result = CGAffineTransformIdentity;
	result = CGAffineTransformConcat( result, posMatrix1 );
	// result = CGAffineTransformConcat( result, rotMatrix1 );
	result = CGAffineTransformConcat( result, originMatrix1 );
	result = CGAffineTransformConcat( result, scaleMatrix );
	// result = CGAffineTransformConcat( result, originMatrix2 );

	[self setZoomMatrix:result];
}

- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal {

	_pos.x = _pos.x + xVal/_zoom;
	_pos.y = _pos.y + yVal/_zoom;
	[self updateMatrix];
}

- (void)zoomByX:(CGFloat)xVal y:(CGFloat)yVal {
	
	NSParameterAssert(xVal>0);
	if(xVal>0) {
		[self setZoomValue:_zoom * xVal];
	}
}

- (void)setZoomValue:(CGFloat)value {

	NSParameterAssert(value>0);

	if( G3DCompareFloat(value,_zoom,0.01f)!=0 ){
		[self willChangeValueForKey:@"zoomValue"];
		_zoom = value;
		[self didChangeValueForKey:@"zoomValue"];
		[self updateMatrix];
	}
}

- (void)setCentrePt:(CGPoint)pt {

	_centrePt = pt;
	[self updateMatrix];
}

- (void)resetZoomSettings {

	_pos = CGPointZero;
	[self setZoomValue:1.0f];
}

- (CGPoint)inversePt:(NSPoint)pt {
	
	if(_inverseMatDirty) {
		_inverseMat = CGAffineTransformInvert(_zoomMatrix);
		_inverseMatDirty = NO;
	}
	CGPoint altPt = CGPointApplyAffineTransform( NSPointToCGPoint(pt), _inverseMat );
	return altPt;
}

- (CGFloat)zoomValue {
	return _zoom;
}

@end
