//
//  EdgeMoveTool.m
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "EdgeMoveTool.h"
#import "SelectedItem.h"
#import "StarScene.h"
#import "AppControl.h"
#import "Graphic.h"
#import "HitTestContext.h"
#import "ToolBarController.h"

@implementation EdgeMoveTool

- (id)initWithToolBarController:(ToolBarController *)value {
	
	self = [super initWithToolBarController:value];
	if(self){
		_identifier = @"SKTEdgeMoveTool";
		_labelString = @"Edge";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"EdgeToolIcn"];
	}
	return self;
}

- (void)enforceConsistentState {

	CALayerStarView *view = _toolBarControl.targetView;
	if( !NSEqualRects(_displayBounds, NSZeroRect ))

//		[view setNeedsDisplayInRect:_displayBounds];
	
	if(_ownerOfEdgeToDraw!=nil){
		_displayBounds = [_ownerOfEdgeToDraw transformedGeometryRectBoundingBox];
//		[view setNeedsDisplayInRect:_displayBounds];
	} else {
		_displayBounds = NSZeroRect;
	}	
}

- (void)drawEdge:(int)edge of:(Graphic *)graphic {
	
	NSPoint ptArray[4];
	[graphic transformedGeometryRectPoints:ptArray];
	NSPoint endPt1, endPt2;
	
	switch(edge) {
		case SKTGraphicBottomEdge:
			endPt1 = ptArray[0];
			endPt2 = ptArray[1];
			break;
		case SKTGraphicRightEdge:
			endPt1 = ptArray[1];
			endPt2 = ptArray[2];
			break;
		case SKTGraphicTopEdge:
			endPt1 = ptArray[2];
			endPt2 = ptArray[3];
			break;
		case SKTGraphicLeftEdge:
			endPt1 = ptArray[3];
			endPt2 = ptArray[0];
			break;
		default:
			[NSException raise:@"Must draw a valid Edge!" format:@"!*!@%^*"];
	}
	[[NSColor greenColor] set];
	NSBezierPath *bottomEdgePath = [NSBezierPath bezierPath];
	[bottomEdgePath setLineWidth:2.0f];
	[bottomEdgePath moveToPoint:endPt1];
	[bottomEdgePath lineToPoint:endPt2];
	[bottomEdgePath stroke];
}

- (NodeProxy *)reverseDrawStars:(NSArray *)starProxies inView:(CALayerStarView *)starView handle:(NSInteger *)outHandle {
	
	SHNode *currentNode = starView.starScene.currentNodeGroup;
	NSAssert(currentNode!=nil, @"we can not be here and not have a current node");
	NodeProxy *np=nil;

	for(NodeProxy *eachStarProxy in [starProxies reverseObjectEnumerator])
	{
		Graphic *original = (Graphic *)eachStarProxy.originalNode;
		
		if([original respondsToSelector:@selector(drawWithHint:)])
		{
			[self drawEdge:SKTGraphicBottomEdge of:original];
			
			[_hitTestCntxt checkAndResetWithKey: @"BottomEdge"];
			if([_hitTestCntxt countOfHitObjects]>0)
			{
				*outHandle = SKTGraphicBottomEdge;
				np = eachStarProxy;
				break;
			}
			
			[self drawEdge:SKTGraphicRightEdge of:original];

			[_hitTestCntxt checkAndResetWithKey: @"RightEdge"];
			if([_hitTestCntxt countOfHitObjects]>0)
			{
				*outHandle = SKTGraphicRightEdge;
				np = eachStarProxy;
				break;
			}
			
			[self drawEdge:SKTGraphicTopEdge of:original];

			[_hitTestCntxt checkAndResetWithKey: @"TopEdge"];
			if([_hitTestCntxt countOfHitObjects]>0)
			{
				*outHandle = SKTGraphicTopEdge;
				np = eachStarProxy;
				break;
			}
			
			[self drawEdge:SKTGraphicLeftEdge of:original];

			[_hitTestCntxt checkAndResetWithKey: @"LeftEdge"];
			if([_hitTestCntxt countOfHitObjects]>0)
			{
				*outHandle = SKTGraphicLeftEdge;
				np = eachStarProxy;
				break;
			}
		}
	}
	return np;
}

