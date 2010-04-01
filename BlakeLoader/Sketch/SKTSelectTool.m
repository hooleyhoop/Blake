//
//  SKTSelectTool.m
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTSelectTool.h"
#import "SKTGraphicView.h"
#import "SKTDecorator_Selected.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"


@implementation SKTSelectTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTSelectTool";
		_labelString = @"Select";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"ArrowToolIcn"];
		
		_drawingBounds = NSZeroRect, _marqueeSelectionBounds = NSZeroRect;
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {
	
	[item setToolTip:@"Select"];
	[super setUpToolbarItem:item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {
	
	// Double-clicking with the selection tool always means "start editing," or "do nothing" if no editable graphic is double-clicked on.
	SKTGraphic *doubleClickedGraphic = nil;
	if ([event clickCount]>1) 
	{
		doubleClickedGraphic = [view graphicUnderPoint:pt index:NULL isSelected:NULL handle:NULL];
		if (doubleClickedGraphic) {
			[self startEditingGraphic:doubleClickedGraphic inSketchView:view];
		}
	}
	if (!doubleClickedGraphic) {
		// Update the selection and/or move graphics or resize graphics.
		[self selectAndTrackMouseWithEvent:event inSketchView:view];
	}
}

- (void)selectAndTrackMouseWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {
	
    // Are we changing the existing selection instead of setting a new one?
    BOOL modifyingExistingSelection = ([event modifierFlags] & NSShiftKeyMask) ? YES : NO;
	
    // Has the user clicked on a graphic?
    NSPoint mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
    NSUInteger clickedGraphicIndex;
    BOOL clickedGraphicIsSelected;
    NSInteger clickedGraphicHandle;
    SKTGraphic *clickedGraphic = [view graphicUnderPoint:mouseLocation index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected handle:&clickedGraphicHandle];
	
    if(clickedGraphic) 
	{
		// Clicking on a graphic knob takes precedence.
		if (clickedGraphicHandle!=SKTGraphicNoHandle)
		{
			NSLog(@"clicked on a graphic handle");
			// The user clicked on a graphic's handle. Let the user drag it around.
			[self resizeGraphic:clickedGraphic usingHandle:clickedGraphicHandle withEvent:event inSketchView:view];
			
		} else {
			
			// -- sketchViewModel needs a selection controller --
			// should the current tool maybe hook into here?
			
			// The user clicked on a graphic's contents. Update the selection.
			if (modifyingExistingSelection) 
			{
				if (clickedGraphicIsSelected) 
				{
					// Remove the graphic from the selection.
					
					// this could be in the scene/model - ??
					NSRect boundsOfDeselectedGraphics = [SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]];
					
					NSMutableIndexSet *newSelectionIndexes = [[view.sketchViewController.sketchViewModel sktSceneSelectionIndexes] mutableCopy];
					[newSelectionIndexes removeIndex:clickedGraphicIndex];
					[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:newSelectionIndexes];
					NSRect boundsOfAllSelected = [SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]];

					[newSelectionIndexes release];
					clickedGraphicIsSelected = NO;
					
					_drawingBounds = boundsOfAllSelected;
					[view setNeedsDisplayInRect:boundsOfDeselectedGraphics];

					// why did sketch need this?
//					[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]]];
					
				} else {
					
					// Add the graphic to the selection.
					
					// why did sketch need this?
//					[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]]];
					
					NSMutableIndexSet *newSelectionIndexes = [[view.sketchViewController.sketchViewModel sktSceneSelectionIndexes] mutableCopy];
					[newSelectionIndexes addIndex:clickedGraphicIndex];
					[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:newSelectionIndexes];
					[newSelectionIndexes release];
					clickedGraphicIsSelected = YES;
					NSRect boundsOfAllSelected = [SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]];
					_drawingBounds = boundsOfAllSelected;

					[view setNeedsDisplayInRect:_drawingBounds];
				}
				
			} else {
				
				// If the graphic wasn't selected before then it is now, and none of the rest are.
				if (!clickedGraphicIsSelected) 
				{
					[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndex:clickedGraphicIndex]];
					clickedGraphicIsSelected = YES;
					
					_drawingBounds = [clickedGraphic drawingBounds];

					// why didn't sketch need this?
					[view setNeedsDisplayInRect:[clickedGraphic drawingBounds]];
						
				}
			}
			// Is the graphic that the user has clicked on now selected?
//			if (clickedGraphicIsSelected) {
//			} else {
				// No. Just swallow mouse events until the user lets go of the mouse button. We don't even bother autoscrolling here.
				while ([event type]!=NSLeftMouseUp)
				{
				//	NSLog(@"In a crazy ass mouse loop");
					event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
				}				
//			}
		}
		
    } else {
	    
		// The user clicked somewhere other than on a graphic. Clear the selection, unless the user is holding down the shift key.
		if (!modifyingExistingSelection)
		{
			[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]]];
			[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]];
			
			_drawingBounds = NSZeroRect;
		}
		
		// The user clicked on a point where there is no graphic. Select and deselect graphics until the user lets go of the mouse button.
		[self marqueeSelectWithEvent:event inSketchView:view];
	}
}

