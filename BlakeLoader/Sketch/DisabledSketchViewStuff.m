//
//  DisabledSketchViewStuff.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 23/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "DisabledSketchViewStuff.h"


@implementation  SKTGraphicView (DisabledSketchViewStuff)


- (void)beginEchoingMoveToRulers:(NSRect)echoRect {
	
    NSRulerView *horizontalRuler = [[self enclosingScrollView] horizontalRulerView];
    NSRulerView *verticalRuler = [[self enclosingScrollView] verticalRulerView];
    
    NSRect newHorizontalRect = [self convertRect:echoRect toView:horizontalRuler];
    NSRect newVerticalRect = [self convertRect:echoRect toView:verticalRuler];
    
    [horizontalRuler moveRulerlineFromLocation:-1.0 toLocation:NSMinX(newHorizontalRect)];
    [horizontalRuler moveRulerlineFromLocation:-1.0 toLocation:NSMidX(newHorizontalRect)];
    [horizontalRuler moveRulerlineFromLocation:-1.0 toLocation:NSMaxX(newHorizontalRect)];
    
    [verticalRuler moveRulerlineFromLocation:-1.0 toLocation:NSMinY(newVerticalRect)];
    [verticalRuler moveRulerlineFromLocation:-1.0 toLocation:NSMidY(newVerticalRect)];
    [verticalRuler moveRulerlineFromLocation:-1.0 toLocation:NSMaxY(newVerticalRect)];
    
//   _rulerEchoedBounds = echoRect;
}

- (void)continueEchoingMoveToRulers:(NSRect)echoRect {
	
//    NSRulerView *horizontalRuler = [[self enclosingScrollView] horizontalRulerView];
//    NSRulerView *verticalRuler = [[self enclosingScrollView] verticalRulerView];
//	
//    NSRect oldHorizontalRect = [self convertRect:_rulerEchoedBounds toView:horizontalRuler];
//    NSRect oldVerticalRect = [self convertRect:_rulerEchoedBounds toView:verticalRuler];    
//    
//    NSRect newHorizontalRect = [self convertRect:echoRect toView:horizontalRuler];
//    NSRect newVerticalRect = [self convertRect:echoRect toView:verticalRuler];
//	
//    [horizontalRuler moveRulerlineFromLocation:NSMinX(oldHorizontalRect) toLocation:NSMinX(newHorizontalRect)];
//    [horizontalRuler moveRulerlineFromLocation:NSMidX(oldHorizontalRect) toLocation:NSMidX(newHorizontalRect)];
//    [horizontalRuler moveRulerlineFromLocation:NSMaxX(oldHorizontalRect) toLocation:NSMaxX(newHorizontalRect)];
//    
//    [verticalRuler moveRulerlineFromLocation:NSMinY(oldVerticalRect) toLocation:NSMinY(newVerticalRect)];
//    [verticalRuler moveRulerlineFromLocation:NSMidY(oldVerticalRect) toLocation:NSMidY(newVerticalRect)];
//    [verticalRuler moveRulerlineFromLocation:NSMaxY(oldVerticalRect) toLocation:NSMaxY(newVerticalRect)];
//    
//    _rulerEchoedBounds = echoRect;
}

- (void)stopEchoingMoveToRulers {
	
//    NSRulerView *horizontalRuler = [[self enclosingScrollView] horizontalRulerView];
//    NSRulerView *verticalRuler = [[self enclosingScrollView] verticalRulerView];
//    
//    NSRect oldHorizontalRect = [self convertRect:_rulerEchoedBounds toView:horizontalRuler];
//    NSRect oldVerticalRect = [self convertRect:_rulerEchoedBounds toView:verticalRuler];
//    
//    [horizontalRuler moveRulerlineFromLocation:NSMinX(oldHorizontalRect) toLocation:-1.0];
//    [horizontalRuler moveRulerlineFromLocation:NSMidX(oldHorizontalRect) toLocation:-1.0];
//    [horizontalRuler moveRulerlineFromLocation:NSMaxX(oldHorizontalRect) toLocation:-1.0];
//    
//    [verticalRuler moveRulerlineFromLocation:NSMinY(oldVerticalRect) toLocation:-1.0];
//    [verticalRuler moveRulerlineFromLocation:NSMidY(oldVerticalRect) toLocation:-1.0];
//    [verticalRuler moveRulerlineFromLocation:NSMaxY(oldVerticalRect) toLocation:-1.0];
//    
//    _rulerEchoedBounds = NSZeroRect;
}


// Overrides of the NSResponder(NSStandardKeyBindingMethods) methods.
- (void)moveLeft:(id)sender {
  //  [self moveSelectedGraphicsByX:-1.0f y:0.0f];
}
- (void)moveRight:(id)sender {
 //   [self moveSelectedGraphicsByX:1.0f y:0.0f];
}
- (void)moveUp:(id)sender {
//    [self moveSelectedGraphicsByX:0.0f y:-1.0f];
}
- (void)moveDown:(id)sender {
  //  [self moveSelectedGraphicsByX:0.0f y:1.0f];
}

