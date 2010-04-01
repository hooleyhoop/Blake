//
//  StarLayer.m
//  DebugDrawing
//
//  Created by steve hooley on 08/12/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "StarLayer.h"
#import "Graphic.h"

@implementation StarLayer



- (void)addSublayer:(CALayer *)layer {
	[NSException raise:@"Star Layers dont have children!" format:@""];
} // COV_NF_LINE

@end
