//
//  SelectionWandIcon.m
//  DebugDrawing
//
//  Created by steve hooley on 15/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SelectionWandIcon.h"
#import "ToolBarController.h"
#import "SelectionWand.h"
#import "CustomMouseDragSelectionEventLoop.h"
#import "CALayerStarView.h"
#import "EditingViewController.h"
//#import "MathUtilities.h"
#import "MoreMiscUtilities.h"

@interface SelectionWandIcon ()
- (void)_showMarquee;
- (void)_hideMarquee;
- (void)_marqueeSelectFromStartPoint:(NSPoint)originalMouseLocation inView:(CALayerStarView *)view withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop;
@end

/*
 *
*/
@implementation SelectionWandIcon

#pragma mark Init Methods
- (id)initWithToolBarController:(ToolBarController *)controller domainTool:(NSObject<EditingToolProtocol, Widget_protocol> *)tool {
	
	self = [super initWithToolBarController:controller domainTool:tool];
	if ( self ) {
		_labelString = @"Select";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"ArrowToolIcn"];
	}
	return self;
}

/* This is the toolbar-item's action */
//- (IBAction)selectToolAction:(id)sender {
//	
//	[super selectToolAction:sender];
//}
//
//- (void)toolWillBecomeUnActive {
//	
//	[super toolWillBecomeUnActive];
//}


#pragma mark Action Methods
/* If we hold the mouse down and drag we enter a loop */
- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {

	// Are we changing the existing selection instead of setting a new one?
	BOOL isModifyingSelection = ([event modifierFlags] & NSShiftKeyMask) ? YES : NO;

	SHNode *mouseDownObject = [(SelectionWand *)_tool nodeUnderPoint:NSPointFromCGPoint(_mouseDownPtInSceneSpace)];

	if( mouseDownObject!=nil )
	{
		[(SelectionWand *)_tool didClickOnGraphic:mouseDownObject modifyingExistingSelection:isModifyingSelection];
	} else {

		[(SelectionWand *)_tool mouseDownInEmptySpaceModifyingExistingSelection:isModifyingSelection];

		// The user clicked on a point where there is no graphic. Select and deselect graphics until the user lets go of the mouse button.

		// custom Event Loop
		CustomMouseDragSelectionEventLoop *eventLoop = [CustomMouseDragSelectionEventLoop eventLoopWithWindow:[view window]];

		// interesting! Illustrator uses a window for the selection marquee
		[self _marqueeSelectFromStartPoint:(_mouseDownPtInViewSpace) inView:view withEventLoop:eventLoop];
	}
}

- (void)_marqueeSelectFromStartPoint:(NSPoint)originalMouseLocation inView:(CALayerStarView *)view withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop {

	[self _showMarquee];
	
	[(SelectionWand *)_tool beginModifyingSelectionWithMarquee];

	NSDictionary *dataDict = [[NSDictionary dictionaryWithObjectsAndKeys:
							   [NSValue valueWithPoint:originalMouseLocation], @"originalMouseLocation", 
							   eventLoop, @"eventLoop", 
							   view, @"view", 
							   nil] retain];
	
	[eventLoop loopWithCallbackObject:self method:@selector(dragLoop:) data:dataDict];
	[dataDict release];
	
	[(SelectionWand *)_tool endModifyingSelectionWithMarquee];
	
	// Schedule the drawing of the place where the rubber band isn't anymore.
	[self _hideMarquee];
}

