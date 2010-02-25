//
//  NodeContainerLayer.m
//  DebugDrawing
//
//  Created by shooley on 07/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "NodeContainerLayer.h"


@implementation NodeContainerLayer


//- (void)drawInContext:(CGContextRef)ctx {
//	
//	CGContextSaveGState(ctx);
//	
//	CGRect bounds = CGContextGetClipBoundingBox(ctx); // This should be the clip rect
//	
//	/* Offset the grdid by current pan amount */
//	//TODO: This is fucked!
//	CATransform3D sceneOffset = self.sublayerTransform;
//	CGContextConcatCTM( ctx, CATransform3DGetAffineTransform(sceneOffset) );
//
//	CGContextBeginPath( ctx );
//	
//	CGContextMoveToPoint( ctx, 0, 200 );
//	CGContextAddLineToPoint( ctx, 0, -200);
//	
//	CGContextMoveToPoint( ctx, -200, 0 );
//	CGContextAddLineToPoint( ctx, 200, 0);
//	
//	CGContextSetLineWidth( ctx, 0.33 );
//	
//	CGContextSetRGBStrokeColor( ctx, 0.0f, 0.0f, 0.0f, 0.9f );
//	CGContextDrawPath( ctx, kCGPathStroke );
//	
//	CGContextRestoreGState( ctx );
//}

@end
