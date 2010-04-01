//
//  SKTTransformTool.m
//  BlakeLoader
//
//  Created by steve hooley on 09/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTTransformTool.h"
#import "TemporaryRealViewStuff.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTDecorator_Wireframe.h"

@implementation SKTTransformTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTTransformTool";
		_labelString = @"Transform";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"TransformToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {
	
	[item setToolTip:@"Transform"];
	[super setUpToolbarItem:item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {
	
    [self selectAndTrackMouseWithEvent:event inSketchView:view];
}

- (void)selectAndTrackMouseWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {
		
    // Has the user clicked on a graphic?
    NSPoint mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
    NSUInteger clickedGraphicIndex;
    BOOL clickedGraphicIsSelected;
    NSInteger clickedGraphicHandle;
    SKTGraphic *clickedGraphic = [view graphicUnderPoint:mouseLocation index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected handle:&clickedGraphicHandle];
	
    if(clickedGraphic) 
	{
        // Is the graphic that the user has clicked on now selected?
        if (clickedGraphicIsSelected) {
            
            // Yes. Let the user move all of the selected objects.
            [self moveSelectedGraphicsWithEvent:event inSketchView:view];
            
        } else {
            
            // No. Just swallow mouse events until the user lets go of the mouse button. We don't even bother autoscrolling here.
            while ([event type]!=NSLeftMouseUp)
            {
         //       NSLog(@"In a crazy ass mouse loop");
                event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
            }
        }
	
    } else {
		// The user clicked somewhere other than on a graphic. Clear the selection, unless the user is holding down the shift key.
		
		// The user clicked on a point where there is no graphic. Select and deselect graphics until the user lets go of the mouse button.
	}
}

- (void)moveSelectedGraphicsWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {
    
    NSPoint lastPoint, curPoint;
	
	/* is there any way this might apply to edges and/or points as weel as entire shapes? */
    NSUInteger c;
    BOOL didMove = NO, isMoving = NO;
    //   BOOL echoToRulers = [[self enclosingScrollView] rulersVisible];
    //   NSRect selBounds = [[SKTGraphic self] boundsOfGraphics:selGraphics];
    
    
    lastPoint = [view convertPoint:[event locationInWindow] fromView:nil];
    //    NSPoint selOriginOffset = NSMakePoint((lastPoint.x - selBounds.origin.x), (lastPoint.y - selBounds.origin.y));
    //    if (echoToRulers) {
    //        [self beginEchoingMoveToRulers:selBounds];
    //    }
    
	// -- swap all selected graphics for wireframe proxies
	NSMutableIndexSet *selectedIndexes = [view.sketchViewController.sketchViewModel sktSceneSelectionIndexes];
	NSMutableArray *sktSceneItems = view.sketchViewController.sketchViewModel.sktSceneItems;
	NSMutableArray *originalItems = [NSMutableArray array];
	unsigned int currentIndex = [selectedIndexes firstIndex];
	while( currentIndex!=NSNotFound ) {
		id originalItem=[sktSceneItems objectAtIndex:currentIndex];
		[originalItems addObject:originalItem];
		SKTDecorator_Wireframe *dec = [SKTDecorator_Wireframe decoratorForGraphic:originalItem];
		[sktSceneItems replaceObjectAtIndex:currentIndex withObject:dec];
		currentIndex = [selectedIndexes indexGreaterThanIndex: currentIndex];
	}
	
	NSArray *selGraphics = [view.sketchViewController.sketchViewModel selectedSktSceneItems];
	_movingGraphics = selGraphics;
    c = [selGraphics count];
	
    while( [event type]!=NSLeftMouseUp ) 
	{
        event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//		[self autoscroll:event];
        curPoint = [view convertPoint:[event locationInWindow] fromView:nil];
        if( !isMoving && ((fabs(curPoint.x - lastPoint.x) >= 2.0) || (fabs(curPoint.y - lastPoint.y) >= 2.0)) ) 
		{
            isMoving = YES;
 //           _isHidingHandles = YES;
        }
        if( isMoving ) 
		{
            if( !NSEqualPoints(lastPoint, curPoint) )
			{		
				//-- NB! we need to mark diry both where the graphics were + where they end up
				[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics: selGraphics]];
                
				[[SKTGraphic class] translateGraphics:selGraphics byX:(curPoint.x - lastPoint.x) y:(curPoint.y - lastPoint.y)];
				didMove = YES;
				
				/* here we must mark dirty for anything that moved - including any representation of the current tool =, etc. */
				[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:selGraphics]];
				
                
                //				if (echoToRulers) {
                //					[self continueEchoingMoveToRulers:NSMakeRect(curPoint.x - selOriginOffset.x, curPoint.y - selOriginOffset.y, NSWidth(selBounds),NSHeight(selBounds))];
                //				}
            }
            lastPoint = curPoint;
        }
    }
	
	// take out the moving proxies and put back our original items
	[sktSceneItems replaceObjectsAtIndexes:selectedIndexes withObjects:originalItems];
	
    _movingGraphics = nil;
    //    if (echoToRulers)  {
    //        [self stopEchoingMoveToRulers];
    //    }
	
    if (isMoving) {
 //       _isHidingHandles = NO;
        
        if (didMove) {
            // Only if we really moved.
			/* here we must mark dirty for anything that moved - including any representation of the current tool =, etc. */
			[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:selGraphics]];

        }
    }
}

//- (SKTGraphic *)preferredDrawingStyleForGraphic:(SKTGraphic *)graphic {
//    
//	if( [_movingGraphics containsObject:graphic] )
//		return SKTGraphicWireframe;
//    return SKTGraphicNormalFill;
//}


//- (enum SKTGraphicDrawingMode)preferredDrawingStyleForGraphic:(SKTGraphic *)graphic {
//    
//	if( [_movingGraphics containsObject:graphic] )
//		return SKTGraphicWireframe;
//    return SKTGraphicNormalFill;
//}

@end
