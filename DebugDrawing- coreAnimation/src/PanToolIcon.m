//
//  PanToolIcon.m
//  DebugDrawing
//
//  Created by steve hooley on 25/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "PanToolIcon.h"
#import "ToolBarController.h"
#import "PanTool.h"
#import "CustomMouseDragSelectionEventLoop.h"
#import "CALayerStarView.h"
#import "EditingViewController.h"
#import "AppControl.h"


@interface PanToolIcon ()
- (void)_dragFromStartPoint:(NSPoint)originalMouseLocation inView:(CALayerStarView *)view withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop;
- (void)panViewControllerFrom:(NSPoint)pt1 to:(NSPoint)pt2;
@end

@implementation PanToolIcon

- (id)initWithToolBarController:(ToolBarController *)controller domainTool:(NSObject<EditingToolProtocol, Widget_protocol> *)tool {
	
	self = [super initWithToolBarController:controller domainTool:tool];
	if ( self ) {
		_labelString = @"Pan";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"PanToolIcn"];
	}
	return self;
}

/* This is the toolbar-item's action */
- (void)toolWillBecomeActive {

	[super toolWillBecomeActive];
	[[NSCursor openHandCursor] set];
}

- (void)toolWillBecomeUnActive {

	[super toolWillBecomeUnActive];
	[[NSCursor arrowCursor] set];
}

/* If we hold the mouse down and drag we enter a loop */
- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {

	// custom Event Loop
	CustomMouseDragSelectionEventLoop *eventLoop = [CustomMouseDragSelectionEventLoop eventLoopWithWindow:[view window]];
	_previousPt = _mouseDownPtInViewSpace;
	[self _dragFromStartPoint:_previousPt inView:view withEventLoop:eventLoop];
}

- (void)_dragFromStartPoint:(NSPoint)originalMouseLocation inView:(CALayerStarView *)view withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop {

	[[NSCursor closedHandCursor] set];

	/* Where should this stuff go? */
	[self setWidgetBounds: CGRectMake( 0, 0, 10, 10 )];
	[self setWidgetOrigin: CGPointMake( originalMouseLocation.x, originalMouseLocation.y )];
	[self enforceConsistentState];
	[_toolBarControl addWidgetToView:self];

	NSDictionary *dataDict = [[NSDictionary dictionaryWithObjectsAndKeys:
							   eventLoop, @"eventLoop",
							   view, @"view",
							   nil] retain];

	[eventLoop loopWithCallbackObject:self method:@selector(dragLoop:) data:dataDict];
	[dataDict release];

	[self setWidgetBounds: CGRectZero];
	[self setWidgetOrigin: CGPointZero];
	[self enforceConsistentState];
	[_toolBarControl removeWidgetFromView:self];

	[[NSCursor openHandCursor] set];
}

- (void)dragLoop:(NSDictionary *)data {
	
	CustomMouseDragSelectionEventLoop *eventLoop = [data objectForKey:@"eventLoop"];
	CALayerStarView *view = [data objectForKey:@"view"];
	
	NSPoint currentMouseLocation = [_toolBarControl eventPtToViewPoint:[eventLoop eventPt]];
	
	[self panViewControllerFrom:_previousPt to:currentMouseLocation];
	
	_previousPt = currentMouseLocation;
	
	//TODO: look into this
	[(AppControl *)[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];
}

- (void)panViewControllerFrom:(NSPoint)pt1 to:(NSPoint)pt2 {
	
	[(PanTool *)_tool panByX:pt2.x-pt1.x y:pt2.y-pt1.y];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	
	CGContextSaveGState(ctx);
	
	CGRect bounds = CGContextGetClipBoundingBox(ctx); // This should be the clip rect
	
	CGContextBeginPath( ctx );
	
	CGContextMoveToPoint( ctx, 0, bounds.size.height/2.0f );
	CGContextAddLineToPoint( ctx, bounds.size.width, bounds.size.height/2.0f);
	
	CGContextMoveToPoint( ctx, bounds.size.width/2.0f, 0 );
	CGContextAddLineToPoint( ctx,bounds.size.width/2.0f, bounds.size.height);
	
	CGContextSetLineWidth( ctx, 0.33f );
	
	CGContextSetRGBStrokeColor( ctx, 0.0f, 0.0f, 0.0f, 0.9f );
	CGContextDrawPath( ctx, kCGPathStroke );
	
	CGContextRestoreGState( ctx );
}

@end
