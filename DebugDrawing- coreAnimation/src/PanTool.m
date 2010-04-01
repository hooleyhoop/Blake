//
//  PanTool.m
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "PanTool.h"

/* 
 *
 */
@implementation PanTool

- (id)initWithTarget:(id)value {
	
	self = [super init];
	if(self){
		_itemToPan = value;
	}
	return self;
}

- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal {
	
	NSAssert(_itemToPan, @"Nothing to pan!");
	[_itemToPan panByX:xVal y:yVal];
}

#pragma mark Accessor methods
- (NSString *)identifier { return @"SKTPanTool"; }

@end