- (NodeProxy *)edgeUnderPoint:(NSPoint)point inView:(CALayerStarView *)view handle:(NSInteger *)outHandle {

	//	-- get the current nodes
	//	-- draw the last one from the root
	//	-- draw the others in reverse order
	NodeProxy *np=nil;
	NSArray *selectedItems = [view.starScene selectedItems];
	NSArray *moveAble = [StarScene justMovableItemsFrom:selectedItems];
	if([moveAble count])
	{
		NSArray *drawingNodesBeforeCurredntNode = [StarScene drawableParentsOf:[moveAble lastObject]];
		if([drawingNodesBeforeCurredntNode count])
			NSAssert(NO, @"we have to do the right stuff! and setup the transforms for these items");
		np = [self reverseDrawStars:moveAble inView:view handle:outHandle];
	}
	return np;
}

- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {

    // Has the user clicked on a graphic?
    NSPoint mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
    NSInteger clickedGraphicHandle;
	
	/* Do a hit test on the edge - not sure how to consolidate all drawing code */
	self.hitTestCntxt = [HitTestContext hitTestContextAtPoint: mouseLocation];
		NodeProxy *clickedGraphic = [self edgeUnderPoint:mouseLocation inView:view handle:&clickedGraphicHandle];
	[_hitTestCntxt cleanUpHitTesting];
	self.hitTestCntxt = nil;

    if( clickedGraphic!=nil ) 
	{
		// Yes. Let the user move all of the selected objects.
		[self moveEdge:clickedGraphicHandle of:(SelectedItem *)clickedGraphic withEvent:event inStarView:view];
    }
}

- (void)moveEdge:(int)edge of:(SelectedItem *)item withEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
    
    NSPoint lastPoint, curPoint;

	/* is there any way this might apply to edges and/or points as well as entire shapes? */
    BOOL didMove = NO, isMoving = NO;

    lastPoint = [view convertPoint:[event locationInWindow] fromView:nil];
	
	_edgeToDraw = edge;
	_ownerOfEdgeToDraw = item;
	
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
				[(Graphic *)[(NodeProxy *)item originalNode] moveEdge:edge byX:(curPoint.x - lastPoint.x) byY:(curPoint.y - lastPoint.y)];
				didMove = YES;

				[[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];
			}
            lastPoint = curPoint;
        }
    }
	
	_edgeToDraw = SKTGraphicNoHandle;
	_ownerOfEdgeToDraw = nil;
}

#pragma mark Notification Methods
- (IBAction)selectToolAction:(id)sender {
	
	_displayBounds = NSZeroRect;
	
	[super selectToolAction:sender];

	// where is the view?
	CALayerStarView *view = _toolBarControl.targetView;
	NSAssert(view!=nil, @"not ready");
	[_toolBarControl addWidgetToView:self];
	// -- cursor
}

- (void)toolWillBecomeUnActive {
	
	// where is the view?
	CALayerStarView *view = _toolBarControl.targetView;
	NSAssert(view!=nil, @"not ready");

	[view removeWidget:self];
	_displayBounds = NSZeroRect;
	// -- cursor
	
	[super toolWillBecomeUnActive];
}

- (NSRect)displaybounds {
	return _displayBounds;
}

- (void)drawInStarView:(CALayerStarView *)value {
	
	if(_edgeToDraw!=SKTGraphicNoHandle)
	{
		NSAssert(_ownerOfEdgeToDraw!=nil, @"Must have an owner if we have an edge? no?");
		Graphic *original = (Graphic *)[(NodeProxy *)_ownerOfEdgeToDraw originalNode];
		[self drawEdge:_edgeToDraw of:original];
	}
}

@end
