//
//  TranslateTool.m
//  DebugDrawing
//
//  Created by steve hooley on 24/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "TranslateTool.h"
#import "StarScene.h"
#import "AppControl.h"
#import "Graphic.h"
#import "SelectedItem.h"
#import "HitTestContext.h"
#import "ToolBarController.h"
#import "CALayerStarView.h"


static CGFloat handleSize = 100.0;
static CGFloat handleCentreSize = 8.0;


enum {
	Mode_noDrag = 0,
	Mode_fullDrag = 1,
	Mode_horizDrag = 2,
	Mode_vertDrag = 3,
};

enum {
	Zone_none = 0,
	Zone_centreRect = 1,
	Zone_horizHandle = 2,
	Zone_vertHandle = 3,
};


@implementation TranslateTool

#pragma mark Init Methods

+ (void)translateItems:(NSArray *)itemsToMove byX:(CGFloat)x byY:(CGFloat)y {

	for(SelectedItem *each in itemsToMove){
		Graphic *graphicToMove = (Graphic *)each.originalNodeProxy.originalNode;
		NSAssert([graphicToMove isKindOfClass:[Graphic class]], @"must be a graphic if we selected it, no?");
		[graphicToMove translateByX:x byY:y];
	}
}

- (id)initWithToolBarController:(ToolBarController *)value {

	self = [super initWithToolBarController:value];
	if(self){
		_identifier = @"SKTTranslateTool";
		_labelString = @"Translate";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"TranslateToolIcn"];
	}
	return self;
}

/* called after each graphic has been updated */
- (void)updateSelectedObjectBounds {
	
//september09	CALayerStarView *view = _toolBarControl.targetView;
	//[view setNeedsDisplayInRect:_displayBounds];

//june09	NSArray *selectedItems = [view.starScene selectedItems];
//june09	NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
	
	// get the bounds of the objecs we are going to drag
//june09	NSRect boundsOfAllSelected = [StarScene drawingBoundsOfGraphics:moveAble];
	// -- tool is dirty in old rect and new rect. the objects themselves have already notified the view
//june09	_selectedObjectsBounds = boundsOfAllSelected;
	
	// get the bounds of the anchor points we are going to drag
//june09	CGRect boundsOfAllAnchorPts = [Graphic enclosingRectOfAnchorPts:moveAble];
//june09	CGRect allDrawingArea = CGRectInset(boundsOfAllAnchorPts, -2.0f, -2.0f);
//june09	allDrawingArea = CGRectUnion(allDrawingArea, NSRectToCGRect(_selectedObjectsBounds));

//june09    CGFloat handleStrokeWidth = 10.0;
//june09	NSRect handleRect = NSMakeRect(NSMidX(boundsOfAllSelected)-handleSize, NSMidY(boundsOfAllSelected), handleSize+handleStrokeWidth, handleSize+handleStrokeWidth);
//june09	_displayBounds = NSInsetRect(NSUnionRect( handleRect, _selectedObjectsBounds ), -5, -5); // add a bit of a margin
//	[view setNeedsDisplayInRect:_displayBounds];
	
	// for calayer
//june09	allDrawingArea = CGRectUnion(allDrawingArea, NSRectToCGRect(_displayBounds));
//putback	self.bounds = allDrawingArea;
}

- (void)enforceConsistentState {
	[self updateSelectedObjectBounds];
}

