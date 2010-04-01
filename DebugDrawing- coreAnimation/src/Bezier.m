//
//  Bezier.m
//  DebugDrawing
//
//  Created by steve hooley on 14/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Bezier.h"


@implementation Bezier

@synthesize path = _path;

- (id)init
{
	self = [super init];
	if ( self ) {
		//! Need to add this to every object or move it up to Graphic, but presumably we will need some graphics with subpatches
		_allowsSubpatches = NO;
	}
	return self;
}

- (void)dealloc
{
	self.path = nil;
	[super dealloc];
}

- (void)moveTo:(NSPoint)pt
{
	self.path = [NSBezierPath bezierPath];
	[_path moveToPoint:pt];
	[self setGeometryRect:[_path bounds]];
}

- (void)lineTo:(NSPoint)pt {
	[_path lineToPoint:pt];
	[self setGeometryRect:[_path bounds]];
}

- (void)curveToTo:(NSPoint)pt controlPt:(NSPoint)cntrlPt {
	[_path curveToPoint:pt controlPoint1:cntrlPt controlPoint2:cntrlPt];
	[self setGeometryRect:[_path bounds]];
}

/* Recalculate computed values. Only ever called from private evaluate once per frame */
- (BOOL)execute:(id)fp8 head:(id)np time:(double)timeKey arguments:(id)fp20
{
	return YES;
}

/* like an end of run loop thing - we may want to get a patch uptodate but not have it do it's evaluateOncePerFrame
   eg. when we are dragging a tool, so in a way evaluateOncePerFrame is broken into two parts - enabling us to only call
   the finalize bit if we need to do so
 */
- (void)enforceConsistentState
{
	[self recalculateDrawingBounds];
}

- (void)recalculateDrawingBounds
{
	if ( _drawingBoundsDidChange == YES ) {
		_drawingBoundsDidChange = NO; // need to do this first, altho seems dodgy

		// -- how do we know what our drawing bounds are?

		NSRect currentSelectedBounds = self.drawingBounds;
		_drawingBounds = [self transformedGeometryRectBoundingBox];

		// add on our differences between drawing bounds and geometry here, eg stroke width, etc.

		[self setDirtyRect:NSUnionRect(self.drawingBounds, currentSelectedBounds)]; // again make sure we use the decorator's drawing bounds
	}
}

- (void)_customDrawing
{
	[[NSColor whiteColor] set];
	[_path setLineWidth:2.0];
	[_path stroke];
}

- (void)setGeometryRect:(NSRect)value {
	
	[super setGeometryRect:value];
//	self.path = [NSBezierPath bezierPathWithRect:_geometryRect];
}

@end
