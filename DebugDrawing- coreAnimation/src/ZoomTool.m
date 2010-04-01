//
//  ZoomTool.m
//  DebugDrawing
//
//  Created by steve hooley on 24/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ZoomTool.h"


@implementation ZoomTool

- (id)initWithTarget:(id)value {
	
	self = [super init];
	if(self){
		_itemToZoom = value;
	}
	return self;
}

- (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2 {

	NSAssert(_itemToZoom, @"No Object To Zoom");
	[_itemToZoom zoomFrom:pt1 to:pt2];
}

#pragma mark Accessor methods
- (NSString *)identifier { return @"SKTZoomTool"; }


@end