/* Only call this from tracking */
- (NSInteger)handleUnderPoint:(NSPoint)apoint {
	
	NSInteger handleUnderPt = Zone_none;
//	CGFloat midx = NSMidX(_selectedObjectsBounds);
//	CGFloat midy = NSMidY(_selectedObjectsBounds);

	// Hit test Handles
//putback	self.hitTestCntxt = [HitTestContext hitTestContextAtPoint:apoint];

	// did we click within the centre rect?
	[self _drawCentreRect];
//putback	[_hitTestCntxt checkAndResetWithKey: @"centrehandle"];
//putback	if([_hitTestCntxt countOfHitObjects]>0)
//putback	{
//putback		handleUnderPt = Zone_centreRect;
//putback		goto home;
//putback	}

	// did we click on the verticle handle?
	[self _drawVerticalHandle];
//putback	[_hitTestCntxt checkAndResetWithKey: @"verthandle"];
//putback	if([_hitTestCntxt countOfHitObjects]>0)
//putback	{
//putback		handleUnderPt = Zone_vertHandle;
//putback		goto home;
//putback	}
	
	// did we click on the horizontal handle?
	[self _drawHorizantalHandle];
//putback	[_hitTestCntxt checkAndResetWithKey: @"horizhandle"];
//putback	if([_hitTestCntxt countOfHitObjects]>0)
//putback	{
//putback		handleUnderPt = Zone_horizHandle;
//putback		goto home;
//putback	}
	
//september09home:
//putback	[_hitTestCntxt cleanUpHitTesting];
//putback	self.hitTestCntxt = nil;
	return handleUnderPt;
}

- (void)mouseDownAtPoint:(NSPoint)pt event:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
    // Has the user clicked on a graphic?
	if( _mouseDownObject!=nil )
	{
		NSUInteger clickedGraphicIndex;
		BOOL clickedGraphicIsSelected, clickedGraphicIsMosveable;
	
//june09        NodeProxy *clickedGraphicProxy = [view.starScene.currentProxy nodeProxyForNode:_mouseDownObject];
 //june09       NSAssert(clickedGraphicProxy!=nil, @"eh?");
 //june09       [view.starScene infoForProxy:clickedGraphicProxy fromScene: index:&clickedGraphicIndex isSelected:&clickedGraphicIsSelected isMovable:&clickedGraphicIsMosveable];
 //june09       if(clickedGraphicIsSelected && clickedGraphicIsMosveable){
 //june09           _clickedOb = clickedGraphicProxy;
//june09        } else 
 //june09           _clickedOb = nil;
    }
}

- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
		
    // Has the user clicked on a graphic?
    NSPoint mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
	
	NSInteger clickedHandle = [self handleUnderPoint:mouseLocation];

	int mode = Mode_noDrag; // 0=dont drag, 1=fulldrag, 2=horizontalDrag, 3=verticleDrag
	if(clickedHandle==Zone_centreRect){
		mode = Mode_fullDrag;
	} else if(clickedHandle==Zone_vertHandle){
		mode = Mode_vertDrag;
	} else if(clickedHandle==Zone_horizHandle){
		mode = Mode_horizDrag;
	}

	/* If we didnt click on a specific handle but we did click on a draggable object do an unconstrained drag */
    if( _clickedOb!=nil && mode==Mode_noDrag) 
	{
		mode = Mode_fullDrag;
	}
	
	if(mode!=Mode_noDrag){

        // Is the graphic that the user has clicked on now selected?
//june09		NSArray *selGraphics = [view.starScene selectedItems];
//june09		if( [selGraphics count]>0 )
//june09		{
			// Yes. Let the user move all of the selected objects.
//june09			[self moveSelectedGraphicsWithEvent:event inMode:mode inStarView:view];

//june09		} else {
			// No. Just swallow mouse events until the user lets go of the mouse button. We don't even bother autoscrolling here.
//june09			while ([event type]!=NSLeftMouseUp)
//june09			{
//june09				NSLog(@"select tool In a crazy ass mouse loop");
//june09				event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//june09			}
//june09		}		
    } else {
		// The user clicked somewhere other than on a graphic.
	}
	_clickedOb = nil;
}

