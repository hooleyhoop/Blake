//
//  MathUtilities.h
//  DebugDrawing
//
//  Created by steve hooley on 08/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface MathUtilities : _ROOT_OBJECT_ {

}

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define DEGREES_TO_RADIANSF(__ANGLE__) ((CGFloat)(__ANGLE__) / 180.0f * M_PI)

#pragma mark Test Equality

/* Dont forget about good stuff like CGRectIsEmpty, CGRectIsNull, CGRectIsInfinite */
 
//NSEqualRects
BOOL nearlyEqualNSRects( NSRect rect1, NSRect rect2 );

//CGRectEqualToRect
BOOL nearlyEqualCGRects( CGRect rect1, CGRect rect2 );

//NSEqualPoints
BOOL nearlyEqualNSPoints( NSPoint pt1, NSPoint pt2 );

//CGPointEqualToPoint
BOOL nearlyEqualCGPoints( CGPoint pt1, CGPoint pt2 );

NSInteger G3DCompareFloat( CGFloat a, CGFloat b, CGFloat tol );

CGRect smallestRectEnclosingPoints( CGPoint point1, CGPoint point2 );

// Think of clock, what is the angle between the hands?
CGFloat angleDegressBetweenTwoPtsAboutCentre( CGPoint pt1, CGPoint pt2, CGPoint centrePt );

@end