- (void)dragLoop:(NSDictionary *)data {
	
	CustomMouseDragSelectionEventLoop *eventLoop = [data objectForKey:@"eventLoop"];
	CALayerStarView *view = [data objectForKey:@"view"];
	
	NSPoint originalMouseLocation = [[data objectForKey:@"originalMouseLocation"] pointValue];
	NSPoint currentMouseLocation = [_toolBarControl eventPtToViewPoint:[eventLoop eventPt]];

	CGPoint originalInSceneSpace = [_toolBarControl viewPointToScenePoint:originalMouseLocation];
	CGPoint currentInSceneSpace = [_toolBarControl viewPointToScenePoint:currentMouseLocation];
	
	// Figure out a new a selection rectangle based on the mouse location.
	CGRect drawInViewSpaceRect = [SelectionWand marqueeSelectionBoundsFromPoint:originalMouseLocation toPoint:currentMouseLocation];
	[self setWidgetBounds: CGRectMake( 0, 0, drawInViewSpaceRect.size.width, drawInViewSpaceRect.size.height )];
	[self setWidgetOrigin: drawInViewSpaceRect.origin];
	NSLog(@"drawInViewSpaceRect.origin] %@", NSStringWithCGPoint(drawInViewSpaceRect.origin));
	[self enforceConsistentState];

	CGRect selectInSceneSpacerect = [SelectionWand marqueeSelectionBoundsFromPoint:NSPointFromCGPoint(originalInSceneSpace) toPoint:NSPointFromCGPoint(currentInSceneSpace)];
	CGRect incorrectlyInsetRect = CGRectInset( selectInSceneSpacerect, -1.0f, -1.0f );
	
	// Erase the old selection rectangle and draw the new one.
	[(SelectionWand *)_tool setMarqueeSelectionBounds: incorrectlyInsetRect];
}

- (void)_showMarquee {
	
//	[(SelectionWand *)_tool setMarqueeSelectionBounds:CGRectZero];
	[self setWidgetBounds: CGRectZero];
	[self setWidgetOrigin: CGPointZero];
	[self enforceConsistentState];
	[_toolBarControl addWidgetToView:self];
}

- (void)_hideMarquee {
	
//	[(SelectionWand *)_tool setMarqueeSelectionBounds:CGRectZero];
	[self setWidgetBounds: CGRectZero];
	[self setWidgetOrigin: CGPointZero];
	[self enforceConsistentState];
	[_toolBarControl removeWidgetFromView:self];
}

#pragma mark CALayer delegate methods
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	
	static CGFloat lengths[6] = { 12.0f, 6.0f, 5.0f, 6.0f, 5.0f, 6.0f };	
	
	CGContextSaveGState(ctx);
	
	//	CGContextTranslateCTM( ctx, -_marqueeSelectionBounds.origin.x, -_marqueeSelectionBounds.origin.y );
	CGContextBeginPath( ctx );
	
	CGRect bounds = CGContextGetClipBoundingBox(ctx); // This should be the clip rect
	
	NSLog(@"*** layer pos ===== %@", [MoreMiscUtilities NSStringFromCGAffineTransform:layer.affineTransform]);

	
	//TODO: 
	/* TODO - this probably needs to correctly account for view scale */
	/* if we try to a draw a line centred around the bounds of the layer the line will be very weak, it needs to be someway inset */
	CGRect geom = [self geometryRect];
	//	CGRect hmmmm = CGRectMake( 0, 0, geom.size.width, geom.size.height );
	CGRect incorrectlyInsetRect = CGRectInset( geom, 2.0f, 2.0f );
	
	CGContextAddRect( ctx, incorrectlyInsetRect );
	CGContextSetLineWidth( ctx, 0.33f );
	
	// draw white
	CGContextSetRGBStrokeColor( ctx, 1.0f, 1.0f, 1.0f, 0.9f );
	CGContextDrawPath( ctx, kCGPathStroke );
	
	// draw black dashed
	CGContextAddRect( ctx, incorrectlyInsetRect );
	CGContextSetRGBStrokeColor( ctx, 0.0f, 0.0f, 0.0f, 0.9f );
	CGContextSetLineDash( ctx, 0.0f, lengths, 4 );
	CGContextSetLineWidth( ctx, 0.4f );
	CGContextDrawPath( ctx, kCGPathStroke );
	
	CGContextRestoreGState( ctx );
}

@end
