//
//  AnchorTool.m
//  DebugDrawing
//
//  Created by steve hooley on 06/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "AnchorTool.h"
#import "StarScene.h"
#import "AppControl.h"
#import "Graphic.h"
#import "SelectedItem.h"
#import "TranslateTool.h"
#import "HitTestContext.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"

const static CGFloat handleCentreSize = 7.0;
const static CGFloat handleSize = 100.0;

@implementation AnchorTool

#pragma mark Init Methods

- (id)initWithToolBarController:(ToolBarController *)value {
	
	self = [super initWithToolBarController:value];
	if(self){
		_identifier = @"SKTAnchorTool";
		_labelString = @"Anchor";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"AnchorToolIcn"];
	}
	return self;
}

/* called after each graphic has been updated */
- (void)updateSelectedObjectBounds {
	
	// we want to draw an anchor point on each selected grapic
	
	CALayerStarView *view = _toolBarControl.targetView;
//	[view setNeedsDisplayInRect:_displayBounds];
	
	NSArray *selectedItems = [view.starScene selectedItems];
	NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
	NSRect boundsOfAllSelected = [StarScene drawingBoundsOfGraphics:moveAble];
	// -- tool is dirty in old rect and new rect. the objects themselves have already notified the view
	_selectedObjectsBounds = boundsOfAllSelected;
	
	// we really need to include all the anchor bounds here, incase total selected bounds is smaller than our anchor point graphic
	NSRect handleRect = NSZeroRect;
	for( SelectedItem *each in moveAble){
		
		NSPoint centrePoint = [each position];
		NSRect anchorRect = NSMakeRect(centrePoint.x-handleCentreSize/2.0, centrePoint.y-handleCentreSize/2.0, handleCentreSize, handleCentreSize);
		handleRect = NSUnionRect(handleRect, anchorRect);
	}
	handleRect = NSMakeRect(handleRect.origin.x-handleSize, handleRect.origin.y, handleSize, handleSize);
	_displayBounds = NSInsetRect( NSUnionRect( handleRect, _selectedObjectsBounds ), -handleCentreSize, -handleCentreSize); // add a bit of a margin
//	[view setNeedsDisplayInRect:_displayBounds];
	
	self.bounds = NSRectToCGRect(_displayBounds);
}

- (void)enforceConsistentState {
    [self updateSelectedObjectBounds];
}


- (SelectedItem*)ownerOfAnchorUnderPoint:(NSPoint)pt inView:(CALayerStarView *)view clickType:(int *)handle {
	
	// find the owner of the anchorpoint under the mouse
    id clickedGraphic = nil;
	NSArray *selectedItems = [view.starScene selectedItems];
	NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
	HitTestContext *secondHitTestCntxt = [HitTestContext hitTestContextAtPoint:pt];

    for( SelectedItem *each in [moveAble reverseObjectEnumerator] )
	{
		// did we click directly on the anchor rect?
		[self _drawAnchor: each];
		[secondHitTestCntxt checkAndResetWithKey: @"anchor"];
		if([secondHitTestCntxt countOfHitObjects]>0)
		{
			*handle = 0;
			clickedGraphic = each;
			goto home;
		}
		
//        NSPoint anchor = [each position];
//        NSRect anchorBounds = NSMakeRect( anchor.x-handleCentreSize/2.0, anchor.y-handleCentreSize/2.0, handleCentreSize, handleCentreSize );
//        BOOL hitAnchor = NSPointInRect(pt, anchorBounds);
//        if(hitAnchor){
//            clickedGraphic = each;
//			*handle = 0;
//			break;
//		}
//		
//		// did we click on Horizontal handle?
//		NSRect horizHandleBounds = NSMakeRect( anchor.x-handleSize, anchor.y-2, handleSize, 4 );
//        hitAnchor = NSPointInRect(pt, horizHandleBounds);
//        if(hitAnchor){
//            clickedGraphic = each;
//			*handle = 1;
//			break;
//		}
//		
//		// did we click on Verticle handle?
//		NSRect vertHandleBounds = NSMakeRect( anchor.x-2, anchor.y, 4, handleSize );
//        hitAnchor = NSPointInRect(pt, vertHandleBounds);
//        if(hitAnchor){
//            clickedGraphic = each;
//			*handle = 2;
//			break;
//		}
    }
home:
	[secondHitTestCntxt cleanUpHitTesting];
	return clickedGraphic;
}