- (void)marqueeSelectWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {
	
    // Dequeue and handle mouse events until the user lets go of the mouse button.
    NSIndexSet *oldSelectionIndexes = [[view.sketchViewController.sketchViewModel sktSceneSelectionIndexes] retain];
    NSPoint originalMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
    while ([event type]!=NSLeftMouseUp) 
	{
		event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		[view autoscroll:event];
		NSPoint currentMouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
		
		// Figure out a new a selection rectangle based on the mouse location.
		NSRect newMarqueeSelectionBounds = NSMakeRect(fmin(originalMouseLocation.x, currentMouseLocation.x), fmin(originalMouseLocation.y, currentMouseLocation.y), fabs(currentMouseLocation.x - originalMouseLocation.x), fabs(currentMouseLocation.y - originalMouseLocation.y));
		if (!NSEqualRects(newMarqueeSelectionBounds, _marqueeSelectionBounds)) 
		{
			// Erase the old selection rectangle and draw the new one.
			[view setNeedsDisplayInRect:_marqueeSelectionBounds];
			_marqueeSelectionBounds = newMarqueeSelectionBounds;
			[view setNeedsDisplayInRect:_marqueeSelectionBounds];
			
			// Either select or deselect all of the graphics that intersect the selection rectangle.
			NSIndexSet *indexesOfGraphicsInRubberBand = [view indexesOfGraphicsIntersectingRect:_marqueeSelectionBounds];
			NSMutableIndexSet *newSelectionIndexes = [oldSelectionIndexes mutableCopy];
			for( NSUInteger index = [indexesOfGraphicsInRubberBand firstIndex]; index!=NSNotFound; index = [indexesOfGraphicsInRubberBand indexGreaterThanIndex:index]) {
				if ([newSelectionIndexes containsIndex:index]) {
					[newSelectionIndexes removeIndex:index];
					
//					-- update _drawingBounds

				} else {
					[newSelectionIndexes addIndex:index];
					
//					-- update _drawingBounds

				}
			}
			[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:newSelectionIndexes];
			NSRect boundsOfAllSelected = [SKTGraphic drawingBoundsOfGraphics:[view.sketchViewController.sketchViewModel selectedSktSceneItems]];
			_drawingBounds = boundsOfAllSelected;
			[newSelectionIndexes release];
			
		}
    }
	[oldSelectionIndexes release];
	
    // Schedule the drawing of the place wherew the rubber band isn't anymore.
    [view setNeedsDisplayInRect:_marqueeSelectionBounds];
	
    // Make it not there.
    _marqueeSelectionBounds = NSZeroRect;
}

- (void)drawHandleInView:(NSView *)view atPoint:(NSPoint)point {
	
    // Figure out a rectangle that's centered on the point but lined up with device pixels.
    NSRect handleBounds;
    handleBounds.origin.x = point.x - 3.0;
    handleBounds.origin.y = point.y - 3.0;
    handleBounds.size.width = 6.0;
    handleBounds.size.height = 6.0;
    handleBounds = [view centerScanRect:handleBounds];
    
    // Draw the shadow of the handle.
    NSRect handleShadowBounds = NSOffsetRect(handleBounds, 1.0f, 1.0f);
    [[NSColor controlDarkShadowColor] set];
    NSRectFill(handleShadowBounds);
	
    // Draw the handle itself.
    [[NSColor knobColor] set];
    NSRectFill(handleBounds);
}

- (void)drawToolInSketchView:(SKTGraphicView *)view {
	
	[[NSColor knobColor] set];

    // If the user is in the middle of selecting draw the selection rectangle.
    if( !NSEqualRects(_marqueeSelectionBounds, NSZeroRect )) {
        NSDottedFrameRect(_marqueeSelectionBounds);
    } 
//	NSFrameRect(_drawingBounds);
//	// draw a little sq in each corner
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(_drawingBounds), NSMinY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMidX(_drawingBounds), NSMinY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(_drawingBounds), NSMinY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(_drawingBounds), NSMidY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(_drawingBounds), NSMidY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMinX(_drawingBounds), NSMaxY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMidX(_drawingBounds), NSMaxY(_drawingBounds))];
//    [self drawHandleInView:view atPoint:NSMakePoint(NSMaxX(_drawingBounds), NSMaxY(_drawingBounds))];
}

- (NSRect)toolDisplaybounds {

	NSRect totalDrawingBounds = NSUnionRect(_marqueeSelectionBounds, _drawingBounds);
	return totalDrawingBounds;
}

@end
