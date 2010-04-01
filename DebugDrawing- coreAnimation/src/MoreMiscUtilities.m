//
//  MoreMiscUtilities.m
//  DebugDrawing
//
//  Created by steve hooley on 10/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "MoreMiscUtilities.h"

@implementation MoreMiscUtilities

+ (NSString *)NSStringFromCGAffineTransform:(CGAffineTransform)t {
	return( [NSString stringWithFormat:@"%g, %g, %g, %g, %g, %g", t.a, t.b, t.c, t.d, t.tx, t.ty] );
}

@end