- (void)mouseDownAtPoint:(NSPoint)pt event:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
    // have we moused down on an anchrPoint? anchrPoint graphic may be outside of a geometry
	_clickHandle=0;
	_ownerOfAnchor = [self ownerOfAnchorUnderPoint:pt inView:view clickType:&_clickHandle];
}

- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
    
    NSPoint startPoint, lastPoint, curPoint, startAnchor;
	BOOL altDrag = ([event modifierFlags] & NSAlternateKeyMask) ? YES : NO;
    BOOL didMove = NO, isMoving = NO;
	    
    startPoint = [view convertPoint:[event locationInWindow] fromView:nil];
    lastPoint=startPoint;
	startAnchor = [(id)_ownerOfAnchor anchorPt];
	
    while( [event type]!=NSLeftMouseUp ) 
	{
        event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        curPoint = [view convertPoint:[event locationInWindow] fromView:nil];
        if( !isMoving && ((fabs(curPoint.x - lastPoint.x) >= 2.0) || (fabs(curPoint.y - lastPoint.y) >= 2.0)) ) 
		{
            isMoving = YES;
        }
        if( isMoving ) 
		{
            if( !NSEqualPoints(lastPoint, curPoint) )
			{
                CGFloat relmovedx = curPoint.x - lastPoint.x;
                CGFloat relmovedy = curPoint.y - lastPoint.y;
                CGFloat movedx = curPoint.x - startPoint.x;
                CGFloat movedy = curPoint.y - startPoint.y;
				
                // Constrain movement to handles
				if(_clickHandle==1){
					relmovedy = 0;
					movedy = 0;
				}
				else if(_clickHandle==2){
					relmovedx = 0;
					movedx = 0;
				}
					
			//	CGFloat newAnchorx = startAnchor.x+movedx;
			//	CGFloat newAnchory = startAnchor.y+movedy;
			//	NSPoint anchorMoveAmount = NSMakePoint(newAnchorx, newAnchory);
				
				Graphic *graphicToMove = (Graphic *)_ownerOfAnchor.originalNodeProxy.originalNode;
               // [(id)_ownerOfAnchor setAnchorPt: [graphicToMove parentSpacePtToLocalSpace:anchorMoveAmount]];
			//	[(id)_ownerOfAnchor setAnchorPt: [graphicToMove parentSpacePtToLocalSpace:anchorMoveAmount]];
				
				[graphicToMove moveAnchorByWorldAmountX:relmovedx byY:relmovedy];
				
                if(altDrag){
                    NSAssert([graphicToMove isKindOfClass:[Graphic class]], @"must be a graphic if we selected it, no?");
                    [graphicToMove translateByX:relmovedx byY:relmovedy];
                }
                didMove = YES;
                    
                /* The drawing loop is suspened at the moment - updates wont be sent from scene to view! */
                // NSRect boundsOfAllSelected = [Graphic drawingBoundsOfGraphics:[view.starScene selectedItems]];
                // _dirtyRect = boundsOfAllSelected;
   // [view setNeedsDisplayInRect:NSMakeRect(0,0,800,800)];
                
                [[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];

			}
            lastPoint = curPoint;
        }
    }
	
	/* would really put this in mouse up */
	_ownerOfAnchor = nil;
}

#pragma mark Notification Methods
- (IBAction)selectToolAction:(id)sender {
    
	[super selectToolAction:sender];

    _selectedObjectsBounds = NSZeroRect;
	_displayBounds = NSZeroRect;
    
	// where is the view?
	CALayerStarView *view = _toolBarControl.targetView;
	NSAssert(view!=nil, @"not ready");
    
	[_toolBarControl addWidgetToView:self];
    
	// -- needs to observe selection	
	[view.starScene addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context: @"AnchorTool"];
    
	// -- cursor
}