// use validateUserInterfaceItem
// Conformance to the NSObject(NSMenuValidation) informal protocol.
- (BOOL)validateMenuItem:(NSMenuItem *)item {
	
    SEL action = [item action];
    
    if (action == @selector(makeNaturalSize:)) {
        // Return YES if we have at least one selected graphic that has a natural size.
 //JOOST       NSArray *selectedGraphics = [_sketchViewController selectedGraphics];
 //JOOST       NSUInteger i, c = [selectedGraphics count];
 //JOOST       if (c > 0) {
 //JOOST           for(i=0; i<c; i++)
//JOOST			{
//JOOST				NSAssert([selectedGraphics count]>i, @"bad index validateMenuItem");
 //JOOST               if ([[selectedGraphics objectAtIndex:i] canMakeNaturalSize]) {
 //JOOST                   return YES;
 //JOOST               }
 //JOOST           }
 //JOOST       }
//JOOST        return NO;
    } else if ((action == @selector(alignWithGrid:)) || (action == @selector(delete:)) || (action == @selector(bringToFront:)) || (action == @selector(sendToBack:)) || (action == @selector(cut:)) || (action == @selector(copy:))) {
		
		// These only apply if there is a selection
 //JOOST       return (([[_sketchViewController selectedGraphics] count] > 0) ? YES : NO);
    } else if ((action == @selector(alignLeftEdges:)) || (action == @selector(alignRightEdges:)) || (action == @selector(alignTopEdges:)) || (action == @selector(alignBottomEdges:)) || (action == @selector(alignHorizontalCenters:)) || (action == @selector(alignVerticalCenters:)) || (action == @selector(makeSameWidth:)) || (action == @selector(makeSameHeight:))) {
        // These only apply to multiple selection
 //JOOST       return (([[_sketchViewController selectedGraphics] count] > 1) ? YES : NO);
    } else if (action==@selector(undo:) || action==@selector(redo:)) {
		
		// Because we implement -undo: and redo: action methods we must validate the actions too. Messaging the window directly like this is not strictly correct, because there may be other responders in the chain between this view and the window (superviews maybe?) that want control over undoing and redoing, but there's no AppKit method we can invoke to simply find the next responder that responds to -undo: and -redo:.
//JOOST		return [[self window] validateMenuItem:item];
		
    } else if (action==@selector(showOrHideRulers:)) {
		
		// The Show/Hide Ruler menu item is always enabled, but we have to set its title.
//JOOST		[item setTitle:([[self enclosingScrollView] rulersVisible] ? NSLocalizedStringFromTable(@"Hide Ruler", @"SKTGraphicView", @"A main menu item title.") : NSLocalizedStringFromTable(@"Show Ruler", @"SKTGraphicView", @"A main menu item title."))];
//JOOST		return YES;
		
    }
	return YES;
}

// - (void)moveSelectedGraphicsByX:(CGFloat)x y:(CGFloat)y {

// Don't do anything if there's nothing to do.
//    NSArray *selectedGraphics = [_sketchViewController selectedGraphics];
//    if ([selectedGraphics count]>0)
//	{
//		// Don't draw and redraw the selection rectangles while the user holds an arrow key to autorepeat.
//        [self hideHandlesMomentarily];
//
//		// Move the selected graphics
//		NSLog(@"new invalidating");
//		[self setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:selectedGraphics]];
//		[[SKTGraphic class] translateGraphics:selectedGraphics byX:x y:y];
//		[self setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:selectedGraphics]];
//    }
// }

//- (void)unhideHandlesForTimer:(NSTimer *)timer {
//    _isHidingHandles = NO;
//    _handleShowingTimer = nil;
//    [self setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:[_sketchViewController selectedGraphics]]];
//}

//- (void)hideHandlesMomentarily {
//    [_handleShowingTimer invalidate];
//    _handleShowingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(unhideHandlesForTimer:) userInfo:nil repeats:NO];
//    _isHidingHandles = YES;
//    [self setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:[_sketchViewController selectedGraphics]]];
//}

// Conformance to the NSObject(NSColorPanelResponderMethod) informal protocol.
//- (void)changeColor:(id)sender {
//    
//    // Change the color of every selected graphic.
//    [[_sketchViewController selectedGraphics] makeObjectsPerformSelector:@selector(setColor:) withObject:[sender color]];
//    
//}

// Overrides of the NSResponder(NSStandardKeyBindingMethods) methods.
//- (void)deleteBackward:(id)sender {
//    [self delete:sender];
//}
//- (void)deleteForward:(id)sender {
//    [self delete:sender];
//}

//- (void)invalidateHandlesOfGraphics:(NSArray *)graphics {
//	
//    NSUInteger i, c = [graphics count];
//    for(i=0; i<c; i++) {
//		NSAssert([graphics count]>i, @"bad index invalidateHandlesOfGraphics");
//		[self setNeedsDisplayInRect:[[graphics objectAtIndex:i] drawingBounds]];
//    }
//}

