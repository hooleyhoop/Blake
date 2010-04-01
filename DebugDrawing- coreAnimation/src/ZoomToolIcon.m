//
//  ZoomToolIcon.m
//  DebugDrawing
//
//  Created by steve hooley on 25/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ZoomToolIcon.h"
#import "ToolBarController.h"
#import "ZoomTool.h"
#import "CALayerStarView.h"
#import "CustomMouseDragSelectionEventLoop.h"
//#import "MathUtilities.h"
#import "DomainContext.h"
#import "StarScene.h"
#import "SceneDisplay.h"
#import "NodeContainerLayer.h"
#import "EditingViewController.h"
#import "AppControl.h"

@interface ZoomToolIcon ()
- (void)_dragFromStartPoint:(NSPoint)originalMouseLocation inView:(CALayerStarView *)view withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop;
- (void)zoomViewControllerFrom:(NSPoint)pt1 to:(NSPoint)pt2;

@end

/*
 *
*/
@implementation ZoomToolIcon

- (id)initWithToolBarController:(ToolBarController *)controller domainTool:(NSObject<EditingToolProtocol, Widget_protocol> *)tool {
	
	self = [super initWithToolBarController:controller domainTool:tool];
	if ( self ) {
		_labelString = @"Zoom";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"ZoomToolIcn"];
	}
	return self;
}

/* This is the toolbar-item's action */
- (void)toolWillBecomeActive {

	[super toolWillBecomeActive];
	[[NSCursor resizeLeftRightCursor] set];
}

- (void)toolWillBecomeUnActive {

	[super toolWillBecomeUnActive];
	[[NSCursor arrowCursor] set];
}

/* If we hold the mouse down and drag we enter a loop */
- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
	// custom Event Loop
	CustomMouseDragSelectionEventLoop *eventLoop = [CustomMouseDragSelectionEventLoop eventLoopWithWindow:[view window]];
	_previousPt = (_mouseDownPtInViewSpace);

	[self _dragFromStartPoint:_previousPt inView:view withEventLoop:eventLoop];
}

- (void)_dragFromStartPoint:(NSPoint)originalMouseLocation inView:(CALayerStarView *)view withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop {
	
	
	//TODO: Apple motion has - right goes bigger, left goes smaller
	//		it drags around the point that you click, which is indicated with a cross hair

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
}

- (void)dragLoop:(NSDictionary *)data {
	
	CustomMouseDragSelectionEventLoop *eventLoop = [data objectForKey:@"eventLoop"];
	CALayerStarView *view = [data objectForKey:@"view"];

	NSPoint currentMouseLocation = ([_toolBarControl eventPtToViewPoint:[eventLoop eventPt]]); // NSPointFromCGPoint
	
	[self zoomViewControllerFrom:_previousPt to:currentMouseLocation];
	
	_previousPt = currentMouseLocation;
	
	//TODO: look into this
	[(AppControl *)[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];
}

- (void)zoomViewControllerFrom:(NSPoint)pt1 to:(NSPoint)pt2 {
	
	// scale from the origin
	// scale = 1, click at 1 and drag to 2 : scale now = 2
	// => scaleAmountToIncrease = 1
	
	// scale = 2, click at 2 and drag to 4 : scale now = 4
	// => scaleAmountToIncrease = 2
	
	// scale = 4, click at 4 and drag to 8 : scale now = 8
	// => scaleAmountToIncrease = 2
	
	// scale = 4, click at 4 and drag to 2 : scale now = 2
	// => scaleAmountToIncrease = -2
	

	
	[(ZoomTool *)_tool zoomFrom:pt1 to:pt2];
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