- (void)moveSelectedGraphicsWithEvent:(NSEvent *)event inMode:(int)mode inStarView:(CALayerStarView *)view {
    
    NSPoint lastPoint, curPoint;
	
	/* is there any way this might apply to edges and/or points as weel as entire shapes? */
    // NSUInteger c;
    BOOL didMove = NO, isMoving = NO;

    //   NSRect selBounds = [[SKTGraphic self] boundsOfGraphics:selGraphics];
    
    lastPoint = [view convertPoint:[event locationInWindow] fromView:nil];
    //    NSPoint selOriginOffset = NSMakePoint((lastPoint.x - selBounds.origin.x), (lastPoint.y - selBounds.origin.y));

	// -- swap all selected graphics for wireframe proxies
//	NSIndexSet *selectedIndexes = [view.starScene selectedItemIndexes];
//	NSMutableArray *sktSceneItems = [view.starScene selectedItems];
//	NSMutableArray *originalItems = [NSMutableArray array];
//	unsigned int currentIndex = [selectedIndexes firstIndex];
//	while( currentIndex!=NSNotFound )
//	{
//		id originalItem=[sktSceneItems objectAtIndex:currentIndex];
//		[originalItems addObject:originalItem];
		
/* Not sure about this decorator stuff at the moment		
		SKTDecorator_Wireframe *dec = [SKTDecorator_Wireframe decoratorForGraphic:originalItem];
		[sktSceneItems replaceObjectAtIndex:currentIndex withObject:dec];
*/
//		currentIndex = [selectedIndexes indexGreaterThanIndex: currentIndex];
//	}
	
//june09	NSArray *selGraphics = [view.starScene selectedItems];
//june09	NSArray *movableSelectedItems = [StarScene justMovableItemsFrom:selGraphics];
	// _movingGraphics = movableSelectedItems;
    // c = [selGraphics count];
	
//june09    while( [event type]!=NSLeftMouseUp ) 
//june09	{
 //june09       event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
 //june09       curPoint = [view convertPoint:[event locationInWindow] fromView:nil];
 //june09       if( !isMoving && ((fabs(curPoint.x - lastPoint.x) >= 2.0) || (fabs(curPoint.y - lastPoint.y) >= 2.0)) ) 
//june09		{
//june09            isMoving = YES;
			// _isHidingHandles = YES;
//june09        }
 //june09       if( isMoving ) 
//june09		{
 //june09           if( !NSEqualPoints(lastPoint, curPoint) )
//june09			{
//june09				if([movableSelectedItems count]){
//june09					CGFloat xAmount = (curPoint.x - lastPoint.x);
//june09					CGFloat yAmount = (curPoint.y - lastPoint.y);
//june09					if(mode==Mode_horizDrag)
//june09						yAmount=0;
//june09					else if(mode==Mode_vertDrag)
//june09						xAmount=0;
	
//june09					[TranslateTool translateItems:movableSelectedItems byX:xAmount byY:yAmount];
//june09					didMove = YES;
					
					/* The drawing loop is suspened at the moment - updates wont be sent from scene to view! */
					// NSRect boundsOfAllSelected = [Graphic drawingBoundsOfGraphics:[view.starScene selectedItems]];
					// _dirtyRect = boundsOfAllSelected;
					// [view setNeedsDisplayInRect:_marqueeSelectionBounds];
					
//june09					[[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];
//june09				}
//june09			}
 //june09           lastPoint = curPoint;
 //june09       }
 //june09   }
	
	// take out the moving proxies and put back our original items
/* again - crazy decorator shit
	[sktSceneItems replaceObjectsAtIndexes:selectedIndexes withObjects:originalItems];
*/
//    _movingGraphics = nil;

    if (isMoving) {
		//       _isHidingHandles = NO;
        
        if (didMove) {
            // Only if we really moved.
			/* here we must mark dirty for anything that moved - including any representation of the current tool =, etc. */
//hmmm			[view setNeedsDisplayInRect:[SKTGraphic drawingBoundsOfGraphics:selGraphics]];
			
        }
    }
}

#pragma mark Notification Methods
- (void)toolWillBecomeActive {

	
	_selectedObjectsBounds = NSZeroRect;
	_displayBounds = NSZeroRect;

	// where is the view?
//september09	CALayerStarView *view = _toolBarControl.targetView;
//september09	NSAssert(view!=nil, @"not ready");

//september09	[_toolBarControl addWidgetToView:self];

	// -- needs to observe selection	
//june09	[view.starScene addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial) context: @"TranslateTool"];
		
	// -- cursor
	[super toolWillBecomeActive];
}

