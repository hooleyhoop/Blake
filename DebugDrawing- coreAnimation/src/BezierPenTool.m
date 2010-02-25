//
//  BezierPenTool.m
//  DebugDrawing
//
//  Created by steve hooley on 14/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "BezierPenTool.h"
#import "Bezier.h"
#import "Graphic.h"
#import "StarScene.h"
#import "AppControl.h"
#import "SelectedItem.h"

@implementation BezierPenTool

- (id)initWithToolBarController:(ToolBarController *)value
{
	self = [super initWithToolBarController:value];
	if ( self ) {
		_identifier = @"SKBezierPenTool";
		_labelString = @"BezierPen";
		_iconPath = [[NSBundle bundleForClass:[self class ]] pathForImageResource:@"PenToolIcn"];
	}
	return self;
}

- (void)mouseDownAtPoint:(NSPoint)pt event:(NSEvent *)event inStarView:(CALayerStarView *)view {

	// -- add a point?
	[self trackMouseWithEvent:event inSketchView:view];
}

NSPoint rotateBy180( NSPoint pt ){
	
	NSPoint rotatedCntrlPt = NSMakePoint( pt.x*-1.0, pt.y*-1.0 );
	return rotatedCntrlPt;
}

- (void)trackMouseWithEvent:(NSEvent *)event inSketchView:(CALayerStarView *)view
{
	NSPoint originalMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];

	if( _editingGraphic==nil ){

		// Clear the selection.
		[view.starScene setCurrentFilteredContentSelectionIndexes:[NSIndexSet indexSet]];
		
		Class graphicClassToInstantiate = [Bezier class];
		[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inStarView:view];

	} else {
		
        NSPoint lineToPoint = originalMouseLocation;
		
		// draw in a ghost line from last point to where new point will be
		NSBezierPath *editingPath = [_editingGraphic path];
		NSPoint lastPoint = [_editingGraphic localPtToParentSpace:[editingPath currentPoint]];
        _ghostLine = [[NSBezierPath bezierPath] retain];
        [_ghostLine moveToPoint:lastPoint];
		
		/* we can not change an alements type - we must recreate the path */
		[_ghostLine curveToPoint:lastPoint controlPoint1:lastPoint controlPoint2:lastPoint];

		/* Temporary */
        [_editingGraphic lineTo:[_editingGraphic parentSpacePtToLocalSpace:lineToPoint]];
		
        NSPoint curveToPoint = originalMouseLocation;

		[_toolBarControl addWidgetToView:self];

		while ( [event type] != NSLeftMouseUp )
		{
			event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
			NSPoint currentMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
			curveToPoint = currentMouseLocation;
			NSPoint rotatedCntrlPt = NSMakePoint( curveToPoint.x-originalMouseLocation.x, curveToPoint.y-originalMouseLocation.y );
            rotatedCntrlPt = rotateBy180(rotatedCntrlPt);
			rotatedCntrlPt.x = rotatedCntrlPt.x+originalMouseLocation.x;
			rotatedCntrlPt.y = rotatedCntrlPt.y+originalMouseLocation.y;
			
            NSPoint ptArray[3];
			ptArray[0] = lastPoint;				// The previous cntrl pt
			ptArray[1] = rotatedCntrlPt;
			ptArray[2] = originalMouseLocation;	// The end point
			NSPointArray ptData = &ptArray[0];


            //NSBezierPathElement eleType = [_path elementAtIndex:0 associatedPoints:ptData];
            //NSPoint startPt = ptArray[0];

	
            [_ghostLine setAssociatedPoints:ptData atIndex:1];
//			[view setNeedsDisplayInRect:[_ghostLine bounds]];
			[[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];

		}
		
		// line or curve?
//		if(NSEqualPoints(curveToPoint, originalMouseLocation))
//			[_editingGraphic lineTo:[_creatingGraphic parentSpacePtToLocalSpace:originalMouseLocation]];
//		else 
//			[_editingGraphic curveToTo:originalMouseLocation controlPt:curveToPoint];
		
		[view removeWidget:self];
        [_ghostLine release];
        _ghostLine = nil;
	}
    
    
}

- (void)createGraphicOfClass:(Class)graphicClass withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view
{
	NSPoint originalMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];

	// Create the new graphic and set it's bounds
	_creatingGraphic = [[graphicClass alloc] init];

	[_creatingGraphic setPosition:originalMouseLocation];
    NSPoint startPoint = [_creatingGraphic parentSpacePtToLocalSpace:originalMouseLocation];
    NSAssert(NSEqualPoints(startPoint, NSZeroPoint), @"Fucked up parentSpacePtToLocalSpace");
	[_creatingGraphic moveTo:startPoint];
	
	// Add it to the scene
	[view.starScene addGraphic:_creatingGraphic];

	[self startEditingGraphic:_creatingGraphic inSketchView:view];


	//    // Let the user size the new graphic until they let go of the mouse. Because different kinds of graphics have different kinds of handles, first ask the graphic class what handle the user is dragging during this initial sizing.
	//    [self resizeGraphic:_creatingGraphic usingHandle:0 withEvent:event inSketchView:view];
	//
	//    // Did we really create a graphic? Don't check with !NSIsEmptyRect(createdGraphicBounds) because the bounds of a perfectly horizontal or vertical line is "empty" but of course we want to let people create those.
	//    NSRect createdGraphicBounds = [_creatingGraphic physicalBounds];
	//    if (NSWidth(createdGraphicBounds)!=0.0 || NSHeight(createdGraphicBounds)!=0.0)
	//	{
	//put back!!		[view.starScene changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];

	// The graphic wasn't sized to nothing during mouse tracking. Present its editing interface it if it's that kind of graphic (like Sketch's SKTTexts). Invokers of the method we're in right now should have already cleared out _editingView.

	//    } else {
	//    }

	[_creatingGraphic release];
	_creatingGraphic = nil;
}

/* If the graphic provides a custom view for editing we  add it to the stage */
- (void)startEditingGraphic:(Graphic *)graphic inSketchView:(CALayerStarView *)view
{
	// Select it.
	// -- from the proxy, or the selected item, how do we find the index of this item?
	int newTextIndex = [view.starScene indexOfOriginalObjectIdenticalTo:_creatingGraphic];
	NSAssert(newTextIndex != NSNotFound, @"Failed to add new text!?");
	[view.starScene selectItemAtIndex:newTextIndex];
	
	_editingGraphic = [graphic retain];
//	[view setNeedsDisplayInRect:[_editingGraphic drawingBounds]];
}

#pragma mark Widget Protocol

/* This needs to be at minimum the bounds of the tool handles etc */
- (NSRect)displaybounds {
	
	return [_ghostLine bounds];
}

- (void)drawInStarView:(CALayerStarView *)view {
	
	[[NSColor controlDarkShadowColor] set];
	[_ghostLine stroke];
	NSLog(@"Drawing bez tool");
}

@end