//putbacklater- (IBAction)bringToFront:(id)sender {

//putbacklater    NSArray *selectedObjects = [[_sketchViewController selectedGraphics] copy];
//putbacklater    NSIndexSet *selectionIndexes = [_sketchViewController selectionIndexes];
//putbacklater    if ([selectionIndexes count]>0) {
//putbacklater	NSMutableArray *mutableGraphics = [_sketchViewController mutableGraphics];
//putbacklater	[mutableGraphics removeObjectsAtIndexes:selectionIndexes];
//putbacklater	NSIndexSet *insertionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [selectedObjects count])];
//putbacklater	[mutableGraphics insertObjects:selectedObjects atIndexes:insertionIndexes];
//putbacklater	[_sketchViewController changeSelectionIndexes:insertionIndexes];
//putbacklater
//putbacklater    }
//putbacklater    [selectedObjects release];
//putbacklater}


//putbacklater- (IBAction)sendToBack:(id)sender {

//putbacklater    NSArray *selectedObjects = [[_sketchViewController selectedGraphics] copy];
//putbacklater    NSIndexSet *selectionIndexes = [_sketchViewController selectionIndexes];
//putbacklater    if ([selectionIndexes count]>0) {
//putbacklater	NSMutableArray *mutableGraphics = [_sketchViewController mutableGraphics];
//putbacklater	[mutableGraphics removeObjectsAtIndexes:selectionIndexes];
//putbacklater	NSIndexSet *insertionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([mutableGraphics count], [selectedObjects count])];
//putbacklater	[mutableGraphics insertObjects:selectedObjects atIndexes:insertionIndexes];
//putbacklater	[_sketchViewController changeSelectionIndexes:insertionIndexes];
//putbacklater    }
//putbacklater    [selectedObjects release];
//putbacklater}

//putbacklater- (IBAction)makeSameWidth:(id)sender {
//putbacklater
//putbacklater    NSArray *selection = [_sketchViewController selectedGraphics];
//putbacklater    NSUInteger i, c = [selection count];
//putbacklater    if (c > 1)
//putbacklater	{
//putbacklater		NSAssert([selection count]>0, @"bad index makeSameWidth");
//putbacklater       NSRect firstBounds = [[selection objectAtIndex:0] bounds];
//putbacklater       SKTGraphic *curGraphic;
//putbacklater        NSRect curBounds;
//putbacklater        for(i=1; i<c; i++) {
//putbacklater			NSAssert([selection count]>i, @"bad index makeSameWidth");
//putbacklater           curGraphic = [selection objectAtIndex:i];
//putbacklater            curBounds = [curGraphic bounds];
//putbacklater           if (curBounds.size.width != firstBounds.size.width) {
//putbacklater               curBounds.size.width = firstBounds.size.width;
//putbacklater               [curGraphic setBounds:curBounds];
//putbacklater            }
//putbacklater        }
//putbacklater
//putbacklater    }
//putbacklater}

//putbacklater- (IBAction)makeSameHeight:(id)sender {
//putbacklater	
//putbacklater    NSArray *selection = [_sketchViewController selectedGraphics];
//putbacklater   NSUInteger i, c = [selection count];
//putbacklater    if (c > 1) {
//putbacklater		NSAssert([selection count]>0, @"bad index makeSameHeight");
//putbacklater       NSRect firstBounds = [[selection objectAtIndex:0] bounds];
//putbacklater       SKTGraphic *curGraphic;
//putbacklater       NSRect curBounds;
//putbacklater       for(i=1; i<c; i++)
//putbacklater		{
//putbacklater			NSAssert([selection count]>i, @"bad index makeSameHeight");
//putbacklater           curGraphic = [selection objectAtIndex:i];
//putbacklater           curBounds = [curGraphic bounds];
//putbacklater           if (curBounds.size.height != firstBounds.size.height) {
//putbacklater               curBounds.size.height = firstBounds.size.height;
//putbacklater                [curGraphic setBounds:curBounds];
//putbacklater           }
//putbacklater       }
//putbacklater
//putbacklater    }
//putbacklater}

//putbacklater- (IBAction)makeNaturalSize:(id)sender {
//putbacklater    NSArray *selection = [_sketchViewController selectedGraphics];
//putbacklater    if ([selection count] > 0) {
//putbacklater        [selection makeObjectsPerformSelector:@selector(makeNaturalSize)];
//putbacklater   }
//putbacklater}



// See the comment in the header about why we're not using -toggleRuler:.
- (IBAction)showOrHideRulers:(id)sender {
    
    // Simple.
    NSScrollView *enclosingScrollView = [self enclosingScrollView];
    [enclosingScrollView setRulersVisible:![enclosingScrollView rulersVisible]];
    
}

@end
