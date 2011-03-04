//
//  MathUtilities.m
//  DebugDrawing
//
//  Created by steve hooley on 08/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "MathUtilities.h"

@implementation MathUtilities

#pragma mark Test Equality
BOOL nearlyEqualNSRects( NSRect rect1, NSRect rect2 ) {
    
    if(rect2.origin.x<rect1.origin.x+0.05 && rect2.origin.x>rect1.origin.x-0.05)
        if(rect2.origin.y<rect1.origin.y+0.05 && rect2.origin.y>rect1.origin.y-0.05)
            if(rect2.size.width<rect1.size.width+0.05 && rect2.size.width>rect1.size.width-0.05)
                if(rect2.size.height<rect1.size.height+0.05 && rect2.size.height>rect1.size.height-0.05)
                    return YES;
    return NO;
}

BOOL nearlyEqualCGRects( CGRect rect1, CGRect rect2 ) {
	
    if(rect2.origin.x<rect1.origin.x+0.05 && rect2.origin.x>rect1.origin.x-0.05)
        if(rect2.origin.y<rect1.origin.y+0.05 && rect2.origin.y>rect1.origin.y-0.05)
            if(rect2.size.width<rect1.size.width+0.05 && rect2.size.width>rect1.size.width-0.05)
                if(rect2.size.height<rect1.size.height+0.05 && rect2.size.height>rect1.size.height-0.05)
                    return YES;
    return NO;
}

BOOL nearlyEqualNSPoints( NSPoint pt1, NSPoint pt2 ){
    
    if(pt2.x<pt1.x+0.05 && pt2.x>pt1.x-0.05)
        if(pt2.y<pt1.y+0.05 && pt2.y>pt1.y-0.05)
			return YES;
    return NO;
}

BOOL nearlyEqualCGPoints( CGPoint pt1, CGPoint pt2 ){
    
    if(pt2.x<pt1.x+0.05 && pt2.x>pt1.x-0.05)
        if(pt2.y<pt1.y+0.05 && pt2.y>pt1.y-0.05)
			return YES;
    return NO;
}

// http://aggregate.ee.engr.uky.edu/MAGIC/
#define FasI(f)  (*((int *) &(f)))
#define FasUI(f) (*((unsigned int *) &(f)))

#define	lt0(f)	(FasUI(f) > 0x80000000U)
#define	le0(f)	(FasI(f) <= 0)
#define	gt0(f)	(FasI(f) > 0)
#define	ge0(f)	(FasUI(f) <= 0x80000000U)
NSInteger G3DCompareFloat( CGFloat a, CGFloat b, CGFloat tol ) {
	if ((a+tol) < b) return -1;
	if ((b+tol) < a) return 1;
	return 0;
}

#pragma mark Point Math utilities
CGRect smallestRectEnclosingPoints( CGPoint point1, CGPoint point2 ){
	CGRect smallestRect = CGRectMake( fminf( point1.x, point2.x), fminf(point1.y, point2.y), fabsf(point2.x - point1.x), fabsf(point2.y - point1.y));
	return smallestRect;
}

/* Think of clock hands */
CGFloat angleDegressBetweenTwoPtsAboutCentre( CGPoint pt1, CGPoint pt2, CGPoint centrePt ) {
	
	CGFloat t1x = pt1.x - centrePt.x;
	CGFloat t1y = pt1.y - centrePt.y;
	CGFloat t2x = pt2.x - centrePt.x;
	CGFloat t2y = pt2.y - centrePt.y;
	CGFloat angle = (atan2f(t1y, t1x) - atan2f(t2y, t2x)) * (CGFloat)(180.0f * M_1_PI);	
	return angle;
}

@end
