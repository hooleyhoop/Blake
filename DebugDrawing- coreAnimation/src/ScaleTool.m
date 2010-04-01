//
//  ScaleTool.m
//  DebugDrawing
//
//  Created by steve hooley on 08/11/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ScaleTool.h"
#import "StarScene.h"
#import "AppControl.h"
#import "Graphic.h"
#import "SelectedItem.h"
#import "TranslateTool.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"


const static CGFloat handleSize = 100.0;
const static CGFloat handleCentreSize = 8.0;

@implementation ScaleTool

- (id)initWithToolBarController:(ToolBarController *)value {
	
	self = [super initWithToolBarController:value];
	if(self){
		_identifier = @"SKTScaleTool";
		_labelString = @"Scale";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"ScaleToolIcn"];
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
    
	// get the bounds of the anchor points we are going to drag
	CGRect boundsOfAllAnchorPts = [Graphic enclosingRectOfAnchorPts:moveAble];
	CGRect allDrawingArea = CGRectInset(boundsOfAllAnchorPts, -2.0f, -2.0f);
	allDrawingArea = CGRectUnion(allDrawingArea, NSRectToCGRect(_selectedObjectsBounds));
    
    CGFloat handleStrokeWidth = 10.0;
	NSRect handleRect = NSMakeRect(NSMidX(boundsOfAllSelected)-handleSize, NSMidY(boundsOfAllSelected), handleSize+handleStrokeWidth, handleSize+handleStrokeWidth);

    _displayBounds = NSInsetRect( NSUnionRect( handleRect, _selectedObjectsBounds ), -handleCentreSize, -handleCentreSize); // add a bit of a margin
//	[view setNeedsDisplayInRect:_displayBounds];
	
	// For CALayer    
	allDrawingArea = CGRectUnion(allDrawingArea, NSRectToCGRect(_displayBounds));
	self.bounds = allDrawingArea;
}

- (void)enforceConsistentState {
    [self updateSelectedObjectBounds];
}

- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
    
    NSPoint startPoint, lastPoint, curPoint;
    BOOL didMove = NO, isMoving = NO;
    
    startPoint = [view convertPoint:[event locationInWindow] fromView:nil];
    lastPoint=startPoint;

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
//                CGFloat relmovedy = curPoint.y - lastPoint.y;
//                CGFloat movedx = curPoint.x - startPoint.x;
//                CGFloat movedy = curPoint.y - startPoint.y;
     
				NSArray *selectedItems = [view.starScene selectedItems];
				NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
				for( SelectedItem *each in moveAble ){
					
					CGFloat scaleAmount = relmovedx/100.0;
	
					[each setScale:[each scale]+scaleAmount];
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

- (void)drawInStarView:(CALayerStarView *)view {
	
	// -- draws dragging-axis handles
    if( !NSEqualRects(_selectedObjectsBounds, NSZeroRect )) 
	{
		[[NSColor greenColor] set];

        NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
		NSRectFill( NSMakeRect(centrePoint.x-handleCentreSize/2.0, centrePoint.y-handleCentreSize/2.0, handleCentreSize, handleCentreSize));
        
        NSBezierPath *path = [NSBezierPath bezierPath];
		[path moveToPoint:NSMakePoint(centrePoint.x-handleSize, centrePoint.y)];
		[path lineToPoint:centrePoint];
		[path lineToPoint:NSMakePoint(centrePoint.x, centrePoint.y+handleSize)];
		[path stroke];
        
		NSArray *selectedItems = [view.starScene selectedItems];
		NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
		for( SelectedItem *each in moveAble ){
			centrePoint = [each position];
			NSRectFill( NSMakeRect(centrePoint.x-handleCentreSize/2.0, centrePoint.y-handleCentreSize/2.0, handleCentreSize, handleCentreSize));
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
	}
	
	// draw centre rect
	NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
	CGContextBeginPath(ctx);
	CGContextAddRect(ctx, CGRectMake(centrePoint.x-2.5f, centrePoint.y-2.5f, 5.0f, 5.0f));
	CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
	CGContextDrawPath(ctx, kCGPathFill);
	
	// draw verticle handle
	CGContextBeginPath(ctx);
	CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
	CGContextMoveToPoint(ctx,centrePoint.x,centrePoint.y);
	CGContextAddLineToPoint(ctx,centrePoint.x, centrePoint.y+handleSize);
	CGContextDrawPath(ctx, kCGPathStroke);
	
	// draw horizontal handle
	CGContextBeginPath(ctx);
	CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
	CGContextMoveToPoint(ctx,centrePoint.x,centrePoint.y);
	CGContextAddLineToPoint(ctx,centrePoint.x-handleSize, centrePoint.y);
	CGContextDrawPath(ctx, kCGPathStroke);
	
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