- (void)toolWillBecomeUnActive {
	
	// where is the view?
	CALayerStarView *view = _toolBarControl.targetView;
	NSAssert(view!=nil, @"not ready");
    
	// -- remove observers
	[view.starScene removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];
	
	[view removeWidget:self];	
	_selectedObjectsBounds = NSZeroRect;
	_displayBounds = NSZeroRect;

    // -- cursor

	[super toolWillBecomeUnActive];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
    
    if( [context isEqualToString:@"AnchorTool"] )
	{
        if ([keyPath isEqualToString:@"currentFilteredContentSelectionIndexes"])
        {
			[self enforceConsistentState];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

#pragma mark Widget Protocol

/* This needs to be at minimum the bounds of the tool handles etc */
- (NSRect)displaybounds {
	
	// -- position of all anchors, offset by a couple
	return _displayBounds;
}

- (void)_drawAnchor:(SelectedItem *)each {

	NSPoint centrePoint = [each position];
	NSRect anchorRect = NSMakeRect(centrePoint.x-handleCentreSize/2.0, centrePoint.y-handleCentreSize/2.0, handleCentreSize, handleCentreSize);

	[[NSColor lightGrayColor] set];
	NSRectFill(anchorRect);
	
	if(each==_ownerOfAnchor){
		[[NSColor greenColor] set];
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path moveToPoint:NSMakePoint(centrePoint.x-handleSize, centrePoint.y)];
		[path lineToPoint:centrePoint];
		[path lineToPoint:NSMakePoint(centrePoint.x, centrePoint.y+handleSize)];
		[path stroke];
	}
	else
		[[NSColor blackColor] set];
	NSFrameRect( anchorRect );
}

- (void)drawInStarView:(CALayerStarView *)view {
	
	// -- draws dragging-axis handles
    if( !NSEqualRects(_selectedObjectsBounds, NSZeroRect )) 
	{
		NSArray *selectedItems = [view.starScene selectedItems];
		NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
		for( SelectedItem *each in moveAble )
        {
			[self _drawAnchor:each];
		}
	}
}


#pragma mark CALayer delegate methods
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	
	static CGFloat lengths[6] = { 12.0, 6.0, 5.0, 6.0, 5.0, 6.0 };
	
	CGContextSaveGState(ctx);
	CGContextTranslateCTM(ctx, -self.bounds.origin.x, -self.bounds.origin.y);
	
	// draw anchor pts
	CALayerStarView *view = _toolBarControl.targetView;
	NSArray *selGraphics = [view.starScene selectedItems];
	NSArray *movableSelectedItems = [StarScene justMovableItemsFrom:selGraphics];	
	for(SelectedItem *each in movableSelectedItems)
	{
#warning! need to be in world coords!
		NSPoint pos = [each position];
		CGContextBeginPath(ctx);
		CGContextAddRect(ctx, CGRectMake(pos.x-2.5f, pos.y-2.5f, 5.0f, 5.0f));
		
		//TODO: wrong colourspace
		CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
		CGContextDrawPath(ctx, kCGPathFill);
		
		// draw verticle handle
		CGContextBeginPath(ctx);
		CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
		CGContextMoveToPoint(ctx, pos.x, pos.y);
		CGContextAddLineToPoint(ctx, pos.x, pos.y+handleSize);
		CGContextDrawPath(ctx, kCGPathStroke);
		
		// draw horizontal handle
		CGContextBeginPath(ctx);
		CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
		CGContextMoveToPoint(ctx, pos.x,pos.y);
		CGContextAddLineToPoint(ctx, pos.x-handleSize, pos.y);
		CGContextDrawPath(ctx, kCGPathStroke);		
	}
	
	// draw centre rect
//	NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
//	CGContextBeginPath(ctx);
//	CGContextAddRect(ctx, CGRectMake(centrePoint.x-2.5f, centrePoint.y-2.5f, 5.0f, 5.0f));
//	CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
//	CGContextDrawPath(ctx, kCGPathFill);
		
	CGContextRestoreGState(ctx);
	
	// draw bounds
	CGRect bounds = CGContextGetClipBoundingBox(ctx); // This should be the clip rect
    CGContextBeginPath(ctx);
	CGContextAddRect(ctx, bounds);
    CGContextSetLineWidth(ctx, 1.0);
	CGContextSetLineDash(ctx, 0.0, lengths, 4);
	CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 0.0f, 1.0f);
	CGContextDrawPath(ctx, kCGPathStroke);
}

@end