- (void)toolWillBecomeUnActive {

	// where is the view?
//september09	CALayerStarView *view = _toolBarControl.targetView;
//september09	NSAssert(view!=nil, @"not ready");

	// -- remove observers
//june09	[view.starScene removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];

//september09	[view removeWidget:self];
//september09	_selectedObjectsBounds = NSZeroRect;
	// -- cursor

//september09	[super toolWillBecomeUnActive];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {

	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];

    if( [context isEqualToString:@"TranslateTool"] )
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
	return _displayBounds;
}

- (void)_drawCentreRect {
	
	[[NSColor greenColor] set];
	NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
	NSRectFill( NSMakeRect(centrePoint.x-handleCentreSize/2.0, centrePoint.y-handleCentreSize/2.0, handleCentreSize, handleCentreSize));
}

- (void)_drawVerticalHandle {

	NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:centrePoint];
	[path lineToPoint:NSMakePoint(centrePoint.x, centrePoint.y+handleSize)];
	[path stroke];
}

- (void)_drawHorizantalHandle {

	NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path moveToPoint:centrePoint];
	[path lineToPoint:NSMakePoint(centrePoint.x-handleSize, centrePoint.y)];
	[path stroke];
}

- (void)drawInStarView:(CALayerStarView *)value {
	
	// -- draws dragging-axis handles
    if( !NSEqualRects(_selectedObjectsBounds, NSZeroRect )) 
	{
		[self _drawCentreRect];
		[self _drawVerticalHandle];
		[self _drawHorizantalHandle];
	}
}

#pragma mark CALayer delegate methods
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	
	static CGFloat lengths[6] = { 12.0, 6.0, 5.0, 6.0, 5.0, 6.0 };

	CGContextSaveGState(ctx);
//putback	CGContextTranslateCTM(ctx, -self.bounds.origin.x, -self.bounds.origin.y);

	// draw anchor pts
//	CALayerStarView *view = _toolBarControl.targetView;
//june09	NSArray *selGraphics = [view.starScene selectedItems];
//june09	NSArray *movableSelectedItems = [StarScene justMovableItemsFrom:selGraphics];	
//june09	for(SelectedItem *each in movableSelectedItems)
//june09	{
//september09		#warning! need to be in world coords!
//june09		NSPoint pos = [each position];
//june09		CGContextBeginPath(ctx);
//june09		CGContextAddRect(ctx, CGRectMake(pos.x-2.5f, pos.y-2.5f, 5.0f, 5.0f));
//june09		CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
//june09		CGContextDrawPath(ctx, kCGPathFill);
//june09	}

	// draw centre rect
//june09	NSPoint centrePoint = NSMakePoint(NSMidX(_selectedObjectsBounds), NSMidY(_selectedObjectsBounds));
//june09	CGContextBeginPath(ctx);
//june09	CGContextAddRect(ctx, CGRectMake(centrePoint.x-2.5f, centrePoint.y-2.5f, 5.0f, 5.0f));
//june09	CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
//june09	CGContextDrawPath(ctx, kCGPathFill);

	// draw verticle handle
//june09	CGContextBeginPath(ctx);
//june09	CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
//june09	CGContextMoveToPoint(ctx,centrePoint.x,centrePoint.y);
//june09	CGContextAddLineToPoint(ctx,centrePoint.x, centrePoint.y+handleSize);
//june09	CGContextDrawPath(ctx, kCGPathStroke);
	
	// draw horizontal handle
//june09	CGContextBeginPath(ctx);
//june09	CGContextSetRGBFillColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
//june09	CGContextMoveToPoint(ctx,centrePoint.x,centrePoint.y);
//june09	CGContextAddLineToPoint(ctx,centrePoint.x-handleSize, centrePoint.y);
//june09	CGContextDrawPath(ctx, kCGPathStroke);
	
//june09	CGContextRestoreGState(ctx);

	// draw bounds
//june09	CGRect bounds = CGContextGetClipBoundingBox(ctx); // This should be the clip rect
 //june09   CGContextBeginPath(ctx);
//june09	CGContextAddRect(ctx, bounds);
//june09    CGContextSetLineWidth(ctx, 1.0);
//june09	CGContextSetLineDash(ctx, 0.0, lengths, 4);
//june09	CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 0.0f, 1.0f);
//june09	CGContextDrawPath(ctx, kCGPathStroke);
 }

@end
